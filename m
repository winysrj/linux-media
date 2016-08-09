Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:34338 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932545AbcHIVls (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2016 17:41:48 -0400
Subject: [PATCH 06/12] [media] dvb_frontend: tuner_ops.release returns void
From: Max Kellermann <max.kellermann@gmail.com>
To: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	mchehab@osg.samsung.com
Cc: linux-kernel@vger.kernel.org
Date: Tue, 09 Aug 2016 23:32:31 +0200
Message-ID: <147077835144.21835.17711813044749292963.stgit@woodpecker.blarg.de>
In-Reply-To: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
References: <147077832610.21835.743840405297289081.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is not clear what this return value means.  All implemenations
return 0, and the one caller ignores the value.  Let's remove this
useless return value completely.

Signed-off-by: Max Kellermann <max.kellermann@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.c         |    3 +--
 drivers/media/dvb-core/dvb_frontend.h         |    4 ++--
 drivers/media/dvb-frontends/ascot2e.c         |    3 +--
 drivers/media/dvb-frontends/cx24113.c         |    3 +--
 drivers/media/dvb-frontends/helene.c          |    3 +--
 drivers/media/dvb-frontends/horus3a.c         |    3 +--
 drivers/media/dvb-frontends/ts2020.c          |    3 +--
 drivers/media/dvb-frontends/zl10039.c         |    3 +--
 drivers/media/tuners/max2165.c                |    4 +---
 drivers/media/tuners/mt2063.c                 |    4 +---
 drivers/media/tuners/mt2131.c                 |    3 +--
 drivers/media/tuners/mxl5005s.c               |    3 +--
 drivers/media/tuners/mxl5007t.c               |    4 +---
 drivers/media/tuners/r820t.c                  |    4 +---
 drivers/media/tuners/tda18271-fe.c            |    4 +---
 drivers/media/tuners/tuner-simple.c           |    4 +---
 drivers/media/tuners/tuner-xc2028.c           |    4 +---
 drivers/media/tuners/xc4000.c                 |    4 +---
 drivers/media/tuners/xc5000.c                 |    4 +---
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c |    3 +--
 20 files changed, 21 insertions(+), 49 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index ed9686b..fea635b 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -169,12 +169,11 @@ static bool has_get_frontend(struct dvb_frontend *fe)
 	return fe->ops.get_frontend != NULL;
 }
 
-int
+void
 dvb_tuner_simple_release(struct dvb_frontend *fe)
 {
 	kfree(fe->tuner_priv);
 	fe->tuner_priv = NULL;
-	return 0;
 }
 EXPORT_SYMBOL(dvb_tuner_simple_release);
 
diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 6b675a8..5bfb16b 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -225,7 +225,7 @@ struct dvb_tuner_ops {
 
 	struct dvb_tuner_info info;
 
-	int (*release)(struct dvb_frontend *fe);
+	void (*release)(struct dvb_frontend *fe);
 	int (*init)(struct dvb_frontend *fe);
 	int (*sleep)(struct dvb_frontend *fe);
 	int (*suspend)(struct dvb_frontend *fe);
@@ -270,7 +270,7 @@ struct dvb_tuner_ops {
  * A common default implementation for dvb_tuner_ops.release.  All it
  * does is kfree() the tuner_priv and assign NULL to it.
  */
-int
+void
 dvb_tuner_simple_release(struct dvb_frontend *fe);
 
 /**
diff --git a/drivers/media/dvb-frontends/ascot2e.c b/drivers/media/dvb-frontends/ascot2e.c
index ad304ee..0ee0df5 100644
--- a/drivers/media/dvb-frontends/ascot2e.c
+++ b/drivers/media/dvb-frontends/ascot2e.c
@@ -254,14 +254,13 @@ static int ascot2e_init(struct dvb_frontend *fe)
 	return ascot2e_leave_power_save(priv);
 }
 
-static int ascot2e_release(struct dvb_frontend *fe)
+static void ascot2e_release(struct dvb_frontend *fe)
 {
 	struct ascot2e_priv *priv = fe->tuner_priv;
 
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
 	kfree(fe->tuner_priv);
 	fe->tuner_priv = NULL;
-	return 0;
 }
 
 static int ascot2e_sleep(struct dvb_frontend *fe)
diff --git a/drivers/media/dvb-frontends/cx24113.c b/drivers/media/dvb-frontends/cx24113.c
index 3883c3b..0c0b4f6 100644
--- a/drivers/media/dvb-frontends/cx24113.c
+++ b/drivers/media/dvb-frontends/cx24113.c
@@ -527,13 +527,12 @@ static int cx24113_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static int cx24113_release(struct dvb_frontend *fe)
+static void cx24113_release(struct dvb_frontend *fe)
 {
 	struct cx24113_state *state = fe->tuner_priv;
 	dprintk("\n");
 	fe->tuner_priv = NULL;
 	kfree(state);
-	return 0;
 }
 
 static const struct dvb_tuner_ops cx24113_tuner_ops = {
diff --git a/drivers/media/dvb-frontends/helene.c b/drivers/media/dvb-frontends/helene.c
index 4cb0505..fa56a20 100644
--- a/drivers/media/dvb-frontends/helene.c
+++ b/drivers/media/dvb-frontends/helene.c
@@ -434,14 +434,13 @@ static int helene_init(struct dvb_frontend *fe)
 	return helene_leave_power_save(priv);
 }
 
-static int helene_release(struct dvb_frontend *fe)
+static void helene_release(struct dvb_frontend *fe)
 {
 	struct helene_priv *priv = fe->tuner_priv;
 
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
 	kfree(fe->tuner_priv);
 	fe->tuner_priv = NULL;
-	return 0;
 }
 
 static int helene_sleep(struct dvb_frontend *fe)
diff --git a/drivers/media/dvb-frontends/horus3a.c b/drivers/media/dvb-frontends/horus3a.c
index 0c089b5..94bb4f7 100644
--- a/drivers/media/dvb-frontends/horus3a.c
+++ b/drivers/media/dvb-frontends/horus3a.c
@@ -151,14 +151,13 @@ static int horus3a_init(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int horus3a_release(struct dvb_frontend *fe)
+static void horus3a_release(struct dvb_frontend *fe)
 {
 	struct horus3a_priv *priv = fe->tuner_priv;
 
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
 	kfree(fe->tuner_priv);
 	fe->tuner_priv = NULL;
-	return 0;
 }
 
 static int horus3a_sleep(struct dvb_frontend *fe)
diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index a9f6bbe..931e5c9 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -56,7 +56,7 @@ struct ts2020_reg_val {
 
 static void ts2020_stat_work(struct work_struct *work);
 
-static int ts2020_release(struct dvb_frontend *fe)
+static void ts2020_release(struct dvb_frontend *fe)
 {
 	struct ts2020_priv *priv = fe->tuner_priv;
 	struct i2c_client *client = priv->client;
@@ -64,7 +64,6 @@ static int ts2020_release(struct dvb_frontend *fe)
 	dev_dbg(&client->dev, "\n");
 
 	i2c_unregister_device(client);
-	return 0;
 }
 
 static int ts2020_sleep(struct dvb_frontend *fe)
diff --git a/drivers/media/dvb-frontends/zl10039.c b/drivers/media/dvb-frontends/zl10039.c
index f8c271b..22cea79 100644
--- a/drivers/media/dvb-frontends/zl10039.c
+++ b/drivers/media/dvb-frontends/zl10039.c
@@ -245,14 +245,13 @@ error:
 	return ret;
 }
 
-static int zl10039_release(struct dvb_frontend *fe)
+static void zl10039_release(struct dvb_frontend *fe)
 {
 	struct zl10039_state *state = fe->tuner_priv;
 
 	dprintk("%s\n", __func__);
 	kfree(state);
 	fe->tuner_priv = NULL;
-	return 0;
 }
 
 static const struct dvb_tuner_ops zl10039_ops = {
diff --git a/drivers/media/tuners/max2165.c b/drivers/media/tuners/max2165.c
index 353b178..c3f1092 100644
--- a/drivers/media/tuners/max2165.c
+++ b/drivers/media/tuners/max2165.c
@@ -370,15 +370,13 @@ static int max2165_init(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int max2165_release(struct dvb_frontend *fe)
+static void max2165_release(struct dvb_frontend *fe)
 {
 	struct max2165_priv *priv = fe->tuner_priv;
 	dprintk("%s()\n", __func__);
 
 	kfree(priv);
 	fe->tuner_priv = NULL;
-
-	return 0;
 }
 
 static const struct dvb_tuner_ops max2165_tuner_ops = {
diff --git a/drivers/media/tuners/mt2063.c b/drivers/media/tuners/mt2063.c
index dfec237..8b39d8d 100644
--- a/drivers/media/tuners/mt2063.c
+++ b/drivers/media/tuners/mt2063.c
@@ -2019,7 +2019,7 @@ static int mt2063_get_status(struct dvb_frontend *fe, u32 *tuner_status)
 	return 0;
 }
 
-static int mt2063_release(struct dvb_frontend *fe)
+static void mt2063_release(struct dvb_frontend *fe)
 {
 	struct mt2063_state *state = fe->tuner_priv;
 
@@ -2027,8 +2027,6 @@ static int mt2063_release(struct dvb_frontend *fe)
 
 	fe->tuner_priv = NULL;
 	kfree(state);
-
-	return 0;
 }
 
 static int mt2063_set_analog_params(struct dvb_frontend *fe,
diff --git a/drivers/media/tuners/mt2131.c b/drivers/media/tuners/mt2131.c
index 6e2cdd2..e7790e4 100644
--- a/drivers/media/tuners/mt2131.c
+++ b/drivers/media/tuners/mt2131.c
@@ -230,12 +230,11 @@ static int mt2131_init(struct dvb_frontend *fe)
 	return ret;
 }
 
-static int mt2131_release(struct dvb_frontend *fe)
+static void mt2131_release(struct dvb_frontend *fe)
 {
 	dprintk(1, "%s()\n", __func__);
 	kfree(fe->tuner_priv);
 	fe->tuner_priv = NULL;
-	return 0;
 }
 
 static const struct dvb_tuner_ops mt2131_tuner_ops = {
diff --git a/drivers/media/tuners/mxl5005s.c b/drivers/media/tuners/mxl5005s.c
index 92a3be4..353744f 100644
--- a/drivers/media/tuners/mxl5005s.c
+++ b/drivers/media/tuners/mxl5005s.c
@@ -4063,12 +4063,11 @@ static int mxl5005s_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static int mxl5005s_release(struct dvb_frontend *fe)
+static void mxl5005s_release(struct dvb_frontend *fe)
 {
 	dprintk(1, "%s()\n", __func__);
 	kfree(fe->tuner_priv);
 	fe->tuner_priv = NULL;
-	return 0;
 }
 
 static const struct dvb_tuner_ops mxl5005s_tuner_ops = {
diff --git a/drivers/media/tuners/mxl5007t.c b/drivers/media/tuners/mxl5007t.c
index 42569c6..b16dfa5 100644
--- a/drivers/media/tuners/mxl5007t.c
+++ b/drivers/media/tuners/mxl5007t.c
@@ -776,7 +776,7 @@ static int mxl5007t_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static int mxl5007t_release(struct dvb_frontend *fe)
+static void mxl5007t_release(struct dvb_frontend *fe)
 {
 	struct mxl5007t_state *state = fe->tuner_priv;
 
@@ -788,8 +788,6 @@ static int mxl5007t_release(struct dvb_frontend *fe)
 	mutex_unlock(&mxl5007t_list_mutex);
 
 	fe->tuner_priv = NULL;
-
-	return 0;
 }
 
 /* ------------------------------------------------------------------------- */
diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 08dca40..ba80376 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -2286,7 +2286,7 @@ static int r820t_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 	return 0;
 }
 
-static int r820t_release(struct dvb_frontend *fe)
+static void r820t_release(struct dvb_frontend *fe)
 {
 	struct r820t_priv *priv = fe->tuner_priv;
 
@@ -2300,8 +2300,6 @@ static int r820t_release(struct dvb_frontend *fe)
 	mutex_unlock(&r820t_list_mutex);
 
 	fe->tuner_priv = NULL;
-
-	return 0;
 }
 
 static const struct dvb_tuner_ops r820t_tuner_ops = {
diff --git a/drivers/media/tuners/tda18271-fe.c b/drivers/media/tuners/tda18271-fe.c
index f862074..ee2733a 100644
--- a/drivers/media/tuners/tda18271-fe.c
+++ b/drivers/media/tuners/tda18271-fe.c
@@ -1048,7 +1048,7 @@ fail:
 	return ret;
 }
 
-static int tda18271_release(struct dvb_frontend *fe)
+static void tda18271_release(struct dvb_frontend *fe)
 {
 	struct tda18271_priv *priv = fe->tuner_priv;
 
@@ -1060,8 +1060,6 @@ static int tda18271_release(struct dvb_frontend *fe)
 	mutex_unlock(&tda18271_list_mutex);
 
 	fe->tuner_priv = NULL;
-
-	return 0;
 }
 
 static int tda18271_get_frequency(struct dvb_frontend *fe, u32 *frequency)
diff --git a/drivers/media/tuners/tuner-simple.c b/drivers/media/tuners/tuner-simple.c
index 9ba9582..63a1d41 100644
--- a/drivers/media/tuners/tuner-simple.c
+++ b/drivers/media/tuners/tuner-simple.c
@@ -1005,7 +1005,7 @@ static int simple_sleep(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int simple_release(struct dvb_frontend *fe)
+static void simple_release(struct dvb_frontend *fe)
 {
 	struct tuner_simple_priv *priv = fe->tuner_priv;
 
@@ -1017,8 +1017,6 @@ static int simple_release(struct dvb_frontend *fe)
 	mutex_unlock(&tuner_simple_list_mutex);
 
 	fe->tuner_priv = NULL;
-
-	return 0;
 }
 
 static int simple_get_frequency(struct dvb_frontend *fe, u32 *frequency)
diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index 317ef63..300d63c 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -1323,7 +1323,7 @@ static int xc2028_sleep(struct dvb_frontend *fe)
 	return rc;
 }
 
-static int xc2028_dvb_release(struct dvb_frontend *fe)
+static void xc2028_dvb_release(struct dvb_frontend *fe)
 {
 	struct xc2028_data *priv = fe->tuner_priv;
 
@@ -1344,8 +1344,6 @@ static int xc2028_dvb_release(struct dvb_frontend *fe)
 	mutex_unlock(&xc2028_list_mutex);
 
 	fe->tuner_priv = NULL;
-
-	return 0;
 }
 
 static int xc2028_get_frequency(struct dvb_frontend *fe, u32 *frequency)
diff --git a/drivers/media/tuners/xc4000.c b/drivers/media/tuners/xc4000.c
index d95c7e0..7ba286c 100644
--- a/drivers/media/tuners/xc4000.c
+++ b/drivers/media/tuners/xc4000.c
@@ -1627,7 +1627,7 @@ static int xc4000_init(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int xc4000_release(struct dvb_frontend *fe)
+static void xc4000_release(struct dvb_frontend *fe)
 {
 	struct xc4000_priv *priv = fe->tuner_priv;
 
@@ -1641,8 +1641,6 @@ static int xc4000_release(struct dvb_frontend *fe)
 	mutex_unlock(&xc4000_list_mutex);
 
 	fe->tuner_priv = NULL;
-
-	return 0;
 }
 
 static const struct dvb_tuner_ops xc4000_tuner_ops = {
diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index e6e5e90..796e763 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -1326,7 +1326,7 @@ static int xc5000_init(struct dvb_frontend *fe)
 	return 0;
 }
 
-static int xc5000_release(struct dvb_frontend *fe)
+static void xc5000_release(struct dvb_frontend *fe)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
 
@@ -1346,8 +1346,6 @@ static int xc5000_release(struct dvb_frontend *fe)
 	mutex_unlock(&xc5000_list_mutex);
 
 	fe->tuner_priv = NULL;
-
-	return 0;
 }
 
 static int xc5000_set_config(struct dvb_frontend *fe, void *priv_cfg)
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c
index f141dcc..f84bef6 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c
@@ -455,13 +455,12 @@ static int mxl111sf_tuner_get_if_frequency(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int mxl111sf_tuner_release(struct dvb_frontend *fe)
+static void mxl111sf_tuner_release(struct dvb_frontend *fe)
 {
 	struct mxl111sf_tuner_state *state = fe->tuner_priv;
 	mxl_dbg("()");
 	kfree(state);
 	fe->tuner_priv = NULL;
-	return 0;
 }
 
 /* ------------------------------------------------------------------------- */

