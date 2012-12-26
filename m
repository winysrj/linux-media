Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43891 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab2LZSzU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Dec 2012 13:55:20 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so4475249eek.33
        for <linux-media@vger.kernel.org>; Wed, 26 Dec 2012 10:55:18 -0800 (PST)
Message-ID: <50DB482A.60302@googlemail.com>
Date: Wed, 26 Dec 2012 19:55:38 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx: module parameter prefer_bulk ?
References: <50D83BB2.4070308@googlemail.com> <20121224131625.128de19c@redhat.com>
In-Reply-To: <20121224131625.128de19c@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------020403070109000109070201"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020403070109000109070201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Am 24.12.2012 16:16, schrieb Mauro Carvalho Chehab:
> Em Mon, 24 Dec 2012 12:25:38 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
>
>> Hi Mauro,
>>
>> now that we prefer bulk transfers for webcams and isoc transfers for TV,
>> I wonder if prefer_bulk is still a good name for this module parameter.
>> What about something like 'usb_mode', 'usb_xfer_mode' or
>> 'frame_xfer_mode' with 0=auto, 1=prefer isoc, 2=prefer bulk ?
> while keeping it as-is is not bad, IMHO, we can change it if people prefer
> renaming it.
>
> usb_xfer_mode sounds good for me. Feel free to submit a patch if you want.

See attachment.

Regards,
Frank



--------------020403070109000109070201
Content-Type: text/x-patch;
 name="0001-em28xx-rename-module-parameter-prefer_bulk-to-usb_xf.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename*0="0001-em28xx-rename-module-parameter-prefer_bulk-to-usb_xf.pa";
 filename*1="tch"

>From b95be429befa40264eb29a63310cc0ab0bca1090 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Date: Wed, 26 Dec 2012 19:12:37 +0100
Subject: [PATCH] em28xx: rename module parameter prefer_bulk to usb_xfer_mode
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since we have now 3 modes (auto/isoc/bulk), usb_xfer_mode is more suitable than prefer_bulk.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |   11 ++++++-----
 1 Datei geändert, 6 Zeilen hinzugefügt(+), 5 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index a0eed7e..c5e1d2d 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -61,9 +61,10 @@ static unsigned int card[]     = {[0 ... (EM28XX_MAXBOARDS - 1)] = UNSET };
 module_param_array(card,  int, NULL, 0444);
 MODULE_PARM_DESC(card,     "card type");
 
-static int prefer_bulk = -1;
-module_param(prefer_bulk, int, 0444);
-MODULE_PARM_DESC(prefer_bulk, "prefer USB bulk transfers (-1 = auto, 0 = isoc, 1 = bulk)");
+static int usb_xfer_mode = -1;
+module_param(usb_xfer_mode, int, 0444);
+MODULE_PARM_DESC(usb_xfer_mode,
+		 "USB transfer mode for frame data (-1 = auto, 0 = prefer isoc, 1 = prefer bulk)");
 
 
 /* Bitmask marking allocated devices from 0 to EM28XX_MAXBOARDS - 1 */
@@ -3399,13 +3400,13 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		goto unlock_and_free;
 	}
 
-	if (prefer_bulk < 0) {
+	if (usb_xfer_mode < 0) {
 		if (dev->board.is_webcam)
 			try_bulk = 1;
 		else
 			try_bulk = 0;
 	} else {
-		try_bulk = prefer_bulk > 0;
+		try_bulk = usb_xfer_mode > 0;
 	}
 
 	/* Select USB transfer types to use */
-- 
1.7.10.4



--------------020403070109000109070201--
