Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:54298 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936133AbeF2Lng (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 07:43:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCHv5 05/12] media: rename MEDIA_ENT_F_DTV_DECODER to MEDIA_ENT_F_DV_DECODER
Date: Fri, 29 Jun 2018 13:43:24 +0200
Message-Id: <20180629114331.7617-6-hverkuil@xs4all.nl>
In-Reply-To: <20180629114331.7617-1-hverkuil@xs4all.nl>
References: <20180629114331.7617-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

The use of 'DTV' is very confusing since it normally refers to Digital
TV e.g. DVB etc.

Instead use 'DV' (Digital Video), which nicely corresponds to the
DV Timings API used to configure such receivers and transmitters.

We keep an alias to avoid breaking userspace applications.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 Documentation/media/uapi/mediactl/media-types.rst | 2 +-
 drivers/media/i2c/adv7604.c                       | 1 +
 drivers/media/i2c/adv7842.c                       | 1 +
 drivers/media/i2c/tda1997x.c                      | 2 +-
 include/uapi/linux/media.h                        | 4 +++-
 5 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/media/uapi/mediactl/media-types.rst b/Documentation/media/uapi/mediactl/media-types.rst
index 96910cf2eaaa..c11b0c7e890b 100644
--- a/Documentation/media/uapi/mediactl/media-types.rst
+++ b/Documentation/media/uapi/mediactl/media-types.rst
@@ -200,7 +200,7 @@ Types and flags used to represent the media graph elements
          MIPI CSI-2, etc.), and outputs them on its source pad to an output
          video bus of another type (eDP, MIPI CSI-2, parallel, etc.).
 
-    *  -  ``MEDIA_ENT_F_DTV_DECODER``
+    *  -  ``MEDIA_ENT_F_DV_DECODER``
        -  Digital video decoder. The basic function of the video decoder is
 	  to accept digital video from a wide variety of sources
 	  and output it in some digital video standard, with appropriate
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 1a3b2c04d9f9..668be2bca57a 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -3499,6 +3499,7 @@ static int adv76xx_probe(struct i2c_client *client,
 	for (i = 0; i < state->source_pad; ++i)
 		state->pads[i].flags = MEDIA_PAD_FL_SINK;
 	state->pads[state->source_pad].flags = MEDIA_PAD_FL_SOURCE;
+	sd->entity.function = MEDIA_ENT_F_DV_DECODER;
 
 	err = media_entity_pads_init(&sd->entity, state->source_pad + 1,
 				state->pads);
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index fddac32e5051..99d781343fb1 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -3541,6 +3541,7 @@ static int adv7842_probe(struct i2c_client *client,
 	INIT_DELAYED_WORK(&state->delayed_work_enable_hotplug,
 			adv7842_delayed_work_enable_hotplug);
 
+	sd->entity.function = MEDIA_ENT_F_DV_DECODER;
 	state->pad.flags = MEDIA_PAD_FL_SOURCE;
 	err = media_entity_pads_init(&sd->entity, 1, &state->pad);
 	if (err)
diff --git a/drivers/media/i2c/tda1997x.c b/drivers/media/i2c/tda1997x.c
index 039a92c3294a..d114ac5243ec 100644
--- a/drivers/media/i2c/tda1997x.c
+++ b/drivers/media/i2c/tda1997x.c
@@ -2570,7 +2570,7 @@ static int tda1997x_probe(struct i2c_client *client,
 		 id->name, i2c_adapter_id(client->adapter),
 		 client->addr);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
-	sd->entity.function = MEDIA_ENT_F_DTV_DECODER;
+	sd->entity.function = MEDIA_ENT_F_DV_DECODER;
 	sd->entity.ops = &tda1997x_media_ops;
 
 	/* set allowed mbus modes based on chip, bus-type, and bus-width */
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index ebd2cda67833..99f5e0978ebb 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -93,7 +93,7 @@ struct media_device_info {
  * Video decoder functions
  */
 #define MEDIA_ENT_F_ATV_DECODER			(MEDIA_ENT_F_OLD_SUBDEV_BASE + 4)
-#define MEDIA_ENT_F_DTV_DECODER			(MEDIA_ENT_F_BASE + 0x6001)
+#define MEDIA_ENT_F_DV_DECODER			(MEDIA_ENT_F_BASE + 0x6001)
 
 /*
  * Digital TV, analog TV, radio and/or software defined radio tuner functions.
@@ -400,6 +400,8 @@ struct media_v2_topology {
 #define MEDIA_ENT_T_V4L2_SUBDEV_DECODER		MEDIA_ENT_F_ATV_DECODER
 #define MEDIA_ENT_T_V4L2_SUBDEV_TUNER		MEDIA_ENT_F_TUNER
 
+#define MEDIA_ENT_F_DTV_DECODER			MEDIA_ENT_F_DV_DECODER
+
 /*
  * There is still no ALSA support in the media controller. These
  * defines should not have been added and we leave them here only
-- 
2.17.0
