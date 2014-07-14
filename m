Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1454 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761AbaGNM7i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 08:59:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 04/12] v4l2-ioctl: call g_selection before calling cropcap
Date: Mon, 14 Jul 2014 14:59:04 +0200
Message-Id: <1405342752-46998-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1405342752-46998-1-git-send-email-hverkuil@xs4all.nl>
References: <1405342752-46998-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If the vidioc_cropcap op is implemented by the driver then the v4l2
core will call that directly.

If g_selection is available, then the core cropcap implementation
uses g_selection to fill in the bounds and defrect and it sets the
pixelaspect to 1x1.

But if both are available, then I would like to use g_selection to
fill in defrect and bounds before calling cropcap. That way the
driver's cropcap implementation doesn't have to set defrect or
bounds.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 48 +++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 8d4a25d..f81b9aa 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1751,37 +1751,41 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_cropcap *p = arg;
-	struct v4l2_selection s = { .type = p->type };
-	int ret;
 
-	if (ops->vidioc_cropcap)
-		return ops->vidioc_cropcap(file, fh, p);
+	if (ops->vidioc_g_selection) {
+		struct v4l2_selection s = { .type = p->type };
+		int ret;
 
-	/* obtaining bounds */
-	if (V4L2_TYPE_IS_OUTPUT(p->type))
-		s.target = V4L2_SEL_TGT_COMPOSE_BOUNDS;
-	else
-		s.target = V4L2_SEL_TGT_CROP_BOUNDS;
+		/* obtaining bounds */
+		if (V4L2_TYPE_IS_OUTPUT(p->type))
+			s.target = V4L2_SEL_TGT_COMPOSE_BOUNDS;
+		else
+			s.target = V4L2_SEL_TGT_CROP_BOUNDS;
 
-	ret = ops->vidioc_g_selection(file, fh, &s);
-	if (ret)
-		return ret;
-	p->bounds = s.r;
+		ret = ops->vidioc_g_selection(file, fh, &s);
+		if (ret)
+			return ret;
+		p->bounds = s.r;
 
-	/* obtaining defrect */
-	if (V4L2_TYPE_IS_OUTPUT(p->type))
-		s.target = V4L2_SEL_TGT_COMPOSE_DEFAULT;
-	else
-		s.target = V4L2_SEL_TGT_CROP_DEFAULT;
+		/* obtaining defrect */
+		if (V4L2_TYPE_IS_OUTPUT(p->type))
+			s.target = V4L2_SEL_TGT_COMPOSE_DEFAULT;
+		else
+			s.target = V4L2_SEL_TGT_CROP_DEFAULT;
 
-	ret = ops->vidioc_g_selection(file, fh, &s);
-	if (ret)
-		return ret;
-	p->defrect = s.r;
+		ret = ops->vidioc_g_selection(file, fh, &s);
+		if (ret)
+			return ret;
+		p->defrect = s.r;
+	}
 
 	/* setting trivial pixelaspect */
 	p->pixelaspect.numerator = 1;
 	p->pixelaspect.denominator = 1;
+
+	if (ops->vidioc_cropcap)
+		return ops->vidioc_cropcap(file, fh, p);
+
 	return 0;
 }
 
-- 
2.0.1

