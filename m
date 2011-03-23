Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:18407 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab1CWNgS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 09:36:18 -0400
Date: Wed, 23 Mar 2011 14:35:57 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] zoran: Drop unused module parameters encoder and decoder
Message-ID: <20110323143557.40ad9df7@endymion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The ability to force the encoder or decoder chip was broken by commit
0ab6e1c38d80ab586e3a1ca9e71844131d9f51dc in February 2009. As nobody
complained for over 2 years, I take it that these parameters were no
longer used so we can simply drop them.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
---
 Documentation/video4linux/Zoran        |    1 -
 drivers/media/video/zoran/zoran_card.c |    8 --------
 2 files changed, 9 deletions(-)

--- linux-2.6.39-rc0.orig/Documentation/video4linux/Zoran	2011-03-23 10:34:22.000000000 +0100
+++ linux-2.6.39-rc0/Documentation/video4linux/Zoran	2011-03-23 13:21:22.000000000 +0100
@@ -130,7 +130,6 @@ Card number: 4
 
 Note: No module for the mse3000 is available yet
 Note: No module for the vpx3224 is available yet
-Note: use encoder=X or decoder=X for non-default i2c chips
 
 ===========================
 
--- linux-2.6.39-rc0.orig/drivers/media/video/zoran/zoran_card.c	2011-03-21 17:46:15.000000000 +0100
+++ linux-2.6.39-rc0/drivers/media/video/zoran/zoran_card.c	2011-03-23 13:21:22.000000000 +0100
@@ -64,14 +64,6 @@ static int card[BUZ_MAX] = { [0 ... (BUZ
 module_param_array(card, int, NULL, 0444);
 MODULE_PARM_DESC(card, "Card type");
 
-static int encoder[BUZ_MAX] = { [0 ... (BUZ_MAX-1)] = -1 };
-module_param_array(encoder, int, NULL, 0444);
-MODULE_PARM_DESC(encoder, "Video encoder chip");
-
-static int decoder[BUZ_MAX] = { [0 ... (BUZ_MAX-1)] = -1 };
-module_param_array(decoder, int, NULL, 0444);
-MODULE_PARM_DESC(decoder, "Video decoder chip");
-
 /*
    The video mem address of the video card.
    The driver has a little database for some videocards


-- 
Jean Delvare
