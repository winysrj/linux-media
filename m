Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46623 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133AbZEDLAv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2009 07:00:51 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "xlzhang76@gmail.com" <xlzhang76@gmail.com>
Date: Mon, 4 May 2009 19:00:24 +0800
Subject: [PATCH 1/5 - part 2] V4L2 patches for Intel Moorestown Camera
 Imaging Drivers
Message-ID: <0A882F4D99BBF6449D58E61AAFD7EDD613810F55@pdsmsx502.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From c9523cb1e81f6229c47c244896fd5772a7e9e702 Mon Sep 17 00:00:00 2001
From: Xiaolin Zhang <xiaolin.zhang@intel.com>
Date: Mon, 4 May 2009 16:54:56 +0800
Subject: [PATCH] [Part 2] c files - camera imaging ISP driver on Intel Moorestown platform
 under v4l2 driver framework.

Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
---
 drivers/media/video/mrstci/include/ci_isp_common.h |   58 +-
 drivers/media/video/mrstci/mrstisp/Makefile        |    9 +
 drivers/media/video/mrstci/mrstisp/intel_v4l2.c    | 1965 ++++++++++++++++++++
 drivers/media/video/mrstci/mrstisp/mrv.c           |  442 +++++
 drivers/media/video/mrstci/mrstisp/mrv_col.c       |   66 +
 drivers/media/video/mrstci/mrstisp/mrv_ie.c        |  237 +++
 drivers/media/video/mrstci/mrstisp/mrv_is.c        |   66 +
 drivers/media/video/mrstci/mrstisp/mrv_isp.c       | 1433 ++++++++++++++
 drivers/media/video/mrstci/mrstisp/mrv_isp_bls.c   |  174 ++
 drivers/media/video/mrstci/mrstisp/mrv_isp_gamma.c |   87 +
 drivers/media/video/mrstci/mrstisp/mrv_jpe.c       |  447 +++++
 drivers/media/video/mrstci/mrstisp/mrv_mif.c       |  677 +++++++
 drivers/media/video/mrstci/mrstisp/mrv_res.c       |  350 ++++
 drivers/media/video/mrstci/mrstisp/mrv_sls_bp.c    |   83 +
 drivers/media/video/mrstci/mrstisp/mrv_sls_dp.c    | 1146 ++++++++++++
 drivers/media/video/mrstci/mrstisp/mrv_sls_jpe.c   |   53 +
 16 files changed, 7237 insertions(+), 56 deletions(-)
 mode change 100755 => 100644 drivers/media/video/mrstci/mrstisp/Kconfig
 create mode 100644 drivers/media/video/mrstci/mrstisp/Makefile
 create mode 100644 drivers/media/video/mrstci/mrstisp/intel_v4l2.c
 create mode 100644 drivers/media/video/mrstci/mrstisp/mrv.c
 create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_col.c
 create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_ie.c
 create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_is.c
 create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_isp.c
 create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_isp_bls.c
 create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_isp_gamma.c
 create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_jpe.c
 create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_mif.c
 create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_res.c
 create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_sls_bp.c
 create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_sls_dp.c
 create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_sls_jpe.c

diff --git a/drivers/media/video/mrstci/include/ci_isp_common.h b/drivers/media/video/mrstci/include/ci_isp_common.h
index 090021d..121100b 100644
--- a/drivers/media/video/mrstci/include/ci_isp_common.h
+++ b/drivers/media/video/mrstci/include/ci_isp_common.h
@@ -63,10 +63,6 @@
 /* JPEG encoding */

 enum ci_isp_jpe_enc_mode {
-#if (MARVIN_FEATURE_JPE_CFG == MARVIN_FEATURE_JPE_CFG_V2)
-       /*single snapshot with Scalado encoding*/
-       CI_ISP_JPE_SCALADO_MODE = 0x08,
-#endif
        /* motion JPEG with header generation */
        CI_ISP_JPE_LARGE_CONT_MODE = 0x04,
        /* motion JPEG only first frame with header */
@@ -106,14 +102,9 @@ struct ci_isp_rsz_lut{
        u8 rsz_lut[64];
 };

-#if (MARVIN_FEATURE_SCALE_FACTORWIDTH == MARVIN_FEATURE_16BITS)
-/* flag to set in scalefactor values to enable upscaling */
-#define RSZ_UPSCALE_ENABLE 0x20000
-#else
 /* flag to set in scalefactor values to enable upscaling */
 #define RSZ_UPSCALE_ENABLE 0x8000
-/* #if (MARVIN_FEATURE_SCALE_FACTORWIDTH == MARVIN_FEATURE_16BITS) */
-#endif
+

 /*
  * Flag to set in scalefactor values to bypass the scaler block.
@@ -122,13 +113,8 @@ struct ci_isp_rsz_lut{
  * words:
  * RSZ_SCALER_BYPASS = max. scalefactor value> + 1
  */
-#if (MARVIN_FEATURE_SCALE_FACTORWIDTH == MARVIN_FEATURE_12BITS)
-#define RSZ_SCALER_BYPASS  0x1000
-#elif (MARVIN_FEATURE_SCALE_FACTORWIDTH == MARVIN_FEATURE_14BITS)
 #define RSZ_SCALER_BYPASS  0x4000
-#elif (MARVIN_FEATURE_SCALE_FACTORWIDTH == MARVIN_FEATURE_16BITS)
-#define RSZ_SCALER_BYPASS  0x10000
-#endif
+

 #define RSZ_FLAGS_MASK (RSZ_UPSCALE_ENABLE | RSZ_SCALER_BYPASS)

@@ -1124,46 +1110,6 @@ struct ci_isp_cac_config {

 };

-/*
- * register values of chromatic aberration correction block (delivered by
- * the CAC driver)
- */
-struct ci_isp_cac_reg_values {
-       /* maximum red/blue pixel shift in horizontal */
-       u8 hclip_mode;
-       /* and vertival direction, range 0..2 */
-       u8 vclip_mode;
-       /* TRUE=enabled, FALSE=disabled */
-       int cac_enabled;
-       /*
-        * preload value of the horizontal CAC pixel
-        * counter, range 1..4095
-        */
-       u16 hcount_start;
-       /*
-        * preload value of the vertical CAC pixel
-        * counter, range 1..4095
-        */
-       u16 vcount_start;
-       /* parameters for radial shift calculation, */
-       u16 ablue;
-       /* 9 bit twos complement with 4 fractional */
-       u16 ared;
-       /* digits, valid range -16..15.9375 */
-       u16 bblue;
-       u16 bred;
-       u16 cblue;
-       u16 cred;
-       /* horizontal normalization shift, range 0..7 */
-       u8 xnorm_shift;
-       /* horizontal normalization factor, range 16..31 */
-       u8 xnorm_factor;
-       /* vertical normalization shift, range 0..7 */
-       u8 ynorm_shift;
-       /* vertical normalization factor, range 16..31 */
-       u8 ynorm_factor;
-};
-
 struct ci_snapshot_config {
        /*  snapshot flags */
        u32 flags;
diff --git a/drivers/media/video/mrstci/mrstisp/Kconfig b/drivers/media/video/mrstci/mrstisp/Kconfig
old mode 100755
new mode 100644
diff --git a/drivers/media/video/mrstci/mrstisp/Makefile b/drivers/media/video/mrstci/mrstisp/Makefile
new file mode 100644
index 0000000..663e2ba
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/Makefile
@@ -0,0 +1,9 @@
+mrstisp-objs   := mrv_is.o mrv_ie.o mrv_jpe.o \
+                mrv_isp.o mrv_sls_bp.o mrv_mif.o  \
+                mrv_sls_dp.o mrv_isp_bls.o  mrv_isp_gamma.o \
+                mrv_sls_jpe.o mrv.o mrv_isp.o \
+                mrv_col.o mrv_is.o mrv_res.o intel_v4l2.o
+
+obj-$(CONFIG_VIDEO_MRST_ISP)    += mrstisp.o
+
+EXTRA_CFLAGS   +=      -I$(src)/../include -I$(src)/include
\ No newline at end of file
diff --git a/drivers/media/video/mrstci/mrstisp/intel_v4l2.c b/drivers/media/video/mrstci/mrstisp/intel_v4l2.c
new file mode 100644
index 0000000..041da05
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/intel_v4l2.c
@@ -0,0 +1,1965 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#include <linux/syscalls.h>
+#include "stdinc.h"
+#include "ci_isp_fmts_common.h"
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+
+static int video_nr = -1;
+int km_debug;
+
+static int pci_driver_loaded;
+static struct intel_isp_device intel_isp_v4l_device;
+struct intel_isp_device *g_intel;
+
+/* !initialized struct to hold the specific configuration */
+static struct ci_sensor_config isi_config;
+static struct ci_sensor_caps isi_caps;
+
+static struct ci_isp_config s_config;
+
+struct ci_isp_dbg_status {
+       u32 isp_imsc;
+       u32 mi_imsc;
+       u32 jpe_error_imsc;
+       u32 jpe_status_imsc;
+};
+
+/* g45-th20-b5 gamma out curve with enhanced black level */
+static struct ci_isp_gamma_out_curve g45_th20_b5 = {
+       {
+        0x0000, 0x0014, 0x003C, 0x0064,
+        0x00A0, 0x0118, 0x0171, 0x01A7,
+        0x01D8, 0x0230, 0x027A, 0x02BB,
+        0x0323, 0x0371, 0x03AD, 0x03DB,
+        0x03FF}
+       ,
+       0
+};
+
+static unsigned long jiffies_start;
+void intel_timer_start(void)
+{
+       jiffies_start = jiffies;
+
+}
+void intel_timer_stop(void)
+{
+       jiffies_start = 0;
+}
+unsigned long intel_get_micro_sec(void)
+{
+       unsigned long time_diff = 0;
+
+       time_diff = jiffies - jiffies_start;
+
+       return jiffies_to_msecs(time_diff);
+
+
+}
+void intel_sleep_micro_sec(unsigned long micro_sec)
+{
+       mdelay(micro_sec);
+}
+
+void intel_dbg_dd_out(u32 category, const char *pszFormat, ...)
+{
+       va_list     arglist;
+       va_start(arglist, pszFormat);
+
+       if (km_debug >= 1) {
+               printk(KERN_INFO "intel_v4l: ");
+               printk(pszFormat, arglist);
+       }
+       va_end(arglist);
+}
+
+static int intel_mrvisp_set_colorconversion_ex(void)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_0, MRV_ISP_CC_COEFF_0,
+           0x00001021);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_1, MRV_ISP_CC_COEFF_1,
+           0x00001040);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_2, MRV_ISP_CC_COEFF_2,
+           0x0000100D);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_3, MRV_ISP_CC_COEFF_3,
+           0x00000FED);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_4, MRV_ISP_CC_COEFF_4,
+           0x00000FDB);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_5, MRV_ISP_CC_COEFF_5,
+           0x00001038);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_6, MRV_ISP_CC_COEFF_6,
+           0x00001038);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_7, MRV_ISP_CC_COEFF_7,
+           0x00000FD1);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_8, MRV_ISP_CC_COEFF_8,
+           0x00000FF7);
+       return CI_STATUS_SUCCESS;
+
+}
+
+static unsigned long kvirt_to_pa(unsigned long adr)
+{
+       unsigned long kva, ret;
+
+       kva = (unsigned long)page_address(vmalloc_to_page((void *)adr));
+       kva |= adr & (PAGE_SIZE - 1);   /* restore the offset */
+       ret = __pa(kva);
+       return ret;
+}
+
+static int intel_defcfg_all_load(struct ci_isp_config *isp_config,
+       struct ci_sensor_config *isi_config)
+{
+
+       if (isp_config == NULL) {
+               DBG_DD(("isp_config is null\n"));
+               return CI_STATUS_NULL_POINTER;
+       }
+
+       if (isi_config == NULL) {
+               DBG_DD(("isi_config is null\n"));
+               return CI_STATUS_NULL_POINTER;
+       }
+       isp_config->demosaic_mode = CI_ISP_DEMOSAIC_ENHANCED;
+       /* bpc */
+       isp_config->bpc_cfg.bp_corr_type = CI_ISP_BP_CORR_DIRECT;
+       isp_config->bpc_cfg.bp_corr_rep = CI_ISP_BP_CORR_REP_NB;
+       isp_config->bpc_cfg.bp_corr_mode = CI_ISP_BP_CORR_HOT_DEAD_EN;
+       isp_config->bpc_cfg.bp_abs_hot_thres = 496;
+       isp_config->bpc_cfg.bp_abs_dead_thres = 20;
+       isp_config->bpc_cfg.bp_dev_hot_thres = 328;
+       isp_config->bpc_cfg.bp_dev_dead_thres = 328;
+       isp_config->bpd_cfg.bp_dead_thres = 1;
+
+       /* WB */
+       isp_config->wb_config.mrv_wb_mode = CI_ISP_AWB_AUTO;
+       isp_config->wb_config.mrv_wb_sub_mode = CI_ISP_AWB_AUTO_ON;
+       isp_config->wb_config.awb_pca_damping = 16;
+       isp_config->wb_config.awb_prior_exp_damping = 12;
+       isp_config->wb_config.awb_pca_push_damping = 16;
+       isp_config->wb_config.awb_prior_exp_push_damping = 12;
+       isp_config->wb_config.awb_auto_max_y = 254;
+       isp_config->wb_config.awb_push_max_y = 250;
+       isp_config->wb_config.awb_measure_max_y = 200;
+       isp_config->wb_config.awb_underexp_det = 10;
+       isp_config->wb_config.awb_push_underexp_det = 170;
+
+       /* CAC */
+       isp_config->cac_config.hsize = 2048;
+       isp_config->cac_config.vsize = 1536;
+       isp_config->cac_config.hcenter_offset = 0;
+       isp_config->cac_config.vcenter_offset = 0;
+       isp_config->cac_config.hclip_mode = 1;
+       isp_config->cac_config.vclip_mode = 2;
+       isp_config->cac_config.ablue = 24;
+       isp_config->cac_config.ared = 489;
+       isp_config->cac_config.bblue = 450;
+       isp_config->cac_config.bred = 53;
+       isp_config->cac_config.cblue = 40;
+       isp_config->cac_config.cred = 479;
+       isp_config->cac_config.aspect_ratio = 0.000000;
+
+       /* BLS */
+       isp_config->bls_cfg.enable_automatic = 0;
+       isp_config->bls_cfg.disable_h = 0;
+       isp_config->bls_cfg.disable_v = 0;
+       isp_config->bls_cfg.isp_bls_window1.enable_window = 0;
+       isp_config->bls_cfg.isp_bls_window1.start_h = 0;
+       isp_config->bls_cfg.isp_bls_window1.stop_h = 0;
+       isp_config->bls_cfg.isp_bls_window1.start_v = 0;
+       isp_config->bls_cfg.isp_bls_window1.stop_v = 0;
+       isp_config->bls_cfg.isp_bls_window2.enable_window = 0;
+       isp_config->bls_cfg.isp_bls_window2.start_h = 0;
+       isp_config->bls_cfg.isp_bls_window2.stop_h = 0;
+       isp_config->bls_cfg.isp_bls_window2.start_v = 0;
+       isp_config->bls_cfg.isp_bls_window2.stop_v = 0;
+       isp_config->bls_cfg.bls_samples = 5;
+       isp_config->bls_cfg.bls_subtraction.fixed_a = 0x100;
+       isp_config->bls_cfg.bls_subtraction.fixed_b = 0x100;
+       isp_config->bls_cfg.bls_subtraction.fixed_c = 0x100;
+       isp_config->bls_cfg.bls_subtraction.fixed_d = 0x100;
+
+       /* AF */
+       isp_config->af_cfg.wnd_pos_a.hoffs = 874;
+       isp_config->af_cfg.wnd_pos_a.voffs = 618;
+       isp_config->af_cfg.wnd_pos_a.hsize = 300;
+       isp_config->af_cfg.wnd_pos_a.vsize = 300;
+
+       /* color */
+       isp_config->color.contrast = 128;
+       isp_config->color.brightness = 0;
+       isp_config->color.saturation = 128;
+       isp_config->color.hue = 0;
+
+       /* Img Effect */
+       isp_config->img_eff_cfg.mode = CI_ISP_IE_MODE_OFF;
+       isp_config->img_eff_cfg.color_sel = 4;
+       isp_config->img_eff_cfg.color_thres = 128;
+       isp_config->img_eff_cfg.tint_cb = 108;
+       isp_config->img_eff_cfg.tint_cr = 141;
+       isp_config->img_eff_cfg.mat_emboss.coeff_11 = 2;
+       isp_config->img_eff_cfg.mat_emboss.coeff_12 = 1;
+       isp_config->img_eff_cfg.mat_emboss.coeff_13 = 0;
+       isp_config->img_eff_cfg.mat_emboss.coeff_21 = 1;
+       isp_config->img_eff_cfg.mat_emboss.coeff_22 = 0;
+       isp_config->img_eff_cfg.mat_emboss.coeff_23 = -1;
+       isp_config->img_eff_cfg.mat_emboss.coeff_31 = 0;
+       isp_config->img_eff_cfg.mat_emboss.coeff_32 = -1;
+       isp_config->img_eff_cfg.mat_emboss.coeff_33 = -2;
+
+       isp_config->img_eff_cfg.mat_sketch.coeff_11 = -1;
+       isp_config->img_eff_cfg.mat_sketch.coeff_12 = -1;
+       isp_config->img_eff_cfg.mat_sketch.coeff_13 = -1;
+       isp_config->img_eff_cfg.mat_sketch.coeff_21 = -1;
+       isp_config->img_eff_cfg.mat_sketch.coeff_22 = 8;
+       isp_config->img_eff_cfg.mat_sketch.coeff_23 = -1;
+       isp_config->img_eff_cfg.mat_sketch.coeff_31 = -1;
+       isp_config->img_eff_cfg.mat_sketch.coeff_32 = -1;
+       isp_config->img_eff_cfg.mat_sketch.coeff_33 = -1;
+
+       /* Framefun */
+       isp_config->flags.bls = 0;
+       isp_config->flags.bls_man = 0;
+       isp_config->flags.bls_smia = 0;
+       isp_config->flags.blsprint = 0;
+       isp_config->flags.bls_dis = 0;
+       isp_config->flags.lsc = 0;
+       isp_config->flags.lscprint = 0;
+       isp_config->flags.lsc_dis = 0;
+       isp_config->flags.bpc = 0;
+       isp_config->flags.bpcprint = 0;
+       isp_config->flags.bpc_dis = 0;
+       isp_config->flags.awb = 0;
+       isp_config->flags.awbprint = 0;
+       isp_config->flags.awbprint2 = 0;
+       isp_config->flags.awb_dis = 1;
+       isp_config->flags.aec = 0;
+       isp_config->flags.aecprint = 0;
+       isp_config->flags.aec_dis = 0;
+       isp_config->flags.af = 0;
+       isp_config->flags.afprint = 0;
+       isp_config->flags.af_dis = 0;
+       isp_config->flags.cp = 0;
+       isp_config->flags.gamma = 0;
+       isp_config->flags.cconv = 0;
+       isp_config->flags.demosaic = 0;
+       isp_config->flags.gamma2 = 0;
+       isp_config->flags.isp_filters = 0;
+       isp_config->flags.cac = 0;
+       isp_config->flags.cp_sat_loop = 0;
+       isp_config->flags.cp_contr_loop = 0;
+       isp_config->flags.cp_bright_loop = 0;
+       isp_config->flags.scaler_loop = 0;
+       isp_config->flags.cconv_basic = 0;
+       isp_config->flags.continous_af = 0;
+       isp_config->flags.bad_pixel_generation = 0;
+       isp_config->demosaic_th = 4;
+       isp_config->exposure = 80;
+       isp_config->advanced_aec_mode = 0;
+       isp_config->report_details = 0xffffffff;
+
+       /* flags = 0x00024010*/
+       isp_config->view_finder.flags = VFFLAG_HWRGB;
+       isp_config->view_finder.zoom = 0;
+       isp_config->view_finder.lcd_contrast = 77;
+       isp_config->view_finder.x = 0;
+       isp_config->view_finder.y = 0;
+       isp_config->view_finder.w = 100;
+       isp_config->view_finder.h = 75;
+       isp_config->view_finder.keep_aspect = 1;
+
+       isp_config->snapshot_a.flags = 0x00010000;
+       isp_config->snapshot_a.user_zoom = 0;
+       isp_config->snapshot_a.user_w = 640;
+       isp_config->snapshot_a.user_h = 480;
+       isp_config->snapshot_a.compression_ratio = 1;
+
+       isp_config->afm_mode = 1;
+       isp_config->afss_mode = 3;
+       isp_config->filter_level_noise_reduc = 4;
+       isp_config->filter_level_sharp = 4;
+
+       isp_config->snapshot_b.flags = 0x00000007;
+       isp_config->snapshot_b.user_zoom = 0;
+       isp_config->snapshot_b.user_w = 640;
+       isp_config->snapshot_b.user_h = 480;
+       isp_config->snapshot_b.compression_ratio = 1;
+       return 0;
+}
+
+static void intel_update_marvinvfaddr(struct intel_isp_device *intel)
+{
+       struct ci_isp_mi_path_conf isp_mi_path_conf;
+       u32 bufsize = 0;
+       u32 w;
+       u32 h;
+       u32 offset = 0;
+
+       memset(&isp_mi_path_conf, 0, sizeof(struct ci_isp_mi_path_conf));
+
+       w = isp_mi_path_conf.llength = intel->bufwidth;
+       h = isp_mi_path_conf.ypic_height = intel->bufheight;
+       isp_mi_path_conf.ypic_width = intel->bufwidth;
+
+       if (intel->pixelformat == V4L2_PIX_FMT_YUV420 ||
+               intel->pixelformat == V4L2_PIX_FMT_YVU420 ||
+               intel->pixelformat == V4L2_PIX_FMT_YUV422P ||
+               intel->pixelformat == V4L2_PIX_FMT_NV12) {
+               bufsize = w*h;
+       } else
+               bufsize = intel->frame_size;
+       offset = intel->cap_frame * PAGE_ALIGN(intel->frame_size);
+       intel->capbuf = intel->mb1_va + offset;
+       intel->capbuf_pa = intel->mb1 + offset;
+       DBG_DD(("UpdateMarvinAddr:\n"));
+       DBG_DD(("buf w:%d, h:%d, cap id=%d, Fsize:%d, Bsize: %d\n",
+               w, h, intel->cap_frame, intel->frame_size, bufsize));
+       DBG_DD(("cap buf va 0x%p, pa 0x%x\n", intel->capbuf, intel->capbuf_pa));
+
+       /* buffer size in bytes */
+       if (intel->pixelformat == V4L2_PIX_FMT_YUV420 ||
+               intel->pixelformat == V4L2_PIX_FMT_YVU420) {
+               DBG_DD(("yuv420 fmt\n"));
+               isp_mi_path_conf.ybuffer.size = bufsize;
+               isp_mi_path_conf.cb_buffer.size = bufsize/4;
+               isp_mi_path_conf.cr_buffer.size = bufsize/4;
+       } else if (intel->pixelformat == V4L2_PIX_FMT_YUV422P) {
+               DBG_DD(("yuv422 fmt\n"));
+               isp_mi_path_conf.ybuffer.size = bufsize;
+               isp_mi_path_conf.cb_buffer.size = bufsize/2;
+               isp_mi_path_conf.cr_buffer.size = bufsize/2;
+       } else if (intel->pixelformat == V4L2_PIX_FMT_NV12) {
+               DBG_DD(("nv12 fmt\n"));
+               isp_mi_path_conf.ybuffer.size = bufsize;
+               isp_mi_path_conf.cb_buffer.size = bufsize/2;
+               isp_mi_path_conf.cr_buffer.size = 0;
+       } else {
+               /* JPEG fmt and RGB and Bayer pattern fmt */
+               DBG_DD(("jpeg and rgb fmt\n"));
+               isp_mi_path_conf.ybuffer.size = bufsize;
+               isp_mi_path_conf.cb_buffer.size = 0;
+               isp_mi_path_conf.cr_buffer.size = 0;
+       }
+
+       if (isp_mi_path_conf.ybuffer.size != 0) {
+               /* buffer start address */
+               isp_mi_path_conf.ybuffer.pucbuffer = (u8 *)(unsigned long)
+                       intel->capbuf_pa;
+       }
+
+       if (isp_mi_path_conf.cb_buffer.size != 0) {
+               /* buffer start address */
+               isp_mi_path_conf.cb_buffer.pucbuffer =
+                       isp_mi_path_conf.ybuffer.pucbuffer +
+                       isp_mi_path_conf.ybuffer.size;
+       }
+
+       if (isp_mi_path_conf.cr_buffer.size != 0) {
+               isp_mi_path_conf.cr_buffer.pucbuffer =
+                       isp_mi_path_conf.cb_buffer.pucbuffer +
+                       isp_mi_path_conf.cb_buffer.size;
+       }
+       if (intel->pixelformat == V4L2_PIX_FMT_YVU420) {
+               isp_mi_path_conf.cr_buffer.pucbuffer =
+                       isp_mi_path_conf.ybuffer.pucbuffer +
+                       isp_mi_path_conf.ybuffer.size;
+               isp_mi_path_conf.cb_buffer.pucbuffer =
+                       isp_mi_path_conf.cr_buffer.pucbuffer +
+                       isp_mi_path_conf.cr_buffer.size;
+       }
+       if (intel->sys_conf.isp_cfg->view_finder.flags &
+               VFFLAG_USE_MAINPATH) {
+               ci_isp_mif__set_main_buffer(&isp_mi_path_conf,
+                       CI_ISP_CFG_UPDATE_FRAME_SYNC);
+       } else {
+               ci_isp_mif__set_self_buffer(&isp_mi_path_conf,
+                       CI_ISP_CFG_UPDATE_FRAME_SYNC);
+       }
+}
+
+static void init_frame_queue(struct fifo *queue)
+{
+       int i;
+       for (i = 0; i < INTEL_CAPTURE_BUFFERS; i++) {
+               queue->data[i] = -1;
+               queue->info[i].state = S_UNUSED;
+               queue->info[i].flags = 0;
+       }
+       queue->front = 0;
+       queue->back = 0;
+}
+
+static void add_frame_to_queue(struct fifo *queue, int frame)
+{
+       queue->data[queue->back] = frame;
+       queue->back = (queue->back + 1) % (INTEL_CAPTURE_BUFFERS + 1);
+}
+
+static int frame_queue_empty(struct fifo *queue)
+{
+       return queue->front == queue->back;
+}
+
+static int remove_frame_from_queue(struct fifo *queue)
+{
+       int frame;
+
+       if (frame_queue_empty(queue))
+               return -1;
+
+       frame = queue->data[queue->front];
+       queue->front = (queue->front + 1) % (INTEL_CAPTURE_BUFFERS + 1);
+       return frame;
+}
+
+static int intel_setup_viewfinder_path(
+       struct intel_isp_device *intel,
+       int zoom)
+{
+       int error = CI_STATUS_SUCCESS;
+       struct ci_isp_datapath_desc DpMain;
+       struct ci_isp_datapath_desc DpSelf;
+       struct ci_isp_rect self_rect;
+       u16 isi_hsize;
+       u16 isi_vsize;
+       u32 dp_mode;
+       int jpe_scale;
+       struct ci_pl_system_config *sys_conf = &intel->sys_conf;
+       struct ci_isp_config *config = sys_conf->isp_cfg;
+
+       if (sys_conf->isp_cfg->flags.fYCbCrFullRange)
+               jpe_scale = false;
+       else
+               jpe_scale = true;
+
+       memset(&DpMain, 0, sizeof(struct ci_isp_datapath_desc));
+       memset(&DpSelf, 0, sizeof(struct ci_isp_datapath_desc));
+
+       DBG_DD(("view_finder.flags = %x\n", config->view_finder.flags));
+
+       self_rect.x = 0;
+       self_rect.y = 0;
+       self_rect.w = intel->bufwidth; /* 640 */
+       self_rect.h = intel->bufheight; /* 480 */
+
+       if (intel->pixelformat == V4L2_PIX_FMT_JPEG) {
+               DBG_DD(("jpeg fmt\n"));
+               DpMain.flags = CI_ISP_DPD_ENABLE | CI_ISP_DPD_MODE_ISPJPEG;
+               config->view_finder.flags |= VFFLAG_USE_MAINPATH;
+               DpMain.out_w = (u16) intel->bufwidth;
+               DpMain.out_h = (u16) intel->bufheight;
+       } else if (intel->pixelformat == INTEL_PIX_FMT_RAW08) {
+               DpMain.flags = CI_ISP_DPD_ENABLE | CI_ISP_DPD_MODE_ISPRAW;
+               config->view_finder.flags |= VFFLAG_USE_MAINPATH;
+               /*just take the output of the sensor without any resizing*/
+               DpMain.flags |= CI_ISP_DPD_NORESIZE;
+               (void)ci_sensor_res2size(sys_conf->isi_config->res,
+                       &(DpMain.out_w), &(DpMain.out_h));
+       } else if (intel->pixelformat == INTEL_PIX_FMT_RAW10 ||
+               intel->pixelformat == INTEL_PIX_FMT_RAW12) {
+               DpMain.flags = (CI_ISP_DPD_ENABLE | CI_ISP_DPD_MODE_ISPRAW_16B);
+               config->view_finder.flags |= VFFLAG_USE_MAINPATH;
+               /*just take the output of the sensor without any resizing*/
+               DpMain.flags |= CI_ISP_DPD_NORESIZE;
+               (void)ci_sensor_res2size(sys_conf->isi_config->res,
+                       &(DpMain.out_w), &(DpMain.out_h));
+       } else if (intel->bufwidth > 640 && intel->bufheight >= 480) {
+               DpMain.flags = (CI_ISP_DPD_ENABLE | CI_ISP_DPD_MODE_ISPYC);
+               DpMain.out_w = (u16) intel->bufwidth;
+               DpMain.out_h = (u16) intel->bufheight;
+               config->view_finder.flags |= VFFLAG_USE_MAINPATH;
+               if (intel->pixelformat == V4L2_PIX_FMT_YUV420 ||
+                       intel->pixelformat == V4L2_PIX_FMT_YVU420)
+                       DpMain.flags |= CI_ISP_DPD_YUV_420 | CI_ISP_DPD_CSS_V2;
+               else if (intel->pixelformat == V4L2_PIX_FMT_YUV422P)
+                       DpMain.flags |= CI_ISP_DPD_YUV_422;
+               else if (intel->pixelformat == V4L2_PIX_FMT_NV12)
+                       DpMain.flags |= CI_ISP_DPD_YUV_NV12 | CI_ISP_DPD_CSS_V2;
+               else if (intel->pixelformat == V4L2_PIX_FMT_YUYV)
+                       DpMain.flags |= CI_ISP_DPD_YUV_YUYV;
+               else
+                       DBG_DD(("dpMain.flags is 0x%x\n", DpMain.flags));
+       } else if (intel->bufwidth <= 640 && intel->bufheight <= 480) {
+               DpSelf.flags = (CI_ISP_DPD_ENABLE | CI_ISP_DPD_MODE_ISPYC);
+               if (intel->pixelformat == V4L2_PIX_FMT_YUV420 ||
+                       intel->pixelformat == V4L2_PIX_FMT_YVU420)
+                       DpSelf.flags |= CI_ISP_DPD_YUV_420 | CI_ISP_DPD_CSS_V2;
+               else if (intel->pixelformat == V4L2_PIX_FMT_YUV422P)
+                       DpSelf.flags |= CI_ISP_DPD_YUV_422;
+               else if (intel->pixelformat == V4L2_PIX_FMT_NV12)
+                       DpSelf.flags |= CI_ISP_DPD_YUV_NV12 | CI_ISP_DPD_CSS_V2;
+               else if (intel->pixelformat == V4L2_PIX_FMT_YUYV)
+                       DpSelf.flags |= CI_ISP_DPD_YUV_YUYV;
+               else if (intel->pixelformat == V4L2_PIX_FMT_RGB565)
+                       DpSelf.flags |= CI_ISP_DPD_HWRGB_565;
+               else if (intel->pixelformat == V4L2_PIX_FMT_BGR32)
+                       DpSelf.flags |= CI_ISP_DPD_HWRGB_888;
+               else
+                       DBG_DD(("DpSelf.flags is 0x%x\n", DpSelf.flags));
+       }
+       DBG_DD(("sensor_res = %x\n", sys_conf->isi_config->res));
+       (void)ci_sensor_res2size(sys_conf->isi_config->res, &isi_hsize,
+           &isi_vsize);
+
+       DBG_DD(("self path: w:%d, h:%d; sensor: w:%d, h:%d\n",
+               self_rect.w, self_rect.h, isi_hsize, isi_vsize));
+       DBG_DD(("main path: out_w:%d, out_h:%d \n",
+               DpMain.out_w, DpMain.out_h));
+
+       DpSelf.out_w = (u16) self_rect.w;
+       DpSelf.out_h = (u16) self_rect.h;
+
+       if (sys_conf->isp_cfg->view_finder.flags & VFFLAG_HWRGB) {
+               if (intel->pixelformat == V4L2_PIX_FMT_RGB565)
+                       DpSelf.flags |= CI_ISP_DPD_HWRGB_565;
+               if (intel->pixelformat == V4L2_PIX_FMT_BGR32)
+                       DpSelf.flags |= CI_ISP_DPD_HWRGB_888;
+
+       } else {
+               DBG_DD(("don't use the HWRGB conversion\n"));
+
+       }
+
+       if (sys_conf->isp_cfg->view_finder.flags & VFFLAG_MIRROR)
+               DpSelf.flags |= CI_ISP_DPD_H_FLIP;
+
+       if (sys_conf->isp_cfg->view_finder.flags & VFFLAG_V_FLIP)
+               DpSelf.flags |= CI_ISP_DPD_V_FLIP;
+
+       if (sys_conf->isp_cfg->view_finder.flags & VFFLAG_ROT90_CCW)
+               DpSelf.flags |= CI_ISP_DPD_90DEG_CCW;
+
+       if (!sys_conf->isp_cfg->flags.af_dis &&
+           (sys_conf->isp_cfg->afm_mode != CI_ISP_AFM_HW)) {
+               if (sys_conf->isp_cfg->view_finder.
+                   flags & VFFLAG_USE_MAINPATH) {
+                               DBG_DD(("ERR: main path configured to do both"
+                               "viewfinding and software AF mesurement\n"));
+                       return CI_STATUS_NOTSUPP;
+               }
+
+               DpMain.flags |= CI_ISP_DPD_ENABLE;
+       }
+       /* setup self & main path with zoom */
+       if (zoom < 0)
+               zoom = sys_conf->isp_cfg->view_finder.zoom;
+       if (sys_conf->isp_cfg->view_finder.flags & VFFLAG_USE_MAINPATH) {
+               DBG_DD(("view finder in mail path\n"));
+               dp_mode = DpMain.flags & CI_ISP_DPD_MODE_MASK;
+               if ((dp_mode == CI_ISP_DPD_MODE_ISPRAW) ||
+                       (dp_mode == CI_ISP_DPD_MODE_ISPRAW_16B)) {
+                       struct ci_sensor_config isi_conf;
+                       isi_conf = *sys_conf->isi_config;
+                       isi_conf.mode = SENSOR_MODE_PICT;
+                       error = ci_isp_set_input_aquisition(&isi_conf);
+                       if (error != CI_STATUS_SUCCESS) {
+                               DBG_OUT((DERR, "ERR: ci_do_snapshot: failed"
+                                       "to re-init ISP input aquisition\n"));
+                       }
+               }
+               error = ci_datapath_isp(sys_conf, &DpMain,
+                       NULL, zoom);
+
+       } else {
+               DBG_DD(("view finder in selfpath\n"));
+               error =
+                   ci_datapath_isp(sys_conf, &DpMain,
+                       &DpSelf, zoom);
+       }
+
+       if (error != CI_STATUS_SUCCESS) {
+               DBG_DD((" ERR: failed to setup marvins datapaths\n"));
+               return error;
+       }
+
+       intel_update_marvinvfaddr(intel);
+       return error;
+}
+
+static int intel_init_mrv_image_effects(
+       const struct ci_pl_system_config *sys_conf,
+       int enable)
+{
+       int res;
+       if ((enable) &&
+           (sys_conf->isp_cfg->img_eff_cfg.mode != CI_ISP_IE_MODE_OFF)) {
+               res = ci_isp_ie_set_config(&(sys_conf->isp_cfg->img_eff_cfg));
+               if (res != CI_STATUS_SUCCESS) {
+                       DBG_OUT((DWARN, "WARN: failed to configure image "
+                           "effects, code(%d)", res));
+               }
+       } else {
+               (void)ci_isp_ie_set_config(NULL);
+               res = CI_STATUS_SUCCESS;
+       }
+       return res;
+}
+
+static int intel_init_mrvisp_lensshade(
+       const struct ci_pl_system_config *sys_conf,
+       int enable)
+{
+       if ((enable) && (sys_conf->isp_cfg->flags.lsc)) {
+               ci_isp_set_ls_correction(&(sys_conf->isp_cfg->lsc_cfg));
+               ci_isp_ls_correction_on_off(true);
+       } else
+               (void)ci_isp_ls_correction_on_off(false);
+
+       return CI_STATUS_SUCCESS;
+}
+
+static int intel_init_mrvisp_badpixel(
+       const struct ci_pl_system_config *sys_conf,
+       int enable)
+{
+       if ((enable) && (sys_conf->isp_cfg->flags.bpc)) {
+               (void)ci_bp_init(&sys_conf->isp_cfg->bpc_cfg,
+                   &sys_conf->isp_cfg->bpd_cfg);
+       } else {
+               (void)ci_bp_end(&sys_conf->isp_cfg->bpc_cfg);
+               (void)ci_isp_set_bp_correction(NULL);
+               (void)ci_isp_set_bp_detection(NULL);
+       }
+       return CI_STATUS_SUCCESS;
+}
+
+static int intel_init_mrv_ispfilter(const struct ci_pl_system_config *sys_conf,
+       int enable)
+{
+       int res;
+       if ((enable) && (sys_conf->isp_cfg->flags.isp_filters)) {
+               (void)ci_isp_activate_filter(true);
+               res =
+                   ci_isp_set_filter_params(sys_conf->isp_cfg->
+                       filter_level_noise_reduc,
+                       sys_conf->isp_cfg->
+                       filter_level_sharp);
+               if (res != CI_STATUS_SUCCESS) {
+                       DBG_OUT((DWARN, "WARN: failed to configure isp "
+                           "filter, code(%d)", res));
+               }
+       } else {
+               (void)ci_isp_activate_filter(false);
+               res = CI_STATUS_SUCCESS;
+       }
+       return res;
+}
+
+static int intel_initbls(const struct ci_pl_system_config *sys_conf)
+{
+       struct ci_isp_bls_config *bls_config =
+           (struct ci_isp_bls_config *)&sys_conf->isp_cfg->bls_cfg;
+       return ci_isp_bls_set_config(bls_config);
+}
+
+
+static void intel_dpinitisi(struct ci_sensor_config *isi_config,
+    struct ci_sensor_caps *isi_caps)
+{
+       int      error       = CI_STATUS_SUCCESS;
+       DBG_DD(("intel_dpinitisi\n"));
+       ci_sensor_get_caps(isi_caps);
+       ci_sensor_get_config(isi_config);
+
+       if (error != CI_STATUS_SUCCESS) {
+               DBG_DD(("IsiGetSelectedSensorDefaultConfig() failed.\n"));
+               /* unable to get the default configuration */
+               ASSERT(false);
+       }
+}
+
+static void intel_enable_interrupt(void)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 bit_mask = 0x00000001;
+       REG_SET_SLICE(mrv_reg->isp_imsc, MRV_ISP_IMSC_ALL, ON);
+       REG_WRITE(mrv_reg->mi_imsc, bit_mask);
+       REG_SET_SLICE(mrv_reg->jpe_error_imr, MRV_JPE_ALL_ERR, ON);
+       REG_SET_SLICE(mrv_reg->jpe_status_imr, MRV_JPE_ALL_STAT, ON);
+       ci_isp_reset_interrupt_status();
+}
+
+static int intel_dpinitmrv(const struct ci_pl_system_config *sys_conf)
+{
+       int error;
+       u8 words_per_pixel;
+       struct ci_isp_config *ptcfg;
+       ptcfg = sys_conf->isp_cfg;
+       DBG_DD(("entering intel_dpinitmrv\n"));
+
+       ci_isp_init();
+       intel_enable_interrupt();
+
+       /* setup input acquisition according to image sensor settings */
+       error = ci_isp_set_input_aquisition(sys_conf->isi_config);
+       if (error) {
+               DBG_DD(("ERR: () failed to configure input aquisition,"
+                       "code(%d)\n", error));
+               return error;
+       }
+
+       /* setup functional blocks for Bayer pattern processing */
+       if (ci_isp_select_path(sys_conf->isi_config, &words_per_pixel) ==
+           CI_ISP_PATH_BAYER) {
+               if (sys_conf->isp_cfg->flags.bls_dis) {
+                       ci_isp_bls_set_config(NULL);
+               } else {
+                       error = intel_initbls(sys_conf);
+                       if (error != CI_STATUS_SUCCESS)
+                               return error;
+               }
+               DBG_DD(("finished ci_isp_bls_set_config\n"));
+
+               if (sys_conf->isp_cfg->flags.gamma2)
+                       ci_isp_set_gamma2(&g45_th20_b5);
+               else
+                       ci_isp_set_gamma2(NULL);
+
+               DBG_DD(("finished ci_isp_set_gamma2\n"));
+
+               ci_isp_set_demosaic(sys_conf->isp_cfg->demosaic_mode,
+                   sys_conf->isp_cfg->demosaic_th);
+               DBG_DD(("finished ci_isp_set_demosaic\n"));
+
+               if (sys_conf->isp_cfg->flags.cconv) {
+                       if (sys_conf->isp_cfg->flags.cconv_basic) {
+                               if (error != CI_STATUS_SUCCESS)
+                                       return error;
+                       } else {
+                               intel_mrvisp_set_colorconversion_ex();
+
+                               if (error != CI_STATUS_SUCCESS)
+                                       return error;
+                       }
+               }
+
+               if (sys_conf->isp_cfg->flags.af_dis)
+                       (void)ci_isp_set_auto_focus(NULL);
+               else
+                       (void)ci_isp_set_auto_focus(&sys_conf->isp_cfg->af_cfg);
+               intel_init_mrv_ispfilter(sys_conf, true);
+       }
+
+       ci_isp_col_set_color_processing(NULL);
+       intel_init_mrv_image_effects(sys_conf, true);
+       (void)intel_init_mrvisp_lensshade(sys_conf, true);
+       (void)intel_init_mrvisp_badpixel(sys_conf, true);
+       return CI_STATUS_SUCCESS;
+}
+
+/* ------------------------- V4L2 interface --------------------- */
+static int intel_open(struct file *file)
+{
+       struct video_device *dev = video_devdata(file);
+       struct intel_isp_device *intel = video_get_drvdata(dev);
+       DBG_DD(("intel_open\n"));
+
+       if (!intel) {
+               DBG_DD(("Internal error, camera_data not found!\n"));
+               return -ENODEV;
+       }
+
+       if (intel->open)  {
+               ++intel->open;
+               DBG_DD(("device has opened already - %d\n", intel->open));
+               return 0;
+       }
+
+       file->private_data = dev;
+       /* increment our usage count for the driver */
+       ++intel->open;
+       DBG_DD(("intel_open is %d\n", intel->open));
+
+       memset(&intel->sys_conf, 0, sizeof(struct ci_pl_system_config));
+       memset(&isi_config, 0, sizeof(isi_config));
+       memset(&isi_caps, 0, sizeof(isi_caps));
+       memset(&s_config, 0, sizeof(s_config));
+
+       intel->sys_conf.isi_config = &isi_config;
+       intel->sys_conf.isi_caps = &isi_caps;
+       intel->sys_conf.isp_cfg = &s_config;
+       s_config.jpeg_enc_ratio = 1;
+
+       intel->frame_size_used = 0;
+
+       /* default buf size and type*/
+       intel->bufwidth = 0;
+       intel->bufheight = 0;
+       intel->depth = 0;
+       intel->pixelformat = 0;
+       return 0;
+}
+
+static int intel_close(struct file *file)
+{
+       struct video_device *dev = video_devdata(file);
+       struct intel_isp_device *intel = video_get_drvdata(dev);
+
+       DBG_DD(("intel_close,release resources\n"));
+
+       --intel->open;
+       if (intel->open) {
+               DBG_DD(("not the last close %d\n", intel->open));
+               return 0;
+       }
+
+       if (!intel->sys_conf.isp_hal_enable)
+               ci_sensor_stop();
+
+       intel->fbuffer = NULL;
+       intel->capbuf = NULL;
+       return 0;
+}
+
+static ssize_t intel_read(struct file *file, char __user *buf,
+    size_t count, loff_t *ppos)
+{
+       return 0;
+
+}
+
+static void intel_vma_open(struct vm_area_struct *vma)
+{
+       struct video_device *dev = vma->vm_private_data;
+       struct intel_isp_device *intel = video_get_drvdata(dev);
+       DBG_DD(("intel_vma_open %d\n", intel->vmas));
+       intel->vmas++;
+}
+
+static void intel_vma_close(struct vm_area_struct *vma)
+{
+       struct video_device *dev = vma->vm_private_data;
+       struct intel_isp_device *intel = video_get_drvdata(dev);
+       int i = 0;
+
+       DBG_DD(("intel_vma_close %d\n", intel->vmas));
+       intel->vmas--;
+
+       /* docs say we should stop I/O too... */
+       if (intel->vmas == 0) {
+               DBG_DD(("clear the  ~V4L2_BUF_FLAG_MAPPED flag\n"));
+               DBG_DD(("i %d, num_frame is %d\n", i, intel->num_frames));
+               for (i = 0; i < intel->num_frames; i++) {
+                       intel->frame_queue.info[i].flags &=
+                       ~V4L2_BUF_FLAG_MAPPED;
+                       DBG_DD(("%d frame queue flags %d\n", i,
+                               intel->frame_queue.info[i].flags));
+               }
+       }
+}
+
+static struct vm_operations_struct intel_vm_ops = {
+       .open =     intel_vma_open,
+       .close =    intel_vma_close
+};
+
+static int km_mmap(struct video_device *dev, struct vm_area_struct *vma)
+{
+       const char *adr = (const char *)vma->vm_start;
+       unsigned long size = vma->vm_end-vma->vm_start;
+       unsigned long start = (unsigned long)adr;
+       unsigned long pos, page = 0;
+       unsigned long vsize;
+       struct intel_isp_device *intel = video_get_drvdata(dev);
+       u32 i;
+
+       /* check the size */
+       vsize = (intel->num_frames) * PAGE_ALIGN(intel->frame_size);
+
+       if (!(vma->vm_flags & (VM_WRITE | VM_READ)))
+               return -EACCES;
+
+       if (!(vma->vm_flags & VM_SHARED))
+               return -EINVAL;
+
+       for (i = 0; i < intel->num_frames; i++) {
+               if (((PAGE_ALIGN(intel->frame_size)*i) >> PAGE_SHIFT) ==
+                   vma->vm_pgoff)
+                       break;
+       }
+
+       if (i == intel->num_frames) {
+               DBG_DD(("mmap: mapping address is out of range\n"));
+               return -EINVAL;
+       }
+
+       if (size != PAGE_ALIGN(intel->frame_size)) {
+               DBG_DD((" failed to check Capture buffer size\n"));
+               return -EINVAL;
+       }
+
+       /* VM_IO is eventually going to replace PageReserved altogether */
+       vma->vm_flags |= VM_IO;
+       vma->vm_flags |= VM_RESERVED;   /* avoid to swap out this VMA */
+
+       pos = (unsigned long)(intel->mb1_va+
+               (intel->cap_frame * PAGE_ALIGN(intel->frame_size)));
+
+       page = kvirt_to_pa(pos);
+       page = page >> PAGE_SHIFT;
+       if (remap_pfn_range(vma, start, page, size, PAGE_SHARED)) {
+               DBG_DD(("failed to put MMAP buffer to user space\n"));
+               return -EAGAIN;
+       }
+       return 0;
+}
+
+/* FIXME */
+/* ------------------------------------------------------------------ */
+static int intel_mmap(struct file *file, struct vm_area_struct *vma)
+{
+       struct video_device *dev = file->private_data;
+       struct intel_isp_device *intel = video_get_drvdata(dev);
+       int i = 0;
+       int retval;
+       retval = km_mmap(dev, vma);
+       if (retval)
+               return retval;
+       vma->vm_ops = &intel_vm_ops;
+       vma->vm_flags |= VM_DONTEXPAND;
+       for (i = 0; i < intel->num_frames; i++) {
+               intel->frame_queue.info[i].flags = V4L2_BUF_FLAG_MAPPED;
+               DBG_DD(("frame queue flags %d\n",
+                       intel->frame_queue.info[i].flags));
+       }
+       vma->vm_private_data = file->private_data;
+       intel_vma_open(vma);
+       return retval;
+}
+
+
+static int intel_g_fmt_cap(struct file *file, void *priv,
+                               struct v4l2_format *f)
+{
+       struct video_device *dev = video_devdata(file);
+       struct intel_isp_device *intel = video_get_drvdata(dev);
+       int ret;
+
+       DBG_DD(("intel_g_fmt_cap\n"));
+       if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+               f->fmt.pix.width = intel->bufwidth;
+               f->fmt.pix.height = intel->bufheight;
+               f->fmt.pix.pixelformat = intel->pixelformat;
+               f->fmt.pix.bytesperline =
+                       (f->fmt.pix.width * intel->depth) >> 3;
+               f->fmt.pix.sizeimage =
+                   f->fmt.pix.height * f->fmt.pix.bytesperline;
+               ret = 0;
+       } else {
+               ret = -EINVAL;
+       }
+       return ret;
+
+}
+
+static struct intel_fmt *fmt_by_fourcc(unsigned int fourcc)
+{
+       unsigned int i;
+
+       for (i = 0; i < NUM_FORMATS; i++)
+               if (fmts[i].fourcc == fourcc)
+                       return fmts+i;
+       return NULL;
+}
+
+static int intel_try_fmt_cap(struct file *file, void *priv,
+                                               struct v4l2_format *f)
+{
+       struct intel_fmt *fmt;
+       int w, h;
+       unsigned short sw, sh;
+       int ret;
+       struct ci_sensor_config *snr_cfg;
+
+       struct video_device *dev = video_devdata(file);
+       struct intel_isp_device *intel = video_get_drvdata(dev);
+
+       snr_cfg = intel->sys_conf.isi_config;
+       DBG_DD(("intel_try_fmt_cap\n"));
+
+       if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+               return -EINVAL;
+
+       fmt = fmt_by_fourcc(f->fmt.pix.pixelformat);
+       if (NULL == fmt) {
+               DBG_DD(("fmt not found\n"));
+               return -EINVAL;
+       }
+
+       w = f->fmt.pix.width;
+       h = f->fmt.pix.height;
+
+       DBG_DD(("TRY_FMT: try before buf :w%d, h%d\n", w, h));
+       if (intel->sys_conf.isp_hal_enable &&
+               snr_cfg->type == SENSOR_TYPE_RAW) {
+               ci_sensor_res2size(snr_cfg->res, &sw, &sh);
+               DBG_DD(("libCI/raw sensor create frame, %dx%d\n", sw, sh));
+               if (w > sw)
+                       w = sw;
+               if (h > sh)
+                       h = sh;
+       } else {
+               DBG_DD(("v4l2 paht or SoC sensor create frame\n"));
+               if (ci_sensor_try_mode(&w, &h))
+                       return -EINVAL;
+       }
+
+       /* RBG on self path */
+       if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_RGB565 ||
+           f->fmt.pix.pixelformat == V4L2_PIX_FMT_BGR32) {
+               if (w < INTEL_MIN_WIDTH)
+                       w = INTEL_MIN_WIDTH;
+               if (w > INTEL_MAX_WIDTH)
+                       w = INTEL_MAX_WIDTH;
+               if (h < INTEL_MIN_HEIGHT)
+                       h = INTEL_MIN_HEIGHT;
+               if (h > INTEL_MAX_HEIGHT)
+                       h = INTEL_MAX_HEIGHT;
+               f->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
+       } else {
+               /* YUV and JPEG formats*/
+               if (w < INTEL_MIN_WIDTH)
+                       w = INTEL_MIN_WIDTH;
+               if (w > INTEL_MAX_WIDTH_MP/*2048*/)
+                       w = INTEL_MAX_WIDTH_MP;
+               if (h < INTEL_MIN_HEIGHT)
+                       h = INTEL_MIN_HEIGHT;
+               if (h > INTEL_MAX_HEIGHT_MP/*1536*/)
+                       h = INTEL_MAX_HEIGHT_MP;
+               f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+       }
+       /* Deal with the raw data bayer pattern */
+       if (f->fmt.pix.pixelformat == INTEL_PIX_FMT_RAW08 ||
+          f->fmt.pix.pixelformat == INTEL_PIX_FMT_RAW10 ||
+          f->fmt.pix.pixelformat == INTEL_PIX_FMT_RAW12)
+                       ret = 0;
+       f->fmt.pix.width = w;
+       f->fmt.pix.height = h;
+       f->fmt.pix.field = V4L2_FIELD_NONE;
+       f->fmt.pix.bytesperline = (w * h)/8;
+       f->fmt.pix.sizeimage = (w * h * fmt->depth)/8;
+       if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_JPEG)
+               f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
+       f->fmt.pix.priv = 0;
+       ret = 0;
+
+       DBG_DD(("TRY_FMT: try after buf :w%d, h%d\n", w, h));
+       return ret;
+}
+
+
+static int intel_s_fmt_cap(struct file *file, void *priv,
+                                       struct v4l2_format *f)
+{
+       struct video_device *dev = video_devdata(file);
+       struct intel_isp_device *intel = video_get_drvdata(dev);
+       struct intel_fmt *fmt;
+       int err;
+
+       DBG_DD(("intel_s_fmt_cap\n"));
+
+       if (!intel->sys_conf.isp_hal_enable) {
+               DBG_DD(("v4l2 path intel_s_fmt_cap, sensor_start\n"));
+               ci_sensor_start();
+       } else
+               DBG_DD(("isp hal path in intel_s_fmt_cap\n"));
+
+       err = intel_try_fmt_cap(file, priv, f);
+       if (0 != err) {
+               DBG_DD(("set format failed\n"));
+               return err;
+       }
+
+       fmt = fmt_by_fourcc(f->fmt.pix.pixelformat);
+       /*
+        * save the format into the driver
+        */
+       intel->pixelformat = fmt->fourcc;
+       intel->depth = fmt->depth;
+       intel->bufwidth = f->fmt.pix.width;
+       intel->bufheight = f->fmt.pix.height;
+       DBG_DD(("set fmt: w %d, h%d, fourcc: %lx\n", intel->bufwidth,
+               intel->bufheight, fmt->fourcc));
+       return 0;
+}
+
+static int intel_queryctrl(struct file *file, void *priv,
+       struct v4l2_queryctrl *c)
+{
+       DBG_DD(("intel_queryctrl\n"));
+
+       if ((c->id <  V4L2_CID_BASE) || (c->id >=  V4L2_CID_PRIVATE_BASE))
+               return -EINVAL;
+
+       if (ci_sensor_queryctrl(c))
+               return -EINVAL;
+       return 0;
+}
+
+static int intel_g_ctrl(struct file *file, void *priv, struct v4l2_control *c)
+{
+       DBG_DD(("intel_g_ctrl\n"));
+       return ci_sensor_get_ctrl(c);
+}
+
+static int intel_s_ctrl(struct file *file, void *fh, struct v4l2_control *c)
+{
+       int ret = 0;
+       struct ci_sensor_config *isi_config;
+       DBG_DD(("intel_s_ctrl\n"));
+       ret = ci_sensor_set_ctrl(c);
+       if ((!ret) && (c->id == V4L2_CID_HFLIP)) {
+               isi_config = kzalloc(sizeof(struct ci_sensor_config),
+                                    GFP_KERNEL);
+               if (isi_config == NULL)
+                       return -ENOMEM;
+               ci_sensor_get_config(isi_config);
+               ci_isp_set_input_aquisition(isi_config);
+       }
+       return ret;
+}
+
+static int intel_enum_input(struct file *file, void *priv,
+       struct v4l2_input *input)
+{
+       int ret;
+
+       if (input->index != 0) {
+               ret = -EINVAL;
+       } else {
+               strlcpy(input->name, "mrst isp", sizeof(input->name));
+               input->type = V4L2_INPUT_TYPE_CAMERA;
+               input->audioset = 0;
+               input->tuner = 0;
+               input->std = V4L2_STD_UNKNOWN;
+               input->status = 0;
+               memset(input->reserved, 0, sizeof(input->reserved));
+               ret = 0;
+       }
+       return ret;
+}
+
+static int intel_g_input(struct file *file, void *priv, unsigned int *i)
+{
+       *i = 0;
+       return 0;
+}
+
+static int intel_s_input(struct file *file, void *priv, unsigned int i)
+{
+       return 0;
+}
+
+static int intel_s_std(struct file *filp, void *priv, v4l2_std_id *a)
+{
+       return 0;
+}
+
+static int intel_querycap(struct file *file, void  *priv,
+       struct v4l2_capability *cap)
+{
+       struct video_device *dev = video_devdata(file);
+       memset(cap, 0, sizeof(struct v4l2_capability));
+       strlcpy(cap->driver, DRIVER_NAME, sizeof(cap->driver));
+       strlcpy(cap->card, dev->name, sizeof(cap->card));
+       memset(cap->bus_info, 0, sizeof(cap->bus_info));
+       cap->version = INTEL_VERSION(0, 5, 0);
+       cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+
+       return 0;
+}
+
+static int intel_cropcap(struct file *file, void *priv,
+                                       struct v4l2_cropcap *cap)
+{
+       struct video_device *dev = video_devdata(file);
+       struct intel_isp_device *intel = video_get_drvdata(dev);
+
+       if (cap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+               return -EINVAL;
+
+       cap->bounds.left = 0;
+       cap->bounds.top = 0;
+       cap->bounds.width = intel->bufwidth;
+       cap->bounds.height = intel->bufheight;
+       cap->defrect = cap->bounds;
+       cap->pixelaspect.numerator   = 1;
+       cap->pixelaspect.denominator = 1;
+       return 0;
+}
+
+static int intel_enum_fmt_cap(struct file *file, void  *priv,
+                                       struct v4l2_fmtdesc *f)
+{
+       struct video_device *dev = video_devdata(file);
+       struct intel_isp_device *intel = video_get_drvdata(dev);
+
+       struct ci_sensor_config *snrcfg;
+
+       int ret;
+       unsigned int index;
+
+       DBG_DD(("intel_enum_fmt_cap\n"));
+       snrcfg = intel->sys_conf.isi_config;
+       index = f->index;
+
+       if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+               ret = -EINVAL;
+       else {
+               if (snrcfg->type == SENSOR_TYPE_SOC)
+                       if (index >= 8)
+                               return -EINVAL;
+               if (index >= sizeof(fmts) / sizeof(*fmts))
+                       return -EINVAL;
+               memset(f, 0, sizeof(*f));
+               f->index = index;
+               f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+               strlcpy(f->description, fmts[index].name,
+                   sizeof(f->description));
+               f->pixelformat = fmts[index].fourcc;
+               if (fmts[index].fourcc == V4L2_PIX_FMT_JPEG)
+                       f->flags = V4L2_FMT_FLAG_COMPRESSED;
+               ret = 0;
+       }
+       return ret;
+
+}
+
+#define ALIGN4(x)       ((((long)(x)) & 0x3) == 0)
+
+static int intel_reqbufs(struct file *file, void *priv,
+               struct v4l2_requestbuffers *req)
+{
+       struct video_device *dev = video_devdata(file);
+       struct intel_isp_device *intel = video_get_drvdata(dev);
+       u32 w;
+       u32 h;
+       u32 depth;
+       u32 fourcc;
+       unsigned long vsize;
+
+       if (req->memory != V4L2_MEMORY_MMAP ||
+           req->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+           req->count < 0)  {
+               return  -EINVAL;
+       }
+
+       if (req->count == 0) {
+               /* free the buffers */
+               intel->fbuffer = NULL;
+               intel->capbuf = NULL;
+               intel->frame_size_used = 0;
+               return 0;
+       }
+
+       DBG_DD(("REQBUFS requested:%d max:%d, \n",
+               req->count, INTEL_CAPTURE_BUFFERS));
+
+       if (req->count > INTEL_CAPTURE_BUFFERS)
+               req->count = INTEL_CAPTURE_BUFFERS;
+
+       w = intel->bufwidth;
+       h = intel->bufheight;
+       depth = intel->depth;
+       fourcc = intel->pixelformat;
+
+       if (fourcc == V4L2_PIX_FMT_JPEG) {
+               DBG_DD(("JPEG\n"));
+               intel->frame_size =
+                       PAGE_ALIGN(intel->mb1_size/req->count) - PAGE_SIZE;
+       } else if (fourcc == INTEL_PIX_FMT_RAW08 ||
+               fourcc == INTEL_PIX_FMT_RAW10 ||
+               fourcc == INTEL_PIX_FMT_RAW12) {
+               DBG_DD(("Bayer Pattern\n"));
+               intel->frame_size = (w * h * depth)/8;
+       } else {
+               DBG_DD(("YUV or RGB "));
+               intel->frame_size = (w * h * depth)/8;
+       }
+
+       DBG_DD(("frame size is %d\n", intel->frame_size));
+       intel->num_frames = req->count;
+
+       /* allocate the memory */
+       if (intel->fbuffer) {
+               DBG_DD(("mem allocated, please free it first\n"));
+               return -EINVAL;
+       }
+       vsize = intel->num_frames * PAGE_ALIGN(intel->frame_size);
+       DBG_DD(("requested frame size is %ld, total is %ld\n", vsize,
+               intel->mb1_size));
+
+       DBG_DD(("PCI space path\n"));
+       if (vsize > intel->mb1_size)
+               intel->fbuffer = NULL;
+       else
+               intel->fbuffer = intel->mb1_va;
+
+       if (intel->fbuffer) {
+               DBG_DD(("for QA to test mmap: kernel address 0x%p\n",
+                       intel->fbuffer));
+       } else {
+               DBG_DD(("failed to allocate fbuffer\n"));
+               return -ENOMEM;
+       }
+
+       if (!intel->capbuf) {
+               if (vsize > intel->mb1_size)
+                       intel->capbuf = NULL;
+               else {
+
+                       intel->capbuf = intel->mb1_va;
+                       intel->capbuf_pa = intel->mb1;
+               }
+
+               if (!intel->capbuf || !ALIGN4(intel->capbuf)) {
+                       DBG_DD(("failed to allocate cap buf\n"));
+                       return -ENOMEM;
+               }
+       }
+
+       intel->vmas = 0;
+       init_frame_queue(&intel->frame_queue);
+       return 0;
+
+
+}
+
+static int intel_querybuf(struct file *file, void *priv,
+                                       struct v4l2_buffer *buf)
+{
+       struct video_device *dev = video_devdata(file);
+       struct intel_isp_device *intel = video_get_drvdata(dev);
+
+       if (buf->memory != V4L2_MEMORY_MMAP ||
+           buf->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+           buf->index >= intel->num_frames || buf->index < 0)
+               return  -EINVAL;
+
+       buf->m.offset = PAGE_ALIGN(intel->frame_size) * buf->index;
+       buf->length = PAGE_ALIGN(intel->frame_size);
+       buf->flags = 0;
+       buf->flags |= intel->frame_queue.info[buf->index].flags;
+       DBG_DD(("buf flags is %x\n", buf->flags));
+
+       if (intel->frame_queue.info[buf->index].state == S_DONE)
+               buf->flags |= V4L2_BUF_FLAG_DONE;
+       else if (intel->frame_queue.info[buf->index].state == S_UNUSED)
+               buf->flags |= V4L2_BUF_FLAG_QUEUED;
+       buf->field = V4L2_FIELD_NONE;
+       /* we know which one to map */
+       intel->cap_frame = buf->index;
+       return  0;
+
+}
+
+static int intel_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+       struct video_device *dev = video_devdata(file);
+       struct intel_isp_device *intel = video_get_drvdata(dev);
+
+       DBG_DD(("+++ intel_qbuf, "));
+
+       if (buf->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+           buf->memory != V4L2_MEMORY_MMAP ||
+           buf->index >= intel->num_frames || buf->index < 0)
+               return -EINVAL;
+
+       if (intel->frame_queue.info[buf->index].state == S_QUEUED) {
+               DBG_DD(("%d buf is already queued\n", buf->index));
+               return -EINVAL;
+       }
+
+       DBG_DD(("bufid %d enqueue\n", buf->index));
+       buf->flags = 0;
+       intel->frame_queue.info[buf->index].state = S_QUEUED;
+       add_frame_to_queue(&intel->frame_queue, buf->index);
+       buf->flags |= V4L2_BUF_FLAG_QUEUED;
+       buf->flags &= ~V4L2_BUF_FLAG_DONE;
+       buf->flags |= intel->frame_queue.info[buf->index].flags;
+
+       return 0;
+
+}
+
+static int intel_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
+{
+       struct video_device *dev = video_devdata(file);
+       struct intel_isp_device *intel = video_get_drvdata(dev);
+       char *bufbase;
+       u16 vsize = 0;
+       u16 hsize = 0;
+       int ret;
+       struct ci_sensor_config *isi_sensorcfg;
+
+       if (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+               return -EINVAL;
+       if (b->memory != V4L2_MEMORY_MMAP)
+               return -EINVAL;
+
+       isi_sensorcfg = intel->sys_conf.isi_config;
+       (void)ci_sensor_res2size(isi_sensorcfg->res, &hsize, &vsize);
+       intel->cap_frame = remove_frame_from_queue(&intel->frame_queue);
+       b->index = intel->cap_frame;
+
+       if (intel->cap_frame < 0) {
+               if (file->f_flags & O_NONBLOCK) {;
+                       return -EAGAIN;
+               }
+               intel->cap_frame = 0;
+       }
+
+       if (intel->frame_queue.info[b->index].state != S_QUEUED) {
+               DBG_DD(("%d buf sate is not queued\n", b->index));
+               return -EINVAL;
+       }
+
+       DBG_DD(("bufid %d dequeue\n", intel->cap_frame));
+       bufbase = (char *)(intel->fbuffer+
+               intel->cap_frame * PAGE_ALIGN(intel->frame_size));
+
+       intel_update_marvinvfaddr(intel);
+       ci_isp_reset_interrupt_status();
+       ci_isp_mif_reset_offsets(CI_ISP_CFG_UPDATE_IMMEDIATE);
+
+       if (intel->pixelformat == V4L2_PIX_FMT_JPEG) {
+               DBG_DD(("jpeg path\n"));
+               ret = ci_isp_jpe_init_ex(intel->bufwidth, intel->bufheight,
+                       s_config.jpeg_enc_ratio, true);
+               if (ret != CI_STATUS_SUCCESS)
+                       return -EAGAIN;
+               if (ci_jpe_capture(CI_ISP_CFG_UPDATE_FRAME_SYNC) == 0)
+                       return -EINVAL;
+               intel->frame_size_used = ci_isp_mif_get_byte_cnt();
+       } else if (intel->pixelformat == INTEL_PIX_FMT_RAW08 ||
+               intel->pixelformat == INTEL_PIX_FMT_RAW10 ||
+               intel->pixelformat == INTEL_PIX_FMT_RAW12) {
+               DBG_DD(("raw path in dqbuf\n"));
+               ci_isp_start(1, CI_ISP_CFG_UPDATE_FRAME_SYNC);
+               ret = ci_isp_wait_for_frame_end();
+               if (ret != CI_STATUS_SUCCESS)
+                       return -EINVAL;
+               intel->frame_size_used = ci_isp_mif_get_byte_cnt();
+
+       } else {
+               /* reset interrupts and start Marvin for only one frame */
+               DBG_DD(("yuv/rgb path in dqbuf\n"));
+               ci_isp_start(1, CI_ISP_CFG_UPDATE_FRAME_SYNC);
+               DBG_DD(("finished ci_isp_start\n"));
+               (void)ci_isp_wait_for_frame_end();
+               intel->frame_size_used = ci_isp_mif_get_byte_cnt();
+       }
+
+       DBG_DD(("buffer in dqbuf, dst 0x%p, src 0x%p, size%dk\n",
+       bufbase, intel->capbuf, intel->frame_size_used/1024));
+
+       do_gettimeofday(&b->timestamp);
+
+       intel->frame_queue.info[b->index].state = S_DONE;
+       b->flags = V4L2_BUF_FLAG_MAPPED;
+       b->flags &= ~V4L2_BUF_FLAG_DONE;
+
+       if (intel->frame_size_used)
+               b->bytesused = intel->frame_size_used;
+       else
+               b->bytesused = intel->frame_size;
+       b->memory = V4L2_MEMORY_MMAP;
+       b->m.offset = intel->cap_frame * PAGE_ALIGN(intel->frame_size);
+       b->length = PAGE_ALIGN(intel->frame_size);
+       b->index = intel->cap_frame;
+       b->sequence = intel->field_count;
+
+       return 0;
+
+}
+
+static int intel_streamon(struct file *file, void *priv,
+                                       enum v4l2_buf_type type)
+{
+       struct video_device *dev = video_devdata(file);
+       struct intel_isp_device *intel = video_get_drvdata(dev);
+
+       if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE || !intel->fbuffer)
+               return -EINVAL;
+
+       intel->cap_frame = 0;
+       intel->state = S_STREAMING;
+       if (!intel->sys_conf.isp_hal_enable) {
+               DBG_DD(("v4l2 path enabled\n"));
+               ci_sensor_set_mode(intel->bufwidth, intel->bufheight);
+               intel_dpinitisi(&isi_config, &isi_caps);
+               intel_defcfg_all_load(&s_config, &isi_config);
+       } else
+               DBG_DD(("isp hal path enabled\n"));
+
+       intel_dpinitmrv(&intel->sys_conf);
+       intel_setup_viewfinder_path(intel, -1);
+       return 0;
+
+}
+
+static int intel_streamoff(struct file *file, void *priv,
+                                       enum v4l2_buf_type type)
+{
+       struct video_device *dev = video_devdata(file);
+       struct intel_isp_device *intel = video_get_drvdata(dev);
+       if (!intel->sys_conf.isp_hal_enable &&
+               (type != V4L2_BUF_TYPE_VIDEO_CAPTURE || !intel->fbuffer))
+               return -EINVAL;
+       intel->state = S_IDLE;
+       ci_isp_stop(CI_ISP_CFG_UPDATE_FRAME_SYNC);
+       init_frame_queue(&intel->frame_queue);
+       return 0;
+}
+
+static u32
+copy_sensor_config_from_user(struct ci_sensor_config *des,
+               struct ci_sensor_config *src)
+{
+       u32 ret = 0;
+       ret = copy_from_user((void *)des, (const void *)src,
+               sizeof(struct ci_sensor_config));
+       if (ret)
+               return -EFAULT;
+       return ret;
+}
+
+static u32
+copy_sensor_caps_from_user(struct ci_sensor_caps *des,
+               struct ci_sensor_caps *src)
+{
+       u32 ret = 0;
+       ret = copy_from_user((void *)des, (const void *)src,
+               sizeof(struct ci_sensor_caps));
+       if (ret)
+               return -EFAULT;
+       return ret;
+}
+
+static u32
+copy_isp_config_from_user(struct ci_isp_config *des,
+               struct ci_isp_config *src)
+{
+       u32 ret = 0;
+       ret = copy_from_user((void *)des, (const void *)src,
+               sizeof(struct ci_isp_config));
+       if (ret)
+               return -EFAULT;
+       return ret;
+}
+
+static int intel_set_cfg(struct file *file, void *priv,
+                                       struct ci_pl_system_config *arg)
+{
+       struct video_device *dev = video_devdata(file);
+       struct intel_isp_device *intel = video_get_drvdata(dev);
+
+       if (arg == NULL) {
+               printk(KERN_WARNING "NULL pointer in intel_set_cfg\n");
+               return 0;
+       }
+
+       DBG_DD(("intel_set_cfg ioctl,%d\n", arg->isp_hal_enable));
+
+       intel->sys_conf.isp_hal_enable = arg->isp_hal_enable;
+
+       if (intel->sys_conf.isp_hal_enable)
+               DBG_DD(("isp hal path\n"));
+
+       if (arg->isi_config != NULL) {
+               copy_sensor_config_from_user(intel->sys_conf.isi_config,
+                       arg->isi_config);
+       } else {
+               printk(KERN_WARNING "NULL sensor config pointer\n");
+               return CI_STATUS_NULL_POINTER;
+       }
+
+       if (arg->isi_caps != NULL) {
+               DBG_DD(("  sync isi caps\n"));
+               copy_sensor_caps_from_user(intel->sys_conf.isi_caps,
+                       arg->isi_caps);
+       } else {
+               printk(KERN_WARNING "NULL sensor caps pointer\n");
+               return CI_STATUS_NULL_POINTER;
+       }
+
+       if (arg->isp_cfg != NULL) {
+               DBG_DD(("sync isp cfg\n"));
+               copy_isp_config_from_user(intel->sys_conf.isp_cfg,
+                       arg->isp_cfg);
+       } else {
+               printk(KERN_WARNING "NULL isp config pointer\n");
+               return CI_STATUS_NULL_POINTER;
+       }
+
+       return 0;
+}
+
+/* for buffer sharing between CI and VA */
+static int intel_get_frame_info(struct file *file, void *priv,
+       struct ci_frame_info *arg)
+{
+       struct video_device *dev = video_devdata(file);
+       struct intel_isp_device *intel = video_get_drvdata(dev);
+
+       arg->width = intel->bufwidth;
+       arg->height = intel->bufheight;
+       arg->fourcc = intel->pixelformat;
+       arg->stride = intel->bufwidth; /* should be 64 bit alignment*/
+       arg->offset = arg->frame_id * PAGE_ALIGN(intel->frame_size);
+       DBG_DD(("w=%d, h=%d, 4cc =%x, stride=%d, offset=%d,fsize=%d\n",
+               arg->width, arg->height, arg->fourcc, arg->stride,
+               arg->offset, intel->frame_size));
+       return 0;
+
+}
+
+static int intel_set_jpg_enc_ratio(struct file *file, void *priv,
+       int *arg)
+{
+       DBG_DD(("set jpg compression ratio is %d\n", *arg));
+       s_config.jpeg_enc_ratio = *arg;
+       return 0;
+}
+
+/* intel private ioctl for libci  */
+static int intel_v4l2p_ioctl(struct file *file,
+       unsigned int cmd, void __user  *arg)
+{
+       void *priv = file->private_data;
+
+       switch (cmd) {
+
+       case VIDIOC_SET_SYS_CFG:
+               return intel_set_cfg(file, priv,
+                       (struct ci_pl_system_config *)arg);
+
+       case VIDIOC_SET_JPG_ENC_RATIO:
+               return intel_set_jpg_enc_ratio(file, priv, (int *)arg);
+
+       case ISP_IOCTL_GET_FRAME_INFO:
+               return intel_get_frame_info(file, priv,
+                       (struct ci_frame_info *)arg);
+
+       default:
+               return -EINVAL;
+       }
+}
+
+static long intel_ioctl_v4l2(struct file *file,
+                              unsigned int cmd, void __user  *arg)
+{
+       void *priv = file->private_data;
+
+       switch (cmd) {
+
+       case VIDIOC_QUERYCAP:
+               return intel_querycap(file, priv, arg);
+
+       case VIDIOC_ENUMINPUT:
+               return intel_enum_input(file, priv, arg);
+
+       case VIDIOC_G_INPUT:
+               return intel_g_input(file, priv, arg);
+
+       case VIDIOC_S_INPUT:
+               return 0;
+
+       case VIDIOC_QUERYCTRL:
+               return intel_queryctrl(file, priv, arg);
+
+       case VIDIOC_G_CTRL:
+               return intel_g_ctrl(file, priv, arg);
+
+       case VIDIOC_S_CTRL:
+               return intel_s_ctrl(file, priv, arg);
+
+       case VIDIOC_CROPCAP:
+               return intel_cropcap(file, priv, arg);
+
+       case VIDIOC_G_CROP:
+               return -EINVAL;
+
+       case VIDIOC_S_CROP:
+               return -EINVAL;
+
+       case VIDIOC_ENUM_FMT:
+               return intel_enum_fmt_cap(file, priv, arg);
+
+       case VIDIOC_G_FMT:
+               return intel_g_fmt_cap(file, priv, arg);
+
+       case VIDIOC_TRY_FMT:
+               return intel_try_fmt_cap(file, priv, arg);
+
+       case VIDIOC_S_FMT:
+               return intel_s_fmt_cap(file, priv, arg);
+
+       case VIDIOC_REQBUFS:
+               return intel_reqbufs(file, priv, arg);
+
+       case VIDIOC_QUERYBUF:
+               return intel_querybuf(file, priv, arg);
+
+       case VIDIOC_QBUF:
+               return intel_qbuf(file, priv, arg);
+
+       case VIDIOC_DQBUF:
+               return intel_dqbuf(file, priv, arg);
+
+       case VIDIOC_STREAMON:
+               return intel_streamon(file, priv, *(int *)arg);
+
+       case VIDIOC_STREAMOFF:
+               return intel_streamoff(file, priv, *(int *)arg);
+
+       case VIDIOC_S_STD:
+               return intel_s_std(file, priv, arg);
+
+       case VIDIOC_G_STD:
+       case VIDIOC_QUERYSTD:
+       case VIDIOC_ENUMSTD:
+       case VIDIOC_QUERYMENU:
+       case VIDIOC_ENUM_FRAMEINTERVALS:
+               return -EINVAL;
+
+       default:
+               return intel_v4l2p_ioctl(file, cmd, arg);
+       }
+}
+
+static long intel_ioctl(struct file *file,
+                        unsigned int cmd, unsigned long arg)
+{
+
+       return video_usercopy(file, cmd, arg, intel_ioctl_v4l2);
+}
+
+
+static const struct v4l2_file_operations intel_fops = {
+       .owner = THIS_MODULE,
+       .open = intel_open,
+       .release = intel_close,
+       .read = intel_read,
+       .mmap = intel_mmap,
+       .ioctl = intel_ioctl,
+};
+
+static const struct v4l2_ioctl_ops intel_ioctl_ops = {
+       .vidioc_querycap                = intel_querycap,
+       .vidioc_enum_fmt_vid_cap        = intel_enum_fmt_cap,
+       .vidioc_g_fmt_vid_cap           = intel_g_fmt_cap,
+       .vidioc_try_fmt_vid_cap         = intel_try_fmt_cap,
+       .vidioc_s_fmt_vid_cap           = intel_s_fmt_cap,
+       .vidioc_cropcap                 = intel_cropcap,
+       .vidioc_reqbufs                 = intel_reqbufs,
+       .vidioc_querybuf                = intel_querybuf,
+       .vidioc_qbuf                    = intel_qbuf,
+       .vidioc_dqbuf                   = intel_dqbuf,
+       .vidioc_enum_input              = intel_enum_input,
+       .vidioc_g_input                 = intel_g_input,
+       .vidioc_s_input                 = intel_s_input,
+       .vidioc_s_std                   = intel_s_std,
+       .vidioc_queryctrl               = intel_queryctrl,
+       .vidioc_streamon                = intel_streamon,
+       .vidioc_streamoff               = intel_streamoff,
+       .vidioc_g_ctrl                  = intel_g_ctrl,
+       .vidioc_s_ctrl                  = intel_s_ctrl,
+};
+
+static struct video_device intel_template = {
+       .name                           = "Moorestown Camera Imaging",
+       .minor                          = -1,
+       .fops                           = &intel_fops,
+       .ioctl_ops                      = &intel_ioctl_ops,
+       .release                        = video_device_release,
+};
+
+static void __devexit intel_pci_remove(struct pci_dev *pci_dev)
+{
+       struct intel_isp_device *intel = NULL;
+
+       if (pci_driver_loaded)
+               intel = &intel_isp_v4l_device;
+
+       pci_driver_loaded = 0;
+
+       if (intel->fbuffer)
+               vfree(intel->fbuffer);
+       intel->fbuffer = NULL;
+
+       if (intel->capbuf) {
+               if (intel->frame_size <= MAX_KMALLOC_MEM)
+                       kfree(intel->capbuf);
+               else
+                       iounmap(intel->capbuf);
+       }
+
+       intel->capbuf = NULL;
+
+       if (intel->regs)
+               iounmap(intel->regs);
+
+       intel->regs = NULL;
+
+       if (intel->mb1_va)
+               iounmap(intel->mb1_va);
+
+       intel->mb1_va = NULL;
+
+       video_unregister_device(intel->vdev);
+       DBG_DD((" Remove v4l device. interrupt_count=%ld\n",
+           intel->interrupt_count));
+       pci_release_regions(pci_dev);
+       if (!pci_driver_loaded)
+               pci_set_drvdata(pci_dev, NULL);
+
+}
+
+static int __devinit intel_pci_probe(struct pci_dev *dev,
+    const struct pci_device_id *pci_id)
+{
+       struct intel_isp_device *intel;
+       int ret = 0;
+       unsigned int start = 0;
+       unsigned int len = 0;
+       intel = &intel_isp_v4l_device;
+       g_intel = &intel_isp_v4l_device;
+       intel->pci_dev = dev;
+       intel->interrupt_count = 0;
+
+       if (pci_enable_device(dev) < 0) {
+               printk(KERN_INFO " can't enable device.\n");
+               return -EIO;
+       }
+
+       ret = pci_request_regions(dev, "intel_isp");
+       if (ret) {
+               DBG_DD(("failed to request I/O memory\n"));
+               return -EIO;
+       }
+
+       /* Determine the address of the I2C area */
+       start = intel->mb0 = pci_resource_start(dev, 0);
+       len = intel->mb0_size = pci_resource_len(dev, 0);
+
+       intel->regs = ioremap_nocache(start, len);
+       if (intel->regs == NULL) {
+               DBG_DD(("failed to ioremap\n"));
+               return -ENXIO;
+       }
+       DBG_DD((" mmio address: 0x%p, lenght=0x%lx\n",
+           intel->regs, intel->mb0_size));
+
+       /* mem base 1*/
+       start = intel->mb1 = pci_resource_start(dev, 1);
+       len = intel->mb1_size = pci_resource_len(dev, 1);
+       intel->mb1_va = ioremap_nocache(start, len);
+       if (intel->mb1_va == NULL) {
+               DBG_DD(("failed to ioremap\n"));
+               return -ENXIO;
+       }
+
+       DBG_DD((" mmio address: 0x%p, lenght=0x%lx\n",
+           intel->mb1_va, intel->mb1_size));
+
+       pci_read_config_word(dev, PCI_VENDOR_ID, &intel->vendorID);
+       pci_read_config_word(dev, PCI_DEVICE_ID, &intel->deviceID);
+
+
+       if (!pci_driver_loaded) {
+               pci_driver_loaded = 1;
+               pci_set_master(dev);
+               pci_set_drvdata(dev, intel);
+       }
+
+       g_intel->vdev = kmalloc(sizeof(struct video_device), GFP_KERNEL);
+       memcpy(intel->vdev, &intel_template, sizeof(intel_template));
+
+       intel->vdev->parent = &dev->dev;
+
+       printk(KERN_INFO "reset ISP hardware ...\n");
+       ci_isp_init();
+       printk(KERN_INFO "reset ISP hardware - done\n");
+       /* register v4l device */
+       video_set_drvdata(g_intel->vdev, g_intel);
+       if (video_register_device(intel->vdev, VFL_TYPE_GRABBER, video_nr)
+           == -1) {
+               printk(KERN_INFO "video_register_device failed\n");
+               return -1;
+       }
+
+       return 0;
+
+}
+
+static struct pci_device_id intel_isp_pci_tbl[] __devinitdata = {
+       { PCI_DEVICE(0x8086, 0x080B) },
+       {0,}
+};
+
+MODULE_DEVICE_TABLE(pci, intel_isp_pci_tbl);
+
+static struct pci_driver intel_isp_pci_driver = {
+       .name = "mrstisp",
+       .id_table = intel_isp_pci_tbl,
+       .probe = intel_pci_probe,
+       .remove = intel_pci_remove,
+};
+
+static int __init intel_pci_init(void)
+{
+       int ret = 0;
+       ret = pci_register_driver(&intel_isp_pci_driver);
+       if (ret) {
+               printk(KERN_ERR "Unable to register intel_isp_pci driver\n");
+               return ret;
+       }
+       return ret;
+}
+
+static void __exit intel_pci_exit(void)
+{
+       struct intel_isp_device *intel = NULL;
+       intel = &intel_isp_v4l_device;
+
+       DBG_DD((" v4l module cleanup.\n"));
+       pci_unregister_driver(&intel_isp_pci_driver);
+}
+
+module_init(intel_pci_init);
+module_exit(intel_pci_exit);
+
+MODULE_DESCRIPTION("mrstisp.ko - CI/V4L2 driver for Moorestown");
+MODULE_AUTHOR("Xiaolin Zhang <xiaolin.zhang@intel.com>");
+MODULE_LICENSE("GPL");
+MODULE_SUPPORTED_DEVICE("video");
+
+module_param(km_debug, int, 0);
+MODULE_PARM_DESC(km_debug, "debug level (default: 0)");
diff --git a/drivers/media/video/mrstci/mrstisp/mrv.c b/drivers/media/video/mrstci/mrstisp/mrv.c
new file mode 100644
index 0000000..4665a78
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/mrv.c
@@ -0,0 +1,442 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * Copyright (c) Silicon Image 2008  www.siliconimage.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#include "stdinc.h"
+#include "reg_access.h"
+#include "mrv_priv.h"
+
+#define CI_ISP_DELAY_AFTER_RESET 15
+
+static u32 ci_isp_get_ci_isp_id(void)
+{
+        struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 result = 0;
+
+       result = REG_GET_SLICE(mrv_reg->vi_id, MRV_REV_ID);
+
+       return result;
+}
+
+static int ci_isp_verify_chip_id(void)
+{
+       u32 mrv_id = ci_isp_get_ci_isp_id();
+       if (mrv_id != MARVIN_FEATURE_CHIP_ID) {
+               DBG_DD(("WARNING: Marvin HW-Id does not match! "
+                       "read:0x%08X, expected:0x%08X\n",
+                        mrv_id, MARVIN_FEATURE_CHIP_ID));
+               return CI_STATUS_FAILURE;
+       }
+       return CI_STATUS_SUCCESS;
+}
+
+void ci_isp_init(void)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+
+       (void)ci_isp_verify_chip_id();
+
+       REG_SET_SLICE(mrv_reg->vi_ccl, MRV_VI_CCLFDIS,
+                     MRV_VI_CCLFDIS_ENABLE);
+       REG_SET_SLICE(mrv_reg->vi_iccl, MRV_VI_ALL_CLK_ENABLE, ENABLE);
+       REG_SET_SLICE(mrv_reg->vi_ircl, MRV_VI_MARVIN_RST, ON);
+       intel_sleep_micro_sec(CI_ISP_DELAY_AFTER_RESET);
+
+}
+
+void ci_isp_off(void)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+
+       REG_SET_SLICE(mrv_reg->vi_ccl, MRV_VI_CCLFDIS,
+                     MRV_VI_CCLFDIS_DISABLE);
+       REG_SET_SLICE(mrv_reg->vi_iccl, MRV_VI_ALL_CLK_ENABLE, DISABLE);
+}
+
+static u32 ci_isp_get_frame_end_irq_mask_isp(void)
+{
+         struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+
+       switch (REG_GET_SLICE(mrv_reg->vi_dpcl, MRV_VI_DMA_SWITCH)) {
+       case MRV_VI_DMA_SWITCH_IE:
+               return 0;
+       case MRV_VI_DMA_SWITCH_SELF:
+       case MRV_VI_DMA_SWITCH_SI:
+       case MRV_VI_DMA_SWITCH_JPG:
+       default:
+       {
+               switch (REG_GET_SLICE
+                       (mrv_reg->vi_dpcl, MRV_VI_CHAN_MODE)) {
+               case MRV_VI_CHAN_MODE_MP:
+                       return MRV_MI_MP_FRAME_END_MASK;
+               case MRV_VI_CHAN_MODE_SP:
+                       return MRV_MI_SP_FRAME_END_MASK;
+               case MRV_VI_CHAN_MODE_MP_SP:
+                       return MRV_MI_MP_FRAME_END_MASK |
+                           MRV_MI_SP_FRAME_END_MASK;
+               default:
+                       return 0;
+               }
+       }
+       }
+
+}
+
+void ci_isp_start(u16 number_of_frames,
+       enum ci_isp_conf_update_time update_time)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 isp_ctrl = REG_READ(mrv_reg->isp_ctrl);
+       u32 eof_irq_mask = ci_isp_get_frame_end_irq_mask_isp();
+
+       /* max. 10 bits allowed */
+       ASSERT(number_of_frames <= MRV_ISP_ACQ_NR_FRAMES_MAX);
+
+       REG_SET_SLICE(mrv_reg->isp_acq_nr_frames, MRV_ISP_ACQ_NR_FRAMES,
+                     number_of_frames);
+       /* clear frame end interrupt */
+       REG_WRITE(mrv_reg->mi_icr, eof_irq_mask);
+
+       switch (update_time) {
+       case CI_ISP_CFG_UPDATE_FRAME_SYNC:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_GEN_CFG_UPD, ENABLE);
+               break;
+       case CI_ISP_CFG_UPDATE_IMMEDIATE:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_CFG_UPD, ENABLE);
+               break;
+       case CI_ISP_CFG_UPDATE_LATER:
+               break;
+       default:
+               break;
+       }
+       REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_INFORM_ENABLE, ENABLE);
+       REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_ENABLE, ENABLE);
+       REG_WRITE(mrv_reg->isp_ctrl, isp_ctrl);
+       DBG_DD(("xiaolin  ISP_CTRL  = 0x%08X\n", mrv_reg->isp_ctrl));
+}
+
+void ci_isp_stop(enum ci_isp_conf_update_time update_time)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 isp_ctrl = REG_READ(mrv_reg->isp_ctrl);
+       u32 eof_irq_mask = ci_isp_get_frame_end_irq_mask_isp();
+
+       /* clear frame end interrupt */
+       REG_WRITE(mrv_reg->mi_icr, eof_irq_mask);
+       /* disable output formatter */
+       REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_ENABLE, DISABLE);
+
+       switch (update_time) {
+       case CI_ISP_CFG_UPDATE_FRAME_SYNC:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_GEN_CFG_UPD, ENABLE);
+               break;
+       case CI_ISP_CFG_UPDATE_IMMEDIATE:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_CFG_UPD, ENABLE);
+               break;
+       case CI_ISP_CFG_UPDATE_LATER:
+               break;
+       default:
+               break;
+       }
+
+       REG_WRITE(mrv_reg->isp_ctrl, isp_ctrl);
+}
+
+int ci_isp_set_data_path(enum ci_isp_ycs_chn_mode ycs_chn_mode,
+                     enum ci_isp_dp_switch dp_switch)
+{
+         struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 vi_dpcl = REG_READ(mrv_reg->vi_dpcl);
+       u32 vi_chan_mode;
+       u32 vi_mp_mux;
+
+       switch (ycs_chn_mode) {
+       case CI_ISP_YCS_OFF:
+               vi_chan_mode = MRV_VI_CHAN_MODE_OFF;
+               break;
+       case CI_ISP_YCS_Y:
+               vi_chan_mode = MRV_VI_CHAN_MODE_Y;
+               break;
+       case CI_ISP_YCS_MVRaw:
+               vi_chan_mode = MRV_VI_CHAN_MODE_MP_RAW;
+               break;
+       case CI_ISP_YCS_MV:
+               vi_chan_mode = MRV_VI_CHAN_MODE_MP;
+               break;
+       case CI_ISP_YCS_SP:
+               vi_chan_mode = MRV_VI_CHAN_MODE_SP;
+               break;
+       case CI_ISP_YCS_MV_SP:
+               vi_chan_mode = MRV_VI_CHAN_MODE_MP_SP;
+               break;
+       default:
+               DBG_DD(("ci_isp_set_data_path: unknown value for "
+                       "enum ci_isp_ycs_chn_mode\n"));
+               return CI_STATUS_NOTSUPP;
+       }
+
+       if (vi_chan_mode &
+           ~(MRV_VI_CHAN_MODE_MASK >> MRV_VI_CHAN_MODE_SHIFT))
+               return CI_STATUS_NOTSUPP;
+
+       switch (dp_switch) {
+       case CI_ISP_DP_RAW:
+               vi_mp_mux = MRV_VI_MP_MUX_RAW;
+               break;
+       case CI_ISP_DP_JPEG:
+               vi_mp_mux = MRV_VI_MP_MUX_JPEG;
+               break;
+       case CI_ISP_DP_MV:
+               vi_mp_mux = MRV_VI_MP_MUX_MP;
+               break;
+       default:
+               DBG_DD((" unknown value for teDpSwitch\n"));
+               return CI_STATUS_NOTSUPP;
+       }
+
+       if (vi_mp_mux & ~MRV_VI_MP_MUX_MASK)
+               return CI_STATUS_NOTSUPP;
+
+       REG_SET_SLICE(vi_dpcl, MRV_VI_CHAN_MODE, vi_chan_mode);
+       REG_SET_SLICE(vi_dpcl, MRV_VI_MP_MUX, vi_mp_mux);
+       REG_WRITE(mrv_reg->vi_dpcl, vi_dpcl);
+
+       return CI_STATUS_SUCCESS;
+}
+
+int ci_isp_set_mipi_smia(u32 mode)
+{
+         struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 if_select;
+
+       switch (mode) {
+       case SENSOR_MODE_MIPI:
+               if_select = MRV_IF_SELECT_MIPI;
+               break;
+       case SENSOR_MODE_BAYER:
+       case SENSOR_MODE_BT601:
+       case SENSOR_MODE_BT656:
+       case SENSOR_MODE_PICT:
+       case SENSOR_MODE_DATA:
+       case SENSOR_MODE_BAY_BT656:
+       case SENSOR_MODE_RAW_BT656:
+               if_select = MRV_IF_SELECT_PAR;
+               break;
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+
+       /* program settings into MARVIN vi_dpcl register */
+       REG_SET_SLICE(mrv_reg->vi_dpcl, MRV_IF_SELECT, if_select);
+       return CI_STATUS_SUCCESS;
+}
+
+static int ci_isp_wait_for_mi(u32 bit_mask)
+{
+         struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+
+       intel_timer_start();
+
+       while ((mrv_reg->mi_ris & bit_mask) != bit_mask) {
+               if (intel_get_micro_sec() > 2000000) {
+                       intel_timer_stop();
+                       REG_SET_SLICE(mrv_reg->vi_ircl,
+                                     MRV_VI_ALL_SOFT_RST, ON);
+                       REG_SET_SLICE(mrv_reg->vi_ircl,
+                                     MRV_VI_ALL_SOFT_RST, OFF);
+                       intel_sleep_micro_sec(CI_ISP_DELAY_AFTER_RESET);
+                       REG_SET_SLICE(mrv_reg->isp_ctrl,
+                                     MRV_ISP_ISP_CFG_UPD, ON);
+                       return CI_STATUS_FAILURE;
+               }
+       }
+
+       intel_timer_stop();
+
+       if (REG_GET_SLICE(mrv_reg->isp_ris, MRV_ISP_RIS_DATA_LOSS)) {
+               DBG_DD(("WARN: *** no failure, "
+                       "but MRV_ISPINT_DATA_LOSS *** \n"));
+       }
+
+       return CI_STATUS_SUCCESS;
+}
+
+int ci_isp_wait_for_frame_end(void)
+{
+       return ci_isp_wait_for_mi(ci_isp_get_frame_end_irq_mask_isp());
+}
+
+void ci_isp_reset_interrupt_status(void)
+{
+         struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+
+       /* ISP interrupt clear register */
+       REG_SET_SLICE(mrv_reg->isp_icr, MRV_ISP_ICR_ALL, ON);
+       REG_SET_SLICE(mrv_reg->isp_err_clr, MRV_ISP_ALL_ERR, ON);
+       REG_SET_SLICE(mrv_reg->mi_icr, MRV_MI_ALLIRQS, ON);
+       /* JPEG error interrupt clear register */
+       REG_SET_SLICE(mrv_reg->jpe_error_icr, MRV_JPE_ALL_ERR, ON);
+       /* JPEG status interrupt clear register */
+       REG_SET_SLICE(mrv_reg->jpe_status_icr, MRV_JPE_ALL_STAT, ON);
+}
+
+void ci_isp_set_dma_read_mode(enum ci_isp_dma_read_mode mode,
+                      enum ci_isp_conf_update_time update_time)
+{
+         struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 vi_dma_switch = 0;
+       u32 vi_dma_spmux = 0;
+       u32 vi_dma_iemux = 0;
+       int dma_jpeg_select = false;
+
+#define DMA_READ_MODE_PROGRAMMING_VI_DPCL  1
+       ASSERT((mode == CI_ISP_DMA_RD_OFF) ||
+              (mode == CI_ISP_DMA_RD_SELF_PATH) ||
+              (mode == CI_ISP_DMA_RD_IE_PATH) ||
+              (mode == CI_ISP_DMA_RD_SUPERIMPOSE));
+
+       switch (mode) {
+       case CI_ISP_DMA_RD_OFF:
+               vi_dma_switch = MRV_VI_DMA_SWITCH_SELF;
+               vi_dma_spmux = MRV_VI_DMA_SPMUX_CAM;
+               vi_dma_iemux = MRV_VI_DMA_IEMUX_CAM;
+               dma_jpeg_select = false;
+               break;
+       case CI_ISP_DMA_RD_SELF_PATH:
+               vi_dma_switch = MRV_VI_DMA_SWITCH_SELF;
+               vi_dma_spmux = MRV_VI_DMA_SPMUX_DMA;
+               vi_dma_iemux = MRV_VI_DMA_IEMUX_CAM;
+               dma_jpeg_select = false;
+               break;
+       case CI_ISP_DMA_RD_IE_PATH:
+               vi_dma_switch = MRV_VI_DMA_SWITCH_IE;
+               vi_dma_spmux = MRV_VI_DMA_SPMUX_CAM;
+               vi_dma_iemux = MRV_VI_DMA_IEMUX_DMA;
+               dma_jpeg_select = false;
+               break;
+       case CI_ISP_DMA_RD_JPG_ENC:
+               vi_dma_switch = MRV_VI_DMA_SWITCH_JPG;
+               vi_dma_spmux = MRV_VI_DMA_SPMUX_CAM;
+               vi_dma_iemux = MRV_VI_DMA_IEMUX_CAM;
+               dma_jpeg_select = true;
+               break;
+       case CI_ISP_DMA_RD_SUPERIMPOSE:
+               vi_dma_switch = MRV_VI_DMA_SWITCH_SI;
+               vi_dma_spmux = MRV_VI_DMA_SPMUX_CAM;
+               vi_dma_iemux = MRV_VI_DMA_IEMUX_CAM;
+               dma_jpeg_select = false;
+               break;
+       default:
+               ASSERT(0);
+
+       }
+
+       {
+               u32 vi_dpcl = REG_READ(mrv_reg->vi_dpcl);
+
+               REG_SET_SLICE(vi_dpcl, MRV_VI_DMA_SWITCH, vi_dma_switch);
+               REG_SET_SLICE(vi_dpcl, MRV_VI_DMA_SPMUX, vi_dma_spmux);
+               REG_SET_SLICE(vi_dpcl, MRV_VI_DMA_IEMUX, vi_dma_iemux);
+#if ((MRV_VI_MP_MUX_JPGDIRECT & \
+      ~(MRV_VI_MP_MUX_MASK >> MRV_VI_MP_MUX_SHIFT)) == 0)
+               if (dma_jpeg_select) {
+                       REG_SET_SLICE(vi_dpcl, MRV_VI_MP_MUX,
+                                     MRV_VI_MP_MUX_JPGDIRECT);
+               }
+#else
+               UNUSED_PARAM(dma_jpeg_select);
+#endif
+               REG_WRITE(mrv_reg->vi_dpcl, vi_dpcl);
+       }
+}
+
+
+void ci_isp_set_ext_ycmode(void)
+{
+         struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 isp_ctrl = REG_READ(mrv_reg->isp_ctrl);
+
+       /* modify isp_ctrl register */
+       REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_CSM_C_RANGE,
+                     MRV_ISP_ISP_CSM_C_RANGE_FULL);
+       REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_CSM_Y_RANGE,
+                     MRV_ISP_ISP_CSM_Y_RANGE_FULL);
+       REG_WRITE(mrv_reg->isp_ctrl, isp_ctrl);
+
+       /* program RGB to YUV color conversion with extended range */
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_0, MRV_ISP_CC_COEFF_0,
+                     0x0026);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_1, MRV_ISP_CC_COEFF_1,
+                     0x004B);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_2, MRV_ISP_CC_COEFF_2,
+                     0x000F);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_3, MRV_ISP_CC_COEFF_3,
+                     0x01EA);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_4, MRV_ISP_CC_COEFF_4,
+                     0x01D6);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_5, MRV_ISP_CC_COEFF_5,
+                     0x0040);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_6, MRV_ISP_CC_COEFF_6,
+                     0x0040);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_7, MRV_ISP_CC_COEFF_7,
+                     0x01CA);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_8, MRV_ISP_CC_COEFF_8,
+                     0x01F6);
+}
+
+void ci_isp_set_yc_mode(void)
+{
+       struct isp_register *mrv_reg = (struct isp_register *)MEM_MRV_REG_BASE;
+       u32 isp_ctrl = REG_READ(mrv_reg->isp_ctrl);
+
+       /* modify isp_ctrl register */
+       REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_CSM_C_RANGE,
+               MRV_ISP_ISP_CSM_Y_RANGE_BT601);
+       REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_CSM_Y_RANGE,
+               MRV_ISP_ISP_CSM_Y_RANGE_BT601);
+       REG_WRITE(mrv_reg->isp_ctrl, isp_ctrl);
+
+       /* program RGB to YUV color conversion with extended range */
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_0, MRV_ISP_CC_COEFF_0, 0x0021);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_1, MRV_ISP_CC_COEFF_1, 0x0040);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_2, MRV_ISP_CC_COEFF_2, 0x000D);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_3, MRV_ISP_CC_COEFF_3, 0x01ED);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_4, MRV_ISP_CC_COEFF_4, 0x01DB);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_5, MRV_ISP_CC_COEFF_5, 0x0038);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_6, MRV_ISP_CC_COEFF_6, 0x0038);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_7, MRV_ISP_CC_COEFF_7, 0x01D1);
+       REG_SET_SLICE(mrv_reg->isp_cc_coeff_8, MRV_ISP_CC_COEFF_8, 0x01F7);
+}
diff --git a/drivers/media/video/mrstci/mrstisp/mrv_col.c b/drivers/media/video/mrstci/mrstisp/mrv_col.c
new file mode 100644
index 0000000..63bb40e
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/mrv_col.c
@@ -0,0 +1,66 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * Copyright (c) Silicon Image 2008  www.siliconimage.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#include "stdinc.h"
+#include "mrv_priv.h"
+
+void ci_isp_col_set_color_processing(
+       const struct ci_isp_color_settings *col)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+
+       if (col == NULL) {
+               /* disable color processing (bypass) */
+               mrv_reg->c_proc_ctrl = 0;
+       } else {
+               mrv_reg->c_proc_contrast = col->contrast;
+               mrv_reg->c_proc_brightness = col->brightness;
+               mrv_reg->c_proc_saturation = col->saturation;
+               mrv_reg->c_proc_hue = col->hue;
+
+               /* modify color processing registers */
+               if (col->flags & CI_ISP_CPROC_C_OUT_RANGE) {
+                       mrv_reg->c_proc_ctrl =
+                           mrv_reg->c_proc_ctrl | CI_ISP_CPROC_C_OUT_RANGE;
+               }
+
+               if (col->flags & CI_ISP_CPROC_Y_IN_RANGE) {
+                       mrv_reg->c_proc_ctrl =
+                           mrv_reg->c_proc_ctrl | CI_ISP_CPROC_Y_IN_RANGE;
+               }
+
+               if (col->flags & CI_ISP_CPROC_Y_OUT_RANGE) {
+                       mrv_reg->c_proc_ctrl =
+                           mrv_reg->c_proc_ctrl | CI_ISP_CPROC_Y_OUT_RANGE;
+               }
+
+               if (col->flags & CI_ISP_CPROC_ENABLE) {
+                       mrv_reg->c_proc_ctrl =
+                           mrv_reg->c_proc_ctrl | CI_ISP_CPROC_ENABLE;
+               }
+       }
+}
+
diff --git a/drivers/media/video/mrstci/mrstisp/mrv_ie.c b/drivers/media/video/mrstci/mrstisp/mrv_ie.c
new file mode 100644
index 0000000..5cb45fa
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/mrv_ie.c
@@ -0,0 +1,237 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * Copyright (c) Silicon Image 2008  www.siliconimage.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#include "stdinc.h"
+#include "reg_access.h"
+#include "mrv_priv.h"
+
+static u32 ci_isp_ie_tint_cx2_reg_val(u8 cx)
+{
+       s32 temp;
+       u32 reg_val;
+       temp = 128 - (s32) cx;
+       temp = ((temp * 64) / 110);
+       /* convert from two's complement to sign/value */
+       if (temp < 0) {
+               reg_val = 0x80;
+               temp *= (-1);
+       } else
+               reg_val = 0;
+       /* saturate at 7 bits */
+       if (temp > 0x7F)
+               temp = 0x7F;
+       /* combine sign and value to build the regiter value */
+       reg_val |= (u32) temp;
+
+       return reg_val;
+}
+
+static u32 ci_isp_ie_mx_dec2_reg_val(s8 dec)
+{
+       if (dec <= (-6)) {
+               /* equivlent to -8 */
+               return 0x0f;
+       } else if (dec <= (-3)) {
+               /* equivlent to -4 */
+               return 0x0e;
+       } else if (dec == (-2)) {
+               /* equivlent to -2 */
+               return 0x0d;
+       } else if (dec == (-1)) {
+               /* equivlent to -1 */
+               return 0x0c;
+       } else if (dec == 0) {
+               /* equivlent to 0 (entry not used) */
+               return 0x00;
+       } else if (dec == 1) {
+               /* equivlent to 1 */
+               return 0x08;
+       } else if (dec == 2) {
+               /* equivlent to 2 */
+               return 0x09;
+       } else if (dec < 6) {
+               /* equivlent to 4 */
+               return 0x0a;
+       } else {
+               /* equivlent to 8 */
+               return 0x0b;
+       }
+}
+
+int ci_isp_ie_set_config(const struct ci_isp_ie_config *ie_config)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+
+       if (!ie_config) {
+               /* just disable the module, i.e. put it in bypass mode */
+               REG_SET_SLICE(mrv_reg->img_eff_ctrl,
+                   MRV_IMGEFF_BYPASS_MODE,
+                   MRV_IMGEFF_BYPASS_MODE_BYPASS);
+       } else  {
+               u32 ul_ie_ctrl = REG_READ(mrv_reg->img_eff_ctrl);
+               u32 ul_ie_csel = REG_READ(mrv_reg->img_eff_color_sel);
+               u32 ul_ie_tint = REG_READ(mrv_reg->img_eff_tint);
+               u32 ul_ie_mat1 = REG_READ(mrv_reg->img_eff_mat_1);
+               u32 ul_ie_mat2 = REG_READ(mrv_reg->img_eff_mat_2);
+               u32 ul_ie_mat3 = REG_READ(mrv_reg->img_eff_mat_3);
+               u32 ul_ie_mat4 = REG_READ(mrv_reg->img_eff_mat_4);
+               u32 ul_ie_mat5 = REG_READ(mrv_reg->img_eff_mat_5);
+
+               /* overall operation mode */
+               switch (ie_config->mode) {
+               case CI_ISP_IE_MODE_OFF:
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_BYPASS_MODE,
+                           MRV_IMGEFF_BYPASS_MODE_BYPASS);
+                       break;
+               case CI_ISP_IE_MODE_GRAYSCALE:
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_EFFECT_MODE,
+                           MRV_IMGEFF_EFFECT_MODE_GRAY);
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_BYPASS_MODE,
+                           MRV_IMGEFF_BYPASS_MODE_PROCESS);
+                       break;
+               case CI_ISP_IE_MODE_NEGATIVE:
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_EFFECT_MODE,
+                           MRV_IMGEFF_EFFECT_MODE_NEGATIVE);
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_BYPASS_MODE,
+                           MRV_IMGEFF_BYPASS_MODE_PROCESS);
+                       break;
+               case CI_ISP_IE_MODE_SEPIA:
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_EFFECT_MODE,
+                           MRV_IMGEFF_EFFECT_MODE_SEPIA);
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_BYPASS_MODE,
+                           MRV_IMGEFF_BYPASS_MODE_PROCESS);
+                       break;
+               case CI_ISP_IE_MODE_COLOR_SEL:
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_EFFECT_MODE,
+                           MRV_IMGEFF_EFFECT_MODE_COLOR_SEL);
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_BYPASS_MODE,
+                           MRV_IMGEFF_BYPASS_MODE_PROCESS);
+                       break;
+               case CI_ISP_IE_MODE_EMBOSS:
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_EFFECT_MODE,
+                           MRV_IMGEFF_EFFECT_MODE_EMBOSS);
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_BYPASS_MODE,
+                           MRV_IMGEFF_BYPASS_MODE_PROCESS);
+                       break;
+               case CI_ISP_IE_MODE_SKETCH:
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_EFFECT_MODE,
+                           MRV_IMGEFF_EFFECT_MODE_SKETCH);
+                       REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_BYPASS_MODE,
+                           MRV_IMGEFF_BYPASS_MODE_PROCESS);
+                       break;
+               default:
+                       return CI_STATUS_OUTOFRANGE;
+               }
+
+               /* use next frame sync update */
+               REG_SET_SLICE(ul_ie_ctrl, MRV_IMGEFF_CFG_UPD, ON);
+
+               /* color selection settings */
+               REG_SET_SLICE(ul_ie_csel, MRV_IMGEFF_COLOR_THRESHOLD,
+                   (u32) (ie_config->color_thres));
+               REG_SET_SLICE(ul_ie_csel, MRV_IMGEFF_COLOR_SELECTION,
+                   (u32) (ie_config->color_sel));
+
+               /* tint color settings */
+               REG_SET_SLICE(ul_ie_tint, MRV_IMGEFF_INCR_CB,
+                   ci_isp_ie_tint_cx2_reg_val(ie_config->tint_cb));
+               REG_SET_SLICE(ul_ie_tint, MRV_IMGEFF_INCR_CR,
+                   ci_isp_ie_tint_cx2_reg_val(ie_config->tint_cr));
+
+               /* matrix coefficients */
+               REG_SET_SLICE(ul_ie_mat1, MRV_IMGEFF_EMB_COEF_11_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
+                   coeff_11));
+               REG_SET_SLICE(ul_ie_mat1, MRV_IMGEFF_EMB_COEF_12_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
+                   coeff_12));
+               REG_SET_SLICE(ul_ie_mat1, MRV_IMGEFF_EMB_COEF_13_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
+                   coeff_13));
+               REG_SET_SLICE(ul_ie_mat1, MRV_IMGEFF_EMB_COEF_21_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
+                   coeff_21));
+               REG_SET_SLICE(ul_ie_mat2, MRV_IMGEFF_EMB_COEF_22_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
+                   coeff_22));
+               REG_SET_SLICE(ul_ie_mat2, MRV_IMGEFF_EMB_COEF_23_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
+                   coeff_23));
+               REG_SET_SLICE(ul_ie_mat2, MRV_IMGEFF_EMB_COEF_31_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
+                   coeff_31));
+               REG_SET_SLICE(ul_ie_mat2, MRV_IMGEFF_EMB_COEF_32_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
+                   coeff_32));
+               REG_SET_SLICE(ul_ie_mat3, MRV_IMGEFF_EMB_COEF_33_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_emboss.
+                   coeff_33));
+               REG_SET_SLICE(ul_ie_mat3, MRV_IMGEFF_SKET_COEF_11_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
+                   coeff_11));
+               REG_SET_SLICE(ul_ie_mat3, MRV_IMGEFF_SKET_COEF_12_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
+                   coeff_12));
+               REG_SET_SLICE(ul_ie_mat3, MRV_IMGEFF_SKET_COEF_13_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
+                   coeff_13));
+               REG_SET_SLICE(ul_ie_mat4, MRV_IMGEFF_SKET_COEF_21_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
+                   coeff_21));
+               REG_SET_SLICE(ul_ie_mat4, MRV_IMGEFF_SKET_COEF_22_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
+                   coeff_22));
+               REG_SET_SLICE(ul_ie_mat4, MRV_IMGEFF_SKET_COEF_23_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
+                   coeff_23));
+               REG_SET_SLICE(ul_ie_mat4, MRV_IMGEFF_SKET_COEF_31_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
+                   coeff_31));
+               REG_SET_SLICE(ul_ie_mat5, MRV_IMGEFF_SKET_COEF_32_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
+                   coeff_32));
+               REG_SET_SLICE(ul_ie_mat5, MRV_IMGEFF_SKET_COEF_33_4,
+                   ci_isp_ie_mx_dec2_reg_val(ie_config->mat_sketch.
+                   coeff_33));
+
+               /* write changed values back to registers */
+               REG_WRITE(mrv_reg->img_eff_ctrl, ul_ie_ctrl);
+               REG_WRITE(mrv_reg->img_eff_color_sel, ul_ie_csel);
+               REG_WRITE(mrv_reg->img_eff_tint, ul_ie_tint);
+               REG_WRITE(mrv_reg->img_eff_mat_1, ul_ie_mat1);
+               REG_WRITE(mrv_reg->img_eff_mat_2, ul_ie_mat2);
+               REG_WRITE(mrv_reg->img_eff_mat_3, ul_ie_mat3);
+               REG_WRITE(mrv_reg->img_eff_mat_4, ul_ie_mat4);
+               REG_WRITE(mrv_reg->img_eff_mat_5, ul_ie_mat5);
+
+               /* frame synchronous update of shadow registers */
+               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_GEN_CFG_UPD,
+                   ON);
+       }
+
+       return CI_STATUS_SUCCESS;
+}
+
diff --git a/drivers/media/video/mrstci/mrstisp/mrv_is.c b/drivers/media/video/mrstci/mrstisp/mrv_is.c
new file mode 100644
index 0000000..0414b03
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/mrv_is.c
@@ -0,0 +1,66 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * Copyright (c) Silicon Image 2008  www.siliconimage.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+#include "stdinc.h"
+#include "reg_access.h"
+#include "mrv_priv.h"
+
+int ci_isp_is_set_config(const struct ci_isp_is_config *is_config)
+{
+
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+
+       if (!is_config) {
+               DBG_OUT((DERR, "ci_isp_is_set_config: is_config == NULL\n"));
+               return CI_STATUS_NULL_POINTER;
+       }
+       if (is_config->max_dx > MRV_IS_IS_MAX_DX_MAX) {
+               REG_SET_SLICE(mrv_reg->isp_is_max_dx, MRV_IS_IS_MAX_DX,
+                             (u32) (MRV_IS_IS_MAX_DX_MAX));
+       } else {
+               REG_SET_SLICE(mrv_reg->isp_is_max_dx, MRV_IS_IS_MAX_DX,
+                             (u32) (is_config->max_dx));
+       }
+
+       if (is_config->max_dy > MRV_IS_IS_MAX_DY_MAX) {
+               REG_SET_SLICE(mrv_reg->isp_is_max_dy, MRV_IS_IS_MAX_DY,
+                             (u32) (MRV_IS_IS_MAX_DY_MAX));
+       } else {
+               REG_SET_SLICE(mrv_reg->isp_is_max_dy, MRV_IS_IS_MAX_DY,
+                             (u32) (is_config->max_dy));
+       }
+
+       REG_SET_SLICE(mrv_reg->isp_is_h_offs, MRV_IS_IS_H_OFFS,
+                     (u32) (is_config->mrv_is_window.hoffs));
+       REG_SET_SLICE(mrv_reg->isp_is_v_offs, MRV_IS_IS_V_OFFS,
+                     (u32) (is_config->mrv_is_window.voffs));
+       REG_SET_SLICE(mrv_reg->isp_is_h_size, MRV_IS_IS_H_SIZE,
+                     (u32) (is_config->mrv_is_window.hsize));
+       REG_SET_SLICE(mrv_reg->isp_is_v_size, MRV_IS_IS_V_SIZE,
+                     (u32) (is_config->mrv_is_window.vsize));
+       return CI_STATUS_SUCCESS;
+}
+
+
diff --git a/drivers/media/video/mrstci/mrstisp/mrv_isp.c b/drivers/media/video/mrstci/mrstisp/mrv_isp.c
new file mode 100644
index 0000000..989cd8d
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/mrv_isp.c
@@ -0,0 +1,1433 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * Copyright (c) Silicon Image 2008  www.siliconimage.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#include "stdinc.h"
+#include "reg_access.h"
+#include "mrv_priv.h"
+
+enum ci_isp_path ci_isp_select_path(const struct ci_sensor_config *isi_cfg,
+                            u8 *words_per_pixel)
+{
+       u8 words;
+       enum ci_isp_path ret_val;
+
+       switch (isi_cfg->mode) {
+       case SENSOR_MODE_DATA:
+               ret_val = CI_ISP_PATH_RAW;
+               words = 1;
+               break;
+       case SENSOR_MODE_PICT:
+               ret_val = CI_ISP_PATH_RAW;
+               words = 1;
+               break;
+       case SENSOR_MODE_RGB565:
+               ret_val = CI_ISP_PATH_RAW;
+               words = 2;
+               break;
+       case SENSOR_MODE_BT601:
+               ret_val = CI_ISP_PATH_YCBCR;
+               words = 2;
+               break;
+       case SENSOR_MODE_BT656:
+               ret_val = CI_ISP_PATH_YCBCR;
+               words = 2;
+               break;
+       case SENSOR_MODE_BAYER:
+               ret_val = CI_ISP_PATH_BAYER;
+               words = 1;
+               break;
+
+       case SENSOR_MODE_MIPI:
+               switch (isi_cfg->mipi_mode) {
+               case SENSOR_MIPI_MODE_RAW_12:
+               case SENSOR_MIPI_MODE_RAW_10:
+               case SENSOR_MIPI_MODE_RAW_8:
+                       ret_val = CI_ISP_PATH_BAYER;
+                       words = 1;
+                       break;
+               case SENSOR_MIPI_MODE_YUV422_8:
+               case SENSOR_MIPI_MODE_YUV422_10:
+                       ret_val = CI_ISP_PATH_YCBCR;
+                       words = 2;
+                       break;
+               case SENSOR_MIPI_MODE_YUV420_8:
+               case SENSOR_MIPI_MODE_YUV420_10:
+               case SENSOR_MIPI_MODE_LEGACY_YUV420_8:
+               case SENSOR_MIPI_MODE_YUV420_CSPS_8:
+               case SENSOR_MIPI_MODE_YUV420_CSPS_10:
+               case SENSOR_MIPI_MODE_RGB444:
+               case SENSOR_MIPI_MODE_RGB555:
+               case SENSOR_MIPI_MODE_RGB565:
+               case SENSOR_MIPI_MODE_RGB666:
+               case SENSOR_MIPI_MODE_RGB888:
+               case SENSOR_MIPI_MODE_RAW_7:
+               case SENSOR_MIPI_MODE_RAW_6:
+               default:
+                       ret_val = CI_ISP_PATH_RAW;
+                       words = 1;
+                       break;
+               }
+               break;
+       case SENSOR_MODE_BAY_BT656:
+               ret_val = CI_ISP_PATH_BAYER;
+               words = 1;
+               break;
+       case SENSOR_MODE_RAW_BT656:
+               ret_val = CI_ISP_PATH_RAW;
+               words = 1;
+               break;
+       default:
+               ret_val = CI_ISP_PATH_UNKNOWN;
+               words = 1;
+       }
+
+       if (words_per_pixel)
+               *words_per_pixel = words ;
+       return ret_val;
+}
+
+int ci_isp_set_input_aquisition(const struct ci_sensor_config *isi_cfg)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 isp_ctrl = REG_READ(mrv_reg->isp_ctrl);
+       u32 isp_acq_prop = REG_READ(mrv_reg->isp_acq_prop);
+       u8 sample_factor;
+       u8 black_lines;
+
+
+       if (ci_isp_select_path(isi_cfg, &sample_factor) ==
+               CI_ISP_PATH_UNKNOWN) {
+               DBG_DD(("failed to select path\n"));
+               return CI_STATUS_NOTSUPP;
+       }
+
+       switch (isi_cfg->mode) {
+       case SENSOR_MODE_DATA:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
+                             MRV_ISP_ISP_MODE_DATA);
+               break;
+       case SENSOR_MODE_PICT:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
+                             MRV_ISP_ISP_MODE_RAW);
+               break;
+       case SENSOR_MODE_RGB565:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
+                             MRV_ISP_ISP_MODE_RAW);
+               break;
+       case SENSOR_MODE_BT601:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
+                             MRV_ISP_ISP_MODE_601);
+               break;
+       case SENSOR_MODE_BT656:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
+                             MRV_ISP_ISP_MODE_656);
+               break;
+       case SENSOR_MODE_BAYER:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
+                             MRV_ISP_ISP_MODE_RGB);
+               break;
+       case SENSOR_MODE_BAY_BT656:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
+                             MRV_ISP_ISP_MODE_RGB656);
+               break;
+       case SENSOR_MODE_RAW_BT656:
+               REG_SET_SLICE(isp_ctrl, MRV_ISP_ISP_MODE,
+                             MRV_ISP_ISP_MODE_RAW656);
+               break;
+
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+
+       switch (isi_cfg->bus_width) {
+       case SENSOR_BUSWIDTH_12BIT:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_INPUT_SELECTION,
+                             MRV_ISP_INPUT_SELECTION_12EXT);
+               break;
+       case SENSOR_BUSWIDTH_10BIT_ZZ:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_INPUT_SELECTION,
+                             MRV_ISP_INPUT_SELECTION_10ZERO);
+               break;
+       case SENSOR_BUSWIDTH_10BIT_EX:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_INPUT_SELECTION,
+                             MRV_ISP_INPUT_SELECTION_10MSB);
+               break;
+       case SENSOR_BUSWIDTH_8BIT_ZZ:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_INPUT_SELECTION,
+                             MRV_ISP_INPUT_SELECTION_8ZERO);
+               break;
+       case SENSOR_BUSWIDTH_8BIT_EX:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_INPUT_SELECTION,
+                             MRV_ISP_INPUT_SELECTION_8MSB);
+               break;
+
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+
+
+       switch (isi_cfg->field_sel) {
+       case SENSOR_FIELDSEL_ODD:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_FIELD_SELECTION,
+                             MRV_ISP_FIELD_SELECTION_ODD);
+               break;
+       case SENSOR_FIELDSEL_EVEN:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_FIELD_SELECTION,
+                             MRV_ISP_FIELD_SELECTION_EVEN);
+               break;
+       case SENSOR_FIELDSEL_BOTH:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_FIELD_SELECTION,
+                             MRV_ISP_FIELD_SELECTION_BOTH);
+               break;
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+
+       switch (isi_cfg->ycseq) {
+       case SENSOR_YCSEQ_CRYCBY:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_CCIR_SEQ,
+                             MRV_ISP_CCIR_SEQ_CRYCBY);
+               break;
+       case SENSOR_YCSEQ_CBYCRY:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_CCIR_SEQ,
+                             MRV_ISP_CCIR_SEQ_CBYCRY);
+               break;
+       case SENSOR_YCSEQ_YCRYCB:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_CCIR_SEQ,
+                             MRV_ISP_CCIR_SEQ_YCRYCB);
+               break;
+       case SENSOR_YCSEQ_YCBYCR:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_CCIR_SEQ,
+                             MRV_ISP_CCIR_SEQ_YCBYCR);
+               break;
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+
+       switch (isi_cfg->conv422) {
+       case SENSOR_CONV422_INTER:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_CONV_422,
+                       MRV_ISP_CONV_422_INTER);
+               break;
+
+       case SENSOR_CONV422_NOCOSITED:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_CONV_422,
+                     MRV_ISP_CONV_422_NONCO);
+               break;
+       case SENSOR_CONV422_COSITED:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_CONV_422,
+                     MRV_ISP_CONV_422_CO);
+               break;
+       default:
+       return CI_STATUS_NOTSUPP;
+       }
+
+       switch (isi_cfg->bpat) {
+       case SENSOR_BPAT_BGBGGRGR:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_BAYER_PAT,
+                     MRV_ISP_BAYER_PAT_BG);
+               break;
+       case SENSOR_BPAT_GBGBRGRG:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_BAYER_PAT,
+                     MRV_ISP_BAYER_PAT_GB);
+               break;
+       case SENSOR_BPAT_GRGRBGBG:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_BAYER_PAT,
+                     MRV_ISP_BAYER_PAT_GR);
+               break;
+       case SENSOR_BPAT_RGRGGBGB:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_BAYER_PAT,
+                     MRV_ISP_BAYER_PAT_RG);
+               break;
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+
+       switch (isi_cfg->vpol) {
+       case SENSOR_VPOL_POS:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_VSYNC_POL, 1);
+               break;
+       case SENSOR_VPOL_NEG:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_VSYNC_POL, 0);
+               break;
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+
+       switch (isi_cfg->hpol) {
+       case SENSOR_HPOL_SYNCPOS:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_HSYNC_POL, 1);
+               break;
+       case SENSOR_HPOL_SYNCNEG:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_HSYNC_POL, 0);
+               break;
+       case SENSOR_HPOL_REFPOS:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_HSYNC_POL, 0);
+               break;
+       case SENSOR_HPOL_REFNEG:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_HSYNC_POL, 1);
+               break;
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+
+       switch (isi_cfg->edge) {
+       case SENSOR_EDGE_RISING:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_SAMPLE_EDGE, 1);
+               break;
+       case SENSOR_EDGE_FALLING:
+               REG_SET_SLICE(isp_acq_prop, MRV_ISP_SAMPLE_EDGE, 0);
+               break;
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+
+       /* now write values to registers */
+       REG_WRITE(mrv_reg->isp_ctrl, isp_ctrl);
+       REG_WRITE(mrv_reg->isp_acq_prop, isp_acq_prop);
+
+       switch (isi_cfg->bls) {
+       case SENSOR_BLS_OFF:
+               black_lines = 0;
+               break;
+       case SENSOR_BLS_TWO_LINES:
+               black_lines = 2;
+               break;
+       case SENSOR_BLS_FOUR_LINES:
+               black_lines = 4;
+               break;
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+
+       REG_SET_SLICE(mrv_reg->isp_acq_h_offs, MRV_ISP_ACQ_H_OFFS,
+                     0 * sample_factor);
+       REG_SET_SLICE(mrv_reg->isp_acq_v_offs, MRV_ISP_ACQ_V_OFFS, 0);
+
+       switch (isi_cfg->res) {
+       /* 88x72 */
+       case SENSOR_RES_QQCIF:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             QQCIF_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QQCIF_SIZE_V + black_lines);
+               break;
+       /* 160x120 */
+       case SENSOR_RES_QQVGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             QQVGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QQVGA_SIZE_V + black_lines);
+               break;
+       /* 176x144 */
+       case SENSOR_RES_QCIF:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             QCIF_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QCIF_SIZE_V + black_lines);
+               break;
+       /* 320x240 */
+       case SENSOR_RES_QVGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             QVGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QVGA_SIZE_V + black_lines);
+               break;
+       /* 352x288 */
+       case SENSOR_RES_CIF:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             CIF_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             CIF_SIZE_V + black_lines);
+               break;
+       /* 640x480 */
+       case SENSOR_RES_VGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             VGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             VGA_SIZE_V + black_lines);
+               break;
+       /* 800x600 */
+       case SENSOR_RES_SVGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             SVGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             SVGA_SIZE_V + black_lines);
+               break;
+       /* 1024x768 */
+       case SENSOR_RES_XGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             XGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             XGA_SIZE_V + black_lines);
+               break;
+       case SENSOR_RES_720P:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             RES_720P_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             RES_720P_SIZE_V + black_lines);
+               break;
+       /* 1280x960 */
+       case SENSOR_RES_XGA_PLUS:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             XGA_PLUS_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             XGA_PLUS_SIZE_V + black_lines);
+               break;
+       /* 1280x1024 */
+       case SENSOR_RES_SXGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             SXGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             SXGA_SIZE_V + black_lines);
+               break;
+       /* 1600x1200 */
+       case SENSOR_RES_UXGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             QSVGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QSVGA_SIZE_V + black_lines);
+               break;
+       /* 1920x1280 */
+       case SENSOR_RES_1080P:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             1920 * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             1080 + black_lines);
+               break;
+       /* 2048x1536 */
+       case SENSOR_RES_QXGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             QXGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QXGA_SIZE_V + black_lines);
+               break;
+       /* 2586x2048 */
+       case SENSOR_RES_QSXGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             QSXGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QSXGA_SIZE_V + black_lines);
+               break;
+       /* 2600x2048 */
+       case SENSOR_RES_QSXGA_PLUS:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             QSXGA_PLUS_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QSXGA_PLUS_SIZE_V + black_lines);
+               break;
+       /* 2600x1950 */
+       case SENSOR_RES_QSXGA_PLUS2:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             QSXGA_PLUS2_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QSXGA_PLUS2_SIZE_V + black_lines);
+               break;
+       /* 2686x2048,  5.30M */
+       case SENSOR_RES_QSXGA_PLUS3:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             QSXGA_PLUS3_SIZE_V * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QSXGA_PLUS3_SIZE_V + black_lines);
+               break;
+       /* 2592*1944 5M */
+       case SENSOR_RES_QXGA_PLUS:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                               QXGA_PLUS_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QXGA_PLUS_SIZE_V + black_lines);
+               break;
+       /* 3200x2048,  6.56M */
+       case SENSOR_RES_WQSXGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             WQSXGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             WQSXGA_SIZE_V + black_lines);
+               break;
+       /* 3200x2400,  7.68M */
+       case SENSOR_RES_QUXGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             QUXGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             QUXGA_SIZE_V + black_lines);
+               break;
+       /* 3840x2400,  9.22M */
+       case SENSOR_RES_WQUXGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             WQUXGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             WQUXGA_SIZE_V + black_lines);
+               break;
+       /* 4096x3072, 12.59M */
+       case SENSOR_RES_HXGA:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             HXGA_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             HXGA_SIZE_V + black_lines);
+               break;
+       /* 4080x1024 */
+       case SENSOR_RES_YUV_HMAX:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             YUV_HMAX_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             YUV_HMAX_SIZE_V);
+               break;
+       /* 1024x4080 */
+       case SENSOR_RES_YUV_VMAX:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             YUV_VMAX_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             YUV_VMAX_SIZE_V);
+               break;
+       /* 4096x2048 */
+       case SENSOR_RES_RAWMAX:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             RAWMAX_SIZE_H);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             RAWMAX_SIZE_V);
+               break;
+       /* 352x240 */
+       case SENSOR_RES_BP1:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             BP1_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             BP1_SIZE_V);
+               break;
+       /* 720x480 */
+       case SENSOR_RES_L_AFM:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             L_AFM_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             L_AFM_SIZE_V);
+               break;
+       /* 128x96 */
+       case SENSOR_RES_M_AFM:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             M_AFM_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             M_AFM_SIZE_V);
+               break;
+       /* 64x32 */
+       case SENSOR_RES_S_AFM:
+               REG_SET_SLICE(mrv_reg->isp_acq_h_size, MRV_ISP_ACQ_H_SIZE,
+                             S_AFM_SIZE_H * sample_factor);
+               REG_SET_SLICE(mrv_reg->isp_acq_v_size, MRV_ISP_ACQ_V_SIZE,
+                             S_AFM_SIZE_V);
+               break;
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+
+       return CI_STATUS_SUCCESS;
+}
+
+void ci_isp_set_output_formatter(const struct ci_isp_window *window,
+                             enum ci_isp_conf_update_time update_time)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       if (window) {
+               REG_SET_SLICE(mrv_reg->isp_out_h_offs, MRV_IS_IS_H_OFFS,
+                       window->hoffs);
+               REG_SET_SLICE(mrv_reg->isp_out_v_offs, MRV_IS_IS_V_OFFS,
+                       window->voffs);
+               REG_SET_SLICE(mrv_reg->isp_out_h_size, MRV_IS_IS_H_SIZE,
+                       window->hsize);
+               REG_SET_SLICE(mrv_reg->isp_out_v_size, MRV_IS_IS_V_SIZE,
+                       window->vsize);
+               REG_SET_SLICE(mrv_reg->isp_is_h_offs, MRV_IS_IS_H_OFFS, 0);
+               REG_SET_SLICE(mrv_reg->isp_is_v_offs, MRV_IS_IS_V_OFFS, 0);
+               REG_SET_SLICE(mrv_reg->isp_is_h_size, MRV_IS_IS_H_SIZE,
+                       window->hsize);
+               REG_SET_SLICE(mrv_reg->isp_is_v_size, MRV_IS_IS_V_SIZE,
+                       window->vsize);
+
+               switch (update_time) {
+               case CI_ISP_CFG_UPDATE_FRAME_SYNC:
+                       REG_SET_SLICE(mrv_reg->isp_ctrl,
+                               MRV_ISP_ISP_GEN_CFG_UPD, ON);
+                       break;
+               case CI_ISP_CFG_UPDATE_IMMEDIATE:
+                       REG_SET_SLICE(mrv_reg->isp_ctrl,
+                               MRV_ISP_ISP_CFG_UPD, ON);
+                       break;
+               case CI_ISP_CFG_UPDATE_LATER:
+                       break;
+               default:
+                       break;
+               }
+       }
+}
+
+void ci_isp_set_demosaic(enum ci_isp_demosaic_mode demosaic_mode,
+       u8 demosaic_th)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 isp_demosaic = REG_READ(mrv_reg->isp_demosaic);
+
+       switch (demosaic_mode) {
+       case CI_ISP_DEMOSAIC_STANDARD:
+               REG_SET_SLICE(isp_demosaic, MRV_ISP_DEMOSAIC_MODE,
+                       MRV_ISP_DEMOSAIC_MODE_STD);
+               break;
+       case CI_ISP_DEMOSAIC_ENHANCED:
+               REG_SET_SLICE(isp_demosaic, MRV_ISP_DEMOSAIC_MODE,
+                       MRV_ISP_DEMOSAIC_MODE_ENH);
+               break;
+       default:
+               ASSERT(false);
+       }
+
+       REG_SET_SLICE(isp_demosaic, MRV_ISP_DEMOSAIC_TH, demosaic_th);
+       REG_WRITE(mrv_reg->isp_demosaic, isp_demosaic);
+}
+
+static int ci_isp_afm_wnd2_regs(const struct ci_isp_window *wnd, u32 *lt,
+                               u32 *rb)
+{
+       ASSERT((wnd != NULL) && (lt != NULL) && (rb != NULL));
+
+       if (wnd->hsize && wnd->vsize) {
+               u32 left = wnd->hoffs;
+               u32 top = wnd->voffs;
+               u32 right = left + wnd->hsize - 1;
+               u32 bottom = top + wnd->vsize - 1;
+
+               if ((left < MRV_AFM_A_H_L_MIN)
+                   || (left > MRV_AFM_A_H_L_MAX)
+                   || (top < MRV_AFM_A_V_T_MIN)
+                   || (top > MRV_AFM_A_V_T_MAX)
+                   || (right < MRV_AFM_A_H_R_MIN)
+                   || (right > MRV_AFM_A_H_R_MAX)
+                   || (bottom < MRV_AFM_A_V_B_MIN)
+                   || (bottom > MRV_AFM_A_V_B_MAX)) {
+                       return CI_STATUS_OUTOFRANGE;
+               }
+
+               REG_SET_SLICE(*lt, MRV_AFM_A_H_L, left);
+               REG_SET_SLICE(*lt, MRV_AFM_A_V_T, top);
+               REG_SET_SLICE(*rb, MRV_AFM_A_H_R, right);
+               REG_SET_SLICE(*rb, MRV_AFM_A_V_B, bottom);
+       } else {
+               *lt = 0;
+               *rb = 0;
+       }
+
+       return CI_STATUS_SUCCESS;
+}
+
+int ci_isp_set_auto_focus(const struct ci_isp_af_config *af_config)
+{
+
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 result = CI_STATUS_SUCCESS;
+
+       REG_SET_SLICE(mrv_reg->isp_afm_ctrl, MRV_AFM_AFM_EN, DISABLE);
+
+       if (af_config) {
+               u32 lt;
+               u32 rb;
+               result = ci_isp_afm_wnd2_regs(&(af_config->wnd_pos_a),
+                       &lt, &rb);
+               if (result != CI_STATUS_SUCCESS)
+                       return result;
+
+               REG_WRITE(mrv_reg->isp_afm_lt_a, lt);
+               REG_WRITE(mrv_reg->isp_afm_rb_a, rb);
+
+               result = ci_isp_afm_wnd2_regs(&(af_config->wnd_pos_b),
+                                       &lt, &rb);
+
+               if (result != CI_STATUS_SUCCESS)
+                       return result;
+
+               REG_WRITE(mrv_reg->isp_afm_lt_b, lt);
+               REG_WRITE(mrv_reg->isp_afm_rb_b, rb);
+
+               result = ci_isp_afm_wnd2_regs(&(af_config->wnd_pos_c),
+                                       &lt, &rb);
+
+               if (result != CI_STATUS_SUCCESS)
+                       return result;
+
+               REG_WRITE(mrv_reg->isp_afm_lt_c, lt);
+               REG_WRITE(mrv_reg->isp_afm_rb_c, rb);
+
+               REG_SET_SLICE(mrv_reg->isp_afm_thres, MRV_AFM_AFM_THRES,
+                       af_config->threshold);
+
+               REG_SET_SLICE(mrv_reg->isp_afm_var_shift, MRV_AFM_LUM_VAR_SHIFT,
+                       (af_config->var_shift >> 16));
+               REG_SET_SLICE(mrv_reg->isp_afm_var_shift, MRV_AFM_AFM_VAR_SHIFT,
+                       (af_config->var_shift >> 0));
+               REG_SET_SLICE(mrv_reg->isp_afm_ctrl, MRV_AFM_AFM_EN, ENABLE);
+       }
+
+       return result;
+
+}
+
+int ci_isp_set_ls_correction(
+       struct ci_sensor_ls_corr_config *ls_corr_config)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 i, n;
+       u32 data = 0;
+       int enabled = false;
+
+       if (!ls_corr_config) {
+               /* disable lens shading module */
+               REG_SET_SLICE(mrv_reg->isp_lsc_ctrl, MRV_LSC_LSC_EN, DISABLE);
+       } else {
+               if (REG_GET_SLICE(mrv_reg->isp_lsc_ctrl, MRV_LSC_LSC_EN)) {
+                       REG_SET_SLICE(mrv_reg->isp_lsc_ctrl,
+                               MRV_LSC_LSC_EN, DISABLE);
+                       intel_sleep_micro_sec(1000);
+                       enabled = true;
+               }
+
+               REG_WRITE(mrv_reg->isp_lsc_r_table_addr, 0);
+               REG_WRITE(mrv_reg->isp_lsc_g_table_addr, 0);
+               REG_WRITE(mrv_reg->isp_lsc_b_table_addr, 0);
+
+               ASSERT(((CI_ISP_MAX_LSC_SECTORS + 1) *
+                       ((CI_ISP_MAX_LSC_SECTORS + 2) / 2)) ==
+                       (MRV_LSC_R_RAM_ADDR_MAX + 1));
+               for (n = 0;
+               n < ((CI_ISP_MAX_LSC_SECTORS + 1)*(CI_ISP_MAX_LSC_SECTORS + 1));
+               n += CI_ISP_MAX_LSC_SECTORS + 1) {
+                       for (i = 0; i < (CI_ISP_MAX_LSC_SECTORS); i += 2) {
+                               REG_SET_SLICE(data, MRV_LSC_R_SAMPLE_0,
+                                       ls_corr_config->ls_rdata_tbl[n + i]);
+                               REG_SET_SLICE(data, MRV_LSC_R_SAMPLE_1,
+                                       ls_corr_config->ls_rdata_tbl
+                                       [n + i + 1]);
+                               REG_WRITE(mrv_reg->isp_lsc_r_table_data, data);
+                               REG_SET_SLICE(data, MRV_LSC_G_SAMPLE_0,
+                                       ls_corr_config->ls_gdata_tbl
+                                       [n + i]);
+                               REG_SET_SLICE(data, MRV_LSC_G_SAMPLE_1,
+                                       ls_corr_config->ls_gdata_tbl
+                                       [n + i + 1]);
+                               REG_WRITE(mrv_reg->isp_lsc_g_table_data, data);
+                               REG_SET_SLICE(data, MRV_LSC_B_SAMPLE_0,
+                                       ls_corr_config->ls_bdata_tbl[n + i]);
+                               REG_SET_SLICE(data, MRV_LSC_B_SAMPLE_1,
+                                       ls_corr_config->ls_bdata_tbl
+                                       [n + i + 1]);
+                               REG_WRITE(mrv_reg->isp_lsc_b_table_data, data);
+                       }
+                       REG_SET_SLICE(data, MRV_LSC_R_SAMPLE_0,
+                               ls_corr_config->ls_rdata_tbl
+                               [n + CI_ISP_MAX_LSC_SECTORS]);
+                       REG_SET_SLICE(data, MRV_LSC_R_SAMPLE_1, 0);
+                       REG_WRITE(mrv_reg->isp_lsc_r_table_data, data);
+                       REG_SET_SLICE(data, MRV_LSC_G_SAMPLE_0,
+                               ls_corr_config->ls_gdata_tbl
+                               [n + CI_ISP_MAX_LSC_SECTORS]);
+                       REG_SET_SLICE(data, MRV_LSC_G_SAMPLE_1, 0);
+                       REG_WRITE(mrv_reg->isp_lsc_g_table_data, data);
+                       REG_SET_SLICE(data, MRV_LSC_B_SAMPLE_0,
+                               ls_corr_config->ls_bdata_tbl
+                               [n + CI_ISP_MAX_LSC_SECTORS]);
+                       REG_SET_SLICE(data, MRV_LSC_B_SAMPLE_1, 0);
+                       REG_WRITE(mrv_reg->isp_lsc_b_table_data, data);
+               }
+
+               REG_SET_SLICE(mrv_reg->isp_lsc_xsize_01, MRV_LSC_X_SECT_SIZE_0,
+                       ls_corr_config->ls_xsize_tbl[0]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_xsize_01, MRV_LSC_X_SECT_SIZE_1,
+                       ls_corr_config->ls_xsize_tbl[1]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_xsize_23, MRV_LSC_X_SECT_SIZE_2,
+                       ls_corr_config->ls_xsize_tbl[2]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_xsize_23, MRV_LSC_X_SECT_SIZE_3,
+                       ls_corr_config->ls_xsize_tbl[3]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_xsize_45, MRV_LSC_X_SECT_SIZE_4,
+                       ls_corr_config->ls_xsize_tbl[4]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_xsize_45, MRV_LSC_X_SECT_SIZE_5,
+                       ls_corr_config->ls_xsize_tbl[5]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_xsize_67, MRV_LSC_X_SECT_SIZE_6,
+                       ls_corr_config->ls_xsize_tbl[6]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_xsize_67, MRV_LSC_X_SECT_SIZE_7,
+                       ls_corr_config->ls_xsize_tbl[7]);
+
+               REG_SET_SLICE(mrv_reg->isp_lsc_ysize_01, MRV_LSC_Y_SECT_SIZE_0,
+                       ls_corr_config->ls_ysize_tbl[0]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_ysize_01, MRV_LSC_Y_SECT_SIZE_1,
+                       ls_corr_config->ls_ysize_tbl[1]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_ysize_23, MRV_LSC_Y_SECT_SIZE_2,
+                       ls_corr_config->ls_ysize_tbl[2]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_ysize_23, MRV_LSC_Y_SECT_SIZE_3,
+                       ls_corr_config->ls_ysize_tbl[3]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_ysize_45, MRV_LSC_Y_SECT_SIZE_4,
+                       ls_corr_config->ls_ysize_tbl[4]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_ysize_45, MRV_LSC_Y_SECT_SIZE_5,
+                       ls_corr_config->ls_ysize_tbl[5]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_ysize_67, MRV_LSC_Y_SECT_SIZE_6,
+                       ls_corr_config->ls_ysize_tbl[6]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_ysize_67, MRV_LSC_Y_SECT_SIZE_7,
+                       ls_corr_config->ls_ysize_tbl[7]);
+
+               REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_01, MRV_LSC_XGRAD_0,
+                       ls_corr_config->ls_xgrad_tbl[0]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_01, MRV_LSC_XGRAD_1,
+                       ls_corr_config->ls_xgrad_tbl[1]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_23, MRV_LSC_XGRAD_2,
+                       ls_corr_config->ls_xgrad_tbl[2]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_23, MRV_LSC_XGRAD_3,
+                       ls_corr_config->ls_xgrad_tbl[3]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_45, MRV_LSC_XGRAD_4,
+                       ls_corr_config->ls_xgrad_tbl[4]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_45, MRV_LSC_XGRAD_5,
+                       ls_corr_config->ls_xgrad_tbl[5]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_67, MRV_LSC_XGRAD_6,
+                       ls_corr_config->ls_xgrad_tbl[6]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_xgrad_67, MRV_LSC_XGRAD_7,
+                       ls_corr_config->ls_xgrad_tbl[7]);
+
+               REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_01, MRV_LSC_YGRAD_0,
+                       ls_corr_config->ls_ygrad_tbl[0]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_01, MRV_LSC_YGRAD_1,
+                       ls_corr_config->ls_ygrad_tbl[1]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_23, MRV_LSC_YGRAD_2,
+                       ls_corr_config->ls_ygrad_tbl[2]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_23, MRV_LSC_YGRAD_3,
+                       ls_corr_config->ls_ygrad_tbl[3]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_45, MRV_LSC_YGRAD_4,
+                       ls_corr_config->ls_ygrad_tbl[4]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_45, MRV_LSC_YGRAD_5,
+                       ls_corr_config->ls_ygrad_tbl[5]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_67, MRV_LSC_YGRAD_6,
+                       ls_corr_config->ls_ygrad_tbl[6]);
+               REG_SET_SLICE(mrv_reg->isp_lsc_ygrad_67, MRV_LSC_YGRAD_7,
+                       ls_corr_config->ls_ygrad_tbl[7]);
+
+               if (enabled) {
+                       REG_SET_SLICE(mrv_reg->isp_lsc_ctrl,
+                               MRV_LSC_LSC_EN, ENABLE);
+               }
+       }
+
+       return CI_STATUS_SUCCESS;
+}
+
+int ci_isp_ls_correction_on_off(int ls_corr_on_off)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       if (ls_corr_on_off) {
+               /* switch on lens chading correction */
+               REG_SET_SLICE(mrv_reg->isp_lsc_ctrl, MRV_LSC_LSC_EN, ENABLE);
+       } else {
+               /* switch off lens chading correction */
+               REG_SET_SLICE(mrv_reg->isp_lsc_ctrl, MRV_LSC_LSC_EN, DISABLE);
+       }
+
+       return CI_STATUS_SUCCESS;
+
+}
+
+int ci_isp_set_bp_correction(
+       const struct ci_isp_bp_corr_config *bp_corr_config)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 isp_bp_ctrl = REG_READ(mrv_reg->isp_bp_ctrl);
+
+       if (!bp_corr_config) {
+               REG_SET_SLICE(isp_bp_ctrl, MRV_BP_HOT_COR_EN, DISABLE);
+               REG_SET_SLICE(isp_bp_ctrl, MRV_BP_DEAD_COR_EN, DISABLE);
+       } else {
+               if (bp_corr_config->bp_corr_type == CI_ISP_BP_CORR_DIRECT) {
+                       u32 isp_bp_cfg1 = REG_READ(mrv_reg->isp_bp_cfg1);
+                       u32 isp_bp_cfg2 = REG_READ(mrv_reg->isp_bp_cfg2);
+
+                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_COR_TYPE,
+                               MRV_BP_COR_TYPE_DIRECT);
+
+                       ASSERT(!REG_GET_SLICE(mrv_reg->isp_bp_ctrl,
+                               MRV_BP_BP_DET_EN));
+
+                       REG_SET_SLICE(isp_bp_cfg1, MRV_BP_HOT_THRES,
+                               bp_corr_config->bp_abs_hot_thres);
+                       REG_SET_SLICE(isp_bp_cfg1, MRV_BP_DEAD_THRES,
+                               bp_corr_config->bp_abs_dead_thres);
+                       REG_WRITE(mrv_reg->isp_bp_cfg1, isp_bp_cfg1);
+                       REG_SET_SLICE(isp_bp_cfg2, MRV_BP_DEV_HOT_THRES,
+                               bp_corr_config->bp_dev_hot_thres);
+                       REG_SET_SLICE(isp_bp_cfg2, MRV_BP_DEV_DEAD_THRES,
+                               bp_corr_config->bp_dev_dead_thres);
+                       REG_WRITE(mrv_reg->isp_bp_cfg2, isp_bp_cfg2);
+               } else {
+                       /* use bad pixel table */
+                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_COR_TYPE,
+                               MRV_BP_COR_TYPE_TABLE);
+               }
+
+               if (bp_corr_config->bp_corr_rep == CI_ISP_BP_CORR_REP_LIN) {
+                       /* use linear approch */
+                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_REP_APPR,
+                               MRV_BP_REP_APPR_INTERPOL);
+               } else {
+                       /* use best neighbour */
+                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_REP_APPR,
+                               MRV_BP_REP_APPR_NEAREST);
+               }
+
+               switch (bp_corr_config->bp_corr_mode) {
+               case CI_ISP_BP_CORR_HOT_EN:
+                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_HOT_COR_EN, ENABLE);
+                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_DEAD_COR_EN, DISABLE);
+                       break;
+               case CI_ISP_BP_CORR_DEAD_EN:
+                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_HOT_COR_EN, DISABLE);
+                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_DEAD_COR_EN, ENABLE);
+                       break;
+               case CI_ISP_BP_CORR_HOT_DEAD_EN:
+               default:
+                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_HOT_COR_EN, ENABLE);
+                       REG_SET_SLICE(isp_bp_ctrl, MRV_BP_DEAD_COR_EN, ENABLE);
+                       break;
+               }
+       }
+
+       REG_WRITE(mrv_reg->isp_bp_ctrl, isp_bp_ctrl);
+       return CI_STATUS_SUCCESS;
+
+}
+
+/*
+ * Sets the Bad Pixel configuration for detection
+ */
+int ci_isp_set_bp_detection(const struct ci_isp_bp_det_config *bp_det_config)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       if (!bp_det_config) {
+               REG_SET_SLICE(mrv_reg->isp_bp_ctrl, MRV_BP_BP_DET_EN, DISABLE);
+       } else {
+               ASSERT(REG_GET_SLICE(mrv_reg->isp_bp_ctrl, MRV_BP_COR_TYPE)
+                       == MRV_BP_COR_TYPE_TABLE);
+               REG_SET_SLICE(mrv_reg->isp_bp_cfg1, MRV_BP_DEAD_THRES,
+                       bp_det_config->bp_dead_thres);
+
+               REG_SET_SLICE(mrv_reg->isp_bp_ctrl, MRV_BP_BP_DET_EN, ENABLE);
+       }
+       return CI_STATUS_SUCCESS;
+}
+
+int ci_isp_clear_bp_int(void)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       if (REG_GET_SLICE(mrv_reg->isp_ris, MRV_ISP_RIS_BP_DET))
+               REG_SET_SLICE(mrv_reg->isp_icr, MRV_ISP_ICR_BP_DET, 1);
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * Initializes Isp filter registers with default reset values.
+ */
+static int ci_isp_initialize_filter_registers(void)
+{
+
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       mrv_reg->isp_filt_mode = 0x00000000;
+       mrv_reg->isp_filt_fac_sh1 = 0x00000010;
+       mrv_reg->isp_filt_fac_sh0 = 0x0000000C;
+       mrv_reg->isp_filt_fac_mid = 0x0000000A;
+       mrv_reg->isp_filt_fac_bl0 = 0x00000006;
+       mrv_reg->isp_filt_fac_bl1 = 0x00000002;
+       mrv_reg->isp_filt_thresh_bl0 = 0x0000000D;
+       mrv_reg->isp_filt_thresh_bl1 = 0x00000005;
+       mrv_reg->isp_filt_thresh_sh0 = 0x0000001A;
+       mrv_reg->isp_filt_thresh_sh1 = 0x0000002C;
+       mrv_reg->isp_filt_lum_weight = 0x00032040;
+       return CI_STATUS_SUCCESS;
+}
+
+int ci_isp_activate_filter(int activate_filter)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       int retval = CI_STATUS_SUCCESS;
+
+       retval = ci_isp_initialize_filter_registers();
+       if (retval != CI_STATUS_SUCCESS)
+               return retval;
+
+       REG_SET_SLICE(mrv_reg->isp_filt_mode, MRV_FILT_FILT_ENABLE,
+               (activate_filter) ? ENABLE : DISABLE);
+       return retval;
+}
+
+/*
+ * Write coefficient and threshold values into Isp filter
+ * registers for noise, sharpness and blurring filtering.
+ */
+int ci_isp_set_filter_params(u8 noise_reduc_level, u8 sharp_level)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 isp_filt_mode = 0;
+
+       if (!REG_GET_SLICE(mrv_reg->isp_filt_mode, MRV_FILT_FILT_ENABLE))
+               return CI_STATUS_CANCELED;
+
+       REG_WRITE(mrv_reg->isp_filt_mode, isp_filt_mode);
+
+       if (((noise_reduc_level <= 10) || (noise_reduc_level == 99))
+           && (sharp_level <= 10)) {
+               switch (noise_reduc_level) {
+               case 99:
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
+                               MRV_FILT_FILT_THRESH_SH1, 0x000003FF);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
+                               MRV_FILT_FILT_THRESH_SH0, 0x000003FF);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
+                               MRV_FILT_FILT_THRESH_BL0, 0x000003FF);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
+                               MRV_FILT_FILT_THRESH_BL1, 0x000003FF);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT, 0
+                               /* MRV_FILT_STAGE1_SELECT_MAX_BLUR */);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
+                               MRV_FILT_FILT_CHR_V_MODE_BYPASS);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
+                               MRV_FILT_FILT_CHR_H_MODE_BYPASS);
+                       break;
+
+               case 0:
+                       /* NoiseReductionLevel = 0 */
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
+                               MRV_FILT_FILT_THRESH_SH1, 0x000000);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
+                               MRV_FILT_FILT_THRESH_SH0, 0x000000);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
+                               MRV_FILT_FILT_THRESH_BL0, 0x000000);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
+                               MRV_FILT_FILT_THRESH_BL1, 0x000000);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT, 6);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
+                               MRV_FILT_FILT_CHR_V_MODE_STATIC8);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
+                               MRV_FILT_FILT_CHR_H_MODE_BYPASS);
+                       break;
+
+               case 1:
+                       /* NoiseReductionLevel = 1; */
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
+                               MRV_FILT_FILT_THRESH_SH1, 33);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
+                               MRV_FILT_FILT_THRESH_SH0, 18);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
+                               MRV_FILT_FILT_THRESH_BL0, 8);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
+                               MRV_FILT_FILT_THRESH_BL1, 2);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT, 6);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
+                               MRV_FILT_FILT_CHR_V_MODE_STATIC12);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
+                               MRV_FILT_FILT_CHR_H_MODE_DYN_2);
+                       break;
+
+               case 2:
+                       /* NoiseReductionLevel = 2; */
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
+                               MRV_FILT_FILT_THRESH_SH1, 44);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
+                               MRV_FILT_FILT_THRESH_SH0, 26);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
+                               MRV_FILT_FILT_THRESH_BL0, 13);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
+                               MRV_FILT_FILT_THRESH_BL1, 5);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT, 4
+                               /* MRV_FILT_STAGE1_SELECT_DEFAULT */);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
+                               MRV_FILT_FILT_CHR_V_MODE_STATIC12);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
+                               MRV_FILT_FILT_CHR_H_MODE_DYN_2);
+                       break;
+
+               case 3:
+                       /* NoiseReductionLevel = 3; */
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
+                               MRV_FILT_FILT_THRESH_SH1, 51);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
+                               MRV_FILT_FILT_THRESH_SH0, 36);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
+                               MRV_FILT_FILT_THRESH_BL0, 23);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
+                               MRV_FILT_FILT_THRESH_BL1, 10);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT, 4
+                               /* MRV_FILT_STAGE1_SELECT_DEFAULT */);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
+                               MRV_FILT_FILT_CHR_V_MODE_STATIC12);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
+                               MRV_FILT_FILT_CHR_H_MODE_DYN_2);
+                       break;
+
+               case 4:
+                       /* NoiseReductionLevel = 4; */
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
+                               MRV_FILT_FILT_THRESH_SH1, 67);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
+                               MRV_FILT_FILT_THRESH_SH0, 41);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
+                               MRV_FILT_FILT_THRESH_BL0, 26);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
+                               MRV_FILT_FILT_THRESH_BL1, 15);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT, 3);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
+                               MRV_FILT_FILT_CHR_V_MODE_STATIC12);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
+                               MRV_FILT_FILT_CHR_H_MODE_DYN_2);
+                       break;
+
+               case 5:
+                       /* NoiseReductionLevel = 5; */
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
+                               MRV_FILT_FILT_THRESH_SH1, 100);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
+                               MRV_FILT_FILT_THRESH_SH0, 75);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
+                               MRV_FILT_FILT_THRESH_BL0, 50);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
+                               MRV_FILT_FILT_THRESH_BL1, 20);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT, 3);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
+                               MRV_FILT_FILT_CHR_V_MODE_STATIC12);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
+                               MRV_FILT_FILT_CHR_H_MODE_DYN_2);
+                       break;
+
+               case 6:
+                       /* NoiseReductionLevel = 6; */
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
+                               MRV_FILT_FILT_THRESH_SH1, 120);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
+                               MRV_FILT_FILT_THRESH_SH0, 90);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
+                               MRV_FILT_FILT_THRESH_BL0, 60);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
+                               MRV_FILT_FILT_THRESH_BL1, 26);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT, 2);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
+                               MRV_FILT_FILT_CHR_V_MODE_STATIC12);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
+                               MRV_FILT_FILT_CHR_H_MODE_DYN_2);
+                       break;
+
+               case 7:
+                       /* NoiseReductionLevel = 7; */
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
+                               MRV_FILT_FILT_THRESH_SH1, 150);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
+                               MRV_FILT_FILT_THRESH_SH0, 120);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
+                               MRV_FILT_FILT_THRESH_BL0, 80);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
+                               MRV_FILT_FILT_THRESH_BL1, 51);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT, 2);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
+                               MRV_FILT_FILT_CHR_V_MODE_STATIC12);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
+                               MRV_FILT_FILT_CHR_H_MODE_DYN_2);
+                       break;
+
+               case 8:
+                       /* NoiseReductionLevel = 8; */
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
+                               MRV_FILT_FILT_THRESH_SH1, 200);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
+                               MRV_FILT_FILT_THRESH_SH0, 170);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
+                               MRV_FILT_FILT_THRESH_BL0, 140);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
+                               MRV_FILT_FILT_THRESH_BL1, 100);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT, 2);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
+                               MRV_FILT_FILT_CHR_V_MODE_STATIC12);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
+                               MRV_FILT_FILT_CHR_H_MODE_DYN_2);
+                       break;
+
+               case 9:
+                       /* NoiseReductionLevel = 9; */
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
+                               MRV_FILT_FILT_THRESH_SH1, 300);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
+                               MRV_FILT_FILT_THRESH_SH0, 250);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
+                               MRV_FILT_FILT_THRESH_BL0, 180);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
+                               MRV_FILT_FILT_THRESH_BL1, 150);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT,
+                               (sharp_level > 3) ? 2 : 1);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
+                               MRV_FILT_FILT_CHR_V_MODE_STATIC12);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
+                               MRV_FILT_FILT_CHR_H_MODE_DYN_2);
+                       break;
+
+               case 10:
+                       /* NoiseReductionLevel = 10; extrem noise */
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
+                               MRV_FILT_FILT_THRESH_SH1, 1023);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
+                               MRV_FILT_FILT_THRESH_SH0, 1023);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl0,
+                               MRV_FILT_FILT_THRESH_BL0, 1023);
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_bl1,
+                               MRV_FILT_FILT_THRESH_BL1, 1023);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_STAGE1_SELECT,
+                               (sharp_level > 5) ? 2 :
+                               ((sharp_level > 3) ? 1 : 0));
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_V_MODE,
+                               MRV_FILT_FILT_CHR_V_MODE_STATIC12);
+                       REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_CHR_H_MODE,
+                               MRV_FILT_FILT_CHR_H_MODE_DYN_2);
+                       break;
+
+               default:
+                       return CI_STATUS_OUTOFRANGE;
+               }
+
+               switch (sharp_level) {
+               /* SharpLevel = 0; no sharp enhancement */
+               case 0:
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
+                               MRV_FILT_FILT_FAC_SH1, 0x00000004);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
+                               MRV_FILT_FILT_FAC_SH0, 0x00000004);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
+                               MRV_FILT_FILT_FAC_MID, 0x00000004);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
+                               MRV_FILT_FILT_FAC_BL0, 0x00000002);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
+                               MRV_FILT_FILT_FAC_BL1, 0x00000000);
+                       break;
+
+               /* SharpLevel = 1; */
+               case 1:
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
+                               MRV_FILT_FILT_FAC_SH1, 0x00000008);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
+                               MRV_FILT_FILT_FAC_SH0, 0x00000007);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
+                               MRV_FILT_FILT_FAC_MID, 0x00000006);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
+                               MRV_FILT_FILT_FAC_BL0, 0x00000002);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
+                               MRV_FILT_FILT_FAC_BL1, 0x00000000);
+                       break;
+
+               /* SharpLevel = 2; */
+               case 2:
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
+                               MRV_FILT_FILT_FAC_SH1, 0x0000000C);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
+                               MRV_FILT_FILT_FAC_SH0, 0x0000000A);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
+                               MRV_FILT_FILT_FAC_MID, 0x00000008);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
+                               MRV_FILT_FILT_FAC_BL0, 0x00000004);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
+                               MRV_FILT_FILT_FAC_BL1, 0x00000000);
+                       break;
+
+               /* SharpLevel = 3; */
+               case 3:
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
+                               MRV_FILT_FILT_FAC_SH1, 0x00000010);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
+                               MRV_FILT_FILT_FAC_SH0, 0x0000000C);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
+                               MRV_FILT_FILT_FAC_MID, 0x0000000A);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
+                               MRV_FILT_FILT_FAC_BL0, 0x00000006);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
+                               MRV_FILT_FILT_FAC_BL1, 0x00000002);
+                       break;
+
+               /* SharpLevel = 4; */
+               case 4:
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
+                               MRV_FILT_FILT_FAC_SH1, 0x00000016);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
+                               MRV_FILT_FILT_FAC_SH0, 0x00000010);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
+                               MRV_FILT_FILT_FAC_MID, 0x0000000C);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
+                               MRV_FILT_FILT_FAC_BL0, 0x00000008);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
+                               MRV_FILT_FILT_FAC_BL1, 0x00000004);
+                       break;
+
+               /* SharpLevel = 5; */
+               case 5:
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
+                               MRV_FILT_FILT_FAC_SH1, 0x0000001B);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
+                               MRV_FILT_FILT_FAC_SH0, 0x00000014);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
+                               MRV_FILT_FILT_FAC_MID, 0x00000010);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
+                               MRV_FILT_FILT_FAC_BL0, 0x0000000A);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
+                               MRV_FILT_FILT_FAC_BL1, 0x00000004);
+                       break;
+
+               /* SharpLevel = 6; */
+               case 6:
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
+                               MRV_FILT_FILT_FAC_SH1, 0x00000020);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
+                               MRV_FILT_FILT_FAC_SH0, 0x0000001A);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
+                               MRV_FILT_FILT_FAC_MID, 0x00000013);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
+                               MRV_FILT_FILT_FAC_BL0, 0x0000000C);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
+                               MRV_FILT_FILT_FAC_BL1, 0x00000006);
+                       break;
+
+               /* SharpLevel = 7; */
+               case 7:
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
+                               MRV_FILT_FILT_FAC_SH1, 0x00000026);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
+                               MRV_FILT_FILT_FAC_SH0, 0x0000001E);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
+                               MRV_FILT_FILT_FAC_MID, 0x00000017);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
+                               MRV_FILT_FILT_FAC_BL0, 0x00000010);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
+                               MRV_FILT_FILT_FAC_BL1, 0x00000008);
+                       break;
+
+               /* SharpLevel = 8; */
+               case 8:
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
+                                     MRV_FILT_FILT_THRESH_SH0,
+                                     0x00000013);
+                       if (REG_GET_SLICE
+                           (mrv_reg->isp_filt_thresh_sh1,
+                            MRV_FILT_FILT_THRESH_SH1) > 0x0000008A) {
+                               REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
+                                             MRV_FILT_FILT_THRESH_SH1,
+                                             0x0000008A);
+                       }
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
+                               MRV_FILT_FILT_FAC_SH1, 0x0000002C);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
+                               MRV_FILT_FILT_FAC_SH0, 0x00000024);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
+                               MRV_FILT_FILT_FAC_MID, 0x0000001D);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
+                               MRV_FILT_FILT_FAC_BL0, 0x00000015);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
+                               MRV_FILT_FILT_FAC_BL1, 0x0000000D);
+                       break;
+
+               /* SharpLevel = 9; */
+               case 9:
+                       REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh0,
+                               MRV_FILT_FILT_THRESH_SH0, 0x00000013);
+                       if (REG_GET_SLICE(mrv_reg->isp_filt_thresh_sh1,
+                               MRV_FILT_FILT_THRESH_SH1) > 0x0000008A) {
+                               REG_SET_SLICE(mrv_reg->isp_filt_thresh_sh1,
+                                       MRV_FILT_FILT_THRESH_SH1,
+                                       0x0000008A);
+                       }
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
+                               MRV_FILT_FILT_FAC_SH1, 0x00000030);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
+                               MRV_FILT_FILT_FAC_SH0, 0x0000002A);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
+                               MRV_FILT_FILT_FAC_MID, 0x00000022);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
+                               MRV_FILT_FILT_FAC_BL0, 0x0000001A);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
+                               MRV_FILT_FILT_FAC_BL1, 0x00000014);
+                       break;
+
+               /* SharpLevel = 10; */
+               case 10:
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh1,
+                               MRV_FILT_FILT_FAC_SH1, 0x0000003F);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_sh0,
+                               MRV_FILT_FILT_FAC_SH0, 0x00000030);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_mid,
+                               MRV_FILT_FILT_FAC_MID, 0x00000028);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
+                               MRV_FILT_FILT_FAC_BL0, 0x00000024);
+                       REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
+                               MRV_FILT_FILT_FAC_BL1, 0x00000020);
+                       break;
+
+               default:
+                       return CI_STATUS_OUTOFRANGE;
+               }
+
+               if (noise_reduc_level > 7) {
+                       if (sharp_level > 7) {
+                               u32 filt_fac_bl0 = REG_GET_SLICE
+                                       (mrv_reg->isp_filt_fac_bl0,
+                                       MRV_FILT_FILT_FAC_BL0);
+                               u32 filt_fac_bl1 =
+                                   REG_GET_SLICE(mrv_reg->isp_filt_fac_bl1,
+                                       MRV_FILT_FILT_FAC_BL1);
+                               REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
+                                       MRV_FILT_FILT_FAC_BL0,
+                                       (filt_fac_bl0) >> 1);
+                               REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
+                                       MRV_FILT_FILT_FAC_BL1,
+                                       (filt_fac_bl1) >> 2);
+                       } else if (sharp_level > 4) {
+                               u32 filt_fac_bl0 =
+                                   REG_GET_SLICE(mrv_reg->isp_filt_fac_bl0,
+                                       MRV_FILT_FILT_FAC_BL0);
+                               u32 filt_fac_bl1 =
+                                   REG_GET_SLICE(mrv_reg->
+                                                 isp_filt_fac_bl1,
+                                                 MRV_FILT_FILT_FAC_BL1);
+                               REG_SET_SLICE(mrv_reg->isp_filt_fac_bl0,
+                                       MRV_FILT_FILT_FAC_BL0,
+                                       (filt_fac_bl0 * 3) >> 2);
+                               REG_SET_SLICE(mrv_reg->isp_filt_fac_bl1,
+                                       MRV_FILT_FILT_FAC_BL1,
+                                       (filt_fac_bl1) >> 1);
+                       }
+               }
+
+               REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_MODE,
+                       MRV_FILT_FILT_MODE_DYNAMIC);
+               REG_SET_SLICE(isp_filt_mode, MRV_FILT_FILT_ENABLE, ENABLE);
+               REG_WRITE(mrv_reg->isp_filt_mode, isp_filt_mode);
+
+               return CI_STATUS_SUCCESS;
+       } else
+
+       return CI_STATUS_OUTOFRANGE;
+}
diff --git a/drivers/media/video/mrstci/mrstisp/mrv_isp_bls.c b/drivers/media/video/mrstci/mrstisp/mrv_isp_bls.c
new file mode 100644
index 0000000..6f79e89
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/mrv_isp_bls.c
@@ -0,0 +1,174 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * Copyright (c) Silicon Image 2008  www.siliconimage.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#include "stdinc.h"
+#include "reg_access.h"
+#include "mrv_priv.h"
+
+static int ci_isp_bls_set_fixed_values(const struct ci_isp_bls_subtraction *
+                              bls_subtraction)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       if (!bls_subtraction)
+               return CI_STATUS_NULL_POINTER;
+       if ((bls_subtraction->fixed_a > MRV_ISP_BLS_FIX_SUB_MAX) ||
+           (bls_subtraction->fixed_b > MRV_ISP_BLS_FIX_SUB_MAX) ||
+           (bls_subtraction->fixed_c > MRV_ISP_BLS_FIX_SUB_MAX) ||
+           (bls_subtraction->fixed_d > MRV_ISP_BLS_FIX_SUB_MAX) ||
+           (bls_subtraction->fixed_a < (s16) MRV_ISP_BLS_FIX_SUB_MIN) ||
+           (bls_subtraction->fixed_b < (s16) MRV_ISP_BLS_FIX_SUB_MIN) ||
+           (bls_subtraction->fixed_c < (s16) MRV_ISP_BLS_FIX_SUB_MIN) ||
+           (bls_subtraction->fixed_d < (s16) MRV_ISP_BLS_FIX_SUB_MIN)) {
+               return CI_STATUS_OUTOFRANGE;
+       } else {
+               /* we are in this path  */
+               REG_SET_SLICE(mrv_reg->isp_bls_a_fixed, MRV_BLS_BLS_A_FIXED,
+                       bls_subtraction->fixed_a);
+               REG_SET_SLICE(mrv_reg->isp_bls_b_fixed, MRV_BLS_BLS_B_FIXED,
+                       bls_subtraction->fixed_b);
+               REG_SET_SLICE(mrv_reg->isp_bls_c_fixed, MRV_BLS_BLS_C_FIXED,
+                       bls_subtraction->fixed_c);
+               REG_SET_SLICE(mrv_reg->isp_bls_d_fixed, MRV_BLS_BLS_D_FIXED,
+                       bls_subtraction->fixed_d);
+       }
+
+       return CI_STATUS_SUCCESS;
+
+}
+
+/*
+ * Sets the desired configuration values to the BLS registers,
+ * if possible. In the case the parameter (bls_config == NULL)
+ * the BLS module will be deactivated.
+ */
+int ci_isp_bls_set_config(const struct ci_isp_bls_config *bls_config)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 isp_bls_ctrl = 0;
+
+       int error = CI_STATUS_FAILURE;
+       if (!bls_config) {
+               /* disable the BLS module */
+               REG_SET_SLICE(mrv_reg->isp_bls_ctrl,
+                       MRV_BLS_BLS_ENABLE, DISABLE);
+
+               return CI_STATUS_SUCCESS;
+       }
+
+       /* measurement window 2, enable_window =0 */
+       if (bls_config->isp_bls_window2.enable_window) {
+               if ((bls_config->isp_bls_window2.start_h >
+                    MRV_BLS_BLS_H2_START_MAX)
+                   || (bls_config->isp_bls_window2.stop_h >
+                       MRV_BLS_BLS_H2_STOP_MAX)
+                   || (bls_config->isp_bls_window2.start_v >
+                       MRV_BLS_BLS_V2_START_MAX)
+                   || (bls_config->isp_bls_window2.stop_v >
+                       MRV_BLS_BLS_V2_STOP_MAX)) {
+                       return CI_STATUS_OUTOFRANGE;
+               } else {
+                       REG_SET_SLICE(mrv_reg->isp_bls_h2_start,
+                               MRV_BLS_BLS_H2_START,
+                               bls_config->isp_bls_window2.start_h);
+                       REG_SET_SLICE(mrv_reg->isp_bls_h2_stop,
+                               MRV_BLS_BLS_H2_STOP,
+                               bls_config->isp_bls_window2.stop_h);
+                       REG_SET_SLICE(mrv_reg->isp_bls_v2_start,
+                               MRV_BLS_BLS_V2_START,
+                               bls_config->isp_bls_window2.start_v);
+                       REG_SET_SLICE(mrv_reg->isp_bls_v2_stop,
+                               MRV_BLS_BLS_V2_STOP,
+                               bls_config->isp_bls_window2.stop_v);
+               }
+
+       }
+
+       /* measurement window 1, enable_window=0 */
+       if (bls_config->isp_bls_window1.enable_window) {
+               if ((bls_config->isp_bls_window1.start_h >
+                    MRV_BLS_BLS_H1_START_MAX)
+                   || (bls_config->isp_bls_window1.stop_h >
+                       MRV_BLS_BLS_H1_STOP_MAX)
+                   || (bls_config->isp_bls_window1.start_v >
+                       MRV_BLS_BLS_V1_START_MAX)
+                   || (bls_config->isp_bls_window1.stop_v >
+                       MRV_BLS_BLS_V1_STOP_MAX)) {
+                       return CI_STATUS_OUTOFRANGE;
+               } else {
+                       REG_SET_SLICE(mrv_reg->isp_bls_h1_start,
+                               MRV_BLS_BLS_H1_START,
+                               bls_config->isp_bls_window1.start_h);
+                       REG_SET_SLICE(mrv_reg->isp_bls_h1_stop,
+                               MRV_BLS_BLS_H1_STOP,
+                               bls_config->isp_bls_window1.stop_h);
+                       REG_SET_SLICE(mrv_reg->isp_bls_v1_start,
+                               MRV_BLS_BLS_V1_START,
+                               bls_config->isp_bls_window1.start_v);
+                       REG_SET_SLICE(mrv_reg->isp_bls_v1_stop,
+                               MRV_BLS_BLS_V1_STOP,
+                               bls_config->isp_bls_window1.stop_v);
+               }
+       }
+
+       if (bls_config->bls_samples > MRV_BLS_BLS_SAMPLES_MAX) {
+               return CI_STATUS_OUTOFRANGE;
+       } else {
+               REG_SET_SLICE(mrv_reg->isp_bls_samples, MRV_BLS_BLS_SAMPLES,
+                               bls_config->bls_samples);
+       }
+
+       /* fixed subtraction values, enable_automatic=0 */
+
+       if (!bls_config->enable_automatic) {
+               error = ci_isp_bls_set_fixed_values
+                       (&(bls_config->bls_subtraction));
+               if (error != CI_STATUS_SUCCESS)
+                       return error;
+       }
+       if ((bls_config->disable_h) || (bls_config->disable_v))
+               return CI_STATUS_OUTOFRANGE;
+
+       isp_bls_ctrl = REG_READ(mrv_reg->isp_bls_ctrl);
+
+       /* enable measurement window(s) */
+       REG_SET_SLICE(isp_bls_ctrl, MRV_BLS_WINDOW_ENABLE,
+                     ((bls_config->isp_bls_window1.enable_window)
+                     ? MRV_BLS_WINDOW_ENABLE_WND1 : 0) |
+                     ((bls_config->isp_bls_window2.enable_window)
+                     ? MRV_BLS_WINDOW_ENABLE_WND2 : 0));
+
+       /* set Mode */
+       REG_SET_SLICE(isp_bls_ctrl, MRV_BLS_BLS_MODE,
+               (bls_config->enable_automatic) ? MRV_BLS_BLS_MODE_MEAS :
+               MRV_BLS_BLS_MODE_FIX);
+
+       /* enable module */
+       REG_SET_SLICE(isp_bls_ctrl, MRV_BLS_BLS_ENABLE, ENABLE);
+
+       /* write into register */
+       REG_WRITE(mrv_reg->isp_bls_ctrl, isp_bls_ctrl);
+
+       return CI_STATUS_SUCCESS;
+}
diff --git a/drivers/media/video/mrstci/mrstisp/mrv_isp_gamma.c b/drivers/media/video/mrstci/mrstisp/mrv_isp_gamma.c
new file mode 100644
index 0000000..870bd90
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/mrv_isp_gamma.c
@@ -0,0 +1,87 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * Copyright (c) Silicon Image 2008  www.siliconimage.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#include "stdinc.h"
+#include "reg_access.h"
+#include "mrv_priv.h"
+
+void ci_isp_set_gamma(const struct ci_sensor_gamma_curve *r,
+                   const struct ci_sensor_gamma_curve *g,
+                   const struct ci_sensor_gamma_curve *b)
+{
+       struct isp_register *mrv_reg = (struct isp_register *)MEM_MRV_REG_BASE;
+       const u8 shift_val = 4;
+       const u16 round_ofs = 0 << (shift_val - 1);
+       s32 i;
+       if (r) {
+               REG_WRITE(mrv_reg->isp_gamma_dx_lo, r->gamma_dx0);
+               REG_WRITE(mrv_reg->isp_gamma_dx_hi, r->gamma_dx1);
+
+               for (i = 0; i < MRV_ISP_GAMMA_R_Y_ARR_SIZE; i++) {
+                       REG_SET_SLICE(mrv_reg->isp_gamma_r_y[i],
+                       MRV_ISP_GAMMA_R_Y,
+                       (r->isp_gamma_y[i] + round_ofs) >> shift_val);
+                       REG_SET_SLICE(mrv_reg->isp_gamma_g_y[i],
+                       MRV_ISP_GAMMA_G_Y,
+                       (g->isp_gamma_y[i] + round_ofs) >> shift_val);
+                       REG_SET_SLICE(mrv_reg->isp_gamma_b_y[i],
+                       MRV_ISP_GAMMA_B_Y,
+                       (b->isp_gamma_y[i] + round_ofs) >> shift_val);
+
+               }
+
+               REG_SET_SLICE(mrv_reg->isp_ctrl,
+               MRV_ISP_ISP_GAMMA_IN_ENABLE, ENABLE);
+       } else {
+               REG_SET_SLICE(mrv_reg->isp_ctrl,
+               MRV_ISP_ISP_GAMMA_IN_ENABLE, DISABLE);
+       }
+}
+
+void ci_isp_set_gamma2(const struct ci_isp_gamma_out_curve *gamma)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       s32 i;
+
+       if (gamma) {
+               ASSERT(MRV_ISP_GAMMA_OUT_Y_ARR_SIZE ==
+                       CI_ISP_GAMMA_OUT_CURVE_ARR_SIZE);
+
+               for (i = 0; i < MRV_ISP_GAMMA_OUT_Y_ARR_SIZE; i++) {
+                       REG_SET_SLICE(mrv_reg->isp_gamma_out_y[i],
+                               MRV_ISP_ISP_GAMMA_OUT_Y,
+                               gamma->isp_gamma_y[i]);
+               }
+
+               REG_SET_SLICE(mrv_reg->isp_gamma_out_mode,
+                             MRV_ISP_EQU_SEGM,
+                             gamma->gamma_segmentation);
+               REG_SET_SLICE(mrv_reg->isp_ctrl,
+                             MRV_ISP_ISP_GAMMA_OUT_ENABLE, ENABLE);
+       } else {
+               REG_SET_SLICE(mrv_reg->isp_ctrl,
+               MRV_ISP_ISP_GAMMA_OUT_ENABLE, DISABLE);
+       }
+}
diff --git a/drivers/media/video/mrstci/mrstisp/mrv_jpe.c b/drivers/media/video/mrstci/mrstisp/mrv_jpe.c
new file mode 100644
index 0000000..cb270c9
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/mrv_jpe.c
@@ -0,0 +1,447 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * Copyright (c) Silicon Image 2008  www.siliconimage.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#include "stdinc.h"
+#include "reg_access.h"
+#include "mrv_priv.h"
+#include "mrv_jpe.h"
+
+int ci_isp_jpe_init_ex(u16 hsize, u16 vsize, u8 compression_ratio, u8 jpe_scale)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+
+       REG_SET_SLICE(mrv_reg->vi_ircl, MRV_VI_JPEG_SOFT_RST, ON);
+       REG_SET_SLICE(mrv_reg->vi_ircl, MRV_VI_JPEG_SOFT_RST, OFF);
+
+       /* set configuration for the Jpeg capturing */
+       ci_isp_jpe_set_config(hsize, vsize, jpe_scale);
+       intel_sleep_micro_sec(15);
+       ci_isp_jpe_set_tables(compression_ratio);
+       ci_isp_jpe_select_tables();
+
+       return CI_STATUS_SUCCESS;
+}
+
+int ci_isp_jpe_init(u32 resolution, u8 compression_ratio, int jpe_scale)
+{
+       u16 hsize = 0;
+       u16 vsize = 0;
+
+       switch (resolution) {
+       case SENSOR_RES_BP1:
+               hsize = BP1_SIZE_H;
+               vsize = BP1_SIZE_V;
+               break;
+       case SENSOR_RES_S_AFM:
+               hsize = S_AFM_SIZE_H;
+               vsize = S_AFM_SIZE_V;
+               break;
+       case SENSOR_RES_M_AFM:
+               hsize = M_AFM_SIZE_H;
+               vsize = M_AFM_SIZE_V;
+               break;
+       case SENSOR_RES_L_AFM:
+               hsize = L_AFM_SIZE_H;
+               vsize = L_AFM_SIZE_V;
+               break;
+       case SENSOR_RES_QQCIF:
+               hsize = QQCIF_SIZE_H;
+               vsize = QQCIF_SIZE_V;
+               break;
+       case SENSOR_RES_QQVGA:
+               hsize = QQVGA_SIZE_H;
+               vsize = QQVGA_SIZE_V;
+               break;
+       case SENSOR_RES_QCIF:
+               hsize = QCIF_SIZE_H;
+               vsize = QCIF_SIZE_V;
+               break;
+       case SENSOR_RES_QVGA:
+               hsize = QVGA_SIZE_H;
+               vsize = QVGA_SIZE_V;
+               break;
+       case SENSOR_RES_CIF:
+               hsize = CIF_SIZE_H;
+               vsize = CIF_SIZE_V;
+               break;
+       case SENSOR_RES_VGA:
+               hsize = VGA_SIZE_H;
+               vsize = VGA_SIZE_V;
+               break;
+       case SENSOR_RES_SVGA:
+               hsize = SVGA_SIZE_H;
+               vsize = SVGA_SIZE_V;
+               break;
+       case SENSOR_RES_XGA:
+               hsize = XGA_SIZE_H;
+               vsize = XGA_SIZE_V;
+               break;
+       case SENSOR_RES_XGA_PLUS:
+               hsize = XGA_PLUS_SIZE_H;
+               vsize = XGA_PLUS_SIZE_V;
+               break;
+       case SENSOR_RES_SXGA:
+               hsize = SXGA_SIZE_H;
+               vsize = SXGA_SIZE_V;
+               break;
+       case SENSOR_RES_UXGA:
+               hsize = UXGA_SIZE_H;
+               vsize = UXGA_SIZE_V;
+               break;
+       case SENSOR_RES_QXGA:
+               hsize = QXGA_SIZE_H;
+               vsize = QXGA_SIZE_V;
+               break;
+       case SENSOR_RES_QSXGA:
+               hsize = QSXGA_SIZE_H;
+               vsize = QSXGA_SIZE_V;
+               break;
+       case SENSOR_RES_QSXGA_PLUS:
+               hsize = QSXGA_PLUS_SIZE_H;
+               vsize = QSXGA_PLUS_SIZE_V;
+               break;
+       case SENSOR_RES_QSXGA_PLUS2:
+               hsize = QSXGA_PLUS2_SIZE_H;
+               vsize = QSXGA_PLUS2_SIZE_V;
+               break;
+       case SENSOR_RES_QSXGA_PLUS3:
+               hsize = QSXGA_PLUS3_SIZE_H;
+               vsize = QSXGA_PLUS3_SIZE_V;
+               break;
+       case SENSOR_RES_WQSXGA:
+               hsize = WQSXGA_SIZE_H;
+               vsize = WQSXGA_SIZE_V;
+               break;
+       case SENSOR_RES_QUXGA:
+               hsize = QUXGA_SIZE_H;
+               vsize = QUXGA_SIZE_V;
+               break;
+       case SENSOR_RES_WQUXGA:
+               hsize = WQUXGA_SIZE_H;
+               vsize = WQUXGA_SIZE_V;
+               break;
+       case SENSOR_RES_HXGA:
+               hsize = HXGA_SIZE_H;
+               vsize = HXGA_SIZE_V;
+               break;
+       default:
+               DBG_OUT((DERR,
+                   "ci_isp_jpe_init: resolution not supported\n"));
+               return CI_STATUS_NOTSUPP;
+       }
+
+    return ci_isp_jpe_init_ex(hsize, vsize, compression_ratio, jpe_scale);
+}
+
+void ci_isp_jpe_set_tables(u8 compression_ratio)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 jpe_table_data = 0;
+       u8 idx, size;
+       const u8 *yqtable = NULL;
+       const u8 *uvqtable = NULL;
+
+       switch (compression_ratio) {
+       case CI_ISP_JPEG_LOW_COMPRESSION:
+               yqtable = ci_isp_yq_table_low_comp1;
+               uvqtable = ci_isp_uv_qtable_low_comp1;
+               break;
+       case CI_ISP_JPEG_01_PERCENT:
+               yqtable = ci_isp_yq_table01_per_cent;
+               uvqtable = ci_isp_uv_qtable01_per_cent;
+               break;
+       case CI_ISP_JPEG_20_PERCENT:
+               yqtable = ci_isp_yq_table20_per_cent;
+               uvqtable = ci_isp_uv_qtable20_per_cent;
+               break;
+       case CI_ISP_JPEG_30_PERCENT:
+               yqtable = ci_isp_yq_table30_per_cent;
+               uvqtable = ci_isp_uv_qtable30_per_cent;
+               break;
+       case CI_ISP_JPEG_40_PERCENT:
+               yqtable = ci_isp_yq_table40_per_cent;
+               uvqtable = ci_isp_uv_qtable40_per_cent;
+               break;
+       case CI_ISP_JPEG_50_PERCENT:
+               yqtable = ci_isp_yq_table50_per_cent;
+               uvqtable = ci_isp_uv_qtable50_per_cent;
+               break;
+       case CI_ISP_JPEG_60_PERCENT:
+               yqtable = ci_isp_yq_table60_per_cent;
+               uvqtable = ci_isp_uv_qtable60_per_cent;
+               break;
+       case CI_ISP_JPEG_70_PERCENT:
+               yqtable = ci_isp_yq_table70_per_cent;
+               uvqtable = ci_isp_uv_qtable70_per_cent;
+               break;
+       case CI_ISP_JPEG_80_PERCENT:
+               yqtable = ci_isp_yq_table80_per_cent;
+               uvqtable = ci_isp_uv_qtable80_per_cent;
+               break;
+       case CI_ISP_JPEG_90_PERCENT:
+               yqtable = ci_isp_yq_table90_per_cent;
+               uvqtable = ci_isp_uv_qtable90_per_cent;
+               break;
+       case CI_ISP_JPEG_99_PERCENT:
+               yqtable = ci_isp_yq_table99_per_cent;
+               uvqtable = ci_isp_uv_qtable99_per_cent;
+               break;
+       case CI_ISP_JPEG_HIGH_COMPRESSION:
+       default:
+               yqtable = ci_isp_yq_table75_per_cent;
+               uvqtable = ci_isp_uv_qtable75_per_cent;
+               break;
+       }
+
+       /* Y q-table 0 programming */
+       /* all possible assigned tables have same size */
+       size = sizeof(ci_isp_yq_table75_per_cent)/
+               sizeof(ci_isp_yq_table75_per_cent[0]);
+       REG_SET_SLICE(mrv_reg->jpe_table_id, MRV_JPE_TABLE_ID,
+           MRV_JPE_TABLE_ID_QUANT0);
+       for (idx = 0; idx < (size - 1); idx += 2) {
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_H,
+                   yqtable[idx]);
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_L,
+                   yqtable[idx + 1]);
+               REG_WRITE(mrv_reg->jpe_table_data, jpe_table_data);
+       }
+
+       /* U/V q-table 0 programming */
+       /* all possible assigned tables have same size */
+       size = sizeof(ci_isp_uv_qtable75_per_cent) /
+               sizeof(ci_isp_uv_qtable75_per_cent[0]);
+       REG_SET_SLICE(mrv_reg->jpe_table_id, MRV_JPE_TABLE_ID,
+           MRV_JPE_TABLE_ID_QUANT1);
+       for (idx = 0; idx < (size - 1); idx += 2) {
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_H,
+                   uvqtable[idx]);
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_L,
+                   uvqtable[idx + 1]);
+               /* auto-increment register! */
+               REG_WRITE(mrv_reg->jpe_table_data, jpe_table_data);
+       }
+
+       /* Y AC-table 0 programming */
+       size = sizeof(ci_isp_ac_luma_table_annex_k) /
+               sizeof(ci_isp_ac_luma_table_annex_k[0]);
+       REG_SET_SLICE(mrv_reg->jpe_table_id, MRV_JPE_TABLE_ID,
+           MRV_JPE_TABLE_ID_VLC_AC0);
+       REG_SET_SLICE(mrv_reg->jpe_tac0_len, MRV_JPE_TAC0_LEN, size);
+       for (idx = 0; idx < (size - 1); idx += 2) {
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_H,
+                   ci_isp_ac_luma_table_annex_k[idx]);
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_L,
+                   ci_isp_ac_luma_table_annex_k[idx + 1]);
+               /* auto-increment register! */
+               REG_WRITE(mrv_reg->jpe_table_data, jpe_table_data);
+       }
+
+       /* U/V AC-table 1 programming */
+       size = sizeof(ci_isp_ac_chroma_table_annex_k) /
+               sizeof(ci_isp_ac_chroma_table_annex_k[0]);
+       REG_SET_SLICE(mrv_reg->jpe_table_id, MRV_JPE_TABLE_ID,
+           MRV_JPE_TABLE_ID_VLC_AC1);
+       REG_SET_SLICE(mrv_reg->jpe_tac1_len, MRV_JPE_TAC1_LEN, size);
+       for (idx = 0; idx < (size - 1); idx += 2) {
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_H,
+                   ci_isp_ac_chroma_table_annex_k[idx]);
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_L,
+                   ci_isp_ac_chroma_table_annex_k[idx + 1]);
+               /* auto-increment register! */
+               REG_WRITE(mrv_reg->jpe_table_data, jpe_table_data);
+       }
+
+       /* Y DC-table 0 programming */
+       size = sizeof(ci_isp_dc_luma_table_annex_k) /
+               sizeof(ci_isp_dc_luma_table_annex_k[0]);
+       REG_SET_SLICE(mrv_reg->jpe_table_id, MRV_JPE_TABLE_ID,
+           MRV_JPE_TABLE_ID_VLC_DC0);
+       REG_SET_SLICE(mrv_reg->jpe_tdc0_len, MRV_JPE_TDC0_LEN, size);
+       for (idx = 0; idx < (size - 1); idx += 2) {
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_H,
+                   ci_isp_dc_luma_table_annex_k[idx]);
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_L,
+                   ci_isp_dc_luma_table_annex_k[idx + 1]);
+               /* auto-increment register! */
+               REG_WRITE(mrv_reg->jpe_table_data, jpe_table_data);
+       }
+
+       /* U/V DC-table 1 programming */
+       size = sizeof(ci_isp_dc_chroma_table_annex_k) /
+               sizeof(ci_isp_dc_chroma_table_annex_k[0]);
+       REG_SET_SLICE(mrv_reg->jpe_table_id, MRV_JPE_TABLE_ID,
+           MRV_JPE_TABLE_ID_VLC_DC1);
+       REG_SET_SLICE(mrv_reg->jpe_tdc1_len, MRV_JPE_TDC1_LEN, size);
+       for (idx = 0; idx < (size - 1); idx += 2) {
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_H,
+                   ci_isp_dc_chroma_table_annex_k[idx]);
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_L,
+                   ci_isp_dc_chroma_table_annex_k[idx + 1]);
+               /* auto-increment register! */
+               REG_WRITE(mrv_reg->jpe_table_data, jpe_table_data);
+       }
+}
+
+/*
+ * selects tables to be used by encoder
+ */
+void ci_isp_jpe_select_tables(void)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+
+       REG_SET_SLICE(mrv_reg->jpe_tq_y_select, MRV_JPE_TQ0_SELECT,
+           MRV_JPE_TQ_SELECT_TAB0);
+       REG_SET_SLICE(mrv_reg->jpe_tq_u_select, MRV_JPE_TQ1_SELECT,
+           MRV_JPE_TQ_SELECT_TAB1);
+       REG_SET_SLICE(mrv_reg->jpe_tq_v_select, MRV_JPE_TQ2_SELECT,
+           MRV_JPE_TQ_SELECT_TAB1);
+       REG_SET_SLICE(mrv_reg->jpe_dc_table_select,
+           MRV_JPE_DC_TABLE_SELECT_Y, 0);
+       REG_SET_SLICE(mrv_reg->jpe_dc_table_select,
+           MRV_JPE_DC_TABLE_SELECT_U, 1);
+       REG_SET_SLICE(mrv_reg->jpe_dc_table_select,
+           MRV_JPE_DC_TABLE_SELECT_V, 1);
+       REG_SET_SLICE(mrv_reg->jpe_ac_table_select,
+           MRV_JPE_AC_TABLE_SELECT_Y, 0);
+       REG_SET_SLICE(mrv_reg->jpe_ac_table_select,
+           MRV_JPE_AC_TABLE_SELECT_U, 1);
+       REG_SET_SLICE(mrv_reg->jpe_ac_table_select,
+           MRV_JPE_AC_TABLE_SELECT_V, 1);
+}
+
+/*
+ * configure JPEG encoder
+ */
+void ci_isp_jpe_set_config(u16 hsize, u16 vsize, int jpe_scale)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+
+       /* JPEG image size */
+       REG_SET_SLICE(mrv_reg->jpe_enc_hsize, MRV_JPE_ENC_HSIZE, hsize);
+       REG_SET_SLICE(mrv_reg->jpe_enc_vsize, MRV_JPE_ENC_VSIZE, vsize);
+       if (jpe_scale) {
+               REG_SET_SLICE(mrv_reg->jpe_y_scale_en, MRV_JPE_Y_SCALE_EN,
+                   ENABLE);
+               REG_SET_SLICE(mrv_reg->jpe_cbcr_scale_en,
+                       MRV_JPE_CBCR_SCALE_EN, ENABLE);
+       } else {
+               REG_SET_SLICE(mrv_reg->jpe_y_scale_en,
+                       MRV_JPE_Y_SCALE_EN, DISABLE);
+               REG_SET_SLICE(mrv_reg->jpe_cbcr_scale_en,
+                       MRV_JPE_CBCR_SCALE_EN, DISABLE);
+       }
+
+       REG_SET_SLICE(mrv_reg->jpe_pic_format, MRV_JPE_ENC_PIC_FORMAT,
+               MRV_JPE_ENC_PIC_FORMAT_422);
+
+       REG_SET_SLICE(mrv_reg->jpe_table_flush, MRV_JPE_TABLE_FLUSH, 0);
+}
+
+int ci_isp_jpe_generate_header(u8 header_mode)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+
+       ASSERT((header_mode == MRV_JPE_HEADER_MODE_JFIF)
+           || (header_mode == MRV_JPE_HEADER_MODE_NO));
+
+       REG_SET_SLICE(mrv_reg->jpe_status_icr, MRV_JPE_GEN_HEADER_DONE,
+           1);
+
+       REG_SET_SLICE(mrv_reg->jpe_header_mode, MRV_JPE_HEADER_MODE,
+           header_mode);
+       REG_SET_SLICE(mrv_reg->jpe_gen_header, MRV_JPE_GEN_HEADER, ON);
+       return ci_isp_jpe_wait_for_header_gen_done();
+}
+
+void ci_isp_jpe_prep_enc(enum ci_isp_jpe_enc_mode jpe_enc_mode)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 jpe_encode = REG_READ(mrv_reg->jpe_encode);
+
+       REG_SET_SLICE(mrv_reg->jpe_status_icr, MRV_JPE_ENCODE_DONE, 1);
+
+       REG_SET_SLICE(jpe_encode, MRV_JPE_ENCODE, ON);
+       switch (jpe_enc_mode) {
+       case CI_ISP_JPE_LARGE_CONT_MODE:
+               REG_SET_SLICE(jpe_encode, MRV_JPE_CONT_MODE,
+                   MRV_JPE_CONT_MODE_HEADER);
+               break;
+       case CI_ISP_JPE_SHORT_CONT_MODE:
+               REG_SET_SLICE(jpe_encode, MRV_JPE_CONT_MODE,
+                   MRV_JPE_CONT_MODE_NEXT);
+               break;
+       default:
+               REG_SET_SLICE(jpe_encode, MRV_JPE_CONT_MODE,
+                   MRV_JPE_CONT_MODE_STOP);
+
+               break;
+       }
+
+       REG_WRITE(mrv_reg->jpe_encode, jpe_encode);
+       REG_SET_SLICE(mrv_reg->jpe_init, MRV_JPE_JP_INIT, 1);
+}
+
+int ci_isp_jpe_wait_for_header_gen_done(void)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+
+       intel_timer_start();
+
+       while (!REG_GET_SLICE
+           (mrv_reg->jpe_status_ris, MRV_JPE_GEN_HEADER_DONE)) {
+               if (intel_get_micro_sec() > 2000000) {
+                       intel_timer_stop();
+                       return CI_STATUS_FAILURE;
+               }
+       }
+       intel_timer_stop();
+       return CI_STATUS_SUCCESS;
+}
+
+int ci_isp_jpe_wait_for_encode_done(void)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+
+       intel_timer_start();
+       while (!REG_GET_SLICE
+           (mrv_reg->jpe_status_ris, MRV_JPE_ENCODE_DONE)) {
+               if (intel_get_micro_sec() > 200000) {
+                       intel_timer_stop();
+                       return CI_STATUS_FAILURE;
+               }
+       }
+       intel_timer_stop();
+       REG_SET_SLICE(mrv_reg->jpe_status_icr, MRV_JPE_ENCODE_DONE, 1);
+       return CI_STATUS_SUCCESS;
+}
diff --git a/drivers/media/video/mrstci/mrstisp/mrv_mif.c b/drivers/media/video/mrstci/mrstisp/mrv_mif.c
new file mode 100644
index 0000000..c682c21
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/mrv_mif.c
@@ -0,0 +1,677 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * Copyright (c) Silicon Image 2008  www.siliconimage.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#include "stdinc.h"
+#include "reg_access.h"
+#include "mrv_priv.h"
+
+void ci_isp_mif_reset_offsets(enum ci_isp_conf_update_time update_time)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+
+       REG_SET_SLICE(mrv_reg->mi_mp_y_offs_cnt_init,
+                     MRV_MI_MP_Y_OFFS_CNT_INIT, 0);
+       REG_SET_SLICE(mrv_reg->mi_mp_cb_offs_cnt_init,
+                     MRV_MI_MP_CB_OFFS_CNT_INIT, 0);
+       REG_SET_SLICE(mrv_reg->mi_mp_cr_offs_cnt_init,
+                     MRV_MI_MP_CR_OFFS_CNT_INIT, 0);
+
+       REG_SET_SLICE(mrv_reg->mi_sp_y_offs_cnt_init,
+                     MRV_MI_SP_Y_OFFS_CNT_INIT, 0);
+       REG_SET_SLICE(mrv_reg->mi_sp_cb_offs_cnt_init,
+                     MRV_MI_SP_CB_OFFS_CNT_INIT, 0);
+       REG_SET_SLICE(mrv_reg->mi_sp_cr_offs_cnt_init,
+                     MRV_MI_SP_CR_OFFS_CNT_INIT, 0);
+
+       REG_SET_SLICE(mrv_reg->mi_ctrl, MRV_MI_INIT_OFFSET_EN, ON);
+       REG_SET_SLICE(mrv_reg->mi_ctrl, MRV_MI_INIT_BASE_EN, ON);
+
+       switch (update_time) {
+       case CI_ISP_CFG_UPDATE_FRAME_SYNC:
+               break;
+       case CI_ISP_CFG_UPDATE_IMMEDIATE:
+               REG_SET_SLICE(mrv_reg->mi_init, MRV_MI_MI_CFG_UPD, ON);
+               break;
+       case CI_ISP_CFG_UPDATE_LATER:
+               break;
+       default:
+               break;
+       }
+
+}
+
+u32 ci_isp_mif_get_byte_cnt(void)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+
+       return (u32) REG_GET_SLICE(mrv_reg->mi_byte_cnt,
+                                     MRV_MI_BYTE_CNT);
+}
+
+static int ci_isp_mif__set_self_pic_orientation(
+       enum ci_isp_mif_sp_mode mrv_mif_sp_mode,
+       int activate_self_path)
+{
+
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 mi_ctrl = REG_READ(mrv_reg->mi_ctrl);
+
+       u32 output_format =
+           REG_GET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT);
+
+       switch (mrv_mif_sp_mode) {
+       case CI_ISP_MIF_SP_ORIGINAL:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP, 0);
+               break;
+
+       case CI_ISP_MIF_SP_HORIZONTAL_FLIP:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP,
+                             MRV_MI_ROT_AND_FLIP_H_FLIP);
+               break;
+
+       case CI_ISP_MIF_SP_VERTICAL_FLIP:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP,
+                             MRV_MI_ROT_AND_FLIP_V_FLIP);
+               break;
+
+       case CI_ISP_MIF_SP_ROTATION_090_DEG:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP,
+                             MRV_MI_ROT_AND_FLIP_ROTATE);
+               break;
+
+       case CI_ISP_MIF_SP_ROTATION_180_DEG:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP,
+                             MRV_MI_ROT_AND_FLIP_H_FLIP |
+                             MRV_MI_ROT_AND_FLIP_V_FLIP);
+               break;
+
+       case CI_ISP_MIF_SP_ROTATION_270_DEG:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP,
+                             MRV_MI_ROT_AND_FLIP_H_FLIP |
+                             MRV_MI_ROT_AND_FLIP_V_FLIP |
+                             MRV_MI_ROT_AND_FLIP_ROTATE);
+               break;
+
+       case CI_ISP_MIF_SP_ROT_090_V_FLIP:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP,
+                             MRV_MI_ROT_AND_FLIP_V_FLIP |
+                             MRV_MI_ROT_AND_FLIP_ROTATE);
+               break;
+
+       case CI_ISP_MIF_SP_ROT_270_V_FLIP:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP,
+                             MRV_MI_ROT_AND_FLIP_H_FLIP |
+                             MRV_MI_ROT_AND_FLIP_ROTATE);
+               break;
+
+       default:
+               return CI_STATUS_NOTSUPP;
+       }
+
+       if (REG_GET_SLICE(mi_ctrl, MRV_MI_ROT_AND_FLIP) &
+           MRV_MI_ROT_AND_FLIP_ROTATE) {
+               switch (output_format) {
+               case MRV_MI_SP_OUTPUT_FORMAT_RGB888:
+               case MRV_MI_SP_OUTPUT_FORMAT_RGB666:
+               case MRV_MI_SP_OUTPUT_FORMAT_RGB565:
+                       break;
+               default:
+                       return CI_STATUS_NOTSUPP;
+               }
+       }
+
+       REG_SET_SLICE(mi_ctrl, MRV_MI_SP_ENABLE,
+                     (activate_self_path) ? ENABLE : DISABLE);
+
+
+       REG_WRITE(mrv_reg->mi_ctrl, mi_ctrl);
+       REG_SET_SLICE(mrv_reg->mi_init, MRV_MI_MI_CFG_UPD, ON);
+
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * Checks the main or self picture path buffer structure.
+ */
+static int ci_isp_mif__check_mi_path_conf(
+       const struct ci_isp_mi_path_conf *isp_mi_path_conf, int main_buffer)
+{
+       if (!isp_mi_path_conf) {
+               DBG_OUT((DERR,
+                        "ci_isp_mif_check_mi_path_conf(): isp_mi_path_conf is"
+                        " NULL\n"));
+               return CI_STATUS_NULL_POINTER;
+       }
+
+       if (!isp_mi_path_conf->ybuffer.pucbuffer)
+               return CI_STATUS_NULL_POINTER;
+
+       if (main_buffer) {
+               if ((((unsigned long)(isp_mi_path_conf->ybuffer.pucbuffer)
+                     & ~(MRV_MI_MP_Y_BASE_AD_INIT_VALID_MASK)) != 0)
+                       ||
+                       ((isp_mi_path_conf->ybuffer.size
+                       & ~(MRV_MI_MP_Y_SIZE_INIT_VALID_MASK)) != 0)
+                       ||
+                       ((isp_mi_path_conf->ybuffer.size
+                       & (MRV_MI_MP_Y_SIZE_INIT_VALID_MASK)) == 0)
+                       ||
+                       ((isp_mi_path_conf->ybuffer.offs
+                       & ~(MRV_MI_MP_Y_OFFS_CNT_INIT_VALID_MASK)) != 0)) {
+                               return CI_STATUS_OUTOFRANGE;
+               }
+       } else {
+               if ((((unsigned long) isp_mi_path_conf->ybuffer.pucbuffer
+                       & ~(MRV_MI_SP_Y_BASE_AD_INIT_VALID_MASK)) != 0)
+                       ||
+                       ((isp_mi_path_conf->ybuffer.size &
+                       ~(MRV_MI_SP_Y_SIZE_INIT_VALID_MASK)) != 0)
+                       ||
+                       ((isp_mi_path_conf->ybuffer.size &
+                       (MRV_MI_SP_Y_SIZE_INIT_VALID_MASK)) == 0)
+                       ||
+                       ((isp_mi_path_conf->ybuffer.offs &
+                       ~(MRV_MI_SP_Y_OFFS_CNT_INIT_VALID_MASK)) !=
+                       0)
+                       ||
+                       ((isp_mi_path_conf->llength &
+                       ~(MRV_MI_SP_Y_LLENGTH_VALID_MASK)) != 0)
+                       ||
+                       ((isp_mi_path_conf->
+                       llength & (MRV_MI_SP_Y_LLENGTH_VALID_MASK)) == 0)) {
+                       return CI_STATUS_OUTOFRANGE;
+               }
+       }
+
+       if (isp_mi_path_conf->cb_buffer.pucbuffer != 0) {
+               if (main_buffer) {
+                       if ((((unsigned long)
+                               isp_mi_path_conf->cb_buffer.pucbuffer
+                               & ~(MRV_MI_MP_CB_BASE_AD_INIT_VALID_MASK)) !=
+                               0)
+                               ||
+                               ((isp_mi_path_conf->cb_buffer.size &
+                               ~(MRV_MI_MP_CB_SIZE_INIT_VALID_MASK)) != 0)
+                               ||
+                               ((isp_mi_path_conf->cb_buffer.size &
+                               (MRV_MI_MP_CB_SIZE_INIT_VALID_MASK)) == 0)
+                               ||
+                               ((isp_mi_path_conf->cb_buffer.offs &
+                               ~(MRV_MI_MP_CB_OFFS_CNT_INIT_VALID_MASK)) !=
+                               0)) {
+                                       return CI_STATUS_OUTOFRANGE;
+                       }
+               } else {
+                       if ((((unsigned long)
+                               isp_mi_path_conf->cb_buffer.pucbuffer
+                               & ~(MRV_MI_SP_CB_BASE_AD_INIT_VALID_MASK)) !=
+                               0)
+                               ||
+                               ((isp_mi_path_conf->cb_buffer.size &
+                               ~(MRV_MI_SP_CB_SIZE_INIT_VALID_MASK)) != 0)
+                               ||
+                               ((isp_mi_path_conf->cb_buffer.size &
+                               (MRV_MI_SP_CB_SIZE_INIT_VALID_MASK)) == 0)
+                               ||
+                               ((isp_mi_path_conf->cb_buffer.offs &
+                               ~(MRV_MI_SP_CB_OFFS_CNT_INIT_VALID_MASK)) !=
+                               0)) {
+                                       return CI_STATUS_OUTOFRANGE;
+                       }
+               }
+       }
+
+       if (isp_mi_path_conf->cr_buffer.pucbuffer != 0) {
+               if (main_buffer) {
+                       if ((((unsigned long)
+                               isp_mi_path_conf->cr_buffer.pucbuffer
+                               & ~(MRV_MI_MP_CR_BASE_AD_INIT_VALID_MASK)) !=
+                               0)
+                               ||
+                               ((isp_mi_path_conf->cr_buffer.size &
+                               ~(MRV_MI_MP_CR_SIZE_INIT_VALID_MASK)) != 0)
+                               ||
+                               ((isp_mi_path_conf->cr_buffer.size &
+                               (MRV_MI_MP_CR_SIZE_INIT_VALID_MASK)) == 0)
+                               ||
+                               ((isp_mi_path_conf->cr_buffer.offs &
+                               ~(MRV_MI_MP_CR_OFFS_CNT_INIT_VALID_MASK)) !=
+                               0)){
+                                       return CI_STATUS_OUTOFRANGE;
+                       }
+               } else {
+                       if ((((unsigned long)
+                               isp_mi_path_conf->cr_buffer.pucbuffer
+                               & ~(MRV_MI_SP_CR_BASE_AD_INIT_VALID_MASK))
+                               != 0)
+                           ||
+                           ((isp_mi_path_conf->cr_buffer.size &
+                             ~(MRV_MI_SP_CR_SIZE_INIT_VALID_MASK)) != 0)
+                           ||
+                           ((isp_mi_path_conf->cr_buffer.size &
+                           (MRV_MI_SP_CR_SIZE_INIT_VALID_MASK)) == 0)
+                           ||
+                           ((isp_mi_path_conf->cr_buffer.offs &
+                           ~(MRV_MI_SP_CR_OFFS_CNT_INIT_VALID_MASK)) != 0))
+                               return CI_STATUS_OUTOFRANGE;
+               }
+       }
+       return CI_STATUS_SUCCESS;
+}
+
+int ci_isp_mif__set_main_buffer(
+       const struct ci_isp_mi_path_conf *isp_mi_path_conf,
+       enum ci_isp_conf_update_time update_time)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+       int error = CI_STATUS_FAILURE;
+
+       error = ci_isp_mif__check_mi_path_conf(isp_mi_path_conf, true);
+       if (error != CI_STATUS_SUCCESS)
+               return error;
+
+       /* set register values */
+       REG_SET_SLICE(mrv_reg->mi_mp_y_base_ad_init,
+                     MRV_MI_MP_Y_BASE_AD_INIT,
+                     (u32)(unsigned long)isp_mi_path_conf->ybuffer.pucbuffer);
+       REG_SET_SLICE(mrv_reg->mi_mp_y_size_init, MRV_MI_MP_Y_SIZE_INIT,
+                     isp_mi_path_conf->ybuffer.size);
+       REG_SET_SLICE(mrv_reg->mi_mp_y_offs_cnt_init,
+                     MRV_MI_MP_Y_OFFS_CNT_INIT,
+                     isp_mi_path_conf->ybuffer.offs);
+
+       if (isp_mi_path_conf->cb_buffer.pucbuffer != 0) {
+               REG_SET_SLICE(mrv_reg->mi_mp_cb_base_ad_init,
+                             MRV_MI_MP_CB_BASE_AD_INIT,
+                             (u32)(unsigned long) isp_mi_path_conf->cb_buffer.
+                             pucbuffer);
+               REG_SET_SLICE(mrv_reg->mi_mp_cb_size_init,
+                             MRV_MI_MP_CB_SIZE_INIT,
+                             isp_mi_path_conf->cb_buffer.size);
+               REG_SET_SLICE(mrv_reg->mi_mp_cb_offs_cnt_init,
+                             MRV_MI_MP_CB_OFFS_CNT_INIT,
+                             isp_mi_path_conf->cb_buffer.offs);
+       }
+
+       if (isp_mi_path_conf->cr_buffer.pucbuffer != 0) {
+               REG_SET_SLICE(mrv_reg->mi_mp_cr_base_ad_init,
+                             MRV_MI_MP_CR_BASE_AD_INIT,
+                             (u32)(unsigned long) isp_mi_path_conf->cr_buffer.
+                             pucbuffer);
+               REG_SET_SLICE(mrv_reg->mi_mp_cr_size_init,
+                             MRV_MI_MP_CR_SIZE_INIT,
+                             isp_mi_path_conf->cr_buffer.size);
+               REG_SET_SLICE(mrv_reg->mi_mp_cr_offs_cnt_init,
+                             MRV_MI_MP_CR_OFFS_CNT_INIT,
+                             isp_mi_path_conf->cr_buffer.offs);
+       }
+
+       REG_SET_SLICE(mrv_reg->mi_ctrl, MRV_MI_INIT_OFFSET_EN, ENABLE);
+       REG_SET_SLICE(mrv_reg->mi_ctrl, MRV_MI_INIT_BASE_EN, ENABLE);
+
+       switch (update_time) {
+       case CI_ISP_CFG_UPDATE_FRAME_SYNC:
+               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_GEN_CFG_UPD,
+                             ON);
+               break;
+       case CI_ISP_CFG_UPDATE_IMMEDIATE:
+               REG_SET_SLICE(mrv_reg->mi_init, MRV_MI_MI_CFG_UPD, ON);
+               break;
+       case CI_ISP_CFG_UPDATE_LATER:
+               break;
+       default:
+               break;
+       }
+
+       return error;
+}
+
+int ci_isp_mif__set_self_buffer(
+       const struct ci_isp_mi_path_conf *isp_mi_path_conf,
+       enum ci_isp_conf_update_time update_time)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+       int error = CI_STATUS_FAILURE;
+
+       error = ci_isp_mif__check_mi_path_conf(isp_mi_path_conf, false);
+       if (error != CI_STATUS_SUCCESS)
+               return error;
+
+       REG_SET_SLICE(mrv_reg->mi_sp_y_base_ad_init,
+                     MRV_MI_SP_Y_BASE_AD_INIT,
+                     (u32)(unsigned long)isp_mi_path_conf->ybuffer.pucbuffer);
+       REG_SET_SLICE(mrv_reg->mi_sp_y_size_init, MRV_MI_SP_Y_SIZE_INIT,
+                     isp_mi_path_conf->ybuffer.size);
+       REG_SET_SLICE(mrv_reg->mi_sp_y_offs_cnt_init,
+                     MRV_MI_SP_Y_OFFS_CNT_INIT,
+                     isp_mi_path_conf->ybuffer.offs);
+
+       REG_SET_SLICE(mrv_reg->mi_sp_y_llength, MRV_MI_SP_Y_LLENGTH,
+                     isp_mi_path_conf->llength);
+
+
+       if (isp_mi_path_conf->cb_buffer.pucbuffer) {
+               REG_SET_SLICE(mrv_reg->mi_sp_cb_base_ad_init,
+                             MRV_MI_SP_CB_BASE_AD_INIT,
+                             (u32) (unsigned long)isp_mi_path_conf->cb_buffer.
+                             pucbuffer);
+               REG_SET_SLICE(mrv_reg->mi_sp_cb_size_init,
+                             MRV_MI_SP_CB_SIZE_INIT,
+                             isp_mi_path_conf->cb_buffer.size);
+               REG_SET_SLICE(mrv_reg->mi_sp_cb_offs_cnt_init,
+                             MRV_MI_SP_CB_OFFS_CNT_INIT,
+                             isp_mi_path_conf->cb_buffer.offs);
+       }
+
+       if (isp_mi_path_conf->cr_buffer.pucbuffer) {
+               REG_SET_SLICE(mrv_reg->mi_sp_cr_base_ad_init,
+                             MRV_MI_SP_CR_BASE_AD_INIT,
+                             (u32) (unsigned long)isp_mi_path_conf->cr_buffer.
+                             pucbuffer);
+               REG_SET_SLICE(mrv_reg->mi_sp_cr_size_init,
+                             MRV_MI_SP_CR_SIZE_INIT,
+                             isp_mi_path_conf->cr_buffer.size);
+               REG_SET_SLICE(mrv_reg->mi_sp_cr_offs_cnt_init,
+                             MRV_MI_SP_CR_OFFS_CNT_INIT,
+                             isp_mi_path_conf->cr_buffer.offs);
+       }
+       if ((!isp_mi_path_conf->ypic_width)
+           || (!isp_mi_path_conf->ypic_height)) {
+               return CI_STATUS_FAILURE;
+       }
+
+       REG_SET_SLICE(mrv_reg->mi_sp_y_pic_width, MRV_MI_SP_Y_PIC_WIDTH,
+                     isp_mi_path_conf->ypic_width);
+       REG_SET_SLICE(mrv_reg->mi_sp_y_pic_height, MRV_MI_SP_Y_PIC_HEIGHT,
+                     isp_mi_path_conf->ypic_height);
+       REG_SET_SLICE(mrv_reg->mi_sp_y_pic_size, MRV_MI_SP_Y_PIC_SIZE,
+                     isp_mi_path_conf->ypic_height *
+                     isp_mi_path_conf->llength);
+
+       REG_SET_SLICE(mrv_reg->mi_ctrl, MRV_MI_INIT_OFFSET_EN, ENABLE);
+       REG_SET_SLICE(mrv_reg->mi_ctrl, MRV_MI_INIT_BASE_EN, ENABLE);
+
+       switch (update_time) {
+       case CI_ISP_CFG_UPDATE_FRAME_SYNC:
+               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_GEN_CFG_UPD,
+                             ON);
+               break;
+       case CI_ISP_CFG_UPDATE_IMMEDIATE:
+               REG_SET_SLICE(mrv_reg->mi_init, MRV_MI_MI_CFG_UPD, ON);
+               break;
+       case CI_ISP_CFG_UPDATE_LATER:
+               break;
+       default:
+               break;
+       }
+       return error;
+}
+
+int ci_isp_mif__set_path_and_orientation(
+       const struct ci_isp_mi_ctrl *mrv_mi_ctrl)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+       int error = CI_STATUS_OUTOFRANGE;
+       u32 mi_ctrl = 0;
+
+       if (!mrv_mi_ctrl)
+               return CI_STATUS_NULL_POINTER;
+
+       if ((mrv_mi_ctrl->
+           irq_offs_init & ~(MRV_MI_MP_Y_IRQ_OFFS_INIT_VALID_MASK)) !=
+           0)
+               return error;
+
+       REG_SET_SLICE(mrv_reg->mi_mp_y_irq_offs_init,
+           MRV_MI_MP_Y_IRQ_OFFS_INIT,
+           mrv_mi_ctrl->irq_offs_init);
+
+       switch (mrv_mi_ctrl->main_path) {
+       case CI_ISP_PATH_OFF:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_MP_ENABLE, OFF);
+               break;
+       case CI_ISP_PATH_ON:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_MP_ENABLE, ON);
+               break;
+       case CI_ISP_PATH_JPE:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_JPEG_ENABLE, ON);
+               break;
+       case CI_ISP_PATH_RAW8:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_RAW_ENABLE, ON);
+               break;
+       case CI_ISP_PATH_RAW816:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_RAW_ENABLE, ON);
+               REG_SET_SLICE(mi_ctrl, MRV_MI_MP_WRITE_FORMAT,
+                   MRV_MI_MP_WRITE_FORMAT_INTERLEAVED);
+               break;
+       default:
+               return error;
+       }
+
+       switch (mrv_mi_ctrl->mrv_mif_sp_out_form) {
+       case CI_ISP_MIF_COL_FORMAT_YCBCR_422:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT,
+                   MRV_MI_SP_OUTPUT_FORMAT_YUV422);
+               break;
+       case CI_ISP_MIF_COL_FORMAT_YCBCR_444:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT,
+                   MRV_MI_SP_OUTPUT_FORMAT_YUV444);
+               break;
+       case CI_ISP_MIF_COL_FORMAT_YCBCR_420:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT,
+                   MRV_MI_SP_OUTPUT_FORMAT_YUV420);
+               break;
+       case CI_ISP_MIF_COL_FORMAT_YCBCR_400:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT,
+                   MRV_MI_SP_OUTPUT_FORMAT_YUV400);
+               break;
+       case CI_ISP_MIF_COL_FORMAT_RGB_565:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT,
+                   MRV_MI_SP_OUTPUT_FORMAT_RGB565);
+               break;
+       case CI_ISP_MIF_COL_FORMAT_RGB_888:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT,
+                   MRV_MI_SP_OUTPUT_FORMAT_RGB888);
+               break;
+       case CI_ISP_MIF_COL_FORMAT_RGB_666:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_OUTPUT_FORMAT,
+                   MRV_MI_SP_OUTPUT_FORMAT_RGB666);
+               break;
+
+       default:
+               return error;
+       }
+
+       switch (mrv_mi_ctrl->mrv_mif_sp_in_form) {
+       case CI_ISP_MIF_COL_FORMAT_YCBCR_422:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_INPUT_FORMAT,
+                   MRV_MI_SP_INPUT_FORMAT_YUV422);
+               break;
+       case CI_ISP_MIF_COL_FORMAT_YCBCR_444:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_INPUT_FORMAT,
+                   MRV_MI_SP_INPUT_FORMAT_YUV444);
+               break;
+       case CI_ISP_MIF_COL_FORMAT_YCBCR_420:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_INPUT_FORMAT,
+                   MRV_MI_SP_INPUT_FORMAT_YUV420);
+               break;
+       case CI_ISP_MIF_COL_FORMAT_YCBCR_400:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_INPUT_FORMAT,
+                   MRV_MI_SP_INPUT_FORMAT_YUV400);
+               break;
+       case CI_ISP_MIF_COL_FORMAT_RGB_565:
+       case CI_ISP_MIF_COL_FORMAT_RGB_666:
+       case CI_ISP_MIF_COL_FORMAT_RGB_888:
+       default:
+               return error;
+       }
+
+       error = CI_STATUS_SUCCESS;
+
+       switch (mrv_mi_ctrl->mrv_mif_sp_pic_form) {
+       case CI_ISP_MIF_PIC_FORM_PLANAR:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_SP_WRITE_FORMAT,
+                   MRV_MI_SP_WRITE_FORMAT_PLANAR);
+               break;
+       case CI_ISP_MIF_PIC_FORM_SEMI_PLANAR:
+               if ((mrv_mi_ctrl->mrv_mif_sp_out_form ==
+                   CI_ISP_MIF_COL_FORMAT_YCBCR_422)
+                   || (mrv_mi_ctrl->mrv_mif_sp_out_form ==
+                   CI_ISP_MIF_COL_FORMAT_YCBCR_420)) {
+                       REG_SET_SLICE(mi_ctrl, MRV_MI_SP_WRITE_FORMAT,
+                           MRV_MI_SP_WRITE_FORMAT_SEMIPLANAR);
+               } else {
+                       error = CI_STATUS_NOTSUPP;
+               }
+               break;
+       case CI_ISP_MIF_PIC_FORM_INTERLEAVED:
+               if (mrv_mi_ctrl->mrv_mif_sp_out_form ==
+                   CI_ISP_MIF_COL_FORMAT_YCBCR_422) {
+                       REG_SET_SLICE(mi_ctrl, MRV_MI_SP_WRITE_FORMAT,
+                           MRV_MI_SP_WRITE_FORMAT_INTERLEAVED);
+               } else {
+                       error = CI_STATUS_NOTSUPP;
+               }
+               break;
+       default:
+               error = CI_STATUS_OUTOFRANGE;
+               break;
+
+       }
+
+       if (error != CI_STATUS_SUCCESS)
+               return error;
+
+       if (mrv_mi_ctrl->main_path == CI_ISP_PATH_ON) {
+
+               switch (mrv_mi_ctrl->mrv_mif_mp_pic_form) {
+               case CI_ISP_MIF_PIC_FORM_PLANAR:
+                       REG_SET_SLICE(mi_ctrl, MRV_MI_MP_WRITE_FORMAT,
+                           MRV_MI_MP_WRITE_FORMAT_PLANAR);
+                       break;
+               case CI_ISP_MIF_PIC_FORM_SEMI_PLANAR:
+                       REG_SET_SLICE(mi_ctrl, MRV_MI_MP_WRITE_FORMAT,
+                           MRV_MI_MP_WRITE_FORMAT_SEMIPLANAR);
+                       break;
+               case CI_ISP_MIF_PIC_FORM_INTERLEAVED:
+                       REG_SET_SLICE(mi_ctrl, MRV_MI_MP_WRITE_FORMAT,
+                           MRV_MI_MP_WRITE_FORMAT_INTERLEAVED);
+                       break;
+               default:
+                       error = CI_STATUS_OUTOFRANGE;
+                       break;
+               }
+       }
+
+       if (error != CI_STATUS_SUCCESS)
+               return error;
+       switch (mrv_mi_ctrl->burst_length_chrom) {
+       case CI_ISP_MIF_BURST_LENGTH_4:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_BURST_LEN_CHROM,
+                   MRV_MI_BURST_LEN_CHROM_4);
+               break;
+       case CI_ISP_MIF_BURST_LENGTH_8:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_BURST_LEN_CHROM,
+                   MRV_MI_BURST_LEN_CHROM_8);
+               break;
+       case CI_ISP_MIF_BURST_LENGTH_16:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_BURST_LEN_CHROM,
+                   MRV_MI_BURST_LEN_CHROM_16);
+               break;
+       default:
+               error = CI_STATUS_OUTOFRANGE;
+               break;
+       }
+
+       if (error != CI_STATUS_SUCCESS)
+               return error;
+       switch (mrv_mi_ctrl->burst_length_lum) {
+       case CI_ISP_MIF_BURST_LENGTH_4:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_BURST_LEN_LUM,
+                   MRV_MI_BURST_LEN_LUM_4);
+               break;
+       case CI_ISP_MIF_BURST_LENGTH_8:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_BURST_LEN_LUM,
+                   MRV_MI_BURST_LEN_LUM_8);
+               break;
+       case CI_ISP_MIF_BURST_LENGTH_16:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_BURST_LEN_LUM,
+                   MRV_MI_BURST_LEN_LUM_16);
+               break;
+       default:
+               error = CI_STATUS_OUTOFRANGE;
+               break;
+       }
+
+       if (error != CI_STATUS_SUCCESS)
+               return error;
+
+       switch (mrv_mi_ctrl->init_vals) {
+       case CI_ISP_MIF_NO_INIT_VALS:
+               break;
+       case CI_ISP_MIF_INIT_OFFS:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_INIT_OFFSET_EN, ENABLE);
+               break;
+       case CI_ISP_MIF_INIT_BASE:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_INIT_BASE_EN, ENABLE);
+               break;
+       case CI_ISP_MIF_INIT_OFFSAndBase:
+               REG_SET_SLICE(mi_ctrl, MRV_MI_INIT_OFFSET_EN, ENABLE);
+               REG_SET_SLICE(mi_ctrl, MRV_MI_INIT_BASE_EN, ENABLE);
+               break;
+       default:
+               error = CI_STATUS_OUTOFRANGE;
+               break;
+       }
+
+       if (error != CI_STATUS_SUCCESS)
+               return error;
+
+       REG_SET_SLICE(mi_ctrl, MRV_MI_BYTE_SWAP,
+           (mrv_mi_ctrl->byte_swap_enable) ? ON : OFF);
+       REG_SET_SLICE(mi_ctrl, MRV_MI_LAST_PIXEL_SIG_EN,
+           (mrv_mi_ctrl->last_pixel_enable) ? ON : OFF);
+
+       REG_WRITE(mrv_reg->mi_ctrl, mi_ctrl);
+       if ((mrv_mi_ctrl->self_path == CI_ISP_PATH_ON) ||
+           (mrv_mi_ctrl->self_path == CI_ISP_PATH_OFF)) {
+               error =
+                   ci_isp_mif__set_self_pic_orientation(mrv_mi_ctrl->
+                       mrv_mif_sp_mode,
+                       (int) (mrv_mi_ctrl->
+                       self_path ==
+                       CI_ISP_PATH_ON));
+       } else
+               error = CI_STATUS_OUTOFRANGE;
+
+       REG_SET_SLICE(mrv_reg->mi_init, MRV_MI_MI_CFG_UPD, ON);
+       return error;
+}
diff --git a/drivers/media/video/mrstci/mrstisp/mrv_res.c b/drivers/media/video/mrstci/mrstisp/mrv_res.c
new file mode 100644
index 0000000..a1fab25
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/mrv_res.c
@@ -0,0 +1,350 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * Copyright (c) Silicon Image 2008  www.siliconimage.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#include "stdinc.h"
+#include "reg_access.h"
+#include "mrv_priv.h"
+
+#define RSZ_FLAGS_MASK (RSZ_UPSCALE_ENABLE | RSZ_SCALER_BYPASS)
+
+void ci_isp_res_set_main_resize(const struct ci_isp_scale *scale,
+                        enum ci_isp_conf_update_time update_time,
+                        const struct ci_isp_rsz_lut *rsz_lut)
+{
+       struct isp_register *mrv_reg =
+           (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 mrsz_ctrl = REG_READ(mrv_reg->mrsz_ctrl);
+       int upscaling = false;
+
+       /* horizontal luminance scale factor */
+       DBG_DD(("ci_isp_res_set_main_resize, hy %d,%x\n", scale->scale_hy,
+               scale->scale_hy));
+
+       if (scale->scale_hy & RSZ_SCALER_BYPASS) {
+               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HY_ENABLE,
+                   DISABLE);
+       } else {
+               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HY_ENABLE, ENABLE);
+               REG_SET_SLICE(mrv_reg->mrsz_scale_hy, MRV_MRSZ_SCALE_HY,
+                   (u32) scale->scale_hy);
+               REG_SET_SLICE(mrv_reg->mrsz_phase_hy, MRV_MRSZ_PHASE_HY,
+                   (u32) scale->phase_hy);
+
+               if (scale->scale_hy & RSZ_UPSCALE_ENABLE) {
+                       DBG_DD(("enable up scale\n"));
+                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HY_UP,
+                           MRV_MRSZ_SCALE_HY_UP_UPSCALE);
+                       upscaling = true;
+               } else {
+                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HY_UP,
+                           MRV_MRSZ_SCALE_HY_UP_DOWNSCALE);
+               }
+       }
+
+       /* horizontal chrominance scale factors */
+       ASSERT((scale->scale_hcb & RSZ_FLAGS_MASK) ==
+           (scale->scale_hcr & RSZ_FLAGS_MASK));
+       DBG_DD(("ci_isp_res_set_main_resize, hcb %d,%x\n", scale->scale_hcb,
+               scale->scale_hcb));
+       if (scale->scale_hcb & RSZ_SCALER_BYPASS) {
+               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HC_ENABLE,
+                   DISABLE);
+       } else {
+               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HC_ENABLE, ENABLE);
+               /* program scale factor and phase */
+
+               REG_SET_SLICE(mrv_reg->mrsz_scale_hcb, MRV_MRSZ_SCALE_HCB,
+                   (u32) scale->scale_hcb);
+               REG_SET_SLICE(mrv_reg->mrsz_scale_hcr, MRV_MRSZ_SCALE_HCB,
+                   (u32) scale->scale_hcr);
+               REG_SET_SLICE(mrv_reg->mrsz_phase_hc, MRV_MRSZ_PHASE_HC,
+                   (u32) scale->phase_hc);
+
+               if (scale->scale_hcb & RSZ_UPSCALE_ENABLE) {
+                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HC_UP,
+                           MRV_MRSZ_SCALE_HC_UP_UPSCALE);
+                       /* scaler and upscaling enabled */
+                       upscaling = true;
+               } else {
+                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_HC_UP,
+                           MRV_MRSZ_SCALE_HC_UP_DOWNSCALE);
+               }
+       }
+
+       /* vertical luminance scale factor */
+       DBG_DD(("ci_isp_res_set_main_resize, Vy %d,%x\n", scale->scale_vy,
+               scale->scale_vy));
+
+       if (scale->scale_vy & RSZ_SCALER_BYPASS) {
+               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VY_ENABLE,
+                   DISABLE);
+       } else {
+               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VY_ENABLE, ENABLE);
+               REG_SET_SLICE(mrv_reg->mrsz_scale_vy, MRV_MRSZ_SCALE_VY,
+                   (u32) scale->scale_vy);
+               REG_SET_SLICE(mrv_reg->mrsz_phase_vy, MRV_MRSZ_PHASE_VY,
+                   (u32) scale->phase_vy);
+
+               if (scale->scale_vy & RSZ_UPSCALE_ENABLE) {
+                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VY_UP,
+                           MRV_MRSZ_SCALE_VY_UP_UPSCALE);
+                       upscaling = true;
+               } else {
+                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VY_UP,
+                           MRV_MRSZ_SCALE_VY_UP_DOWNSCALE);
+               }
+       }
+
+       /* vertical chrominance scale factor */
+       DBG_DD(("ci_isp_res_set_main_resize, Vc %d,%x\n",
+       scale->scale_vc, scale->scale_vc));
+
+       if (scale->scale_vc & RSZ_SCALER_BYPASS) {
+               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VC_ENABLE,
+                   DISABLE);
+       } else {
+               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VC_ENABLE, ENABLE);
+               REG_SET_SLICE(mrv_reg->mrsz_scale_vc, MRV_MRSZ_SCALE_VC,
+                   (u32) scale->scale_vc);
+               REG_SET_SLICE(mrv_reg->mrsz_phase_vc, MRV_MRSZ_PHASE_VC,
+                   (u32) scale->phase_vc);
+
+               if (scale->scale_vc & RSZ_UPSCALE_ENABLE) {
+                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VC_UP,
+                           MRV_MRSZ_SCALE_VC_UP_UPSCALE);
+                       upscaling = true;
+               } else {
+                       REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_SCALE_VC_UP,
+                           MRV_MRSZ_SCALE_VC_UP_DOWNSCALE);
+               }
+       }
+
+       /* apply upscaling lookup table */
+       if (rsz_lut) {
+               u32 i;
+               for (i = 0; i <= MRV_MRSZ_SCALE_LUT_ADDR_MASK; i++) {
+                       REG_SET_SLICE(mrv_reg->mrsz_scale_lut_addr,
+                           MRV_MRSZ_SCALE_LUT_ADDR, i);
+                       REG_SET_SLICE(mrv_reg->mrsz_scale_lut,
+                           MRV_MRSZ_SCALE_LUT,
+                           rsz_lut->rsz_lut[i]);
+               }
+       } else if (upscaling) {
+               ASSERT("ci_isp_res_set_main_resize()" ==
+                   "Upscaling requires lookup table!");
+       }
+
+       /* handle immediate update flag and write mrsz_ctrl */
+       switch (update_time) {
+       case CI_ISP_CFG_UPDATE_FRAME_SYNC:
+               REG_WRITE(mrv_reg->mrsz_ctrl, mrsz_ctrl);
+               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_GEN_CFG_UPD,
+                   ON);
+               break;
+       case CI_ISP_CFG_UPDATE_IMMEDIATE:
+               REG_SET_SLICE(mrsz_ctrl, MRV_MRSZ_CFG_UPD, ON);
+               REG_WRITE(mrv_reg->mrsz_ctrl, mrsz_ctrl);
+               break;
+       case CI_ISP_CFG_UPDATE_LATER:
+       default:
+               REG_WRITE(mrv_reg->mrsz_ctrl, mrsz_ctrl);
+               break;
+       }
+}
+
+/*
+ * writes the scaler values to the appropriate Marvin registers.
+ */
+void ci_isp_res_set_self_resize(const struct ci_isp_scale *scale,
+                        enum ci_isp_conf_update_time update_time,
+                        const struct ci_isp_rsz_lut *rsz_lut)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 srsz_ctrl = REG_READ(mrv_reg->srsz_ctrl);
+       int upscaling = false;
+
+       /* flags must be "outside" scaler value */
+       ASSERT((RSZ_FLAGS_MASK & MRV_RSZ_SCALE_MASK) == 0);
+       ASSERT((scale->scale_hy & ~RSZ_FLAGS_MASK) <=
+           MRV_RSZ_SCALE_MAX);
+       ASSERT((scale->scale_hcb & ~RSZ_FLAGS_MASK) <=
+           MRV_RSZ_SCALE_MAX);
+       ASSERT((scale->scale_hcr & ~RSZ_FLAGS_MASK) <=
+           MRV_RSZ_SCALE_MAX);
+       ASSERT((scale->scale_vy & ~RSZ_FLAGS_MASK) <=
+           MRV_RSZ_SCALE_MAX);
+       ASSERT((scale->scale_vc & ~RSZ_FLAGS_MASK) <=
+           MRV_RSZ_SCALE_MAX);
+
+       /* horizontal luminance scale factor */
+       DBG_DD(("ci_isp_res_set_self_resize, hy %d,%x\n", scale->scale_hy,
+               scale->scale_hy));
+
+       if (scale->scale_hy & RSZ_SCALER_BYPASS) {
+               /* disable (bypass) scaler */
+               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HY_ENABLE,
+                   DISABLE);
+       } else {
+               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HY_ENABLE, ENABLE);
+               REG_SET_SLICE(mrv_reg->srsz_scale_hy, MRV_SRSZ_SCALE_HY,
+                   (u32) scale->scale_hy);
+               REG_SET_SLICE(mrv_reg->srsz_phase_hy, MRV_SRSZ_PHASE_HY,
+                   (u32) scale->phase_hy);
+
+               if (scale->scale_hy & RSZ_UPSCALE_ENABLE) {
+                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HY_UP,
+                           MRV_SRSZ_SCALE_HY_UP_UPSCALE);
+                       upscaling = true;
+               } else {
+                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HY_UP,
+                           MRV_SRSZ_SCALE_HY_UP_DOWNSCALE);
+               }
+       }
+
+       /* horizontal chrominance scale factors */
+       ASSERT((scale->scale_hcb & RSZ_FLAGS_MASK) ==
+           (scale->scale_hcr & RSZ_FLAGS_MASK));
+
+       DBG_DD(("ci_isp_res_set_self_resize, hcb %d,%x\n", scale->scale_hcb,
+               scale->scale_hcb));
+
+       if (scale->scale_hcb & RSZ_SCALER_BYPASS) {
+               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HC_ENABLE,
+                   DISABLE);
+       } else {
+               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HC_ENABLE, ENABLE);
+               /* program scale factor and phase */
+
+               REG_SET_SLICE(mrv_reg->srsz_scale_hcb, MRV_SRSZ_SCALE_HCB,
+                   (u32) scale->scale_hcb);
+               REG_SET_SLICE(mrv_reg->srsz_scale_hcr, MRV_SRSZ_SCALE_HCB,
+                   (u32) scale->scale_hcr);
+
+               REG_SET_SLICE(mrv_reg->srsz_phase_hc, MRV_SRSZ_PHASE_HC,
+                   (u32) scale->phase_hc);
+
+               if (scale->scale_hcb & RSZ_UPSCALE_ENABLE) {
+                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HC_UP,
+                           MRV_SRSZ_SCALE_HC_UP_UPSCALE);
+                       /* scaler and upscaling enabled */
+                       upscaling = true;
+               } else {
+                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_HC_UP,
+                           MRV_SRSZ_SCALE_HC_UP_DOWNSCALE);
+               }
+       }
+
+       /* vertical luminance scale factor */
+       DBG_DD(("ci_isp_res_set_self_resize, vy %d,%x\n", scale->scale_vy,
+               scale->scale_vy));
+
+       if (scale->scale_vy & RSZ_SCALER_BYPASS) {
+               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VY_ENABLE,
+                   DISABLE);
+       } else {
+               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VY_ENABLE, ENABLE);
+               /* program scale factor and phase */
+
+               REG_SET_SLICE(mrv_reg->srsz_scale_vy, MRV_SRSZ_SCALE_VY,
+                   (u32) scale->scale_vy);
+               REG_SET_SLICE(mrv_reg->srsz_phase_vy, MRV_SRSZ_PHASE_VY,
+                   (u32) scale->phase_vy);
+
+               if (scale->scale_vy & RSZ_UPSCALE_ENABLE)
+                       /* enable upscaling mode */
+               {
+                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VY_UP,
+                           MRV_SRSZ_SCALE_VY_UP_UPSCALE);
+                       /* scaler and upscaling enabled */
+                       upscaling = true;
+               } else
+                       /* disable upscaling mode */
+               {
+                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VY_UP,
+                           MRV_SRSZ_SCALE_VY_UP_DOWNSCALE);
+               }
+
+       }
+
+       /* vertical chrominance scale factor */
+       DBG_DD(("ci_isp_res_set_self_resize, vc %d,%x\n", scale->scale_vc,
+               scale->scale_vc));
+
+       if (scale->scale_vc & RSZ_SCALER_BYPASS) {
+               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VC_ENABLE,
+                   DISABLE);
+       } else {
+               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VC_ENABLE, ENABLE);
+               /* program scale factor and phase */
+
+               REG_SET_SLICE(mrv_reg->srsz_scale_vc, MRV_SRSZ_SCALE_VC,
+                   (u32) scale->scale_vc);
+               REG_SET_SLICE(mrv_reg->srsz_phase_vc, MRV_SRSZ_PHASE_VC,
+                   (u32) scale->phase_vc);
+
+               if (scale->scale_vc & RSZ_UPSCALE_ENABLE) {
+                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VC_UP,
+                           MRV_SRSZ_SCALE_VC_UP_UPSCALE);
+                       /* scaler and upscaling enabled */
+                       upscaling = true;
+               } else {
+                       REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_SCALE_VC_UP,
+                           MRV_SRSZ_SCALE_VC_UP_DOWNSCALE);
+               }
+       }
+
+       /* apply upscaling lookup table */
+       if (rsz_lut) {
+               u32 i;
+               for (i = 0; i <= MRV_SRSZ_SCALE_LUT_ADDR_MASK; i++) {
+                       REG_SET_SLICE(mrv_reg->srsz_scale_lut_addr,
+                           MRV_SRSZ_SCALE_LUT_ADDR, i);
+                       REG_SET_SLICE(mrv_reg->srsz_scale_lut,
+                           MRV_SRSZ_SCALE_LUT,
+                           rsz_lut->rsz_lut[i]);
+               }
+       } else if (upscaling) {
+               ASSERT("ci_isp_res_set_self_resize()" ==
+                   "Upscaling requires lookup table!");
+       }
+
+
+       /* handle immediate update flag and write mrsz_ctrl */
+       switch (update_time) {
+       case CI_ISP_CFG_UPDATE_FRAME_SYNC:
+               REG_WRITE(mrv_reg->srsz_ctrl, srsz_ctrl);
+               REG_SET_SLICE(mrv_reg->isp_ctrl, MRV_ISP_ISP_GEN_CFG_UPD,
+                   ON);
+               break;
+       case CI_ISP_CFG_UPDATE_IMMEDIATE:
+               REG_SET_SLICE(srsz_ctrl, MRV_SRSZ_CFG_UPD, ON);
+               REG_WRITE(mrv_reg->srsz_ctrl, srsz_ctrl);
+               break;
+       case CI_ISP_CFG_UPDATE_LATER:
+       default:
+               REG_WRITE(mrv_reg->srsz_ctrl, srsz_ctrl);
+               break;
+       }
+}
diff --git a/drivers/media/video/mrstci/mrstisp/mrv_sls_bp.c b/drivers/media/video/mrstci/mrstisp/mrv_sls_bp.c
new file mode 100644
index 0000000..8681dce
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/mrv_sls_bp.c
@@ -0,0 +1,83 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * Copyright (c) Silicon Image 2008  www.siliconimage.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#include "stdinc.h"
+static struct ci_sensor_bp_table bp_table = { 0 };
+
+int ci_bp_init(const struct ci_isp_bp_corr_config *bp_corr_config,
+                    const struct ci_isp_bp_det_config *bp_det_config)
+{
+       int error = CI_STATUS_SUCCESS;
+#define MRVSLS_BPINIT_MAX_TABLE 2048
+       if (!bp_corr_config || !bp_det_config)
+               return CI_STATUS_NULL_POINTER;
+
+       if (bp_corr_config->bp_corr_type == CI_ISP_BP_CORR_TABLE) {
+               error |= ci_isp_set_bp_correction(bp_corr_config);
+               error |= ci_isp_set_bp_detection(bp_det_config);
+
+               bp_table.bp_number = 0;
+               if (!bp_table.bp_table_elem) {
+                       bp_table.bp_table_elem =
+                           (struct ci_sensor_bp_table_elem *)
+                           kmalloc((sizeof(struct ci_sensor_bp_table_elem)*
+                                       MRVSLS_BPINIT_MAX_TABLE), GFP_KERNEL);
+                       if (!bp_table.bp_table_elem)
+                               error |= CI_STATUS_FAILURE;
+
+               }
+               bp_table.bp_table_elem_num = MRVSLS_BPINIT_MAX_TABLE;
+               error |= ci_isp_clear_bp_int();
+
+       } else {
+               if (bp_corr_config->bp_corr_type == CI_ISP_BP_CORR_DIRECT) {
+                       error |= ci_isp_set_bp_correction(bp_corr_config);
+                       error |= ci_isp_set_bp_detection(NULL);
+               } else {
+                       return CI_STATUS_NOTSUPP;
+               }
+       }
+
+       return error;
+}
+
+int ci_bp_end(const struct ci_isp_bp_corr_config *bp_corr_config)
+{
+       int uiResult = CI_STATUS_SUCCESS;
+
+       if (!bp_corr_config)
+               return CI_STATUS_NULL_POINTER;
+
+       uiResult |= ci_isp_set_bp_correction(NULL);
+       uiResult |= ci_isp_set_bp_detection(NULL);
+
+       if (bp_corr_config->bp_corr_type == CI_ISP_BP_CORR_TABLE) {
+               uiResult |= ci_isp_clear_bp_int();
+               kfree(bp_table.bp_table_elem);
+                       bp_table.bp_table_elem = NULL;
+       }
+       return uiResult;
+}
+
diff --git a/drivers/media/video/mrstci/mrstisp/mrv_sls_dp.c b/drivers/media/video/mrstci/mrstisp/mrv_sls_dp.c
new file mode 100644
index 0000000..4a800d3
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/mrv_sls_dp.c
@@ -0,0 +1,1146 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * Copyright (c) Silicon Image 2008  www.siliconimage.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#include "stdinc.h"
+#define CI_ISP_DPD_CSS_MASK  (CI_ISP_DPD_CSS_H_MASK | CI_ISP_DPD_CSS_V_MASK)
+#define SCALER_COFFS_COSITED 0x400
+#define FIXEDPOINT_ONE 0x1000
+#define MAIN_SCALER_WIDTH_MAX 2600
+#define SELF_SCALER_WIDTH_MAX 640
+#define SCALER_MIN 16
+#define SELF_UPSCALE_FACTOR_MAX 5
+#define MAIN_UPSCALE_FACTOR_MAX 5
+
+/* smooth edges */
+static const struct ci_isp_rsz_lut isp_rsz_lut_smooth_lin = {
+       {
+       0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
+       0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
+       0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
+       0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F,
+       0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27,
+       0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x2E, 0x2F,
+       0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
+       0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F
+       }
+};
+
+/* sharp edges */
+static const struct ci_isp_rsz_lut isp_rsz_lut_sharp = {
+       {
+       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+       0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+       0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
+       0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
+       0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
+       0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F
+       }
+};
+
+/* structure combining virtual ISP windows settings */
+struct ci_isp_virtual_isp_wnds {
+       struct ci_isp_window wnd_blacklines;
+       struct ci_isp_window wnd_zoom_crop;
+};
+
+/* static storage to remember last applied virtual ISP window settings */
+static struct ci_isp_virtual_isp_wnds last_isp_wnds;
+
+static u32 ci_get_scale_reg(u16 in, u16 out)
+{
+       if (in > out) {
+               /* downscaling */
+               return (u32) (((((u32) out -
+                                   1) * RSZ_SCALER_BYPASS) /
+                                 (u32) (in - 1)) + 1);
+       } else if (in < out) {
+               /* upscaling */
+               return (u32) (((((u32) in -
+                                   1) * RSZ_SCALER_BYPASS) /
+                                 (u32) (out -
+                                           1)) | (u32)
+                                RSZ_UPSCALE_ENABLE);
+
+       }
+       return RSZ_SCALER_BYPASS;
+}
+
+static u32 ci_calc_scale_factors(const struct ci_isp_datapath_desc *source,
+                                     const struct ci_isp_datapath_desc *path,
+                                     struct ci_isp_scale *scale,
+                                     int implementation)
+{
+       u32 scaler_output_format;
+       u32 cssflags;
+       u32 scaler_input_format;
+
+       u16 chroma_inW;
+       u16 chroma_inH;
+       u16 chroma_outWCR;
+       u16 chroma_outWCB;
+       u16 chroma_outH;
+
+       memset(scale, 0, sizeof(struct ci_isp_scale));
+       scale->scale_hy =
+           ci_get_scale_reg(source->out_w, path->out_w);
+       scale->scale_vy =
+           ci_get_scale_reg(source->out_h, path->out_h);
+
+       /* figure out the color input format of the scaler */
+       switch (path->flags & CI_ISP_DPD_MODE_MASK) {
+       case CI_ISP_DPD_MODE_DMAYC_DIRECT:
+       case CI_ISP_DPD_MODE_DMAYC_ISP:
+       case CI_ISP_DPD_MODE_DMAJPEG_DIRECT:
+       case CI_ISP_DPD_MODE_DMAJPEG_ISP:
+               scaler_input_format =
+                   path->flags & CI_ISP_DPD_DMA_IN_MASK;
+               break;
+       default:
+               scaler_input_format = CI_ISP_DPD_DMA_IN_422;
+               break;
+       }
+
+       if (implementation == MARVIN_FEATURE_SCALEFACTOR_SEPARATED_UV) {
+               switch (scaler_input_format) {
+               case CI_ISP_DPD_DMA_IN_422:
+                       chroma_inW = source->out_w / 2;
+                       chroma_inH = source->out_h;
+                       chroma_outWCR = path->out_w / 2;
+                       chroma_outWCB = (path->out_w + 1) / 2;
+                       chroma_outH = path->out_h;
+                       break;
+               case CI_ISP_DPD_DMA_IN_420:
+                       chroma_inW = source->out_w / 2;
+                       chroma_inH = source->out_h / 2;
+                       chroma_outWCR = path->out_w / 2;
+                       chroma_outWCB = (path->out_w + 1) / 2;
+                       chroma_outH = path->out_h / 2;
+                       break;
+               case CI_ISP_DPD_DMA_IN_411:
+                       chroma_inW = source->out_w / 4;
+                       chroma_inH = source->out_h;
+                       chroma_outWCR = path->out_w / 4;
+                       chroma_outWCB = (path->out_w + 2) / 4;
+                       chroma_outH = path->out_h;
+                       break;
+               case CI_ISP_DPD_DMA_IN_444:
+               default:
+                       chroma_inW = source->out_w;
+                       chroma_inH = source->out_h;
+                       chroma_outWCB = chroma_outWCR = path->out_w;
+                       chroma_outH = path->out_h;
+                       break;
+               }
+       } else {
+               ASSERT(implementation ==
+                      MARVIN_FEATURE_SCALEFACTOR_COMBINED_UV);
+               ASSERT(scaler_input_format == CI_ISP_DPD_DMA_IN_422);
+               chroma_inW = source->out_w;
+               chroma_inH = source->out_h;
+               chroma_outWCB = chroma_outWCR = path->out_w;
+               chroma_outH = path->out_h;
+       }
+
+       /* calculate chrominance scale factors */
+       switch (path->flags & CI_ISP_DPD_CSS_H_MASK) {
+       case CI_ISP_DPD_CSS_H2:
+               chroma_outWCB /= 2;
+               chroma_outWCR /= 2;
+               break;
+       case CI_ISP_DPD_CSS_H4:
+               chroma_outWCB /= 4;
+               chroma_outWCR /= 4;
+               break;
+       case CI_ISP_DPD_CSS_HUP2:
+               chroma_outWCB *= 2;
+               chroma_outWCR *= 2;
+               break;
+       case CI_ISP_DPD_CSS_HUP4:
+               chroma_outWCB *= 4;
+               chroma_outWCR *= 4;
+               break;
+       default:
+               /*leave chroma_outW untouched*/
+               break;
+       }
+       scale->scale_hcr = ci_get_scale_reg(chroma_inW, chroma_outWCR);
+       scale->scale_hcb = ci_get_scale_reg(chroma_inW, chroma_outWCB);
+       scale->scale_hcb = scale->scale_hcr;
+       switch (path->flags & CI_ISP_DPD_CSS_V_MASK) {
+       case CI_ISP_DPD_CSS_V2:
+               chroma_outH /= 2;
+               break;
+       case CI_ISP_DPD_CSS_V4:
+               chroma_outH /= 4;
+               break;
+       case CI_ISP_DPD_CSS_VUP2:
+               chroma_outH *= 2;
+               break;
+       case CI_ISP_DPD_CSS_VUP4:
+               chroma_outH *= 4;
+               break;
+       default:
+               /* leave chroma_outH untouched */
+               break;
+       }
+       scale->scale_vc = ci_get_scale_reg(chroma_inH, chroma_outH);
+
+       /* additional chrominance phase shifts */
+       if (path->flags & CI_ISP_DPD_CSS_HSHIFT)
+               scale->phase_hc = SCALER_COFFS_COSITED;
+       if (path->flags & CI_ISP_DPD_CSS_VSHIFT)
+               scale->phase_vc = SCALER_COFFS_COSITED;
+       /* additional luminance phase shifts */
+       if (path->flags & CI_ISP_DPD_LUMA_HSHIFT)
+               scale->phase_hy = SCALER_COFFS_COSITED;
+       if (path->flags & CI_ISP_DPD_LUMA_VSHIFT)
+               scale->phase_vy = SCALER_COFFS_COSITED;
+
+       /* try to figure out the outcoming YCbCr format */
+       cssflags = path->flags & CI_ISP_DPD_CSS_MASK;
+       if (cssflags == (CI_ISP_DPD_CSS_H_OFF | CI_ISP_DPD_CSS_V_OFF))
+               scaler_output_format = scaler_input_format;
+       else {
+               /* assume invalid format by default */
+               scaler_output_format = (u32) (-1);
+               switch (scaler_input_format) {
+               case CI_ISP_DPD_DMA_IN_444:
+                       if (cssflags ==
+                           (CI_ISP_DPD_CSS_H2 | CI_ISP_DPD_CSS_V_OFF))
+                               /* conversion 444 -> 422 */
+                       {
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_422;
+                       } else if (cssflags ==
+                                  (CI_ISP_DPD_CSS_H4 | CI_ISP_DPD_CSS_V_OFF))
+                               /* conversion 444 -> 411 */
+                       {
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_411;
+                       } else if (cssflags ==
+                                  (CI_ISP_DPD_CSS_H2 | CI_ISP_DPD_CSS_V2))
+                               /* conversion 444 -> 420 */
+                       {
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_420;
+                       }
+                       break;
+
+               case CI_ISP_DPD_DMA_IN_422:
+                       if (cssflags ==
+                           (CI_ISP_DPD_CSS_HUP2 | CI_ISP_DPD_CSS_V_OFF))
+                               /* conversion 422 -> 444 */
+                       {
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_444;
+                       } else if (cssflags ==
+                                  (CI_ISP_DPD_CSS_H2 | CI_ISP_DPD_CSS_V_OFF))
+                               /* conversion 422 -> 411 */
+                       {
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_411;
+                       } else if (cssflags ==
+                                  (CI_ISP_DPD_CSS_H_OFF | CI_ISP_DPD_CSS_V2))
+                               /* conversion 422 -> 420 */
+                       {
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_420;
+                       }
+                       break;
+
+               case CI_ISP_DPD_DMA_IN_420:
+                       if (cssflags ==
+                           (CI_ISP_DPD_CSS_HUP2 | CI_ISP_DPD_CSS_VUP2))
+                               /* conversion 420 -> 444 */
+                       {
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_444;
+                       } else if (cssflags ==
+                                  (CI_ISP_DPD_CSS_H2 | CI_ISP_DPD_CSS_VUP2))
+                               /* conversion 420 -> 411 */
+                       {
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_411;
+                       } else if (cssflags ==
+                                  (CI_ISP_DPD_CSS_H_OFF | CI_ISP_DPD_CSS_VUP2))
+                               /* conversion 420 -> 422 */
+                       {
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_422;
+                       }
+                       break;
+
+               case CI_ISP_DPD_DMA_IN_411:
+                       if (cssflags ==
+                           (CI_ISP_DPD_CSS_HUP4 | CI_ISP_DPD_CSS_V_OFF))
+                               /* conversion 411 -> 444 */
+                       {
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_444;
+                       } else if (cssflags ==
+                                  (CI_ISP_DPD_CSS_HUP2 | CI_ISP_DPD_CSS_V_OFF))
+                               /* conversion 411 -> 422 */
+                       {
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_422;
+                       } else if (cssflags ==
+                                  (CI_ISP_DPD_CSS_HUP2 | CI_ISP_DPD_CSS_V2))
+                               /* conversion 411 -> 420 */
+                       {
+                               scaler_output_format = CI_ISP_DPD_DMA_IN_420;
+                       }
+                       break;
+
+               default:
+                       break;
+               }
+       }
+
+       return scaler_output_format;
+}
+
+static const struct ci_isp_rsz_lut *ci_get_rsz_lut(u32 flags)
+{
+       const struct ci_isp_rsz_lut *ret_val;
+       switch (flags & CI_ISP_DPD_UPSCALE_MASK) {
+       case CI_ISP_DPD_UPSCALE_SHARP:
+               ret_val = &isp_rsz_lut_sharp;
+               break;
+       default:
+               ret_val = &isp_rsz_lut_smooth_lin;
+               break;
+       }
+       return ret_val;
+}
+
+static int ci_calc_main_path_settings(
+       const struct ci_isp_datapath_desc *source,
+       const struct ci_isp_datapath_desc  *main,
+       struct ci_isp_scale *scale_main,
+       struct ci_isp_mi_ctrl *mrv_mi_ctrl)
+{
+       u32 main_flag;
+
+       PRE_CONDITION(source != NULL);
+       PRE_CONDITION(scale_main != NULL);
+       PRE_CONDITION(mrv_mi_ctrl != NULL);
+
+       /* assume datapath deactivation if no selfpath pointer is given) */
+       if (main)
+               main_flag = main->flags;
+       else
+               main_flag = 0;
+
+       memset(scale_main, 0, sizeof(struct ci_isp_scale));
+       scale_main->scale_hy = RSZ_SCALER_BYPASS;
+       scale_main->scale_hcb = RSZ_SCALER_BYPASS;
+       scale_main->scale_hcr = RSZ_SCALER_BYPASS;
+       scale_main->scale_vy = RSZ_SCALER_BYPASS;
+       scale_main->scale_vc = RSZ_SCALER_BYPASS;
+
+       if (main_flag & CI_ISP_DPD_ENABLE) {
+               switch (main_flag & CI_ISP_DPD_MODE_MASK) {
+               case CI_ISP_DPD_MODE_ISPYC:
+               case CI_ISP_DPD_MODE_DMAYC_ISP:
+                       mrv_mi_ctrl->main_path = CI_ISP_PATH_ON;
+                       break;
+               case CI_ISP_DPD_MODE_ISPJPEG:
+               case CI_ISP_DPD_MODE_DMAJPEG_DIRECT:
+               case CI_ISP_DPD_MODE_DMAJPEG_ISP:
+                       mrv_mi_ctrl->main_path = CI_ISP_PATH_JPE;
+                       break;
+               case CI_ISP_DPD_MODE_ISPRAW:
+
+
+                       mrv_mi_ctrl->main_path = CI_ISP_PATH_RAW8;
+                       break;
+               case CI_ISP_DPD_MODE_ISPRAW_16B:
+
+
+                       mrv_mi_ctrl->main_path = CI_ISP_PATH_RAW816;
+                       break;
+
+               default:
+                       DBG_OUT((DERR,
+                                "ERR: unsupported mode for main path\n"));
+                       return CI_STATUS_NOTSUPP;
+               }
+               if (0 /* main_flag & CI_ISP_DPD_HWRGB_MASK*/) {
+                       DBG_OUT((DERR,
+                                "ERR: not supported for main path\n"));
+                       return CI_STATUS_NOTSUPP;
+               }
+               if (main_flag & (CI_ISP_DPD_H_FLIP | CI_ISP_DPD_V_FLIP |
+                       CI_ISP_DPD_90DEG_CCW)) {
+                       DBG_OUT((DERR,
+                                "ERR: not supported for main path\n"));
+                       return CI_STATUS_NOTSUPP;
+               }
+               if (main_flag & CI_ISP_DPD_NORESIZE) {
+                       if (main_flag & CI_ISP_DPD_CSS_MASK) {
+                               DBG_OUT((DERR,
+                                        "ERR: main path needs rezizer\n"));
+                               return CI_STATUS_NOTSUPP;
+                       }
+                       if (main_flag &
+                           (CI_ISP_DPD_LUMA_HSHIFT | CI_ISP_DPD_LUMA_VSHIFT)) {
+                               DBG_OUT((DERR,
+                                        "ERR: main path needs rezizer\n"));
+                               return CI_STATUS_NOTSUPP;
+                       }
+               } else {
+                       if ((mrv_mi_ctrl->main_path == CI_ISP_PATH_RAW8)
+                           || (mrv_mi_ctrl->main_path == CI_ISP_PATH_RAW8)) {
+                               DBG_OUT((DERR,
+                                        "ERR: scaler not in RAW mode\n"));
+                               return CI_STATUS_NOTSUPP;
+                       }
+                       if (main != NULL) {
+                               DBG_DD(("xiaolin, here to main resize\n"));
+                               if ((((u32) (source->out_w) *
+                                     MAIN_UPSCALE_FACTOR_MAX) < main->out_w)
+                                   ||
+                                   (((u32) (source->out_h) *
+                                     MAIN_UPSCALE_FACTOR_MAX) <
+                                    main->out_h)) {
+                                       DBG_OUT((DERR,
+                                        "ERR: : main upscaling exceeded\n"));
+                                       return CI_STATUS_NOTSUPP;
+                               }
+                               if ((main->out_w >
+                                    MAIN_SCALER_WIDTH_MAX)
+                                   || (main->out_w < SCALER_MIN)
+                                   || (main->out_h < SCALER_MIN)) {
+                                       DBG_OUT((DERR,
+                                        "ERR: : main scaler ange exceeded\n"));
+                                       return CI_STATUS_NOTSUPP;
+                               }
+                       } else {
+                               ASSERT(main != NULL);
+                       }
+
+                       if (source->out_w & 0x01) {
+                               DBG_OUT((DERR,
+                                "ERR: input width must be even!(is %hu)\n",
+                                        source->out_w));
+                               return CI_STATUS_NOTSUPP;
+                       }
+
+                       /* calculate scale factors. */
+                       DBG_DD(("ci_calc_main_path_settings\n"));
+                       (void)ci_calc_scale_factors(source, main,
+                                     scale_main,
+                                     MARVIN_FEATURE_MSCALE_FACTORCALC);
+               }
+       } else {
+               mrv_mi_ctrl->main_path = CI_ISP_PATH_OFF;
+       }
+
+       /* hardcoded MI settings */
+       DBG_DD(("*** main_flag is 0x%x\n", main_flag));
+       if (main_flag & CI_ISP_DPD_HWRGB_MASK) {
+               switch (main_flag & CI_ISP_DPD_HWRGB_MASK) {
+               case CI_ISP_DPD_YUV_420:
+               case CI_ISP_DPD_YUV_422:
+                       mrv_mi_ctrl->mrv_mif_mp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_PLANAR;
+                       break;
+               case CI_ISP_DPD_YUV_NV12:
+                       mrv_mi_ctrl->mrv_mif_mp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_SEMI_PLANAR;
+                       break;
+               case CI_ISP_DPD_YUV_YUYV:
+                       mrv_mi_ctrl->mrv_mif_mp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_INTERLEAVED;
+                       break;
+               default:
+                       mrv_mi_ctrl->mrv_mif_mp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_PLANAR;
+               }
+       }
+
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * Fills in scale factors and MI configuration for the self
+ * path.  Note that only self path related settings will be written into
+ * the MI config struct, so this routine can be used for both ISP and DMA
+ * originated datapath setups.
+ *
+ * Following fields are being filled in:
+ *           scale_flag :
+ *              [all fields]
+ *           mrv_mi_ctrl :
+ *              mrv_mif_sp_out_form
+ *              mrv_mif_sp_in_form
+ *              mrv_mif_sp_pic_form
+ *              mrv_mif_sp_mode
+ *              self_path
+ */
+static int ci_calc_self_path_settings(
+       const struct ci_isp_datapath_desc *source,
+       const struct ci_isp_datapath_desc *self,
+       struct ci_isp_scale *scale_flag,
+       struct ci_isp_mi_ctrl *mrv_mi_ctrl)
+{
+       u32 scaler_out_col_format;
+       u32 self_flag;
+
+       PRE_CONDITION(source != NULL);
+       PRE_CONDITION(scale_flag != NULL);
+       PRE_CONDITION(mrv_mi_ctrl != NULL);
+
+       /* assume datapath deactivation if no selfpath pointer is given) */
+       if (self)
+               self_flag = self->flags;
+       else
+               self_flag = 0;
+       memset(scale_flag, 0, sizeof(struct ci_isp_scale));
+       scale_flag->scale_hy = RSZ_SCALER_BYPASS;
+       scale_flag->scale_hcb = RSZ_SCALER_BYPASS;
+       scale_flag->scale_hcr = RSZ_SCALER_BYPASS;
+       scale_flag->scale_vy = RSZ_SCALER_BYPASS;
+       scale_flag->scale_vc = RSZ_SCALER_BYPASS;
+
+       if (self_flag & CI_ISP_DPD_ENABLE) {
+
+               switch (self_flag & CI_ISP_DPD_MODE_MASK) {
+               case CI_ISP_DPD_MODE_ISPYC:
+                       mrv_mi_ctrl->self_path = CI_ISP_PATH_ON;
+                       scaler_out_col_format = CI_ISP_DPD_DMA_IN_422;
+                       break;
+               case CI_ISP_DPD_MODE_DMAYC_ISP:
+               case CI_ISP_DPD_MODE_DMAYC_DIRECT:
+                       mrv_mi_ctrl->self_path = CI_ISP_PATH_ON;
+                       scaler_out_col_format =
+                           self_flag & CI_ISP_DPD_DMA_IN_MASK;
+                       break;
+               default:
+                       DBG_OUT((DERR,
+                                "ERR: unsupported mode for self path\n"));
+                       return CI_STATUS_NOTSUPP;
+               }
+
+               if (self_flag & CI_ISP_DPD_NORESIZE) {
+                       if (self_flag & CI_ISP_DPD_CSS_MASK) {
+                               DBG_OUT((DERR,
+                                        "ERR: in self path needs rezizer\n"));
+                               return CI_STATUS_NOTSUPP;
+                       }
+                       if (self_flag &
+                           (CI_ISP_DPD_LUMA_HSHIFT | CI_ISP_DPD_LUMA_VSHIFT)) {
+                               DBG_OUT((DERR,
+                                        "ERR: n self path needs rezizer\n"));
+                               return CI_STATUS_NOTSUPP;
+                       }
+                       if (self != NULL) {
+                               if ((source->out_w != self->out_w) ||
+                                   (source->out_h != self->out_h)) {
+                                       DBG_OUT((DERR,
+                                                "ERR: sizes needs resizer\n"));
+                                       return CI_STATUS_NOTSUPP;
+                               }
+                       } else {
+                               ASSERT(self != NULL);
+                       }
+               } else {
+                       if (self != NULL) {
+                               if ((((u32) (source->out_w) *
+                                     SELF_UPSCALE_FACTOR_MAX) <
+                                    self->out_w)
+                                   ||
+                                   (((u32) (source->out_h) *
+                                     SELF_UPSCALE_FACTOR_MAX) <
+                                    self->out_h)) {
+                                       DBG_OUT((DERR,
+                                                "ERR: apability exceeded\n"));
+                                       return CI_STATUS_NOTSUPP;
+                               }
+                               if ((self->out_w >
+                                    SELF_SCALER_WIDTH_MAX)
+                                   || (self->out_w < SCALER_MIN)
+                                   || (self->out_h < SCALER_MIN)) {
+                                       DBG_OUT((DERR,
+                                                "ERR: out range exceeded\n"));
+                                       return CI_STATUS_NOTSUPP;
+                               }
+                       } else {
+                               ASSERT(self != NULL);
+                       }
+
+                       if (source->out_w & 0x01) {
+                               DBG_OUT((DERR,
+                                        "ERR: width must be even! (is %hu)\n",
+                                        source->out_w));
+                               return CI_STATUS_NOTSUPP;
+                       }
+
+                       /* calculate scale factors. */
+                       scaler_out_col_format =
+                           ci_calc_scale_factors(source, self, scale_flag,
+                           MARVIN_FEATURE_SSCALE_FACTORCALC);
+               }
+
+               /* figure out the input format setting */
+               switch (scaler_out_col_format) {
+               case CI_ISP_DPD_DMA_IN_444:
+                       mrv_mi_ctrl->mrv_mif_sp_in_form =
+                           CI_ISP_MIF_COL_FORMAT_YCBCR_444;
+                       break;
+               case CI_ISP_DPD_DMA_IN_422:
+                       mrv_mi_ctrl->mrv_mif_sp_in_form =
+                           CI_ISP_MIF_COL_FORMAT_YCBCR_422;
+                       break;
+               case CI_ISP_DPD_DMA_IN_420:
+                       mrv_mi_ctrl->mrv_mif_sp_in_form =
+                           CI_ISP_MIF_COL_FORMAT_YCBCR_420;
+                       break;
+                       /* no break, does not seem to be supported by HW */
+               case CI_ISP_DPD_DMA_IN_411:
+               default:
+                       DBG_OUT((DERR,
+                                "ERR: input color format not supported\n"));
+                       return CI_STATUS_NOTSUPP;
+               }
+
+               switch (self_flag & CI_ISP_DPD_HWRGB_MASK) {
+               case CI_ISP_DPD_HWRGB_565:
+                       mrv_mi_ctrl->mrv_mif_sp_out_form =
+                           CI_ISP_MIF_COL_FORMAT_RGB_565;
+                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_PLANAR;
+                       break;
+               case CI_ISP_DPD_HWRGB_666:
+                       mrv_mi_ctrl->mrv_mif_sp_out_form =
+                           CI_ISP_MIF_COL_FORMAT_RGB_666;
+                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_PLANAR;
+                       break;
+               case CI_ISP_DPD_HWRGB_888:
+                       mrv_mi_ctrl->mrv_mif_sp_out_form =
+                           CI_ISP_MIF_COL_FORMAT_RGB_888;
+                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_PLANAR;
+                       DBG_DD(("CI_ISP_MIF_COL_FORMAT_RGB_888\n"));
+                       break;
+               case CI_ISP_DPD_YUV_420:
+                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_PLANAR;
+                       mrv_mi_ctrl->mrv_mif_sp_out_form =
+                               CI_ISP_MIF_COL_FORMAT_YCBCR_420;
+                       break;
+               case CI_ISP_DPD_YUV_422:
+                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_PLANAR;
+                       mrv_mi_ctrl->mrv_mif_sp_out_form =
+                               CI_ISP_MIF_COL_FORMAT_YCBCR_422;
+                       break;
+               case CI_ISP_DPD_YUV_NV12:
+                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_SEMI_PLANAR;
+                       mrv_mi_ctrl->mrv_mif_sp_out_form =
+                               CI_ISP_MIF_COL_FORMAT_YCBCR_420;
+                       break;
+               case CI_ISP_DPD_YUV_YUYV:
+                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_INTERLEAVED;
+                       mrv_mi_ctrl->mrv_mif_sp_out_form =
+                               CI_ISP_MIF_COL_FORMAT_YCBCR_422;
+                       break;
+
+               case CI_ISP_DPD_HWRGB_OFF:
+                       mrv_mi_ctrl->mrv_mif_sp_out_form =
+                           mrv_mi_ctrl->mrv_mif_sp_in_form;
+
+                       mrv_mi_ctrl->mrv_mif_sp_pic_form =
+                               CI_ISP_MIF_PIC_FORM_PLANAR;
+                       break;
+               default:
+                       DBG_OUT((DERR,
+                                "ERR:  output color format not supported\n"));
+                       return CI_STATUS_NOTSUPP;
+               }
+
+               switch (self_flag &
+                       (CI_ISP_DPD_90DEG_CCW | CI_ISP_DPD_V_FLIP |
+                        CI_ISP_DPD_H_FLIP)) {
+               case (CI_ISP_DPD_H_FLIP):
+                       mrv_mi_ctrl->mrv_mif_sp_mode =
+                       CI_ISP_MIF_SP_HORIZONTAL_FLIP;
+                       break;
+               case (CI_ISP_DPD_V_FLIP):
+                       mrv_mi_ctrl->mrv_mif_sp_mode =
+                       CI_ISP_MIF_SP_VERTICAL_FLIP;
+                       break;
+               case (CI_ISP_DPD_V_FLIP | CI_ISP_DPD_H_FLIP):
+                       mrv_mi_ctrl->mrv_mif_sp_mode =
+                       CI_ISP_MIF_SP_ROTATION_180_DEG;
+                       break;
+               case (CI_ISP_DPD_90DEG_CCW):
+                       mrv_mi_ctrl->mrv_mif_sp_mode =
+                       CI_ISP_MIF_SP_ROTATION_090_DEG;
+                       break;
+               case (CI_ISP_DPD_90DEG_CCW | CI_ISP_DPD_H_FLIP):
+                       mrv_mi_ctrl->mrv_mif_sp_mode =
+                       CI_ISP_MIF_SP_ROT_270_V_FLIP;
+                       break;
+               case (CI_ISP_DPD_90DEG_CCW | CI_ISP_DPD_V_FLIP):
+                       mrv_mi_ctrl->mrv_mif_sp_mode =
+                       CI_ISP_MIF_SP_ROT_090_V_FLIP;
+                       break;
+               case (CI_ISP_DPD_90DEG_CCW | CI_ISP_DPD_V_FLIP |
+                       CI_ISP_DPD_H_FLIP):
+                       mrv_mi_ctrl->mrv_mif_sp_mode =
+                       CI_ISP_MIF_SP_ROTATION_270_DEG;
+                       break;
+               default:
+                       mrv_mi_ctrl->mrv_mif_sp_mode = CI_ISP_MIF_SP_ORIGINAL;
+                       break;
+               }
+
+       } else {
+               mrv_mi_ctrl->self_path = CI_ISP_PATH_OFF;
+       }
+       return CI_STATUS_SUCCESS;
+}
+
+static int ci_calc_dp_mux_settings(const struct ci_isp_mi_ctrl *mi_ctrl,
+                                      enum ci_isp_ycs_chn_mode *peYcsChnMode,
+                                      enum ci_isp_dp_switch *peDpSwitch)
+{
+       switch (mi_ctrl->main_path) {
+       case CI_ISP_PATH_RAW8:
+       case CI_ISP_PATH_RAW816:
+               *peDpSwitch = CI_ISP_DP_RAW;
+               *peYcsChnMode = CI_ISP_YCS_MVRaw;
+               if (mi_ctrl->self_path != CI_ISP_PATH_OFF) {
+                       DBG_OUT((DERR,
+                                "ERR: ombined with RAW mode of main path\n"));
+                       return CI_STATUS_NOTSUPP;
+               }
+               break;
+
+       case CI_ISP_PATH_JPE:
+               *peDpSwitch = CI_ISP_DP_JPEG;
+               if (mi_ctrl->self_path != CI_ISP_PATH_OFF)
+                       *peYcsChnMode = CI_ISP_YCS_MV_SP;
+               else
+                       *peYcsChnMode = CI_ISP_YCS_MV;
+               break;
+
+       case CI_ISP_PATH_ON:
+               *peDpSwitch = CI_ISP_DP_MV;
+               if (mi_ctrl->self_path != CI_ISP_PATH_OFF)
+                       *peYcsChnMode = CI_ISP_YCS_MV_SP;
+               else
+                       *peYcsChnMode = CI_ISP_YCS_MV;
+               break;
+
+       case CI_ISP_PATH_OFF:
+               *peDpSwitch = CI_ISP_DP_MV;
+               if (mi_ctrl->self_path != CI_ISP_PATH_OFF)
+                       *peYcsChnMode = CI_ISP_YCS_SP;
+               else
+                       *peYcsChnMode = CI_ISP_YCS_OFF;
+               break;
+
+       default:
+               ASSERT(0);
+
+       }
+
+       return CI_STATUS_SUCCESS;
+}
+
+#define ISPWND_COMBINE_WNDS    0x00000001
+#define ISPWND_APPLY_OUTFORM   0x00000002
+#define ISPWND_APPLY_ISCONF    0x00000004
+#define ISPWND_NO_CROPPING     0x00000008
+
+static u32 ci_get_isp_wnd_style(enum ci_isp_path isp_path)
+{
+       u32 res = 0;
+       /* image stabilization in both bayer and YCbCr paths */
+       if ((isp_path == CI_ISP_PATH_BAYER) ||
+           (isp_path == CI_ISP_PATH_YCBCR))
+               res = ISPWND_APPLY_OUTFORM | ISPWND_APPLY_ISCONF;
+       else
+               res = ISPWND_COMBINE_WNDS | ISPWND_APPLY_OUTFORM;
+       return res;
+}
+
+static int ci_set_isp_windows(
+       const struct ci_sensor_config *isi_sensor_config,
+       const struct ci_isp_window *wnd_blackline,
+       const struct ci_isp_window *wnd_zoom_crop)
+{
+       struct ci_isp_window wnd_out_form;
+       struct ci_isp_is_config is_conf;
+       enum ci_isp_path isp_path;
+       u32 wnd_style;
+
+       memset(&wnd_out_form, 0, sizeof(wnd_out_form));
+       memset(&is_conf, 0, sizeof(is_conf));
+
+       isp_path = ci_isp_select_path(isi_sensor_config, NULL);
+       if (isp_path == CI_ISP_PATH_UNKNOWN) {
+               DBG_OUT((DERR,
+                        "failed to detect marvin ISP path to use\n"));
+               return CI_STATUS_NOTSUPP;
+       }
+
+       wnd_style = ci_get_isp_wnd_style(isp_path);
+       if (wnd_style & ISPWND_NO_CROPPING) {
+               u16 isiX;
+               u16 isiY;
+               (void)ci_sensor_res2size(isi_sensor_config->res, &isiX,
+                                 &isiY);
+               if ((wnd_zoom_crop->hsize != isiX)
+                   || (wnd_zoom_crop->vsize != isiY)
+                   || (wnd_zoom_crop->hoffs != 0)
+                   || (wnd_zoom_crop->voffs != 0)) {
+                       DBG_OUT((DERR,
+                                "not supported in selected ISP data path\n"));
+                       return CI_STATUS_NOTSUPP;
+               }
+               if ((wnd_blackline->hsize != isiX) ||
+                   (wnd_blackline->vsize != isiY) ||
+                   (wnd_blackline->hoffs != 0) ||
+                   (wnd_blackline->voffs != 0)) {
+                       DBG_OUT((DERR,
+                                " not supported in selected ISP data path\n"));
+                       return CI_STATUS_NOTSUPP;
+               }
+       }
+
+       is_conf.max_dx = wnd_zoom_crop->hoffs;
+       is_conf.max_dy = wnd_zoom_crop->voffs;
+       is_conf.mrv_is_window = *wnd_zoom_crop;
+
+       /* combine both blackline and zoom/crop window */
+       if (wnd_style & ISPWND_COMBINE_WNDS) {
+               /* combine both blackline and zoom/crop window */
+               wnd_out_form = *wnd_zoom_crop;
+               wnd_out_form.voffs += wnd_blackline->voffs;
+               wnd_out_form.hoffs += wnd_blackline->hoffs;
+               is_conf.mrv_is_window = wnd_out_form;
+               if (wnd_style & ISPWND_APPLY_OUTFORM) {
+                       is_conf.mrv_is_window.hoffs = 0;
+                       is_conf.mrv_is_window.voffs = 0;
+               }
+       } else {
+               wnd_out_form = *wnd_blackline;
+               is_conf.mrv_is_window = *wnd_zoom_crop;
+       }
+
+       /* finally, apply the settings to marvin */
+       if (wnd_style & ISPWND_APPLY_OUTFORM) {
+               ci_isp_set_output_formatter(&wnd_out_form,
+                                        CI_ISP_CFG_UPDATE_IMMEDIATE);
+       }
+       if (wnd_style & ISPWND_APPLY_ISCONF) {
+               int res = ci_isp_is_set_config(&is_conf);
+               if (res != CI_STATUS_SUCCESS) {
+                       DBG_OUT((DERR,
+                                "ERR: set image stabilization config\n"));
+                       return res;
+               }
+       }
+
+       /* success - remember our virtual settings */
+       last_isp_wnds.wnd_blacklines = *wnd_blackline;
+       last_isp_wnds.wnd_zoom_crop = *wnd_zoom_crop;
+       return CI_STATUS_SUCCESS;
+}
+
+static int ci_ext_ycb_cr_mode(const struct ci_isp_datapath_desc *path)
+{
+
+       u32 main_flag;
+
+       PRE_CONDITION(path != NULL);
+
+       /* assume datapath deactivation if no selfpath pointer is given) */
+       if (path)
+               main_flag = path->flags;
+       else
+               main_flag = 0;
+
+       /* if flag CI_ISP_DPD_YCBCREXT is set set extended YCbCr mode */
+       if (main_flag & CI_ISP_DPD_ENABLE) {
+               if (main_flag & CI_ISP_DPD_YCBCREXT)
+                       ci_isp_set_ext_ycmode();
+
+       }
+
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * Configures main and self data pathes and scaler for data
+ *              coming from the ISP.
+ *
+ * Following MARVIN subsystems are programmed:
+ * - ISP output formatter
+ * - Image stabilization module
+ * - YC-Splitter
+ * - Self path DMA-read multiplexer
+ * - Main path multiplexer
+ * - Main & Self path resizer
+ * - Small output unit
+ * - Memory Interface (MI) input source, en/disable and data format
+ *
+ * Following MARVIN subsystems are *NOT* programmed:
+ * - All ISP functionality but the output formatter & image stabilization
+ * module
+ * - color Processing block
+ * - JPEG encode subsystem (quantisation tables etc.)
+ * - Memory Interface (MI) output buffer addresses and sizes
+ */
+int ci_datapath_isp(const struct ci_pl_system_config *sys_conf,
+                         const struct ci_isp_datapath_desc *main,
+                         const struct ci_isp_datapath_desc *self, int zoom)
+{
+       /* return value of several sub-functions called from here */
+       int res;
+       u32 main_flag;
+       u32 self_flag;
+       /* resolution from sensor configuration */
+       u16 isiX;
+       u16 isiY;
+       const struct ci_isp_datapath_desc *target = NULL;
+
+       /* things to apply to MARVIN */
+       struct ci_isp_scale scale_main;
+       struct ci_isp_scale scale_flag;
+       enum ci_isp_ycs_chn_mode chn_mode = 0;
+       enum ci_isp_dp_switch dp_switch = 0;
+       struct ci_isp_mi_ctrl mrv_mi_ctrl;
+       struct ci_isp_datapath_desc source;
+       /* ISP windowing because of cutting away blacklines from the sensor */
+       struct ci_isp_window wnd_blackline;
+       /* ISP windowing because of aspect ratio change and/or zoom */
+       struct ci_isp_window wnd_zoom_crop;
+
+       /* assume dapapath deactivation for not provided descriptors */
+       main_flag = 0;
+       self_flag = 0;
+       if (main)
+               main_flag = main->flags;        /* 0x012 */
+
+       if (self)
+               self_flag = self->flags;        /* 0x10015 */
+
+       /* initialize variables on the stack */
+       res = CI_STATUS_SUCCESS;
+       (void)ci_sensor_res2size(sys_conf->isi_config->res, &isiX, &isiY);
+       memset(&mrv_mi_ctrl, 0, sizeof(struct ci_isp_mi_ctrl));
+       memset(&wnd_blackline, 0, sizeof(wnd_blackline));
+       memset(&wnd_zoom_crop, 0, sizeof(wnd_zoom_crop));
+
+       wnd_blackline.hsize = isiX;
+       wnd_blackline.vsize = isiY;
+       wnd_zoom_crop = wnd_blackline;
+
+       if ((main_flag & CI_ISP_DPD_ENABLE) &&
+           (main_flag & CI_ISP_DPD_KEEPRATIO)) {
+               target = main;
+       }
+       if ((self_flag & CI_ISP_DPD_ENABLE) &&
+           (self_flag & CI_ISP_DPD_KEEPRATIO)) {
+               if (target) {
+                       DBG_OUT((DERR,
+                               "ERR: only allowed for one path\n"));
+                       return CI_STATUS_NOTSUPP;
+               }
+               target = self;
+       }
+
+       /* if so, calculate the cropping */
+       if (target) {
+               u32 aspect_cam =
+                   (0x1000 * ((u32) isiX)) / isiY;
+               u32 aspect_target =
+                   (0x1000 * ((u32) (target->out_w))) /
+                   target->out_h;
+               if (aspect_cam < aspect_target) {
+                       wnd_zoom_crop.vsize =
+                           (u16) (((u32) isiX *
+                                      (u32) (target->
+                                                out_h)) /
+                                     target->out_w);
+               } else  {
+                       wnd_zoom_crop.hsize =
+                           (u16) (((u32) isiY *
+                                      (u32) (target->
+                                                out_w)) /
+                                     target->out_h);
+               }
+       }
+
+       if (zoom > 0) {
+               wnd_zoom_crop.vsize =
+                   (u16) (((u32) (wnd_zoom_crop.vsize) *
+                              1024) / (1024 + (u32) zoom));
+               wnd_zoom_crop.hsize =
+                   (u16) (((u32) (wnd_zoom_crop.hsize) *
+                              1024) / (1024 + (u32) zoom));
+       }
+
+       wnd_zoom_crop.hsize &= ~0x01;
+       wnd_zoom_crop.hoffs = (isiX - wnd_zoom_crop.hsize) / 2;
+       wnd_zoom_crop.voffs = (isiY - wnd_zoom_crop.vsize) / 2;
+
+       switch (sys_conf->isi_config->bls) {
+       case SENSOR_BLS_OFF:
+               break;
+       case SENSOR_BLS_TWO_LINES:
+               wnd_blackline.voffs += 2;
+               break;
+       case SENSOR_BLS_FOUR_LINES:
+               wnd_blackline.voffs += 2;
+               break;
+       default:
+               DBG_OUT((DERR,
+                       "black sensor config\n"));
+               return CI_STATUS_NOTSUPP;
+       }
+
+       if (sys_conf->isi_config->bls != SENSOR_BLS_OFF) {
+               if (((main_flag & CI_ISP_DPD_ENABLE)
+                    && (main_flag & CI_ISP_DPD_BLACKLINES_TOP))
+                   || ((self_flag & CI_ISP_DPD_ENABLE)
+                       && (self_flag & CI_ISP_DPD_BLACKLINES_TOP))) {
+                       if ((main_flag & CI_ISP_DPD_ENABLE)
+                           && (self_flag & CI_ISP_DPD_ENABLE)
+                           && ((main_flag & CI_ISP_DPD_BLACKLINES_TOP)
+                               !=
+                               (self_flag &
+                                CI_ISP_DPD_BLACKLINES_TOP))) {
+                               DBG_OUT((DERR,
+                                        "in main and self path\n"));
+                               return CI_STATUS_NOTSUPP;
+                       }
+                       wnd_blackline.voffs = 0;
+                       wnd_zoom_crop.voffs = 0;
+               }
+       }
+
+       source.out_w = wnd_zoom_crop.hsize;
+       source.out_h = wnd_zoom_crop.vsize;
+       source.flags = CI_ISP_DPD_DMA_IN_422;
+
+       res = ci_calc_main_path_settings(&source, main, &scale_main,
+               &mrv_mi_ctrl);
+       if (res != CI_STATUS_SUCCESS)
+               return res;
+
+       /* additional settings specific for main path fed from ISP */
+       if (main_flag & CI_ISP_DPD_ENABLE) {
+               switch (main_flag & CI_ISP_DPD_MODE_MASK) {
+               case CI_ISP_DPD_MODE_ISPYC:
+               case CI_ISP_DPD_MODE_ISPRAW:
+               case CI_ISP_DPD_MODE_ISPRAW_16B:
+               case CI_ISP_DPD_MODE_ISPJPEG:
+                       break;
+               default:
+                       DBG_OUT((DERR,
+                                "supported for data coming from the ISP\n"));
+                       return CI_STATUS_NOTSUPP;
+               }
+       }
+
+       res = ci_calc_self_path_settings(&source, self, &scale_flag,
+               &mrv_mi_ctrl);
+       if (res != CI_STATUS_SUCCESS)
+               return res;
+
+       if (sys_conf->isp_cfg->flags.fYCbCrNonCosited)
+               mrv_mi_ctrl.mrv_mif_spInPhase = mrv_mif_col_Phase_Non_Cosited;
+       else
+               mrv_mi_ctrl.mrv_mif_spInPhase = mrv_mif_col_Phase_Cosited;
+       if (sys_conf->isp_cfg->flags.fYCbCrFullRange)
+               mrv_mi_ctrl.mrv_mif_spInRange = mrv_mif_col_Range_Full;
+       else
+               mrv_mi_ctrl.mrv_mif_spInRange = mrv_mif_col_Range_Std;
+       if (self_flag & CI_ISP_DPD_ENABLE) {
+               switch (self_flag & CI_ISP_DPD_MODE_MASK) {
+               case CI_ISP_DPD_MODE_ISPYC:
+                       /* only allowed case, just proceed */
+                       break;
+               default:
+                       DBG_OUT((DERR,
+                                "supported for data coming from the ISP\n"));
+                       return CI_STATUS_NOTSUPP;
+               }
+       }
+
+       /* Datapath multiplexers */
+       res = ci_calc_dp_mux_settings(&mrv_mi_ctrl, &chn_mode, &dp_switch);
+       if (res != CI_STATUS_SUCCESS)
+               return res;
+
+       mrv_mi_ctrl.byte_swap_enable = false;
+       mrv_mi_ctrl.init_vals = CI_ISP_MIF_INIT_OFFSAndBase;
+
+       res = ci_set_isp_windows(sys_conf->isi_config, &wnd_blackline,
+               &wnd_zoom_crop);
+       if (res != CI_STATUS_SUCCESS) {
+               DBG_OUT((DERR,
+                        "ERR: failed to set ISP window configuration\n"));
+               return res;
+       }
+       res = ci_isp_set_data_path(chn_mode, dp_switch);
+       if (res != CI_STATUS_SUCCESS)
+               return res;
+
+       res = ci_isp_set_mipi_smia(sys_conf->isi_config->mode);
+       if (res != CI_STATUS_SUCCESS)
+               return res;
+
+       if (mrv_mi_ctrl.self_path != CI_ISP_PATH_OFF)
+               ci_isp_res_set_self_resize(&scale_flag,
+                       CI_ISP_CFG_UPDATE_IMMEDIATE, ci_get_rsz_lut(self_flag));
+
+       if (mrv_mi_ctrl.main_path != CI_ISP_PATH_OFF)
+               ci_isp_res_set_main_resize(&scale_main,
+                       CI_ISP_CFG_UPDATE_IMMEDIATE, ci_get_rsz_lut(main_flag));
+
+       ci_isp_set_dma_read_mode(CI_ISP_DMA_RD_OFF,
+               CI_ISP_CFG_UPDATE_IMMEDIATE);
+
+       res = ci_isp_mif__set_path_and_orientation(&mrv_mi_ctrl);
+       if (res != CI_STATUS_SUCCESS) {
+               DBG_OUT((DERR,
+                        "ERR:  failed to set MI path and orientation\n"));
+               return res;
+       }
+
+       /* here the extended YCbCr mode is configured */
+       if (sys_conf->isp_cfg->flags.fYCbCrFullRange)
+               res = ci_ext_ycb_cr_mode(main);
+       else
+               (void)ci_isp_set_yc_mode();
+
+       if (res != CI_STATUS_SUCCESS) {
+               DBG_OUT((DERR,
+                        "ERR: failed to set ISP YCbCr extended mode\n"));
+               return res;
+       }
+       return CI_STATUS_SUCCESS;
+}
+
diff --git a/drivers/media/video/mrstci/mrstisp/mrv_sls_jpe.c b/drivers/media/video/mrstci/mrstisp/mrv_sls_jpe.c
new file mode 100644
index 0000000..6bb0d4b
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstisp/mrv_sls_jpe.c
@@ -0,0 +1,53 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * Copyright (c) Silicon Image 2008  www.siliconimage.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#include "stdinc.h"
+#include "mrv_priv.h"
+
+u32 ci_jpe_capture(enum ci_isp_conf_update_time update_time)
+{
+       int retval = CI_STATUS_SUCCESS;
+
+       /* generate header */
+       retval = ci_isp_jpe_generate_header(MRV_JPE_HEADER_MODE_JFIF);
+       if (retval != CI_STATUS_SUCCESS)
+               return 0;
+
+       /* now encode JPEG */
+       retval = ci_jpe_encode(update_time, CI_ISP_JPE_SINGLE_SHOT);
+       if (retval != CI_STATUS_SUCCESS)
+               return 0;
+       return ci_isp_mif_get_byte_cnt();
+}
+
+int ci_jpe_encode(enum ci_isp_conf_update_time update_time,
+       enum ci_isp_jpe_enc_mode mrv_jpe_encMode)
+{
+       ci_isp_jpe_prep_enc(mrv_jpe_encMode);
+       /* start Marvin for 1 frame to capture */
+       ci_isp_start(1, update_time);
+       return ci_isp_jpe_wait_for_encode_done();
+}
+
--
1.5.5

