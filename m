Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34831 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbcBLJqb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2016 04:46:31 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 09/11] [media] si2157: register as a tuner entity
Date: Fri, 12 Feb 2016 07:45:04 -0200
Message-Id: <7c267b5c748d508b417fdacbc2954e71170135db.1455269986.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1455269986.git.mchehab@osg.samsung.com>
References: <cover.1455269986.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1455269986.git.mchehab@osg.samsung.com>
References: <cover.1455269986.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As this tuner doesn't use the usual subdev interface, we need
to register it manually.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/tuners/si2157.c      | 32 +++++++++++++++++++++++++++++++-
 drivers/media/tuners/si2157.h      |  5 +++++
 drivers/media/tuners/si2157_priv.h |  8 ++++++++
 3 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 3450dfb7c427..243ac3816028 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -403,7 +403,7 @@ err:
 }
 
 static int si2157_probe(struct i2c_client *client,
-		const struct i2c_device_id *id)
+			const struct i2c_device_id *id)
 {
 	struct si2157_config *cfg = client->dev.platform_data;
 	struct dvb_frontend *fe = cfg->fe;
@@ -438,6 +438,31 @@ static int si2157_probe(struct i2c_client *client,
 	memcpy(&fe->ops.tuner_ops, &si2157_ops, sizeof(struct dvb_tuner_ops));
 	fe->tuner_priv = client;
 
+#ifdef CONFIG_MEDIA_CONTROLLER
+	if (cfg->mdev) {
+		dev->mdev = cfg->mdev;
+
+		dev->ent.name = KBUILD_MODNAME;
+		dev->ent.function = MEDIA_ENT_F_TUNER;
+
+		dev->pad[TUNER_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
+		dev->pad[TUNER_PAD_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
+		dev->pad[TUNER_PAD_AUD_OUT].flags = MEDIA_PAD_FL_SOURCE;
+
+		ret = media_entity_pads_init(&dev->ent, TUNER_NUM_PADS,
+					     &dev->pad[0]);
+
+		if (ret)
+			goto err_kfree;
+
+		ret = media_device_register_entity(cfg->mdev, &dev->ent);
+		if (ret) {
+			media_entity_cleanup(&dev->ent);
+			goto err_kfree;
+		}
+	}
+#endif
+
 	dev_info(&client->dev, "Silicon Labs %s successfully attached\n",
 			dev->chiptype == SI2157_CHIPTYPE_SI2146 ?
 			"Si2146" : "Si2147/2148/2157/2158");
@@ -461,6 +486,11 @@ static int si2157_remove(struct i2c_client *client)
 	/* stop statistics polling */
 	cancel_delayed_work_sync(&dev->stat_work);
 
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+	if (dev->mdev)
+		media_device_unregister_entity(&dev->ent);
+#endif
+
 	memset(&fe->ops.tuner_ops, 0, sizeof(struct dvb_tuner_ops));
 	fe->tuner_priv = NULL;
 	kfree(dev);
diff --git a/drivers/media/tuners/si2157.h b/drivers/media/tuners/si2157.h
index 4db97ab744d6..5f1a60bf7ced 100644
--- a/drivers/media/tuners/si2157.h
+++ b/drivers/media/tuners/si2157.h
@@ -18,6 +18,7 @@
 #define SI2157_H
 
 #include <linux/kconfig.h>
+#include <media/media-device.h>
 #include "dvb_frontend.h"
 
 /*
@@ -30,6 +31,10 @@ struct si2157_config {
 	 */
 	struct dvb_frontend *fe;
 
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_device *mdev;
+#endif
+
 	/*
 	 * Spectral Inversion
 	 */
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index ecc463db8f69..589d558d381c 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -18,6 +18,7 @@
 #define SI2157_PRIV_H
 
 #include <linux/firmware.h>
+#include <media/v4l2-mc.h>
 #include "si2157.h"
 
 /* state struct */
@@ -31,6 +32,13 @@ struct si2157_dev {
 	u8 if_port;
 	u32 if_frequency;
 	struct delayed_work stat_work;
+
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_device	*mdev;
+	struct media_entity	ent;
+	struct media_pad	pad[TUNER_NUM_PADS];
+#endif
+
 };
 
 #define SI2157_CHIPTYPE_SI2157 0
-- 
2.5.0


