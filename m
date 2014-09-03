Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44401 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151AbaICUdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:33:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 30/46] [media] omap: simplify test logic
Date: Wed,  3 Sep 2014 17:33:02 -0300
Message-Id: <c9aef2a208d6c0c0a69ca18ff91e1d523f253a59.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <cover.1409775488.git.m.chehab@samsung.com>
References: <cover.1409775488.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

instead of testing bools if they are false or true, just use
if (!foo) or if (foo). That makes the code easier to
read and shorter.

Also, properly initialize booleans with true or false.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index d9258f3d0f8e..64ab6fb06b9c 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -989,7 +989,7 @@ static int omap_vout_release(struct file *file)
 		mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN |
 			DISPC_IRQ_EVSYNC_ODD | DISPC_IRQ_VSYNC2;
 		omap_dispc_unregister_isr(omap_vout_isr, vout, mask);
-		vout->streaming = 0;
+		vout->streaming = false;
 
 		videobuf_streamoff(q);
 		videobuf_queue_cancel(q);
@@ -1644,7 +1644,7 @@ static int vidioc_streamon(struct file *file, void *fh, enum v4l2_buf_type i)
 	vout->field_id = 0;
 
 	/* set flag here. Next QBUF will start DMA */
-	vout->streaming = 1;
+	vout->streaming = true;
 
 	vout->first_int = 1;
 
@@ -1704,7 +1704,7 @@ static int vidioc_streamoff(struct file *file, void *fh, enum v4l2_buf_type i)
 	if (!vout->streaming)
 		return -EINVAL;
 
-	vout->streaming = 0;
+	vout->streaming = false;
 	mask = DISPC_IRQ_VSYNC | DISPC_IRQ_EVSYNC_EVEN | DISPC_IRQ_EVSYNC_ODD
 		| DISPC_IRQ_VSYNC2;
 
@@ -1912,7 +1912,7 @@ static int __init omap_vout_setup_video_data(struct omap_vout_device *vout)
 	control[0].id = V4L2_CID_ROTATE;
 	control[0].value = 0;
 	vout->rotation = 0;
-	vout->mirror = 0;
+	vout->mirror = false;
 	vout->control[2].id = V4L2_CID_HFLIP;
 	vout->control[2].value = 0;
 	if (vout->vid_info.rotation_type == VOUT_ROT_VRFB)
diff --git a/drivers/media/platform/omap/omap_vout_vrfb.c b/drivers/media/platform/omap/omap_vout_vrfb.c
index 62e7e5783ce8..aa39306afc73 100644
--- a/drivers/media/platform/omap/omap_vout_vrfb.c
+++ b/drivers/media/platform/omap/omap_vout_vrfb.c
@@ -148,7 +148,7 @@ int omap_vout_setup_vrfb_bufs(struct platform_device *pdev, int vid_num,
 			ret =  -ENOMEM;
 			goto release_vrfb_ctx;
 		}
-		vout->vrfb_static_allocation = 1;
+		vout->vrfb_static_allocation = true;
 	}
 	return 0;
 
@@ -336,7 +336,7 @@ void omap_vout_calculate_vrfb_offset(struct omap_vout_device *vout)
 		offset = vout->vrfb_context[0].yoffset *
 			vout->vrfb_context[0].bytespp;
 		temp_ps = ps / vr_ps;
-		if (mirroring == 0) {
+		if (!mirroring) {
 			*cropped_offset = offset + line_length *
 				temp_ps * cleft + crop->top * temp_ps;
 		} else {
@@ -350,7 +350,7 @@ void omap_vout_calculate_vrfb_offset(struct omap_vout_device *vout)
 			vout->vrfb_context[0].bytespp) +
 			(vout->vrfb_context[0].xoffset *
 			vout->vrfb_context[0].bytespp));
-		if (mirroring == 0) {
+		if (!mirroring) {
 			*cropped_offset = offset + (line_length * ps * ctop) +
 				(cleft / vr_ps) * ps;
 
@@ -364,7 +364,7 @@ void omap_vout_calculate_vrfb_offset(struct omap_vout_device *vout)
 		offset = MAX_PIXELS_PER_LINE * vout->vrfb_context[0].xoffset *
 			vout->vrfb_context[0].bytespp;
 		temp_ps = ps / vr_ps;
-		if (mirroring == 0) {
+		if (!mirroring) {
 			*cropped_offset = offset + line_length *
 			    temp_ps * crop->left + ctop * ps;
 		} else {
@@ -375,7 +375,7 @@ void omap_vout_calculate_vrfb_offset(struct omap_vout_device *vout)
 		}
 		break;
 	case dss_rotation_0_degree:
-		if (mirroring == 0) {
+		if (!mirroring) {
 			*cropped_offset = (line_length * ps) *
 				crop->top + (crop->left / vr_ps) * ps;
 		} else {
-- 
1.9.3

