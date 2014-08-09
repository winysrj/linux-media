Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39113 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252AbaHIU1c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Aug 2014 16:27:32 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Bimow Chen <Bimow.Chen@ite.com.tw>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 03/14] it913x: init tuner on attach
Date: Sat,  9 Aug 2014 23:27:01 +0300
Message-Id: <1407616032-2722-4-git-send-email-crope@iki.fi>
In-Reply-To: <1407616032-2722-1-git-send-email-crope@iki.fi>
References: <1407616032-2722-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Bimow Chen <Bimow.Chen@ite.com.tw>

That register is needed to program very first in order to operate
correctly.

[crope@iki.fi: returned sequence back, removed sleep, moved reg
write earlier to prevent populating tuner ops in case of failure]

Signed-off-by: Bimow Chen <Bimow.Chen@ite.com.tw>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/tuner_it913x.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/tuners/tuner_it913x.c b/drivers/media/tuners/tuner_it913x.c
index 6f30d7e..3d83c42 100644
--- a/drivers/media/tuners/tuner_it913x.c
+++ b/drivers/media/tuners/tuner_it913x.c
@@ -396,6 +396,7 @@ struct dvb_frontend *it913x_attach(struct dvb_frontend *fe,
 		struct i2c_adapter *i2c_adap, u8 i2c_addr, u8 config)
 {
 	struct it913x_state *state = NULL;
+	int ret;
 
 	/* allocate memory for the internal state */
 	state = kzalloc(sizeof(struct it913x_state), GFP_KERNEL);
@@ -425,6 +426,11 @@ struct dvb_frontend *it913x_attach(struct dvb_frontend *fe,
 	state->tuner_type = config;
 	state->firmware_ver = 1;
 
+	/* tuner RF initial */
+	ret = it913x_wr_reg(state, PRO_DMOD, 0xec4c, 0x68);
+	if (ret < 0)
+		goto error;
+
 	fe->tuner_priv = state;
 	memcpy(&fe->ops.tuner_ops, &it913x_tuner_ops,
 			sizeof(struct dvb_tuner_ops));
-- 
http://palosaari.fi/

