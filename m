Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52377 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756497Ab2IMAY0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 20:24:26 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 03/16] ec100: use Kernel dev_foo() logging
Date: Thu, 13 Sep 2012 03:23:44 +0300
Message-Id: <1347495837-3244-3-git-send-email-crope@iki.fi>
In-Reply-To: <1347495837-3244-1-git-send-email-crope@iki.fi>
References: <1347495837-3244-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/ec100.c      | 23 ++++++++-----------
 drivers/media/dvb-frontends/ec100.h      |  2 +-
 drivers/media/dvb-frontends/ec100_priv.h | 39 --------------------------------
 3 files changed, 11 insertions(+), 53 deletions(-)
 delete mode 100644 drivers/media/dvb-frontends/ec100_priv.h

diff --git a/drivers/media/dvb-frontends/ec100.c b/drivers/media/dvb-frontends/ec100.c
index c56fddb..b4ea34c 100644
--- a/drivers/media/dvb-frontends/ec100.c
+++ b/drivers/media/dvb-frontends/ec100.c
@@ -20,13 +20,8 @@
  */
 
 #include "dvb_frontend.h"
-#include "ec100_priv.h"
 #include "ec100.h"
 
-int ec100_debug;
-module_param_named(debug, ec100_debug, int, 0644);
-MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
-
 struct ec100_state {
 	struct i2c_adapter *i2c;
 	struct dvb_frontend frontend;
@@ -46,7 +41,8 @@ static int ec100_write_reg(struct ec100_state *state, u8 reg, u8 val)
 		.buf = buf};
 
 	if (i2c_transfer(state->i2c, &msg, 1) != 1) {
-		warn("I2C write failed reg:%02x", reg);
+		dev_warn(&state->i2c->dev, "%s: i2c wr failed reg=%02x\n",
+				KBUILD_MODNAME, reg);
 		return -EREMOTEIO;
 	}
 	return 0;
@@ -70,7 +66,8 @@ static int ec100_read_reg(struct ec100_state *state, u8 reg, u8 *val)
 	};
 
 	if (i2c_transfer(state->i2c, msg, 2) != 2) {
-		warn("I2C read failed reg:%02x", reg);
+		dev_warn(&state->i2c->dev, "%s: i2c rd failed reg=%02x\n",
+				KBUILD_MODNAME, reg);
 		return -EREMOTEIO;
 	}
 	return 0;
@@ -83,8 +80,8 @@ static int ec100_set_frontend(struct dvb_frontend *fe)
 	int ret;
 	u8 tmp, tmp2;
 
-	deb_info("%s: freq:%d bw:%d\n", __func__, c->frequency,
-		c->bandwidth_hz);
+	dev_dbg(&state->i2c->dev, "%s: frequency=%d bandwidth_hz=%d\n",
+			__func__, c->frequency, c->bandwidth_hz);
 
 	/* program tuner */
 	if (fe->ops.tuner_ops.set_params)
@@ -150,7 +147,7 @@ static int ec100_set_frontend(struct dvb_frontend *fe)
 
 	return ret;
 error:
-	deb_info("%s: failed:%d\n", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -196,7 +193,7 @@ static int ec100_read_status(struct dvb_frontend *fe, fe_status_t *status)
 
 	return ret;
 error:
-	deb_info("%s: failed:%d\n", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -228,7 +225,7 @@ static int ec100_read_ber(struct dvb_frontend *fe, u32 *ber)
 
 	return ret;
 error:
-	deb_info("%s: failed:%d\n", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
@@ -248,7 +245,7 @@ static int ec100_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 
 	return ret;
 error:
-	deb_info("%s: failed:%d\n", __func__, ret);
+	dev_dbg(&state->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
 }
 
diff --git a/drivers/media/dvb-frontends/ec100.h b/drivers/media/dvb-frontends/ec100.h
index ee8e524..b847971 100644
--- a/drivers/media/dvb-frontends/ec100.h
+++ b/drivers/media/dvb-frontends/ec100.h
@@ -38,7 +38,7 @@ extern struct dvb_frontend *ec100_attach(const struct ec100_config *config,
 static inline struct dvb_frontend *ec100_attach(
 	const struct ec100_config *config, struct i2c_adapter *i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif
diff --git a/drivers/media/dvb-frontends/ec100_priv.h b/drivers/media/dvb-frontends/ec100_priv.h
deleted file mode 100644
index 5c99014..0000000
--- a/drivers/media/dvb-frontends/ec100_priv.h
+++ /dev/null
@@ -1,39 +0,0 @@
-/*
- * E3C EC100 demodulator driver
- *
- * Copyright (C) 2009 Antti Palosaari <crope@iki.fi>
- *
- *    This program is free software; you can redistribute it and/or modify
- *    it under the terms of the GNU General Public License as published by
- *    the Free Software Foundation; either version 2 of the License, or
- *    (at your option) any later version.
- *
- *    This program is distributed in the hope that it will be useful,
- *    but WITHOUT ANY WARRANTY; without even the implied warranty of
- *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *    GNU General Public License for more details.
- *
- *    You should have received a copy of the GNU General Public License
- *    along with this program; if not, write to the Free Software
- *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- */
-
-#ifndef EC100_PRIV
-#define EC100_PRIV
-
-#define LOG_PREFIX "ec100"
-
-#define dprintk(var, level, args...) \
-	do { if ((var & level)) printk(args); } while (0)
-
-#define deb_info(args...) dprintk(ec100_debug, 0x01, args)
-
-#undef err
-#define err(f, arg...)  printk(KERN_ERR     LOG_PREFIX": " f "\n" , ## arg)
-#undef info
-#define info(f, arg...) printk(KERN_INFO    LOG_PREFIX": " f "\n" , ## arg)
-#undef warn
-#define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
-
-#endif /* EC100_PRIV */
-- 
1.7.11.4

