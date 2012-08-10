Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56331 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024Ab2HJAwy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Aug 2012 20:52:54 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/3] tda18218: silence compiler warning
Date: Fri, 10 Aug 2012 03:50:37 +0300
Message-Id: <1344559837-6365-3-git-send-email-crope@iki.fi>
In-Reply-To: <1344559837-6365-1-git-send-email-crope@iki.fi>
References: <1344559837-6365-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trivial fix.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/common/tuners/tda18218.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/common/tuners/tda18218.c b/drivers/media/common/tuners/tda18218.c
index dfb3a83..8a6f9ca 100644
--- a/drivers/media/common/tuners/tda18218.c
+++ b/drivers/media/common/tuners/tda18218.c
@@ -282,7 +282,7 @@ struct dvb_frontend *tda18218_attach(struct dvb_frontend *fe,
 	struct i2c_adapter *i2c, struct tda18218_config *cfg)
 {
 	struct tda18218_priv *priv = NULL;
-	u8 val;
+	u8 uninitialized_var(val);
 	int ret;
 	/* chip default registers values */
 	static u8 def_regs[] = {
-- 
1.7.11.2

