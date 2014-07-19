Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45756 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760244AbaGSCit (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 22:38:49 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 10/10] si2157: Add get_if_frequency callback
Date: Sat, 19 Jul 2014 05:38:26 +0300
Message-Id: <1405737506-13186-10-git-send-email-crope@iki.fi>
In-Reply-To: <1405737506-13186-1-git-send-email-crope@iki.fi>
References: <1405737506-13186-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Matthias Schwarzott <zzam@gentoo.org>

This is needed for PCTV 522e support.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/si2157.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index f619983..6c53edb 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -279,6 +279,12 @@ err:
 	return ret;
 }
 
+static int si2157_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
+{
+	*frequency = 5000000; /* default value of property 0x0706 */
+	return 0;
+}
+
 static const struct dvb_tuner_ops si2157_ops = {
 	.info = {
 		.name           = "Silicon Labs Si2157/Si2158",
@@ -289,6 +295,7 @@ static const struct dvb_tuner_ops si2157_ops = {
 	.init = si2157_init,
 	.sleep = si2157_sleep,
 	.set_params = si2157_set_params,
+	.get_if_frequency = si2157_get_if_frequency,
 };
 
 static int si2157_probe(struct i2c_client *client,
-- 
1.9.3

