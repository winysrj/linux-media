Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:33604 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbcBOWmQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 17:42:16 -0500
Received: by mail-wm0-f46.google.com with SMTP id g62so167374103wme.0
        for <linux-media@vger.kernel.org>; Mon, 15 Feb 2016 14:42:15 -0800 (PST)
Received: from [192.168.0.10] (host-92-17-109-254.as13285.net. [92.17.109.254])
        by smtp.googlemail.com with ESMTPSA id ka4sm27367968wjc.47.2016.02.15.14.42.11
        for <linux-media@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Mon, 15 Feb 2016 14:42:13 -0800 (PST)
To: linux-media@vger.kernel.org
From: Tony IBM-MAIN <v1i9v6a6@gmail.com>
Subject: TW6800 video fails with more than 4 cameras on 8 channel card
Message-ID: <56C25442.6040004@gmail.com>
Date: Mon, 15 Feb 2016 22:42:11 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am running Motion on Lubuntu 14.04 with an 8 channel tw6800 card. I 
have 6 camera attached. When I activate more that 4 threads in motion 
CCTV application one or more threads continually timeout. With any 4 
cameras of the 6 cameras active it seems stable.

******************* apt-cache showpkg motion *******************

Package: motion
Versions:
3.2.12-4 
(/var/lib/apt/lists/gb.archive.ubuntu.com_ubuntu_dists_trusty_universe_binary-amd64_Packages) 
(/var/lib/dpkg/status)
  Description Language:
                  File: 
/var/lib/apt/lists/gb.archive.ubuntu.com_ubuntu_dists_trusty_universe_binary-amd64_Packages
                   MD5: 95691a2891ad329d51433cc29defc924
  Description Language: en
                  File: 
/var/lib/apt/lists/gb.archive.ubuntu.com_ubuntu_dists_trusty_universe_i18n_Translation-en
                   MD5: 95691a2891ad329d51433cc29defc924


Reverse Depends:
   motion:i386,motion
Dependencies:
3.2.12-4 - libavcodec54 (18 6:9.1-1) libavcodec-extra-54 (2 6:9.11) 
libavformat54 (2 6:9.1-1) libavutil52 (2 6:9.1-1) libc6 (2 2.15) 
libjpeg8 (2 8c) libmysqlclient18 (2 5.5.24+dfsg-1) libpq5 (0 (null)) 
debconf (18 0.5) debconf-2.0 (0 (null)) adduser (0 (null)) debconf (0 
(null)) mysql-client (0 (null)) postgresql-client (0 (null)) ffmpeg (0 
(null)) motion:i386 (0 (null))
Provides:
3.2.12-4 -
Reverse Provides:

******************* sudo modinfo tw68 *******************

filename: 
/lib/modules/3.19.0-49-generic/kernel/drivers/media/pci/tw68/tw68.ko
license:        GPL
author:         Hans Verkuil <hverkuil@xs4all.nl>
author:         William M. Brack
description:    v4l2 driver module for tw6800 based video capture cards
srcversion:     FB3C913977198E340B58A2E
depends: videobuf2-core,videodev,videobuf2-dma-sg,v4l2-common
intree:         Y
vermagic:       3.19.0-49-generic SMP mod_unload modversions
signer:         Magrathea: Glacier signing key
sig_key: A9:32:DC:23:78:95:A4:4D:39:59:BF:91:A3:56:6A:20:EE:21:1F:37
sig_hashalgo:   sha512
parm:           latency:pci latency timer (int)
parm:           video_nr:video device number (array of int)
parm:           card:card type (array of int)



Here are the syslog messages for motion after shutting it down with 4 
threads and restarting with 5 threads

Feb 14 17:18:03 AJS2 motion: [0] httpd Closing
Feb 14 17:18:03 AJS2 motion: [0] httpd thread exit
Feb 14 17:18:04 AJS2 motion: [4] Calling vid_close() from motion_cleanup
Feb 14 17:18:04 AJS2 motion: [4] Closing video device /dev/video5
Feb 14 17:18:04 AJS2 motion: [2] Calling vid_close() from motion_cleanup
Feb 14 17:18:04 AJS2 motion: [2] Closing video device /dev/video3
Feb 14 17:18:04 AJS2 motion: [1] Calling vid_close() from motion_cleanup
Feb 14 17:18:04 AJS2 motion: [1] Closing video device /dev/video1
Feb 14 17:18:04 AJS2 motion: [3] Calling vid_close() from motion_cleanup
Feb 14 17:18:04 AJS2 motion: [3] Closing video device /dev/video4
Feb 14 17:18:05 AJS2 motion: [0] Motion terminating
Feb 14 17:18:05 AJS2 motion: [0] Removed process id file (pid file).
Feb 14 17:18:07 AJS2 motion: [0] Processing thread 0 - config file 
/etc/motion/motion.conf
Feb 14 17:18:07 AJS2 motion: [0] Unknown config option "destination"
Feb 14 17:18:07 AJS2 motion: [0] Processing config file 
/etc/motion/thread0.conf
Feb 14 17:18:07 AJS2 motion: [0] Processing config file 
/etc/motion/thread1.conf
Feb 14 17:18:07 AJS2 motion: [0] Processing config file 
/etc/motion/thread3.conf
Feb 14 17:18:07 AJS2 motion: [0] Processing config file 
/etc/motion/thread4.conf
Feb 14 17:18:07 AJS2 motion: [0] Processing config file 
/etc/motion/thread5.conf
Feb 14 17:18:07 AJS2 motion: [0] Motion 3.2.12 Started
Feb 14 17:18:07 AJS2 motion: [0] Created process id file 
/var/run/motion/motion.pid. Process ID is 30807
Feb 14 17:18:07 AJS2 motion: [0] Motion running as daemon process
Feb 14 17:18:07 AJS2 motion: [0] ffmpeg LIBAVCODEC_BUILD 3547904 
LIBAVFORMAT_BUILD 3544067
Feb 14 17:18:07 AJS2 motion: [0] Thread 1 is from /etc/motion/thread0.conf
Feb 14 17:18:07 AJS2 motion: [0] Thread 2 is from /etc/motion/thread1.conf
Feb 14 17:18:07 AJS2 motion: [0] Thread 3 is from /etc/motion/thread3.conf
Feb 14 17:18:07 AJS2 motion: [0] Thread 4 is from /etc/motion/thread4.conf
Feb 14 17:18:07 AJS2 motion: [0] Thread 5 is from /etc/motion/thread5.conf
Feb 14 17:18:07 AJS2 motion: [1] Thread 1 started
Feb 14 17:18:07 AJS2 motion: [1] cap.driver: "tw68"
Feb 14 17:18:07 AJS2 motion: [1] cap.card: "Techwell Capture Card"
Feb 14 17:18:07 AJS2 motion: [1] cap.bus_info: "PCI:0000:02:04.0"
Feb 14 17:18:07 AJS2 motion: [1] cap.capabilities=0x85200001
Feb 14 17:18:07 AJS2 motion: [1] - VIDEO_CAPTURE
Feb 14 17:18:07 AJS2 motion: [1] - READWRITE
Feb 14 17:18:07 AJS2 motion: [1] - STREAMING
Feb 14 17:18:07 AJS2 motion: [1] Test palette UYVY (720x576)
Feb 14 17:18:07 AJS2 motion: [1] Using palette UYVY (720x576) 
bytesperlines 1440 sizeimage 829440 colorspace 00000001
Feb 14 17:18:07 AJS2 motion: [1] found control 0x00980900, "Brightness", 
range -128,127
Feb 14 17:18:07 AJS2 motion: [1] #011"Brightness", default 20, current 20
Feb 14 17:18:07 AJS2 motion: [1] found control 0x00980901, "Contrast", 
range 0,255
Feb 14 17:18:07 AJS2 motion: [1] #011"Contrast", default 100, current 100
Feb 14 17:18:07 AJS2 motion: [1] found control 0x00980902, "Saturation", 
range 0,255
Feb 14 17:18:07 AJS2 motion: [1] #011"Saturation", default 128, current 128
Feb 14 17:18:07 AJS2 motion: [1] found control 0x00980903, "Hue", range 
-128,127
Feb 14 17:18:07 AJS2 motion: [1] #011"Hue", default 0, current 0
Feb 14 17:18:07 AJS2 motion: [4] Thread 4 started
Feb 14 17:18:07 AJS2 motion: [5] Thread 5 started
Feb 14 17:18:07 AJS2 motion: [0] motion-httpd/3.2.12 running, accepting 
connections
Feb 14 17:18:07 AJS2 motion: [0] motion-httpd: waiting for data on port 
TCP 8888
Feb 14 17:18:07 AJS2 motion: [3] Thread 3 started
Feb 14 17:18:07 AJS2 motion: [2] Thread 2 started
Feb 14 17:18:07 AJS2 motion: [1] mmap information:
Feb 14 17:18:07 AJS2 motion: [1] frames=4
Feb 14 17:18:07 AJS2 motion: [1] 0 length=829440
Feb 14 17:18:07 AJS2 motion: [1] 1 length=829440
Feb 14 17:18:07 AJS2 motion: [1] 2 length=829440
Feb 14 17:18:07 AJS2 motion: [1] 3 length=829440
Feb 14 17:18:07 AJS2 motion: [1] Resizing pre_capture buffer to 1 items
Feb 14 17:18:07 AJS2 motion: [4] cap.driver: "tw68"
Feb 14 17:18:07 AJS2 motion: [4] cap.card: "Techwell Capture Card"
Feb 14 17:18:07 AJS2 motion: [4] cap.bus_info: "PCI:0000:02:05.0"
Feb 14 17:18:07 AJS2 motion: [4] cap.capabilities=0x85200001
Feb 14 17:18:07 AJS2 motion: [4] - VIDEO_CAPTURE
Feb 14 17:18:07 AJS2 motion: [4] - READWRITE
Feb 14 17:18:07 AJS2 motion: [4] - STREAMING
Feb 14 17:18:07 AJS2 motion: [4] Test palette UYVY (720x576)
Feb 14 17:18:07 AJS2 motion: [4] Using palette UYVY (720x576) 
bytesperlines 1440 sizeimage 829440 colorspace 00000001
Feb 14 17:18:07 AJS2 motion: [4] found control 0x00980900, "Brightness", 
range -128,127
Feb 14 17:18:07 AJS2 motion: [4] #011"Brightness", default 20, current 20
Feb 14 17:18:07 AJS2 motion: [4] found control 0x00980901, "Contrast", 
range 0,255
Feb 14 17:18:07 AJS2 motion: [4] #011"Contrast", default 100, current 100
Feb 14 17:18:07 AJS2 motion: [4] found control 0x00980902, "Saturation", 
range 0,255
Feb 14 17:18:07 AJS2 motion: [4] #011"Saturation", default 128, current 128
Feb 14 17:18:07 AJS2 motion: [4] found control 0x00980903, "Hue", range 
-128,127
Feb 14 17:18:07 AJS2 motion: [4] #011"Hue", default 0, current 0
Feb 14 17:18:07 AJS2 motion: [4] mmap information:
Feb 14 17:18:07 AJS2 motion: [4] frames=4
Feb 14 17:18:07 AJS2 motion: [4] 0 length=829440
Feb 14 17:18:07 AJS2 motion: [4] 1 length=829440
Feb 14 17:18:07 AJS2 motion: [4] 2 length=829440
Feb 14 17:18:07 AJS2 motion: [4] 3 length=829440
Feb 14 17:18:07 AJS2 motion: [4] Resizing pre_capture buffer to 1 items
Feb 14 17:18:07 AJS2 motion: [5] cap.driver: "tw68"
Feb 14 17:18:07 AJS2 motion: [5] cap.card: "Techwell Capture Card"
Feb 14 17:18:07 AJS2 motion: [5] cap.bus_info: "PCI:0000:02:05.1"
Feb 14 17:18:07 AJS2 motion: [5] cap.capabilities=0x85200001
Feb 14 17:18:07 AJS2 motion: [5] - VIDEO_CAPTURE
Feb 14 17:18:07 AJS2 motion: [5] - READWRITE
Feb 14 17:18:07 AJS2 motion: [5] - STREAMING
Feb 14 17:18:07 AJS2 motion: [5] Test palette UYVY (720x576)
Feb 14 17:18:07 AJS2 motion: [5] Using palette UYVY (720x576) 
bytesperlines 1440 sizeimage 829440 colorspace 00000001
Feb 14 17:18:07 AJS2 motion: [5] found control 0x00980900, "Brightness", 
range -128,127
Feb 14 17:18:07 AJS2 motion: [5] #011"Brightness", default 20, current 20
Feb 14 17:18:07 AJS2 motion: [5] found control 0x00980901, "Contrast", 
range 0,255
Feb 14 17:18:07 AJS2 motion: [5] #011"Contrast", default 100, current 100
Feb 14 17:18:07 AJS2 motion: [5] found control 0x00980902, "Saturation", 
range 0,255
Feb 14 17:18:07 AJS2 motion: [5] #011"Saturation", default 128, current 128
Feb 14 17:18:07 AJS2 motion: [5] found control 0x00980903, "Hue", range 
-128,127
Feb 14 17:18:07 AJS2 motion: [5] #011"Hue", default 0, current 0
Feb 14 17:18:07 AJS2 motion: [5] mmap information:
Feb 14 17:18:07 AJS2 motion: [5] frames=4
Feb 14 17:18:07 AJS2 motion: [5] 0 length=829440
Feb 14 17:18:07 AJS2 motion: [5] 1 length=829440
Feb 14 17:18:07 AJS2 motion: [5] 2 length=829440
Feb 14 17:18:07 AJS2 motion: [5] 3 length=829440
Feb 14 17:18:07 AJS2 motion: [5] Resizing pre_capture buffer to 1 items
Feb 14 17:18:07 AJS2 motion: [3] cap.driver: "tw68"
Feb 14 17:18:07 AJS2 motion: [3] cap.card: "Techwell Capture Card"
Feb 14 17:18:07 AJS2 motion: [3] cap.bus_info: "PCI:0000:02:04.3"
Feb 14 17:18:07 AJS2 motion: [3] cap.capabilities=0x85200001
Feb 14 17:18:07 AJS2 motion: [3] - VIDEO_CAPTURE
Feb 14 17:18:07 AJS2 motion: [3] - READWRITE
Feb 14 17:18:07 AJS2 motion: [3] - STREAMING
Feb 14 17:18:07 AJS2 motion: [3] Test palette UYVY (720x576)
Feb 14 17:18:07 AJS2 motion: [3] Using palette UYVY (720x576) 
bytesperlines 1440 sizeimage 829440 colorspace 00000001
Feb 14 17:18:07 AJS2 motion: [3] found control 0x00980900, "Brightness", 
range -128,127
Feb 14 17:18:07 AJS2 motion: [3] #011"Brightness", default 20, current 20
Feb 14 17:18:07 AJS2 motion: [3] found control 0x00980901, "Contrast", 
range 0,255
Feb 14 17:18:07 AJS2 motion: [3] #011"Contrast", default 100, current 100
Feb 14 17:18:07 AJS2 motion: [3] found control 0x00980902, "Saturation", 
range 0,255
Feb 14 17:18:07 AJS2 motion: [3] #011"Saturation", default 128, current 128
Feb 14 17:18:07 AJS2 motion: [3] found control 0x00980903, "Hue", range 
-128,127
Feb 14 17:18:07 AJS2 motion: [3] #011"Hue", default 0, current 0
Feb 14 17:18:07 AJS2 motion: [3] mmap information:
Feb 14 17:18:07 AJS2 motion: [3] frames=4
Feb 14 17:18:07 AJS2 motion: [3] 0 length=829440
Feb 14 17:18:07 AJS2 motion: [3] 1 length=829440
Feb 14 17:18:07 AJS2 motion: [3] 2 length=829440
Feb 14 17:18:07 AJS2 motion: [3] 3 length=829440
Feb 14 17:18:07 AJS2 motion: [3] Resizing pre_capture buffer to 1 items
Feb 14 17:18:07 AJS2 motion: [2] cap.driver: "tw68"
Feb 14 17:18:07 AJS2 motion: [2] cap.card: "Techwell Capture Card"
Feb 14 17:18:07 AJS2 motion: [2] cap.bus_info: "PCI:0000:02:04.1"
Feb 14 17:18:07 AJS2 motion: [2] cap.capabilities=0x85200001
Feb 14 17:18:07 AJS2 motion: [2] - VIDEO_CAPTURE
Feb 14 17:18:07 AJS2 motion: [2] - READWRITE
Feb 14 17:18:07 AJS2 motion: [2] - STREAMING
Feb 14 17:18:07 AJS2 motion: [2] Test palette UYVY (720x576)
Feb 14 17:18:07 AJS2 motion: [2] Using palette UYVY (720x576) 
bytesperlines 1440 sizeimage 829440 colorspace 00000001
Feb 14 17:18:07 AJS2 motion: [2] found control 0x00980900, "Brightness", 
range -128,127
Feb 14 17:18:07 AJS2 motion: [2] #011"Brightness", default 20, current 20
Feb 14 17:18:07 AJS2 motion: [2] found control 0x00980901, "Contrast", 
range 0,255
Feb 14 17:18:07 AJS2 motion: [2] #011"Contrast", default 100, current 100
Feb 14 17:18:07 AJS2 motion: [2] found control 0x00980902, "Saturation", 
range 0,255
Feb 14 17:18:07 AJS2 motion: [2] #011"Saturation", default 128, current 128
Feb 14 17:18:07 AJS2 motion: [2] found control 0x00980903, "Hue", range 
-128,127
Feb 14 17:18:07 AJS2 motion: [2] #011"Hue", default 0, current 0
Feb 14 17:18:07 AJS2 motion: [2] mmap information:
Feb 14 17:18:07 AJS2 motion: [2] frames=4
Feb 14 17:18:07 AJS2 motion: [2] 0 length=829440
Feb 14 17:18:07 AJS2 motion: [2] 1 length=829440
Feb 14 17:18:07 AJS2 motion: [2] 2 length=829440
Feb 14 17:18:07 AJS2 motion: [2] 3 length=829440
Feb 14 17:18:07 AJS2 motion: [2] Resizing pre_capture buffer to 1 items
Feb 14 17:18:07 AJS2 motion: [4] Started stream webcam server in port 8094
Feb 14 17:18:07 AJS2 motion: [4] Resizing pre_capture buffer to 21 items
Feb 14 17:18:07 AJS2 motion: [1] Started stream webcam server in port 8090
Feb 14 17:18:07 AJS2 motion: [3] Started stream webcam server in port 8093
Feb 14 17:18:07 AJS2 motion: [3] Resizing pre_capture buffer to 21 items
Feb 14 17:18:07 AJS2 motion: [1] Resizing pre_capture buffer to 21 items
Feb 14 17:18:07 AJS2 motion: [2] Started stream webcam server in port 8091
Feb 14 17:18:07 AJS2 motion: [2] Resizing pre_capture buffer to 21 items
Feb 14 17:18:07 AJS2 motion: [5] Started stream webcam server in port 8095
Feb 14 17:18:07 AJS2 motion: [5] Resizing pre_capture buffer to 21 items
Feb 14 17:18:54 AJS2 motion: [0] Thread 1 - Watchdog timeout, trying to 
do a graceful restart

I can dual boot this PC with Lubuntu 12.10 and run 6 camera fine with 
the same motion config.

I dont think this is a memory problem. Here is a top display running 4 
camera for 24+ hours

top - 22:37:14 up 1 day,  5:35,  1 user,  load average: 0.13, 0.21, 0.22
Tasks: 178 total,   1 running, 177 sleeping,   0 stopped, 0 zombie
%Cpu(s):  7.6 us,  3.3 sy,  0.0 ni, 89.0 id,  0.0 wa,  0.0 hi,  0.0 si,  
0.0 st
KiB Mem:   1918268 total,  1796656 used,   121612 free, 99096 buffers
KiB Swap: 10239996 total,    72896 used, 10167100 free. 987244 cached Mem

   PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ 
COMMAND
23672 motion    20   0  644856 134552  15028 S   7.0  7.0 155:49.80 motion
10013 tony      20   0  615884  12648   7900 S   0.7  0.7 3:09.46 lxpanel
     7 root      20   0       0      0      0 S   0.3  0.0 2:53.63 
rcu_sched
    18 root      20   0       0      0      0 S   0.3  0.0 0:56.68 rcuos/1
  5681 root      20   0       0      0      0 S   0.3  0.0 0:00.21 
kworker/1:0
10011 tony      20   0  284204   9852   5216 S   0.3  0.5 0:40.82 openbox
13667 tony      20   0   30244   2868   2364 R   0.3  0.1 0:00.02 top
     1 root      20   0   33908   3848   2424 S   0.0  0.2 0:02.40 init

Any ideas what might be causing this?

Thanks for your help.

Tony.
