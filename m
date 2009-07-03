Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n637kfOB018994
	for <video4linux-list@redhat.com>; Fri, 3 Jul 2009 03:46:41 -0400
Received: from smtp01.udag.de (smtp01.udag.de [89.31.137.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n637jG2m031680
	for <video4linux-list@redhat.com>; Fri, 3 Jul 2009 03:45:17 -0400
Received: from baldur.czar (bwl250.internetdsl.tpnet.pl [83.18.219.250])
	by smtp01.udag.de (Postfix) with ESMTP id 737959C41A
	for <video4linux-list@redhat.com>;
	Fri,  3 Jul 2009 09:45:21 +0200 (CEST)
From: Wally <wally@voosen.eu>
To: video4linux-list@redhat.com
Date: Fri, 3 Jul 2009 09:45:07 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907030945.08063.wally@voosen.eu>
Subject: microscope camera eb1a:2750 eMPIA
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


I want to use a microscope camera with Opensuse linux.

Actually i get a green screen on mplayer and black with tiny white stripes 
on other applications. I can see that the camera response to light chnges 
here. 


The device is identified by lsusb as 
ID eb1a:2750 eMPIA Technology, Inc. ECS Elitegroup G220 integrated webcam

the em28xx kernelmodule driver are loaded and reports dmesg :

usb 5-2: new high speed USB device using ehci_hcd and address 2
usb 5-2: configuration #1 chosen from 1 choice
usb 5-2: New USB device found, idVendor=eb1a, idProduct=2750
usb 5-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
Linux video capture interface: v2.00
em28xx v4l2 driver version 0.0.1 loaded
em28xx: new video device (eb1a:2750): interface 0, class 255
em28xx: device is attached to a USB 2.0 bus
em28xx #0: Alternate settings: 8
em28xx #0: Alternate setting 0, max size= 0
em28xx #0: Alternate setting 1, max size= 0
em28xx #0: Alternate setting 2, max size= 1448
em28xx #0: Alternate setting 3, max size= 2048
em28xx #0: Alternate setting 4, max size= 2304
em28xx #0: Alternate setting 5, max size= 2580
em28xx #0: Alternate setting 6, max size= 2892
em28xx #0: Alternate setting 7, max size= 3072
em28xx #0: V4L2 device registered as /dev/video0
em28xx #0: Found Huaqi DLCW-130
usbcore: registered new interface driver em28xx

I tried to use modprobe options card=42 , but this doesn't have any effect.
i did this in /etc/modprobe.conf.local and /etc/modprobe.conf

Also added a file to /etc/modprobe.d with the options content

I am using: 
em28xx-new-kmp-pae-20090403_2.6.27.23_0.1-1.3.i586


regards wally

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
