Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:57325 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427Ab3CKTBC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 15:01:02 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	shaik.samsung@gmail.com, arun.kk@samsung.com, a.hajda@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 04/11] s5p-fimc: Update graph traversal for entities with
 multiple source pads
Date: Mon, 11 Mar 2013 20:00:19 +0100
Message-id: <1363028426-2771-5-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1363028426-2771-1-git-send-email-s.nawrocki@samsung.com>
References: <1363028426-2771-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We cannot assume that the passed entity the fimc_pipeline_prepare()
function is supposed to start the media graph traversal from will
always have its sink pad at pad index 0. Find the starting media
entity's sink pad by iterating over its all pads and checking the
pad flags. This ensures proper handling of FIMC, FIMC-LITE and
FIMC-IS-ISP subdevs that have more than one sink and one source pad.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 19cd628..0a7c95b 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -47,7 +47,6 @@ static int __fimc_md_set_camclk(struct fimc_md *fmd,
 static void fimc_pipeline_prepare(struct fimc_pipeline *p,
 				  struct media_entity *me)
 {
-	struct media_pad *pad = &me->pads[0];
 	struct v4l2_subdev *sd;
 	int i;
 
@@ -55,15 +54,21 @@ static void fimc_pipeline_prepare(struct fimc_pipeline *p,
 		p->subdevs[i] = NULL;
 
 	while (1) {
-		if (!(pad->flags & MEDIA_PAD_FL_SINK))
-			break;
+		struct media_pad *pad = NULL;
+
+		/* Find remote source pad */
+		for (i = 0; i < me->num_pads; i++) {
+			struct media_pad *spad = &me->pads[i];
+			if (!(spad->flags & MEDIA_PAD_FL_SINK))
+				continue;
+			pad = media_entity_remote_source(spad);
+			if (pad)
+				break;
+		}
 
-		/* source pad */
-		pad = media_entity_remote_source(pad);
 		if (pad == NULL ||
 		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
 			break;
-
 		sd = media_entity_to_v4l2_subdev(pad->entity);
 
 		switch (sd->grp_id) {
@@ -84,8 +89,9 @@ static void fimc_pipeline_prepare(struct fimc_pipeline *p,
 			pr_warn("%s: Unknown subdev grp_id: %#x\n",
 				__func__, sd->grp_id);
 		}
-		/* sink pad */
-		pad = &sd->entity.pads[0];
+		me = &sd->entity;
+		if (me->num_pads == 1)
+			break;
 	}
 }
 
-- 
1.7.9.5

