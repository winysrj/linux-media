Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58171 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760219AbaGSCit (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 22:38:49 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 09/10] si2157: Add support for spectral inversion
Date: Sat, 19 Jul 2014 05:38:25 +0300
Message-Id: <1405737506-13186-9-git-send-email-crope@iki.fi>
In-Reply-To: <1405737506-13186-1-git-send-email-crope@iki.fi>
References: <1405737506-13186-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Matthias Schwarzott <zzam@gentoo.org>

This is needed for PCTV 522e support.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/si2157.c      | 3 +++
 drivers/media/tuners/si2157.h      | 5 +++++
 drivers/media/tuners/si2157_priv.h | 1 +
 3 files changed, 9 insertions(+)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 4730f69..f619983 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -253,6 +253,8 @@ static int si2157_set_params(struct dvb_frontend *fe)
 
 	memcpy(cmd.args, "\x14\x00\x03\x07\x00\x00", 6);
 	cmd.args[4] = delivery_system | bandwidth;
+	if (s->inversion)
+		cmd.args[5] = 0x01;
 	cmd.wlen = 6;
 	cmd.rlen = 1;
 	ret = si2157_cmd_execute(s, &cmd);
@@ -307,6 +309,7 @@ static int si2157_probe(struct i2c_client *client,
 
 	s->client = client;
 	s->fe = cfg->fe;
+	s->inversion = cfg->inversion;
 	mutex_init(&s->i2c_mutex);
 
 	/* check if the tuner is there */
diff --git a/drivers/media/tuners/si2157.h b/drivers/media/tuners/si2157.h
index 4465c46..6da4d5d 100644
--- a/drivers/media/tuners/si2157.h
+++ b/drivers/media/tuners/si2157.h
@@ -29,6 +29,11 @@ struct si2157_config {
 	 * frontend
 	 */
 	struct dvb_frontend *fe;
+
+	/*
+	 * Spectral Inversion
+	 */
+	bool inversion;
 };
 
 #endif
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index db79f3c..3ddab5e 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -26,6 +26,7 @@ struct si2157 {
 	struct i2c_client *client;
 	struct dvb_frontend *fe;
 	bool active;
+	bool inversion;
 };
 
 /* firmare command struct */
-- 
1.9.3

