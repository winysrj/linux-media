Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44176 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802AbaHZVzW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:22 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 17/35] [media] omap_vout: Get rid of a few warnings
Date: Tue, 26 Aug 2014 18:54:53 -0300
Message-Id: <1409090111-8290-18-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/omap/omap_vout.c: In function 'omapvid_setup_overlay':
drivers/media/platform/omap/omap_vout.c:372:29: warning: variable 'pixheight' set but not used [-Wunused-but-set-variable]
  int cropheight, cropwidth, pixheight, pixwidth;
                             ^
drivers/media/platform/omap/omap_vout.c: In function 'vidioc_s_ctrl':
drivers/media/platform/omap/omap_vout.c:1454:24: warning: variable 'ovl' set but not used [-Wunused-but-set-variable]
   struct omap_overlay *ovl;
                        ^
drivers/media/platform/omap/omap_vout.c: In function 'vidioc_reqbufs':
drivers/media/platform/omap/omap_vout.c:1492:55: warning: comparison of unsigned expression < 0 is always false [-Wtype-limits]
  if ((req->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) || (req->count < 0))
                                                       ^

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/omap/omap_vout.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index 2d177fa58471..d9258f3d0f8e 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -369,7 +369,7 @@ static int omapvid_setup_overlay(struct omap_vout_device *vout,
 {
 	int ret = 0;
 	struct omap_overlay_info info;
-	int cropheight, cropwidth, pixheight, pixwidth;
+	int cropheight, cropwidth, pixwidth;
 
 	if ((ovl->caps & OMAP_DSS_OVL_CAP_SCALE) == 0 &&
 			(outw != vout->pix.width || outh != vout->pix.height)) {
@@ -389,12 +389,10 @@ static int omapvid_setup_overlay(struct omap_vout_device *vout,
 	if (is_rotation_90_or_270(vout)) {
 		cropheight = vout->crop.width;
 		cropwidth = vout->crop.height;
-		pixheight = vout->pix.width;
 		pixwidth = vout->pix.height;
 	} else {
 		cropheight = vout->crop.height;
 		cropwidth = vout->crop.width;
-		pixheight = vout->pix.height;
 		pixwidth = vout->pix.width;
 	}
 
@@ -1451,12 +1449,10 @@ static int vidioc_s_ctrl(struct file *file, void *fh, struct v4l2_control *a)
 	}
 	case V4L2_CID_VFLIP:
 	{
-		struct omap_overlay *ovl;
 		struct omapvideo_info *ovid;
 		unsigned int  mirror = a->value;
 
 		ovid = &vout->vid_info;
-		ovl = ovid->overlays[0];
 
 		mutex_lock(&vout->lock);
 		if (mirror && ovid->rotation_type == VOUT_ROT_NONE) {
@@ -1489,7 +1485,7 @@ static int vidioc_reqbufs(struct file *file, void *fh,
 	struct omap_vout_device *vout = fh;
 	struct videobuf_queue *q = &vout->vbq;
 
-	if ((req->type != V4L2_BUF_TYPE_VIDEO_OUTPUT) || (req->count < 0))
+	if (req->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		return -EINVAL;
 	/* if memory is not mmp or userptr
 	   return error */
-- 
1.9.3

