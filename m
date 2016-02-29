Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:48093 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507AbcB2KQu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 05:16:50 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund+renesas@ragnatech.se,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/2] v4l2-ioctl: simplify code
Date: Mon, 29 Feb 2016 11:16:39 +0100
Message-Id: <1456741000-39069-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1456741000-39069-1-git-send-email-hverkuil@xs4all.nl>
References: <1456741000-39069-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Instead of a big if at the beginning, just check if g_selection == NULL
and call the cropcap op immediately and return the result.

No functional changes in this patch.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 44 ++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 86c4c19..67dbb03 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2157,33 +2157,33 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_cropcap *p = arg;
+	struct v4l2_selection s = { .type = p->type };
+	int ret;
 
-	if (ops->vidioc_g_selection) {
-		struct v4l2_selection s = { .type = p->type };
-		int ret;
+	if (ops->vidioc_g_selection == NULL)
+		return ops->vidioc_cropcap(file, fh, p);
 
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

