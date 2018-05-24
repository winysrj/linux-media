Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-1b.atlantis.sk ([80.94.52.26]:34303 "EHLO
        smtp-1b.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966195AbeEXPO5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 11:14:57 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] gspca_zc3xx: Fix exposure with power line frequency for OV7648
Date: Thu, 24 May 2018 17:09:31 +0200
Message-Id: <20180524150931.26574-3-linux@rainbow-software.org>
In-Reply-To: <20180524150931.26574-1-linux@rainbow-software.org>
References: <20180524150931.26574-1-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 50Hz and 60Hz power line frequency settings disable short (1/120s
and 1/100s) exposure times for banding filter, causing overexposed
image near lamps. No flicker setting enables them (when banding
filter is disabled and they're not used).

Seems that the logic is just the wrong way around. Fix it.
(This bug came from the Windows driver.)

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/usb/gspca/zc3xx.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/gspca/zc3xx.c b/drivers/media/usb/gspca/zc3xx.c
index 9a78420e8ad8..299ea70bfb67 100644
--- a/drivers/media/usb/gspca/zc3xx.c
+++ b/drivers/media/usb/gspca/zc3xx.c
@@ -3188,7 +3188,9 @@ static const struct usb_action ov7620_50HZ[] = {
 				 * don't change autoexposure */
 	{0xdd, 0x00, 0x0100},	/* 00,01,00,dd */
 	{0xaa, 0x2b, 0x0096},	/* 00,2b,96,aa */
-	{0xaa, 0x75, 0x008a},	/* 00,75,8a,aa */
+/*	{0xaa, 0x75, 0x008a},	 * 00,75,8a,aa */
+	/* enable 1/120s & 1/100s exposures for banding filter */
+	{0xaa, 0x75, 0x008e},
 	{0xaa, 0x2d, 0x0005},	/* 00,2d,05,aa */
 	{0xa0, 0x00, ZC3XX_R190_EXPOSURELIMITHIGH},	/* 01,90,00,cc */
 	{0xa0, 0x04, ZC3XX_R191_EXPOSURELIMITMID},	/* 01,91,04,cc */
@@ -3208,7 +3210,9 @@ static const struct usb_action ov7620_60HZ[] = {
 				 * don't change autoexposure */
 	{0xdd, 0x00, 0x0100},			/* 00,01,00,dd */
 	{0xaa, 0x2b, 0x0000},			/* 00,2b,00,aa */
-	{0xaa, 0x75, 0x008a},			/* 00,75,8a,aa */
+/*	{0xaa, 0x75, 0x008a},			 * 00,75,8a,aa */
+	/* enable 1/120s & 1/100s exposures for banding filter */
+	{0xaa, 0x75, 0x008e},
 	{0xaa, 0x2d, 0x0005},			/* 00,2d,05,aa */
 	{0xa0, 0x00, ZC3XX_R190_EXPOSURELIMITHIGH}, /* 01,90,00,cc */
 	{0xa0, 0x04, ZC3XX_R191_EXPOSURELIMITMID}, /* 01,91,04,cc */
@@ -3231,7 +3235,9 @@ static const struct usb_action ov7620_NoFliker[] = {
 				 * don't change autoexposure */
 	{0xdd, 0x00, 0x0100},			/* 00,01,00,dd */
 	{0xaa, 0x2b, 0x0000},			/* 00,2b,00,aa */
-	{0xaa, 0x75, 0x008e},			/* 00,75,8e,aa */
+/*	{0xaa, 0x75, 0x008e},			 * 00,75,8e,aa */
+	/* disable 1/120s & 1/100s exposures for banding filter */
+	{0xaa, 0x75, 0x008a},
 	{0xaa, 0x2d, 0x0001},			/* 00,2d,01,aa */
 	{0xa0, 0x00, ZC3XX_R190_EXPOSURELIMITHIGH}, /* 01,90,00,cc */
 	{0xa0, 0x04, ZC3XX_R191_EXPOSURELIMITMID}, /* 01,91,04,cc */
-- 
Ondrej Zary
