Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34668 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755897Ab2HJAvA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Aug 2012 20:51:00 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/3] tda18212: silence compiler warning
Date: Fri, 10 Aug 2012 03:50:35 +0300
Message-Id: <1344559837-6365-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trivial fix.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/common/tuners/tda18212.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/common/tuners/tda18212.c b/drivers/media/common/tuners/tda18212.c
index 602c2e3..a14e8b6 100644
--- a/drivers/media/common/tuners/tda18212.c
+++ b/drivers/media/common/tuners/tda18212.c
@@ -287,7 +287,7 @@ struct dvb_frontend *tda18212_attach(struct dvb_frontend *fe,
 {
 	struct tda18212_priv *priv = NULL;
 	int ret;
-	u8 val;
+	u8 uninitialized_var(val);
 
 	priv = kzalloc(sizeof(struct tda18212_priv), GFP_KERNEL);
 	if (priv == NULL)
-- 
1.7.11.2

