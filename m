Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBV0l6qw000479
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 19:47:06 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.170])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBV0kYWN028866
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 19:46:34 -0500
Received: by wf-out-1314.google.com with SMTP id 25so5436195wfc.6
	for <video4linux-list@redhat.com>; Tue, 30 Dec 2008 16:46:34 -0800 (PST)
Message-ID: <c785bba30812301646vf7572dcua9361eb10ec58716@mail.gmail.com>
Date: Tue, 30 Dec 2008 17:46:34 -0700
From: "Paul Thomas" <pthomas8589@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: em28xx issues
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

Hello,

I'm trying to get a Empia EM2860 board working (specifically the "DVD
Maker USB 2.0"). Everything seems OK to start with, when I plug in the
board I get a reasonable dmesg (posted at the bottom).

I then try to use cheese or camstream and all I get is a black screen
or a black screen with a green stripe at the bottom. I've tested it
with a Windows box so I know there's nothing wrong with the video
input.

Are cheese & camstream the appropriate v4l2 frontends for testing
with. Is there something more low level I could test with?

I using Fedora 10, my kernel version is 2.6.27.9-159.fc10.i686.

Thanks in advance.

-Paul

usb 1-2: new high speed USB device using ehci_hcd and address 20
usb 1-2: configuration #1 chosen from 1 choice
em28xx new video device (eb1a:2860): interface 0, class 255
em28xx Doesn't have usb audio class
em28xx #0: Alternate settings: 8
em28xx #0: Alternate setting 0, max size= 0
em28xx #0: Alternate setting 1, max size= 0
em28xx #0: Alternate setting 2, max size= 1448
em28xx #0: Alternate setting 3, max size= 2048
em28xx #0: Alternate setting 4, max size= 2304
em28xx #0: Alternate setting 5, max size= 2580
em28xx #0: Alternate setting 6, max size= 2892
em28xx #0: Alternate setting 7, max size= 3072
em28xx #0: chip ID is em2860
saa7115' 1-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
em28xx #0: found i2c device @ 0x4a [saa7113h]
em28xx #0: Your board has no unique USB ID.
em28xx #0: A hint were successfully done, based on i2c devicelist hash.
em28xx #0: This method is not 100% failproof.
em28xx #0: If the board were missdetected, please email this log to:
em28xx #0: 	V4L Mailing List  <video4linux-list@redhat.com>
em28xx #0: Board detected as PointNix Intra-Oral Camera
em28xx #0: Registering snapshot button...
input: em28xx snapshot button as
/devices/pci0000:00/0000:00:1d.7/usb1/1-2/input/input16
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
em28xx-audio.c: probing for em28x1 non standard usbaudio
em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
em28xx #0: Found PointNix Intra-Oral Camera
usb 1-2: New USB device found, idVendor=eb1a, idProduct=2860
usb 1-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
