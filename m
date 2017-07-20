Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:37446 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934876AbdGTMCT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 08:02:19 -0400
Received: by mail-wm0-f65.google.com with SMTP id m4so3283105wmi.4
        for <linux-media@vger.kernel.org>; Thu, 20 Jul 2017 05:02:18 -0700 (PDT)
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Sekhar Nori <nsekhar@ti.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [v4] media: platform: davinci: return -EINVAL for VPFE_CMD_S_CCDC_RAW_PARAMS ioctl
Date: Thu, 20 Jul 2017 13:02:09 +0100
Message-Id: <1500552129-422-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

this patch makes sure VPFE_CMD_S_CCDC_RAW_PARAMS ioctl no longer works
for vpfe_capture driver with a minimal patch suitable for backporting.

- This ioctl was never in public api and was only defined in kernel header.
- The function set_params constantly mixes up pointers and phys_addr_t
  numbers.
- This is part of a 'VPFE_CMD_S_CCDC_RAW_PARAMS' ioctl command that is
  described as an 'experimental ioctl that will change in future kernels'.
- The code to allocate the table never gets called after we copy_from_user
  the user input over the kernel settings, and then compare them
  for inequality.
- We then go on to use an address provided by user space as both the
  __user pointer for input and pass it through phys_to_virt to come up
  with a kernel pointer to copy the data to. This looks like a trivially
  exploitable root hole.

Due to these reasons we make sure this ioctl now returns -EINVAL and backport
this patch as far as possible.

Fixes: 5f15fbb68fd7 ("V4L/DVB (12251): v4l: dm644x ccdc module for vpfe capture driver")
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpfe_capture.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index e3fe3e0..1831bf5 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -1719,27 +1719,9 @@ static long vpfe_param_handler(struct file *file, void *priv,
 
 	switch (cmd) {
 	case VPFE_CMD_S_CCDC_RAW_PARAMS:
+		ret = -EINVAL;
 		v4l2_warn(&vpfe_dev->v4l2_dev,
-			  "VPFE_CMD_S_CCDC_RAW_PARAMS: experimental ioctl\n");
-		if (ccdc_dev->hw_ops.set_params) {
-			ret = ccdc_dev->hw_ops.set_params(param);
-			if (ret) {
-				v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
-					"Error setting parameters in CCDC\n");
-				goto unlock_out;
-			}
-			ret = vpfe_get_ccdc_image_format(vpfe_dev,
-							 &vpfe_dev->fmt);
-			if (ret < 0) {
-				v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
-					"Invalid image format at CCDC\n");
-				goto unlock_out;
-			}
-		} else {
-			ret = -EINVAL;
-			v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
-				"VPFE_CMD_S_CCDC_RAW_PARAMS not supported\n");
-		}
+			"VPFE_CMD_S_CCDC_RAW_PARAMS not supported\n");
 		break;
 	default:
 		ret = -ENOTTY;
-- 
2.7.4
