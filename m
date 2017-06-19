Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56873 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750925AbdFSRBE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 13:01:04 -0400
From: Helen Koike <helen.koike@collabora.com>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, jgebben@codeaurora.org,
        mchehab@osg.samsung.com, Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v5 01/12] [media] vimc: sen: Integrate the tpg on the sensor
Date: Mon, 19 Jun 2017 14:00:10 -0300
Message-Id: <1497891629-1562-2-git-send-email-helen.koike@collabora.com>
In-Reply-To: <1497891629-1562-1-git-send-email-helen.koike@collabora.com>
References: <1497891629-1562-1-git-send-email-helen.koike@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialize the test pattern generator on the sensor
Generate a colored bar image instead of a grey one

Signed-off-by: Helen Koike <helen.koike@collabora.com>

---

Changes in v5: None
Changes in v4: None
Changes in v3:
[media] vimc: sen: Integrate the tpg on the sensor
	- Declare frame_size as a local variable
	- Set tpg frame format before starting kthread
	- s_stream(sd, 1): return 0 if stream is already enabled
	- s_stream(sd, 0): return 0 if stream is already disabled
	- s_stream: propagate error from kthread_stop
	- coding style when calling tpg_s_bytesperline
	- s/vimc_thread_sen/vimc_sen_tpg_thread
	- fix multiline comment
	- remove V4L2_FIELD_ALTERNATE from tpg_s_field
	- remove V4L2_STD_PAL from tpg_fill_plane_buffer

Changes in v2:
[media] vimc: sen: Integrate the tpg on the sensor
	- Fix include location
	- Select V4L2_TPG in Kconfig
	- configure tpg on streamon only
	- rm BUG_ON
	- coding style


---
 drivers/media/platform/vimc/Kconfig       |  1 +
 drivers/media/platform/vimc/vimc-sensor.c | 64 ++++++++++++++++++++++++-------
 2 files changed, 52 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/vimc/Kconfig b/drivers/media/platform/vimc/Kconfig
index a18f635..71c9fe7 100644
--- a/drivers/media/platform/vimc/Kconfig
+++ b/drivers/media/platform/vimc/Kconfig
@@ -2,6 +2,7 @@ config VIDEO_VIMC
 	tristate "Virtual Media Controller Driver (VIMC)"
 	depends on VIDEO_DEV && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	select VIDEOBUF2_VMALLOC
+	select VIDEO_V4L2_TPG
 	default n
 	---help---
 	  Skeleton driver for Virtual Media Controller
diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
index 591f6a4..2e83487 100644
--- a/drivers/media/platform/vimc/vimc-sensor.c
+++ b/drivers/media/platform/vimc/vimc-sensor.c
@@ -20,17 +20,20 @@
 #include <linux/v4l2-mediabus.h>
 #include <linux/vmalloc.h>
 #include <media/v4l2-subdev.h>
+#include <media/v4l2-tpg.h>
 
 #include "vimc-sensor.h"
 
+#define VIMC_SEN_FRAME_MAX_WIDTH 4096
+
 struct vimc_sen_device {
 	struct vimc_ent_device ved;
 	struct v4l2_subdev sd;
+	struct tpg_data tpg;
 	struct task_struct *kthread_sen;
 	u8 *frame;
 	/* The active format */
 	struct v4l2_mbus_framefmt mbus_format;
-	int frame_size;
 };
 
 static int vimc_sen_enum_mbus_code(struct v4l2_subdev *sd,
@@ -84,6 +87,24 @@ static int vimc_sen_get_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static void vimc_sen_tpg_s_format(struct vimc_sen_device *vsen)
+{
+	const struct vimc_pix_map *vpix =
+				vimc_pix_map_by_code(vsen->mbus_format.code);
+
+	tpg_reset_source(&vsen->tpg, vsen->mbus_format.width,
+			 vsen->mbus_format.height, vsen->mbus_format.field);
+	tpg_s_bytesperline(&vsen->tpg, 0, vsen->mbus_format.width * vpix->bpp);
+	tpg_s_buf_height(&vsen->tpg, vsen->mbus_format.height);
+	tpg_s_fourcc(&vsen->tpg, vpix->pixelformat);
+	/* TODO: add support for V4L2_FIELD_ALTERNATE */
+	tpg_s_field(&vsen->tpg, vsen->mbus_format.field, false);
+	tpg_s_colorspace(&vsen->tpg, vsen->mbus_format.colorspace);
+	tpg_s_ycbcr_enc(&vsen->tpg, vsen->mbus_format.ycbcr_enc);
+	tpg_s_quantization(&vsen->tpg, vsen->mbus_format.quantization);
+	tpg_s_xfer_func(&vsen->tpg, vsen->mbus_format.xfer_func);
+}
+
 static const struct v4l2_subdev_pad_ops vimc_sen_pad_ops = {
 	.enum_mbus_code		= vimc_sen_enum_mbus_code,
 	.enum_frame_size	= vimc_sen_enum_frame_size,
@@ -97,7 +118,7 @@ static const struct media_entity_operations vimc_sen_mops = {
 	.link_validate = v4l2_subdev_link_validate,
 };
 
-static int vimc_thread_sen(void *data)
+static int vimc_sen_tpg_thread(void *data)
 {
 	struct vimc_sen_device *vsen = data;
 	unsigned int i;
@@ -110,7 +131,7 @@ static int vimc_thread_sen(void *data)
 		if (kthread_should_stop())
 			break;
 
-		memset(vsen->frame, 100, vsen->frame_size);
+		tpg_fill_plane_buffer(&vsen->tpg, 0, 0, vsen->frame);
 
 		/* Send the frame to all source pads */
 		for (i = 0; i < vsen->sd.entity.num_pads; i++)
@@ -132,26 +153,31 @@ static int vimc_sen_s_stream(struct v4l2_subdev *sd, int enable)
 
 	if (enable) {
 		const struct vimc_pix_map *vpix;
+		unsigned int frame_size;
 
 		if (vsen->kthread_sen)
-			return -EINVAL;
+			/* tpg is already executing */
+			return 0;
 
 		/* Calculate the frame size */
 		vpix = vimc_pix_map_by_code(vsen->mbus_format.code);
-		vsen->frame_size = vsen->mbus_format.width * vpix->bpp *
-				   vsen->mbus_format.height;
+		frame_size = vsen->mbus_format.width * vpix->bpp *
+			     vsen->mbus_format.height;
 
 		/*
 		 * Allocate the frame buffer. Use vmalloc to be able to
 		 * allocate a large amount of memory
 		 */
-		vsen->frame = vmalloc(vsen->frame_size);
+		vsen->frame = vmalloc(frame_size);
 		if (!vsen->frame)
 			return -ENOMEM;
 
+		/* configure the test pattern generator */
+		vimc_sen_tpg_s_format(vsen);
+
 		/* Initialize the image generator thread */
-		vsen->kthread_sen = kthread_run(vimc_thread_sen, vsen, "%s-sen",
-						vsen->sd.v4l2_dev->name);
+		vsen->kthread_sen = kthread_run(vimc_sen_tpg_thread, vsen,
+					"%s-sen", vsen->sd.v4l2_dev->name);
 		if (IS_ERR(vsen->kthread_sen)) {
 			dev_err(vsen->sd.v4l2_dev->dev,
 				"%s: kernel_thread() failed\n",	vsen->sd.name);
@@ -161,15 +187,17 @@ static int vimc_sen_s_stream(struct v4l2_subdev *sd, int enable)
 		}
 	} else {
 		if (!vsen->kthread_sen)
-			return -EINVAL;
+			return 0;
 
 		/* Stop image generator */
 		ret = kthread_stop(vsen->kthread_sen);
-		vsen->kthread_sen = NULL;
+		if (ret)
+			return ret;
 
+		vsen->kthread_sen = NULL;
 		vfree(vsen->frame);
 		vsen->frame = NULL;
-		return ret;
+		return 0;
 	}
 
 	return 0;
@@ -189,6 +217,7 @@ static void vimc_sen_destroy(struct vimc_ent_device *ved)
 	struct vimc_sen_device *vsen =
 				container_of(ved, struct vimc_sen_device, ved);
 
+	tpg_free(&vsen->tpg);
 	v4l2_device_unregister_subdev(&vsen->sd);
 	media_entity_cleanup(ved->ent);
 	kfree(vsen);
@@ -254,17 +283,26 @@ struct vimc_ent_device *vimc_sen_create(struct v4l2_device *v4l2_dev,
 	vsen->mbus_format.quantization = V4L2_QUANTIZATION_FULL_RANGE;
 	vsen->mbus_format.xfer_func = V4L2_XFER_FUNC_SRGB;
 
+	/* Initialize the test pattern generator */
+	tpg_init(&vsen->tpg, vsen->mbus_format.width,
+		 vsen->mbus_format.height);
+	ret = tpg_alloc(&vsen->tpg, VIMC_SEN_FRAME_MAX_WIDTH);
+	if (ret)
+		goto err_clean_m_ent;
+
 	/* Register the subdev with the v4l2 and the media framework */
 	ret = v4l2_device_register_subdev(v4l2_dev, &vsen->sd);
 	if (ret) {
 		dev_err(vsen->sd.v4l2_dev->dev,
 			"%s: subdev register failed (err=%d)\n",
 			vsen->sd.name, ret);
-		goto err_clean_m_ent;
+		goto err_free_tpg;
 	}
 
 	return &vsen->ved;
 
+err_free_tpg:
+	tpg_free(&vsen->tpg);
 err_clean_m_ent:
 	media_entity_cleanup(&vsen->sd.entity);
 err_clean_pads:
-- 
2.7.4
