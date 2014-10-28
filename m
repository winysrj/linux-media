Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46266 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbaJ1PA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Oct 2014 11:00:59 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Ira Krufky <mkrufky@linuxtv.org>,
	Fred Richter <frichter@hauppauge.com>
Subject: [PATCH 02/13] [media] lgdt3306a: Use IS_ENABLED() for attach function
Date: Tue, 28 Oct 2014 13:00:37 -0200
Message-Id: <87ac8bc45c90a90f848e5396de2ec9fdcab5bec5.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1414507927.git.mchehab@osg.samsung.com>
References: <cover.1414507927.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Simplify the check if CONFIG_DVB_LGDT3306A is enabled, use the
IS_ENABLED() macro, just like the other frontend modules.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-frontends/lgdt3306a.c b/drivers/media/dvb-frontends/lgdt3306a.c
index 99128d2afebb..c8af071ce40b 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.c
+++ b/drivers/media/dvb-frontends/lgdt3306a.c
@@ -1662,7 +1662,7 @@ static void lgdt3306a_release(struct dvb_frontend *fe)
 static struct dvb_frontend_ops lgdt3306a_ops;
 
 struct dvb_frontend *lgdt3306a_attach(const struct lgdt3306a_config *config,
-				     struct i2c_adapter *i2c_adap)
+				      struct i2c_adapter *i2c_adap)
 {
 	struct lgdt3306a_state *state = NULL;
 	int ret;
diff --git a/drivers/media/dvb-frontends/lgdt3306a.h b/drivers/media/dvb-frontends/lgdt3306a.h
index f489a1fcc5ac..405beebb86e1 100644
--- a/drivers/media/dvb-frontends/lgdt3306a.h
+++ b/drivers/media/dvb-frontends/lgdt3306a.h
@@ -63,15 +63,13 @@ struct lgdt3306a_config {
 	int  xtalMHz;
 };
 
-#if defined(CONFIG_DVB_LGDT3306A) || (defined(CONFIG_DVB_LGDT3306A_MODULE) && \
-				     defined(MODULE))
-extern
+#if IS_ENABLED(CONFIG_DVB_LGDT3306A)
 struct dvb_frontend *lgdt3306a_attach(const struct lgdt3306a_config *config,
-				     struct i2c_adapter *i2c_adap);
+				      struct i2c_adapter *i2c_adap);
 #else
 static inline
 struct dvb_frontend *lgdt3306a_attach(const struct lgdt3306a_config *config,
-				     struct i2c_adapter *i2c_adap)
+				      struct i2c_adapter *i2c_adap)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
-- 
1.9.3

