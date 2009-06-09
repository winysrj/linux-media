Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n59JwIMb021686
	for <video4linux-list@redhat.com>; Tue, 9 Jun 2009 15:58:18 -0400
Received: from out2.smtp.messagingengine.com (out2.smtp.messagingengine.com
	[66.111.4.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n59Jw2rM008342
	for <video4linux-list@redhat.com>; Tue, 9 Jun 2009 15:58:02 -0400
Received: from compute2.internal (compute2.internal [10.202.2.42])
	by out1.messagingengine.com (Postfix) with ESMTP id D16B435F7D1
	for <video4linux-list@redhat.com>; Tue,  9 Jun 2009 15:58:01 -0400 (EDT)
Message-Id: <1244577481.32457.1319583459@webmail.messagingengine.com>
From: "Kay Wrobel" <kwrobel@letterboxes.org>
To: "V4L Mailing List" <video4linux-list@redhat.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Date: Tue, 09 Jun 2009 14:58:01 -0500
Subject: KWorld VS-USB2800D recognized as PointNix Intra-Oral Camera - No
 Composite Input
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

Hi video4linux list,

This may be something that has been asked in the past. I have a KWorld
VS-USB2800D video capture device and my Ubuntu 9.04 Jaunty recognizes it
as a PointNix Intra-Oral Camera. The only thing that works is the
S-Video input. However, I'd like to use the Composite input (regular
yellow RCA). So here's the dmesg:

[18325.975026] usb 3-2.2: USB disconnect, address 7
[18406.553718] usb 3-2.2: new full speed USB device using uhci_hcd and
address 8
[18406.655706] usb 3-2.2: not running at top speed; connect to a high
speed hub
[18406.664296] usb 3-2.2: configuration #1 chosen from 1 choice
[18406.666788] hub 3-2.2:1.0: USB hub found
[18406.668783] hub 3-2.2:1.0: 4 ports detected
[20149.760030] usb 1-6: new high speed USB device using ehci_hcd and
address 5
[20149.892966] usb 1-6: configuration #1 chosen from 1 choice
[20149.954275] Linux video capture interface: v2.00
[20149.964580] em28xx v4l2 driver version 0.1.0 loaded
[20149.964632] em28xx new video device (eb1a:2860): interface 0, class
255
[20149.964640] em28xx Doesn't have usb audio class
[20149.964645] em28xx #0: Alternate settings: 8
[20149.964649] em28xx #0: Alternate setting 0, max size= 0
[20149.964653] em28xx #0: Alternate setting 1, max size= 0
[20149.964657] em28xx #0: Alternate setting 2, max size= 1448
[20149.964661] em28xx #0: Alternate setting 3, max size= 2048
[20149.964666] em28xx #0: Alternate setting 4, max size= 2304
[20149.964670] em28xx #0: Alternate setting 5, max size= 2580
[20149.964674] em28xx #0: Alternate setting 6, max size= 2892
[20149.964678] em28xx #0: Alternate setting 7, max size= 3072
[20149.964926] em28xx #0: chip ID is em2860
[20150.196540] em28xx #0: board has no eeprom
[20150.210897] em28xx #0: found i2c device @ 0x4a [saa7113h]
[20150.252142] em28xx #0: Your board has no unique USB ID.
[20150.252150] em28xx #0: A hint were successfully done, based on i2c
devicelist hash.
[20150.252155] em28xx #0: This method is not 100% failproof.
[20150.252160] em28xx #0: If the board were missdetected, please email
this log to:
[20150.252164] em28xx #0:       V4L Mailing List 
<video4linux-list@redhat.com>
[20150.252170] em28xx #0: Board detected as PointNix Intra-Oral Camera
[20150.252175] em28xx #0: Registering snapshot button...
[20150.252411] input: em28xx snapshot button as
/devices/pci0000:00/0000:00:1d.7/usb1/1-6/input/input6
[20150.643094] saa7115' 4-0025: saa7113 found (1f7113d0e100000) @ 0x4a
(em28xx #0)
[20151.920343] em28xx #0: V4L2 device registered as /dev/video0 and
/dev/vbi0
[20151.920351] em28xx #0: Found PointNix Intra-Oral Camera
[20151.920395] usbcore: registered new interface driver em28xx
[20151.927004] em28xx-audio.c: probing for em28x1 non standard usbaudio
[20151.927009] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[20151.927534] Em28xx: Initialized (Em28xx Audio Extension) extension

Notice how it only generates /dev/video0 and /dev/vbi0. I would have
expected to see two additional devices, like /dev/video1 and /dev/vbi1.

Maybe the detected Intra-Oral camera doesn't have that input, but the
KWorld VS-USB2008D does. What can be done to make the driver recognize
the Composite input correctly?

Thanks for any help...
-- 
  Kay Wrobel
  kwrobel@letterboxes.org

-- 
http://www.fastmail.fm - IMAP accessible web-mail

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
