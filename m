Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:57996 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753158AbdDGWhf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Apr 2017 18:37:35 -0400
From: Helen Koike <helen.koike@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, jgebben@codeaurora.org,
        mchehab@osg.samsung.com, Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v2 1/7] [media] vimc: sen: Integrate the tpg on the sensor
Date: Fri,  7 Apr 2017 19:37:06 -0300
Message-Id: <1491604632-23544-2-git-send-email-helen.koike@collabora.com>
In-Reply-To: <1491604632-23544-1-git-send-email-helen.koike@collabora.com>
References: <cover.1438891530.git.helen.fornazier@gmail.com>
 <1491604632-23544-1-git-send-email-helen.koike@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialize the test pattern generator on the sensor
Generate a colored bar image instead of a grey one

Signed-off-by: Helen Koike <helen.koike@collabora.com>

---

Changes in v2:
[media] vimc: sen: Integrate the tpg on the sensor
	- Fix include location
	- Select V4L2_TPG in Kconfig
	- configure tpg on streamon only
	- rm BUG_ON
	- coding style


---
 drivers/media/platform/vimc/Kconfig       |  1 +
 drivers/media/platform/vimc/vimc-sensor.c | 43 +++++++++++++++++++++++++++++--
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vimc/Kconfig b/drivers/media/platform/vimc/Kconfig
index dd285fa..df124d4 100644
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
index 591f6a4..9154322 100644
--- a/drivers/media/platform/vimc/vimc-sensor.c
+++ b/drivers/media/platform/vimc/vimc-sensor.c
@@ -20,12 +20,16 @@
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
@@ -84,6 +88,28 @@ static int vimc_sen_get_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static void vimc_sen_tpg_s_format(struct vimc_sen_device *vsen)
+{
+	const struct vimc_pix_map *vpix =
+				vimc_pix_map_by_code(vsen->mbus_format.code);
+
+	tpg_reset_source(&vsen->tpg, vsen->mbus_format.width,
+			 vsen->mbus_format.height, vsen->mbus_format.field);
+	tpg_s_bytesperline(&vsen->tpg, 0,
+			   vsen->mbus_format.width * vpix->bpp);
+	tpg_s_buf_height(&vsen->tpg, vsen->mbus_format.height);
+	tpg_s_fourcc(&vsen->tpg, vpix->pixelformat);
+	/* TODO: check why the tpg_s_field need this third argument if
+	 * it is already receiving the field
+	 */
+	tpg_s_field(&vsen->tpg, vsen->mbus_format.field,
+		    vsen->mbus_format.field == V4L2_FIELD_ALTERNATE);
+	tpg_s_colorspace(&vsen->tpg, vsen->mbus_format.colorspace);
+	tpg_s_ycbcr_enc(&vsen->tpg, vsen->mbus_format.ycbcr_enc);
+	tpg_s_quantization(&vsen->tpg, vsen->mbus_format.quantization);
+	tpg_s_xfer_func(&vsen->tpg, vsen->mbus_format.xfer_func);
+}
+
 static const struct v4l2_subdev_pad_ops vimc_sen_pad_ops = {
 	.enum_mbus_code		= vimc_sen_enum_mbus_code,
 	.enum_frame_size	= vimc_sen_enum_frame_size,
@@ -110,7 +136,7 @@ static int vimc_thread_sen(void *data)
 		if (kthread_should_stop())
 			break;
 
-		memset(vsen->frame, 100, vsen->frame_size);
+		tpg_fill_plane_buffer(&vsen->tpg, V4L2_STD_PAL, 0, vsen->frame);
 
 		/* Send the frame to all source pads */
 		for (i = 0; i < vsen->sd.entity.num_pads; i++)
@@ -159,6 +185,9 @@ static int vimc_sen_s_stream(struct v4l2_subdev *sd, int enable)
 			vsen->frame = NULL;
 			return PTR_ERR(vsen->kthread_sen);
 		}
+
+		/* configure the test pattern generator */
+		vimc_sen_tpg_s_format(vsen);
 	} else {
 		if (!vsen->kthread_sen)
 			return -EINVAL;
@@ -189,6 +218,7 @@ static void vimc_sen_destroy(struct vimc_ent_device *ved)
 	struct vimc_sen_device *vsen =
 				container_of(ved, struct vimc_sen_device, ved);
 
+	tpg_free(&vsen->tpg);
 	v4l2_device_unregister_subdev(&vsen->sd);
 	media_entity_cleanup(ved->ent);
 	kfree(vsen);
@@ -254,17 +284,26 @@ struct vimc_ent_device *vimc_sen_create(struct v4l2_device *v4l2_dev,
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
