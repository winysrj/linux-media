Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:42626 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753873AbeDLPYa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 11:24:30 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeremy Sowden <jeremy@azazel.net>, devel@driverdev.osuosl.org
Subject: [PATCH 01/17] media: staging: atomisp: fix number conversion
Date: Thu, 12 Apr 2018 11:23:53 -0400
Message-Id: <d20ab7176b2af82d6b679211edb5f151629d4033.1523546545.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

smatch says that there's an issue with number
conversion:

   drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c:4154 sh_css_params_write_to_ddr_internal() warn: '((-(1 << ((14 - 1)))))' 4294959104 can't fit into 32767 'converted_macc_table.data[idx]'
   drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c:4157 sh_css_params_write_to_ddr_internal() warn: '((-(1 << ((14 - 1)))))' 4294959104 can't fit into 32767 'converted_macc_table.data[idx + 1]'
   drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c:4160 sh_css_params_write_to_ddr_internal() warn: '((-(1 << ((14 - 1)))))' 4294959104 can't fit into 32767 'converted_macc_table.data[idx + 2]'
   drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_params.c:4163 sh_css_params_write_to_ddr_internal() warn: '((-(1 << ((14 - 1)))))' 4294959104 can't fit into 32767 'converted_macc_table.data[idx + 3]'
   drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8.host.c:168 ia_css_eed1_8_vmem_encode() warn: assigning (-8192) to unsigned variable 'to->e_dew_enh_a[0][base + j]'

That's probably because min() and max() definition used there
are really poor ones. So, replace by the in-kernel macro.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../css2400/isp/kernels/eed1_8/ia_css_eed1_8.host.c      | 16 ++++++++++++----
 .../media/atomisp/pci/atomisp2/css2400/sh_css_frac.h     |  2 +-
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8.host.c
index 47bb5042381b..8f2178bf9e68 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8.host.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8.host.c
@@ -160,17 +160,25 @@ ia_css_eed1_8_vmem_encode(
 		base = shuffle_block * i;
 
 		for (j = 0; j < IA_CSS_NUMBER_OF_DEW_ENHANCE_SEGMENTS; j++) {
-			to->e_dew_enh_x[0][base + j] = min(max(from->dew_enhance_seg_x[j], 0), 8191);
-			to->e_dew_enh_y[0][base + j] = min(max(from->dew_enhance_seg_y[j], -8192), 8191);
+			to->e_dew_enh_x[0][base + j] = min_t(int, max_t(int,
+									from->dew_enhance_seg_x[j], 0),
+									8191);
+			to->e_dew_enh_y[0][base + j] = min_t(int, max_t(int,
+									from->dew_enhance_seg_y[j], -8192),
+									8191);
 		}
 
 		for (j = 0; j < (IA_CSS_NUMBER_OF_DEW_ENHANCE_SEGMENTS - 1); j++) {
-			to->e_dew_enh_a[0][base + j] = min(max(from->dew_enhance_seg_slope[j], -8192), 8191);
+			to->e_dew_enh_a[0][base + j] = min_t(int, max_t(int,
+									from->dew_enhance_seg_slope[j],
+								        -8192), 8191);
 			/* Convert dew_enhance_seg_exp to flag:
 			 * 0 -> 0
 			 * 1...13 -> 1
 			 */
-			to->e_dew_enh_f[0][base + j] = (min(max(from->dew_enhance_seg_exp[j], 0), 13) > 0);
+			to->e_dew_enh_f[0][base + j] = (min_t(int, max_t(int,
+									 from->dew_enhance_seg_exp[j],
+									 0), 13) > 0);
 		}
 
 		/* Hard-coded to 0, in order to be able to handle out of
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_frac.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_frac.h
index 1d1771d71f3c..90a63b3921e6 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_frac.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_frac.h
@@ -30,7 +30,7 @@
 
 /* a:fraction bits for 16bit precision, b:fraction bits for ISP precision */
 #define sDIGIT_FITTING(v, a, b) \
-	min(max((((v)>>sSHIFT) >> max(sFRACTION_BITS_FITTING(a)-(b), 0)), \
+	min_t(int, max_t(int, (((v)>>sSHIFT) >> max(sFRACTION_BITS_FITTING(a)-(b), 0)), \
 	  sISP_VAL_MIN), sISP_VAL_MAX)
 #define uDIGIT_FITTING(v, a, b) \
 	min((unsigned)max((unsigned)(((v)>>uSHIFT) \
-- 
2.14.3
