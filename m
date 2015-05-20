Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:56267 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754455AbbEUJCt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 05:02:49 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com,
	hverkuil@xs4all.nl, rob.taylor@codethink.co.uk
Subject: [PATCH 20/20] media: soc_camera: Add debugging for get_formats
Date: Wed, 20 May 2015 17:39:40 +0100
Message-Id: <1432139980-12619-21-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Rob Taylor <rob.taylor@codethink.co.uk>

Some helpful debugging for get_formats use, useful for debugging
v4l2-compliance issues.

Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
Reviewed-by: William Towle <william.towle@codethink.co.uk>
---
 drivers/media/platform/soc_camera/soc_camera.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 583c5e6..503e9b6 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -522,7 +522,7 @@ static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 
 	/* Second pass - actually fill data formats */
 	fmts = 0;
-	for (i = 0; i < raw_fmts; i++)
+	for (i = 0; i < raw_fmts; i++) {
 		if (!ici->ops->get_formats) {
 			code.index = i;
 			v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code);
@@ -537,6 +537,8 @@ static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 				goto egfmt;
 			fmts += ret;
 		}
+		dev_dbg(icd->pdev, " Format: %x %c%c%c%c", icd->user_formats[fmts-1].code, pixfmtstr(icd->user_formats[fmts-1].host_fmt->fourcc));
+	}
 
 	icd->num_user_formats = fmts;
 	icd->current_fmt = &icd->user_formats[0];
@@ -732,6 +734,8 @@ static int soc_camera_open(struct file *file)
 		 * apart from someone else calling open() simultaneously, but
 		 * .host_lock is protecting us against it.
 		 */
+
+		dev_dbg(icd->pdev, "%s:%d calling set_fmt with size %d x %d",__func__, __LINE__, f.fmt.pix.width, f.fmt.pix.height);
 		ret = soc_camera_set_fmt(icd, &f);
 		if (ret < 0)
 			goto esfmt;
@@ -2234,6 +2238,7 @@ static int soc_camera_pdrv_probe(struct platform_device *pdev)
 	icd->user_width		= DEFAULT_WIDTH;
 	icd->user_height	= DEFAULT_HEIGHT;
 
+	dev_dbg(icd->pdev, "%s:%d setting default user size to %d x %d",__func__, __LINE__, icd->user_width, icd->user_height);
 	return soc_camera_device_register(icd);
 }
 
-- 
1.7.10.4

