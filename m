Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39160 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab1LHNAI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2011 08:00:08 -0500
Received: by eekd41 with SMTP id d41so1147121eek.19
        for <linux-media@vger.kernel.org>; Thu, 08 Dec 2011 05:00:07 -0800 (PST)
Message-ID: <4EE0B4D4.2020909@gmail.com>
Date: Thu, 08 Dec 2011 14:00:04 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/1] xc3028: fix center frequency calculation for DTV78
 firmware
References: <4EE0B419.3070604@gmail.com>
In-Reply-To: <4EE0B419.3070604@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Updated center frequency calculation to fix VHF band reception
with firmware DTV78.
The adjustment for DTV78 is not needed anymore with new
firmwares, since the offset is not depending anymore on the
bandwidth or the firmware version (at least for DTV7, DTV8, DTV78).

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/common/tuners/tuner-xc2028.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/media/common/tuners/tuner-xc2028.c
b/drivers/media/common/tuners/tuner-xc2028.c
index e531267..7653aca 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -962,14 +962,20 @@ static int generic_set_freq(struct dvb_frontend
*fe, u32 freq /* in HZ */,
 		 * For DTV 7/8, the firmware uses BW = 8000, so it needs a
 		 * further adjustment to get the frequency center on VHF
 		 */
+
+		/*
+		 * The center frequency formula above seems no more correct.
+		 * The adjustment for DTV78 is not needed anymore with new
+		 * firmwares, since the offset is not depending anymore on the
+		 * bandwidth or the firmware version (at least for DTV78).
+		 * This is probably a consequence of the SCODE table adjustments
+		 * mentioned in the comment below.
+		 */
+
 		if (priv->cur_fw.type & DTV6)
 			offset = 1750000;
-		else if (priv->cur_fw.type & DTV7)
-			offset = 2250000;
-		else	/* DTV8 or DTV78 */
+		else	/* DTV7 or DTV8 or DTV78 */
 			offset = 2750000;
-		if ((priv->cur_fw.type & DTV78) && freq < 470000000)
-			offset -= 500000;

 		/*
 		 * xc3028 additional "magic"
@@ -979,17 +985,13 @@ static int generic_set_freq(struct dvb_frontend
*fe, u32 freq /* in HZ */,
 		 * newer firmwares
 		 */

-#if 1
 		/*
 		 * The proper adjustment would be to do it at s-code table.
 		 * However, this didn't work, as reported by
 		 * Robert Lowery <rglowery@exemail.com.au>
 		 */

-		if (priv->cur_fw.type & DTV7)
-			offset += 500000;
-
-#else
+#if 0
 		/*
 		 * Still need tests for XC3028L (firmware 3.2 or upper)
 		 * So, for now, let's just comment the per-firmware
-- 
1.7.0.4
