Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:20340 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab3HUI3p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 04:29:45 -0400
From: Dinesh Ram <dinram@cisco.com>
To: linux-media@vger.kernel.org
Cc: eduardo.valentin@nokia.com
Subject: [RFC PATCH 0/5] si4713 : USB driver
Date: Wed, 21 Aug 2013 10:19:46 +0200
Message-Id: <1377073191-29197-1-git-send-email-dinram@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds USB support for the SiLabs development board 
which contains the Si4713 FM transmitter chip. 
This device can transmit audio through FM. 
It can transmit RDS and RBDS signals as well.

Documentation for this product can be accessed here :
http://www.silabs.com/products/audiovideo/fmtransmitters/Pages/si471213.aspx

Note : All the patches are on top of the latest version of the media-git tree as 
on 20-August-2013 (15:30 Europe time)

In the source tree, drivers/media/radio has been reorganized to include a new folder 
drivers/media/radio/si4713 which  contains all the si4713 related files.

Modified and renamed files :
-----------------------------------
drivers/media/radio/si4713-i2c.c ==> drivers/media/radio/si4713/si4713.c
drivers/media/radio/si4713-i2c.h ==> drivers/media/radio/si4713/si4713.h
drivers/media/radio/radio-si4713.c ==> drivers/media/radio/si4713/radio-i2c-si4713.c

New files :
-------------
drivers/media/radio/si4713/radio-usb-si4713.c

The existing i2c driver has been modified to add support for cases where the interrupt 
is not enabled. 
Checks have been introduced at several places in the code to test if an interrupt is set or not. 
The development board is plugged into the host through USB and does not use interrupts. 
To get a valid response, within a specified timeout, the device is polled instead.

The USB driver has been developed by analyzing the the USB traffic obtained by sniffing the USB bus.
A sequence of commands are sent during device startup, the specifics of which are not obvious.
Nevertheless they seem to be necessary for the proper fuctioning of the device.

The i2c driver assumes a 2-wire bus mode.

