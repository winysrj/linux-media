Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32790 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756532AbdDPRf7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Apr 2017 13:35:59 -0400
Received: by mail-wm0-f68.google.com with SMTP id o81so5886409wmb.0
        for <linux-media@vger.kernel.org>; Sun, 16 Apr 2017 10:35:59 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: linux-media@vger.kernel.org
Cc: guennadi.liakhovetski@intel.com, hans.verkuil@cisco.com,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 2/7] ov2640: improve banding filter register definitions/documentation
Date: Sun, 16 Apr 2017 19:35:41 +0200
Message-Id: <20170416173546.4317-3-fschaefer.oss@googlemail.com>
In-Reply-To: <20170416173546.4317-1-fschaefer.oss@googlemail.com>
References: <20170416173546.4317-1-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- add missing initialisation of sensor register COM25 (2 MSBs of banding
  filter AEC values)
- add macros for setting the banding filter AEC values
- add definitions for sensor register 0x5a, which is documented in
  Omnivisions software application notes

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/i2c/ov2640.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index df9f6c7a929c..fd1b215b6dec 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -248,8 +248,19 @@
 #define ZOOMS       0x49 /* Zoom: Vertical start point */
 #define COM22       0x4B /* Flash light control */
 #define COM25       0x4E /* For Banding operations */
+#define   COM25_50HZ_BANDING_AEC_MSBS_MASK      0xC0 /* 50Hz Bd. AEC 2 MSBs */
+#define   COM25_60HZ_BANDING_AEC_MSBS_MASK      0x30 /* 60Hz Bd. AEC 2 MSBs */
+#define   COM25_50HZ_BANDING_AEC_MSBS_SET(x)    VAL_SET(x, 0x3, 8, 6)
+#define   COM25_60HZ_BANDING_AEC_MSBS_SET(x)    VAL_SET(x, 0x3, 8, 4)
 #define BD50        0x4F /* 50Hz Banding AEC 8 LSBs */
+#define   BD50_50HZ_BANDING_AEC_LSBS_SET(x)     VAL_SET(x, 0xFF, 0, 0)
 #define BD60        0x50 /* 60Hz Banding AEC 8 LSBs */
+#define   BD60_60HZ_BANDING_AEC_LSBS_SET(x)     VAL_SET(x, 0xFF, 0, 0)
+#define REG5A       0x5A /* 50/60Hz Banding Maximum AEC Step */
+#define   BD50_MAX_AEC_STEP_MASK         0xF0 /* 50Hz Banding Max. AEC Step */
+#define   BD60_MAX_AEC_STEP_MASK         0x0F /* 60Hz Banding Max. AEC Step */
+#define   BD50_MAX_AEC_STEP_SET(x)       VAL_SET((x - 1), 0x0F, 0, 4)
+#define   BD60_MAX_AEC_STEP_SET(x)       VAL_SET((x - 1), 0x0F, 0, 0)
 #define REG5D       0x5D /* AVGsel[7:0],   16-zone average weight option */
 #define REG5E       0x5E /* AVGsel[15:8],  16-zone average weight option */
 #define REG5F       0x5F /* AVGsel[23:16], 16-zone average weight option */
@@ -356,9 +367,12 @@ static const struct regval_list ov2640_init_regs[] = {
 	{ 0x73,   0xc1 },
 	{ 0x3d,   0x34 },
 	{ COM7,   COM7_RES_UXGA | COM7_ZOOM_EN },
-	{ 0x5a,   0x57 },
-	{ BD50,   0xbb },
-	{ BD60,   0x9c },
+	{ REG5A,  BD50_MAX_AEC_STEP_SET(6)
+		   | BD60_MAX_AEC_STEP_SET(8) },		/* 0x57 */
+	{ COM25,  COM25_50HZ_BANDING_AEC_MSBS_SET(0x0bb)
+		   | COM25_60HZ_BANDING_AEC_MSBS_SET(0x09c) },	/* 0x00 */
+	{ BD50,   BD50_50HZ_BANDING_AEC_LSBS_SET(0x0bb) },	/* 0xbb */
+	{ BD60,   BD60_60HZ_BANDING_AEC_LSBS_SET(0x09c) },	/* 0x9c */
 	{ BANK_SEL,  BANK_SEL_DSP },
 	{ 0xe5,   0x7f },
 	{ MC_BIST,  MC_BIST_RESET | MC_BIST_BOOT_ROM_SEL },
-- 
2.12.2
