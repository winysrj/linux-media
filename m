Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49999 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437AbbFBKUd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Jun 2015 06:20:33 -0400
Date: Tue, 2 Jun 2015 13:20:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] m88ds3103: a couple missing error codes
Message-ID: <20150602102000.GD11247@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We need to set some error codes here.

Fixes: f01919e8f54f ('[media] m88ds3103: add I2C client binding')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 01b9ded..7b21f1a 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1563,6 +1563,7 @@ static int m88ds3103_probe(struct i2c_client *client,
 		u8tmp = 0x10;
 		break;
 	default:
+		ret = -EINVAL;
 		goto err_kfree;
 	}
 
@@ -1590,8 +1591,10 @@ static int m88ds3103_probe(struct i2c_client *client,
 	dev->i2c_adapter = i2c_add_mux_adapter(client->adapter, &client->dev,
 					       dev, 0, 0, 0, m88ds3103_select,
 					       m88ds3103_deselect);
-	if (dev->i2c_adapter == NULL)
+	if (dev->i2c_adapter == NULL) {
+		ret = -ENOMEM;
 		goto err_kfree;
+	}
 
 	/* create dvb_frontend */
 	memcpy(&dev->fe.ops, &m88ds3103_ops, sizeof(struct dvb_frontend_ops));
