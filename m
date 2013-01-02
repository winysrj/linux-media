Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33125 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab3ABLNi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 06:13:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: [PATCH 2/2] mt9m032: Define MT9M032_READ_MODE1 bits
Date: Wed,  2 Jan 2013 12:15:04 +0100
Message-Id: <1357125304-6128-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1357125304-6128-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1357125304-6128-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace hardcoded values with #define's.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9m032.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/media/i2c/mt9m032.c b/drivers/media/i2c/mt9m032.c
index 30d755a..de150d3 100644
--- a/drivers/media/i2c/mt9m032.c
+++ b/drivers/media/i2c/mt9m032.c
@@ -90,6 +90,24 @@
 #define		MT9M032_PLL_CONFIG1_PREDIV_MASK		0x3f
 #define		MT9M032_PLL_CONFIG1_MUL_SHIFT		8
 #define MT9M032_READ_MODE1				0x1e
+#define		MT9M032_READ_MODE1_OUTPUT_BAD_FRAMES	(1 << 13)
+#define		MT9M032_READ_MODE1_MAINTAIN_FRAME_RATE	(1 << 12)
+#define		MT9M032_READ_MODE1_XOR_LINE_VALID	(1 << 11)
+#define		MT9M032_READ_MODE1_CONT_LINE_VALID	(1 << 10)
+#define		MT9M032_READ_MODE1_INVERT_TRIGGER	(1 << 9)
+#define		MT9M032_READ_MODE1_SNAPSHOT		(1 << 8)
+#define		MT9M032_READ_MODE1_GLOBAL_RESET		(1 << 7)
+#define		MT9M032_READ_MODE1_BULB_EXPOSURE	(1 << 6)
+#define		MT9M032_READ_MODE1_INVERT_STROBE	(1 << 5)
+#define		MT9M032_READ_MODE1_STROBE_ENABLE	(1 << 4)
+#define		MT9M032_READ_MODE1_STROBE_START_TRIG1	(0 << 2)
+#define		MT9M032_READ_MODE1_STROBE_START_EXP	(1 << 2)
+#define		MT9M032_READ_MODE1_STROBE_START_SHUTTER	(2 << 2)
+#define		MT9M032_READ_MODE1_STROBE_START_TRIG2	(3 << 2)
+#define		MT9M032_READ_MODE1_STROBE_END_TRIG1	(0 << 0)
+#define		MT9M032_READ_MODE1_STROBE_END_EXP	(1 << 0)
+#define		MT9M032_READ_MODE1_STROBE_END_SHUTTER	(2 << 0)
+#define		MT9M032_READ_MODE1_STROBE_END_TRIG2	(3 << 0)
 #define MT9M032_READ_MODE2				0x20
 #define		MT9M032_READ_MODE2_VFLIP_SHIFT		15
 #define		MT9M032_READ_MODE2_HFLIP_SHIFT		14
@@ -282,7 +300,9 @@ static int mt9m032_setup_pll(struct mt9m032 *sensor)
 				    MT9P031_PLL_CONTROL_PWRON |
 				    MT9P031_PLL_CONTROL_USEPLL);
 	if (!ret)		/* more reserved, Continuous, Master Mode */
-		ret = mt9m032_write(client, MT9M032_READ_MODE1, 0x8006);
+		ret = mt9m032_write(client, MT9M032_READ_MODE1, 0x8000 |
+				    MT9M032_READ_MODE1_STROBE_START_EXP |
+				    MT9M032_READ_MODE1_STROBE_END_SHUTTER);
 	if (!ret) {
 		reg_val = (pll.p1 == 6 ? MT9M032_FORMATTER1_PLL_P1_6 : 0)
 			| MT9M032_FORMATTER1_PARALLEL | 0x001e; /* 14-bit */
-- 
1.7.8.6

