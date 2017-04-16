Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36352 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756293AbdDPRgB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Apr 2017 13:36:01 -0400
Received: by mail-wm0-f68.google.com with SMTP id q125so5870508wmd.3
        for <linux-media@vger.kernel.org>; Sun, 16 Apr 2017 10:36:00 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: linux-media@vger.kernel.org
Cc: guennadi.liakhovetski@intel.com, hans.verkuil@cisco.com,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 3/7] ov2640: add information about DSP register 0xc7
Date: Sun, 16 Apr 2017 19:35:42 +0200
Message-Id: <20170416173546.4317-4-fschaefer.oss@googlemail.com>
In-Reply-To: <20170416173546.4317-1-fschaefer.oss@googlemail.com>
References: <20170416173546.4317-1-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to ov2640 software application notes, there are two Automatic
White Balance (AWB) modes, which are selected by DSP register 0xc7:

1) Simple AWB: assumes the average color is gray
   + independent from lens
   - doesn't work well if captured area contains unbalanced colors
     (e.g. large blue background)

2) Advanced AWB: uses color temperature information
   + more accurate, works with all image contents
   - lens specific, requires calibration

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/i2c/ov2640.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index fd1b215b6dec..11f1b807c292 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -106,6 +106,10 @@
 #define   CTRL1_AWB_GAIN     0x04
 #define   CTRL1_LENC         0x02
 #define   CTRL1_PRE          0x01
+/*      REG 0xC7 (unknown name): affects Auto White Balance (AWB)
+ *	  AWB_OFF            0x40
+ *	  AWB_SIMPLE         0x10
+ *	  AWB_ON             0x00	(Advanced AWB ?) */
 #define R_DVP_SP    0xD3 /* DVP output speed control */
 #define   R_DVP_SP_AUTO_MODE 0x80
 #define   R_DVP_SP_DVP_MASK  0x3F /* DVP PCLK = sysclk (48)/[6:0] (YUV0);
@@ -449,7 +453,7 @@ static const struct regval_list ov2640_init_regs[] = {
 	{ 0xc5,   0x11 },
 	{ 0xc6,   0x51 },
 	{ 0xbf,   0x80 },
-	{ 0xc7,   0x10 },
+	{ 0xc7,   0x10 },	/* simple AWB */
 	{ 0xb6,   0x66 },
 	{ 0xb8,   0xA5 },
 	{ 0xb7,   0x64 },
-- 
2.12.2
