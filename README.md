Demo video of build

Notes:
- remote builder ptolemy is set to maxJobs = 6
- Local builder max-jobs = "auto" (4 threads)
- More than 6 of the REMOTE derivations get pushed to ptolemy at once, in fact it seems like all derivations that don't have `preferLocalBuild` set get pushed.
  - If the `preferLocalBuild` override is commented out, all builds are pushed to the remote builder
  - If `preferLocalBuild` is ONLY set on the final `parallel` derivation, all the builds are still pushed out even though it would make sense to build all dependents locally to avoid network transfers.
- The LOCAL derivations don't seem to start until all the remote ones are finished, even though none of the derivations should depend on each other

https://github.com/user-attachments/assets/acb10674-0ec6-4c00-a63e-083eeb55367a

EDIT 2026-05-12
Tried switching to lix stable (2.94.1) and it seems to have slightly different behavior:
- remote builder maxJobs seems to be respected (only up to 6 jobs are sent at once)
- My local nix.conf max-jobs no longer seems to be respected, seems like all the LOCAL derivations get started as soon as possible
- All derivations that don't have `preferLocalBuild=true` still get pushed
  - Lix seems to wait for the full send->build->download cycle to complete before sending new jobs, so the build is actually significantly slower if `preferLocalBuild` is disabled on all packages (all packages sent to remote)
  - Same behavior as above if `preferLocalBuild` is set on the final `parallel` derivation (albeit build takes way longer due to lix respecting maxJobs and waiting)
  - The LOCAL derivations start alongside the REMOTE ones, although since they all start at once it seems like it chokes system performance leading to slower transfers to the remote (unable to send a full 6 jobs at a time)
 


https://github.com/user-attachments/assets/ac675288-39ef-460e-b077-9da4bf170204


