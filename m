Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48419 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbbH3DHt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2015 23:07:49 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>, Shuah Khan <shuahkh@osg.samsung.com>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Olli Salonen <olli.salonen@iki.fi>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Navya Sri Nizamkari <navyasri.tech@gmail.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>,
	anuvazhayil <anuv.1994@gmail.com>,
	Mahati Chamarthy <mahati.chamarthy@gmail.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Jiayi Ye <yejiayily@gmail.com>,
	Wolfram Sang <wsa@the-dreams.de>,
	Heena Sirwani <heenasirwani@gmail.com>,
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sh@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: [PATCH v8 10/55] [media] media: rename the function that create pad links
Date: Sun, 30 Aug 2015 00:06:21 -0300
Message-Id: <06bad8b26ee0cef02d9c52d578af3a51a0f03b1f.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the new API, a link can be either between two PADs or between an interface
and an entity. So, we need to use a better name for the function that create
links between two pads.

So, rename the such function to media_create_pad_link().

No functional changes.

This patch was created via this shell script:
	for i in $(find drivers/media -name '*.[ch]' -type f) $(find drivers/staging/media -name '*.[ch]' -type f) $(find include/ -name '*.h' -type f) ; do sed s,media_entity_create_link,media_create_pad_link,g <$i >a && mv a $i; done

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/Documentation/media-framework.txt b/Documentation/media-framework.txt
index 6903b2503577..b424de6c3bb3 100644
--- a/Documentation/media-framework.txt
+++ b/Documentation/media-framework.txt
@@ -199,7 +199,7 @@ pre-allocated and grows dynamically as needed.
 
 Drivers create links by calling
 
-	media_entity_create_link(struct media_entity *source, u16 source_pad,
+	media_create_pad_link(struct media_entity *source, u16 source_pad,
 				 struct media_entity *sink,   u16 sink_pad,
 				 u32 flags);
 
diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 2fdcbb5f000a..65f59f2124b4 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -412,16 +412,16 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
 	}
 
 	if (tuner && fe)
-		media_entity_create_link(tuner, 0, fe, 0, 0);
+		media_create_pad_link(tuner, 0, fe, 0, 0);
 
 	if (fe && demux)
-		media_entity_create_link(fe, 1, demux, 0, MEDIA_LNK_FL_ENABLED);
+		media_create_pad_link(fe, 1, demux, 0, MEDIA_LNK_FL_ENABLED);
 
 	if (demux && dvr)
-		media_entity_create_link(demux, 1, dvr, 0, MEDIA_LNK_FL_ENABLED);
+		media_create_pad_link(demux, 1, dvr, 0, MEDIA_LNK_FL_ENABLED);
 
 	if (demux && ca)
-		media_entity_create_link(demux, 1, ca, 0, MEDIA_LNK_FL_ENABLED);
+		media_create_pad_link(demux, 1, ca, 0, MEDIA_LNK_FL_ENABLED);
 }
 EXPORT_SYMBOL_GPL(dvb_create_media_graph);
 #endif
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index 6d167428727d..c81bfbfea32f 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1482,11 +1482,11 @@ static int s5c73m3_oif_registered(struct v4l2_subdev *sd)
 		return ret;
 	}
 
-	ret = media_entity_create_link(&state->sensor_sd.entity,
+	ret = media_create_pad_link(&state->sensor_sd.entity,
 			S5C73M3_ISP_PAD, &state->oif_sd.entity, OIF_ISP_PAD,
 			MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
 
-	ret = media_entity_create_link(&state->sensor_sd.entity,
+	ret = media_create_pad_link(&state->sensor_sd.entity,
 			S5C73M3_JPEG_PAD, &state->oif_sd.entity, OIF_JPEG_PAD,
 			MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED);
 
diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index 30a9ca62e034..d3bff30bcb6f 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -1756,7 +1756,7 @@ static int s5k5baf_registered(struct v4l2_subdev *sd)
 		v4l2_err(sd, "failed to register subdev %s\n",
 			 state->cis_sd.name);
 	else
-		ret = media_entity_create_link(&state->cis_sd.entity, PAD_CIS,
+		ret = media_create_pad_link(&state->cis_sd.entity, PAD_CIS,
 					       &state->sd.entity, PAD_CIS,
 					       MEDIA_LNK_FL_IMMUTABLE |
 					       MEDIA_LNK_FL_ENABLED);
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 308613ea0aed..5aa49eb393a9 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2495,7 +2495,7 @@ static int smiapp_register_subdevs(struct smiapp_sensor *sensor)
 			return rval;
 		}
 
-		rval = media_entity_create_link(&this->sd.entity,
+		rval = media_create_pad_link(&this->sd.entity,
 						this->source_pad,
 						&last->sd.entity,
 						last->sink_pad,
@@ -2503,7 +2503,7 @@ static int smiapp_register_subdevs(struct smiapp_sensor *sensor)
 						MEDIA_LNK_FL_IMMUTABLE);
 		if (rval) {
 			dev_err(&client->dev,
-				"media_entity_create_link failed\n");
+				"media_create_pad_link failed\n");
 			return rval;
 		}
 
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 6d515e149d7f..35e52cd1fc5a 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -542,7 +542,7 @@ static struct media_link *media_entity_add_link(struct media_entity *entity)
 }
 
 int
-media_entity_create_link(struct media_entity *source, u16 source_pad,
+media_create_pad_link(struct media_entity *source, u16 source_pad,
 			 struct media_entity *sink, u16 sink_pad, u32 flags)
 {
 	struct media_link *link;
@@ -586,7 +586,7 @@ media_entity_create_link(struct media_entity *source, u16 source_pad,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(media_entity_create_link);
+EXPORT_SYMBOL_GPL(media_create_pad_link);
 
 void __media_entity_remove_links(struct media_entity *entity)
 {
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 4f5586a4cbff..3ba76940eef5 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -729,7 +729,7 @@ static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
 		flags = ((1 << i) & link_mask) ? MEDIA_LNK_FL_ENABLED : 0;
 
 		sink = &fmd->fimc[i]->vid_cap.subdev.entity;
-		ret = media_entity_create_link(source, pad, sink,
+		ret = media_create_pad_link(source, pad, sink,
 					      FIMC_SD_PAD_SINK_CAM, flags);
 		if (ret)
 			return ret;
@@ -749,7 +749,7 @@ static int __fimc_md_create_fimc_sink_links(struct fimc_md *fmd,
 			continue;
 
 		sink = &fmd->fimc_lite[i]->subdev.entity;
-		ret = media_entity_create_link(source, pad, sink,
+		ret = media_create_pad_link(source, pad, sink,
 					       FLITE_SD_PAD_SINK, 0);
 		if (ret)
 			return ret;
@@ -781,13 +781,13 @@ static int __fimc_md_create_flite_source_links(struct fimc_md *fmd)
 		source = &fimc->subdev.entity;
 		sink = &fimc->ve.vdev.entity;
 		/* FIMC-LITE's subdev and video node */
-		ret = media_entity_create_link(source, FLITE_SD_PAD_SOURCE_DMA,
+		ret = media_create_pad_link(source, FLITE_SD_PAD_SOURCE_DMA,
 					       sink, 0, 0);
 		if (ret)
 			break;
 		/* Link from FIMC-LITE to IS-ISP subdev */
 		sink = &fmd->fimc_is->isp.subdev.entity;
-		ret = media_entity_create_link(source, FLITE_SD_PAD_SOURCE_ISP,
+		ret = media_create_pad_link(source, FLITE_SD_PAD_SOURCE_ISP,
 					       sink, 0, 0);
 		if (ret)
 			break;
@@ -811,7 +811,7 @@ static int __fimc_md_create_fimc_is_links(struct fimc_md *fmd)
 
 		/* Link from FIMC-IS-ISP subdev to FIMC */
 		sink = &fmd->fimc[i]->vid_cap.subdev.entity;
-		ret = media_entity_create_link(source, FIMC_ISP_SD_PAD_SRC_FIFO,
+		ret = media_create_pad_link(source, FIMC_ISP_SD_PAD_SRC_FIFO,
 					       sink, FIMC_SD_PAD_SINK_FIFO, 0);
 		if (ret)
 			return ret;
@@ -824,7 +824,7 @@ static int __fimc_md_create_fimc_is_links(struct fimc_md *fmd)
 	if (sink->num_pads == 0)
 		return 0;
 
-	return media_entity_create_link(source, FIMC_ISP_SD_PAD_SRC_DMA,
+	return media_create_pad_link(source, FIMC_ISP_SD_PAD_SRC_DMA,
 					sink, 0, 0);
 }
 
@@ -873,7 +873,7 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 				return -EINVAL;
 
 			pad = sensor->entity.num_pads - 1;
-			ret = media_entity_create_link(&sensor->entity, pad,
+			ret = media_create_pad_link(&sensor->entity, pad,
 					      &csis->entity, CSIS_PAD_SINK,
 					      MEDIA_LNK_FL_IMMUTABLE |
 					      MEDIA_LNK_FL_ENABLED);
@@ -927,7 +927,7 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 		source = &fmd->fimc[i]->vid_cap.subdev.entity;
 		sink = &fmd->fimc[i]->vid_cap.ve.vdev.entity;
 
-		ret = media_entity_create_link(source, FIMC_SD_PAD_SOURCE,
+		ret = media_create_pad_link(source, FIMC_SD_PAD_SOURCE,
 					      sink, 0, flags);
 		if (ret)
 			break;
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index e08183f9d0f7..6351f35b0a65 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1865,7 +1865,7 @@ static int isp_link_entity(
 		return -EINVAL;
 	}
 
-	return media_entity_create_link(entity, i, input, pad, flags);
+	return media_create_pad_link(entity, i, input, pad, flags);
 }
 
 static int isp_register_entities(struct isp_device *isp)
@@ -2004,51 +2004,51 @@ static int isp_initialize_modules(struct isp_device *isp)
 	}
 
 	/* Connect the submodules. */
-	ret = media_entity_create_link(
+	ret = media_create_pad_link(
 			&isp->isp_csi2a.subdev.entity, CSI2_PAD_SOURCE,
 			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SINK, 0);
 	if (ret < 0)
 		goto error_link;
 
-	ret = media_entity_create_link(
+	ret = media_create_pad_link(
 			&isp->isp_ccp2.subdev.entity, CCP2_PAD_SOURCE,
 			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SINK, 0);
 	if (ret < 0)
 		goto error_link;
 
-	ret = media_entity_create_link(
+	ret = media_create_pad_link(
 			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
 			&isp->isp_prev.subdev.entity, PREV_PAD_SINK, 0);
 	if (ret < 0)
 		goto error_link;
 
-	ret = media_entity_create_link(
+	ret = media_create_pad_link(
 			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_OF,
 			&isp->isp_res.subdev.entity, RESZ_PAD_SINK, 0);
 	if (ret < 0)
 		goto error_link;
 
-	ret = media_entity_create_link(
+	ret = media_create_pad_link(
 			&isp->isp_prev.subdev.entity, PREV_PAD_SOURCE,
 			&isp->isp_res.subdev.entity, RESZ_PAD_SINK, 0);
 	if (ret < 0)
 		goto error_link;
 
-	ret = media_entity_create_link(
+	ret = media_create_pad_link(
 			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
 			&isp->isp_aewb.subdev.entity, 0,
 			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
 	if (ret < 0)
 		goto error_link;
 
-	ret = media_entity_create_link(
+	ret = media_create_pad_link(
 			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
 			&isp->isp_af.subdev.entity, 0,
 			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
 	if (ret < 0)
 		goto error_link;
 
-	ret = media_entity_create_link(
+	ret = media_create_pad_link(
 			&isp->isp_ccdc.subdev.entity, CCDC_PAD_SOURCE_VP,
 			&isp->isp_hist.subdev.entity, 0,
 			MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE);
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index d96e3be5e252..27555e4f4aa8 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -2667,7 +2667,7 @@ static int ccdc_init_entities(struct isp_ccdc_device *ccdc)
 		goto error_video;
 
 	/* Connect the CCDC subdev to the video node. */
-	ret = media_entity_create_link(&ccdc->subdev.entity, CCDC_PAD_SOURCE_OF,
+	ret = media_create_pad_link(&ccdc->subdev.entity, CCDC_PAD_SOURCE_OF,
 			&ccdc->video_out.video.entity, 0, 0);
 	if (ret < 0)
 		goto error_link;
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index e1b5f5bea541..b215eb5049d6 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -1100,7 +1100,7 @@ static int ccp2_init_entities(struct isp_ccp2_device *ccp2)
 		goto error_video;
 
 	/* Connect the video node to the ccp2 subdev. */
-	ret = media_entity_create_link(&ccp2->video_in.video.entity, 0,
+	ret = media_create_pad_link(&ccp2->video_in.video.entity, 0,
 				       &ccp2->subdev.entity, CCP2_PAD_SINK, 0);
 	if (ret < 0)
 		goto error_link;
diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index 6fff92f0813a..fcefc1e74881 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -1265,7 +1265,7 @@ static int csi2_init_entities(struct isp_csi2_device *csi2)
 		goto error_video;
 
 	/* Connect the CSI2 subdev to the video node. */
-	ret = media_entity_create_link(&csi2->subdev.entity, CSI2_PAD_SOURCE,
+	ret = media_create_pad_link(&csi2->subdev.entity, CSI2_PAD_SOURCE,
 				       &csi2->video_out.video.entity, 0, 0);
 	if (ret < 0)
 		goto error_link;
diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index b440c6342ca4..ad38d20c7770 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -2312,12 +2312,12 @@ static int preview_init_entities(struct isp_prev_device *prev)
 		goto error_video_out;
 
 	/* Connect the video nodes to the previewer subdev. */
-	ret = media_entity_create_link(&prev->video_in.video.entity, 0,
+	ret = media_create_pad_link(&prev->video_in.video.entity, 0,
 			&prev->subdev.entity, PREV_PAD_SINK, 0);
 	if (ret < 0)
 		goto error_link;
 
-	ret = media_entity_create_link(&prev->subdev.entity, PREV_PAD_SOURCE,
+	ret = media_create_pad_link(&prev->subdev.entity, PREV_PAD_SOURCE,
 			&prev->video_out.video.entity, 0, 0);
 	if (ret < 0)
 		goto error_link;
diff --git a/drivers/media/platform/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
index 3deb1ec4a973..b48ad4d4b834 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -1756,12 +1756,12 @@ static int resizer_init_entities(struct isp_res_device *res)
 	res->video_out.video.entity.flags |= MEDIA_ENT_FL_DEFAULT;
 
 	/* Connect the video nodes to the resizer subdev. */
-	ret = media_entity_create_link(&res->video_in.video.entity, 0,
+	ret = media_create_pad_link(&res->video_in.video.entity, 0,
 			&res->subdev.entity, RESZ_PAD_SINK, 0);
 	if (ret < 0)
 		goto error_link;
 
-	ret = media_entity_create_link(&res->subdev.entity, RESZ_PAD_SOURCE,
+	ret = media_create_pad_link(&res->subdev.entity, RESZ_PAD_SOURCE,
 			&res->video_out.video.entity, 0, 0);
 	if (ret < 0)
 		goto error_link;
diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
index f47b332f0418..3e33c60be004 100644
--- a/drivers/media/platform/s3c-camif/camif-core.c
+++ b/drivers/media/platform/s3c-camif/camif-core.c
@@ -263,7 +263,7 @@ static int camif_create_media_links(struct camif_dev *camif)
 {
 	int i, ret;
 
-	ret = media_entity_create_link(&camif->sensor.sd->entity, 0,
+	ret = media_create_pad_link(&camif->sensor.sd->entity, 0,
 				&camif->subdev.entity, CAMIF_SD_PAD_SINK,
 				MEDIA_LNK_FL_IMMUTABLE |
 				MEDIA_LNK_FL_ENABLED);
@@ -271,7 +271,7 @@ static int camif_create_media_links(struct camif_dev *camif)
 		return ret;
 
 	for (i = 1; i < CAMIF_SD_PADS_NUM && !ret; i++) {
-		ret = media_entity_create_link(&camif->subdev.entity, i,
+		ret = media_create_pad_link(&camif->subdev.entity, i,
 				&camif->vp[i - 1].vdev.entity, 0,
 				MEDIA_LNK_FL_IMMUTABLE |
 				MEDIA_LNK_FL_ENABLED);
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 4e61886384e3..9cd94a76a9ed 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -101,7 +101,7 @@ static int vsp1_create_links(struct vsp1_device *vsp1, struct vsp1_entity *sink)
 			if (!(entity->pads[pad].flags & MEDIA_PAD_FL_SINK))
 				continue;
 
-			ret = media_entity_create_link(&source->subdev.entity,
+			ret = media_create_pad_link(&source->subdev.entity,
 						       source->source_pad,
 						       entity, pad, flags);
 			if (ret < 0)
@@ -262,7 +262,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	}
 
 	if (vsp1->pdata.features & VSP1_HAS_LIF) {
-		ret = media_entity_create_link(
+		ret = media_create_pad_link(
 			&vsp1->wpf[0]->entity.subdev.entity, RWPF_PAD_SOURCE,
 			&vsp1->lif->entity.subdev.entity, LIF_PAD_SINK, 0);
 		if (ret < 0)
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 3294529a3108..b60a528a8fe8 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -278,7 +278,7 @@ struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index)
 	rpf->entity.video = video;
 
 	/* Connect the video device to the RPF. */
-	ret = media_entity_create_link(&rpf->video.video.entity, 0,
+	ret = media_create_pad_link(&rpf->video.video.entity, 0,
 				       &rpf->entity.subdev.entity,
 				       RWPF_PAD_SINK,
 				       MEDIA_LNK_FL_ENABLED |
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 1d2b3a2f1573..d39aa4b8aea1 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -284,7 +284,7 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 	if (!(vsp1->pdata.features & VSP1_HAS_LIF) || index != 0)
 		flags |= MEDIA_LNK_FL_IMMUTABLE;
 
-	ret = media_entity_create_link(&wpf->entity.subdev.entity,
+	ret = media_create_pad_link(&wpf->entity.subdev.entity,
 				       RWPF_PAD_SOURCE,
 				       &wpf->video.video.entity, 0, flags);
 	if (ret < 0)
diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index 7b7cb9c28d2c..79d4be7ce9a5 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -156,7 +156,7 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 			local->name, local_pad->index,
 			remote->name, remote_pad->index);
 
-		ret = media_entity_create_link(local, local_pad->index,
+		ret = media_create_pad_link(local, local_pad->index,
 					       remote, remote_pad->index,
 					       link_flags);
 		if (ret < 0) {
@@ -270,7 +270,7 @@ static int xvip_graph_build_dma(struct xvip_composite_device *xdev)
 			source->name, source_pad->index,
 			sink->name, sink_pad->index);
 
-		ret = media_entity_create_link(source, source_pad->index,
+		ret = media_create_pad_link(source, source_pad->index,
 					       sink, sink_pad->index,
 					       link_flags);
 		if (ret < 0) {
diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
index 0378a2c99ebb..a55eb524ea21 100644
--- a/drivers/media/usb/au0828/au0828-core.c
+++ b/drivers/media/usb/au0828/au0828-core.c
@@ -260,13 +260,13 @@ static void au0828_create_media_graph(struct au0828_dev *dev)
 		return;
 
 	if (tuner)
-		media_entity_create_link(tuner, 0, decoder, 0,
+		media_create_pad_link(tuner, 0, decoder, 0,
 					 MEDIA_LNK_FL_ENABLED);
 	if (dev->vdev.entity.links)
-		media_entity_create_link(decoder, 1, &dev->vdev.entity, 0,
+		media_create_pad_link(decoder, 1, &dev->vdev.entity, 0,
 				 MEDIA_LNK_FL_ENABLED);
 	if (dev->vbi_dev.entity.links)
-		media_entity_create_link(decoder, 2, &dev->vbi_dev.entity, 0,
+		media_create_pad_link(decoder, 2, &dev->vbi_dev.entity, 0,
 				 MEDIA_LNK_FL_ENABLED);
 #endif
 }
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 4a117a58c39a..3b5c9ae39ad3 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1264,11 +1264,11 @@ static void cx231xx_create_media_graph(struct cx231xx *dev)
 		return;
 
 	if (tuner)
-		media_entity_create_link(tuner, 0, decoder, 0,
+		media_create_pad_link(tuner, 0, decoder, 0,
 					 MEDIA_LNK_FL_ENABLED);
-	media_entity_create_link(decoder, 1, &dev->vdev.entity, 0,
+	media_create_pad_link(decoder, 1, &dev->vdev.entity, 0,
 				 MEDIA_LNK_FL_ENABLED);
-	media_entity_create_link(decoder, 2, &dev->vbi_dev.entity, 0,
+	media_create_pad_link(decoder, 2, &dev->vbi_dev.entity, 0,
 				 MEDIA_LNK_FL_ENABLED);
 #endif
 }
diff --git a/drivers/media/usb/uvc/uvc_entity.c b/drivers/media/usb/uvc/uvc_entity.c
index 245445491516..429e428ccd93 100644
--- a/drivers/media/usb/uvc/uvc_entity.c
+++ b/drivers/media/usb/uvc/uvc_entity.c
@@ -56,7 +56,7 @@ static int uvc_mc_register_entity(struct uvc_video_chain *chain,
 			continue;
 
 		remote_pad = remote->num_pads - 1;
-		ret = media_entity_create_link(source, remote_pad,
+		ret = media_create_pad_link(source, remote_pad,
 					       sink, i, flags);
 		if (ret < 0)
 			return ret;
diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
index 8fb676186898..d96bdaaae50e 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
@@ -971,7 +971,7 @@ vpfe_ipipeif_register_entities(struct vpfe_ipipeif_device *ipipeif,
 	ipipeif->video_in.vpfe_dev = vpfe_dev;
 
 	flags = 0;
-	ret = media_entity_create_link(&ipipeif->video_in.video_dev.entity, 0,
+	ret = media_create_pad_link(&ipipeif->video_in.video_dev.entity, 0,
 					&ipipeif->subdev.entity, 0, flags);
 	if (ret < 0)
 		goto fail;
diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
index b1f01adfa7c8..df77288b0ec0 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
@@ -1817,7 +1817,7 @@ int vpfe_isif_register_entities(struct vpfe_isif_device *isif,
 	isif->video_out.vpfe_dev = vpfe_dev;
 	flags = 0;
 	/* connect isif to video node */
-	ret = media_entity_create_link(&isif->subdev.entity, 1,
+	ret = media_create_pad_link(&isif->subdev.entity, 1,
 				       &isif->video_out.video_dev.entity,
 				       0, flags);
 	if (ret < 0)
diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 692789aa22f4..ae942de3a23d 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -1831,27 +1831,27 @@ int vpfe_resizer_register_entities(struct vpfe_resizer_device *resizer,
 	resizer->resizer_b.video_out.vpfe_dev = vpfe_dev;
 
 	/* create link between Resizer Crop----> Resizer A*/
-	ret = media_entity_create_link(&resizer->crop_resizer.subdev.entity, 1,
+	ret = media_create_pad_link(&resizer->crop_resizer.subdev.entity, 1,
 				&resizer->resizer_a.subdev.entity,
 				0, flags);
 	if (ret < 0)
 		goto out_create_link;
 
 	/* create link between Resizer Crop----> Resizer B*/
-	ret = media_entity_create_link(&resizer->crop_resizer.subdev.entity, 2,
+	ret = media_create_pad_link(&resizer->crop_resizer.subdev.entity, 2,
 				&resizer->resizer_b.subdev.entity,
 				0, flags);
 	if (ret < 0)
 		goto out_create_link;
 
 	/* create link between Resizer A ----> video out */
-	ret = media_entity_create_link(&resizer->resizer_a.subdev.entity, 1,
+	ret = media_create_pad_link(&resizer->resizer_a.subdev.entity, 1,
 		&resizer->resizer_a.video_out.video_dev.entity, 0, flags);
 	if (ret < 0)
 		goto out_create_link;
 
 	/* create link between Resizer B ----> video out */
-	ret = media_entity_create_link(&resizer->resizer_b.subdev.entity, 1,
+	ret = media_create_pad_link(&resizer->resizer_b.subdev.entity, 1,
 		&resizer->resizer_b.video_out.video_dev.entity, 0, flags);
 	if (ret < 0)
 		goto out_create_link;
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
index 57426199ad7a..08c8a5f967d3 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
@@ -445,32 +445,32 @@ static int vpfe_register_entities(struct vpfe_device *vpfe_dev)
 		/* if entity has no pads (ex: amplifier),
 		   cant establish link */
 		if (vpfe_dev->sd[i]->entity.num_pads) {
-			ret = media_entity_create_link(&vpfe_dev->sd[i]->entity,
+			ret = media_create_pad_link(&vpfe_dev->sd[i]->entity,
 				0, &vpfe_dev->vpfe_isif.subdev.entity,
 				0, flags);
 			if (ret < 0)
 				goto out_resizer_register;
 		}
 
-	ret = media_entity_create_link(&vpfe_dev->vpfe_isif.subdev.entity, 1,
+	ret = media_create_pad_link(&vpfe_dev->vpfe_isif.subdev.entity, 1,
 				       &vpfe_dev->vpfe_ipipeif.subdev.entity,
 				       0, flags);
 	if (ret < 0)
 		goto out_resizer_register;
 
-	ret = media_entity_create_link(&vpfe_dev->vpfe_ipipeif.subdev.entity, 1,
+	ret = media_create_pad_link(&vpfe_dev->vpfe_ipipeif.subdev.entity, 1,
 				       &vpfe_dev->vpfe_ipipe.subdev.entity,
 				       0, flags);
 	if (ret < 0)
 		goto out_resizer_register;
 
-	ret = media_entity_create_link(&vpfe_dev->vpfe_ipipe.subdev.entity,
+	ret = media_create_pad_link(&vpfe_dev->vpfe_ipipe.subdev.entity,
 			1, &vpfe_dev->vpfe_resizer.crop_resizer.subdev.entity,
 			0, flags);
 	if (ret < 0)
 		goto out_resizer_register;
 
-	ret = media_entity_create_link(&vpfe_dev->vpfe_ipipeif.subdev.entity, 1,
+	ret = media_create_pad_link(&vpfe_dev->vpfe_ipipeif.subdev.entity, 1,
 			&vpfe_dev->vpfe_resizer.crop_resizer.subdev.entity,
 			0, flags);
 	if (ret < 0)
diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index e54a7afd31de..7226553ceb2f 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -1259,7 +1259,7 @@ static int iss_register_entities(struct iss_device *iss)
 			goto done;
 		}
 
-		ret = media_entity_create_link(&sensor->entity, 0, input, pad,
+		ret = media_create_pad_link(&sensor->entity, 0, input, pad,
 					       flags);
 		if (ret < 0)
 			goto done;
@@ -1317,31 +1317,31 @@ static int iss_initialize_modules(struct iss_device *iss)
 	}
 
 	/* Connect the submodules. */
-	ret = media_entity_create_link(
+	ret = media_create_pad_link(
 			&iss->csi2a.subdev.entity, CSI2_PAD_SOURCE,
 			&iss->ipipeif.subdev.entity, IPIPEIF_PAD_SINK, 0);
 	if (ret < 0)
 		goto error_link;
 
-	ret = media_entity_create_link(
+	ret = media_create_pad_link(
 			&iss->csi2b.subdev.entity, CSI2_PAD_SOURCE,
 			&iss->ipipeif.subdev.entity, IPIPEIF_PAD_SINK, 0);
 	if (ret < 0)
 		goto error_link;
 
-	ret = media_entity_create_link(
+	ret = media_create_pad_link(
 			&iss->ipipeif.subdev.entity, IPIPEIF_PAD_SOURCE_VP,
 			&iss->resizer.subdev.entity, RESIZER_PAD_SINK, 0);
 	if (ret < 0)
 		goto error_link;
 
-	ret = media_entity_create_link(
+	ret = media_create_pad_link(
 			&iss->ipipeif.subdev.entity, IPIPEIF_PAD_SOURCE_VP,
 			&iss->ipipe.subdev.entity, IPIPE_PAD_SINK, 0);
 	if (ret < 0)
 		goto error_link;
 
-	ret = media_entity_create_link(
+	ret = media_create_pad_link(
 			&iss->ipipe.subdev.entity, IPIPE_PAD_SOURCE_VP,
 			&iss->resizer.subdev.entity, RESIZER_PAD_SINK, 0);
 	if (ret < 0)
diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index e936cfc218cb..6b4dcbfa9425 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -1291,7 +1291,7 @@ static int csi2_init_entities(struct iss_csi2_device *csi2, const char *subname)
 		goto error_video;
 
 	/* Connect the CSI2 subdev to the video node. */
-	ret = media_entity_create_link(&csi2->subdev.entity, CSI2_PAD_SOURCE,
+	ret = media_create_pad_link(&csi2->subdev.entity, CSI2_PAD_SOURCE,
 				       &csi2->video_out.video.entity, 0, 0);
 	if (ret < 0)
 		goto error_link;
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index be5f80d7b5dc..44c432ef2ac5 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -762,7 +762,7 @@ static int ipipeif_init_entities(struct iss_ipipeif_device *ipipeif)
 		return ret;
 
 	/* Connect the IPIPEIF subdev to the video node. */
-	ret = media_entity_create_link(&ipipeif->subdev.entity,
+	ret = media_create_pad_link(&ipipeif->subdev.entity,
 				       IPIPEIF_PAD_SOURCE_ISIF_SF,
 				       &ipipeif->video_out.video.entity, 0, 0);
 	if (ret < 0)
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index 91e724085dba..b659e465cb56 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -806,7 +806,7 @@ static int resizer_init_entities(struct iss_resizer_device *resizer)
 		return ret;
 
 	/* Connect the RESIZER subdev to the video node. */
-	ret = media_entity_create_link(&resizer->subdev.entity,
+	ret = media_create_pad_link(&resizer->subdev.entity,
 				       RESIZER_PAD_SOURCE_MEM,
 				       &resizer->video_out.video.entity, 0, 0);
 	if (ret < 0)
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index af6646ddf6db..e0e4b014ce62 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -208,7 +208,7 @@ int media_entity_init(struct media_entity *entity, u16 num_pads,
 		struct media_pad *pads);
 void media_entity_cleanup(struct media_entity *entity);
 
-int media_entity_create_link(struct media_entity *source, u16 source_pad,
+int media_create_pad_link(struct media_entity *source, u16 source_pad,
 		struct media_entity *sink, u16 sink_pad, u32 flags);
 void __media_entity_remove_links(struct media_entity *entity);
 void media_entity_remove_links(struct media_entity *entity);
-- 
2.4.3

