# envMod
Simple development environment switching tool

## WARNING
This is **NOT** secure. In fact, for development ease, this is made to be *easy to break out of.* 

## Use
envMod was made for development of several programs at a time on one machine without any of the hassle of switching folders and making programs cooperate.\
You can run the `install.lua` script included to install easily.\
\
To enter a folder and make it root, run `envMod [path]`.\
When you are finished, exit by running `fs.unsetEnvironment()`. This is easiest done in the lua prompt.\
\
envMod will save environment state on reboot! Even upon reboot, your environment will stay the same. You will not need to re-enter the `envMod` command. **This requires that you have installed the `startup.lua` script included or added it to the top of your own.**

## Bugs
I have done some minimal testing and there is only one known bug: `cd ..` can *seem* to put you outside of the environment. However, this is only caused because I can't figure out how to get the shell to not update its path. It won't actually escape. Found more bugs? Open an issue or DM SpSf (swoshswosh_01578). Bugs will be fixed. Probably™.
