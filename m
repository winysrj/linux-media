Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932082AbdBJU1z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 15:27:55 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, kieran.bingham@ideasonboard.com
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 5/8] v4l: vsp1: Operate on partition struct data directly
Date: Fri, 10 Feb 2017 20:27:33 +0000
Message-Id: <1f4036763d2d29bf9b2a0d8f39942155e493b343.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When generating the partition windows, operate directly on the partition
struct rather than copying and duplicating the processed data

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 43 ++++++++++++-------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index a978508a4993..5f1886bfad26 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -189,17 +189,17 @@ static int __vsp1_video_try_format(struct vsp1_video *video,
 /**
  * vsp1_video_partition - Calculate the active partition output window
  *
+ * @partition: The active partition data
  * @div_size: pre-determined maximum partition division size
  * @index: partition index
  *
- * Returns a v4l2_rect describing the partition window.
+ * Generates the output partitioning positions.
  */
-static struct v4l2_rect vsp1_video_partition(struct vsp1_pipeline *pipe,
-					     unsigned int div_size,
-					     unsigned int index)
+static void vsp1_video_partition(struct vsp1_pipeline *pipe,
+				 struct vsp1_partition *partition,
+				 unsigned int div_size, unsigned int index)
 {
 	const struct v4l2_mbus_framefmt *format;
-	struct v4l2_rect partition;
 	unsigned int modulus;
 
 	format = vsp1_entity_get_pad_format(&pipe->output->entity,
@@ -208,18 +208,19 @@ static struct v4l2_rect vsp1_video_partition(struct vsp1_pipeline *pipe,
 
 	/* A single partition simply processes the output size in full. */
 	if (pipe->partitions <= 1) {
-		partition.left = 0;
-		partition.top = 0;
-		partition.width = format->width;
-		partition.height = format->height;
-		return partition;
+		partition->dest.left = 0;
+		partition->dest.top = 0;
+		partition->dest.width = format->width;
+		partition->dest.height = format->height;
+
+		return;
 	}
 
 	/* Initialise the partition with sane starting conditions. */
-	partition.left = index * div_size;
-	partition.top = 0;
-	partition.width = div_size;
-	partition.height = format->height;
+	partition->dest.left = index * div_size;
+	partition->dest.top = 0;
+	partition->dest.width = div_size;
+	partition->dest.height = format->height;
 
 	modulus = format->width % div_size;
 
@@ -242,18 +243,16 @@ static struct v4l2_rect vsp1_video_partition(struct vsp1_pipeline *pipe,
 		if (modulus < div_size / 2) {
 			if (index == partitions - 1) {
 				/* Halve the penultimate partition. */
-				partition.width = div_size / 2;
+				partition->dest.width = div_size / 2;
 			} else if (index == partitions) {
 				/* Increase the final partition. */
-				partition.width = (div_size / 2) + modulus;
-				partition.left -= div_size / 2;
+				partition->dest.width = div_size / 2 + modulus;
+				partition->dest.left -= div_size / 2;
 			}
 		} else if (index == partitions) {
-			partition.width = modulus;
+			partition->dest.width = modulus;
 		}
 	}
-
-	return partition;
 }
 
 static void vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
@@ -274,7 +273,7 @@ static void vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
 		struct vsp1_partition *partition = &pipe->part_table[0];
 
 		pipe->partitions = 1;
-		partition->dest = vsp1_video_partition(pipe, div_size, 0);
+		vsp1_video_partition(pipe, partition, div_size, 0);
 
 		return;
 	}
@@ -294,7 +293,7 @@ static void vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
 	for (i = 0; i < pipe->partitions; i++) {
 		struct vsp1_partition *partition = &pipe->part_table[i];
 
-		partition->dest = vsp1_video_partition(pipe, div_size, i);
+		vsp1_video_partition(pipe, partition, div_size, i);
 	}
 }
 
-- 
git-series 0.9.1
