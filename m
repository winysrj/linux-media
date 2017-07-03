Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:6847 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753516AbdGCJRE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Jul 2017 05:17:04 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        " H. Nikolaus Schaller" <hns@goldelico.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC: <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH v2 4/7] [media] ov9650: use write_array() for resolution sequences
Date: Mon, 3 Jul 2017 11:16:05 +0200
Message-ID: <1499073368-31905-5-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1499073368-31905-1-git-send-email-hugues.fruchet@st.com>
References: <1499073368-31905-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Align resolution sequences on initialization sequence using
i2c_rv structure NULL terminated .This add flexibility
on resolution sequence size.
Document resolution related registers by using corresponding
define instead of hexa address/value.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/ov9650.c | 88 +++++++++++++++++++++++++++++++---------------
 1 file changed, 59 insertions(+), 29 deletions(-)

diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index 7e9a902..db96698 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -227,11 +227,16 @@ struct ov965x_ctrls {
 	u8 update;
 };
 
+struct i2c_rv {
+	u8 addr;
+	u8 value;
+};
+
 struct ov965x_framesize {
 	u16 width;
 	u16 height;
 	u16 max_exp_lines;
-	const u8 *regs;
+	const struct i2c_rv *regs;
 };
 
 struct ov965x_interval {
@@ -280,11 +285,6 @@ struct ov965x {
 	u8 apply_frame_fmt;
 };
 
-struct i2c_rv {
-	u8 addr;
-	u8 value;
-};
-
 static const struct i2c_rv ov965x_init_regs[] = {
 	{ REG_COM2, 0x10 },	/* Set soft sleep mode */
 	{ REG_COM5, 0x00 },	/* System clock options */
@@ -342,30 +342,59 @@ struct i2c_rv {
 	{ REG_NULL, 0 }
 };
 
-#define NUM_FMT_REGS 14
-/*
- * COM7,  COM3,  COM4, HSTART, HSTOP, HREF, VSTART, VSTOP, VREF,
- * EXHCH, EXHCL, ADC,  OCOM,   OFON
- */
-static const u8 frame_size_reg_addr[NUM_FMT_REGS] = {
-	0x12, 0x0c, 0x0d, 0x17, 0x18, 0x32, 0x19, 0x1a, 0x03,
-	0x2a, 0x2b, 0x37, 0x38, 0x39,
-};
-
-static const u8 ov965x_sxga_regs[NUM_FMT_REGS] = {
-	0x00, 0x00, 0x00, 0x1e, 0xbe, 0xbf, 0x01, 0x81, 0x12,
-	0x10, 0x34, 0x81, 0x93, 0x51,
+static const struct i2c_rv ov965x_sxga_regs[] = {
+	{ REG_COM7, 0x00 },
+	{ REG_COM3, 0x00 },
+	{ REG_COM4, 0x00 },
+	{ REG_HSTART, 0x1e },
+	{ REG_HSTOP, 0xbe },
+	{ 0x32, 0xbf },
+	{ REG_VSTART, 0x01 },
+	{ REG_VSTOP, 0x81 },
+	{ REG_VREF, 0x12 },
+	{ REG_EXHCH, 0x10 },
+	{ REG_EXHCL, 0x34 },
+	{ REG_ADC, 0x81 },
+	{ REG_ACOM, 0x93 },
+	{ REG_OFON, 0x51 },
+	{ REG_NULL, 0 },
 };
 
-static const u8 ov965x_vga_regs[NUM_FMT_REGS] = {
-	0x40, 0x04, 0x80, 0x26, 0xc6, 0xed, 0x01, 0x3d, 0x00,
-	0x10, 0x40, 0x91, 0x12, 0x43,
+static const struct i2c_rv ov965x_vga_regs[] = {
+	{ REG_COM7, 0x40 },
+	{ REG_COM3, 0x04 },
+	{ REG_COM4, 0x80 },
+	{ REG_HSTART, 0x26 },
+	{ REG_HSTOP, 0xc6 },
+	{ 0x32, 0xed },
+	{ REG_VSTART, 0x01 },
+	{ REG_VSTOP, 0x3d },
+	{ REG_VREF, 0x00 },
+	{ REG_EXHCH, 0x10 },
+	{ REG_EXHCL, 0x40 },
+	{ REG_ADC, 0x91 },
+	{ REG_ACOM, 0x12 },
+	{ REG_OFON, 0x43 },
+	{ REG_NULL, 0 },
 };
 
 /* Determined empirically. */
-static const u8 ov965x_qvga_regs[NUM_FMT_REGS] = {
-	0x10, 0x04, 0x80, 0x25, 0xc5, 0xbf, 0x00, 0x80, 0x12,
-	0x10, 0x40, 0x91, 0x12, 0x43,
+static const struct i2c_rv ov965x_qvga_regs[] = {
+	{ REG_COM7, 0x10 },
+	{ REG_COM3, 0x04 },
+	{ REG_COM4, 0x80 },
+	{ REG_HSTART, 0x25 },
+	{ REG_HSTOP, 0xc5 },
+	{ 0x32, 0xbf },
+	{ REG_VSTART, 0x00 },
+	{ REG_VSTOP, 0x80 },
+	{ REG_VREF, 0x12 },
+	{ REG_EXHCH, 0x10 },
+	{ REG_EXHCL, 0x40 },
+	{ REG_ADC, 0x91 },
+	{ REG_ACOM, 0x12 },
+	{ REG_OFON, 0x43 },
+	{ REG_NULL, 0 },
 };
 
 static const struct ov965x_framesize ov965x_framesizes[] = {
@@ -1266,11 +1295,12 @@ static int ov965x_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config
 
 static int ov965x_set_frame_size(struct ov965x *ov965x)
 {
-	int i, ret = 0;
+	int ret = 0;
+
+	v4l2_dbg(1, debug, ov965x->client, "%s\n", __func__);
 
-	for (i = 0; ret == 0 && i < NUM_FMT_REGS; i++)
-		ret = ov965x_write(ov965x->client, frame_size_reg_addr[i],
-				   ov965x->frame_size->regs[i]);
+	ret = ov965x_write_array(ov965x->client,
+				 ov965x->frame_size->regs);
 	return ret;
 }
 
-- 
1.9.1
