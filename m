Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n297bTv8014869
	for <video4linux-list@redhat.com>; Mon, 9 Mar 2009 03:37:29 -0400
Received: from mail-bw0-f160.google.com (mail-bw0-f160.google.com
	[209.85.218.160])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n297bBce023418
	for <video4linux-list@redhat.com>; Mon, 9 Mar 2009 03:37:11 -0400
Received: by bwz4 with SMTP id 4so1053986bwz.3
	for <video4linux-list@redhat.com>; Mon, 09 Mar 2009 00:37:10 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 9 Mar 2009 13:07:10 +0530
Message-ID: <77ca8eab0903090037x6e0e2705sfe62940141780e7e@mail.gmail.com>
From: amol verule <amol.debian@gmail.com>
To: amol verule <averule@gmail.com>, video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: 
Subject: video4linux-list@redhat.com
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

hi,
 i am having iball 9.0 device and getting error while opening it as
#camorama -D
VIDIOCGCAP  --  could not get camera capabilities, exiting.....

#ls -l /dev/video0
crw-rw---- 1 root video 81, 0 2009-03-09 18:16 /dev/video0

 this is dmesg when i plugged in camera
usb 1-1: new full speed USB device using uhci_hcd and address 4
usb 1-1: configuration #1 chosen from 1 choice
Linux video capture interface: v2.00
sn9c102: V4L2 driver for SN9C1xx PC Camera Controllers v1:1.44
usb 1-1: SN9C120 PC Camera Controller detected (vid:pid 0x0C45:0x6130)
usb 1-1: MI-0360 image sensor detected
usb 1-1: Initialization succeeded
usb 1-1: V4L2 device registered as /dev/video0
usb 1-1: Optional device control through 'sysfs' interface disabled
usbcore: registered new interface driver sn9c102
usbcore: registered new interface driver gspca
/usr/src/modules/gspca/gspca_core.c: gspca driver 01.00.20 registered
...
what is actual problem even though driver is available and it created
/dev/video0 ..i am not able to use webcam..
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
