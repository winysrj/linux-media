Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6TDv0rO028531
	for <video4linux-list@redhat.com>; Wed, 29 Jul 2009 09:57:00 -0400
Received: from mail-gx0-f221.google.com (mail-gx0-f221.google.com
	[209.85.217.221])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n6TDukSk027517
	for <video4linux-list@redhat.com>; Wed, 29 Jul 2009 09:56:46 -0400
Received: by gxk21 with SMTP id 21so1459010gxk.3
	for <video4linux-list@redhat.com>; Wed, 29 Jul 2009 06:56:46 -0700 (PDT)
Message-ID: <4A705512.1000808@gmail.com>
Date: Wed, 29 Jul 2009 09:56:34 -0400
From: "buhochileno@gmail.com" <buhochileno@gmail.com>
MIME-Version: 1.0
To: V4L Mailing List <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: ROBOTIS Wireless Camera Recognized as PointNix Intra-Oral Camera
 - No Composite, No Turner
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

This problem is simillar to the one with the KWorld VS-USB2800D that 
previously don't recognize the composite input, in this case is the 
ROBOTIS Bioloid Expert Kit Wireless Camera Set that is recognized by my 
Fedora 10 (kernel  2.6.27.15-170.2.24) as "PointNix Intra-Oral Camera", 
but xawtv or other software just show me S-Video as input and in this 
case this capture device have a Composite and also a Turner (since it is 
a wireless receiver capture device it use channels 1,2,3 and 4 to get 
the video from the camera)...Here is what my kernel see:

usb 1-3: new high speed USB device using ehci_hcd and address 5
usb 1-3: configuration #1 chosen from 1 choice
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
saa7115' 0-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
em28xx #0: found i2c device @ 0x4a [saa7113h]
em28xx #0: Your board has no unique USB ID.
em28xx #0: A hint were successfully done, based on i2c devicelist hash.
em28xx #0: This method is not 100% failproof.
em28xx #0: If the board were missdetected, please email this log to:
em28xx #0:     V4L Mailing List  <video4linux-list@redhat.com>
em28xx #0: Board detected as PointNix Intra-Oral Camera
em28xx #0: Registering snapshot button...
input: em28xx snapshot button as 
/devices/pci0000:00/0000:00:1d.7/usb1/1-3/input/input11
em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
em28xx-audio.c: probing for em28x1 non standard usbaudio
em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
em28xx #0: Found PointNix Intra-Oral Camera
usb 1-3: New USB device found, idVendor=eb1a, idProduct=2860
usb 1-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0


Thanks,

Mauricio

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
