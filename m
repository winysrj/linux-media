Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51715 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933330Ab2HVVDo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 17:03:44 -0400
Received: by weyx8 with SMTP id x8so19786wey.19
        for <linux-media@vger.kernel.org>; Wed, 22 Aug 2012 14:03:43 -0700 (PDT)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH] soc-camera: Use new selection target definitions
Date: Wed, 22 Aug 2012 23:03:30 +0200
Message-Id: <1345669410-31836-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the deprecated V4L2_SEL_TGT_*_ACTIVE selection target
names with their new unified counterparts.
Compatibility definitions are already in linux/v4l2-common.h.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 drivers/media/platform/soc_camera/soc_camera.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 10b57f8..ba62960 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -950,11 +950,11 @@ static int soc_camera_s_selection(struct file *file, void *fh,
 
 	/* In all these cases cropping emulation will not help */
 	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
-	    (s->target != V4L2_SEL_TGT_COMPOSE_ACTIVE &&
-	     s->target != V4L2_SEL_TGT_CROP_ACTIVE))
+	    (s->target != V4L2_SEL_TGT_COMPOSE &&
+	     s->target != V4L2_SEL_TGT_CROP))
 		return -EINVAL;
 
-	if (s->target == V4L2_SEL_TGT_COMPOSE_ACTIVE) {
+	if (s->target == V4L2_SEL_TGT_COMPOSE) {
 		/* No output size change during a running capture! */
 		if (is_streaming(ici, icd) &&
 		    (icd->user_width != s->r.width ||
@@ -974,7 +974,7 @@ static int soc_camera_s_selection(struct file *file, void *fh,
 
 	ret = ici->ops->set_selection(icd, s);
 	if (!ret &&
-	    s->target == V4L2_SEL_TGT_COMPOSE_ACTIVE) {
+	    s->target == V4L2_SEL_TGT_COMPOSE) {
 		icd->user_width = s->r.width;
 		icd->user_height = s->r.height;
 		if (!icd->streamer)
-- 
1.7.4.1

