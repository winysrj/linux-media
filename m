Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:52953 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933243AbcJLO7x (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 10:59:53 -0400
Subject: [PATCH 21/34] [media] DaVinci-VPFE-Capture: Delete an unnecessary
 variable initialisation in 11 functions
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <a1904a63-329c-45e9-2c65-5d8d6b6be41c@users.sourceforge.net>
Date: Wed, 12 Oct 2016 16:59:43 +0200
MIME-Version: 1.0
In-Reply-To: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 12 Oct 2016 10:50:54 +0200

The local variable "ret" will be set to an appropriate value a bit later.
Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/davinci/vpfe_capture.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 9da353b..ba71310 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -384,7 +384,7 @@ static int vpfe_config_image_format(struct vpfe_device *vpfe_dev,
 	};
 	struct v4l2_mbus_framefmt *mbus_fmt = &fmt.format;
 	struct v4l2_pix_format *pix = &vpfe_dev->fmt.fmt.pix;
-	int i, ret = 0;
+	int i, ret;
 
 	for (i = 0; i < ARRAY_SIZE(vpfe_standards); i++) {
 		if (vpfe_standards[i].std_id & std_id) {
@@ -453,7 +453,7 @@ static int vpfe_config_image_format(struct vpfe_device *vpfe_dev,
 
 static int vpfe_initialize_device(struct vpfe_device *vpfe_dev)
 {
-	int ret = 0;
+	int ret;
 
 	/* set first input of current subdevice as the current input */
 	vpfe_dev->current_input = 0;
@@ -979,7 +979,7 @@ static int vpfe_s_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct vpfe_device *vpfe_dev = video_drvdata(file);
 	const struct vpfe_pixel_format *pix_fmts;
-	int ret = 0;
+	int ret;
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_fmt_vid_cap\n");
 
@@ -1112,7 +1112,7 @@ static int vpfe_s_input(struct file *file, void *priv, unsigned int index)
 	int subdev_index, inp_index;
 	struct vpfe_route *route;
 	u32 input = 0, output = 0;
-	int ret = -EINVAL;
+	int ret;
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_input\n");
 
@@ -1178,7 +1178,7 @@ static int vpfe_querystd(struct file *file, void *priv, v4l2_std_id *std_id)
 {
 	struct vpfe_device *vpfe_dev = video_drvdata(file);
 	struct vpfe_subdev_info *sdinfo;
-	int ret = 0;
+	int ret;
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_querystd\n");
 
@@ -1197,7 +1197,7 @@ static int vpfe_s_std(struct file *file, void *priv, v4l2_std_id std_id)
 {
 	struct vpfe_device *vpfe_dev = video_drvdata(file);
 	struct vpfe_subdev_info *sdinfo;
-	int ret = 0;
+	int ret;
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_std\n");
 
@@ -1346,7 +1346,7 @@ static int vpfe_reqbufs(struct file *file, void *priv,
 {
 	struct vpfe_device *vpfe_dev = video_drvdata(file);
 	struct vpfe_fh *fh = file->private_data;
-	int ret = 0;
+	int ret;
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_reqbufs\n");
 
@@ -1478,7 +1478,7 @@ static int vpfe_streamon(struct file *file, void *priv,
 	struct vpfe_fh *fh = file->private_data;
 	struct vpfe_subdev_info *sdinfo;
 	unsigned long addr;
-	int ret = 0;
+	int ret;
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_streamon\n");
 
@@ -1561,7 +1561,7 @@ static int vpfe_streamoff(struct file *file, void *priv,
 	struct vpfe_device *vpfe_dev = video_drvdata(file);
 	struct vpfe_fh *fh = file->private_data;
 	struct vpfe_subdev_info *sdinfo;
-	int ret = 0;
+	int ret;
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_streamoff\n");
 
@@ -1647,7 +1647,7 @@ static int vpfe_s_selection(struct file *file, void *priv,
 {
 	struct vpfe_device *vpfe_dev = video_drvdata(file);
 	struct v4l2_rect rect = sel->r;
-	int ret = 0;
+	int ret;
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_s_selection\n");
 
@@ -1705,7 +1705,7 @@ static long vpfe_param_handler(struct file *file, void *priv,
 		bool valid_prio, unsigned int cmd, void *param)
 {
 	struct vpfe_device *vpfe_dev = video_drvdata(file);
-	int ret = 0;
+	int ret;
 
 	v4l2_dbg(2, debug, &vpfe_dev->v4l2_dev, "vpfe_param_handler\n");
 
-- 
2.10.1

