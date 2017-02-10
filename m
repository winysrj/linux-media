Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932082AbdBJU1s (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 15:27:48 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, kieran.bingham@ideasonboard.com
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 2/8] v4l: vsp1: Track the SRU entity in the pipeline
Date: Fri, 10 Feb 2017 20:27:30 +0000
Message-Id: <8ad9d316c05ab254b65ad5230fb9232325e783ec.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The UDS and other entities are already tracked directly through the
pipeline object. To follow the design pattern, and allow us to reference
the SRU convert the usage of 'sru_found'

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_pipe.h  |  2 ++
 drivers/media/platform/vsp1/vsp1_video.c | 11 ++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index bc419ef48d8d..5aa31143ce59 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -76,6 +76,7 @@ enum vsp1_pipeline_state {
  * @output: WPF at the output of the pipeline
  * @bru: BRU entity, if present
  * @lif: LIF entity, if present
+ * @sru: SRU entity, if present
  * @uds: UDS entity, if present
  * @uds_input: entity at the input of the UDS, if the UDS is present
  * @entities: list of entities in the pipeline
@@ -104,6 +105,7 @@ struct vsp1_pipeline {
 	struct vsp1_rwpf *output;
 	struct vsp1_entity *bru;
 	struct vsp1_entity *lif;
+	struct vsp1_entity *sru;
 	struct vsp1_entity *uds;
 	struct vsp1_entity *uds_input;
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index e2f242e7f0fa..be9c860b1c04 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -473,7 +473,6 @@ static int vsp1_video_pipeline_build_branch(struct vsp1_pipeline *pipe,
 	struct vsp1_entity *entity;
 	struct media_pad *pad;
 	bool bru_found = false;
-	bool sru_found = false;
 	int ret;
 
 	ret = media_entity_enum_init(&ent_enum, &input->entity.vsp1->media_dev);
@@ -523,6 +522,12 @@ static int vsp1_video_pipeline_build_branch(struct vsp1_pipeline *pipe,
 		if (entity->type == VSP1_ENTITY_SRU) {
 			struct vsp1_sru *sru = to_sru(&entity->subdev);
 
+			/* SRU can't be chained. */
+			if (pipe->sru) {
+				ret = -EPIPE;
+				goto out;
+			}
+
 			/*
 			 * Gen3 partition algorithm restricts SRU double-scaled
 			 * resolution if it is connected after a UDS entity
@@ -530,7 +535,7 @@ static int vsp1_video_pipeline_build_branch(struct vsp1_pipeline *pipe,
 			if (vsp1->info->gen == 3 && pipe->uds)
 				sru->force_identity_mode = true;
 
-			sru_found = true;
+			pipe->sru = entity;
 		}
 
 		if (entity->type == VSP1_ENTITY_UDS) {
@@ -546,7 +551,7 @@ static int vsp1_video_pipeline_build_branch(struct vsp1_pipeline *pipe,
 			 * SRU on Gen3 will always engage the partition
 			 * algorithm
 			 */
-			if (vsp1->info->gen == 3 && sru_found) {
+			if (vsp1->info->gen == 3 && pipe->sru) {
 				ret = -EPIPE;
 				goto out;
 			}
-- 
git-series 0.9.1
