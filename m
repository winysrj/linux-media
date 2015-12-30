Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52499 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbbL3Ntk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2015 08:49:40 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6/6] [media] mxl111sf: Add a tuner entity
Date: Wed, 30 Dec 2015 11:48:56 -0200
Message-Id: <b408292fe9c107eeca30df484f684dc287983bd7.1451482760.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1451482760.git.mchehab@osg.samsung.com>
References: <cover.1451482760.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1451482760.git.mchehab@osg.samsung.com>
References: <cover.1451482760.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While mxl111sf may have multiple frontends, it has just one
tuner. Reflect that on the media graph.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/dvb-core/dvbdev.h         |  6 ++++++
 drivers/media/usb/dvb-usb-v2/mxl111sf.c | 20 ++++++++++++++++++++
 drivers/media/usb/dvb-usb-v2/mxl111sf.h |  5 +++++
 3 files changed, 31 insertions(+)

diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index d7c67baa885e..4aff7bd3dea8 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -242,6 +242,11 @@ static inline void dvb_register_media_controller(struct dvb_adapter *adap,
 	adap->mdev = mdev;
 }
 
+static inline struct media_device
+*dvb_get_media_controller(struct dvb_adapter *adap)
+{
+	return adap->mdev;
+}
 #else
 static inline
 int dvb_create_media_graph(struct dvb_adapter *adap,
@@ -250,6 +255,7 @@ int dvb_create_media_graph(struct dvb_adapter *adap,
 	return 0;
 };
 #define dvb_register_media_controller(a, b) {}
+#define dvb_get_media_controller(a) NULL
 #endif
 
 int dvb_generic_open (struct inode *inode, struct file *file);
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index 1710f9038d75..b669deccc34c 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -10,6 +10,7 @@
 
 #include <linux/vmalloc.h>
 #include <linux/i2c.h>
+#include <media/tuner.h>
 
 #include "mxl111sf.h"
 #include "mxl111sf-reg.h"
@@ -868,6 +869,10 @@ static struct mxl111sf_tuner_config mxl_tuner_config = {
 static int mxl111sf_attach_tuner(struct dvb_usb_adapter *adap)
 {
 	struct mxl111sf_state *state = adap_to_priv(adap);
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+	struct media_device *mdev = dvb_get_media_controller(&adap->dvb_adap);
+	int ret;
+#endif
 	int i;
 
 	pr_debug("%s()\n", __func__);
@@ -879,6 +884,21 @@ static int mxl111sf_attach_tuner(struct dvb_usb_adapter *adap)
 		adap->fe[i]->ops.read_signal_strength = adap->fe[i]->ops.tuner_ops.get_rf_strength;
 	}
 
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+	state->tuner.function = MEDIA_ENT_F_TUNER;
+	state->tuner.name = "mxl111sf tuner";
+	state->tuner_pads[TUNER_PAD_RF_INPUT].flags = MEDIA_PAD_FL_SINK;
+	state->tuner_pads[TUNER_PAD_IF_OUTPUT].flags = MEDIA_PAD_FL_SOURCE;
+
+	ret = media_entity_pads_init(&state->tuner,
+				     TUNER_NUM_PADS, state->tuner_pads);
+	if (ret)
+		return ret;
+
+	ret = media_device_register_entity(mdev, &state->tuner);
+	if (ret)
+		return ret;
+#endif
 	return 0;
 }
 
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.h b/drivers/media/usb/dvb-usb-v2/mxl111sf.h
index ee70df1f1e94..846260e0eec0 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.h
@@ -17,6 +17,7 @@
 #define DVB_USB_LOG_PREFIX "mxl111sf"
 #include "dvb_usb.h"
 #include <media/tveeprom.h>
+#include <media/media-entity.h>
 
 #define MXL_EP1_REG_READ     1
 #define MXL_EP2_REG_WRITE    2
@@ -85,6 +86,10 @@ struct mxl111sf_state {
 	struct mutex fe_lock;
 	u8 num_frontends;
 	struct mxl111sf_adap_state adap_state[3];
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+	struct media_entity tuner;
+	struct media_pad tuner_pads[2];
+#endif
 };
 
 int mxl111sf_read_reg(struct mxl111sf_state *state, u8 addr, u8 *data);
-- 
2.5.0


