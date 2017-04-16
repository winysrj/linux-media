Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34511 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756546AbdDPRgC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Apr 2017 13:36:02 -0400
Received: by mail-wr0-f196.google.com with SMTP id u18so18048446wrc.1
        for <linux-media@vger.kernel.org>; Sun, 16 Apr 2017 10:36:01 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: linux-media@vger.kernel.org
Cc: guennadi.liakhovetski@intel.com, hans.verkuil@cisco.com,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 4/7] ov2640: add missing write to size change preamble
Date: Sun, 16 Apr 2017 19:35:43 +0200
Message-Id: <20170416173546.4317-5-fschaefer.oss@googlemail.com>
In-Reply-To: <20170416173546.4317-1-fschaefer.oss@googlemail.com>
References: <20170416173546.4317-1-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HSIZE and VSIZE bits 0 to 2 and HSIZE bit 11 are encoded in DSP register
SIZEL.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/i2c/ov2640.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index 11f1b807c292..6f0cc722477d 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -500,6 +500,9 @@ static const struct regval_list ov2640_init_regs[] = {
 static const struct regval_list ov2640_size_change_preamble_regs[] = {
 	{ BANK_SEL, BANK_SEL_DSP },
 	{ RESET, RESET_DVP },
+	{ SIZEL, SIZEL_HSIZE8_11_SET(UXGA_WIDTH) |
+		 SIZEL_HSIZE8_SET(UXGA_WIDTH) |
+		 SIZEL_VSIZE8_SET(UXGA_HEIGHT) },
 	{ HSIZE8, HSIZE8_SET(UXGA_WIDTH) },
 	{ VSIZE8, VSIZE8_SET(UXGA_HEIGHT) },
 	{ CTRL2, CTRL2_DCW_EN | CTRL2_SDE_EN |
-- 
2.12.2
