Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37305 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751329AbdHSLil (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Aug 2017 07:38:41 -0400
Received: by mail-wm0-f67.google.com with SMTP id t138so6825255wmt.4
        for <linux-media@vger.kernel.org>; Sat, 19 Aug 2017 04:38:41 -0700 (PDT)
From: Jemma Denson <jdenson@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Patrick Boettcher <pb@linuxtv.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v4] media: isl6421: add checks for current overflow
Date: Sat, 19 Aug 2017 12:38:26 +0100
Message-Id: <20170819113826.3503-1-jdenson@gmail.com>
In-Reply-To: <20170817193645.6159-1-jdenson@gmail.com>
References: <20170817193645.6159-1-jdenson@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This Kaffeine's BZ:
	https://bugs.kde.org/show_bug.cgi?id=374693

affects SkyStar S2 PCI DVB-S/S2 rev 3.3 device. It could be due to
a Kernel bug.

While checking the Isil 6421, comparing with its manual, available at:

	http://www.intersil.com/content/dam/Intersil/documents/isl6/isl6421a.pdf

It was noticed that, if the output load is highly capacitive, a different approach
is recomended when energizing the LNBf.

Also, it is possible to detect if a current overload is happening, by checking an
special flag.

Add support for it.

Tested on Skystar S2. Changes respect override_or option so should still work fine
on cx88 based cards which disable dynamic current limit.

Changes since v1:
v2 - fixed incorrect checking of i2c return values
v3 - fix if logic to check if dcl needs re-enabling
   - respect override_or values which aim to disable dcl
   - only do long sleep on overload if dcl enabled
   - add short sleep before re-enabling dcl
   - only check overload and potentially return EINVAL if device is on
v4 - revert v3 sleep logic changes to remove tuning delays

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Jemma Denson <jdenson@gmail.com>
---
 drivers/media/dvb-frontends/isl6421.c | 76 +++++++++++++++++++++++++++++++++--
 1 file changed, 72 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/isl6421.c b/drivers/media/dvb-frontends/isl6421.c
index 838b42771a05..3f3487887672 100644
--- a/drivers/media/dvb-frontends/isl6421.c
+++ b/drivers/media/dvb-frontends/isl6421.c
@@ -38,35 +38,101 @@ struct isl6421 {
 	u8			override_and;
 	struct i2c_adapter	*i2c;
 	u8			i2c_addr;
+	bool			is_off;
 };
 
 static int isl6421_set_voltage(struct dvb_frontend *fe,
 			       enum fe_sec_voltage voltage)
 {
+	int ret;
+	u8 buf;
+	bool is_off;
 	struct isl6421 *isl6421 = (struct isl6421 *) fe->sec_priv;
-	struct i2c_msg msg = {	.addr = isl6421->i2c_addr, .flags = 0,
-				.buf = &isl6421->config,
-				.len = sizeof(isl6421->config) };
+	struct i2c_msg msg[2] = {
+		{
+		  .addr = isl6421->i2c_addr,
+		  .flags = 0,
+		  .buf = &isl6421->config,
+		  .len = 1,
+		}, {
+		  .addr = isl6421->i2c_addr,
+		  .flags = I2C_M_RD,
+		  .buf = &buf,
+		  .len = 1,
+		}
+
+	};
 
 	isl6421->config &= ~(ISL6421_VSEL1 | ISL6421_EN1);
 
 	switch(voltage) {
 	case SEC_VOLTAGE_OFF:
+		is_off = true;
 		break;
 	case SEC_VOLTAGE_13:
+		is_off = false;
 		isl6421->config |= ISL6421_EN1;
 		break;
 	case SEC_VOLTAGE_18:
+		is_off = false;
 		isl6421->config |= (ISL6421_EN1 | ISL6421_VSEL1);
 		break;
 	default:
 		return -EINVAL;
 	}
 
+	/*
+	 * If LNBf were not powered on, disable dynamic current limit, as,
+	 * according with datasheet, highly capacitive load on the output may
+	 * cause a difficult start-up.
+	 */
+	if (isl6421->is_off && !is_off)
+		isl6421->config |= ISL6421_DCL;
+
 	isl6421->config |= isl6421->override_or;
 	isl6421->config &= isl6421->override_and;
 
-	return (i2c_transfer(isl6421->i2c, &msg, 1) == 1) ? 0 : -EIO;
+	ret = i2c_transfer(isl6421->i2c, msg, 2);
+	if (ret < 0)
+		return ret;
+	if (ret != 2)
+		return -EIO;
+
+	/* Store off status now incase future commands fail */
+	isl6421->is_off = is_off;
+
+	/* On overflow, the device will try again after 900 ms (typically) */
+	if (!is_off && (buf & ISL6421_OLF1))
+		msleep(1000);
+
+	/* Re-enable dynamic current limit */
+	if ((isl6421->config & ISL6421_DCL) &&
+	    !(isl6421->override_or & ISL6421_DCL)) {
+		isl6421->config &= ~ISL6421_DCL;
+
+		ret = i2c_transfer(isl6421->i2c, msg, 2);
+		if (ret < 0)
+			return ret;
+		if (ret != 2)
+			return -EIO;
+	}
+
+	/* Check if overload flag is active. If so, disable power */
+	if (!is_off && (buf & ISL6421_OLF1)) {
+		isl6421->config &= ~(ISL6421_VSEL1 | ISL6421_EN1);
+		ret = i2c_transfer(isl6421->i2c, msg, 1);
+		if (ret < 0)
+			return ret;
+		if (ret != 1)
+			return -EIO;
+		isl6421->is_off = true;
+
+		dev_warn(&isl6421->i2c->dev,
+			 "Overload current detected. disabling LNBf power\n");
+		return -EINVAL;
+	}
+
+	return 0;
 }
 
 static int isl6421_enable_high_lnb_voltage(struct dvb_frontend *fe, long arg)
@@ -148,6 +214,8 @@ struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe, struct i2c_adapter
 		return NULL;
 	}
 
+	isl6421->is_off = true;
+
 	/* install release callback */
 	fe->ops.release_sec = isl6421_release;
 
-- 
2.13.4
