Demo video of build

Notes:
- remote builder ptolemy is set to maxJobs = 6
- Local builder maxJobs = "auto" (4 threads)
- More than 6 of the REMOTE derivations get pushed to ptolemy at once, in fact it seems like all derivations that don't have `preferLocalBuild` set get pushed.
- The LOCAL derivations don't seem to start until all the remote ones are finished, even though none of the derivations should depend on each other

https://github.com/user-attachments/assets/acb10674-0ec6-4c00-a63e-083eeb55367a

