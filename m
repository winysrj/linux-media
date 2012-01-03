Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34509 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab2ACSaR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2012 13:30:17 -0500
Received: by eekc4 with SMTP id c4so16105782eek.19
        for <linux-media@vger.kernel.org>; Tue, 03 Jan 2012 10:30:16 -0800 (PST)
Message-ID: <4F034934.4010407@gmail.com>
Date: Tue, 03 Jan 2012 19:30:12 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH v2] xc3028: fix center frequency calculation for DTV78 firmware
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,
this patch replaces the previous one proposed in the thread
"xc3028: force reload of DTV7 firmware in VHF band with Zarlink
demodulator".
The problem is that the firmware DTV78 works fine in UHF band (8 MHz
bandwidth) but is not working at all in VHF band (7 MHz bandwidth).
Reading the comments inside the code, I figured out that the real
problem could be connected to the formula used to calculate the center
frequency offset in VHF band.

In fact, removing this adjustment fixes the problem:

		if ((priv->cur_fw.type & DTV78) && freq < 470000000)
			offset -= 500000;

This is coherent to what was implemented for the DTV7 firmware by an
Australian user:

		if (priv->cur_fw.type & DTV7)
			offset += 500000;

In the end, now the center frequency is the same for all firmwares
(DTV7, DTV8, DTV78) and doesn't depend on channel bandwidth.

The final code looks clean and simple, and there is no need for any
"magic" adjustment:

		if (priv->cur_fw.type & DTV6)
			offset = 1750000;
		else	/* DTV7 or DTV8 or DTV78 */
			offset = 2750000;

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/common/tuners/tuner-xc2028.c |   26
++++++++++++++++----------
 1 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/media/common/tuners/tuner-xc2028.c
b/drivers/media/common/tuners/tuner-xc2028.c
index bdcbfd7..2755599 100644
--- a/drivers/media/common/tuners/tuner-xc2028.c
+++ b/drivers/media/common/tuners/tuner-xc2028.c
@@ -962,14 +962,24 @@ static int generic_set_freq(struct dvb_frontend
*fe, u32 freq /* in HZ */,
 		 * For DTV 7/8, the firmware uses BW = 8000, so it needs a
 		 * further adjustment to get the frequency center on VHF
 		 */
+
+		/*
+		 * The firmware DTV78 used to work fine in UHF band (8 MHz
+		 * bandwidth) but not at all in VHF band (7 MHz bandwidth).
+		 * The real problem was connected to the formula used to
+		 * calculate the center frequency offset in VHF band.
+		 * In fact, removing the 500KHz adjustment fixed the problem.
+		 * This is coherent to what was implemented for the DTV7
+		 * firmware.
+		 * In the end, now the center frequency is the same for all 3
+		 * firmwares (DTV7, DTV8, DTV78) and doesn't depend on channel
+		 * bandwidth.
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
@@ -979,17 +989,13 @@ static int generic_set_freq(struct dvb_frontend
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
1.7.5.4
