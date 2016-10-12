Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:63222 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754719AbcJLRRE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 13:17:04 -0400
Subject: [PATCH resent 03/34] [media] DaVinci-VPBE: Adjust 16 checks for null
 pointers
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <a99f89f2-a3be-9b5f-95c1-e0912a7d78f3@users.sourceforge.net>
 <fdf72877-08a9-1a86-aec8-627a378258da@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <ea25141d-b337-94c8-970b-1289b8dfdefb@users.sourceforge.net>
Date: Wed, 12 Oct 2016 19:15:49 +0200
MIME-Version: 1.0
In-Reply-To: <fdf72877-08a9-1a86-aec8-627a378258da@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 11 Oct 2016 13:37:10 +0200

The script "checkpatch.pl" pointed information out like the following.

Comparison to NULL could be written ...

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---

Another send try because of the following notification:

Mailer Daemon wrote on 2016-10-12 at 16:39:
> This message was created automatically by mail delivery software.
> 
> A message that you sent could not be delivered to one or more of
> its recipients. This is a permanent error. The following address(es)
> failed:
> 
> linux-kernel@vger.kernel.org:
> SMTP error from remote server for TEXT command, host: vger.kernel.org (209.132.180.67) reason: 550 5.7.1 Content-Policy reject msg: Wrong MIME labeling on 8-bit characte
> r texts. BF:<H 0>; S1755378AbcJLOjE
> 
> linux-media@vger.kernel.org:
> SMTP error from remote server for TEXT command, host: vger.kernel.org (209.132.180.67) reason: 550 5.7.1 Content-Policy reject msg: Wrong MIME labeling on 8-bit characte
> r texts. BF:<H 0>; S1755378AbcJLOjE
> 
> kernel-janitors@vger.kernel.org:
> SMTP error from remote server for TEXT command, host: vger.kernel.org (209.132.180.67) reason: 550 5.7.1 Content-Policy reject msg: Wrong MIME labeling on 8-bit characte
> r texts. BF:<H 0>; S1755378AbcJLOjE


 drivers/media/platform/davinci/vpbe.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index b479747..496b27f 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -107,7 +107,7 @@ static int vpbe_find_encoder_sd_index(struct vpbe_config *cfg,
 static int vpbe_g_cropcap(struct vpbe_device *vpbe_dev,
 			  struct v4l2_cropcap *cropcap)
 {
-	if (NULL == cropcap)
+	if (!cropcap)
 		return -EINVAL;
 	cropcap->bounds.left = 0;
 	cropcap->bounds.top = 0;
@@ -149,7 +149,7 @@ static int vpbe_get_mode_info(struct vpbe_device *vpbe_dev, char *mode,
 	int curr_output = output_index;
 	int i;
 
-	if (NULL == mode)
+	if (!mode)
 		return -EINVAL;
 
 	for (i = 0; i < cfg->outputs[curr_output].num_modes; i++) {
@@ -166,7 +166,7 @@ static int vpbe_get_mode_info(struct vpbe_device *vpbe_dev, char *mode,
 static int vpbe_get_current_mode_info(struct vpbe_device *vpbe_dev,
 				      struct vpbe_enc_mode_info *mode_info)
 {
-	if (NULL == mode_info)
+	if (!mode_info)
 		return -EINVAL;
 
 	*mode_info = vpbe_dev->current_timings;
@@ -356,7 +356,7 @@ static int vpbe_s_dv_timings(struct vpbe_device *vpbe_dev,
 
 	ret = v4l2_subdev_call(vpbe_dev->encoders[sd_index], video,
 					s_dv_timings, dv_timings);
-	if (!ret && (vpbe_dev->amp != NULL)) {
+	if (!ret && vpbe_dev->amp) {
 		/* Call amplifier subdevice */
 		ret = v4l2_subdev_call(vpbe_dev->amp, video,
 				s_dv_timings, dv_timings);
@@ -512,7 +512,7 @@ static int vpbe_set_mode(struct vpbe_device *vpbe_dev,
 	int ret = 0;
 	int i;
 
-	if ((NULL == mode_info) || (NULL == mode_info->name))
+	if (!mode_info || !mode_info->name)
 		return -EINVAL;
 
 	for (i = 0; i < cfg->outputs[out_index].num_modes; i++) {
@@ -536,7 +536,7 @@ static int vpbe_set_mode(struct vpbe_device *vpbe_dev,
 	}
 
 	/* Only custom timing should reach here */
-	if (preset_mode == NULL)
+	if (!preset_mode)
 		return -EINVAL;
 
 	mutex_lock(&vpbe_dev->lock);
@@ -570,9 +570,9 @@ static int platform_device_get(struct device *dev, void *data)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct vpbe_device *vpbe_dev = data;
 
-	if (strstr(pdev->name, "vpbe-osd") != NULL)
+	if (strstr(pdev->name, "vpbe-osd"))
 		vpbe_dev->osd_device = platform_get_drvdata(pdev);
-	if (strstr(pdev->name, "vpbe-venc") != NULL)
+	if (strstr(pdev->name, "vpbe-venc"))
 		vpbe_dev->venc_device = dev_get_platdata(&pdev->dev);
 
 	return 0;
@@ -606,7 +606,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 	 * from the platform device by iteration of platform drivers and
 	 * matching with device name
 	 */
-	if (NULL == vpbe_dev || NULL == dev) {
+	if (!vpbe_dev || !dev) {
 		printk(KERN_ERR "Null device pointers.\n");
 		return -ENODEV;
 	}
@@ -652,7 +652,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 	vpbe_dev->venc = venc_sub_dev_init(&vpbe_dev->v4l2_dev,
 					   vpbe_dev->cfg->venc.module_name);
 	/* register venc sub device */
-	if (vpbe_dev->venc == NULL) {
+	if (!vpbe_dev->venc) {
 		v4l2_err(&vpbe_dev->v4l2_dev,
 			"vpbe unable to init venc sub device\n");
 		ret = -ENODEV;
@@ -660,8 +660,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 	}
 	/* initialize osd device */
 	osd_device = vpbe_dev->osd_device;
-
-	if (NULL != osd_device->ops.initialize) {
+	if (osd_device->ops.initialize) {
 		err = osd_device->ops.initialize(osd_device);
 		if (err) {
 			v4l2_err(&vpbe_dev->v4l2_dev,
@@ -679,7 +678,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 	vpbe_dev->encoders = kmalloc_array(num_encoders,
 					   sizeof(*vpbe_dev->encoders),
 					   GFP_KERNEL);
-	if (NULL == vpbe_dev->encoders) {
+	if (!vpbe_dev->encoders) {
 		ret = -ENOMEM;
 		goto fail_dev_unregister;
 	}
@@ -715,7 +714,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 	}
 	/* Add amplifier subdevice for dm365 */
 	if ((strcmp(vpbe_dev->cfg->module_name, "dm365-vpbe-display") == 0) &&
-			vpbe_dev->cfg->amp != NULL) {
+	   vpbe_dev->cfg->amp) {
 		amp_info = vpbe_dev->cfg->amp;
 		if (amp_info->is_i2c) {
 			vpbe_dev->amp = v4l2_i2c_new_subdev_board(
@@ -824,7 +823,7 @@ static int vpbe_probe(struct platform_device *pdev)
 	struct vpbe_config *cfg;
 	int ret = -EINVAL;
 
-	if (pdev->dev.platform_data == NULL) {
+	if (!pdev->dev.platform_data) {
 		v4l2_err(pdev->dev.driver, "No platform data\n");
 		return -ENODEV;
 	}
-- 
2.10.1

