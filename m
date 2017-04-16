Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32782 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756293AbdDPRf6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Apr 2017 13:35:58 -0400
Received: by mail-wm0-f67.google.com with SMTP id o81so5886338wmb.0
        for <linux-media@vger.kernel.org>; Sun, 16 Apr 2017 10:35:57 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: linux-media@vger.kernel.org
Cc: guennadi.liakhovetski@intel.com, hans.verkuil@cisco.com,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/7] ov2640: fix init sequence alignment
Date: Sun, 16 Apr 2017 19:35:40 +0200
Message-Id: <20170416173546.4317-2-fschaefer.oss@googlemail.com>
In-Reply-To: <20170416173546.4317-1-fschaefer.oss@googlemail.com>
References: <20170416173546.4317-1-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While we are at it, remove a misleading comment (copy/paste mistake)

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/i2c/ov2640.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index d55ca37dc12f..df9f6c7a929c 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -199,7 +199,7 @@
 #define   COM7_ZOOM_EN         0x04 /* Enable Zoom mode */
 #define   COM7_COLOR_BAR_TEST  0x02 /* Enable Color Bar Test Pattern */
 #define COM8        0x13 /* Common control 8 */
-#define   COM8_DEF             0xC0 /* Banding filter ON/OFF */
+#define   COM8_DEF             0xC0
 #define   COM8_BNDF_EN         0x20 /* Banding filter ON/OFF */
 #define   COM8_AGC_EN          0x04 /* AGC Auto/Manual control selection */
 #define   COM8_AEC_EN          0x01 /* Auto/Manual Exposure control */
@@ -306,11 +306,11 @@ static const struct regval_list ov2640_init_regs[] = {
 	{ 0x2e,   0xdf },
 	{ BANK_SEL, BANK_SEL_SENS },
 	{ 0x3c,   0x32 },
-	{ CLKRC, CLKRC_DIV_SET(1) },
-	{ COM2, COM2_OCAP_Nx_SET(3) },
-	{ REG04, REG04_DEF | REG04_HREF_EN },
-	{ COM8,  COM8_DEF | COM8_BNDF_EN | COM8_AGC_EN | COM8_AEC_EN },
-	{ COM9, COM9_AGC_GAIN_8x | 0x08},
+	{ CLKRC,  CLKRC_DIV_SET(1) },
+	{ COM2,   COM2_OCAP_Nx_SET(3) },
+	{ REG04,  REG04_DEF | REG04_HREF_EN },
+	{ COM8,   COM8_DEF | COM8_BNDF_EN | COM8_AGC_EN | COM8_AEC_EN },
+	{ COM9,   COM9_AGC_GAIN_8x | 0x08},
 	{ 0x2c,   0x0c },
 	{ 0x33,   0x78 },
 	{ 0x3a,   0x33 },
@@ -355,25 +355,25 @@ static const struct regval_list ov2640_init_regs[] = {
 	{ 0x71,   0x94 },
 	{ 0x73,   0xc1 },
 	{ 0x3d,   0x34 },
-	{ COM7, COM7_RES_UXGA | COM7_ZOOM_EN },
+	{ COM7,   COM7_RES_UXGA | COM7_ZOOM_EN },
 	{ 0x5a,   0x57 },
 	{ BD50,   0xbb },
 	{ BD60,   0x9c },
-	{ BANK_SEL, BANK_SEL_DSP },
+	{ BANK_SEL,  BANK_SEL_DSP },
 	{ 0xe5,   0x7f },
-	{ MC_BIST, MC_BIST_RESET | MC_BIST_BOOT_ROM_SEL },
+	{ MC_BIST,  MC_BIST_RESET | MC_BIST_BOOT_ROM_SEL },
 	{ 0x41,   0x24 },
-	{ RESET, RESET_JPEG | RESET_DVP },
+	{ RESET,  RESET_JPEG | RESET_DVP },
 	{ 0x76,   0xff },
 	{ 0x33,   0xa0 },
 	{ 0x42,   0x20 },
 	{ 0x43,   0x18 },
 	{ 0x4c,   0x00 },
-	{ CTRL3, CTRL3_BPC_EN | CTRL3_WPC_EN | 0x10 },
+	{ CTRL3,  CTRL3_BPC_EN | CTRL3_WPC_EN | 0x10 },
 	{ 0x88,   0x3f },
 	{ 0xd7,   0x03 },
 	{ 0xd9,   0x10 },
-	{ R_DVP_SP , R_DVP_SP_AUTO_MODE | 0x2 },
+	{ R_DVP_SP,  R_DVP_SP_AUTO_MODE | 0x2 },
 	{ 0xc8,   0x08 },
 	{ 0xc9,   0x80 },
 	{ BPADDR, 0x00 },
-- 
2.12.2
