Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:34445 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754077AbcDOJ1f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 05:27:35 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id AEE15180436
	for <linux-media@vger.kernel.org>; Fri, 15 Apr 2016 11:27:28 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv2] v4l2-ioctl.c: improve cropcap compatibility code
Message-ID: <5710B400.9080408@xs4all.nl>
Date: Fri, 15 Apr 2016 11:27:28 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- Add a check for the case that both the cropcap and g_selection ops
  are NULL. This shouldn't happen, but I feel happier if the code
  guards against this.

- If g_selection exists, then ignore ENOTTY and ENOIOCTLCMD error
  codes from cropcap. Just assume square pixelaspect ratio in that
  case. This situation can happen if the bridge driver's cropcap op
  calls the corresponding subdev's op. So the cropcap ioctl is set,
  but it might return ENOIOCTLCMD anyway. In the past this would
  just return an error which is wrong.

- Call cropcap first and let g_selection overwrite the bounds and
  defrect. This safeguards against subdev cropcap implementations
  that set those rectangles as well. What g_selection returns has
  priority over what such cropcap implementations return.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---

This replaces a pair of older cleanup patches.

---
 drivers/media/v4l2-core/v4l2-ioctl.c | 70 ++++++++++++++++++++++--------------
 1 file changed, 43 insertions(+), 27 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 6bf5a3e..28e5be2 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2160,40 +2160,56 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_cropcap *p = arg;
+	struct v4l2_selection s = { .type = p->type };
+	int ret = 0;

-	if (ops->vidioc_g_selection) {
-		struct v4l2_selection s = { .type = p->type };
-		int ret;
+	/* setting trivial pixelaspect */
+	p->pixelaspect.numerator = 1;
+	p->pixelaspect.denominator = 1;

-		/* obtaining bounds */
-		if (V4L2_TYPE_IS_OUTPUT(p->type))
-			s.target = V4L2_SEL_TGT_COMPOSE_BOUNDS;
-		else
-			s.target = V4L2_SEL_TGT_CROP_BOUNDS;
+	/*
+	 * The determine_valid_ioctls() call already should ensure
+	 * that this can never happen, but just in case...
+	 */
+	if (WARN_ON(!ops->vidioc_cropcap && !ops->vidioc_cropcap))
+		return -ENOTTY;

-		ret = ops->vidioc_g_selection(file, fh, &s);
-		if (ret)
-			return ret;
-		p->bounds = s.r;
+	if (ops->vidioc_cropcap)
+		ret = ops->vidioc_cropcap(file, fh, p);

-		/* obtaining defrect */
-		if (V4L2_TYPE_IS_OUTPUT(p->type))
-			s.target = V4L2_SEL_TGT_COMPOSE_DEFAULT;
-		else
-			s.target = V4L2_SEL_TGT_CROP_DEFAULT;
+	if (!ops->vidioc_g_selection)
+		return ret;

-		ret = ops->vidioc_g_selection(file, fh, &s);
-		if (ret)
-			return ret;
-		p->defrect = s.r;
-	}
+	/*
+	 * Ignore ENOTTY or ENOIOCTLCMD error returns, just use the
+	 * square pixel aspect ratio in that case.
+	 */
+	if (ret && ret != -ENOTTY && ret != -ENOIOCTLCMD)
+		return ret;

-	/* setting trivial pixelaspect */
-	p->pixelaspect.numerator = 1;
-	p->pixelaspect.denominator = 1;
+	/* Use g_selection() to fill in the bounds and defrect rectangles */

-	if (ops->vidioc_cropcap)
-		return ops->vidioc_cropcap(file, fh, p);
+	/* obtaining bounds */
+	if (V4L2_TYPE_IS_OUTPUT(p->type))
+		s.target = V4L2_SEL_TGT_COMPOSE_BOUNDS;
+	else
+		s.target = V4L2_SEL_TGT_CROP_BOUNDS;
+
+	ret = ops->vidioc_g_selection(file, fh, &s);
+	if (ret)
+		return ret;
+	p->bounds = s.r;
+
+	/* obtaining defrect */
+	if (V4L2_TYPE_IS_OUTPUT(p->type))
+		s.target = V4L2_SEL_TGT_COMPOSE_DEFAULT;
+	else
+		s.target = V4L2_SEL_TGT_CROP_DEFAULT;
+
+	ret = ops->vidioc_g_selection(file, fh, &s);
+	if (ret)
+		return ret;
+	p->defrect = s.r;

 	return 0;
 }
-- 
2.8.0.rc3


