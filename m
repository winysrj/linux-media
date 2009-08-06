Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n76Mu2dV014176
	for <video4linux-list@redhat.com>; Thu, 6 Aug 2009 18:56:02 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n76MtlRQ018750
	for <video4linux-list@redhat.com>; Thu, 6 Aug 2009 18:55:47 -0400
Received: from wwwrun by mail.phosco.info with local (Exim 4.69)
	(envelope-from <phosco@gmx.de>) id 1MZBs6-0001Ao-Sv
	for video4linux-list@redhat.com; Fri, 07 Aug 2009 00:55:42 +0200
Message-ID: <20090807005542.962158ltxqad3b0g@horde.phosco.info>
Date: Fri, 07 Aug 2009 00:55:42 +0200
From: =?utf-8?b?QW5kcsOp?= Rothe <arothe@phosco.info>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: New device
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

Hi,

I have bought a new video grabber device. It is an USB device from Q-sonic.
The device is not successfully detected, so there is only an input=0  
available, the S-Video connector. But I get only black-white video,  
the other connector (Composite) delivers color video on Windows, but I  
cannot switch the driver to it.

em28xx v4l2 driver version 0.1.0 loaded
em28xx new video device (eb1a:2820): interface 0, class 255
em28xx Doesn't have usb audio class
em28xx #0: Alternate settings: 8
em28xx #0: Alternate setting 0, max size= 0
em28xx #0: Alternate setting 1, max size= 1024
em28xx #0: Alternate setting 2, max size= 1448
em28xx #0: Alternate setting 3, max size= 2048
em28xx #0: Alternate setting 4, max size= 2304
em28xx #0: Alternate setting 5, max size= 2580
em28xx #0: Alternate setting 6, max size= 2892
em28xx #0: Alternate setting 7, max size= 3072
em28xx #0: em28xx chip ID = 18
saa7115' 7-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
em28xx #0: found i2c device @ 0x4a [saa7113h]
em28xx #0: Your board has no unique USB ID.
em28xx #0: A hint were successfully done, based on i2c devicelist hash.
em28xx #0: This method is not 100% failproof.
em28xx #0: If the board were missdetected, please email this log to:
em28xx #0: 	V4L Mailing List  <video4linux-list@redhat.com>
em28xx #0: Board detected as PointNix Intra-Oral Camera
em28xx #0: Registering snapshot button...
input: em28xx snapshot button as  
/devices/pci0000:00/0000:00:1d.7/usb2/2-1/input/input9
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
em28xx #0: Found PointNix Intra-Oral Camera
usbcore: registered new interface driver em28xx
em28xx-audio.c: probing for em28x1 non standard usbaudio
em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
Em28xx: Initialized (Em28xx Audio Extension) extension

Thank you
Andre

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
