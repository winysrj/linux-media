Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:36077 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753693AbcCUIsK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 04:48:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 1/2] v4l2-ioctl: simplify code
Date: Mon, 21 Mar 2016 09:47:59 +0100
Message-Id: <1458550080-42743-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1458550080-42743-1-git-send-email-hverkuil@xs4all.nl>
References: <1458550080-42743-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Instead of a big if at the beginning, just check if g_selection == NULL
and call the cropcap op immediately and return the result.

No functional changes in this patch.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 51 ++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 6bf5a3e..3cf8d3a 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2160,33 +2160,40 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_cropcap *p = arg;
+	struct v4l2_selection s = { .type = p->type };
+	int ret;
 
-	if (ops->vidioc_g_selection) {
-		struct v4l2_selection s = { .type = p->type };
-		int ret;
+	if (ops->vidioc_g_selection == NULL) {
+		/*
+		 * The determine_valid_ioctls() call already should ensure
+		 * that ops->vidioc_cropcap != NULL, but just in case...
+		 */
+		if (ops->vidioc_cropcap)
+			return ops->vidioc_cropcap(file, fh, p);
+		return -ENOTTY;
+	}
 
-		/* obtaining bounds */
-		if (V4L2_TYPE_IS_OUTPUT(p->type))
-			s.target = V4L2_SEL_TGT_COMPOSE_BOUNDS;
-		else
-			s.target = V4L2_SEL_TGT_CROP_BOUNDS;
+	/* obtaining bounds */
+	if (V4L2_TYPE_IS_OUTPUT(p->type))
+		s.target = V4L2_SEL_TGT_COMPOSE_BOUNDS;
+	else
+		s.target = V4L2_SEL_TGT_CROP_BOUNDS;
 
-		ret = ops->vidioc_g_selection(file, fh, &s);
-		if (ret)
-			return ret;
-		p->bounds = s.r;
+	ret = ops->vidioc_g_selection(file, fh, &s);
+	if (ret)
+		return ret;
+	p->bounds = s.r;
 
-		/* obtaining defrect */
-		if (V4L2_TYPE_IS_OUTPUT(p->type))
-			s.target = V4L2_SEL_TGT_COMPOSE_DEFAULT;
-		else
-			s.target = V4L2_SEL_TGT_CROP_DEFAULT;
+	/* obtaining defrect */
+	if (V4L2_TYPE_IS_OUTPUT(p->type))
+		s.target = V4L2_SEL_TGT_COMPOSE_DEFAULT;
+	else
+		s.target = V4L2_SEL_TGT_CROP_DEFAULT;
 
-		ret = ops->vidioc_g_selection(file, fh, &s);
-		if (ret)
-			return ret;
-		p->defrect = s.r;
-	}
+	ret = ops->vidioc_g_selection(file, fh, &s);
+	if (ret)
+		return ret;
+	p->defrect = s.r;
 
 	/* setting trivial pixelaspect */
 	p->pixelaspect.numerator = 1;
-- 
2.7.0

