Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:61772 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755147AbcJLO6t (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 10:58:49 -0400
Subject: [PATCH 20/34] [media] DaVinci-VPFE-Capture: Adjust 13 checks for null
 pointers
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <111cbf0f-7fe6-63e7-6577-0724f3789226@users.sourceforge.net>
Date: Wed, 12 Oct 2016 16:58:39 +0200
MIME-Version: 1.0
In-Reply-To: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 12 Oct 2016 10:46:28 +0200

Convert comparisons with the preprocessor symbol "NULL" to condition checks
without it.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/davinci/vpfe_capture.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index e370400..9da353b 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -229,7 +229,7 @@ int vpfe_register_ccdc_device(struct ccdc_hw_device *dev)
 	BUG_ON(!dev->hw_ops.getfid);
 
 	mutex_lock(&ccdc_lock);
-	if (NULL == ccdc_cfg) {
+	if (!ccdc_cfg) {
 		/*
 		 * TODO. Will this ever happen? if so, we need to fix it.
 		 * Proabably we need to add the request to a linked list and
@@ -265,7 +265,7 @@ EXPORT_SYMBOL(vpfe_register_ccdc_device);
  */
 void vpfe_unregister_ccdc_device(struct ccdc_hw_device *dev)
 {
-	if (NULL == dev) {
+	if (!dev) {
 		printk(KERN_ERR "invalid ccdc device ptr\n");
 		return;
 	}
@@ -469,7 +469,7 @@ static int vpfe_initialize_device(struct vpfe_device *vpfe_dev)
 
 	/* now open the ccdc device to initialize it */
 	mutex_lock(&ccdc_lock);
-	if (NULL == ccdc_dev) {
+	if (!ccdc_dev) {
 		v4l2_err(&vpfe_dev->v4l2_dev, "ccdc device not registered\n");
 		ret = -ENODEV;
 		goto unlock;
@@ -582,7 +582,7 @@ static irqreturn_t vpfe_isr(int irq, void *dev_id)
 		goto clear_intr;
 
 	/* only for 6446 this will be applicable */
-	if (NULL != ccdc_dev->hw_ops.reset)
+	if (ccdc_dev->hw_ops.reset)
 		ccdc_dev->hw_ops.reset();
 
 	if (field == V4L2_FIELD_NONE) {
@@ -822,7 +822,7 @@ static const struct vpfe_pixel_format *
 	int temp, found;
 
 	vpfe_pix_fmt = vpfe_lookup_pix_format(pixfmt->pixelformat);
-	if (NULL == vpfe_pix_fmt) {
+	if (!vpfe_pix_fmt) {
 		/*
 		 * use current pixel format in the vpfe device. We
 		 * will find this pix format in the table
@@ -965,7 +965,7 @@ static int vpfe_enum_fmt_vid_cap(struct file *file, void  *priv,
 
 	/* Fill in the information about format */
 	pix_fmt = vpfe_lookup_pix_format(pix);
-	if (NULL != pix_fmt) {
+	if (pix_fmt) {
 		temp_index = fmt->index;
 		*fmt = pix_fmt->fmtdesc;
 		fmt->index = temp_index;
@@ -991,8 +991,7 @@ static int vpfe_s_fmt_vid_cap(struct file *file, void *priv,
 
 	/* Check for valid frame format */
 	pix_fmts = vpfe_check_format(vpfe_dev, &fmt->fmt.pix);
-
-	if (NULL == pix_fmts)
+	if (!pix_fmts)
 		return -EINVAL;
 
 	/* store the pixel format in the device  object */
@@ -1018,7 +1017,7 @@ static int vpfe_try_fmt_vid_cap(struct file *file, void *priv,
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_try_fmt_vid_cap\n");
 
 	pix_fmts = vpfe_check_format(vpfe_dev, &f->fmt.pix);
-	if (NULL == pix_fmts)
+	if (!pix_fmts)
 		return -EINVAL;
 	return 0;
 }
@@ -1833,7 +1832,7 @@ static int vpfe_probe(struct platform_device *pdev)
 
 	vpfe_dev->pdev = &pdev->dev;
 
-	if (NULL == pdev->dev.platform_data) {
+	if (!pdev->dev.platform_data) {
 		v4l2_err(pdev->dev.driver, "Unable to get vpfe config\n");
 		ret = -ENODEV;
 		goto probe_free_dev_mem;
@@ -1841,9 +1840,7 @@ static int vpfe_probe(struct platform_device *pdev)
 
 	vpfe_cfg = pdev->dev.platform_data;
 	vpfe_dev->cfg = vpfe_cfg;
-	if (NULL == vpfe_cfg->ccdc ||
-	    NULL == vpfe_cfg->card_name ||
-	    NULL == vpfe_cfg->sub_devs) {
+	if (!vpfe_cfg->ccdc || !vpfe_cfg->card_name || !vpfe_cfg->sub_devs) {
 		v4l2_err(pdev->dev.driver, "null ptr in vpfe_cfg\n");
 		ret = -ENOENT;
 		goto probe_free_dev_mem;
@@ -1938,7 +1935,7 @@ static int vpfe_probe(struct platform_device *pdev)
 	vpfe_dev->sd = kmalloc_array(num_subdevs,
 				     sizeof(*vpfe_dev->sd),
 				     GFP_KERNEL);
-	if (NULL == vpfe_dev->sd) {
+	if (!vpfe_dev->sd) {
 		ret = -ENOMEM;
 		goto probe_out_video_unregister;
 	}
-- 
2.10.1

