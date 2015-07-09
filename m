Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36327 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbbGIEGz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jul 2015 00:06:55 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 02/12] a8293: remove legacy media attach
Date: Thu,  9 Jul 2015 07:06:22 +0300
Message-Id: <1436414792-9716-2-git-send-email-crope@iki.fi>
In-Reply-To: <1436414792-9716-1-git-send-email-crope@iki.fi>
References: <1436414792-9716-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove legacy media attach as all users are on I2C bindings now.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/a8293.c | 63 +------------------------------------
 drivers/media/dvb-frontends/a8293.h | 18 -----------
 2 files changed, 1 insertion(+), 80 deletions(-)

diff --git a/drivers/media/dvb-frontends/a8293.c b/drivers/media/dvb-frontends/a8293.c
index 97ecbe0..522b0d1 100644
--- a/drivers/media/dvb-frontends/a8293.c
+++ b/drivers/media/dvb-frontends/a8293.c
@@ -18,7 +18,6 @@
  *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
-#include "dvb_frontend.h"
 #include "a8293.h"
 
 struct a8293_priv {
@@ -105,68 +104,8 @@ err:
 	return ret;
 }
 
-static void a8293_release_sec(struct dvb_frontend *fe)
-{
-	a8293_set_voltage(fe, SEC_VOLTAGE_OFF);
-
-	kfree(fe->sec_priv);
-	fe->sec_priv = NULL;
-}
-
-struct dvb_frontend *a8293_attach(struct dvb_frontend *fe,
-	struct i2c_adapter *i2c, const struct a8293_config *cfg)
-{
-	int ret;
-	struct a8293_priv *priv = NULL;
-	u8 buf[2];
-
-	/* allocate memory for the internal priv */
-	priv = kzalloc(sizeof(struct a8293_priv), GFP_KERNEL);
-	if (priv == NULL) {
-		ret = -ENOMEM;
-		goto err;
-	}
-
-	/* setup the priv */
-	priv->i2c = i2c;
-	priv->i2c_addr = cfg->i2c_addr;
-	fe->sec_priv = priv;
-
-	/* check if the SEC is there */
-	ret = a8293_rd(priv, buf, 2);
-	if (ret)
-		goto err;
-
-	/* ENB=0 */
-	priv->reg[0] = 0x10;
-	ret = a8293_wr(priv, &priv->reg[0], 1);
-	if (ret)
-		goto err;
-
-	/* TMODE=0, TGATE=1 */
-	priv->reg[1] = 0x82;
-	ret = a8293_wr(priv, &priv->reg[1], 1);
-	if (ret)
-		goto err;
-
-	fe->ops.release_sec = a8293_release_sec;
-
-	/* override frontend ops */
-	fe->ops.set_voltage = a8293_set_voltage;
-
-	dev_info(&priv->i2c->dev, "%s: Allegro A8293 SEC attached\n",
-			KBUILD_MODNAME);
-
-	return fe;
-err:
-	dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
-	kfree(priv);
-	return NULL;
-}
-EXPORT_SYMBOL(a8293_attach);
-
 static int a8293_probe(struct i2c_client *client,
-			const struct i2c_device_id *id)
+		       const struct i2c_device_id *id)
 {
 	struct a8293_priv *dev;
 	struct a8293_platform_data *pdata = client->dev.platform_data;
diff --git a/drivers/media/dvb-frontends/a8293.h b/drivers/media/dvb-frontends/a8293.h
index aff3653..aa07b68 100644
--- a/drivers/media/dvb-frontends/a8293.h
+++ b/drivers/media/dvb-frontends/a8293.h
@@ -22,7 +22,6 @@
 #define A8293_H
 
 #include "dvb_frontend.h"
-#include <linux/kconfig.h>
 
 /*
  * I2C address
@@ -37,21 +36,4 @@ struct a8293_platform_data {
 	struct dvb_frontend *dvb_frontend;
 };
 
-
-struct a8293_config {
-	u8 i2c_addr;
-};
-
-#if IS_REACHABLE(CONFIG_DVB_A8293)
-extern struct dvb_frontend *a8293_attach(struct dvb_frontend *fe,
-	struct i2c_adapter *i2c, const struct a8293_config *cfg);
-#else
-static inline struct dvb_frontend *a8293_attach(struct dvb_frontend *fe,
-	struct i2c_adapter *i2c, const struct a8293_config *cfg)
-{
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-#endif
-
 #endif /* A8293_H */
-- 
http://palosaari.fi/

