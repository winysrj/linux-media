Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49306 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbaBLTkx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 14:40:53 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 1/3] tda10071: remove a duplicative test
Date: Wed, 12 Feb 2014 21:40:38 +0200
Message-Id: <1392234040-14198-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

"ret" is an error code here, we already tested that.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/tda10071.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index 8ad3a57..a76df29 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -1006,8 +1006,7 @@ static int tda10071_init(struct dvb_frontend *fe)
 				dev_err(&priv->i2c->dev, "%s: firmware " \
 						"download failed=%d\n",
 						KBUILD_MODNAME, ret);
-				if (ret)
-					goto error_release_firmware;
+				goto error_release_firmware;
 			}
 		}
 		release_firmware(fw);
-- 
1.8.5.3

