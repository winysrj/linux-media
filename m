Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39410 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbaA3MAu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jan 2014 07:00:50 -0500
Date: Thu, 30 Jan 2014 15:00:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] tda10071: remove a duplicative test
Message-ID: <20140130120034.GA13267@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

"ret" is an error code here, we already tested that.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index 8ad3a57cf640..a76df29c4973 100644
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
