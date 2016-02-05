Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44120 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbcBEJwb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Feb 2016 04:52:31 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Junghak Sung <jh1009.sung@samsung.com>,
	Geunyoung Kim <nenggun.kim@samsung.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 1/2] [media] v4l2-mc: add a generic function to create the media graph
Date: Fri,  5 Feb 2016 07:51:14 -0200
Message-Id: <6e3da35783650a6e555d20524421f4549d919821.1454665849.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The em28xx_v4l2_create_media_graph() is almost generic enough to
be at the core, as an ancillary function. Make it even more generic,
by getting rid of em28xx-specific code, relying only at the
media_device, in order to discover all entities found on PC-customer's
hardware and add it at the V4L2 core.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/v4l2-core/Makefile  |   1 +
 drivers/media/v4l2-core/v4l2-mc.c | 181 ++++++++++++++++++++++++++++++++++++++
 include/media/v4l2-mc.h           |  24 +++++
 3 files changed, 206 insertions(+)
 create mode 100644 drivers/media/v4l2-core/v4l2-mc.c

diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 1dc8bba2b198..795a5352761d 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -16,6 +16,7 @@ endif
 ifeq ($(CONFIG_TRACEPOINTS),y)
   videodev-objs += vb2-trace.o v4l2-trace.o
 endif
+videodev-$(CONFIG_MEDIA_CONTROLLER) += v4l2-mc.o
 
 obj-$(CONFIG_VIDEO_V4L2) += videodev.o
 obj-$(CONFIG_VIDEO_V4L2) += v4l2-common.o
diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
new file mode 100644
index 000000000000..7276dbbbe830
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-mc.c
@@ -0,0 +1,181 @@
+/*
+ * Media Controller ancillary functions
+ *
+ * (c) 2016 Mauro Carvalho Chehab <mchehab@osg.samsung.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <media/media-entity.h>
+#include <media/v4l2-mc.h>
+
+int v4l2_mc_create_media_graph(struct media_device *mdev)
+
+{
+	struct media_entity *entity;
+	struct media_entity *if_vid = NULL, *if_aud = NULL, *sensor = NULL;
+	struct media_entity *tuner = NULL, *decoder = NULL;
+	struct media_entity *io_v4l = NULL, *io_vbi = NULL, *io_swradio = NULL;
+	bool is_webcam = false;
+	int ret;
+
+	if (!mdev)
+		return 0;
+
+	media_device_for_each_entity(entity, mdev) {
+		switch (entity->function) {
+		case MEDIA_ENT_F_IF_VID_DECODER:
+			if_vid = entity;
+			break;
+		case MEDIA_ENT_F_IF_AUD_DECODER:
+			if_aud = entity;
+			break;
+		case MEDIA_ENT_F_TUNER:
+			tuner = entity;
+			break;
+		case MEDIA_ENT_F_ATV_DECODER:
+			decoder = entity;
+			break;
+		case MEDIA_ENT_F_IO_V4L:
+			io_v4l = entity;
+			break;
+		case MEDIA_ENT_F_IO_VBI:
+			io_vbi = entity;
+			break;
+		case MEDIA_ENT_F_IO_SWRADIO:
+			io_swradio = entity;
+			break;
+		case MEDIA_ENT_F_CAM_SENSOR:
+			sensor = entity;
+			is_webcam = true;
+			break;
+		}
+	}
+
+	/* It should have at least one I/O entity */
+	if (!io_v4l && !io_vbi && !io_swradio)
+		return -EINVAL;
+
+	/*
+	 * Here, webcams are modeled on a very simple way: the sensor is
+	 * connected directly to the I/O entity. All dirty details, like
+	 * scaler and crop HW are hidden. While such mapping is not enough
+	 * for mc-centric hardware, it is enough for v4l2 interface centric
+	 * PC-consumer's hardware.
+	 */
+	if (is_webcam) {
+		if (!io_v4l)
+			return -EINVAL;
+
+		media_device_for_each_entity(entity, mdev) {
+			if (entity->function != MEDIA_ENT_F_CAM_SENSOR)
+				continue;
+			ret = media_create_pad_link(entity, 0,
+						    io_v4l, 0,
+						    MEDIA_LNK_FL_ENABLED);
+			if (ret)
+				return ret;
+		}
+		if (!decoder)
+			return 0;
+	}
+
+	/* The device isn't a webcam. So, it should have a decoder */
+	if (!decoder)
+		return -EINVAL;
+
+	/* Link the tuner and IF video output pads */
+	if (tuner) {
+		if (if_vid) {
+			ret = media_create_pad_link(tuner, TUNER_PAD_OUTPUT,
+						    if_vid,
+						    IF_VID_DEC_PAD_IF_INPUT,
+						    MEDIA_LNK_FL_ENABLED);
+			if (ret)
+				return ret;
+			ret = media_create_pad_link(if_vid, IF_VID_DEC_PAD_OUT,
+						decoder, DEMOD_PAD_IF_INPUT,
+						MEDIA_LNK_FL_ENABLED);
+			if (ret)
+				return ret;
+		} else {
+			ret = media_create_pad_link(tuner, TUNER_PAD_OUTPUT,
+						decoder, DEMOD_PAD_IF_INPUT,
+						MEDIA_LNK_FL_ENABLED);
+			if (ret)
+				return ret;
+		}
+
+		if (if_aud) {
+			ret = media_create_pad_link(tuner, TUNER_PAD_AUD_OUT,
+						    if_aud,
+						    IF_AUD_DEC_PAD_IF_INPUT,
+						    MEDIA_LNK_FL_ENABLED);
+			if (ret)
+				return ret;
+		} else {
+			if_aud = tuner;
+		}
+
+	}
+
+	/* Create demod to V4L, VBI and SDR radio links */
+	if (io_v4l) {
+		ret = media_create_pad_link(decoder, DEMOD_PAD_VID_OUT,
+					io_v4l, 0,
+					MEDIA_LNK_FL_ENABLED);
+		if (ret)
+			return ret;
+	}
+
+	if (io_swradio) {
+		ret = media_create_pad_link(decoder, DEMOD_PAD_VID_OUT,
+					io_swradio, 0,
+					MEDIA_LNK_FL_ENABLED);
+		if (ret)
+			return ret;
+	}
+
+	if (io_vbi) {
+		ret = media_create_pad_link(decoder, DEMOD_PAD_VBI_OUT,
+					    io_vbi, 0,
+					    MEDIA_LNK_FL_ENABLED);
+		if (ret)
+			return ret;
+	}
+
+	/* Create links for the media connectors */
+	media_device_for_each_entity(entity, mdev) {
+		switch (entity->function) {
+		case MEDIA_ENT_F_CONN_RF:
+			if (!tuner)
+				continue;
+
+			ret = media_create_pad_link(entity, 0, tuner,
+						    TUNER_PAD_RF_INPUT,
+						    MEDIA_LNK_FL_ENABLED);
+			break;
+		case MEDIA_ENT_F_CONN_SVIDEO:
+		case MEDIA_ENT_F_CONN_COMPOSITE:
+		case MEDIA_ENT_F_CONN_TEST:
+			ret = media_create_pad_link(entity, 0, decoder,
+						    DEMOD_PAD_IF_INPUT, 0);
+			break;
+		default:
+			continue;
+		}
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_mc_create_media_graph);
diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
index df115195690e..3097493e6cf1 100644
--- a/include/media/v4l2-mc.h
+++ b/include/media/v4l2-mc.h
@@ -14,6 +14,8 @@
  * GNU General Public License for more details.
  */
 
+#include <media/media-device.h>
+
 /**
  * enum tuner_pad_index - tuner pad index for MEDIA_ENT_F_TUNER
  *
@@ -89,3 +91,25 @@ enum demod_pad_index {
 	DEMOD_PAD_VBI_OUT,
 	DEMOD_NUM_PADS
 };
+
+/**
+ * v4l2_mc_create_media_graph() - create Media Controller links at the graph.
+ *
+ * @mdev:	pointer to the &media_device struct.
+ *
+ * Add links between the entities commonly found on PC customer's hardware at
+ * the V4L2 side: camera sensors, audio and video PLL-IF decoders, tuners,
+ * analog TV decoder and I/O entities (video, VBI and Software Defined Radio).
+ * NOTE: webcams are modeled on a very simple way: the sensor is
+ * connected directly to the I/O entity. All dirty details, like
+ * scaler and crop HW are hidden. While such mapping is enough for v4l2
+ * interface centric PC-consumer's hardware, V4L2 subdev centric camera
+ * hardware should not use this routine, as it will not build the right graph.
+ */
+#ifdef CONFIG_MEDIA_CONTROLLER
+int v4l2_mc_create_media_graph(struct media_device *mdev);
+#else
+static inline int v4l2_mc_create_media_graph(struct media_device *mdev) {
+	return 0;
+}
+#endif
-- 
2.5.0

