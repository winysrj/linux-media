Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43275 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab3KENDt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 08:03:49 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 18/29] [media] tuners: Don't use dynamic static allocation
Date: Tue,  5 Nov 2013 08:01:31 -0200
Message-Id: <1383645702-30636-19-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
References: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
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
max data length of 64 bytes for	the control URBs.

So, it seem safe to use 64 bytes as the hard limit for all those devices.

 On most cases, the limit is a way lower than that, but	this limit
is small enough to not affect the Kernel stack, and it is a no brain
limit, as using smaller ones would require to either carefully each
driver or to take a look on each datasheet.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/tuners/e4000.c    | 21 +++++++++++++++++++--
 drivers/media/tuners/fc2580.c   | 21 +++++++++++++++++++--
 drivers/media/tuners/tda18212.c | 21 +++++++++++++++++++--
 drivers/media/tuners/tda18218.c | 21 +++++++++++++++++++--
 4 files changed, 76 insertions(+), 8 deletions(-)

diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index ad9309da4a91..30192463c9e1 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -20,11 +20,14 @@
 
 #include "e4000_priv.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 /* write multiple registers */
 static int e4000_wr_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
 {
 	int ret;
-	u8 buf[1 + len];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->cfg->i2c_addr,
@@ -34,6 +37,13 @@ static int e4000_wr_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
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
 
@@ -53,7 +63,7 @@ static int e4000_wr_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
 static int e4000_rd_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
 {
 	int ret;
-	u8 buf[len];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[2] = {
 		{
 			.addr = priv->cfg->i2c_addr,
@@ -68,6 +78,13 @@ static int e4000_rd_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
 		}
 	};
 
+	if (len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c rd reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	ret = i2c_transfer(priv->i2c, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index 81f38aae9c66..430fa5163ec7 100644
--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -20,6 +20,9 @@
 
 #include "fc2580_priv.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 /*
  * TODO:
  * I2C write and read works only for one single register. Multiple registers
@@ -41,7 +44,7 @@
 static int fc2580_wr_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
 {
 	int ret;
-	u8 buf[1 + len];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->cfg->i2c_addr,
@@ -51,6 +54,13 @@ static int fc2580_wr_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
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
 
@@ -69,7 +79,7 @@ static int fc2580_wr_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
 static int fc2580_rd_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
 {
 	int ret;
-	u8 buf[len];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[2] = {
 		{
 			.addr = priv->cfg->i2c_addr,
@@ -84,6 +94,13 @@ static int fc2580_rd_regs(struct fc2580_priv *priv, u8 reg, u8 *val, int len)
 		}
 	};
 
+	if (len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c rd reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	ret = i2c_transfer(priv->i2c, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
diff --git a/drivers/media/tuners/tda18212.c b/drivers/media/tuners/tda18212.c
index e4a84ee231cf..b3a4adf9ff8f 100644
--- a/drivers/media/tuners/tda18212.c
+++ b/drivers/media/tuners/tda18212.c
@@ -20,6 +20,9 @@
 
 #include "tda18212.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 struct tda18212_priv {
 	struct tda18212_config *cfg;
 	struct i2c_adapter *i2c;
@@ -32,7 +35,7 @@ static int tda18212_wr_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 	int len)
 {
 	int ret;
-	u8 buf[len+1];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->cfg->i2c_address,
@@ -42,6 +45,13 @@ static int tda18212_wr_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
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
 
@@ -61,7 +71,7 @@ static int tda18212_rd_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 	int len)
 {
 	int ret;
-	u8 buf[len];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[2] = {
 		{
 			.addr = priv->cfg->i2c_address,
@@ -76,6 +86,13 @@ static int tda18212_rd_regs(struct tda18212_priv *priv, u8 reg, u8 *val,
 		}
 	};
 
+	if (len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c rd reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	ret = i2c_transfer(priv->i2c, msg, 2);
 	if (ret == 2) {
 		memcpy(val, buf, len);
diff --git a/drivers/media/tuners/tda18218.c b/drivers/media/tuners/tda18218.c
index 2d31aeb6b088..7e2b32ee5349 100644
--- a/drivers/media/tuners/tda18218.c
+++ b/drivers/media/tuners/tda18218.c
@@ -20,11 +20,14 @@
 
 #include "tda18218_priv.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 /* write multiple registers */
 static int tda18218_wr_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
 {
 	int ret = 0, len2, remaining;
-	u8 buf[1 + len];
+	u8 buf[MAX_XFER_SIZE];
 	struct i2c_msg msg[1] = {
 		{
 			.addr = priv->cfg->i2c_address,
@@ -33,6 +36,13 @@ static int tda18218_wr_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
 		}
 	};
 
+	if (1 + len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	for (remaining = len; remaining > 0;
 			remaining -= (priv->cfg->i2c_wr_max - 1)) {
 		len2 = remaining;
@@ -63,7 +73,7 @@ static int tda18218_wr_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
 static int tda18218_rd_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
 {
 	int ret;
-	u8 buf[reg+len]; /* we must start read always from reg 0x00 */
+	u8 buf[MAX_XFER_SIZE]; /* we must start read always from reg 0x00 */
 	struct i2c_msg msg[2] = {
 		{
 			.addr = priv->cfg->i2c_address,
@@ -78,6 +88,13 @@ static int tda18218_rd_regs(struct tda18218_priv *priv, u8 reg, u8 *val, u8 len)
 		}
 	};
 
+	if (reg + len > sizeof(buf)) {
+		dev_warn(&priv->i2c->dev,
+			 "%s: i2c wr reg=%04x: len=%d is too big!\n",
+			 KBUILD_MODNAME, reg, len);
+		return -EINVAL;
+	}
+
 	ret = i2c_transfer(priv->i2c, msg, 2);
 	if (ret == 2) {
 		memcpy(val, &buf[reg], len);
-- 
1.8.3.1

