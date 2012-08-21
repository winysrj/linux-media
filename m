Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48984 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab2HUX5I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 19:57:08 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
	Thomas Mair <thomas.mair86@googlemail.com>
Subject: [PATCH 5/5] rtl2832: implement .read_ber()
Date: Wed, 22 Aug 2012 02:56:22 +0300
Message-Id: <1345593382-11367-5-git-send-email-crope@iki.fi>
In-Reply-To: <1345593382-11367-1-git-send-email-crope@iki.fi>
References: <1345593382-11367-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implementation taken from rtl2830.

Cc: Thomas Mair <thomas.mair86@googlemail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/rtl2832.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index dad8ab5..4d40b4f 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -824,6 +824,24 @@ err:
 	return ret;
 }
 
+static int rtl2832_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	struct rtl2832_priv *priv = fe->demodulator_priv;
+	int ret;
+	u8 buf[2];
+
+	ret = rtl2832_rd_regs(priv, 0x4e, 3, buf, 2);
+	if (ret)
+		goto err;
+
+	*ber = buf[0] << 8 | buf[1];
+
+	return 0;
+err:
+	dbg("%s: failed=%d", __func__, ret);
+	return ret;
+}
+
 static struct dvb_frontend_ops rtl2832_ops;
 
 static void rtl2832_release(struct dvb_frontend *fe)
@@ -909,6 +927,7 @@ static struct dvb_frontend_ops rtl2832_ops = {
 
 	.read_status = rtl2832_read_status,
 	.read_snr = rtl2832_read_snr,
+	.read_ber = rtl2832_read_ber,
 
 	.i2c_gate_ctrl = rtl2832_i2c_gate_ctrl,
 };
-- 
1.7.11.4

