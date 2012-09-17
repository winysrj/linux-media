Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42341 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805Ab2IQC10 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Sep 2012 22:27:26 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/3] af9033: sleep on attach
Date: Mon, 17 Sep 2012 05:26:57 +0300
Message-Id: <1347848817-18607-3-git-send-email-crope@iki.fi>
In-Reply-To: <1347848817-18607-1-git-send-email-crope@iki.fi>
References: <1347848817-18607-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reduces power consumption 10mA.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 0979ada..56e9611 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -909,6 +909,15 @@ struct dvb_frontend *af9033_attach(const struct af9033_config *config,
 			"OFDM=%d.%d.%d.%d\n", KBUILD_MODNAME, buf[0], buf[1],
 			buf[2], buf[3], buf[4], buf[5], buf[6], buf[7]);
 
+	/* sleep */
+	ret = af9033_wr_reg(state, 0x80004c, 1);
+	if (ret < 0)
+		goto err;
+
+	ret = af9033_wr_reg(state, 0x800000, 0);
+	if (ret < 0)
+		goto err;
+
 	/* configure internal TS mode */
 	switch (state->cfg.ts_mode) {
 	case AF9033_TS_MODE_PARALLEL:
-- 
1.7.11.4

