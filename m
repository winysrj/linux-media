Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51126 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbaAYRLB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 12:11:01 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 05/52] rtl2832_sdr: use get_if_frequency()
Date: Sat, 25 Jan 2014 19:09:59 +0200
Message-Id: <1390669846-8131-6-git-send-email-crope@iki.fi>
In-Reply-To: <1390669846-8131-1-git-send-email-crope@iki.fi>
References: <1390669846-8131-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Get IF from tuner and use it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 60 ++++++++++++++++++++----
 1 file changed, 51 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index 513da22..c4b72c1 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -208,7 +208,15 @@ static int rtl2832_sdr_rd_regs(struct rtl2832_sdr_state *s, u16 reg, u8 *val,
 
 	return rtl2832_sdr_rd(s, reg2, val, len);
 }
+#endif
 
+/* write single register */
+static int rtl2832_sdr_wr_reg(struct rtl2832_sdr_state *s, u16 reg, u8 val)
+{
+	return rtl2832_sdr_wr_regs(s, reg, &val, 1);
+}
+
+#if 0
 /* read single register */
 static int rtl2832_sdr_rd_reg(struct rtl2832_sdr_state *s, u16 reg, u8 *val)
 {
@@ -632,8 +640,12 @@ static void rtl2832_sdr_buf_queue(struct vb2_buffer *vb)
 
 static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 {
+	struct dvb_frontend *fe = s->fe;
 	int ret;
-	unsigned int f_sr;
+	unsigned int f_sr, f_if;
+	u8 buf[3], tmp;
+	u64 u64tmp;
+	u32 u32tmp;
 
 	dev_dbg(&s->udev->dev, "%s:\n", __func__);
 
@@ -647,14 +659,42 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 	ret = rtl2832_sdr_wr_regs(s, 0x116, "\x00\x00", 2);
 	ret = rtl2832_sdr_wr_regs(s, 0x118, "\x00", 1);
 
-	if (s->cfg->tuner == RTL2832_TUNER_R820T) {
-		ret = rtl2832_sdr_wr_regs(s, 0x119, "\x38\x11", 2);
-		ret = rtl2832_sdr_wr_regs(s, 0x11b, "\x12", 1);
-		ret = rtl2832_sdr_wr_regs(s, 0x115, "\x01", 1);
-	} else {
-		ret = rtl2832_sdr_wr_regs(s, 0x119, "\x00\x00", 2);
-		ret = rtl2832_sdr_wr_regs(s, 0x11b, "\x00", 1);
-	}
+	/* get IF from tuner */
+	if (fe->ops.tuner_ops.get_if_frequency)
+		ret = fe->ops.tuner_ops.get_if_frequency(fe, &f_if);
+	else
+		ret = -EINVAL;
+
+	if (ret)
+		goto err;
+
+	/* program IF */
+	u64tmp = f_if % s->cfg->xtal;
+	u64tmp *= 0x400000;
+	u64tmp = div_u64(u64tmp, s->cfg->xtal);
+	u64tmp = -u64tmp;
+	u32tmp = u64tmp & 0x3fffff;
+
+	dev_dbg(&s->udev->dev, "%s: f_if=%u if_ctl=%08x\n",
+			__func__, f_if, u32tmp);
+
+	buf[0] = (u32tmp >> 16) & 0xff;
+	buf[1] = (u32tmp >>  8) & 0xff;
+	buf[2] = (u32tmp >>  0) & 0xff;
+
+	ret = rtl2832_sdr_wr_regs(s, 0x119, buf, 3);
+	if (ret)
+		goto err;
+
+	/* program BB / IF mode */
+	if (f_if)
+		tmp = 0x00;
+	else
+		tmp = 0x01;
+
+	ret = rtl2832_sdr_wr_reg(s, 0x1b1, tmp);
+	if (ret)
+		goto err;
 
 	ret = rtl2832_sdr_wr_regs(s, 0x19f, "\x03\x84", 2);
 	ret = rtl2832_sdr_wr_regs(s, 0x1a1, "\x00\x00", 2);
@@ -696,6 +736,7 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 	ret = rtl2832_sdr_wr_regs(s, 0x102, "\x40", 1);
 
 	if (s->cfg->tuner == RTL2832_TUNER_R820T) {
+		ret = rtl2832_sdr_wr_regs(s, 0x115, "\x01", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x103, "\x80", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x1c7, "\x24", 1);
 		ret = rtl2832_sdr_wr_regs(s, 0x104, "\xcc", 1);
@@ -751,6 +792,7 @@ static int rtl2832_sdr_set_adc(struct rtl2832_sdr_state *s)
 		ret = rtl2832_sdr_wr_regs(s, 0x101, "\x10", 1);
 	}
 
+err:
 	return ret;
 };
 
-- 
1.8.5.3

