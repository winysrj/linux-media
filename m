Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43310 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab3KENDw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 08:03:52 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 13/29] [media] dvb-frontends: Don't use dynamic static allocation
Date: Tue,  5 Nov 2013 08:01:26 -0200
Message-Id: <1383645702-30636-14-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
References: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
	drivers/media/dvb-frontends/af9013.c:77:1: warning: 'af9013_wr_regs_i2c' uses dynamic stack allocation [enabled by default]
	drivers/media/dvb-frontends/af9033.c:188:1: warning: 'af9033_wr_reg_val_tab' uses dynamic stack allocation [enabled by default]
	drivers/media/dvb-frontends/af9033.c:68:1: warning: 'af9033_wr_regs' uses dynamic stack allocation [enabled by default]
	drivers/media/dvb-frontends/bcm3510.c:230:1: warning: 'bcm3510_do_hab_cmd' uses dynamic stack allocation [enabled by default]
	drivers/media/dvb-frontends/cxd2820r_core.c:84:1: warning: 'cxd2820r_rd_regs_i2c.isra.1' uses dynamic stack allocation [enabled by default]
	drivers/media/dvb-frontends/rtl2830.c:56:1: warning: 'rtl2830_wr' uses dynamic stack allocation [enabled by default]
	drivers/media/dvb-frontends/rtl2832.c:187:1: warning: 'rtl2832_wr' uses dynamic stack allocation [enabled by default]
	drivers/media/dvb-frontends/tda10071.c:52:1: warning: 'tda10071_wr_regs' uses dynamic stack allocation [enabled by default]
	drivers/media/dvb-frontends/tda10071.c:84:1: warning: 'tda10071_rd_regs' uses dynamic stack allocation [enabled by default]

Instead, let's enforce a limit for the buffer. Considering that I2C
transfers are generally limited, and that devices used on USB has a
max data length of 64 bytes for	the control URBs.

So, it seem safe to use 64 bytes as the hard limit for all those devices.

 On most cases, the limit is a way lower than that, but	this limit
is small enough to not affect the Kernel stack, and it is a no brain
limit, as using smaller ones would require to either carefully each
driver or to take a look on each datasheet.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/af9013.c        | 12 +++++++++++-
 drivers/media/dvb-frontends/af9033.c        | 21 +++++++++++++++++++--
 drivers/media/dvb-frontends/cxd2820r_core.c | 21 +++++++++++++++++++--
 drivers/media/dvb-frontends/rtl2830.c       | 12 +++++++++++-
 drivers/media/dvb-frontends/rtl2832.c       | 12 +++++++++++-
 drivers/media/dvb-frontends/tda10071.c      | 21 +++++++++++++++++++--
 6 files changed, 90 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index a204f2828820..19ba66ad23fa 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -24,6 +24,9 @@
 
 #include "af9013_priv.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 struct af9013_state {
 	struct i2c_adapter *i2c;
 	struct dvb_frontend fe;
@@ -50,7 +53,7 @@ static int af9013_wr_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
 	const u8 *val, int len)
 {
 	int ret;
-	u8 buf[3+len];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->config.i2c_addr,
@@ -60,6 +63,13 @@ static int af9013_wr_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
 		}
 	};
 
+	if (3 + len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	buf[0] = (reg >> 8) & 0xff;
 	buf[1] = (reg >> 0) & 0xff;
 	buf[2] = mbox;
diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index a777b4b944eb..11f1555e66dc 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -21,6 +21,9 @@
 
 #include "af9033_priv.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 struct af9033_state {
 	struct i2c_adapter *i2c;
 	struct dvb_frontend fe;
@@ -40,7 +43,7 @@ static int af9033_wr_regs(struct af9033_state *state, u32 reg, const u8 *val,
 		int len)
 {
 	int ret;
-	u8 buf[3 + len];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = state->cfg.i2c_addr,
@@ -50,6 +53,13 @@ static int af9033_wr_regs(struct af9033_state *state, u32 reg, const u8 *val,
 		}
 	};
 
+	if (3 + len > sizeof(buf)) {
+		dev_warn(&state->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	buf[0] = (reg >> 16) & 0xff;
 	buf[1] = (reg >>  8) & 0xff;
 	buf[2] = (reg >>  0) & 0xff;
@@ -161,7 +171,14 @@ static int af9033_wr_reg_val_tab(struct af9033_state *state,
 		const struct reg_val *tab, int tab_len)
 {
 	int ret, i, j;
-	u8 buf[tab_len];
+	u8 buf[MAX_XFER_SIZE];
+
+	if (tab_len > sizeof(buf)) {
+		dev_warn(&state->i2c->dev,
+			 "%s: i2c wr len=%d is too big!\n",
+			 KBUILD_MODNAME, tab_len);
+		return -EINVAL;
+	}
 
 	dev_dbg(&state->i2c->dev, "%s: tab_len=%d\n", __func__, tab_len);
 
diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
index d9eeeb1dfa96..03930d5e9fea 100644
--- a/drivers/media/dvb-frontends/cxd2820r_core.c
+++ b/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -21,12 +21,15 @@
 
 #include "cxd2820r_priv.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 /* write multiple registers */
 static int cxd2820r_wr_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 	u8 *val, int len)
 {
 	int ret;
-	u8 buf[len+1];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = i2c,
@@ -36,6 +39,13 @@ static int cxd2820r_wr_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 		}
 	};
 
+	if (1 + len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
@@ -55,7 +65,7 @@ static int cxd2820r_rd_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 	u8 *val, int len)
 {
 	int ret;
-	u8 buf[len];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[2] = {
 		{
 			.addr = i2c,
@@ -70,6 +80,13 @@ static int cxd2820r_rd_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 		}
 	};
 
+	if (len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	ret = i2c_transfer(priv->i2c, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index 362d26d11e82..b908800b390d 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -27,11 +27,14 @@
 
 #include "rtl2830_priv.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 /* write multiple hardware registers */
 static int rtl2830_wr(struct rtl2830_priv *priv, u8 reg, const u8 *val, int len)
 {
 	int ret;
-	u8 buf[1+len];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->cfg.i2c_addr,
@@ -41,6 +44,13 @@ static int rtl2830_wr(struct rtl2830_priv *priv, u8 reg, const u8 *val, int len)
 		}
 	};
 
+	if (1 + len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index a95dfe0a5ce3..cd1e6965ac11 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -22,6 +22,9 @@
 #include "dvb_math.h"
 #include <linux/bitops.h>
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 int rtl2832_debug;
 module_param_named(debug, rtl2832_debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
@@ -162,7 +165,7 @@ static const struct rtl2832_reg_entry registers[] = {
 static int rtl2832_wr(struct rtl2832_priv *priv, u8 reg, u8 *val, int len)
 {
 	int ret;
-	u8 buf[1+len];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->cfg.i2c_addr,
@@ -172,6 +175,13 @@ static int rtl2832_wr(struct rtl2832_priv *priv, u8 reg, u8 *val, int len)
 		}
 	};
 
+	if (1 + len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index e79749cfec81..1d8bc2ea4b10 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -20,6 +20,9 @@
 
 #include "tda10071_priv.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 static struct dvb_frontend_ops tda10071_ops;
 
 /* write multiple registers */
@@ -27,7 +30,7 @@ static int tda10071_wr_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
 	int len)
 {
 	int ret;
-	u8 buf[len+1];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->cfg.demod_i2c_addr,
@@ -37,6 +40,13 @@ static int tda10071_wr_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
 		}
 	};
 
+	if (1 + len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
@@ -56,7 +66,7 @@ static int tda10071_rd_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
 	int len)
 {
 	int ret;
-	u8 buf[len];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[2] = {
 		{
 			.addr = priv->cfg.demod_i2c_addr,
@@ -71,6 +81,13 @@ static int tda10071_rd_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
 		}
 	};
 
+	if (len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	ret = i2c_transfer(priv->i2c, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
-- 
1.8.3.1

