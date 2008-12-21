Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBLNX1cx030179
	for <video4linux-list@redhat.com>; Sun, 21 Dec 2008 18:33:01 -0500
Received: from h1431883.stratoserver.net (mizapf.de [85.214.33.99])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBLNW02j023213
	for <video4linux-list@redhat.com>; Sun, 21 Dec 2008 18:32:01 -0500
Received: from [192.168.71.7] (p4FDC6362.dip.t-dialin.net [79.220.99.98])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by h1431883.stratoserver.net (Postfix) with ESMTP id 732FB15EA6F8
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 00:31:59 +0100 (CET)
Message-ID: <494ED217.4000807@mizapf.eu>
Date: Mon, 22 Dec 2008 00:32:39 +0100
From: Michael Zapf <newsmail08@mizapf.eu>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Subject: USBVision: Camtel USB Video Genie Supported?
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

I somehow can't get the USB Video Genie to work with VLC or xawtv, so I
suppose the problem starts in v4l. The device is a small USB box with a
grey button and a S-Video and a Composite input jack. Plugging the USB
box in, I get

kernel: usb 6-2: new full speed USB device using uhci_hcd and address 2
kernel: usb 6-2: new device found, idVendor=0573, idProduct=0003
kernel: usb 6-2: new device strings: Mfr=0, Product=0, SerialNumber=0
kernel: usb 6-2: configuration #1 chosen from 1 choice
kernel: Linux video capture interface: v2.00
kernel: usbvision_probe: USBGear USBG-V1 resp. HAMA USB found
kernel: USBVision[0]: registered USBVision Video device /dev/video0 [v4l2]
kernel: USBVision[0]: registered USBVision VBI device /dev/vbi0 [v4l2]
(Not Working Yet!)
kernel: usbcore: registered new interface driver usbvision
kernel: USBVision USB Video Device Driver for Linux : 0.9.9
kernel: saa7115 1-0024: saa7111 found (1f7111d1e200000) @ 0x48
(usbvision #0)

That's all I find in the log. From v4l-info I get

### v4l2 device info [/dev/video0] ###
general info
    VIDIOC_QUERYCAP
        driver                  : "USBVision"
        card                    : "USBGear USBG-V1 resp. HAMA USB"
        bus_info                : "6-2"
        version                 : 0.9.9
        capabilities            : 0x5020001
[VIDEO_CAPTURE,AUDIO,READWRITE,STREAMING]

...

VLC does not open a window when I select the device for play; doing a
plain "cat /dev/video0" does not produce anything. Tried the different
inputs, no result. Am I missing something here? Do I require a special
firmware for this device?

Thanks for any help,

Michael

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
