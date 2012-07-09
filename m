Return-path: <linux-media-owner@vger.kernel.org>
Received: from yoda.london.02.net ([82.132.130.151]:58502 "EHLO mail.o2.co.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751857Ab2GIKUn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2012 06:20:43 -0400
Received: from MailServer1.merlin.local (94.195.39.92) by mail.o2.co.uk (8.5.119.05) (authenticated as joenyland)
        id 4EEB65B0204712A0 for linux-media@vger.kernel.org; Mon, 9 Jul 2012 11:12:00 +0100
Received: from localhost (localhost [127.0.0.1])
	by MailServer1.merlin.local (Postfix) with ESMTP id 9B3F0A0FB4
	for <linux-media@vger.kernel.org>; Mon,  9 Jul 2012 11:11:59 +0100 (BST)
Received: from MailServer1.merlin.local ([127.0.0.1])
	by localhost (MailServer1.merlin.local [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id S16h9OgE6c+r for <linux-media@vger.kernel.org>;
	Mon,  9 Jul 2012 11:11:59 +0100 (BST)
Received: from MailServer1.merlin.local (localhost [127.0.0.1])
	by MailServer1.merlin.local (Postfix) with ESMTP id 57A52A0EE4
	for <linux-media@vger.kernel.org>; Mon,  9 Jul 2012 11:11:59 +0100 (BST)
Subject: Unable to build V4L drivers on Ubuntu 10.04.4 2.6.32-41-server x86_64
From: =?utf-8?Q?Joe_Nyland?= <joe@joenyland.co.uk>
To: =?utf-8?Q?linux-media=40vger=2Ekernel=2Eorg?=
	<linux-media@vger.kernel.org>
Date: Mon, 9 Jul 2012 11:11:59 +0100
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-Id: <zarafa.4ffaae6f.254c.278ade6a4ad07a11@MailServer1.merlin.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Fairly new user to the list here, but been using V4L with MythTV 0.25 for a few months now.

I tried to build the V4L drivers for Ubuntu Server 10.04.4 2.6.32-41-server x86_64 yesterday on a new system, however the build fails when applying the patches. I've previously been able to build the drivers successfully on other servers running Ubuntu 10.04.4 x86_64, but I'm not sure they were the same kernel version as this install.

Here's the full log from my terminal when I tried to build:

joe@FileServer1:~$ git clone git://linuxtv.org/media_build.git
Initialized empty Git repository in /home/joe/media_build/.git/
remote: Counting objects: 1397, done.
remote: Compressing objects: 100% (463/463), done.
remote: Total 1397 (delta 905), reused 1377 (delta 895)
Receiving objects: 100% (1397/1397), 338.38 KiB | 276 KiB/s, done.
Resolving deltas: 100% (905/905), done.

joe@FileServer1:~$ cd media_build/

joe@FileServer1:~/media_build$ ./build
Checking if the needed tools for Ubuntu 10.04.4 LTS are available
Needed package dependencies are met.

************************************************************
* This script will download the latest tarball and build it*
* Assuming that your kernel is compatible with the latest  *
* drivers. If not, you'll need to add some extra backports,*
* ./backports/<kernel> directory.                          *
* It will also update this tree to be sure that all compat *
* bits are there, to avoid compilation failures            *
************************************************************
************************************************************
* All drivers and build system are under GPLv2 License     *
* Firmware files are under the license terms found at:     *
* http://www.linuxtv.org/downloads/firmware/               *
* Please abort if you don't agree with the license         *
************************************************************

****************************
Updating the building system
****************************
>From git://linuxtv.org/media_build
 * branch            master     -> FETCH_HEAD
Already up-to-date.
make: Entering directory `/home/joe/media_build/linux'
wget http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2.md5 -O linux-media.tar.bz2.md5.tmp
--2012-07-09 10:59:34--  http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2.md5
Resolving linuxtv.org... 130.149.80.248
Connecting to linuxtv.org|130.149.80.248|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 93 [application/x-bzip2]
Saving to: `linux-media.tar.bz2.md5.tmp'

100%[==============================================================================>] 93          --.-K/s   in 0s

2012-07-09 10:59:34 (21.5 MB/s) - `linux-media.tar.bz2.md5.tmp' saved [93/93]

cat: linux-media.tar.bz2.md5: No such file or directory
--2012-07-09 10:59:34--  http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2
Resolving linuxtv.org... 130.149.80.248
Connecting to linuxtv.org|130.149.80.248|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 4383385 (4.2M) [application/x-bzip2]
Saving to: `linux-media.tar.bz2'

100%[==============================================================================>] 4,383,385    383K/s   in 12s

2012-07-09 10:59:46 (367 KB/s) - `linux-media.tar.bz2' saved [4383385/4383385]

make: Leaving directory `/home/joe/media_build/linux'
make: Entering directory `/home/joe/media_build/linux'
tar xfj linux-media.tar.bz2
rm -f .patches_applied .linked_dir .git_log.md5
make: Leaving directory `/home/joe/media_build/linux'
**********************************************************
* Downloading firmwares from linuxtv.org.                *
**********************************************************
--2012-07-09 10:59:47--  http://www.linuxtv.org/downloads/firmware//dvb-firmwares.tar.bz2
Resolving www.linuxtv.org... 130.149.80.248
Connecting to www.linuxtv.org|130.149.80.248|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 649441 (634K) [application/x-bzip2]
Saving to: `dvb-firmwares.tar.bz2'

100%[==============================================================================>] 649,441      370K/s   in 1.7s

2012-07-09 10:59:49 (370 KB/s) - `dvb-firmwares.tar.bz2' saved [649441/649441]

tar: Record size = 8 blocks
dvb-fe-bcm3510-01.fw
dvb-fe-or51132-qam.fw
dvb-fe-or51132-vsb.fw
dvb-fe-or51211.fw
dvb-fe-xc5000-1.6.114.fw
dvb-ttpci-01.fw-261a
dvb-ttpci-01.fw-261b
dvb-ttpci-01.fw-261c
dvb-ttpci-01.fw-261d
dvb-ttpci-01.fw-261f
dvb-ttpci-01.fw-2622
dvb-usb-avertv-a800-02.fw
dvb-usb-bluebird-01.fw
dvb-usb-dib0700-1.20.fw
dvb-usb-dibusb-5.0.0.11.fw
dvb-usb-dibusb-6.0.0.8.fw
dvb-usb-dtt200u-01.fw
dvb-usb-terratec-h5-drxk.fw
dvb-usb-terratec-h7-az6007.fw
dvb-usb-terratec-h7-drxk.fw
dvb-usb-umt-010-02.fw
dvb-usb-vp702x-01.fw
dvb-usb-vp7045-01.fw
dvb-usb-wt220u-01.fw
dvb-usb-wt220u-02.fw
v4l-cx231xx-avcore-01.fw
v4l-cx23418-apu.fw
v4l-cx23418-cpu.fw
v4l-cx23418-dig.fw
v4l-cx23885-avcore-01.fw
v4l-cx23885-enc.fw
v4l-cx25840.fw
******************
* Start building *
******************
make -C /home/joe/media_build/v4l allyesconfig
make[1]: Entering directory `/home/joe/media_build/v4l'
No version yet, using 2.6.32-41-server
make[1]: Leaving directory `/home/joe/media_build/v4l'
make[1]: Entering directory `/home/joe/media_build/v4l'
make[2]: Entering directory `/home/joe/media_build/linux'
Applying patches for kernel 2.6.32-41-server
patch -s -f -N -p1 -i ../backports/api_version.patch
1 out of 1 hunk FAILED -- saving rejects to file drivers/media/video/v4l2-ioctl.c.rej
make[2]: *** [apply_patches] Error 1
make[2]: Leaving directory `/home/joe/media_build/linux'
make[1]: *** [allyesconfig] Error 2
make[1]: Leaving directory `/home/joe/media_build/v4l'
make: *** [allyesconfig] Error 2
can't select all drivers at ./build line 451.

joe@FileServer1:~/media_build$ ./build --verbose
Checking if the needed tools for Ubuntu 10.04.4 LTS are available
Needed package dependencies are met.

************************************************************
* This script will download the latest tarball and build it*
* Assuming that your kernel is compatible with the latest  *
* drivers. If not, you'll need to add some extra backports,*
* ./backports/<kernel> directory.                          *
* It will also update this tree to be sure that all compat *
* bits are there, to avoid compilation failures            *
************************************************************
************************************************************
* All drivers and build system are under GPLv2 License     *
* Firmware files are under the license terms found at:     *
* http://www.linuxtv.org/downloads/firmware/               *
* Please abort if you don't agree with the license         *
************************************************************

****************************
Updating the building system
****************************
>From git://linuxtv.org/media_build
 * branch            master     -> FETCH_HEAD
Already up-to-date.
make: Entering directory `/home/joe/media_build/linux'
wget http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2.md5 -O linux-media.tar.bz2.md5.tmp
--2012-07-09 11:04:14--  http://linuxtv.org/downloads/drivers/linux-media-LATEST.tar.bz2.md5
Resolving linuxtv.org... 130.149.80.248
Connecting to linuxtv.org|130.149.80.248|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 93 [application/x-bzip2]
Saving to: `linux-media.tar.bz2.md5.tmp'

100%[==============================================================================>] 93          --.-K/s   in 0s

2012-07-09 11:04:14 (24.5 MB/s) - `linux-media.tar.bz2.md5.tmp' saved [93/93]

make: Leaving directory `/home/joe/media_build/linux'
make: Entering directory `/home/joe/media_build/linux'
tar xfj linux-media.tar.bz2
rm -f .patches_applied .linked_dir .git_log.md5
make: Leaving directory `/home/joe/media_build/linux'
**********************************************************
* Downloading firmwares from linuxtv.org.                *
**********************************************************
tar: Record size = 8 blocks
dvb-fe-bcm3510-01.fw
dvb-fe-or51132-qam.fw
dvb-fe-or51132-vsb.fw
dvb-fe-or51211.fw
dvb-fe-xc5000-1.6.114.fw
dvb-ttpci-01.fw-261a
dvb-ttpci-01.fw-261b
dvb-ttpci-01.fw-261c
dvb-ttpci-01.fw-261d
dvb-ttpci-01.fw-261f
dvb-ttpci-01.fw-2622
dvb-usb-avertv-a800-02.fw
dvb-usb-bluebird-01.fw
dvb-usb-dib0700-1.20.fw
dvb-usb-dibusb-5.0.0.11.fw
dvb-usb-dibusb-6.0.0.8.fw
dvb-usb-dtt200u-01.fw
dvb-usb-terratec-h5-drxk.fw
dvb-usb-terratec-h7-az6007.fw
dvb-usb-terratec-h7-drxk.fw
dvb-usb-umt-010-02.fw
dvb-usb-vp702x-01.fw
dvb-usb-vp7045-01.fw
dvb-usb-wt220u-01.fw
dvb-usb-wt220u-02.fw
v4l-cx231xx-avcore-01.fw
v4l-cx23418-apu.fw
v4l-cx23418-cpu.fw
v4l-cx23418-dig.fw
v4l-cx23885-avcore-01.fw
v4l-cx23885-enc.fw
v4l-cx25840.fw
******************
* Start building *
******************
make -C /home/joe/media_build/v4l allyesconfig
make[1]: Entering directory `/home/joe/media_build/v4l'
make[2]: Entering directory `/home/joe/media_build/linux'
Applying patches for kernel 2.6.32-41-server
patch -s -f -N -p1 -i ../backports/api_version.patch
1 out of 1 hunk FAILED -- saving rejects to file drivers/media/video/v4l2-ioctl.c.rej
make[2]: *** [apply_patches] Error 1
make[2]: Leaving directory `/home/joe/media_build/linux'
make[1]: *** [allyesconfig] Error 2
make[1]: Leaving directory `/home/joe/media_build/v4l'
make: *** [allyesconfig] Error 2
can't select all drivers at ./build line 451.
joe@FileServer1:~/media_build$

Whilst the script says "saving rejects to file drivers/media/video/v4l2-ioctl.c.rej" this file does not exist:

joe@FileServer1:~/media_build$ cat linux/drivers/media/video/v4l2-ioctl.c.rej
cat: linux/drivers/media/video/v4l2-ioctl.c.rej: No such file or directory

However, applying the patch manually:

joe@FileServer1:~/media_build$ cd linux/
joe@FileServer1:~/media_build/linux$ patch -s -f -N -p1 -i ../backports/api_version.patch
1 out of 1 hunk FAILED -- saving rejects to file drivers/media/video/v4l2-ioctl.c.rej
joe@FileServer1:~/media_build/linux$ cat drivers/media/video/v4l2-ioctl.c.rej
--- drivers/media/video/v4l2-ioctl.c
+++ drivers/media/video/v4l2-ioctl.c
@@ -609 +609 @@
-               cap->version = LINUX_VERSION_CODE;
+               cap->version = V4L2_VERSION;

Any ideas how I can get this to build please?

Thanks,

Joe
