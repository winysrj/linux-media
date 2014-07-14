Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59529 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756722AbaGNRJX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 13:09:23 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 13/18] si2157: Set delivery system and bandwidth before tuning
Date: Mon, 14 Jul 2014 20:08:54 +0300
Message-Id: <1405357739-3570-13-git-send-email-crope@iki.fi>
In-Reply-To: <1405357739-3570-1-git-send-email-crope@iki.fi>
References: <1405357739-3570-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Olli Salonen <olli.salonen@iki.fi>

Tell used TV standard and bandwidth for tuner firmware.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/si2157.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 58c5ef5..b656f9b 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -209,6 +209,7 @@ static int si2157_set_params(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	struct si2157_cmd cmd;
+	u8 bandwidth, delivery_system;
 
 	dev_dbg(&s->client->dev,
 			"%s: delivery_system=%d frequency=%u bandwidth_hz=%u\n",
@@ -220,6 +221,36 @@ static int si2157_set_params(struct dvb_frontend *fe)
 		goto err;
 	}
 
+	if (c->bandwidth_hz <= 6000000)
+		bandwidth = 0x06;
+	else if (c->bandwidth_hz <= 7000000)
+		bandwidth = 0x07;
+	else if (c->bandwidth_hz <= 8000000)
+		bandwidth = 0x08;
+	else
+		bandwidth = 0x0f;
+
+	switch (c->delivery_system) {
+	case SYS_DVBT:
+	case SYS_DVBT2: /* it seems DVB-T and DVB-T2 both are 0x20 here */
+			delivery_system = 0x20;
+			break;
+	case SYS_DVBC_ANNEX_A:
+			delivery_system = 0x30;
+			break;
+	default:
+			ret = -EINVAL;
+			goto err;
+	}
+
+	memcpy(cmd.args, "\x14\x00\x03\x07\x00\x00", 6);
+	cmd.args[4] = delivery_system | bandwidth;
+	cmd.wlen = 6;
+	cmd.rlen = 1;
+	ret = si2157_cmd_execute(s, &cmd);
+	if (ret)
+		goto err;
+
 	/* set frequency */
 	memcpy(cmd.args, "\x41\x00\x00\x00\x00\x00\x00\x00", 8);
 	cmd.args[4] = (c->frequency >>  0) & 0xff;
-- 
1.9.3

