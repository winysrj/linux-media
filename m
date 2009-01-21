Return-path: <linux-media-owner@vger.kernel.org>
Received: from njbrsmtp1.vzwmail.net ([66.174.76.155]:47216 "EHLO
	njbrsmtp1.vzwmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbZAUWHI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jan 2009 17:07:08 -0500
Received: from [75.216.227.37] (smtp.vzwmail.net [66.174.76.25])
	(authenticated bits=0)
	by njbrsmtp1.vzwmail.net (8.12.9/8.12.9) with ESMTP id n0LM6sFm023550
	for <linux-media@vger.kernel.org>; Wed, 21 Jan 2009 22:07:05 GMT
Message-ID: <49779CA2.8050608@vzwmail.net>
Date: Wed, 21 Jan 2009 15:07:30 -0700
From: "T.P. Reitzel" <4066724035@vzwmail.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: gspca_spca505
Content-Type: multipart/mixed;
 boundary="------------010007090106020406080806"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010007090106020406080806
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

OK, I've raised the level of debug to 15 as you requested. Personally, I 
hope the code for the internal capture card is still intact and bugs 
simply prevent its use. Time will tell. ;) Evidently Intel isn't much 
use as a source for documentation of equipment manufactured for them. I 
wonder who wrote the Windows driver for the chipset used in this camera, 
the chipset manufacturer? Somebody has the documentation and should be 
willing to release it after this number of years has elapsed. You 
developers know the process...so I HTH. I apologize for overlooking the 
debug level on the first go.

--------------010007090106020406080806
Content-Type: application/octet-stream;
 name="image.dat"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="image.dat"

AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
--------------010007090106020406080806
Content-Type: text/plain;
 name="kernel.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kernel.txt"

agpgart-amd64 0000:00:00.0: AGP 3.0 bridge
agpgart-amd64 0000:00:00.0: putting AGP V3 device into 8x mode
pci 0000:01:00.0: putting AGP V3 device into 8x mode
[drm] Setting GART location based on new memory map
[drm] Loading R300 Microcode
[drm] Num pipes: 1
[drm] writeback test succeeded in 1 usecs
usb 1-1: USB disconnect, address 4
usb 3-1: new full speed USB device using uhci_hcd and address 3
usb 3-1: configuration #1 chosen from 1 choice
gspca: probing 0733:0430
gspca: probe ok
usb 3-1: New USB device found, idVendor=0733, idProduct=0430
usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb 3-1: USB disconnect, address 3
gspca: device released
gspca: disconnect complete
usb 3-1: new full speed USB device using uhci_hcd and address 4
usb 3-1: configuration #1 chosen from 1 choice
gspca: probing 0733:0430
spca505: Initializing SPCA505
spca505: After vector read returns : 0x101 should be 0x0101
gspca: probe ok
usb 3-1: New USB device found, idVendor=0733, idProduct=0430
usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
gspca: hald-probe-vide open
gspca: open done
gspca: try fmt cap S505 10000x10000
gspca: hald-probe-vide close
gspca: close done

--------------010007090106020406080806--
