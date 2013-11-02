Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60764 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab3KBQdm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:33:42 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCHv2 19/29] tuners: Don't use dynamic static allocation
Date: Sat,  2 Nov 2013 11:31:27 -0200
Message-Id: <1383399097-11615-20-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:

	drivers/media/tuners/e4000.c:50:1: warning: 'e4000_wr_regs' uses dynamic stack allocation [enabled by default]
	drivers/media/tuners/e4000.c:83:1: warning: 'e4000_rd_regs' uses dynamic stack allocation [enabled by default]
	drivers/media/tuners/fc2580.c:66:1: warning: 'fc2580_wr_regs.constprop.1' uses dynamic stack allocation [enabled by default]
	drivers/media/tuners/fc2580.c:98:1: warning: 'fc2580_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]
	drivers/media/tuners/tda18212.c:57:1: warning: 'tda18212_wr_regs' uses dynamic stack allocation [enabled by default]
	drivers/media/tuners/tda18212.c:90:1: warning: 'tda18212_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]
	drivers/media/tuners/tda18218.c:60:1: warning: 'tda18218_wr_regs' uses dynamic stack allocation [enabled by default]
	drivers/media/tuners/tda18218.c:92:1: warning: 'tda18218_rd_regs.constprop.0' uses dynamic stack allocation [enabled by default]

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
 drivers/media/tuners/e4000.c    | 18 ++++++++++++++++--
 drivers/media/tuners/fc2580.c   | 18 ++++++++++++++++--
 drivers/media/tuners/tda18212.c | 18 ++++++++++++++++--
 drivers/media/tuners/tda18218.c | 18 ++++++++++++++++--
 4 files changed, 64 insertions(+), 8 deletions(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index ad9309da4a91..235e90251609 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -24,7 +24,7 @@
 static int e4000_wr_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
 {
 	int ret;
-	u8 buf[1 + len];
+	u8 buf[80];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->cfg->i2c_addr,
@@ -34,6 +34,13 @@ static int e4000_wr_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
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
 
@@ -53,7 +60,7 @@ static int e4000_wr_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
 static int e4000_rd_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
 {
 	int ret;
-	u8 buf[len];
+	u8 buf[80];
 	struct i2c_msg msg[2] = {
 		{
 			.addr = priv->cfg->i2c_addr,
@@ -68,6 +75,13 @@ static int e4000_rd_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
 		}
 	};
 
+	if (len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c rd reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EREMOTEIO;
+	}
+
 	ret = i2c_transfer(priv->i2c, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index 81f38aae9c66..e27bf5be311d 100644
--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -41,7 +41,7 @@
 static int fc2580_wr_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
 {
 	int ret;
-	u8 buf[1 + len];
+	u8 buf[80];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->cfg->i2c_addr,
@@ -51,6 +51,13 @@ static int fc2580_wr_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
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
 
@@ -69,7 +76,7 @@ static int fc2580_wr_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
 static int fc2580_rd_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
 {
 	int ret;
-	u8 buf[len];
+	u8 buf[80];
 	struct i2c_msg msg[2] = {
 		{
 			.addr = priv->cfg->i2c_addr,
@@ -84,6 +91,13 @@ static int fc2580_rd_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
 		}
 	};
 
+	if (len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c rd reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EREMOTEIO;
+	}
+
 	ret = i2c_transfer(priv->i2c, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
diff --git a/drivers/media/tuners/tda18212.c b/drivers/media/tuners/tda18212.c
index e4a84ee231cf..765b9f9d4bc6 100644
--- a/drivers/media/tuners/tda18212.c
+++ b/drivers/media/tuners/tda18212.c
@@ -32,7 +32,7 @@ static int tda18212_wr_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 	int len)
 {
 	int ret;
-	u8 buf[len+1];
+	u8 buf[80];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->cfg->i2c_address,
@@ -42,6 +42,13 @@ static int tda18212_wr_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
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
 
@@ -61,7 +68,7 @@ static int tda18212_rd_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 	int len)
 {
 	int ret;
-	u8 buf[len];
+	u8 buf[80];
 	struct i2c_msg msg[2] = {
 		{
 			.addr = priv->cfg->i2c_address,
@@ -76,6 +83,13 @@ static int tda18212_rd_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 		}
 	};
 
+	if (len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c rd reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EREMOTEIO;
+	}
+
 	ret = i2c_transfer(priv->i2c, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
diff --git a/drivers/media/tuners/tda18218.c b/drivers/media/tuners/tda18218.c
index 2d31aeb6b088..e4e662c2e6ef 100644
--- a/drivers/media/tuners/tda18218.c
+++ b/drivers/media/tuners/tda18218.c
@@ -24,7 +24,7 @@
 static int tda18218_wr_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
 {
 	int ret = 0, len2, remaining;
-	u8 buf[1 + len];
+	u8 buf[80];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->cfg->i2c_address,
@@ -33,6 +33,13 @@ static int tda18218_wr_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
 		}
 	};
 
+	if (1 + len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EREMOTEIO;
+	}
+
 	for (remaining = len; remaining > 0;
 			remaining -= (priv->cfg->i2c_wr_max - 1)) {
 		len2 = remaining;
@@ -63,7 +70,7 @@ static int tda18218_wr_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
 static int tda18218_rd_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
 {
 	int ret;
-	u8 buf[reg+len]; /* we must start read always from reg 0x00 */
+	u8 buf[80]; /* we must start read always from reg 0x00 */
 	struct i2c_msg msg[2] = {
 		{
 			.addr = priv->cfg->i2c_address,
@@ -78,6 +85,13 @@ static int tda18218_rd_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
 		}
 	};
 
+	if (reg + len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EREMOTEIO;
+	}
+
 	ret = i2c_transfer(priv->i2c, msg, 2);
 	if (ret == 2) {
 		memcpy(val, &buf[reg], len);
-- 
1.8.3.1

