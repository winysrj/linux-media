Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60752 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab3KBQdm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:33:42 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 14/29] dvb-frontends: Don't use dynamic static allocation
Date: Sat,  2 Nov 2013 11:31:22 -0200
Message-Id: <1383399097-11615-15-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
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
max data length of 80, it seem safe to use 80 as the hard limit for all
those devices. On most cases, the limit is a way lower than that, but
80 is small enough to not affect the Kernel stack, and it is a no brain
limit, as using smaller ones would require to either carefully each
driver or to take a look on each datasheet.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9013.c        |  9 ++++++++-
 drivers/media/dvb-frontends/af9033.c        | 18 ++++++++++++++++--
 drivers/media/dvb-frontends/cxd2820r_core.c | 18 ++++++++++++++++--
 drivers/media/dvb-frontends/rtl2830.c       |  9 ++++++++-
 drivers/media/dvb-frontends/rtl2832.c       |  9 ++++++++-
 drivers/media/dvb-frontends/tda10071.c      | 18 ++++++++++++++++--
 6 files changed, 72 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index a204f2828820..f968dc0e5de9 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -50,7 +50,7 @@ static int af9013_wr_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
 	const u8 *val, int len)
 {
 	int ret;
-	u8 buf[3+len];
+	u8 buf[80];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->config.i2c_addr,
@@ -60,6 +60,13 @@ static int af9013_wr_regs_i2c(struct af9013_state *priv, u8 mbox, u16 reg,
 		}
 	};
 
+	if (3 + len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EREMOTEIO;
+	}
+
 	buf[0] = (reg >> 8) & 0xff;
 	buf[1] = (reg >> 0) & 0xff;
 	buf[2] = mbox;
diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index a777b4b944eb..efa2efafa97f 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -40,7 +40,7 @@ static int af9033_wr_regs(struct af9033_state *state, u32 reg, const u8 *val,
 		int len)
 {
 	int ret;
-	u8 buf[3 + len];
+	u8 buf[80];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = state->cfg.i2c_addr,
@@ -50,6 +50,13 @@ static int af9033_wr_regs(struct af9033_state *state, u32 reg, const u8 *val,
 		}
 	};
 
+	if (3 + len > sizeof(buf)) {
+		dev_warn(&state->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EREMOTEIO;
+	}
+
 	buf[0] = (reg >> 16) & 0xff;
 	buf[1] = (reg >>  8) & 0xff;
 	buf[2] = (reg >>  0) & 0xff;
@@ -161,7 +168,14 @@ static int af9033_wr_reg_val_tab(struct af9033_state *state,
 		const struct reg_val *tab, int tab_len)
 {
 	int ret, i, j;
-	u8 buf[tab_len];
+	u8 buf[80];
+
+	if (tab_len > sizeof(buf)) {
+		dev_warn(&state->i2c->dev,
+			 "%s: i2c wr len=%d is too big!\n",
+			 KBUILD_MODNAME, tab_len);
+		return -EREMOTEIO;
+	}
 
 	dev_dbg(&state->i2c->dev, "%s: tab_len=%d\n", __func__, tab_len);
 
diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
index d9eeeb1dfa96..8ef96a96b141 100644
--- a/drivers/media/dvb-frontends/cxd2820r_core.c
+++ b/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -26,7 +26,7 @@ static int cxd2820r_wr_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 	u8 *val, int len)
 {
 	int ret;
-	u8 buf[len+1];
+	u8 buf[80];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = i2c,
@@ -36,6 +36,13 @@ static int cxd2820r_wr_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 		}
 	};
 
+	if (1 + len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EREMOTEIO;
+	}
+
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
@@ -55,7 +62,7 @@ static int cxd2820r_rd_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 	u8 *val, int len)
 {
 	int ret;
-	u8 buf[len];
+	u8 buf[80];
 	struct i2c_msg msg[2] = {
 		{
 			.addr = i2c,
@@ -70,6 +77,13 @@ static int cxd2820r_rd_regs_i2c(struct cxd2820r_priv *priv, u8 i2c, u8 reg,
 		}
 	};
 
+	if (len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EREMOTEIO;
+	}
+
 	ret = i2c_transfer(priv->i2c, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
index 362d26d11e82..bd54fd8b3e2d 100644
--- a/drivers/media/dvb-frontends/rtl2830.c
+++ b/drivers/media/dvb-frontends/rtl2830.c
@@ -31,7 +31,7 @@
 static int rtl2830_wr(struct rtl2830_priv *priv, u8 reg, const u8 *val, int len)
 {
 	int ret;
-	u8 buf[1+len];
+	u8 buf[80];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->cfg.i2c_addr,
@@ -41,6 +41,13 @@ static int rtl2830_wr(struct rtl2830_priv *priv, u8 reg, const u8 *val, int len)
 		}
 	};
 
+	if (1 + len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EREMOTEIO;
+	}
+
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
index a95dfe0a5ce3..067547fd6ac5 100644
--- a/drivers/media/dvb-frontends/rtl2832.c
+++ b/drivers/media/dvb-frontends/rtl2832.c
@@ -162,7 +162,7 @@ static const struct rtl2832_reg_entry registers[] = {
 static int rtl2832_wr(struct rtl2832_priv *priv, u8 reg, u8 *val, int len)
 {
 	int ret;
-	u8 buf[1+len];
+	u8 buf[80];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->cfg.i2c_addr,
@@ -172,6 +172,13 @@ static int rtl2832_wr(struct rtl2832_priv *priv, u8 reg, u8 *val, int len)
 		}
 	};
 
+	if (1 + len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EREMOTEIO;
+	}
+
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index e79749cfec81..6f007f55d35d 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -27,7 +27,7 @@ static int tda10071_wr_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
 	int len)
 {
 	int ret;
-	u8 buf[len+1];
+	u8 buf[80];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->cfg.demod_i2c_addr,
@@ -37,6 +37,13 @@ static int tda10071_wr_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
 		}
 	};
 
+	if (1 + len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EREMOTEIO;
+	}
+
 	buf[0] = reg;
 	memcpy(&buf[1], val, len);
 
@@ -56,7 +63,7 @@ static int tda10071_rd_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
 	int len)
 {
 	int ret;
-	u8 buf[len];
+	u8 buf[80];
 	struct i2c_msg msg[2] = {
 		{
 			.addr = priv->cfg.demod_i2c_addr,
@@ -71,6 +78,13 @@ static int tda10071_rd_regs(struct tda10071_priv *priv, u8 reg, u8 *val,
 		}
 	};
 
+	if (len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EREMOTEIO;
+	}
+
 	ret = i2c_transfer(priv->i2c, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
-- 
1.8.3.1

