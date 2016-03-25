Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40677 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbcCYKog (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 06:44:36 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 06/54] v4l: vsp1: video: Fix coding style
Date: Fri, 25 Mar 2016 12:43:40 +0200
Message-Id: <1458902668-1141-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 54b5a749b4f3 ("[media] v4l: vsp1: Use media entity enumeration
interface") wasn't aligned with the driver coding style. Fix it by
renaming the rval variable to ret.

Furthermore shorten lines by accessing the media_device instance in a
more straightforward fashion.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 72cc7d3729f8..b97bbdb1a256 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -175,31 +175,30 @@ static int vsp1_video_pipeline_validate_branch(struct vsp1_pipeline *pipe,
 					       struct vsp1_rwpf *input,
 					       struct vsp1_rwpf *output)
 {
-	struct vsp1_entity *entity;
 	struct media_entity_enum ent_enum;
+	struct vsp1_entity *entity;
 	struct media_pad *pad;
-	int rval;
 	bool bru_found = false;
+	int ret;
 
 	input->location.left = 0;
 	input->location.top = 0;
 
-	rval = media_entity_enum_init(
-		&ent_enum, input->entity.pads[RWPF_PAD_SOURCE].graph_obj.mdev);
-	if (rval)
-		return rval;
+	ret = media_entity_enum_init(&ent_enum, &input->entity.vsp1->media_dev);
+	if (ret < 0)
+		return ret;
 
 	pad = media_entity_remote_pad(&input->entity.pads[RWPF_PAD_SOURCE]);
 
 	while (1) {
 		if (pad == NULL) {
-			rval = -EPIPE;
+			ret = -EPIPE;
 			goto out;
 		}
 
 		/* We've reached a video node, that shouldn't have happened. */
 		if (!is_media_entity_v4l2_subdev(pad->entity)) {
-			rval = -EPIPE;
+			ret = -EPIPE;
 			goto out;
 		}
 
@@ -229,14 +228,14 @@ static int vsp1_video_pipeline_validate_branch(struct vsp1_pipeline *pipe,
 		/* Ensure the branch has no loop. */
 		if (media_entity_enum_test_and_set(&ent_enum,
 						   &entity->subdev.entity)) {
-			rval = -EPIPE;
+			ret = -EPIPE;
 			goto out;
 		}
 
 		/* UDS can't be chained. */
 		if (entity->type == VSP1_ENTITY_UDS) {
 			if (pipe->uds) {
-				rval = -EPIPE;
+				ret = -EPIPE;
 				goto out;
 			}
 
@@ -256,12 +255,12 @@ static int vsp1_video_pipeline_validate_branch(struct vsp1_pipeline *pipe,
 
 	/* The last entity must be the output WPF. */
 	if (entity != &output->entity)
-		rval = -EPIPE;
+		ret = -EPIPE;
 
 out:
 	media_entity_enum_cleanup(&ent_enum);
 
-	return rval;
+	return ret;
 }
 
 static int vsp1_video_pipeline_validate(struct vsp1_pipeline *pipe,
-- 
2.7.3

