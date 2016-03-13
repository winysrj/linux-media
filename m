Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35176 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbcCMOlK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Mar 2016 10:41:10 -0400
Received: by mail-wm0-f43.google.com with SMTP id l68so75674530wml.0
        for <linux-media@vger.kernel.org>; Sun, 13 Mar 2016 07:41:09 -0700 (PDT)
Received: from [192.168.0.10] (host-78-150-114-46.as13285.net. [78.150.114.46])
        by smtp.googlemail.com with ESMTPSA id g203sm11754526wmf.23.2016.03.13.07.41.06
        for <linux-media@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Sun, 13 Mar 2016 07:41:07 -0700 (PDT)
Subject: Fwd: Re: tw68 fails with motion package running more than 4 cameras
 on 8 channel card
References: <56E57B89.70406@gmail.com>
To: linux-media@vger.kernel.org
From: Tony IBM-MAIN <v1i9v6a6@gmail.com>
Message-ID: <56E57C01.8070906@gmail.com>
Date: Sun, 13 Mar 2016 14:41:05 +0000
MIME-Version: 1.0
In-Reply-To: <56E57B89.70406@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




-------- Forwarded Message --------
From: 	07 2016 <>
X-Mozilla-Status: 	0001
X-Mozilla-Status2: 	00800000
X-Mozilla-Keys: 	
Subject: 	Re: tw68 fails with motion package running more than 4 cameras 
on 8 channel card
To: 	Hans Verkuil <hverkuil@xs4all.nl>
References: 	<56D4BB54.2000909@gmail.com> <56D6A19D.7010100@xs4all.nl>
From: 	Tony IBM-MAIN <v1i9v6a6@gmail.com>
Message-ID: 	<56E57B89.70406@gmail.com>
Date: 	Sun, 13 Mar 2016 14:39:05 +0000
User-Agent: 	Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101 
Thunderbird/38.6.0
MIME-Version: 	1.0
In-Reply-To: 	<56D6A19D.7010100@xs4all.nl>
Content-Type: 	text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 	7bit



On 02/03/16 08:17, Hans Verkuil wrote:
> On 02/29/2016 10:42 PM, Tony IBM-MAIN wrote:
>> Hi,
>>
>> This is an updated version of a posting made a couple of weeks ago after
>> some more testing.
>>
>> I am running a Motion 3.2.12 CCTV system on Lubuntu 14.04 and 15.10 with
>> an 8 channel tw68 card. I have 6 camera attached. When I activate more
>> that 4 threads in motion CCTV application one or more threads
>> continually timeout. With any 4 cameras of the 6 cameras active it seems
>> stable.
>>
>> I have been running this system with 6 camera on Lubuntu 12.10 for over
>> 3 years without a problem.
>>
>>
>> On Lubuntu 14.04 LTS
>>
>> ******************* apt-cache showpkg motion *******************
>> a
>> Package: motion
>> Versions:
>> 3.2.12-4
>> (/var/lib/apt/lists/gb.archive.ubuntu.com_ubuntu_dists_trusty_universe_binary-amd64_Packages)
>> (/var/lib/dpkg/status)
>>    Description Language:
>>                    File:
>> /var/lib/apt/lists/gb.archive.ubuntu.com_ubuntu_dists_trusty_universe_binary-amd64_Packages
>>                     MD5: 95691a2891ad329d51433cc29defc924
>>    Description Language: en
>>                    File:
>> /var/lib/apt/lists/gb.archive.ubuntu.com_ubuntu_dists_trusty_universe_i18n_Translation-en
>>                     MD5: 95691a2891ad329d51433cc29defc924
>>
>>
>> Reverse Depends:
>>     motion:i386,motion
>> Dependencies:
>> 3.2.12-4 - libavcodec54 (18 6:9.1-1) libavcodec-extra-54 (2 6:9.11)
>> libavformat54 (2 6:9.1-1) libavutil52 (2 6:9.1-1) libc6 (2 2.15)
>> libjpeg8 (2 8c) libmysqlclient18 (2 5.5.24+dfsg-1) libpq5 (0 (null))
>> debconf (18 0.5) debconf-2.0 (0 (null)) adduser (0 (null)) debconf (0
>> (null)) mysql-client (0 (null)) postgresql-client (0 (null)) ffmpeg (0
>> (null)) motion:i386 (0 (null))
>> Provides:
>> 3.2.12-4 -
>> Reverse Provides:
>>
>> ******************* sudo modinfo tw68 *******************
>>
>> filename:
>> /lib/modules/3.19.0-49-generic/kernel/drivers/media/pci/tw68/tw68.ko
>> license:        GPL
>> author:         Hans Verkuil <hverkuil@xs4all.nl>
>> author:         William M. Brack
>> description:    v4l2 driver module for tw6800 based video capture cards
>> srcversion:     FB3C913977198E340B58A2E
>> depends: videobuf2-core,videodev,videobuf2-dma-sg,v4l2-common
>> intree:         Y
>> vermagic:       3.19.0-49-generic SMP mod_unload modversions
>> signer:         Magrathea: Glacier signing key
>> sig_key: A9:32:DC:23:78:95:A4:4D:39:59:BF:91:A3:56:6A:20:EE:21:1F:37
>> sig_hashalgo:   sha512
>> parm:           latency:pci latency timer (int)
>> parm:           video_nr:video device number (array of int)
>> parm:           card:card type (array of int)
>>
>>
>>
>> Here are the syslog messages for motion after shutting it down with 4
>> threads and restarting with 5 threads
>>
>> Feb 14 17:18:03 AJS2 motion: [0] httpd Closing
>> Feb 14 17:18:03 AJS2 motion: [0] httpd thread exit
>> Feb 14 17:18:04 AJS2 motion: [4] Calling vid_close() from motion_cleanup
>> Feb 14 17:18:04 AJS2 motion: [4] Closing video device /dev/video5
>> Feb 14 17:18:04 AJS2 motion: [2] Calling vid_close() from motion_cleanup
>> Feb 14 17:18:04 AJS2 motion: [2] Closing video device /dev/video3
>> Feb 14 17:18:04 AJS2 motion: [1] Calling vid_close() from motion_cleanup
>> Feb 14 17:18:04 AJS2 motion: [1] Closing video device /dev/video1
>> Feb 14 17:18:04 AJS2 motion: [3] Calling vid_close() from motion_cleanup
>> Feb 14 17:18:04 AJS2 motion: [3] Closing video device /dev/video4
>> Feb 14 17:18:05 AJS2 motion: [0] Motion terminating
>> Feb 14 17:18:05 AJS2 motion: [0] Removed process id file (pid file).
>> Feb 14 17:18:07 AJS2 motion: [0] Processing thread 0 - config file
>> /etc/motion/motion.conf
>> Feb 14 17:18:07 AJS2 motion: [0] Unknown config option "destination"
>> Feb 14 17:18:07 AJS2 motion: [0] Processing config file
>> /etc/motion/thread0.conf
>> Feb 14 17:18:07 AJS2 motion: [0] Processing config file
>> /etc/motion/thread1.conf
>> Feb 14 17:18:07 AJS2 motion: [0] Processing config file
>> /etc/motion/thread3.conf
>> Feb 14 17:18:07 AJS2 motion: [0] Processing config file
>> /etc/motion/thread4.conf
>> Feb 14 17:18:07 AJS2 motion: [0] Processing config file
>> /etc/motion/thread5.conf
>> Feb 14 17:18:07 AJS2 motion: [0] Motion 3.2.12 Started
>> Feb 14 17:18:07 AJS2 motion: [0] Created process id file
>> /var/run/motion/motion.pid. Process ID is 30807
>> Feb 14 17:18:07 AJS2 motion: [0] Motion running as daemon process
>> Feb 14 17:18:07 AJS2 motion: [0] ffmpeg LIBAVCODEC_BUILD 3547904
>> LIBAVFORMAT_BUILD 3544067
>> Feb 14 17:18:07 AJS2 motion: [0] Thread 1 is from /etc/motion/thread0.conf
>> Feb 14 17:18:07 AJS2 motion: [0] Thread 2 is from /etc/motion/thread1.conf
>> Feb 14 17:18:07 AJS2 motion: [0] Thread 3 is from /etc/motion/thread3.conf
>> Feb 14 17:18:07 AJS2 motion: [0] Thread 4 is from /etc/motion/thread4.conf
>> Feb 14 17:18:07 AJS2 motion: [0] Thread 5 is from /etc/motion/thread5.conf
>> Feb 14 17:18:07 AJS2 motion: [1] Thread 1 started
>> Feb 14 17:18:07 AJS2 motion: [1] cap.driver: "tw68"
>> Feb 14 17:18:07 AJS2 motion: [1] cap.card: "Techwell Capture Card"
>> Feb 14 17:18:07 AJS2 motion: [1] cap.bus_info: "PCI:0000:02:04.0"
>> Feb 14 17:18:07 AJS2 motion: [1] cap.capabilities=0x85200001
>> Feb 14 17:18:07 AJS2 motion: [1] - VIDEO_CAPTURE
>> Feb 14 17:18:07 AJS2 motion: [1] - READWRITE
>> Feb 14 17:18:07 AJS2 motion: [1] - STREAMING
>> Feb 14 17:18:07 AJS2 motion: [1] Test palette UYVY (720x576)
>> Feb 14 17:18:07 AJS2 motion: [1] Using palette UYVY (720x576)
>> bytesperlines 1440 sizeimage 829440 colorspace 00000001
>> Feb 14 17:18:07 AJS2 motion: [1] found control 0x00980900, "Brightness",
>> range -128,127
>> Feb 14 17:18:07 AJS2 motion: [1] #011"Brightness", default 20, current 20
>> Feb 14 17:18:07 AJS2 motion: [1] found control 0x00980901, "Contrast",
>> range 0,255
>> Feb 14 17:18:07 AJS2 motion: [1] #011"Contrast", default 100, current 100
>> Feb 14 17:18:07 AJS2 motion: [1] found control 0x00980902, "Saturation",
>> range 0,255
>> Feb 14 17:18:07 AJS2 motion: [1] #011"Saturation", default 128, current 128
>> Feb 14 17:18:07 AJS2 motion: [1] found control 0x00980903, "Hue", range
>> -128,127
>> Feb 14 17:18:07 AJS2 motion: [1] #011"Hue", default 0, current 0
>> Feb 14 17:18:07 AJS2 motion: [4] Thread 4 started
>> Feb 14 17:18:07 AJS2 motion: [5] Thread 5 started
>> Feb 14 17:18:07 AJS2 motion: [0] motion-httpd/3.2.12 running, accepting
>> connections
>> Feb 14 17:18:07 AJS2 motion: [0] motion-httpd: waiting for data on port
>> TCP 8888
>> Feb 14 17:18:07 AJS2 motion: [3] Thread 3 started
>> Feb 14 17:18:07 AJS2 motion: [2] Thread 2 started
>> Feb 14 17:18:07 AJS2 motion: [1] mmap information:
>> Feb 14 17:18:07 AJS2 motion: [1] frames=4
>> Feb 14 17:18:07 AJS2 motion: [1] 0 length=829440
>> Feb 14 17:18:07 AJS2 motion: [1] 1 length=829440
>> Feb 14 17:18:07 AJS2 motion: [1] 2 length=829440
>> Feb 14 17:18:07 AJS2 motion: [1] 3 length=829440
>> Feb 14 17:18:07 AJS2 motion: [1] Resizing pre_capture buffer to 1 items
>> Feb 14 17:18:07 AJS2 motion: [4] cap.driver: "tw68"
>> Feb 14 17:18:07 AJS2 motion: [4] cap.card: "Techwell Capture Card"
>> Feb 14 17:18:07 AJS2 motion: [4] cap.bus_info: "PCI:0000:02:05.0"
>> Feb 14 17:18:07 AJS2 motion: [4] cap.capabilities=0x85200001
>> Feb 14 17:18:07 AJS2 motion: [4] - VIDEO_CAPTURE
>> Feb 14 17:18:07 AJS2 motion: [4] - READWRITE
>> Feb 14 17:18:07 AJS2 motion: [4] - STREAMING
>> Feb 14 17:18:07 AJS2 motion: [4] Test palette UYVY (720x576)
>> Feb 14 17:18:07 AJS2 motion: [4] Using palette UYVY (720x576)
>> bytesperlines 1440 sizeimage 829440 colorspace 00000001
>> Feb 14 17:18:07 AJS2 motion: [4] found control 0x00980900, "Brightness",
>> range -128,127
>> Feb 14 17:18:07 AJS2 motion: [4] #011"Brightness", default 20, current 20
>> Feb 14 17:18:07 AJS2 motion: [4] found control 0x00980901, "Contrast",
>> range 0,255
>> Feb 14 17:18:07 AJS2 motion: [4] #011"Contrast", default 100, current 100
>> Feb 14 17:18:07 AJS2 motion: [4] found control 0x00980902, "Saturation",
>> range 0,255
>> Feb 14 17:18:07 AJS2 motion: [4] #011"Saturation", default 128, current 128
>> Feb 14 17:18:07 AJS2 motion: [4] found control 0x00980903, "Hue", range
>> -128,127
>> Feb 14 17:18:07 AJS2 motion: [4] #011"Hue", default 0, current 0
>> Feb 14 17:18:07 AJS2 motion: [4] mmap information:
>> Feb 14 17:18:07 AJS2 motion: [4] frames=4
>> Feb 14 17:18:07 AJS2 motion: [4] 0 length=829440
>> Feb 14 17:18:07 AJS2 motion: [4] 1 length=829440
>> Feb 14 17:18:07 AJS2 motion: [4] 2 length=829440
>> Feb 14 17:18:07 AJS2 motion: [4] 3 length=829440
>> Feb 14 17:18:07 AJS2 motion: [4] Resizing pre_capture buffer to 1 items
>> Feb 14 17:18:07 AJS2 motion: [5] cap.driver: "tw68"
>> Feb 14 17:18:07 AJS2 motion: [5] cap.card: "Techwell Capture Card"
>> Feb 14 17:18:07 AJS2 motion: [5] cap.bus_info: "PCI:0000:02:05.1"
>> Feb 14 17:18:07 AJS2 motion: [5] cap.capabilities=0x85200001
>> Feb 14 17:18:07 AJS2 motion: [5] - VIDEO_CAPTURE
>> Feb 14 17:18:07 AJS2 motion: [5] - READWRITE
>> Feb 14 17:18:07 AJS2 motion: [5] - STREAMING
>> Feb 14 17:18:07 AJS2 motion: [5] Test palette UYVY (720x576)
>> Feb 14 17:18:07 AJS2 motion: [5] Using palette UYVY (720x576)
>> bytesperlines 1440 sizeimage 829440 colorspace 00000001
>> Feb 14 17:18:07 AJS2 motion: [5] found control 0x00980900, "Brightness",
>> range -128,127
>> Feb 14 17:18:07 AJS2 motion: [5] #011"Brightness", default 20, current 20
>> Feb 14 17:18:07 AJS2 motion: [5] found control 0x00980901, "Contrast",
>> range 0,255
>> Feb 14 17:18:07 AJS2 motion: [5] #011"Contrast", default 100, current 100
>> Feb 14 17:18:07 AJS2 motion: [5] found control 0x00980902, "Saturation",
>> range 0,255
>> Feb 14 17:18:07 AJS2 motion: [5] #011"Saturation", default 128, current 128
>> Feb 14 17:18:07 AJS2 motion: [5] found control 0x00980903, "Hue", range
>> -128,127
>> Feb 14 17:18:07 AJS2 motion: [5] #011"Hue", default 0, current 0
>> Feb 14 17:18:07 AJS2 motion: [5] mmap information:
>> Feb 14 17:18:07 AJS2 motion: [5] frames=4
>> Feb 14 17:18:07 AJS2 motion: [5] 0 length=829440
>> Feb 14 17:18:07 AJS2 motion: [5] 1 length=829440
>> Feb 14 17:18:07 AJS2 motion: [5] 2 length=829440
>> Feb 14 17:18:07 AJS2 motion: [5] 3 length=829440
>> Feb 14 17:18:07 AJS2 motion: [5] Resizing pre_capture buffer to 1 items
>> Feb 14 17:18:07 AJS2 motion: [3] cap.driver: "tw68"
>> Feb 14 17:18:07 AJS2 motion: [3] cap.card: "Techwell Capture Card"
>> Feb 14 17:18:07 AJS2 motion: [3] cap.bus_info: "PCI:0000:02:04.3"
>> Feb 14 17:18:07 AJS2 motion: [3] cap.capabilities=0x85200001
>> Feb 14 17:18:07 AJS2 motion: [3] - VIDEO_CAPTURE
>> Feb 14 17:18:07 AJS2 motion: [3] - READWRITE
>> Feb 14 17:18:07 AJS2 motion: [3] - STREAMING
>> Feb 14 17:18:07 AJS2 motion: [3] Test palette UYVY (720x576)
>> Feb 14 17:18:07 AJS2 motion: [3] Using palette UYVY (720x576)
>> bytesperlines 1440 sizeimage 829440 colorspace 00000001
>> Feb 14 17:18:07 AJS2 motion: [3] found control 0x00980900, "Brightness",
>> range -128,127
>> Feb 14 17:18:07 AJS2 motion: [3] #011"Brightness", default 20, current 20
>> Feb 14 17:18:07 AJS2 motion: [3] found control 0x00980901, "Contrast",
>> range 0,255
>> Feb 14 17:18:07 AJS2 motion: [3] #011"Contrast", default 100, current 100
>> Feb 14 17:18:07 AJS2 motion: [3] found control 0x00980902, "Saturation",
>> range 0,255
>> Feb 14 17:18:07 AJS2 motion: [3] #011"Saturation", default 128, current 128
>> Feb 14 17:18:07 AJS2 motion: [3] found control 0x00980903, "Hue", range
>> -128,127
>> Feb 14 17:18:07 AJS2 motion: [3] #011"Hue", default 0, current 0
>> Feb 14 17:18:07 AJS2 motion: [3] mmap information:
>> Feb 14 17:18:07 AJS2 motion: [3] frames=4
>> Feb 14 17:18:07 AJS2 motion: [3] 0 length=829440
>> Feb 14 17:18:07 AJS2 motion: [3] 1 length=829440
>> Feb 14 17:18:07 AJS2 motion: [3] 2 length=829440
>> Feb 14 17:18:07 AJS2 motion: [3] 3 length=829440
>> Feb 14 17:18:07 AJS2 motion: [3] Resizing pre_capture buffer to 1 items
>> Feb 14 17:18:07 AJS2 motion: [2] cap.driver: "tw68"
>> Feb 14 17:18:07 AJS2 motion: [2] cap.card: "Techwell Capture Card"
>> Feb 14 17:18:07 AJS2 motion: [2] cap.bus_info: "PCI:0000:02:04.1"
>> Feb 14 17:18:07 AJS2 motion: [2] cap.capabilities=0x85200001
>> Feb 14 17:18:07 AJS2 motion: [2] - VIDEO_CAPTURE
>> Feb 14 17:18:07 AJS2 motion: [2] - READWRITE
>> Feb 14 17:18:07 AJS2 motion: [2] - STREAMING
>> Feb 14 17:18:07 AJS2 motion: [2] Test palette UYVY (720x576)
>> Feb 14 17:18:07 AJS2 motion: [2] Using palette UYVY (720x576)
>> bytesperlines 1440 sizeimage 829440 colorspace 00000001
>> Feb 14 17:18:07 AJS2 motion: [2] found control 0x00980900, "Brightness",
>> range -128,127
>> Feb 14 17:18:07 AJS2 motion: [2] #011"Brightness", default 20, current 20
>> Feb 14 17:18:07 AJS2 motion: [2] found control 0x00980901, "Contrast",
>> range 0,255
>> Feb 14 17:18:07 AJS2 motion: [2] #011"Contrast", default 100, current 100
>> Feb 14 17:18:07 AJS2 motion: [2] found control 0x00980902, "Saturation",
>> range 0,255
>> Feb 14 17:18:07 AJS2 motion: [2] #011"Saturation", default 128, current 128
>> Feb 14 17:18:07 AJS2 motion: [2] found control 0x00980903, "Hue", range
>> -128,127
>> Feb 14 17:18:07 AJS2 motion: [2] #011"Hue", default 0, current 0
>> Feb 14 17:18:07 AJS2 motion: [2] mmap information:
>> Feb 14 17:18:07 AJS2 motion: [2] frames=4
>> Feb 14 17:18:07 AJS2 motion: [2] 0 length=829440
>> Feb 14 17:18:07 AJS2 motion: [2] 1 length=829440
>> Feb 14 17:18:07 AJS2 motion: [2] 2 length=829440
>> Feb 14 17:18:07 AJS2 motion: [2] 3 length=829440
>> Feb 14 17:18:07 AJS2 motion: [2] Resizing pre_capture buffer to 1 items
>> Feb 14 17:18:07 AJS2 motion: [4] Started stream webcam server in port 8094
>> Feb 14 17:18:07 AJS2 motion: [4] Resizing pre_capture buffer to 21 items
>> Feb 14 17:18:07 AJS2 motion: [1] Started stream webcam server in port 8090
>> Feb 14 17:18:07 AJS2 motion: [3] Started stream webcam server in port 8093
>> Feb 14 17:18:07 AJS2 motion: [3] Resizing pre_capture buffer to 21 items
>> Feb 14 17:18:07 AJS2 motion: [1] Resizing pre_capture buffer to 21 items
>> Feb 14 17:18:07 AJS2 motion: [2] Started stream webcam server in port 8091
>> Feb 14 17:18:07 AJS2 motion: [2] Resizing pre_capture buffer to 21 items
>> Feb 14 17:18:07 AJS2 motion: [5] Started stream webcam server in port 8095
>> Feb 14 17:18:07 AJS2 motion: [5] Resizing pre_capture buffer to 21 items
>> Feb 14 17:18:54 AJS2 motion: [0] Thread 1 - Watchdog timeout, trying to
>> do a graceful restart
>>
>>
>> On Lubuntu 15.10
>>
>> I installed Lubuntu 15.10 on a new partition (not an upgrade) but the
>> problem remains exactly the same.
>>
>> Motion was updated to a later git version.
>>
>> ******************* apt-cache showpkg motion *******************
>>
>> Package: motion
>> Versions:
>> 3.2.12+git20140228-7
>> (/var/lib/apt/lists/gb.archive.ubuntu.com_ubuntu_dists_wily_universe_binary-amd64_Packages)
>> (/var/lib/dpkg/status)
>>    Description Language:
>>                    File:
>> /var/lib/apt/lists/gb.archive.ubuntu.com_ubuntu_dists_wily_universe_binary-amd64_Packages
>>                     MD5: 2699ebee3b63a553c62f7f823c1643ca
>>    Description Language: en
>>                    File:
>> /var/lib/apt/lists/gb.archive.ubuntu.com_ubuntu_dists_wily_universe_i18n_Translation-en
>>                     MD5: 2699ebee3b63a553c62f7f823c1643ca
>>
>>
>> ******************* sudo modinfo tw68 *******************
>>
>> filename:
>> /lib/modules/4.2.0-16-generic/kernel/drivers/media/pci/tw68/tw68.ko
>> license:        GPL
>> author:         Hans Verkuil <hverkuil@xs4all.nl>
>> author:         William M. Brack
>> description:    v4l2 driver module for tw6800 based video capture cards
>> srcversion:     1C0BD6DEE4DE378750B9124
>> depends:        videobuf2-core,videodev,videobuf2-dma-sg,v4l2-common
>> intree:         Y
>> vermagic:       4.2.0-16-generic SMP mod_unload modversions
>> signer:         Build time autogenerated kernel key
>> sig_key: 6A:1C:9C:21:F0:4A:B8:6F:D1:D7:CE:D6:CA:11:35:40:FC:8E:35:B6
>> sig_hashalgo:   sha512
>> parm:           latency:pci latency timer (int)
>> parm:           video_nr:video device number (array of int)
>> parm:           card:card type (array of int)
>>
>> The 15.10 system ran with 4 cameras working fine for 24 hours. I then
>> added the 5th and it causes one camera to fail.
>>
>> Here is an extract from the motion.log when recycled
>>
>> [1] [NTC] [VID] [Feb 29 19:31:37] vid_v4lx_start: Using V4L2
>> [1] [NTC] [ALL] [Feb 29 19:31:37] image_ring_resize: Resizing
>> pre_capture buffer to 1 items
>> [4] [NTC] [STR] [Feb 29 19:31:37] http_bindsock: motion-stream testing :
>> IPV4 addr: 0.0.0.0 port: 8094
>> [4] [NTC] [STR] [Feb 29 19:31:37] http_bindsock: motion-stream Bound :
>> IPV4 addr: 0.0.0.0 port: 8094
>> [4] [NTC] [ALL] [Feb 29 19:31:37] motion_init: Started motion-stream
>> server in port 8094 auth Disabled
>> [4] [NTC] [ALL] [Feb 29 19:31:37] image_ring_resize: Resizing
>> pre_capture buffer to 21 items
>> [2] [NTC] [STR] [Feb 29 19:31:37] http_bindsock: motion-stream testing :
>> IPV4 addr: 0.0.0.0 port: 8092
>> [2] [NTC] [STR] [Feb 29 19:31:37] http_bindsock: motion-stream Bound :
>> IPV4 addr: 0.0.0.0 port: 8092
>> [2] [NTC] [ALL] [Feb 29 19:31:37] motion_init: Started motion-stream
>> server in port 8092 auth Disabled
>> [2] [NTC] [ALL] [Feb 29 19:31:37] image_ring_resize: Resizing
>> pre_capture buffer to 3 items
>> [3] [NTC] [STR] [Feb 29 19:31:37] http_bindsock: motion-stream testing :
>> IPV4 addr: 0.0.0.0 port: 8093
>> [3] [NTC] [STR] [Feb 29 19:31:37] http_bindsock: motion-stream Bound :
>> IPV4 addr: 0.0.0.0 port: 8093
>> [3] [NTC] [ALL] [Feb 29 19:31:37] motion_init: Started motion-stream
>> server in port 8093 auth Disabled
>> [3] [NTC] [ALL] [Feb 29 19:31:37] image_ring_resize: Resizing
>> pre_capture buffer to 21 items
>> [1] [NTC] [STR] [Feb 29 19:31:37] http_bindsock: motion-stream testing :
>> IPV4 addr: 0.0.0.0 port: 8090
>> [1] [NTC] [STR] [Feb 29 19:31:37] http_bindsock: motion-stream Bound :
>> IPV4 addr: 0.0.0.0 port: 8090
>> [1] [NTC] [ALL] [Feb 29 19:31:37] motion_init: Started motion-stream
>> server in port 8090 auth Disabled
>> [1] [NTC] [ALL] [Feb 29 19:31:37] image_ring_resize: Resizing
>> pre_capture buffer to 21 items
>> [5] [NTC] [STR] [Feb 29 19:31:37] http_bindsock: motion-stream testing :
>> IPV4 addr: 0.0.0.0 port: 8095
>> [5] [NTC] [STR] [Feb 29 19:31:37] http_bindsock: motion-stream Bound :
>> IPV4 addr: 0.0.0.0 port: 8095
>> [5] [NTC] [ALL] [Feb 29 19:31:37] motion_init: Started motion-stream
>> server in port 8095 auth Disabled
>> [5] [NTC] [ALL] [Feb 29 19:31:37] image_ring_resize: Resizing
>> pre_capture buffer to 21 items
>> [0] [ERR] [ALL] [Feb 29 19:32:09] main: Thread 1 - Watchdog timeout,
>> trying to do a graceful restart                  <---- failure
>> [2] [NTC] [EVT] [Feb 29 19:32:09] event_new_video FPS 2
>> [2] [NTC] [EVT] [Feb 29 19:32:09] event_newfile: File of type 8 saved
>> to: /AJS2/AJS2_Data10/CCTV/201602/29/19/MD-2-0229-193209.avi
>> [2] [NTC] [ALL] [Feb 29 19:32:09] motion_detected: Motion detected -
>> starting event 1
>> [0] [ERR] [ALL] [Feb 29 19:33:09] main: Thread 1 - Watchdog timeout, did
>> NOT restart graceful,killing it!
>> [0] [NTC] [STR] [Feb 29 19:33:09] stream_stop: Closing motion-stream
>> listen socket & active motion-stream sockets
>> [0] [NTC] [STR] [Feb 29 19:33:09] stream_stop: Closed motion-stream
>> listen socket & active motion-stream sockets
>> [0] [NTC] [VID] [Feb 29 19:33:09] vid_close: Closing video device
>> /dev/video0
>> [1] [ERR] [VID] [Feb 29 19:33:09] v4l2_next: VIDIOC_DQBUF: Invalid argument
>> [0] [NTC] [ALL] [Feb 29 19:33:10] main: Motion thread 1 restart
>> [1] [NTC] [ALL] [Feb 29 19:33:10] motion_init: Thread 1 started , motion
>> detection Enabled
>> [1] [NTC] [VID] [Feb 29 19:33:10] vid_v4lx_start: Using videodevice
>> /dev/video0 and input -1
>> [1] [NTC] [VID] [Feb 29 19:33:10] v4l2_get_capability:
>> ------------------------
>>
>> Does anyone have any suggestions?
> Nothing has changed in the driver code for ages, so I think it is unlikely
> that that is the reason.
>
> Try to capture using qv4l2, one qv4l2 instance for each channel. If that works
> fine, then it is definitely not a driver/kernel issue. If that fails, then let me
> know and I can take a look.
>
> Regards,
>
> 	Hans
>
>
Hans,

Sorry for the long delay in responding. Only just got around to testing
qv4l2.

All was well with qv4l2 on 4 camera's each capturing 25fps. Then when I
activated the 5th camera it all went pear shaped.
One camera dies, the image on its screen freezes on the last good frame.
All the other cameras get corrupt screens like line sync is missing.
Horizontal lines everywhere. See
http://www.doom.talktalk.net/2016-03-13-124047_1152x864_scrot.png.

I have seen this effect 4 years ago using zoneminder. I had two camera
working fine in zoneminder with motion detect recording. Adding two more
caused the effect in the screen capture. Eventually I put it down to
Zoneminder being very CPU hungry event at the lowest framerate. I
switched to motion and it would happily run motion detect on 6 cameras
using about 15% on one CPU (Dual core AMD Athlon(tm) II X2 270u
Processor 1600Mhz). Both zoneminder and motion were using the same old
tw68 module from github.

I have set up motion to capture at a relative low 2fps, it is all I
need. Can I set qv4l2 to capture at a lower rate to see if it resolves
the problem?

Thanks,
Tony.





