Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:54782 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507AbcB2KQv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 05:16:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund+renesas@ragnatech.se,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] v4l2-ioctl: improve cropcap handling
Date: Mon, 29 Feb 2016 11:16:40 +0100
Message-Id: <1456741000-39069-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1456741000-39069-1-git-send-email-hverkuil@xs4all.nl>
References: <1456741000-39069-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If cropcap is implemented, then call it first to fill in the pixel
aspect ratio. Don't return if cropcap returns ENOTTY or ENOIOCTLCMD,
in that case just assume a 1:1 pixel aspect ratio.

After cropcap was called, then overwrite bounds and defrect with the
g_selection result because the g_selection() result always has priority
over anything that vidioc_cropcap returns.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 67dbb03..a3db569 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2158,11 +2158,37 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
 {
 	struct v4l2_cropcap *p = arg;
 	struct v4l2_selection s = { .type = p->type };
-	int ret;
+	int ret = -ENOTTY;
 
 	if (ops->vidioc_g_selection == NULL)
 		return ops->vidioc_cropcap(file, fh, p);
 
+	/*
+	 * Let cropcap fill in the pixelaspect if cropcap is available.
+	 * There is still no other way of obtaining this information.
+	 */
+	if (ops->vidioc_cropcap) {
+		ret = ops->vidioc_cropcap(file, fh, p);
+
+		/*
+		 * If cropcap reports that it isn't implemented,
+		 * then just keep going.
+		 */
+		if (ret && ret != -ENOTTY && ret != -ENOIOCTLCMD)
+			return ret;
+	}
+
+	if (ret) {
+		/*
+		 * cropcap wasn't implemented, so assume a 1:1 pixel
+		 * aspect ratio, otherwise keep what cropcap gave us.
+		 */
+		p->pixelaspect.numerator = 1;
+		p->pixelaspect.denominator = 1;
+	}
+
+	/* Use g_selection() to fill in the bounds and defrect rectangles */
+
 	/* obtaining bounds */
 	if (V4L2_TYPE_IS_OUTPUT(p->type))
 		s.target = V4L2_SEL_TGT_COMPOSE_BOUNDS;
@@ -2185,13 +2211,6 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
 		return ret;
 	p->defrect = s.r;
 
-	/* setting trivial pixelaspect */
-	p->pixelaspect.numerator = 1;
-	p->pixelaspect.denominator = 1;
-
-	if (ops->vidioc_cropcap)
-		return ops->vidioc_cropcap(file, fh, p);
-
 	return 0;
 }
 
-- 
2.7.0

