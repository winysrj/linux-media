Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:58873 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab2K2HJX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 02:09:23 -0500
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id BC13A40B98
	for <linux-media@vger.kernel.org>; Thu, 29 Nov 2012 08:09:21 +0100 (CET)
Date: Thu, 29 Nov 2012 08:09:21 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3.7] media: sh-vou: fix compiler warnings
Message-ID: <Pine.LNX.4.64.1211290807430.11210@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

sh-vou causes several "may be used uninitialized" warnings. Even though
they all are purely theoretical, it is better to fix them.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

I'll be pushing last-minute soc-camera+misc 3.7 fixes shortly, this patch 
will be there too.

 drivers/media/platform/sh_vou.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index a1c87f0..7494858 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -207,6 +207,7 @@ static void sh_vou_stream_start(struct sh_vou_device *vou_dev,
 #endif
 
 	switch (vou_dev->pix.pixelformat) {
+	default:
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV16:
 		row_coeff = 1;
@@ -595,9 +596,9 @@ static void vou_adjust_input(struct sh_vou_geometry *geo, v4l2_std_id std)
  */
 static void vou_adjust_output(struct sh_vou_geometry *geo, v4l2_std_id std)
 {
-	unsigned int best_err = UINT_MAX, best, width_max, height_max,
-		img_height_max;
-	int i, idx;
+	unsigned int best_err = UINT_MAX, best = geo->in_width,
+		width_max, height_max, img_height_max;
+	int i, idx = 0;
 
 	if (std & V4L2_STD_525_60) {
 		width_max = 858;
-- 
1.7.2.5

