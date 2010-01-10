Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:62018 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab0AJQiK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 11:38:10 -0500
Message-ID: <4B4A0268.20104@freemail.hu>
Date: Sun, 10 Jan 2010 17:38:00 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: gspca_sunplus problem: more than one device is created
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I tried the gspca_sunplus driver from http://linuxtv.org/hg/~jfrancois/gspca/
rev 13915 on top of Linux kernel 2.6.32. When I plug the Trust 610 LCD PowerC@m Zoom
device in webcam mode (0x06d6:0x0031) then two devices are created: /dev/video0
and /dev/video1:

[31636.528184] usb 3-2: new full speed USB device using uhci_hcd and address 5
[31636.740722] usb 3-2: New USB device found, idVendor=06d6, idProduct=0031
[31636.740744] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[31636.740760] usb 3-2: Product: Trust 610 LCD POWERC@M ZOOM
[31636.740772] usb 3-2: Manufacturer: Trust
[31636.744229] usb 3-2: configuration #1 chosen from 1 choice
[31636.747584] gspca: probing 06d6:0031
[31636.760176] gspca: video0 created
[31636.760643] gspca: probing 06d6:0031
[31636.772063] gspca: video1 created

The /dev/video0 is working correctly but the /dev/video1 just causes error:
$ ./svv -d /dev/video1
raw pixfmt: JPEG 464x480
pixfmt: RGB3 464x480
mmap method
VIDIOC_STREAMON error 5, Input/output error

Here is the USB descriptor of the device:

Trust 610 LCD POWERC@M ZOOM
Manufacturer: Trust
Speed: 12Mb/s (full)
USB Version:  1.00
Device Class: 00(>ifc )
Device Subclass: 00
Device Protocol: 00
Maximum Default Endpoint Size: 8
Number of Configurations: 1
Vendor Id: 06d6
Product Id: 0031
Revision Number:  1.00

Config Number: 1
	Number of Interfaces: 2
	Attributes: 80
	MaxPower Needed: 500mA

	Interface Number: 0
		Name: sunplus
		Alternate Number: 0
		Class: ff(vend.)
		Sub Class: 00
		Protocol: 00
		Number of Endpoints: 1

			Endpoint Address: 81
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 0
			Interval: 1ms

	Interface Number: 0
		Name: sunplus
		Alternate Number: 1
		Class: ff(vend.)
		Sub Class: 00
		Protocol: 00
		Number of Endpoints: 1

			Endpoint Address: 81
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 128
			Interval: 1ms

	Interface Number: 0
		Name: sunplus
		Alternate Number: 2
		Class: ff(vend.)
		Sub Class: 00
		Protocol: 00
		Number of Endpoints: 1

			Endpoint Address: 81
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 384
			Interval: 1ms

	Interface Number: 0
		Name: sunplus
		Alternate Number: 3
		Class: ff(vend.)
		Sub Class: 00
		Protocol: 00
		Number of Endpoints: 1

			Endpoint Address: 81
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 512
			Interval: 1ms

	Interface Number: 0
		Name: sunplus
		Alternate Number: 4
		Class: ff(vend.)
		Sub Class: 00
		Protocol: 00
		Number of Endpoints: 1

			Endpoint Address: 81
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 640
			Interval: 1ms

	Interface Number: 0
		Name: sunplus
		Alternate Number: 5
		Class: ff(vend.)
		Sub Class: 00
		Protocol: 00
		Number of Endpoints: 1

			Endpoint Address: 81
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 768
			Interval: 1ms

	Interface Number: 0
		Name: sunplus
		Alternate Number: 6
		Class: ff(vend.)
		Sub Class: 00
		Protocol: 00
		Number of Endpoints: 1

			Endpoint Address: 81
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 896
			Interval: 1ms

	Interface Number: 0
		Name: sunplus
		Alternate Number: 7
		Class: ff(vend.)
		Sub Class: 00
		Protocol: 00
		Number of Endpoints: 1

			Endpoint Address: 81
			Direction: in
			Attribute: 1
			Type: Isoc
			Max Packet Size: 1023
			Interval: 1ms

	Interface Number: 1
		Name: sunplus
		Alternate Number: 0
		Class: ff(vend.)
		Sub Class: 00
		Protocol: 00
		Number of Endpoints: 3

			Endpoint Address: 82
			Direction: in
			Attribute: 2
			Type: Bulk
			Max Packet Size: 64
			Interval: 0ms

			Endpoint Address: 03
			Direction: out
			Attribute: 2
			Type: Bulk
			Max Packet Size: 64
			Interval: 0ms

			Endpoint Address: 84
			Direction: in
			Attribute: 3
			Type: Int.
			Max Packet Size: 1
			Interval: 1ms

Regards,

	Márton Németh
