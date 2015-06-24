Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33357 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbbFXKtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 06:49:53 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/7] [media] tuner-i2c: be consistent with I2C declaration
Date: Wed, 24 Jun 2015 07:49:06 -0300
Message-Id: <ceefaf5d8e04414a8d9323d6647f36103e8747b7.1435142906.git.mchehab@osg.samsung.com>
In-Reply-To: <dd7a2acf5b7da9449988a99fe671349b3e5ec593.1435142906.git.mchehab@osg.samsung.com>
References: <dd7a2acf5b7da9449988a99fe671349b3e5ec593.1435142906.git.mchehab@osg.samsung.com>
In-Reply-To: <dd7a2acf5b7da9449988a99fe671349b3e5ec593.1435142906.git.mchehab@osg.samsung.com>
References: <dd7a2acf5b7da9449988a99fe671349b3e5ec593.1435142906.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On alpha, gcc warns a log about signed/unsigned ballance, with
produces 3185 warnings. Ok, this is bogus, but it indicates that
the declaration at V4L2 side is not consistent with the one at
I2C.

With this trivial patch, the number of errors reduce to 2959
warnings. Still too much, but it is 7.1% less. So let's do it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/tuners/tuner-i2c.h b/drivers/media/tuners/tuner-i2c.h
index 18f005634c67..bda67a5a76f2 100644
--- a/drivers/media/tuners/tuner-i2c.h
+++ b/drivers/media/tuners/tuner-i2c.h
@@ -33,7 +33,8 @@ struct tuner_i2c_props {
 	char *name;
 };
 
-static inline int tuner_i2c_xfer_send(struct tuner_i2c_props *props, char *buf, int len)
+static inline int tuner_i2c_xfer_send(struct tuner_i2c_props *props,
+				      unsigned char *buf, int len)
 {
 	struct i2c_msg msg = { .addr = props->addr, .flags = 0,
 			       .buf = buf, .len = len };
@@ -42,7 +43,8 @@ static inline int tuner_i2c_xfer_send(struct tuner_i2c_props *props, char *buf,
 	return (ret == 1) ? len : ret;
 }
 
-static inline int tuner_i2c_xfer_recv(struct tuner_i2c_props *props, char *buf, int len)
+static inline int tuner_i2c_xfer_recv(struct tuner_i2c_props *props,
+				      unsigned char *buf, int len)
 {
 	struct i2c_msg msg = { .addr = props->addr, .flags = I2C_M_RD,
 			       .buf = buf, .len = len };
@@ -52,8 +54,8 @@ static inline int tuner_i2c_xfer_recv(struct tuner_i2c_props *props, char *buf,
 }
 
 static inline int tuner_i2c_xfer_send_recv(struct tuner_i2c_props *props,
-					   char *obuf, int olen,
-					   char *ibuf, int ilen)
+					   unsigned char *obuf, int olen,
+					   unsigned char *ibuf, int ilen)
 {
 	struct i2c_msg msg[2] = { { .addr = props->addr, .flags = 0,
 				    .buf = obuf, .len = olen },
-- 
2.4.3

