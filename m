Return-Path: <SRS0=dU+R=OY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60982C43387
	for <linux-media@archiver.kernel.org>; Sat, 15 Dec 2018 16:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F42B2080F
	for <linux-media@archiver.kernel.org>; Sat, 15 Dec 2018 16:47:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rjbKI4E0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729716AbeLOQrc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 15 Dec 2018 11:47:32 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42104 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727168AbeLOQrb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Dec 2018 11:47:31 -0500
Received: by mail-qt1-f195.google.com with SMTP id d19so9695784qtq.9;
        Sat, 15 Dec 2018 08:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B+pB4KzJkh+D0o0kHCrkWcDR5NxhFqqZZ67lnLw2J8Q=;
        b=rjbKI4E0/kNM7ZzIvTT4dnebLfEX6obgE3G7OG1qPfh2H2U7ffrqzD3K73JTxC+O6u
         iVdXPL5cjXGfs5VtFRL+OnFaNgal1QWMyQFKChYgEUP/W2SIwIR8pJ/Gc+ej+iHCeB2l
         PCcUUm2SxQVQgBeOs6bLE91dtTrLcM1dI4ikhjG0HGqn6B2APD7sa8pEO0e3AweBXYhR
         IkSr13BFxWgalYyVgO4YtSH9u/UmEtJtG6O7h7r+aWt85F1AAfNn5NvNQ3bDVv1vbVuj
         L4+F2OWjHY7RdzgLtNSe784b0mFFlLCsPmHydqX8ZpA5DkG69M0LbH0SPjPcOUQ80H2b
         20IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B+pB4KzJkh+D0o0kHCrkWcDR5NxhFqqZZ67lnLw2J8Q=;
        b=FpLnf3hukyU5aj79VKwJg+xbSEbaxd6AhEJcAqhloxUwaf6ZSoCFpokFkgSfaqKQP/
         Y1kLz73LiyjCmNNo9CZg2Jgv2Oi+U+ICm61GtITeL4KrqJ51INyCBz2rKTq8myS++yvS
         KnqahvGKZ3SPhugg3qfKZBnSSMgl2+PNTzi92/A6BKg4KE5ppBqrTtZXAerlvUq9V9JZ
         2soa8X/6oxMKA0ZWUXH6f6tT9N1qRE3Uh+1eDPClJs04r2jfW+/aUre/zPzlkazPegv9
         dvvRLg6XWIBAhnOld8ZNuRR6/XjbO6LQlBIXx7Px85L2nQ/3zQWHbZpsc/nUc4BNR0HI
         JsFg==
X-Gm-Message-State: AA+aEWaOTaf87Ix/25CeflswZAAW02w4Hi8ltBvrHmmSKYxBEHT/x8+3
        A5F9xnKP1iGL8RBuqIJd57GJd3Eo
X-Google-Smtp-Source: AFSGD/XnIh6GBEUbAWXK2a5IQ6Cx/Ux/hog9mPDfehM72QLJZpWsnrl+5E0xmyBPnMzPrcT3r6psYg==
X-Received: by 2002:ac8:71d0:: with SMTP id i16mr7608303qtp.386.1544892449464;
        Sat, 15 Dec 2018 08:47:29 -0800 (PST)
Received: from localhost.localdomain ([177.194.44.253])
        by smtp.gmail.com with ESMTPSA id a68sm5147995qkj.63.2018.12.15.08.47.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Dec 2018 08:47:28 -0800 (PST)
From:   =?UTF-8?q?Lucas=20A=2E=20M=2E=20Magalh=C3=A3es?= 
        <lucmaga@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com, hverkuil@xs4all.nl, mchehab@kernel.org,
        lkcamp@lists.libreplanetbr.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Lucas=20A=2E=20M=2E=20Magalh=C3=A3es?= 
        <lucmaga@gmail.com>
Subject: [Lkcamp][PATCH] media: vimc: Add vimc-streamer for stream control
Date:   Sat, 15 Dec 2018 14:46:31 -0200
Message-Id: <20181215164631.8623-1-lucmaga@gmail.com>
X-Mailer: git-send-email 2.20.0.rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The previous code pipeline used the stack to walk on the graph and
process a frame. Basically the vimc-sensor entity starts a thread that
generates the frames and calls the propagate_process function to send
this frame to each entity linked with a sink pad. The propagate_process
will call the process_frame of the entities which will call the
propagate_frame for each one of it's sink pad. This cycle will continue
until it reaches a vimc-capture entity that will finally return and
unstack.

This solution had many problems:
  * It was a little bit slow
  * It was susceptible to a stack overflow as it made indiscriminate
    use of the stack.
  * It doesn't allow frame rate control
  * It was complex to understand
  * It doesn't allow pipeline control

This commit proposes an alternative way to control vimc streams by
having a streamer object. This object will create a linear pipeline
walking backwards on the graph. When the stream starts it will simply
loop through the pipeline calling the respective process_frame function
for each entity on the pipeline.

This solution has some premises which are true for now:
  * Two paths can never be enabled and streaming at the same time.
  * There is no entity streaming frames to two source pads at the same
    time.
  * There is no entity receiving frames from two sink pads at the same
    time.

Signed-off-by: Lucas A. M. Magalhães <lucmaga@gmail.com>
---
Hi,

This patch introduces a streamer controller library for the vimc
driver. It's a step towards a optimized mode I've been discussing with
Helen.
I plan to pass a tpg struct through the pipeline. This tpg struct
will be configured in each entity and the capture will generate the
frames with the correct format at the end of the pipeline.

Thanks,
Lucas

 drivers/media/platform/vimc/Makefile        |   3 +-
 drivers/media/platform/vimc/vimc-capture.c  |  18 +-
 drivers/media/platform/vimc/vimc-common.c   |  50 ++----
 drivers/media/platform/vimc/vimc-common.h   |  15 +-
 drivers/media/platform/vimc/vimc-debayer.c  |  26 +--
 drivers/media/platform/vimc/vimc-scaler.c   |  28 +---
 drivers/media/platform/vimc/vimc-sensor.c   |  56 ++-----
 drivers/media/platform/vimc/vimc-streamer.c | 176 ++++++++++++++++++++
 drivers/media/platform/vimc/vimc-streamer.h |  38 +++++
 9 files changed, 268 insertions(+), 142 deletions(-)
 create mode 100644 drivers/media/platform/vimc/vimc-streamer.c
 create mode 100644 drivers/media/platform/vimc/vimc-streamer.h

diff --git a/drivers/media/platform/vimc/Makefile b/drivers/media/platform/vimc/Makefile
index 4b2e3de7856e..c4fc8e7d365a 100644
--- a/drivers/media/platform/vimc/Makefile
+++ b/drivers/media/platform/vimc/Makefile
@@ -5,6 +5,7 @@ vimc_common-objs := vimc-common.o
 vimc_debayer-objs := vimc-debayer.o
 vimc_scaler-objs := vimc-scaler.o
 vimc_sensor-objs := vimc-sensor.o
+vimc_streamer-objs := vimc-streamer.o
 
 obj-$(CONFIG_VIDEO_VIMC) += vimc.o vimc_capture.o vimc_common.o vimc-debayer.o \
-				vimc_scaler.o vimc_sensor.o
+			    vimc_scaler.o vimc_sensor.o vimc_streamer.o
diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index 3f7e9ed56633..80d7515ec420 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -24,6 +24,7 @@
 #include <media/videobuf2-vmalloc.h>
 
 #include "vimc-common.h"
+#include "vimc-streamer.h"
 
 #define VIMC_CAP_DRV_NAME "vimc-capture"
 
@@ -44,7 +45,7 @@ struct vimc_cap_device {
 	spinlock_t qlock;
 	struct mutex lock;
 	u32 sequence;
-	struct media_pipeline pipe;
+	struct vimc_stream stream;
 };
 
 static const struct v4l2_pix_format fmt_default = {
@@ -248,14 +249,13 @@ static int vimc_cap_start_streaming(struct vb2_queue *vq, unsigned int count)
 	vcap->sequence = 0;
 
 	/* Start the media pipeline */
-	ret = media_pipeline_start(entity, &vcap->pipe);
+	ret = media_pipeline_start(entity, &vcap->stream.pipe);
 	if (ret) {
 		vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_QUEUED);
 		return ret;
 	}
 
-	/* Enable streaming from the pipe */
-	ret = vimc_pipeline_s_stream(&vcap->vdev.entity, 1);
+	ret = vimc_streamer_s_stream(&vcap->stream, &vcap->ved, 1);
 	if (ret) {
 		media_pipeline_stop(entity);
 		vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_QUEUED);
@@ -273,8 +273,7 @@ static void vimc_cap_stop_streaming(struct vb2_queue *vq)
 {
 	struct vimc_cap_device *vcap = vb2_get_drv_priv(vq);
 
-	/* Disable streaming from the pipe */
-	vimc_pipeline_s_stream(&vcap->vdev.entity, 0);
+	vimc_streamer_s_stream(&vcap->stream, &vcap->ved, 0);
 
 	/* Stop the media pipeline */
 	media_pipeline_stop(&vcap->vdev.entity);
@@ -355,8 +354,8 @@ static void vimc_cap_comp_unbind(struct device *comp, struct device *master,
 	kfree(vcap);
 }
 
-static void vimc_cap_process_frame(struct vimc_ent_device *ved,
-				   struct media_pad *sink, const void *frame)
+static void *vimc_cap_process_frame(struct vimc_ent_device *ved,
+				    const void *frame)
 {
 	struct vimc_cap_device *vcap = container_of(ved, struct vimc_cap_device,
 						    ved);
@@ -370,7 +369,7 @@ static void vimc_cap_process_frame(struct vimc_ent_device *ved,
 					    typeof(*vimc_buf), list);
 	if (!vimc_buf) {
 		spin_unlock(&vcap->qlock);
-		return;
+		return ERR_PTR(-EAGAIN);
 	}
 
 	/* Remove this entry from the list */
@@ -391,6 +390,7 @@ static void vimc_cap_process_frame(struct vimc_ent_device *ved,
 	vb2_set_plane_payload(&vimc_buf->vb2.vb2_buf, 0,
 			      vcap->format.sizeimage);
 	vb2_buffer_done(&vimc_buf->vb2.vb2_buf, VB2_BUF_STATE_DONE);
+	return NULL;
 }
 
 static int vimc_cap_comp_bind(struct device *comp, struct device *master,
diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/platform/vimc/vimc-common.c
index dee1b9dfc4f6..8eb27ac589e2 100644
--- a/drivers/media/platform/vimc/vimc-common.c
+++ b/drivers/media/platform/vimc/vimc-common.c
@@ -207,41 +207,6 @@ const struct vimc_pix_map *vimc_pix_map_by_pixelformat(u32 pixelformat)
 }
 EXPORT_SYMBOL_GPL(vimc_pix_map_by_pixelformat);
 
-int vimc_propagate_frame(struct media_pad *src, const void *frame)
-{
-	struct media_link *link;
-
-	if (!(src->flags & MEDIA_PAD_FL_SOURCE))
-		return -EINVAL;
-
-	/* Send this frame to all sink pads that are direct linked */
-	list_for_each_entry(link, &src->entity->links, list) {
-		if (link->source == src &&
-		    (link->flags & MEDIA_LNK_FL_ENABLED)) {
-			struct vimc_ent_device *ved = NULL;
-			struct media_entity *entity = link->sink->entity;
-
-			if (is_media_entity_v4l2_subdev(entity)) {
-				struct v4l2_subdev *sd =
-					container_of(entity, struct v4l2_subdev,
-						     entity);
-				ved = v4l2_get_subdevdata(sd);
-			} else if (is_media_entity_v4l2_video_device(entity)) {
-				struct video_device *vdev =
-					container_of(entity,
-						     struct video_device,
-						     entity);
-				ved = video_get_drvdata(vdev);
-			}
-			if (ved && ved->process_frame)
-				ved->process_frame(ved, link->sink, frame);
-		}
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(vimc_propagate_frame);
-
 /* Helper function to allocate and initialize pads */
 struct media_pad *vimc_pads_init(u16 num_pads, const unsigned long *pads_flag)
 {
@@ -263,6 +228,21 @@ struct media_pad *vimc_pads_init(u16 num_pads, const unsigned long *pads_flag)
 }
 EXPORT_SYMBOL_GPL(vimc_pads_init);
 
+struct media_entity *vimc_get_source_entity(struct media_entity *ent)
+{
+	struct media_pad *pad;
+	int i;
+
+	for (i = 0; i < ent->num_pads; i++) {
+		if (ent->pads[i].flags & MEDIA_PAD_FL_SOURCE)
+			continue;
+		pad = media_entity_remote_pad(&ent->pads[i]);
+		return pad ? pad->entity : NULL;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(vimc_get_source_entity);
+
 int vimc_pipeline_s_stream(struct media_entity *ent, int enable)
 {
 	struct v4l2_subdev *sd;
diff --git a/drivers/media/platform/vimc/vimc-common.h b/drivers/media/platform/vimc/vimc-common.h
index 2e9981b18166..1cbafd31ecb0 100644
--- a/drivers/media/platform/vimc/vimc-common.h
+++ b/drivers/media/platform/vimc/vimc-common.h
@@ -113,22 +113,21 @@ struct vimc_pix_map {
 struct vimc_ent_device {
 	struct media_entity *ent;
 	struct media_pad *pads;
-	void (*process_frame)(struct vimc_ent_device *ved,
-			      struct media_pad *sink, const void *frame);
+	void * (*process_frame)(struct vimc_ent_device *ved,
+				const void *frame);
 	void (*vdev_get_format)(struct vimc_ent_device *ved,
 			      struct v4l2_pix_format *fmt);
 };
 
 /**
- * vimc_propagate_frame - propagate a frame through the topology
+ * vimc_get_source_entity - get the media_entity source of a given media_entity
  *
- * @src:	the source pad where the frame is being originated
- * @frame:	the frame to be propagated
+ * @ent:	reference media_entity
  *
- * This function will call the process_frame callback from the vimc_ent_device
- * struct of the nodes directly connected to the @src pad
+ * Helper function that return the media entity which is source from the given
+ * media entity.
  */
-int vimc_propagate_frame(struct media_pad *src, const void *frame);
+struct media_entity *vimc_get_source_entity(struct media_entity *ent);
 
 /**
  * vimc_pads_init - initialize pads
diff --git a/drivers/media/platform/vimc/vimc-debayer.c b/drivers/media/platform/vimc/vimc-debayer.c
index 77887f66f323..7d77c63b99d2 100644
--- a/drivers/media/platform/vimc/vimc-debayer.c
+++ b/drivers/media/platform/vimc/vimc-debayer.c
@@ -321,7 +321,6 @@ static void vimc_deb_set_rgb_mbus_fmt_rgb888_1x24(struct vimc_deb_device *vdeb,
 static int vimc_deb_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct vimc_deb_device *vdeb = v4l2_get_subdevdata(sd);
-	int ret;
 
 	if (enable) {
 		const struct vimc_pix_map *vpix;
@@ -351,22 +350,10 @@ static int vimc_deb_s_stream(struct v4l2_subdev *sd, int enable)
 		if (!vdeb->src_frame)
 			return -ENOMEM;
 
-		/* Turn the stream on in the subdevices directly connected */
-		ret = vimc_pipeline_s_stream(&vdeb->sd.entity, 1);
-		if (ret) {
-			vfree(vdeb->src_frame);
-			vdeb->src_frame = NULL;
-			return ret;
-		}
 	} else {
 		if (!vdeb->src_frame)
 			return 0;
 
-		/* Disable streaming from the pipe */
-		ret = vimc_pipeline_s_stream(&vdeb->sd.entity, 0);
-		if (ret)
-			return ret;
-
 		vfree(vdeb->src_frame);
 		vdeb->src_frame = NULL;
 	}
@@ -480,9 +467,8 @@ static void vimc_deb_calc_rgb_sink(struct vimc_deb_device *vdeb,
 	}
 }
 
-static void vimc_deb_process_frame(struct vimc_ent_device *ved,
-				   struct media_pad *sink,
-				   const void *sink_frame)
+static void *vimc_deb_process_frame(struct vimc_ent_device *ved,
+				    const void *sink_frame)
 {
 	struct vimc_deb_device *vdeb = container_of(ved, struct vimc_deb_device,
 						    ved);
@@ -491,7 +477,7 @@ static void vimc_deb_process_frame(struct vimc_ent_device *ved,
 
 	/* If the stream in this node is not active, just return */
 	if (!vdeb->src_frame)
-		return;
+		return ERR_PTR(-EINVAL);
 
 	for (i = 0; i < vdeb->sink_fmt.height; i++)
 		for (j = 0; j < vdeb->sink_fmt.width; j++) {
@@ -499,12 +485,8 @@ static void vimc_deb_process_frame(struct vimc_ent_device *ved,
 			vdeb->set_rgb_src(vdeb, i, j, rgb);
 		}
 
-	/* Propagate the frame through all source pads */
-	for (i = 1; i < vdeb->sd.entity.num_pads; i++) {
-		struct media_pad *pad = &vdeb->sd.entity.pads[i];
+	return vdeb->src_frame;
 
-		vimc_propagate_frame(pad, vdeb->src_frame);
-	}
 }
 
 static void vimc_deb_comp_unbind(struct device *comp, struct device *master,
diff --git a/drivers/media/platform/vimc/vimc-scaler.c b/drivers/media/platform/vimc/vimc-scaler.c
index b0952ee86296..39b2a73dfcc1 100644
--- a/drivers/media/platform/vimc/vimc-scaler.c
+++ b/drivers/media/platform/vimc/vimc-scaler.c
@@ -217,7 +217,6 @@ static const struct v4l2_subdev_pad_ops vimc_sca_pad_ops = {
 static int vimc_sca_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct vimc_sca_device *vsca = v4l2_get_subdevdata(sd);
-	int ret;
 
 	if (enable) {
 		const struct vimc_pix_map *vpix;
@@ -245,22 +244,10 @@ static int vimc_sca_s_stream(struct v4l2_subdev *sd, int enable)
 		if (!vsca->src_frame)
 			return -ENOMEM;
 
-		/* Turn the stream on in the subdevices directly connected */
-		ret = vimc_pipeline_s_stream(&vsca->sd.entity, 1);
-		if (ret) {
-			vfree(vsca->src_frame);
-			vsca->src_frame = NULL;
-			return ret;
-		}
 	} else {
 		if (!vsca->src_frame)
 			return 0;
 
-		/* Disable streaming from the pipe */
-		ret = vimc_pipeline_s_stream(&vsca->sd.entity, 0);
-		if (ret)
-			return ret;
-
 		vfree(vsca->src_frame);
 		vsca->src_frame = NULL;
 	}
@@ -346,26 +333,19 @@ static void vimc_sca_fill_src_frame(const struct vimc_sca_device *const vsca,
 			vimc_sca_scale_pix(vsca, i, j, sink_frame);
 }
 
-static void vimc_sca_process_frame(struct vimc_ent_device *ved,
-				   struct media_pad *sink,
-				   const void *sink_frame)
+static void *vimc_sca_process_frame(struct vimc_ent_device *ved,
+				    const void *sink_frame)
 {
 	struct vimc_sca_device *vsca = container_of(ved, struct vimc_sca_device,
 						    ved);
-	unsigned int i;
 
 	/* If the stream in this node is not active, just return */
 	if (!vsca->src_frame)
-		return;
+		return ERR_PTR(-EINVAL);
 
 	vimc_sca_fill_src_frame(vsca, sink_frame);
 
-	/* Propagate the frame through all source pads */
-	for (i = 1; i < vsca->sd.entity.num_pads; i++) {
-		struct media_pad *pad = &vsca->sd.entity.pads[i];
-
-		vimc_propagate_frame(pad, vsca->src_frame);
-	}
+	return vsca->src_frame;
 };
 
 static void vimc_sca_comp_unbind(struct device *comp, struct device *master,
diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
index 32ca9c6172b1..93961a1e694f 100644
--- a/drivers/media/platform/vimc/vimc-sensor.c
+++ b/drivers/media/platform/vimc/vimc-sensor.c
@@ -16,8 +16,6 @@
  */
 
 #include <linux/component.h>
-#include <linux/freezer.h>
-#include <linux/kthread.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
@@ -201,38 +199,27 @@ static const struct v4l2_subdev_pad_ops vimc_sen_pad_ops = {
 	.set_fmt		= vimc_sen_set_fmt,
 };
 
-static int vimc_sen_tpg_thread(void *data)
+static void *vimc_sen_process_frame(struct vimc_ent_device *ved,
+				    const void *sink_frame)
 {
-	struct vimc_sen_device *vsen = data;
-	unsigned int i;
-
-	set_freezable();
-	set_current_state(TASK_UNINTERRUPTIBLE);
-
-	for (;;) {
-		try_to_freeze();
-		if (kthread_should_stop())
-			break;
-
-		tpg_fill_plane_buffer(&vsen->tpg, 0, 0, vsen->frame);
+	struct vimc_sen_device *vsen = container_of(ved, struct vimc_sen_device,
+						    ved);
+	const struct vimc_pix_map *vpix;
+	unsigned int frame_size;
 
-		/* Send the frame to all source pads */
-		for (i = 0; i < vsen->sd.entity.num_pads; i++)
-			vimc_propagate_frame(&vsen->sd.entity.pads[i],
-					     vsen->frame);
+	/* Calculate the frame size */
+	vpix = vimc_pix_map_by_code(vsen->mbus_format.code);
+	frame_size = vsen->mbus_format.width * vpix->bpp *
+		     vsen->mbus_format.height;
 
-		/* 60 frames per second */
-		schedule_timeout(HZ/60);
-	}
-
-	return 0;
+	tpg_fill_plane_buffer(&vsen->tpg, 0, 0, vsen->frame);
+	return vsen->frame;
 }
 
 static int vimc_sen_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct vimc_sen_device *vsen =
 				container_of(sd, struct vimc_sen_device, sd);
-	int ret;
 
 	if (enable) {
 		const struct vimc_pix_map *vpix;
@@ -258,26 +245,8 @@ static int vimc_sen_s_stream(struct v4l2_subdev *sd, int enable)
 		/* configure the test pattern generator */
 		vimc_sen_tpg_s_format(vsen);
 
-		/* Initialize the image generator thread */
-		vsen->kthread_sen = kthread_run(vimc_sen_tpg_thread, vsen,
-					"%s-sen", vsen->sd.v4l2_dev->name);
-		if (IS_ERR(vsen->kthread_sen)) {
-			dev_err(vsen->dev, "%s: kernel_thread() failed\n",
-				vsen->sd.name);
-			vfree(vsen->frame);
-			vsen->frame = NULL;
-			return PTR_ERR(vsen->kthread_sen);
-		}
 	} else {
-		if (!vsen->kthread_sen)
-			return 0;
-
-		/* Stop image generator */
-		ret = kthread_stop(vsen->kthread_sen);
-		if (ret)
-			return ret;
 
-		vsen->kthread_sen = NULL;
 		vfree(vsen->frame);
 		vsen->frame = NULL;
 		return 0;
@@ -413,6 +382,7 @@ static int vimc_sen_comp_bind(struct device *comp, struct device *master,
 	if (ret)
 		goto err_free_hdl;
 
+	vsen->ved.process_frame = vimc_sen_process_frame;
 	dev_set_drvdata(comp, &vsen->ved);
 	vsen->dev = comp;
 
diff --git a/drivers/media/platform/vimc/vimc-streamer.c b/drivers/media/platform/vimc/vimc-streamer.c
new file mode 100644
index 000000000000..f614734538c2
--- /dev/null
+++ b/drivers/media/platform/vimc/vimc-streamer.c
@@ -0,0 +1,176 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * vimc-streamer.c Virtual Media Controller Driver
+ *
+ * Copyright (C) 2018 Lucas A. M. Magalhães <lucmaga@gmail.com>
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/freezer.h>
+#include <linux/kthread.h>
+
+#include "vimc-streamer.h"
+
+/*
+ * vimc_streamer_pipeline_disable - Disable stream in all ved in stream
+ *
+ * @stream: the pointer to the stream structure with the pipeline to be
+ *	    disabled.
+ *
+ * Calls s_stream to disable the stream in each entity of the pipeline
+ *
+ */
+static void vimc_streamer_pipeline_disable(struct vimc_stream *stream)
+{
+	struct media_entity *entity;
+	struct v4l2_subdev *sd;
+
+	do {
+		stream->pipe_size--;
+		entity = stream->ved_pipeline[stream->pipe_size]->ent;
+		entity = vimc_get_source_entity(entity);
+		stream->ved_pipeline[stream->pipe_size] = NULL;
+		/*
+		 *  This may occur only if the streamer was not correctly
+		 *  initialized.
+		 */
+		if (!entity)
+			continue;
+
+		if (!is_media_entity_v4l2_subdev(entity))
+			continue;
+
+		sd = media_entity_to_v4l2_subdev(entity);
+		v4l2_subdev_call(sd, video, s_stream, 0);
+	} while (stream->pipe_size);
+}
+
+/*
+ * vimc_streamer_pipeline_init - initializes the stream structure
+ *
+ * @stream: the pointer to the stream structure to be initialized
+ * @ved:    the pointer to the vimc entity initializing the stream
+ *
+ * Initializes the stream structure. Walks through the entity graph to
+ * construct the pipeline used later on the streamer thread.
+ * Calls s_stream to enable stream in all entities of the pipeline.
+ */
+static int vimc_streamer_pipeline_init(struct vimc_stream *stream,
+				struct vimc_ent_device *ved)
+{
+	struct vimc_ent_device *source_ved = NULL;
+	struct media_entity *entity;
+	struct video_device *vdev;
+	struct v4l2_subdev *sd;
+	int ret = -EINVAL;
+
+	stream->pipe_size = 0;
+	stream->ved_pipeline[stream->pipe_size++] = ved;
+
+	while (stream->pipe_size < VIMC_STREAMER_PIPELINE_MAX_SIZE) {
+		if (!stream->ved_pipeline[stream->pipe_size-1])
+			return 0;
+		entity = stream->ved_pipeline[stream->pipe_size-1]->ent;
+		entity = vimc_get_source_entity(entity);
+		if (!entity)
+			return 0;
+		if (is_media_entity_v4l2_subdev(entity)) {
+			sd = media_entity_to_v4l2_subdev(entity);
+			ret = v4l2_subdev_call(sd, video, s_stream, 1);
+			if (ret && ret != -ENOIOCTLCMD)
+				break;
+			source_ved = v4l2_get_subdevdata(sd);
+		} else {
+			vdev = container_of(entity,
+					    struct video_device,
+					    entity);
+			source_ved = video_get_drvdata(vdev);
+		}
+
+		stream->ved_pipeline[stream->pipe_size++] = source_ved;
+		source_ved = NULL;
+	}
+
+	/*
+	 * If an error occur during initialization or the pipeline gets longer
+	 * than VIMC_STREAMER_PIPELINE_MAX_SIZE the stream is disabled and
+	 * return the error code.
+	 */
+	vimc_streamer_pipeline_disable(stream);
+	return ret;
+}
+
+static int vimc_streamer_thread(void *data)
+{
+	struct vimc_stream *stream = data;
+	int i;
+
+	set_freezable();
+	set_current_state(TASK_UNINTERRUPTIBLE);
+
+	for (;;) {
+		try_to_freeze();
+		if (kthread_should_stop())
+			break;
+
+		for (i = stream->pipe_size - 1; i >= 0; i--) {
+			stream->frame = stream->ved_pipeline[i]->process_frame(
+					stream->ved_pipeline[i],
+					stream->frame);
+			if (!stream->frame)
+				break;
+			if (IS_ERR(stream->frame))
+				break;
+		}
+		//wait for 60hz
+		schedule_timeout(HZ / 60);
+	}
+
+	return 0;
+}
+
+int vimc_streamer_s_stream(struct vimc_stream *stream,
+			   struct vimc_ent_device *ved,
+			   int enable)
+{
+	int ret;
+
+	if (!stream || !ved)
+		return -EINVAL;
+
+	if (enable) {
+		if (stream->kthread)
+			return 0;
+
+		ret = vimc_streamer_pipeline_init(stream, ved);
+		if (ret)
+			return ret;
+
+		stream->kthread = kthread_run(vimc_streamer_thread, stream,
+					      "vimc-streamer thread");
+
+		if (IS_ERR(stream->kthread))
+			return PTR_ERR(stream->kthread);
+
+	} else {
+		if (!stream->kthread)
+			return 0;
+
+		ret = kthread_stop(stream->kthread);
+		if (ret)
+			return ret;
+
+		stream->kthread = NULL;
+
+		vimc_streamer_pipeline_disable(stream);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vimc_streamer_s_stream);
+
+MODULE_DESCRIPTION("Virtual Media Controller Driver (VIMC) Streamer");
+MODULE_AUTHOR("Lucas A. M. Magalhães <lucmaga@gmail.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/platform/vimc/vimc-streamer.h b/drivers/media/platform/vimc/vimc-streamer.h
new file mode 100644
index 000000000000..752af2e2d5a2
--- /dev/null
+++ b/drivers/media/platform/vimc/vimc-streamer.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+/*
+ * vimc-streamer.h Virtual Media Controller Driver
+ *
+ * Copyright (C) 2018 Lucas A. M. Magalhães <lucmaga@gmail.com>
+ *
+ */
+
+#ifndef _VIMC_STREAMER_H_
+#define _VIMC_STREAMER_H_
+
+#include <media/media-device.h>
+
+#include "vimc-common.h"
+
+#define VIMC_STREAMER_PIPELINE_MAX_SIZE 16
+
+struct vimc_stream {
+	struct media_pipeline pipe;
+	struct vimc_ent_device *ved_pipeline[VIMC_STREAMER_PIPELINE_MAX_SIZE];
+	unsigned int pipe_size;
+	u8 *frame;
+	struct task_struct *kthread;
+};
+
+/**
+ * vimc_streamer_s_streamer - start/stop the stream
+ *
+ * @stream:	the pointer to the stream to start or stop
+ * @ved:	The last entity of the streamer pipeline
+ * @enable:	any non-zero number start the stream, zero stop
+ *
+ */
+int vimc_streamer_s_stream(struct vimc_stream *stream,
+			   struct vimc_ent_device *ved,
+			   int enable);
+
+#endif  //_VIMC_STREAMER_H_
-- 
2.20.0.rc1

