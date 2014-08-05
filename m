Return-path: <linux-media-owner@vger.kernel.org>
Received: from 219-87-157-213.static.tfn.net.tw ([219.87.157.213]:18715 "EHLO
	ironport.ite.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141AbaHEFp4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 01:45:56 -0400
Received: from ms2.internal.ite.com.tw (ms2.internal.ite.com.tw [192.168.15.236])
	by mse.ite.com.tw with ESMTP id s755jrHY002618
	for <linux-media@vger.kernel.org>; Tue, 5 Aug 2014 13:45:53 +0800 (CST)
	(envelope-from Bimow.Chen@ite.com.tw)
Received: from [192.168.190.2] (unknown [192.168.190.2])
	by ms2.internal.ite.com.tw (Postfix) with ESMTP id 1296645307
	for <linux-media@vger.kernel.org>; Tue,  5 Aug 2014 13:45:50 +0800 (CST)
Subject: [PATCH 3/4] V4L/DVB: Update tuner initialization sequence
From: Bimow Chen <Bimow.Chen@ite.com.tw>
To: linux-media@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-8ibir3gD+Pv+BMuc8eil"
Date: Tue, 05 Aug 2014 13:46:53 +0800
Message-ID: <1407217613.2988.7.camel@ite-desktop>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-8ibir3gD+Pv+BMuc8eil
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



--=-8ibir3gD+Pv+BMuc8eil
Content-Disposition: attachment; filename="0003-Update-tuner-initialization-sequence.patch"
Content-Type: text/x-patch; name="0003-Update-tuner-initialization-sequence.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 68df717c82f5da425a807a417872de0a9566211c Mon Sep 17 00:00:00 2001
From: Bimow Chen <Bimow.Chen@ite.com.tw>
Date: Tue, 5 Aug 2014 11:14:47 +0800
Subject: [PATCH 3/4] Update tuner initialization sequence.


Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
---
 drivers/media/tuners/tuner_it913x.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/media/tuners/tuner_it913x.c b/drivers/media/tuners/tuner_it913x.c
index 6f30d7e..728de57 100644
--- a/drivers/media/tuners/tuner_it913x.c
+++ b/drivers/media/tuners/tuner_it913x.c
@@ -200,10 +200,7 @@ static int it913x_init(struct dvb_frontend *fe)
 		}
 	}
 
-	/* Power Up Tuner - common all versions */
-	ret = it913x_wr_reg(state, PRO_DMOD, 0xec40, 0x1);
-	ret |= it913x_wr_reg(state, PRO_DMOD, 0xfba8, 0x0);
-	ret |= it913x_wr_reg(state, PRO_DMOD, 0xec57, 0x0);
+	ret = it913x_wr_reg(state, PRO_DMOD, 0xec57, 0x0);
 	ret |= it913x_wr_reg(state, PRO_DMOD, 0xec58, 0x0);
 
 	return it913x_wr_reg(state, PRO_DMOD, 0xed81, val);
@@ -396,6 +393,7 @@ struct dvb_frontend *it913x_attach(struct dvb_frontend *fe,
 		struct i2c_adapter *i2c_adap, u8 i2c_addr, u8 config)
 {
 	struct it913x_state *state = NULL;
+	int ret;
 
 	/* allocate memory for the internal state */
 	state = kzalloc(sizeof(struct it913x_state), GFP_KERNEL);
@@ -429,6 +427,13 @@ struct dvb_frontend *it913x_attach(struct dvb_frontend *fe,
 	memcpy(&fe->ops.tuner_ops, &it913x_tuner_ops,
 			sizeof(struct dvb_tuner_ops));
 
+	/* tuner RF initial */
+	ret = it913x_wr_reg(state, PRO_DMOD, 0xec4c, 0x68);
+	if (ret < 0)
+		goto error;
+
+	msleep(30);
+
 	dev_info(&i2c_adap->dev,
 			"%s: ITE Tech IT913X successfully attached\n",
 			KBUILD_MODNAME);
-- 
1.7.0.4


--=-8ibir3gD+Pv+BMuc8eil--

