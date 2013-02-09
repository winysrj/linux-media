Return-path: <linux-media-owner@vger.kernel.org>
Received: from fep27.mx.upcmail.net ([62.179.121.47]:34439 "EHLO
	fep27.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947469Ab3BIAde (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2013 19:33:34 -0500
Message-ID: <51159418.6040608@hispeed.ch>
Date: Sat, 09 Feb 2013 01:11:04 +0100
From: Roland Scheidegger <rscheidegger_lists@hispeed.ch>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: terratec h5 rev. 3?
References: <50D3F5A8.5010903@hispeed.ch> <510668E3.8060603@hispeed.ch> <20130208131742.32ab0750@redhat.com>
In-Reply-To: <20130208131742.32ab0750@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------080003000907030301000509"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080003000907030301000509
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Am 08.02.2013 16:17, schrieb Mauro Carvalho Chehab:
> Em Mon, 28 Jan 2013 13:02:43 +0100
> Roland Scheidegger <rscheidegger_lists@hispeed.ch> escreveu:
> 
>> From: Roland Scheidegger <rscheidegger_lists@hispeed.ch>
>> To: linux-media@vger.kernel.org
>> Subject: Re: terratec h5 rev. 3?
>> Date: Mon, 28 Jan 2013 13:02:43 +0100
>> Sender: linux-media-owner@vger.kernel.org
>> User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
>>
>> Am 21.12.2012 06:38, schrieb linux-media-owner@vger.kernel.org:
>>> Hi,
>>>
>>> I've recently got a terratec h5 for dvb-c and thought it would be
>>> supported but it looks like it's a newer revision not recognized by em28xx.
>>> After using the new_id hack it gets recognized and using various htc
>>> cards (notably h5 or cinergy htc stick, cards 79 and 82 respectively) it
>>> seems to _nearly_ work but not quite (I was using h5 firmware for the
>>> older version). Tuning, channel scan works however tv (or dvb radio)
>>> does not, since it appears the error rate is going through the roof
>>> (with some imagination it is possible to see some parts of the picture
>>> sometimes and hear some audio pieces).  
>>
>> Ok I have received a replacement now and I can confirm this stick in
>> fact just works like the same as the older versions (I guess maybe the
>> first one had bad solder point?). I can't judge signal sensitivity or
>> anything like that (the snr values are rather humorous) but it's
>> definitely good enough now with no reception issues. The IR receiver is
>> another matter and I was unsuccesful in making it work for now (I guess
>> noone got it working with the old versions neither as it lacks the ir
>> entries).
>> So could this card be added? I've added the trivial patch.
> 
> Could you please add your Signed-of-by: to the patch?

Sure. Here's this masterpiece of code again :-).

Roland



--------------080003000907030301000509
Content-Type: text/x-patch;
 name="0001-media-em28xx-add-usb-id-for-terratec-h5-rev.-3.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename*0="0001-media-em28xx-add-usb-id-for-terratec-h5-rev.-3.patch"

>From 03b68ff4f13736cf59140e090bf1609accd8dcb0 Mon Sep 17 00:00:00 2001
From: Roland Scheidegger <rscheidegger_lists@hispeed.ch>
Date: Sat, 9 Feb 2013 01:08:55 +0100
Subject: [PATCH] [media] em28xx: add usb id for terratec h5 rev. 3
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>

Seems to work just the same as older revisions.

Signed-off-by: Roland Scheidegger <rscheidegger_lists@hispeed.ch>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    2 ++
 1 Datei geändert, 2 Zeilen hinzugefügt(+)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 0a5aa62..5b24594 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2080,6 +2080,8 @@ struct usb_device_id em28xx_id_table[] = {
 			.driver_info = EM2884_BOARD_TERRATEC_H5 },
 	{ USB_DEVICE(0x0ccd, 0x10ad),	/* H5 Rev. 2 */
 			.driver_info = EM2884_BOARD_TERRATEC_H5 },
+	{ USB_DEVICE(0x0ccd, 0x10b6),	/* H5 Rev. 3 */
+			.driver_info = EM2884_BOARD_TERRATEC_H5 },			
 	{ USB_DEVICE(0x0ccd, 0x0084),
 			.driver_info = EM2860_BOARD_TERRATEC_AV350 },
 	{ USB_DEVICE(0x0ccd, 0x0096),
-- 
1.7.10.4


--------------080003000907030301000509--
