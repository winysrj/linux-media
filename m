Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932082AbdBJU1u (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 15:27:50 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, kieran.bingham@ideasonboard.com
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 3/8] v4l: vsp1: Correct image partition parameters
Date: Fri, 10 Feb 2017 20:27:31 +0000
Message-Id: <6d9f8e04ac314ef7a1ffdc10d079fcd30707a03a.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The image partition algorithm operates on the image dimensions as input
into the WPF entity.

Correct this in the code, and document what defines the properties for
the algorithm in the section header

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 12 ++++++++++--
 drivers/media/platform/vsp1/vsp1_wpf.c   |  4 ++--
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index be9c860b1c04..4ade958a1c9e 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -176,6 +176,14 @@ static int __vsp1_video_try_format(struct vsp1_video *video,
 
 /* -----------------------------------------------------------------------------
  * VSP1 Partition Algorithm support
+ *
+ * VSP hardware can have restrictions on image width dependent on the hardware
+ * configuration of the pipeline. Adapting for these restrictions is implemented
+ * via the partition algorithm.
+ *
+ * The partition windows and sizes are based on the output size of the WPF
+ * before rotation, which is represented by the input parameters to the WPF
+ * entity in our pipeline.
  */
 
 /**
@@ -196,7 +204,7 @@ static struct v4l2_rect vsp1_video_partition(struct vsp1_pipeline *pipe,
 
 	format = vsp1_entity_get_pad_format(&pipe->output->entity,
 					    pipe->output->entity.config,
-					    RWPF_PAD_SOURCE);
+					    RWPF_PAD_SINK);
 
 	/* A single partition simply processes the output size in full. */
 	if (pipe->partitions <= 1) {
@@ -258,7 +266,7 @@ static void vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
 
 	format = vsp1_entity_get_pad_format(&pipe->output->entity,
 					    pipe->output->entity.config,
-					    RWPF_PAD_SOURCE);
+					    RWPF_PAD_SINK);
 	div_size = format->width;
 
 	/* Gen2 hardware doesn't require image partitioning. */
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 7c48f81cd5c1..ad67034e08e9 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -218,8 +218,8 @@ static void wpf_configure(struct vsp1_entity *entity,
 		const struct v4l2_pix_format_mplane *format = &wpf->format;
 		struct vsp1_rwpf_memory mem = wpf->mem;
 		unsigned int flip = wpf->flip.active;
-		unsigned int width = source_format->width;
-		unsigned int height = source_format->height;
+		unsigned int width = sink_format->width;
+		unsigned int height = sink_format->height;
 		unsigned int offset;
 
 		/*
-- 
git-series 0.9.1
