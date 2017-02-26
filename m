Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59369 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751298AbdBZVGw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Feb 2017 16:06:52 -0500
Date: Sun, 26 Feb 2017 21:58:16 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
        Yoshihiro Kaneko <ykaneko0929@gmail.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] soc-camera: fix rectangle adjustment in cropping
Message-ID: <Pine.LNX.4.64.1702262150090.17018@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

update_subrect() adjusts the sub-rectangle to be inside a base area.
It checks width and height to not exceed those of the area, then it
checks the low border (left or top) to lie within the area, then the
high border (right or bottom) to lie there too. This latter check has
a bug, which is fixed by this patch.

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
[g.liakhovetski@gmx.de: dropped supposedly wrong hunks]
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

This is a part of the https://patchwork.linuxtv.org/patch/26441/ submitted 
almost 2.5 years ago. Back then I commented to the patch but never got a 
reply or an update. I preserved original authorship and Sob tags, although 
this version only uses a small portion of the original patch. This version 
is of course completely untested, any testing (at least regression) would 
be highly appreciated! This code is only used by the SH CEU driver and 
only in cropping / zooming scenarios.

 drivers/media/platform/soc_camera/soc_scale_crop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
index f77252d..4bfc1bf 100644
--- a/drivers/media/platform/soc_camera/soc_scale_crop.c
+++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
@@ -70,14 +70,14 @@ static void update_subrect(struct v4l2_rect *rect, struct v4l2_rect *subrect)
 	if (rect->height < subrect->height)
 		subrect->height = rect->height;
 
-	if (rect->left > subrect->left)
+	if (rect->left < subrect->left)
 		subrect->left = rect->left;
 	else if (rect->left + rect->width >
 		 subrect->left + subrect->width)
 		subrect->left = rect->left + rect->width -
 			subrect->width;
 
-	if (rect->top > subrect->top)
+	if (rect->top < subrect->top)
 		subrect->top = rect->top;
 	else if (rect->top + rect->height >
 		 subrect->top + subrect->height)
-- 
1.9.3
