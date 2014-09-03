Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44384 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089AbaICUda (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:30 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 15/46] [media] tda10071: use true/false for boolean vars
Date: Wed,  3 Sep 2014 17:32:47 -0300
Message-Id: <4d4c1fba364043a45a260a164651600675d33984.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using 0 or 1 for boolean, use the true/false
defines.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index 9619be5d4827..4a19b85995f1 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -1037,7 +1037,7 @@ static int tda10071_init(struct dvb_frontend *fe)
 			ret = -EFAULT;
 			goto error;
 		} else {
-			priv->warm = 1;
+			priv->warm = true;
 		}
 
 		cmd.args[0] = CMD_GET_FW_VERSION;
-- 
1.9.3

