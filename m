Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42480 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaEUUjJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 May 2014 16:39:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH] v4l: vsp1: Remove the unneeded vsp1_video_buffer video field
Date: Wed, 21 May 2014 22:39:16 +0200
Message-Id: <1400704756-2521-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The field is assigned but never read, remove it.

This fixes a bug caused by the struct vb2_buffer field not being be the
very first field of the vsp1_video_buffer buffer structure as required
by videobuf2.

Cc: stable@vger.kernel.org
Reported-by: Takanari Hayama <taki@igel.co.jp>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 2 --
 drivers/media/platform/vsp1/vsp1_video.h | 1 -
 2 files changed, 3 deletions(-)

Mauro, this is a bug fix, could it get in v3.16 ?

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 8a1253e..677e3aa 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -654,8 +654,6 @@ static int vsp1_video_buffer_prepare(struct vb2_buffer *vb)
 	if (vb->num_planes < format->num_planes)
 		return -EINVAL;
 
-	buf->video = video;
-
 	for (i = 0; i < vb->num_planes; ++i) {
 		buf->addr[i] = vb2_dma_contig_plane_dma_addr(vb, i);
 		buf->length[i] = vb2_plane_size(vb, i);
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index c04d48f..7284320 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -90,7 +90,6 @@ static inline struct vsp1_pipeline *to_vsp1_pipeline(struct media_entity *e)
 }
 
 struct vsp1_video_buffer {
-	struct vsp1_video *video;
 	struct vb2_buffer buf;
 	struct list_head queue;
 
-- 
Regards,

Laurent Pinchart

