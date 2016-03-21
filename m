Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:45880 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753633AbcCUIsL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 04:48:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 2/2] v4l2-ioctl: improve cropcap handling
Date: Mon, 21 Mar 2016 09:48:00 +0100
Message-Id: <1458550080-42743-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1458550080-42743-1-git-send-email-hverkuil@xs4all.nl>
References: <1458550080-42743-1-git-send-email-hverkuil@xs4all.nl>
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
index 3cf8d3a..61eb810 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2161,7 +2161,7 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
 {
 	struct v4l2_cropcap *p = arg;
 	struct v4l2_selection s = { .type = p->type };
-	int ret;
+	int ret = -ENOTTY;
 
 	if (ops->vidioc_g_selection == NULL) {
 		/*
@@ -2173,6 +2173,32 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
 		return -ENOTTY;
 	}
 
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
@@ -2195,13 +2221,6 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
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

