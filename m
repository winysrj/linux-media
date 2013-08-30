Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:28019 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560Ab3H3L2y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 07:28:54 -0400
From: Dinesh Ram <dinram@cisco.com>
To: linux-media@vger.kernel.org
Cc: dinesh.ram@cern.ch
Subject: [PATCH 0/6] si4713 : USB driver 
Date: Fri, 30 Aug 2013 13:28:18 +0200
Message-Id: <1377862104-15429-1-git-send-email-dinram@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a follow-up to the patch-series mailed on 21-Agu-2013 to the mailing list.

Please note that I will not be reachable at the cisco email id anymore. So please
send you comments and suggestions to my private email : dinesh.ram@cern.ch

All the patches are on top of the latest version of the media-git tree as 
on 30-August-2013 (10:30 Europe time)

The main difference to the aforementioned patch series is that, in this series the 
radio-i2c-si4713.c is renamed to a more appropriate one - radio-platform-si4713.c. 
Ofcourse, this also involvs corrosponding changes in the Makefile and Kconfig 
in drivers/media/radio/si4713.

An entry is also added to the MAINTAINERS file.

This patch series adds USB support for the SiLabs development board 
which contains the Si4713 FM transmitter chip. 

This device can transmit audio through FM. 
It can transmit RDS and RBDS signals as well.

Documentation for this product can be accessed here :
http://www.silabs.com/products/audiovideo/fmtransmitters/Pages/si471213.aspx


In the source tree, drivers/media/radio has been reorganized to include a new folder 
drivers/media/radio/si4713 which  contains all the si4713 related files.

Modified and renamed files :
-----------------------------------
drivers/media/radio/si4713-i2c.c ==> drivers/media/radio/si4713/si4713.c
drivers/media/radio/si4713-i2c.h ==> drivers/media/radio/si4713/si4713.h
drivers/media/radio/radio-si4713.c ==> drivers/media/radio/si4713/radio-platform-si4713.c

New files :
-------------
drivers/media/radio/si4713/radio-usb-si4713.c

The existing i2c driver has been modified to add support for cases where the interrupt 
is not enabled. 
Checks have been introduced in several places in the code to test if an interrupt is set or not. 
The development board is plugged into the host through USB and does not use interrupts. 
To get a valid response, within a specified timeout, the device is polled instead.


The USB driver has been developed by analyzing the the USB traffic obtained by sniffing the USB bus.
A bunch of commands are sent during device startup, the specifics of which are not obvious.
Nevertheless they seem to be necessary for the proper fuctioning of the device.

Note : The i2c driver assumes a 2-wire bus mode.

