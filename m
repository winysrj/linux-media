Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49139 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932924AbbFEO2N (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Jun 2015 10:28:13 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Wolfram Sang <wsa@the-dreams.de>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH 03/11] [media] sh_vou: avoid going past arrays
Date: Fri,  5 Jun 2015 11:27:36 -0300
Message-Id: <5ac417efe66ddd7cd70a98f7f4e32a14ae40a651.1433514004.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433514004.git.mchehab@osg.samsung.com>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1433514004.git.mchehab@osg.samsung.com>
References: <cover.1433514004.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Smatch reports two issues:
	drivers/media/platform/sh_vou.c:670 vou_adjust_output() error: buffer overflow 'vou_scale_v_num' 3 <= 4
	drivers/media/platform/sh_vou.c:670 vou_adjust_output() error: buffer overflow 'vou_scale_v_den' 3 <= 4

It seems that there's actually a bug here: the same var (idx) is used
as an index for vertical and horizontal scaling arrays. However,
there are 4 elements on the h arrays, and only 3 at the v ones.

On the first loop, it may select index 4 for the horizontal array.

In this case, if the second loop fails to select an index, the
code would keep using 4 for the vertical array, with is past of
the array sizes.

The intent here seems to use index 0, if the scale is not found.

So, use a separate var for the vertical index.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 829e85c26610..8b799bae01b8 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -600,7 +600,7 @@ static void vou_adjust_output(struct sh_vou_geometry *geo, v4l2_std_id std)
 {
 	unsigned int best_err = UINT_MAX, best = geo->in_width,
 		width_max, height_max, img_height_max;
-	int i, idx = 0;
+	int i, idx_h = 0, idx_v = 0;
 
 	if (std & V4L2_STD_525_60) {
 		width_max = 858;
@@ -625,7 +625,7 @@ static void vou_adjust_output(struct sh_vou_geometry *geo, v4l2_std_id std)
 		err = abs(found - geo->output.width);
 		if (err < best_err) {
 			best_err = err;
-			idx = i;
+			idx_h = i;
 			best = found;
 		}
 		if (!err)
@@ -633,12 +633,12 @@ static void vou_adjust_output(struct sh_vou_geometry *geo, v4l2_std_id std)
 	}
 
 	geo->output.width = best;
-	geo->scale_idx_h = idx;
+	geo->scale_idx_h = idx_h;
 	if (geo->output.left + best > width_max)
 		geo->output.left = width_max - best;
 
 	pr_debug("%s(): W %u * %u/%u = %u\n", __func__, geo->in_width,
-		 vou_scale_h_num[idx], vou_scale_h_den[idx], best);
+		 vou_scale_h_num[idx_h], vou_scale_h_den[idx_h], best);
 
 	best_err = UINT_MAX;
 
@@ -655,7 +655,7 @@ static void vou_adjust_output(struct sh_vou_geometry *geo, v4l2_std_id std)
 		err = abs(found - geo->output.height);
 		if (err < best_err) {
 			best_err = err;
-			idx = i;
+			idx_v = i;
 			best = found;
 		}
 		if (!err)
@@ -663,12 +663,12 @@ static void vou_adjust_output(struct sh_vou_geometry *geo, v4l2_std_id std)
 	}
 
 	geo->output.height = best;
-	geo->scale_idx_v = idx;
+	geo->scale_idx_v = idx_v;
 	if (geo->output.top + best > height_max)
 		geo->output.top = height_max - best;
 
 	pr_debug("%s(): H %u * %u/%u = %u\n", __func__, geo->in_height,
-		 vou_scale_v_num[idx], vou_scale_v_den[idx], best);
+		 vou_scale_v_num[idx_v], vou_scale_v_den[idx_v], best);
 }
 
 static int sh_vou_s_fmt_vid_out(struct file *file, void *priv,
-- 
2.4.2

