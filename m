Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:39097 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755997AbaLWMZ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 07:25:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/4] Documentation/video4linux: remove obsolete text files
Date: Tue, 23 Dec 2014 13:24:57 +0100
Message-Id: <1419337497-7231-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1419337497-7231-1-git-send-email-hverkuil@xs4all.nl>
References: <1419337497-7231-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Remove obsolete text files for drivers that have been removed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/CQcam.txt      | 205 -------------------------------
 Documentation/video4linux/README.tlg2300 |  47 -------
 Documentation/video4linux/w9966.txt      |  33 -----
 3 files changed, 285 deletions(-)
 delete mode 100644 Documentation/video4linux/CQcam.txt
 delete mode 100644 Documentation/video4linux/README.tlg2300
 delete mode 100644 Documentation/video4linux/w9966.txt

diff --git a/Documentation/video4linux/CQcam.txt b/Documentation/video4linux/CQcam.txt
deleted file mode 100644
index 0b69e4e..0000000
--- a/Documentation/video4linux/CQcam.txt
+++ /dev/null
@@ -1,205 +0,0 @@
-c-qcam - Connectix Color QuickCam video4linux kernel driver
-
-Copyright (C) 1999  Dave Forrest  <drf5n@virginia.edu>
-		    released under GNU GPL.
-
-1999-12-08 Dave Forrest, written with kernel version 2.2.12 in mind
-
-
-Table of Contents
-
-1.0 Introduction
-2.0 Compilation, Installation, and Configuration
-3.0 Troubleshooting
-4.0 Future Work / current work arounds
-9.0 Sample Program, v4lgrab
-10.0 Other Information
-
-
-1.0 Introduction
-
-  The file ../../drivers/media/parport/c-qcam.c is a device driver for
-the Logitech (nee Connectix) parallel port interface color CCD camera.
-This is a fairly inexpensive device for capturing images.  Logitech
-does not currently provide information for developers, but many people
-have engineered several solutions for non-Microsoft use of the Color
-Quickcam.
-
-1.1 Motivation
-
-  I spent a number of hours trying to get my camera to work, and I
-hope this document saves you some time.  My camera will not work with
-the 2.2.13 kernel as distributed, but with a few patches to the
-module, I was able to grab some frames. See 4.0, Future Work.
-
-
-
-2.0 Compilation, Installation, and Configuration
-
-  The c-qcam depends on parallel port support, video4linux, and the
-Color Quickcam.  It is also nice to have the parallel port readback
-support enabled. I enabled these as modules during the kernel
-configuration.  The appropriate flags are:
-
-    CONFIG_PRINTER       M    for lp.o, parport.o parport_pc.o modules
-    CONFIG_PNP_PARPORT   M for autoprobe.o IEEE1284 readback module
-    CONFIG_PRINTER_READBACK M for parport_probe.o IEEE1284 readback module
-    CONFIG_VIDEO_DEV     M    for videodev.o video4linux module
-    CONFIG_VIDEO_CQCAM   M    for c-qcam.o  Color Quickcam module
-
-  With these flags, the kernel should compile and install the modules.
-To record and monitor the compilation, I use:
-
- (make zlilo ; \
-  make modules; \
-  make modules_install ;
-  depmod -a ) &>log &
- less log  # then a capital 'F' to watch the progress
-
-But that is my personal preference.
-
-2.2 Configuration
-
-  The configuration requires module configuration and device
-configuration.  The following sections detail these procedures.
-
-
-2.1 Module Configuration
-
-  Using modules requires a bit of work to install and pass the
-parameters.  Understand that entries in /etc/modprobe.d/*.conf of:
-
-   alias parport_lowlevel parport_pc
-   options parport_pc io=0x378 irq=none
-   alias char-major-81 videodev
-   alias char-major-81-0 c-qcam
-
-2.2 Device Configuration
-
-  At this point, we need to ensure that the device files exist.
-Video4linux used the /dev/video* files, and we want to attach the
-Quickcam to one of these.
-
-   ls -lad /dev/video*  # should produce a list of the video devices
-
-If the video devices do not exist, you can create them with:
-
-  su
-  cd /dev
-  for ii in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 ; do
-    mknod video$ii c 81 $ii   # char-major-81-[0-16]
-    chown root.root video$ii  # owned by root
-    chmod 600 video$ii        # read/writable by root only
-  done
-
-  Lots of people connect video0 to video and bttv, but you might want
-your c-qcam to mean something more:
-
-   ln -s video0 c-qcam  # make /dev/c-qcam a working file
-   ln -s c-qcam video   # make /dev/c-qcam your default video source
-
-  But these are conveniences.  The important part is to make the proper
-special character files with the right major and minor numbers.  All
-of the special device files are listed in ../devices.txt.  If you
-would like the c-qcam readable by non-root users, you will need to
-change the permissions.
-
-3.0 Troubleshooting
-
-  If the sample program below, v4lgrab, gives you output then
-everything is working.
-
-    v4lgrab | wc # should give you a count of characters
-
-  Otherwise, you have some problem.
-
-  The c-qcam is IEEE1284 compatible, so if you are using the proc file
-system (CONFIG_PROC_FS), the parallel printer support
-(CONFIG_PRINTER), the IEEE 1284 system,(CONFIG_PRINTER_READBACK), you
-should be able to read some identification from your quickcam with
-
-	 modprobe -v parport
-	 modprobe -v parport_probe
-	 cat /proc/parport/PORTNUMBER/autoprobe
-Returns:
-  CLASS:MEDIA;
-  MODEL:Color QuickCam 2.0;
-  MANUFACTURER:Connectix;
-
-  A good response to this indicates that your color quickcam is alive
-and well.  A common problem is that the current driver does not
-reliably detect a c-qcam, even though one is attached.  In this case,
-
-     modprobe -v c-qcam
-or
-     insmod -v c-qcam
-
-  Returns a message saying "Device or resource busy"  Development is
-currently underway, but a workaround is to patch the module to skip
-the detection code and attach to a defined port.  Check the
-video4linux mailing list and archive for more current information.
-
-3.1 Checklist:
-
-  Can you get an image?
-	    v4lgrab >qcam.ppm ; wc qcam.ppm ; xv qcam.ppm
-
-  Is a working c-qcam connected to the port?
-	    grep ^ /proc/parport/?/autoprobe
-
-  Do the /dev/video* files exist?
-	    ls -lad /dev/video
-
-  Is the c-qcam module loaded?
-	    modprobe -v c-qcam ; lsmod
-
-  Does the camera work with alternate programs? cqcam, etc?
-
-
-
-
-4.0 Future Work / current workarounds
-
-  It is hoped that this section will soon become obsolete, but if it
-isn't, you might try patching the c-qcam module to add a parport=xxx
-option as in the bw-qcam module so you can specify the parallel port:
-
-       insmod -v c-qcam parport=0
-
-And bypass the detection code, see ../../drivers/char/c-qcam.c and
-look for the 'qc_detect' code and call.
-
-  Note that there is work in progress to change the video4linux API,
-this work is documented at the video4linux2 site listed below.
-
-
-9.0 --- A sample program using v4lgrabber,
-
-v4lgrab is a simple image grabber that will copy a frame from the
-first video device, /dev/video0 to standard output in portable pixmap
-format (.ppm)  To produce .jpg output, you can use it like this:
-'v4lgrab | convert - c-qcam.jpg'
-
-
-10.0 --- Other Information
-
-Use the ../../Maintainers file, particularly the  VIDEO FOR LINUX and PARALLEL
-PORT SUPPORT sections
-
-The video4linux page:
-  http://linuxtv.org
-
-The V4L2 API spec:
-  http://v4l2spec.bytesex.org/
-
-Some web pages about the quickcams:
-   http://www.pingouin-land.com/howto/QuickCam-HOWTO.html
-
-   http://www.crynwr.com/qcpc/            QuickCam Third-Party Drivers
-   http://www.crynwr.com/qcpc/re.html     Some Reverse Engineering
-   http://www.wirelesscouch.net/software/gqcam/   v4l client
-   http://phobos.illtel.denver.co.us/pub/qcread/ doesn't use v4l
-   ftp://ftp.cs.unm.edu/pub/chris/quickcam/   Has lots of drivers
-   http://www.cs.duke.edu/~reynolds/quickcam/ Has lots of information
-
-
diff --git a/Documentation/video4linux/README.tlg2300 b/Documentation/video4linux/README.tlg2300
deleted file mode 100644
index 416ccb9..0000000
--- a/Documentation/video4linux/README.tlg2300
+++ /dev/null
@@ -1,47 +0,0 @@
-tlg2300 release notes
-====================
-
-This is a v4l2/dvb device driver for the tlg2300 chip.
-
-
-current status
-==============
-
-video
-	- support mmap and read().(no overlay)
-
-audio
-	- The driver will register a ALSA card for the audio input.
-
-vbi
-	- Works for almost TV norms.
-
-dvb-t
-	- works for DVB-T
-
-FM
-	- Works for radio.
-
----------------------------------------------------------------------------
-TESTED APPLICATIONS:
-
--VLC1.0.4 test the video and dvb. The GUI is friendly to use.
-
--Mplayer test the video.
-
--Mplayer test the FM. The mplayer should be compiled with --enable-radio and
-	 --enable-radio-capture.
-	The command runs as this(The alsa audio registers to card 1):
-	#mplayer radio://103.7/capture/ -radio adevice=hw=1,0:arate=48000 \
-		-rawaudio rate=48000:channels=2
-
----------------------------------------------------------------------------
-KNOWN PROBLEMS:
-about preemphasis:
-	You can set the preemphasis for radio by the following command:
-	#v4l2-ctl -d /dev/radio0 --set-ctrl=pre_emphasis_settings=1
-
-	"pre_emphasis_settings=1" means that you select the 50us. If you want
-	to select the 75us, please use "pre_emphasis_settings=2"
-
-
diff --git a/Documentation/video4linux/w9966.txt b/Documentation/video4linux/w9966.txt
deleted file mode 100644
index 8550245..0000000
--- a/Documentation/video4linux/w9966.txt
+++ /dev/null
@@ -1,33 +0,0 @@
-W9966 Camera driver, written by Jakob Kemi (jakob.kemi@telia.com)
-
-After a lot of work in softice & wdasm, reading .pdf-files and tiresome
-trial-and-error work I've finally got everything to work. I needed vision for a
-robotics project so I borrowed this camera from a friend and started hacking.
-Anyway I've converted my original code from the AVR 8bit RISC C/ASM code into
-a working Linux driver.
-
-To get it working simply configure your kernel to support
-parport, ieee1284, video4linux and w9966
-
-If w9966 is statically linked it will always perform aggressive probing for
-the camera. If built as a module you'll have more configuration options.
-
-Options:
- modprobe w9966.o pardev=parport0(or whatever) parmode=0 (0=auto, 1=ecp, 2=epp)
-voila!
-
-you can also type 'modinfo -p w9966.o' for option usage
-(or checkout w9966.c)
-
-The only thing to keep in mind is that the image format is in Y-U-Y-V format
-where every two pixels take 4 bytes. In SDL (www.libsdl.org) this format
-is called VIDEO_PALETTE_YUV422 (16 bpp).
-
-A minimal test application (with source) is available from:
-  http://www.slackwaresupport.com/howtos/Webcam-HOWTO
-
-The slow framerate is due to missing DMA ECP read support in the
-parport drivers. I might add working EPP support later.
-
-Good luck!
-    /Jakob Kemi
-- 
2.1.3

