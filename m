Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34403 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562Ab2HJAwy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Aug 2012 20:52:54 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/3] tda18212: use Kernel dev_* logging
Date: Fri, 10 Aug 2012 03:50:36 +0300
Message-Id: <1344559837-6365-2-git-send-email-crope@iki.fi>
In-Reply-To: <1344559837-6365-1-git-send-email-crope@iki.fi>
References: <1344559837-6365-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/common/tuners/tda18212.c | 35 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/media/common/tuners/tda18212.c b/drivers/media/common/tuners/tda18212.c
index a14e8b6..5d9f028 100644
--- a/drivers/media/common/tuners/tda18212.c
+++ b/drivers/media/common/tuners/tda18212.c
@@ -18,8 +18,6 @@
  *    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include "tda18212.h"
 
 struct tda18212_priv {
@@ -29,16 +27,6 @@ struct tda18212_priv {
 	u32 if_frequency;
 };
 
-#define dbg(fmt, arg...)					\
-do {								\
-	if (debug)						\
-		pr_info("%s: " fmt, __func__, ##arg);		\
-} while (0)
-
-static int debug;
-module_param(debug, int, 0644);
-MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
-
 /* write multiple registers */
 static int tda18212_wr_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 	int len)
@@ -61,8 +49,8 @@ static int tda18212_wr_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 	if (ret == 1) {
 		ret = 0;
 	} else {
-		pr_warn("i2c wr failed ret:%d reg:%02x len:%d\n",
-			ret, reg, len);
+		dev_warn(&priv->i2c->dev, "%s: i2c wr failed=%d reg=%02x " \
+				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 	return ret;
@@ -93,8 +81,8 @@ static int tda18212_rd_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 		memcpy(val, buf, len);
 		ret = 0;
 	} else {
-		pr_warn("i2c rd failed ret:%d reg:%02x len:%d\n",
-			ret, reg, len);
+		dev_warn(&priv->i2c->dev, "%s: i2c rd failed=%d reg=%02x " \
+				"len=%d\n", KBUILD_MODNAME, ret, reg, len);
 		ret = -EREMOTEIO;
 	}
 
@@ -157,8 +145,10 @@ static int tda18212_set_params(struct dvb_frontend *fe)
 		[DVBC_8]  = { 0x92, 0x53, 0x03 },
 	};
 
-	dbg("delsys=%d RF=%d BW=%d\n",
-	    c->delivery_system, c->frequency, c->bandwidth_hz);
+	dev_dbg(&priv->i2c->dev,
+			"%s: delivery_system=%d frequency=%d bandwidth_hz=%d\n",
+			__func__, c->delivery_system, c->frequency,
+			c->bandwidth_hz);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */
@@ -247,7 +237,7 @@ exit:
 	return ret;
 
 error:
-	dbg("failed:%d\n", ret);
+	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	goto exit;
 }
 
@@ -306,13 +296,16 @@ struct dvb_frontend *tda18212_attach(struct dvb_frontend *fe,
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0); /* close I2C-gate */
 
-	dbg("ret:%d chip ID:%02x\n", ret, val);
+	dev_dbg(&priv->i2c->dev, "%s: ret=%d chip id=%02x\n", __func__, ret,
+			val);
 	if (ret || val != 0xc7) {
 		kfree(priv);
 		return NULL;
 	}
 
-	pr_info("NXP TDA18212HN successfully identified\n");
+	dev_info(&priv->i2c->dev,
+			"%s: NXP TDA18212HN successfully identified\n",
+			KBUILD_MODNAME);
 
 	memcpy(&fe->ops.tuner_ops, &tda18212_tuner_ops,
 		sizeof(struct dvb_tuner_ops));
-- 
1.7.11.2

