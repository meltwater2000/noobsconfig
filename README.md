NOOBSConfig
===========

###Introduction###
This repository contains files to customise the installation of a standard NOOBS installation.

After the standard boot and root images have been installed to the SD card, it allows a custom tarball to be copied, decompressed and extracted onto each partition for each distro/partition/flavour that exists in the appropriate OS folder to apply user customisations.

###What can it be used for?###
This method is for simple customisations of a distro. It behaves a bit like applying a patch file to the distro after it has been installed.
As such it can replace or add files to the distro, but not delete existing files.
Some examples of its use are therefore:
* setting up wifi so that it works "out of the box" (maybe useful for schools etc)
* installing script files to install other packages (either manually or on first boot - like raspi-config)
* provide standard configurations for config.txt (instead of requiring raspi-config to be executed on first execution)

###Benefits###
* ideal for small customisations
* does not require the creation of a full customised OS
* independent of NOOBS distributions
* Simple to apply to the standard NOOBS download
* the same customisations can be quickly and easily applied to a subsequent update of the NOOBS download

###What it doesn't do###
Currently it does not execute user-defined scripts, it simply copies/replaces existing files.
Whilst it could be used to copy entire packages onto the distro, this use is not recommended and it is suggested to follow the existing instructions to create a customised OS if the modifications are extensive.

###Rationale###
I like to use the latest version of NOOBS whenever it is released, ensuring I get all the latest updates and distro versions.
However, whenever I update to a new version, or reinstall a distro from NOOBS, I end up having to apply the same customisations and installations over and over again.
I've now learnt to create scripts for these common operations and a custom tarball that I can use to overwrite files like `/etc/network/interfaces` etc.
But it's still an extra step to perform after NOOBS has finished. So I thought about how this could be applied automatically.

From a simple beginning of modifying `partition_setup.sh` to copy and extract a tarball of files onto the installed Raspbian distro, this has now been extended to work with all of the supplied distros and includes support for different flavours aswell.

The ability to patch using a flavour would be ideal for schools and others, it would save building full custom images and avoids them having to redo it for every release of Raspbian. It would also allow Zero-config setups, for instance you'd be able to configure NOOBS to auto-install a distro which has direct networking enabled out of the box via a small app perhaps.
 
##How to use noobsconfig##
1. Copy `customise.sh` to the root directory of the NOOBS recovery partition.
2. For each OS that you want to customise, add the following line near the end of its `partition_setup.sh`
        `if [ -e /mnt/customise.sh ]; then . /mnt/customise.sh; fi`
   If the `partition_setup.sh` file does not exist, then one can be created.
   Example `partition_setup.sh` files can be found on this repository for the provided distros
3. Create a tarball (optionally compressed) of all the files that you want copied to the distro after the standard installation and store it in the corresponding OS folder.
Tarballs must have a specific name of the format `<flavour>_<partitionName>.tar(.xz)`
Note that `<flavour>` and `<partitionName>` must exactly match (in characters and case) the names provided in the `*.json` files that describe each OS in order for them to be recognised.
4. Install a distro from NOOBS as usual.

###How to Create a Tarball###

1. Firstly you need to start from a working installation of the distro. I suggest you use NOOBS to install the distro first.
2. Modify any existing, or create any new files that you want to be included in your customisation.
3. For manageability I suggest creating a simple text file that contains a list of all the new/modified files, with one fullpathname on each line.
For example:
<pre>
$>sudo nano files.txt<br>
/etc/network/interfaces
/etc/init.d/rc.local
</pre>

4. Now create the tar ball using this text file as input:
<pre>
$>sudo tar cvf &lt;flavour&gt;_&lt;partitionName&gt;.tar -T files.txt
$>sudo xz &lt;flavour&gt;_&lt;partitionName&gt;.tar
</pre>
