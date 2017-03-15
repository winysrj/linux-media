Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34855 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751878AbdCOF7h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 01:59:37 -0400
Date: Wed, 15 Mar 2017 14:55:29 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, daeseok.youn@gmail.com,
        alan@linux.intel.com, dan.carpenter@oracle.com,
        singhalsimran0@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 2/4] staging: atomisp: fix inconsistent indenting
Message-ID: <20170315055529.GA8583@SEL-JYOUN-D1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix warnings from the smatch tool

atomisp_cmd.c:5698
   atomisp_set_fmt_to_snr() warn: inconsistent indenting
atomisp_cmd.c:5714
   atomisp_set_fmt_to_snr() warn: inconsistent indenting

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index 9c3ba11..6160119 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -5693,7 +5693,7 @@ static int atomisp_set_fmt_to_snr(struct video_device *vdev,
 	/* Disable dvs if resolution can't be supported by sensor */
 	if (asd->params.video_dis_en &&
 	    source_pad == ATOMISP_SUBDEV_PAD_SOURCE_VIDEO) {
-	    vformat.which = V4L2_SUBDEV_FORMAT_TRY;
+		vformat.which = V4L2_SUBDEV_FORMAT_TRY;
 		ret = v4l2_subdev_call(isp->inputs[asd->input_curr].camera,
 			pad, set_fmt, &pad_cfg, &vformat);
 		if (ret)
@@ -5710,7 +5710,7 @@ static int atomisp_set_fmt_to_snr(struct video_device *vdev,
 	}
 	dev_dbg(isp->dev, "sensor width: %d, height: %d\n",
 		ffmt->width, ffmt->height);
-    vformat.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	vformat.which = V4L2_SUBDEV_FORMAT_ACTIVE;
 	ret = v4l2_subdev_call(isp->inputs[asd->input_curr].camera, pad,
 			       set_fmt, NULL, &vformat);
 	if (ret)
-- 
1.9.1
