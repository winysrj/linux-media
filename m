Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep24.mx.upcmail.net ([62.179.121.44]:51093 "EHLO
	fep24.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3A1MFk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 07:05:40 -0500
Received: from edge04.upcmail.net ([192.168.13.239])
          by viefep17-int.chello.at
          (InterMail vM.8.01.05.05 201-2260-151-110-20120111) with ESMTP
          id <20130128120319.CNTX7658.viefep17-int.chello.at@edge04.upcmail.net>
          for <linux-media@vger.kernel.org>;
          Mon, 28 Jan 2013 13:03:19 +0100
Message-ID: <510668E3.8060603@hispeed.ch>
Date: Mon, 28 Jan 2013 13:02:43 +0100
From: Roland Scheidegger <rscheidegger_lists@hispeed.ch>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: terratec h5 rev. 3?
References: <50D3F5A8.5010903@hispeed.ch>
In-Reply-To: <50D3F5A8.5010903@hispeed.ch>
Content-Type: multipart/mixed;
 boundary="------------060601040804040503050004"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060601040804040503050004
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Am 21.12.2012 06:38, schrieb linux-media-owner@vger.kernel.org:
> Hi,
> 
> I've recently got a terratec h5 for dvb-c and thought it would be
> supported but it looks like it's a newer revision not recognized by em28xx.
> After using the new_id hack it gets recognized and using various htc
> cards (notably h5 or cinergy htc stick, cards 79 and 82 respectively) it
> seems to _nearly_ work but not quite (I was using h5 firmware for the
> older version). Tuning, channel scan works however tv (or dvb radio)
> does not, since it appears the error rate is going through the roof
> (with some imagination it is possible to see some parts of the picture
> sometimes and hear some audio pieces).

Ok I have received a replacement now and I can confirm this stick in
fact just works like the same as the older versions (I guess maybe the
first one had bad solder point?). I can't judge signal sensitivity or
anything like that (the snr values are rather humorous) but it's
definitely good enough now with no reception issues. The IR receiver is
another matter and I was unsuccesful in making it work for now (I guess
noone got it working with the old versions neither as it lacks the ir
entries).
So could this card be added? I've added the trivial patch.

Roland



--------------060601040804040503050004
Content-Type: text/x-patch;
 name="h5rev3.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="h5rev3.diff"

--- linux/drivers/media/usb/em28xx/em28xx-cards.c	2013-01-23 04:33:31.145158768 +0100
+++ linux/drivers/media/usb/em28xx/em28xx-cards.c	2013-01-23 04:33:31.158158768 +0100
@@ -2080,6 +2080,8 @@
 			.driver_info = EM2884_BOARD_TERRATEC_H5 },
 	{ USB_DEVICE(0x0ccd, 0x10ad),	/* H5 Rev. 2 */
 			.driver_info = EM2884_BOARD_TERRATEC_H5 },
+	{ USB_DEVICE(0x0ccd, 0x10b6),	/* H5 Rev. 3 */
+			.driver_info = EM2884_BOARD_TERRATEC_H5 },			
 	{ USB_DEVICE(0x0ccd, 0x0084),
 			.driver_info = EM2860_BOARD_TERRATEC_AV350 },
 	{ USB_DEVICE(0x0ccd, 0x0096),


--------------060601040804040503050004--
