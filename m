Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46868 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751838AbeEWF1c (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 01:27:32 -0400
From: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
To: alan@linux.intel.com, sakari.ailus@linux.intel.com,
        mchehab@kernel.org, gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] media: staging: atomisp: Remove useless "ifndef ISP2401"
Date: Wed, 23 May 2018 10:51:33 +0530
Message-Id: <1527052896-30777-4-git-send-email-pankaj.laxminarayan.bharadiya@intel.com>
In-Reply-To: <1527052896-30777-1-git-send-email-pankaj.laxminarayan.bharadiya@intel.com>
References: <1527052896-30777-1-git-send-email-pankaj.laxminarayan.bharadiya@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In atomisp_csi2_set_ffmt(), there is no reason to have
"#ifndef ISP2401" condition since code is identical in ifndef and
else sections. Hence remove redudent checks.

Signed-off-by: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_csi2.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_csi2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_csi2.c
index fa03b78..606ebdb 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_csi2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_csi2.c
@@ -90,11 +90,7 @@ int atomisp_csi2_set_ffmt(struct v4l2_subdev *sd,
 {
 	struct atomisp_mipi_csi2_device *csi2 = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *actual_ffmt =
-#ifndef ISP2401
 		__csi2_get_format(csi2, cfg, which, pad);
-#else
-	    __csi2_get_format(csi2, cfg, which, pad);
-#endif
 
 	if (pad == CSI2_PAD_SINK) {
 		const struct atomisp_in_fmt_conv *ic;
@@ -121,11 +117,7 @@ int atomisp_csi2_set_ffmt(struct v4l2_subdev *sd,
 
 	/* FIXME: DPCM decompression */
 	*actual_ffmt = *ffmt =
-#ifndef ISP2401
 		*__csi2_get_format(csi2, cfg, which, CSI2_PAD_SINK);
-#else
-	    *__csi2_get_format(csi2, cfg, which, CSI2_PAD_SINK);
-#endif
 
 	return 0;
 }
-- 
2.7.4
