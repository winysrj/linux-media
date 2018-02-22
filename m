Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:41095 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752712AbeBVITd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 03:19:33 -0500
Received: by mail-wr0-f195.google.com with SMTP id f14so9583238wre.8
        for <linux-media@vger.kernel.org>; Thu, 22 Feb 2018 00:19:32 -0800 (PST)
From: Corentin Labbe <clabbe@baylibre.com>
To: gregkh@linuxfoundation.org, mchehab@kernel.org,
        sakari.ailus@linux.intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] staging: media: atomisp: Remove inclusion of non-existing directories
Date: Thu, 22 Feb 2018 08:19:25 +0000
Message-Id: <1519287565-28485-1-git-send-email-clabbe@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fix the following build warnings:
  CC [M]  drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.o
cc1: warning: drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bayer_ls/bayer_ls_1.0/: No such file or directory [-Wmissing-include-dirs]
cc1: warning: drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/io_ls/plane_io_ls/: No such file or directory [-Wmissing-include-dirs]
cc1: warning: drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/io_ls/yuv420_io_ls/: No such file or directory [-Wmissing-include-dirs]
cc1: warning: drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/ipu2_io_ls/plane_io_ls/: No such file or directory [-Wmissing-include-dirs]
cc1: warning: drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/ipu2_io_ls/yuv420_io_ls/: No such file or directory [-Wmissing-include-dirs]
cc1: warning: drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/s3a_stat_ls/: No such file or directory [-Wmissing-include-dirs]
cc1: warning: drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/scale/: No such file or directory [-Wmissing-include-dirs]
cc1: warning: drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/scale/scale_1.0/: No such file or directory [-Wmissing-include-dirs]
cc1: warning: drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/yuv_ls: No such file or directory [-Wmissing-include-dirs]
cc1: warning: drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/yuv_ls/yuv_ls_1.0/: No such file or directory [-Wmissing-include-dirs]
by removing the inclusion of such directories

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/staging/media/atomisp/pci/atomisp2/Makefile | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/Makefile b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
index ac3805345f20..83f816faba1b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/Makefile
+++ b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
@@ -215,7 +215,6 @@ INCLUDES += \
 	-I$(atomisp)/css2400/isp/kernels/aa/aa_2/ \
 	-I$(atomisp)/css2400/isp/kernels/anr/anr_1.0/ \
 	-I$(atomisp)/css2400/isp/kernels/anr/anr_2/ \
-	-I$(atomisp)/css2400/isp/kernels/bayer_ls/bayer_ls_1.0/ \
 	-I$(atomisp)/css2400/isp/kernels/bh/bh_2/ \
 	-I$(atomisp)/css2400/isp/kernels/bnlm/ \
 	-I$(atomisp)/css2400/isp/kernels/bnr/ \
@@ -258,14 +257,10 @@ INCLUDES += \
 	-I$(atomisp)/css2400/isp/kernels/io_ls/ \
 	-I$(atomisp)/css2400/isp/kernels/io_ls/bayer_io_ls/ \
 	-I$(atomisp)/css2400/isp/kernels/io_ls/common/ \
-	-I$(atomisp)/css2400/isp/kernels/io_ls/plane_io_ls/ \
-	-I$(atomisp)/css2400/isp/kernels/io_ls/yuv420_io_ls/ \
 	-I$(atomisp)/css2400/isp/kernels/io_ls/yuv444_io_ls/ \
 	-I$(atomisp)/css2400/isp/kernels/ipu2_io_ls/ \
 	-I$(atomisp)/css2400/isp/kernels/ipu2_io_ls/bayer_io_ls/ \
 	-I$(atomisp)/css2400/isp/kernels/ipu2_io_ls/common/ \
-	-I$(atomisp)/css2400/isp/kernels/ipu2_io_ls/plane_io_ls/ \
-	-I$(atomisp)/css2400/isp/kernels/ipu2_io_ls/yuv420_io_ls/ \
 	-I$(atomisp)/css2400/isp/kernels/ipu2_io_ls/yuv444_io_ls/ \
 	-I$(atomisp)/css2400/isp/kernels/iterator/ \
 	-I$(atomisp)/css2400/isp/kernels/iterator/iterator_1.0/ \
@@ -289,9 +284,6 @@ INCLUDES += \
 	-I$(atomisp)/css2400/isp/kernels/ref/ref_1.0/ \
 	-I$(atomisp)/css2400/isp/kernels/s3a/ \
 	-I$(atomisp)/css2400/isp/kernels/s3a/s3a_1.0/ \
-	-I$(atomisp)/css2400/isp/kernels/s3a_stat_ls/ \
-	-I$(atomisp)/css2400/isp/kernels/scale/ \
-	-I$(atomisp)/css2400/isp/kernels/scale/scale_1.0/ \
 	-I$(atomisp)/css2400/isp/kernels/sc/ \
 	-I$(atomisp)/css2400/isp/kernels/sc/sc_1.0/ \
 	-I$(atomisp)/css2400/isp/kernels/sdis/ \
@@ -315,8 +307,6 @@ INCLUDES += \
 	-I$(atomisp)/css2400/isp/kernels/ynr/ \
 	-I$(atomisp)/css2400/isp/kernels/ynr/ynr_1.0/ \
 	-I$(atomisp)/css2400/isp/kernels/ynr/ynr_2/ \
-	-I$(atomisp)/css2400/isp/kernels/yuv_ls \
-	-I$(atomisp)/css2400/isp/kernels/yuv_ls/yuv_ls_1.0/ \
 	-I$(atomisp)/css2400/isp/modes/interface/ \
 	-I$(atomisp)/css2400/runtime/binary/interface/ \
 	-I$(atomisp)/css2400/runtime/bufq/interface/ \
-- 
2.16.1
