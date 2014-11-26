Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:49816 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaKZGUC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 01:20:02 -0500
Received: by mail-pa0-f51.google.com with SMTP id ey11so2234901pad.10
        for <linux-media@vger.kernel.org>; Tue, 25 Nov 2014 22:20:01 -0800 (PST)
From: Takanari Hayama <taki@igel.co.jp>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 1/2] v4l: vsp1: Reset VSP1 RPF source address
Date: Wed, 26 Nov 2014 15:19:51 +0900
Message-Id: <1416982792-11917-2-git-send-email-taki@igel.co.jp>
In-Reply-To: <1416982792-11917-1-git-send-email-taki@igel.co.jp>
References: <1416982792-11917-1-git-send-email-taki@igel.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Source address of VSP1 RPF needs to be reset whenever crop offsets are
recalculated.

This correctly reflects a crop setting even VIDIOC_QBUF is called
before VIDIOIC_STREAMON is called.

Signed-off-by: Takanari Hayama <taki@igel.co.jp>
---
 drivers/media/platform/vsp1/vsp1_rpf.c  | 15 +++++++++++++++
 drivers/media/platform/vsp1/vsp1_rwpf.h |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index d14d26b..79c0db8 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -106,11 +106,22 @@ static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 			+ crop->left * fmtinfo->bpp[0] / 8;
 	pstride = format->plane_fmt[0].bytesperline
 		<< VI6_RPF_SRCM_PSTRIDE_Y_SHIFT;
+
+	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_Y,
+		       rpf->buf_addr[0] + rpf->offsets[0]);
+
 	if (format->num_planes > 1) {
 		rpf->offsets[1] = crop->top * format->plane_fmt[1].bytesperline
 				+ crop->left * fmtinfo->bpp[1] / 8;
 		pstride |= format->plane_fmt[1].bytesperline
 			<< VI6_RPF_SRCM_PSTRIDE_C_SHIFT;
+
+		vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C0,
+			       rpf->buf_addr[1] + rpf->offsets[1]);
+
+		if (format->num_planes > 2)
+			vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C1,
+				       rpf->buf_addr[2] + rpf->offsets[1]);
 	}
 
 	vsp1_rpf_write(rpf, VI6_RPF_SRCM_PSTRIDE, pstride);
@@ -179,6 +190,10 @@ static void rpf_vdev_queue(struct vsp1_video *video,
 			   struct vsp1_video_buffer *buf)
 {
 	struct vsp1_rwpf *rpf = container_of(video, struct vsp1_rwpf, video);
+	int i;
+
+	for (i = 0; i < 3; i++)
+		rpf->buf_addr[i] = buf->addr[i];
 
 	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_Y,
 		       buf->addr[0] + rpf->offsets[0]);
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 28dd9e7..1f98fe3 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -39,6 +39,8 @@ struct vsp1_rwpf {
 	struct v4l2_rect crop;
 
 	unsigned int offsets[2];
+
+	unsigned int buf_addr[3];
 };
 
 static inline struct vsp1_rwpf *to_rwpf(struct v4l2_subdev *subdev)
-- 
1.8.0

