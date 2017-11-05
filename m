Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:44712 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751307AbdKEOZb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Nov 2017 09:25:31 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 13/15] si2165: add DVBv3 wrapper for C/N statistics
Date: Sun,  5 Nov 2017 15:25:09 +0100
Message-Id: <20171105142511.16563-13-zzam@gentoo.org>
In-Reply-To: <20171105142511.16563-1-zzam@gentoo.org>
References: <20171105142511.16563-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add read_snr function that reads from property cache to support DVBv3.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 1cd2120f5dc4..ceb5a2bb0dea 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -794,6 +794,17 @@ static int si2165_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	return 0;
 }
 
+static int si2165_read_snr(struct dvb_frontend *fe, u16 *snr)
+{
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+
+	if (c->cnr.stat[0].scale == FE_SCALE_DECIBEL)
+		*snr = div_s64(c->cnr.stat[0].svalue, 100);
+	else
+		*snr = 0;
+	return 0;
+}
+
 static int si2165_set_oversamp(struct si2165_state *state, u32 dvb_rate)
 {
 	u64 oversamp;
@@ -1111,6 +1122,7 @@ static const struct dvb_frontend_ops si2165_ops = {
 
 	.set_frontend      = si2165_set_frontend,
 	.read_status       = si2165_read_status,
+	.read_snr          = si2165_read_snr,
 };
 
 static int si2165_probe(struct i2c_client *client,
-- 
2.15.0
