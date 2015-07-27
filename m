Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:36913 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbbG0Mfe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2015 08:35:34 -0400
Date: Mon, 27 Jul 2015 13:35:28 +0100 (BST)
From: William Towle <william.towle@codethink.co.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 07/13] media: soc_camera pad-aware driver
 initialisation
In-Reply-To: <55B24941.1040803@xs4all.nl>
Message-ID: <alpine.DEB.2.02.1507271333570.4745@xk120.dyn.ducie.codethink.co.uk>
References: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk> <1437654103-26409-8-git-send-email-william.towle@codethink.co.uk> <55B24941.1040803@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 24 Jul 2015, Hans Verkuil wrote:
> Why would you want to init vdev->entity? soc-camera doesn't create a media controller
> device, so there is no point in doing this.

   Thanks, I hadn't quite understood that about the code I was
transplanting to/from. Please find an update below.

Cheers,
   Wills.


...
Subject: [PATCH] media: soc_camera pad-aware driver initialisation

Add detection of source pad number for drivers aware of the media
controller API, so that the combination of soc_camera and rcar_vin
can create device nodes to support modern drivers such as adv7604.c
(for HDMI on Lager) and the converted adv7180.c (for composite)
underneath.

Building rcar_vin gains a dependency on CONFIG_MEDIA_CONTROLLER, in
line with requirements for building the drivers associated with it.

Signed-off-by: William Towle <william.towle@codethink.co.uk>
Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
---
  drivers/media/platform/soc_camera/Kconfig      |    1 +
  drivers/media/platform/soc_camera/rcar_vin.c   |    1 +
  drivers/media/platform/soc_camera/soc_camera.c |   20 +++++++++++++++++++-
  include/media/soc_camera.h                     |    1 +
  4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index f2776cd..5c45c83 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -38,6 +38,7 @@ config VIDEO_RCAR_VIN
  	depends on VIDEO_DEV && SOC_CAMERA
  	depends on ARCH_SHMOBILE || COMPILE_TEST
  	depends on HAS_DMA
+	depends on MEDIA_CONTROLLER
  	select VIDEOBUF2_DMA_CONTIG
  	select SOC_CAMERA_SCALE_CROP
  	---help---
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 16352a8..00c1034 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1359,6 +1359,7 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
  		struct device *dev = icd->parent;
  		int shift;

+		fmt.pad = icd->src_pad_idx;
  		ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
  		if (ret < 0)
  			return ret;
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index d708df4..82d3ebe 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1293,6 +1293,10 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
  		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
  	};
  	struct v4l2_mbus_framefmt *mf = &fmt.format;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	struct media_pad pad;
+	int pad_idx;
+#endif
  	int ret;

  	sd->grp_id = soc_camera_grp_id(icd);
@@ -1311,9 +1315,23 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
  	}

  	/* At this point client .probe() should have run already */
+	icd->src_pad_idx = 0;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
+		if (sd->entity.pads[pad_idx].flags
+				== MEDIA_PAD_FL_SOURCE)
+			break;
+	if (pad_idx >= sd->entity.num_pads)
+		goto eusrfmt;
+
+	icd->src_pad_idx = pad_idx;
+#endif
+
  	ret = soc_camera_init_user_formats(icd);
-	if (ret < 0)
+	if (ret < 0) {
+		icd->src_pad_idx = -1;
  		goto eusrfmt;
+	}

  	icd->field = V4L2_FIELD_ANY;

diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 2f6261f..30193cf 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -42,6 +42,7 @@ struct soc_camera_device {
  	unsigned char devnum;		/* Device number per host */
  	struct soc_camera_sense *sense;	/* See comment in struct definition */
  	struct video_device *vdev;
+	int src_pad_idx;		/* For media-controller drivers */
  	struct v4l2_ctrl_handler ctrl_handler;
  	const struct soc_camera_format_xlate *current_fmt;
  	struct soc_camera_format_xlate *user_formats;
-- 
1.7.10.4

