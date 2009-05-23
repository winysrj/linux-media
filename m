Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36906 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZEWJDq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 May 2009 05:03:46 -0400
Date: Sat, 23 May 2009 06:03:42 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"xlzhang76@gmail.com" <xlzhang76@gmail.com>
Subject: Re: [PATCH 1/5 - part 2] V4L2 patches for Intel Moorestown Camera
 Imaging Drivers
Message-ID: <20090523060342.46eb89aa@pedra.chehab.org>
In-Reply-To: <0A882F4D99BBF6449D58E61AAFD7EDD613810F55@pdsmsx502.ccr.corp.intel.com>
References: <0A882F4D99BBF6449D58E61AAFD7EDD613810F55@pdsmsx502.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok, this is my next comment. I'll avoid to repeat here the generic comments I
made on 1/5 part 1.


Em Mon, 4 May 2009 19:00:24 +0800
"Zhang, Xiaolin" <xiaolin.zhang@intel.com> escreveu:

> From c9523cb1e81f6229c47c244896fd5772a7e9e702 Mon Sep 17 00:00:00 2001
> From: Xiaolin Zhang <xiaolin.zhang@intel.com>
> Date: Mon, 4 May 2009 16:54:56 +0800
> Subject: [PATCH] [Part 2] c files - camera imaging ISP driver on Intel Moorestown platform
>  under v4l2 driver framework.
> 
> Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>

Please, better describe your patch. The same also applies to patch 1/5 part 1.
In general, several of the comments that are sent to patch 0/5 should be,
instead, at patch 1.

> ---
>  drivers/media/video/mrstci/include/ci_isp_common.h |   58 +-
>  drivers/media/video/mrstci/mrstisp/Makefile        |    9 +
>  drivers/media/video/mrstci/mrstisp/intel_v4l2.c    | 1965 ++++++++++++++++++++
>  drivers/media/video/mrstci/mrstisp/mrv.c           |  442 +++++
>  drivers/media/video/mrstci/mrstisp/mrv_col.c       |   66 +
>  drivers/media/video/mrstci/mrstisp/mrv_ie.c        |  237 +++
>  drivers/media/video/mrstci/mrstisp/mrv_is.c        |   66 +
>  drivers/media/video/mrstci/mrstisp/mrv_isp.c       | 1433 ++++++++++++++
>  drivers/media/video/mrstci/mrstisp/mrv_isp_bls.c   |  174 ++
>  drivers/media/video/mrstci/mrstisp/mrv_isp_gamma.c |   87 +
>  drivers/media/video/mrstci/mrstisp/mrv_jpe.c       |  447 +++++
>  drivers/media/video/mrstci/mrstisp/mrv_mif.c       |  677 +++++++
>  drivers/media/video/mrstci/mrstisp/mrv_res.c       |  350 ++++
>  drivers/media/video/mrstci/mrstisp/mrv_sls_bp.c    |   83 +
>  drivers/media/video/mrstci/mrstisp/mrv_sls_dp.c    | 1146 ++++++++++++
>  drivers/media/video/mrstci/mrstisp/mrv_sls_jpe.c   |   53 +
>  16 files changed, 7237 insertions(+), 56 deletions(-)
>  mode change 100755 => 100644 drivers/media/video/mrstci/mrstisp/Kconfig
>  create mode 100644 drivers/media/video/mrstci/mrstisp/Makefile
>  create mode 100644 drivers/media/video/mrstci/mrstisp/intel_v4l2.c
>  create mode 100644 drivers/media/video/mrstci/mrstisp/mrv.c
>  create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_col.c
>  create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_ie.c
>  create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_is.c
>  create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_isp.c
>  create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_isp_bls.c
>  create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_isp_gamma.c
>  create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_jpe.c
>  create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_mif.c
>  create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_res.c
>  create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_sls_bp.c
>  create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_sls_dp.c
>  create mode 100644 drivers/media/video/mrstci/mrstisp/mrv_sls_jpe.c
> 
> diff --git a/drivers/media/video/mrstci/include/ci_isp_common.h b/drivers/media/video/mrstci/include/ci_isp_common.h
> index 090021d..121100b 100644
> --- a/drivers/media/video/mrstci/include/ci_isp_common.h
> +++ b/drivers/media/video/mrstci/include/ci_isp_common.h
> @@ -63,10 +63,6 @@
>  /* JPEG encoding */
> 
>  enum ci_isp_jpe_enc_mode {
> -#if (MARVIN_FEATURE_JPE_CFG == MARVIN_FEATURE_JPE_CFG_V2)
> -       /*single snapshot with Scalado encoding*/
> -       CI_ISP_JPE_SCALADO_MODE = 0x08,
> -#endif

This seems obfuscated to be: You didn't even add all your code, and you're
already removing things? why?

>         /* motion JPEG with header generation */
>         CI_ISP_JPE_LARGE_CONT_MODE = 0x04,
>         /* motion JPEG only first frame with header */
> @@ -106,14 +102,9 @@ struct ci_isp_rsz_lut{
>         u8 rsz_lut[64];
>  };
> 
> -#if (MARVIN_FEATURE_SCALE_FACTORWIDTH == MARVIN_FEATURE_16BITS)
> -/* flag to set in scalefactor values to enable upscaling */
> -#define RSZ_UPSCALE_ENABLE 0x20000
> -#else
>  /* flag to set in scalefactor values to enable upscaling */
>  #define RSZ_UPSCALE_ENABLE 0x8000
> -/* #if (MARVIN_FEATURE_SCALE_FACTORWIDTH == MARVIN_FEATURE_16BITS) */
> -#endif
> +
> 

This seems obfuscated to be: You didn't even add all your code, and you're
already removing things? why?


>  /*
>   * Flag to set in scalefactor values to bypass the scaler block.
> @@ -122,13 +113,8 @@ struct ci_isp_rsz_lut{
>   * words:
>   * RSZ_SCALER_BYPASS = max. scalefactor value> + 1
>   */
> -#if (MARVIN_FEATURE_SCALE_FACTORWIDTH == MARVIN_FEATURE_12BITS)
> -#define RSZ_SCALER_BYPASS  0x1000
> -#elif (MARVIN_FEATURE_SCALE_FACTORWIDTH == MARVIN_FEATURE_14BITS)
>  #define RSZ_SCALER_BYPASS  0x4000
> -#elif (MARVIN_FEATURE_SCALE_FACTORWIDTH == MARVIN_FEATURE_16BITS)
> -#define RSZ_SCALER_BYPASS  0x10000
> -#endif
> +
> 
>  #define RSZ_FLAGS_MASK (RSZ_UPSCALE_ENABLE | RSZ_SCALER_BYPASS)
> 
> @@ -1124,46 +1110,6 @@ struct ci_isp_cac_config {
> 
>  };
> 
> -/*
> - * register values of chromatic aberration correction block (delivered by
> - * the CAC driver)
> - */
> -struct ci_isp_cac_reg_values {
> -       /* maximum red/blue pixel shift in horizontal */
> -       u8 hclip_mode;
> -       /* and vertival direction, range 0..2 */
> -       u8 vclip_mode;
> -       /* TRUE=enabled, FALSE=disabled */
> -       int cac_enabled;
> -       /*
> -        * preload value of the horizontal CAC pixel
> -        * counter, range 1..4095
> -        */
> -       u16 hcount_start;
> -       /*
> -        * preload value of the vertical CAC pixel
> -        * counter, range 1..4095
> -        */
> -       u16 vcount_start;
> -       /* parameters for radial shift calculation, */
> -       u16 ablue;
> -       /* 9 bit twos complement with 4 fractional */
> -       u16 ared;
> -       /* digits, valid range -16..15.9375 */
> -       u16 bblue;
> -       u16 bred;
> -       u16 cblue;
> -       u16 cred;
> -       /* horizontal normalization shift, range 0..7 */
> -       u8 xnorm_shift;
> -       /* horizontal normalization factor, range 16..31 */
> -       u8 xnorm_factor;
> -       /* vertical normalization shift, range 0..7 */
> -       u8 ynorm_shift;
> -       /* vertical normalization factor, range 16..31 */
> -       u8 ynorm_factor;
> -};
> -

This seems obfuscated to be: You didn't even add all your code, and you're
already removing things? why?

I won't repeat my self about it again. Your first patchsets should be consistent.

Due to the big size of your patches, it is a good idea to split your
changesets, but please take care about the order of they, since each patch
individually shouldn't break compilation. Also, send the patches on the order
that are more comprehensive to the reviewers. Something like: first KABI/KAPI
changes, then the basic code, then the ancillary drivers, and lastly the
Kconfig/Makefile changes.

Also, please split any changes into Kconfig/Makefile into a different
changeset, since we may need to rearrange it, if merge conflicts arise when adding it upstream.

>  struct ci_snapshot_config {
>         /*  snapshot flags */
>         u32 flags;
> diff --git a/drivers/media/video/mrstci/mrstisp/Kconfig b/drivers/media/video/mrstci/mrstisp/Kconfig
> old mode 100755
> new mode 100644
> diff --git a/drivers/media/video/mrstci/mrstisp/Makefile b/drivers/media/video/mrstci/mrstisp/Makefile
> new file mode 100644
> index 0000000..663e2ba
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/Makefile
> @@ -0,0 +1,9 @@
> +mrstisp-objs   := mrv_is.o mrv_ie.o mrv_jpe.o \
> +                mrv_isp.o mrv_sls_bp.o mrv_mif.o  \
> +                mrv_sls_dp.o mrv_isp_bls.o  mrv_isp_gamma.o \
> +                mrv_sls_jpe.o mrv.o mrv_isp.o \
> +                mrv_col.o mrv_is.o mrv_res.o intel_v4l2.o
> +
> +obj-$(CONFIG_VIDEO_MRST_ISP)    += mrstisp.o
> +
> +EXTRA_CFLAGS   +=      -I$(src)/../include -I$(src)/include
> \ No newline at end of file
> diff --git a/drivers/media/video/mrstci/mrstisp/intel_v4l2.c b/drivers/media/video/mrstci/mrstisp/intel_v4l2.c
> new file mode 100644
> index 0000000..041da05
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/intel_v4l2.c
> @@ -0,0 +1,1965 @@
> +/*
> + * Support for Moorestown Langwell Camera Imaging ISP subsystem.
> + *
> + * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> + * 02110-1301, USA.
> + *
> + *
> + * Xiaolin Zhang <xiaolin.zhang@intel.com>
> + */
> +
> +#include <linux/syscalls.h>
> +#include "stdinc.h"
> +#include "ci_isp_fmts_common.h"
> +#include <linux/i2c.h>
> +#include <linux/gpio.h>
> +
> +static int video_nr = -1;
> +int km_debug;

If you really need a global symbol here, please take care about its name, since
it should be unique. So, it would be better to use a prefix that you'll be sure nobody will ever use it, like:

int mrstci_debug;

Although it is not mandatory, the better is to use the module prefix on your
static functions (and constants) as well, since you may need to declare one of
them as global, and to provide a consistent naming over the driver.

> +
> +static int pci_driver_loaded;
> +static struct intel_isp_device intel_isp_v4l_device;
> +struct intel_isp_device *g_intel;
> +
> +/* !initialized struct to hold the specific configuration */
> +static struct ci_sensor_config isi_config;
> +static struct ci_sensor_caps isi_caps;
> +
> +static struct ci_isp_config s_config;

Please describe your static vars. Also, I suspect that you're doing something
wrong here: Why do you need so many static vars that seems to reflect your config?
Shouldn't you be allocating those dynamically at module load, having here just a list?

Would it be possible to have more than one driver instance?

> +
> +struct ci_isp_dbg_status {
> +       u32 isp_imsc;
> +       u32 mi_imsc;
> +       u32 jpe_error_imsc;
> +       u32 jpe_status_imsc;
> +};
> +
> +/* g45-th20-b5 gamma out curve with enhanced black level */
> +static struct ci_isp_gamma_out_curve g45_th20_b5 = {
> +       {
> +        0x0000, 0x0014, 0x003C, 0x0064,
> +        0x00A0, 0x0118, 0x0171, 0x01A7,
> +        0x01D8, 0x0230, 0x027A, 0x02BB,
> +        0x0323, 0x0371, 0x03AD, 0x03DB,
> +        0x03FF}
> +       ,
> +       0
> +};
> +
> +static unsigned long jiffies_start;
> +void intel_timer_start(void)
> +{
> +       jiffies_start = jiffies;
> +
> +}
> +void intel_timer_stop(void)
> +{
> +       jiffies_start = 0;
> +}
> +unsigned long intel_get_micro_sec(void)
> +{
> +       unsigned long time_diff = 0;
> +
> +       time_diff = jiffies - jiffies_start;
> +
> +       return jiffies_to_msecs(time_diff);
> +
> +
> +}
> +void intel_sleep_micro_sec(unsigned long micro_sec)
> +{
> +       mdelay(micro_sec);
> +}

Don't re-invent the wheel! there are already functions for doing time diff at
kernel. Also, what's the sense of renaming mdelay to some obfucated naming, and
creating global symbols for they???

> +
> +void intel_dbg_dd_out(u32 category, const char *pszFormat, ...)
> +{
> +       va_list     arglist;
> +       va_start(arglist, pszFormat);
> +
> +       if (km_debug >= 1) {
> +               printk(KERN_INFO "intel_v4l: ");
> +               printk(pszFormat, arglist);
> +       }
> +       va_end(arglist);
> +}

It is better to use a macro instead of (again) reinventing the wheel. You'll
see several macros for debugs at v4l code.

> +
> +static int intel_mrvisp_set_colorconversion_ex(void)
> +{
> +       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_0, MRV_ISP_CC_COEFF_0,
> +           0x00001021);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_1, MRV_ISP_CC_COEFF_1,
> +           0x00001040);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_2, MRV_ISP_CC_COEFF_2,
> +           0x0000100D);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_3, MRV_ISP_CC_COEFF_3,
> +           0x00000FED);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_4, MRV_ISP_CC_COEFF_4,
> +           0x00000FDB);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_5, MRV_ISP_CC_COEFF_5,
> +           0x00001038);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_6, MRV_ISP_CC_COEFF_6,
> +           0x00001038);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_7, MRV_ISP_CC_COEFF_7,
> +           0x00000FD1);
> +       REG_SET_SLICE(mrv_reg->isp_cc_coeff_8, MRV_ISP_CC_COEFF_8,
> +           0x00000FF7);
> +       return CI_STATUS_SUCCESS;
> +
> +}
> +
> +static unsigned long kvirt_to_pa(unsigned long adr)
> +{
> +       unsigned long kva, ret;
> +
> +       kva = (unsigned long)page_address(vmalloc_to_page((void *)adr));
> +       kva |= adr & (PAGE_SIZE - 1);   /* restore the offset */
> +       ret = __pa(kva);
> +       return ret;
> +}
> +
> +static int intel_defcfg_all_load(struct ci_isp_config *isp_config,
> +       struct ci_sensor_config *isi_config)
> +{
> +
> +       if (isp_config == NULL) {
> +               DBG_DD(("isp_config is null\n"));
> +               return CI_STATUS_NULL_POINTER;
> +       }
> +
> +       if (isi_config == NULL) {
> +               DBG_DD(("isi_config is null\n"));
> +               return CI_STATUS_NULL_POINTER;
> +       }
> +       isp_config->demosaic_mode = CI_ISP_DEMOSAIC_ENHANCED;
> +       /* bpc */
> +       isp_config->bpc_cfg.bp_corr_type = CI_ISP_BP_CORR_DIRECT;
> +       isp_config->bpc_cfg.bp_corr_rep = CI_ISP_BP_CORR_REP_NB;
> +       isp_config->bpc_cfg.bp_corr_mode = CI_ISP_BP_CORR_HOT_DEAD_EN;
> +       isp_config->bpc_cfg.bp_abs_hot_thres = 496;
> +       isp_config->bpc_cfg.bp_abs_dead_thres = 20;
> +       isp_config->bpc_cfg.bp_dev_hot_thres = 328;
> +       isp_config->bpc_cfg.bp_dev_dead_thres = 328;
> +       isp_config->bpd_cfg.bp_dead_thres = 1;
> +
> +       /* WB */
> +       isp_config->wb_config.mrv_wb_mode = CI_ISP_AWB_AUTO;
> +       isp_config->wb_config.mrv_wb_sub_mode = CI_ISP_AWB_AUTO_ON;
> +       isp_config->wb_config.awb_pca_damping = 16;
> +       isp_config->wb_config.awb_prior_exp_damping = 12;
> +       isp_config->wb_config.awb_pca_push_damping = 16;
> +       isp_config->wb_config.awb_prior_exp_push_damping = 12;
> +       isp_config->wb_config.awb_auto_max_y = 254;
> +       isp_config->wb_config.awb_push_max_y = 250;
> +       isp_config->wb_config.awb_measure_max_y = 200;
> +       isp_config->wb_config.awb_underexp_det = 10;
> +       isp_config->wb_config.awb_push_underexp_det = 170;
> +
> +       /* CAC */
> +       isp_config->cac_config.hsize = 2048;
> +       isp_config->cac_config.vsize = 1536;
> +       isp_config->cac_config.hcenter_offset = 0;
> +       isp_config->cac_config.vcenter_offset = 0;
> +       isp_config->cac_config.hclip_mode = 1;
> +       isp_config->cac_config.vclip_mode = 2;
> +       isp_config->cac_config.ablue = 24;
> +       isp_config->cac_config.ared = 489;
> +       isp_config->cac_config.bblue = 450;
> +       isp_config->cac_config.bred = 53;
> +       isp_config->cac_config.cblue = 40;
> +       isp_config->cac_config.cred = 479;
> +       isp_config->cac_config.aspect_ratio = 0.000000;
> +
> +       /* BLS */
> +       isp_config->bls_cfg.enable_automatic = 0;
> +       isp_config->bls_cfg.disable_h = 0;
> +       isp_config->bls_cfg.disable_v = 0;
> +       isp_config->bls_cfg.isp_bls_window1.enable_window = 0;
> +       isp_config->bls_cfg.isp_bls_window1.start_h = 0;
> +       isp_config->bls_cfg.isp_bls_window1.stop_h = 0;
> +       isp_config->bls_cfg.isp_bls_window1.start_v = 0;
> +       isp_config->bls_cfg.isp_bls_window1.stop_v = 0;
> +       isp_config->bls_cfg.isp_bls_window2.enable_window = 0;
> +       isp_config->bls_cfg.isp_bls_window2.start_h = 0;
> +       isp_config->bls_cfg.isp_bls_window2.stop_h = 0;
> +       isp_config->bls_cfg.isp_bls_window2.start_v = 0;
> +       isp_config->bls_cfg.isp_bls_window2.stop_v = 0;
> +       isp_config->bls_cfg.bls_samples = 5;
> +       isp_config->bls_cfg.bls_subtraction.fixed_a = 0x100;
> +       isp_config->bls_cfg.bls_subtraction.fixed_b = 0x100;
> +       isp_config->bls_cfg.bls_subtraction.fixed_c = 0x100;
> +       isp_config->bls_cfg.bls_subtraction.fixed_d = 0x100;
> +
> +       /* AF */
> +       isp_config->af_cfg.wnd_pos_a.hoffs = 874;
> +       isp_config->af_cfg.wnd_pos_a.voffs = 618;
> +       isp_config->af_cfg.wnd_pos_a.hsize = 300;
> +       isp_config->af_cfg.wnd_pos_a.vsize = 300;
> +
> +       /* color */
> +       isp_config->color.contrast = 128;
> +       isp_config->color.brightness = 0;
> +       isp_config->color.saturation = 128;
> +       isp_config->color.hue = 0;
> +
> +       /* Img Effect */
> +       isp_config->img_eff_cfg.mode = CI_ISP_IE_MODE_OFF;
> +       isp_config->img_eff_cfg.color_sel = 4;
> +       isp_config->img_eff_cfg.color_thres = 128;
> +       isp_config->img_eff_cfg.tint_cb = 108;
> +       isp_config->img_eff_cfg.tint_cr = 141;
> +       isp_config->img_eff_cfg.mat_emboss.coeff_11 = 2;
> +       isp_config->img_eff_cfg.mat_emboss.coeff_12 = 1;
> +       isp_config->img_eff_cfg.mat_emboss.coeff_13 = 0;
> +       isp_config->img_eff_cfg.mat_emboss.coeff_21 = 1;
> +       isp_config->img_eff_cfg.mat_emboss.coeff_22 = 0;
> +       isp_config->img_eff_cfg.mat_emboss.coeff_23 = -1;
> +       isp_config->img_eff_cfg.mat_emboss.coeff_31 = 0;
> +       isp_config->img_eff_cfg.mat_emboss.coeff_32 = -1;
> +       isp_config->img_eff_cfg.mat_emboss.coeff_33 = -2;
> +
> +       isp_config->img_eff_cfg.mat_sketch.coeff_11 = -1;
> +       isp_config->img_eff_cfg.mat_sketch.coeff_12 = -1;
> +       isp_config->img_eff_cfg.mat_sketch.coeff_13 = -1;
> +       isp_config->img_eff_cfg.mat_sketch.coeff_21 = -1;
> +       isp_config->img_eff_cfg.mat_sketch.coeff_22 = 8;
> +       isp_config->img_eff_cfg.mat_sketch.coeff_23 = -1;
> +       isp_config->img_eff_cfg.mat_sketch.coeff_31 = -1;
> +       isp_config->img_eff_cfg.mat_sketch.coeff_32 = -1;
> +       isp_config->img_eff_cfg.mat_sketch.coeff_33 = -1;
> +
> +       /* Framefun */
> +       isp_config->flags.bls = 0;
> +       isp_config->flags.bls_man = 0;
> +       isp_config->flags.bls_smia = 0;
> +       isp_config->flags.blsprint = 0;
> +       isp_config->flags.bls_dis = 0;
> +       isp_config->flags.lsc = 0;
> +       isp_config->flags.lscprint = 0;
> +       isp_config->flags.lsc_dis = 0;
> +       isp_config->flags.bpc = 0;
> +       isp_config->flags.bpcprint = 0;
> +       isp_config->flags.bpc_dis = 0;
> +       isp_config->flags.awb = 0;
> +       isp_config->flags.awbprint = 0;
> +       isp_config->flags.awbprint2 = 0;
> +       isp_config->flags.awb_dis = 1;
> +       isp_config->flags.aec = 0;
> +       isp_config->flags.aecprint = 0;
> +       isp_config->flags.aec_dis = 0;
> +       isp_config->flags.af = 0;
> +       isp_config->flags.afprint = 0;
> +       isp_config->flags.af_dis = 0;
> +       isp_config->flags.cp = 0;
> +       isp_config->flags.gamma = 0;
> +       isp_config->flags.cconv = 0;
> +       isp_config->flags.demosaic = 0;
> +       isp_config->flags.gamma2 = 0;
> +       isp_config->flags.isp_filters = 0;
> +       isp_config->flags.cac = 0;
> +       isp_config->flags.cp_sat_loop = 0;
> +       isp_config->flags.cp_contr_loop = 0;
> +       isp_config->flags.cp_bright_loop = 0;
> +       isp_config->flags.scaler_loop = 0;
> +       isp_config->flags.cconv_basic = 0;
> +       isp_config->flags.continous_af = 0;
> +       isp_config->flags.bad_pixel_generation = 0;
> +       isp_config->demosaic_th = 4;
> +       isp_config->exposure = 80;
> +       isp_config->advanced_aec_mode = 0;
> +       isp_config->report_details = 0xffffffff;
> +
> +       /* flags = 0x00024010*/
> +       isp_config->view_finder.flags = VFFLAG_HWRGB;
> +       isp_config->view_finder.zoom = 0;
> +       isp_config->view_finder.lcd_contrast = 77;
> +       isp_config->view_finder.x = 0;
> +       isp_config->view_finder.y = 0;
> +       isp_config->view_finder.w = 100;
> +       isp_config->view_finder.h = 75;
> +       isp_config->view_finder.keep_aspect = 1;
> +
> +       isp_config->snapshot_a.flags = 0x00010000;
> +       isp_config->snapshot_a.user_zoom = 0;
> +       isp_config->snapshot_a.user_w = 640;
> +       isp_config->snapshot_a.user_h = 480;
> +       isp_config->snapshot_a.compression_ratio = 1;
> +
> +       isp_config->afm_mode = 1;
> +       isp_config->afss_mode = 3;
> +       isp_config->filter_level_noise_reduc = 4;
> +       isp_config->filter_level_sharp = 4;
> +
> +       isp_config->snapshot_b.flags = 0x00000007;
> +       isp_config->snapshot_b.user_zoom = 0;
> +       isp_config->snapshot_b.user_w = 640;
> +       isp_config->snapshot_b.user_h = 480;
> +       isp_config->snapshot_b.compression_ratio = 1;
> +       return 0;
> +}

Wouldn't be better to use a static table and just copy or point to it?

> +
> +static void intel_update_marvinvfaddr(struct intel_isp_device *intel)
> +{
> +       struct ci_isp_mi_path_conf isp_mi_path_conf;
> +       u32 bufsize = 0;
> +       u32 w;
> +       u32 h;
> +       u32 offset = 0;
> +
> +       memset(&isp_mi_path_conf, 0, sizeof(struct ci_isp_mi_path_conf));
> +
> +       w = isp_mi_path_conf.llength = intel->bufwidth;
> +       h = isp_mi_path_conf.ypic_height = intel->bufheight;
> +       isp_mi_path_conf.ypic_width = intel->bufwidth;
> +
> +       if (intel->pixelformat == V4L2_PIX_FMT_YUV420 ||
> +               intel->pixelformat == V4L2_PIX_FMT_YVU420 ||
> +               intel->pixelformat == V4L2_PIX_FMT_YUV422P ||
> +               intel->pixelformat == V4L2_PIX_FMT_NV12) {
> +               bufsize = w*h;

You should check all your patches against CodingStyle with checkpatch.pl. The correct style is:
               bufsize = w * h;


> +       } else
> +               bufsize = intel->frame_size;
> +       offset = intel->cap_frame * PAGE_ALIGN(intel->frame_size);
> +       intel->capbuf = intel->mb1_va + offset;
> +       intel->capbuf_pa = intel->mb1 + offset;
> +       DBG_DD(("UpdateMarvinAddr:\n"));
> +       DBG_DD(("buf w:%d, h:%d, cap id=%d, Fsize:%d, Bsize: %d\n",
> +               w, h, intel->cap_frame, intel->frame_size, bufsize));
> +       DBG_DD(("cap buf va 0x%p, pa 0x%x\n", intel->capbuf, intel->capbuf_pa));
> +
> +       /* buffer size in bytes */
> +       if (intel->pixelformat == V4L2_PIX_FMT_YUV420 ||
> +               intel->pixelformat == V4L2_PIX_FMT_YVU420) {
> +               DBG_DD(("yuv420 fmt\n"));
> +               isp_mi_path_conf.ybuffer.size = bufsize;
> +               isp_mi_path_conf.cb_buffer.size = bufsize/4;
> +               isp_mi_path_conf.cr_buffer.size = bufsize/4;
> +       } else if (intel->pixelformat == V4L2_PIX_FMT_YUV422P) {
> +               DBG_DD(("yuv422 fmt\n"));
> +               isp_mi_path_conf.ybuffer.size = bufsize;
> +               isp_mi_path_conf.cb_buffer.size = bufsize/2;
> +               isp_mi_path_conf.cr_buffer.size = bufsize/2;
> +       } else if (intel->pixelformat == V4L2_PIX_FMT_NV12) {
> +               DBG_DD(("nv12 fmt\n"));
> +               isp_mi_path_conf.ybuffer.size = bufsize;
> +               isp_mi_path_conf.cb_buffer.size = bufsize/2;
> +               isp_mi_path_conf.cr_buffer.size = 0;
> +       } else {
> +               /* JPEG fmt and RGB and Bayer pattern fmt */
> +               DBG_DD(("jpeg and rgb fmt\n"));
> +               isp_mi_path_conf.ybuffer.size = bufsize;
> +               isp_mi_path_conf.cb_buffer.size = 0;
> +               isp_mi_path_conf.cr_buffer.size = 0;
> +       }
> +
> +       if (isp_mi_path_conf.ybuffer.size != 0) {
> +               /* buffer start address */
> +               isp_mi_path_conf.ybuffer.pucbuffer = (u8 *)(unsigned long)
> +                       intel->capbuf_pa;
> +       }
> +
> +       if (isp_mi_path_conf.cb_buffer.size != 0) {
> +               /* buffer start address */
> +               isp_mi_path_conf.cb_buffer.pucbuffer =
> +                       isp_mi_path_conf.ybuffer.pucbuffer +
> +                       isp_mi_path_conf.ybuffer.size;
> +       }
> +
> +       if (isp_mi_path_conf.cr_buffer.size != 0) {
> +               isp_mi_path_conf.cr_buffer.pucbuffer =
> +                       isp_mi_path_conf.cb_buffer.pucbuffer +
> +                       isp_mi_path_conf.cb_buffer.size;
> +       }
> +       if (intel->pixelformat == V4L2_PIX_FMT_YVU420) {
> +               isp_mi_path_conf.cr_buffer.pucbuffer =
> +                       isp_mi_path_conf.ybuffer.pucbuffer +
> +                       isp_mi_path_conf.ybuffer.size;
> +               isp_mi_path_conf.cb_buffer.pucbuffer =
> +                       isp_mi_path_conf.cr_buffer.pucbuffer +
> +                       isp_mi_path_conf.cr_buffer.size;
> +       }
> +       if (intel->sys_conf.isp_cfg->view_finder.flags &
> +               VFFLAG_USE_MAINPATH) {
> +               ci_isp_mif__set_main_buffer(&isp_mi_path_conf,
> +                       CI_ISP_CFG_UPDATE_FRAME_SYNC);
> +       } else {
> +               ci_isp_mif__set_self_buffer(&isp_mi_path_conf,
> +                       CI_ISP_CFG_UPDATE_FRAME_SYNC);
> +       }
> +}
> +
> +static void init_frame_queue(struct fifo *queue)
> +{
> +       int i;
> +       for (i = 0; i < INTEL_CAPTURE_BUFFERS; i++) {
> +               queue->data[i] = -1;
> +               queue->info[i].state = S_UNUSED;
> +               queue->info[i].flags = 0;
> +       }
> +       queue->front = 0;
> +       queue->back = 0;
> +}
> +
> +static void add_frame_to_queue(struct fifo *queue, int frame)
> +{
> +       queue->data[queue->back] = frame;
> +       queue->back = (queue->back + 1) % (INTEL_CAPTURE_BUFFERS + 1);
> +}
> +
> +static int frame_queue_empty(struct fifo *queue)
> +{
> +       return queue->front == queue->back;
> +}
> +
> +static int remove_frame_from_queue(struct fifo *queue)
> +{
> +       int frame;
> +
> +       if (frame_queue_empty(queue))
> +               return -1;
> +
> +       frame = queue->data[queue->front];
> +       queue->front = (queue->front + 1) % (INTEL_CAPTURE_BUFFERS + 1);
> +       return frame;
> +}

Please, don't reinvent the wheel! We have already 3 different flavors of
standard videobuf definitions (for usb, using vmalloc, for scatter/gather DMA
and for continuous DMA). Please use one of them instead of creating your own
video buffer handlers.

> +
> +static int intel_setup_viewfinder_path(
> +       struct intel_isp_device *intel,
> +       int zoom)
> +{
> +       int error = CI_STATUS_SUCCESS;
> +       struct ci_isp_datapath_desc DpMain;
> +       struct ci_isp_datapath_desc DpSelf;
> +       struct ci_isp_rect self_rect;
> +       u16 isi_hsize;
> +       u16 isi_vsize;
> +       u32 dp_mode;
> +       int jpe_scale;
> +       struct ci_pl_system_config *sys_conf = &intel->sys_conf;
> +       struct ci_isp_config *config = sys_conf->isp_cfg;
> +
> +       if (sys_conf->isp_cfg->flags.fYCbCrFullRange)
> +               jpe_scale = false;
> +       else
> +               jpe_scale = true;
> +
> +       memset(&DpMain, 0, sizeof(struct ci_isp_datapath_desc));
> +       memset(&DpSelf, 0, sizeof(struct ci_isp_datapath_desc));
> +
> +       DBG_DD(("view_finder.flags = %x\n", config->view_finder.flags));
> +
> +       self_rect.x = 0;
> +       self_rect.y = 0;
> +       self_rect.w = intel->bufwidth; /* 640 */
> +       self_rect.h = intel->bufheight; /* 480 */
> +
> +       if (intel->pixelformat == V4L2_PIX_FMT_JPEG) {
> +               DBG_DD(("jpeg fmt\n"));
> +               DpMain.flags = CI_ISP_DPD_ENABLE | CI_ISP_DPD_MODE_ISPJPEG;
> +               config->view_finder.flags |= VFFLAG_USE_MAINPATH;
> +               DpMain.out_w = (u16) intel->bufwidth;
> +               DpMain.out_h = (u16) intel->bufheight;
> +       } else if (intel->pixelformat == INTEL_PIX_FMT_RAW08) {
> +               DpMain.flags = CI_ISP_DPD_ENABLE | CI_ISP_DPD_MODE_ISPRAW;
> +               config->view_finder.flags |= VFFLAG_USE_MAINPATH;
> +               /*just take the output of the sensor without any resizing*/
> +               DpMain.flags |= CI_ISP_DPD_NORESIZE;
> +               (void)ci_sensor_res2size(sys_conf->isi_config->res,
> +                       &(DpMain.out_w), &(DpMain.out_h));
> +       } else if (intel->pixelformat == INTEL_PIX_FMT_RAW10 ||
> +               intel->pixelformat == INTEL_PIX_FMT_RAW12) {
> +               DpMain.flags = (CI_ISP_DPD_ENABLE | CI_ISP_DPD_MODE_ISPRAW_16B);
> +               config->view_finder.flags |= VFFLAG_USE_MAINPATH;
> +               /*just take the output of the sensor without any resizing*/
> +               DpMain.flags |= CI_ISP_DPD_NORESIZE;
> +               (void)ci_sensor_res2size(sys_conf->isi_config->res,
> +                       &(DpMain.out_w), &(DpMain.out_h));
> +       } else if (intel->bufwidth > 640 && intel->bufheight >= 480) {
> +               DpMain.flags = (CI_ISP_DPD_ENABLE | CI_ISP_DPD_MODE_ISPYC);
> +               DpMain.out_w = (u16) intel->bufwidth;
> +               DpMain.out_h = (u16) intel->bufheight;
> +               config->view_finder.flags |= VFFLAG_USE_MAINPATH;
> +               if (intel->pixelformat == V4L2_PIX_FMT_YUV420 ||
> +                       intel->pixelformat == V4L2_PIX_FMT_YVU420)
> +                       DpMain.flags |= CI_ISP_DPD_YUV_420 | CI_ISP_DPD_CSS_V2;
> +               else if (intel->pixelformat == V4L2_PIX_FMT_YUV422P)
> +                       DpMain.flags |= CI_ISP_DPD_YUV_422;
> +               else if (intel->pixelformat == V4L2_PIX_FMT_NV12)
> +                       DpMain.flags |= CI_ISP_DPD_YUV_NV12 | CI_ISP_DPD_CSS_V2;
> +               else if (intel->pixelformat == V4L2_PIX_FMT_YUYV)
> +                       DpMain.flags |= CI_ISP_DPD_YUV_YUYV;
> +               else
> +                       DBG_DD(("dpMain.flags is 0x%x\n", DpMain.flags));
> +       } else if (intel->bufwidth <= 640 && intel->bufheight <= 480) {
> +               DpSelf.flags = (CI_ISP_DPD_ENABLE | CI_ISP_DPD_MODE_ISPYC);
> +               if (intel->pixelformat == V4L2_PIX_FMT_YUV420 ||
> +                       intel->pixelformat == V4L2_PIX_FMT_YVU420)
> +                       DpSelf.flags |= CI_ISP_DPD_YUV_420 | CI_ISP_DPD_CSS_V2;
> +               else if (intel->pixelformat == V4L2_PIX_FMT_YUV422P)
> +                       DpSelf.flags |= CI_ISP_DPD_YUV_422;
> +               else if (intel->pixelformat == V4L2_PIX_FMT_NV12)
> +                       DpSelf.flags |= CI_ISP_DPD_YUV_NV12 | CI_ISP_DPD_CSS_V2;
> +               else if (intel->pixelformat == V4L2_PIX_FMT_YUYV)
> +                       DpSelf.flags |= CI_ISP_DPD_YUV_YUYV;
> +               else if (intel->pixelformat == V4L2_PIX_FMT_RGB565)
> +                       DpSelf.flags |= CI_ISP_DPD_HWRGB_565;
> +               else if (intel->pixelformat == V4L2_PIX_FMT_BGR32)
> +                       DpSelf.flags |= CI_ISP_DPD_HWRGB_888;
> +               else
> +                       DBG_DD(("DpSelf.flags is 0x%x\n", DpSelf.flags));
> +       }

Due to your own abstraction layer, your code got obfuscated and confused. Just
pass pixformat over your code, without renaming each V4L2 API name.


> +       DBG_DD(("sensor_res = %x\n", sys_conf->isi_config->res));
> +       (void)ci_sensor_res2size(sys_conf->isi_config->res, &isi_hsize,
> +           &isi_vsize);
> +
> +       DBG_DD(("self path: w:%d, h:%d; sensor: w:%d, h:%d\n",
> +               self_rect.w, self_rect.h, isi_hsize, isi_vsize));
> +       DBG_DD(("main path: out_w:%d, out_h:%d \n",
> +               DpMain.out_w, DpMain.out_h));
> +
> +       DpSelf.out_w = (u16) self_rect.w;
> +       DpSelf.out_h = (u16) self_rect.h;
> +
> +       if (sys_conf->isp_cfg->view_finder.flags & VFFLAG_HWRGB) {
> +               if (intel->pixelformat == V4L2_PIX_FMT_RGB565)
> +                       DpSelf.flags |= CI_ISP_DPD_HWRGB_565;
> +               if (intel->pixelformat == V4L2_PIX_FMT_BGR32)
> +                       DpSelf.flags |= CI_ISP_DPD_HWRGB_888;
> +
> +       } else {
> +               DBG_DD(("don't use the HWRGB conversion\n"));
> +
> +       }
> +
> +       if (sys_conf->isp_cfg->view_finder.flags & VFFLAG_MIRROR)
> +               DpSelf.flags |= CI_ISP_DPD_H_FLIP;
> +
> +       if (sys_conf->isp_cfg->view_finder.flags & VFFLAG_V_FLIP)
> +               DpSelf.flags |= CI_ISP_DPD_V_FLIP;
> +
> +       if (sys_conf->isp_cfg->view_finder.flags & VFFLAG_ROT90_CCW)
> +               DpSelf.flags |= CI_ISP_DPD_90DEG_CCW;
> +
> +       if (!sys_conf->isp_cfg->flags.af_dis &&
> +           (sys_conf->isp_cfg->afm_mode != CI_ISP_AFM_HW)) {
> +               if (sys_conf->isp_cfg->view_finder.
> +                   flags & VFFLAG_USE_MAINPATH) {
> +                               DBG_DD(("ERR: main path configured to do both"
> +                               "viewfinding and software AF mesurement\n"));
> +                       return CI_STATUS_NOTSUPP;
> +               }
> +
> +               DpMain.flags |= CI_ISP_DPD_ENABLE;
> +       }
> +       /* setup self & main path with zoom */
> +       if (zoom < 0)
> +               zoom = sys_conf->isp_cfg->view_finder.zoom;
> +       if (sys_conf->isp_cfg->view_finder.flags & VFFLAG_USE_MAINPATH) {
> +               DBG_DD(("view finder in mail path\n"));
> +               dp_mode = DpMain.flags & CI_ISP_DPD_MODE_MASK;
> +               if ((dp_mode == CI_ISP_DPD_MODE_ISPRAW) ||
> +                       (dp_mode == CI_ISP_DPD_MODE_ISPRAW_16B)) {
> +                       struct ci_sensor_config isi_conf;
> +                       isi_conf = *sys_conf->isi_config;
> +                       isi_conf.mode = SENSOR_MODE_PICT;
> +                       error = ci_isp_set_input_aquisition(&isi_conf);
> +                       if (error != CI_STATUS_SUCCESS) {
> +                               DBG_OUT((DERR, "ERR: ci_do_snapshot: failed"
> +                                       "to re-init ISP input aquisition\n"));
> +                       }
> +               }
> +               error = ci_datapath_isp(sys_conf, &DpMain,
> +                       NULL, zoom);
> +
> +       } else {
> +               DBG_DD(("view finder in selfpath\n"));
> +               error =
> +                   ci_datapath_isp(sys_conf, &DpMain,
> +                       &DpSelf, zoom);
> +       }
> +
> +       if (error != CI_STATUS_SUCCESS) {
> +               DBG_DD((" ERR: failed to setup marvins datapaths\n"));
> +               return error;
> +       }
> +
> +       intel_update_marvinvfaddr(intel);
> +       return error;
> +}
> +
> +static int intel_init_mrv_image_effects(
> +       const struct ci_pl_system_config *sys_conf,
> +       int enable)
> +{
> +       int res;
> +       if ((enable) &&
> +           (sys_conf->isp_cfg->img_eff_cfg.mode != CI_ISP_IE_MODE_OFF)) {
> +               res = ci_isp_ie_set_config(&(sys_conf->isp_cfg->img_eff_cfg));
> +               if (res != CI_STATUS_SUCCESS) {
> +                       DBG_OUT((DWARN, "WARN: failed to configure image "
> +                           "effects, code(%d)", res));
> +               }
> +       } else {
> +               (void)ci_isp_ie_set_config(NULL);
> +               res = CI_STATUS_SUCCESS;
> +       }
> +       return res;
> +}
> +
> +static int intel_init_mrvisp_lensshade(
> +       const struct ci_pl_system_config *sys_conf,
> +       int enable)
> +{
> +       if ((enable) && (sys_conf->isp_cfg->flags.lsc)) {
> +               ci_isp_set_ls_correction(&(sys_conf->isp_cfg->lsc_cfg));
> +               ci_isp_ls_correction_on_off(true);
> +       } else
> +               (void)ci_isp_ls_correction_on_off(false);
> +
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +static int intel_init_mrvisp_badpixel(
> +       const struct ci_pl_system_config *sys_conf,
> +       int enable)
> +{
> +       if ((enable) && (sys_conf->isp_cfg->flags.bpc)) {
> +               (void)ci_bp_init(&sys_conf->isp_cfg->bpc_cfg,
> +                   &sys_conf->isp_cfg->bpd_cfg);
> +       } else {
> +               (void)ci_bp_end(&sys_conf->isp_cfg->bpc_cfg);
> +               (void)ci_isp_set_bp_correction(NULL);
> +               (void)ci_isp_set_bp_detection(NULL);
> +       }
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +static int intel_init_mrv_ispfilter(const struct ci_pl_system_config *sys_conf,
> +       int enable)
> +{
> +       int res;
> +       if ((enable) && (sys_conf->isp_cfg->flags.isp_filters)) {
> +               (void)ci_isp_activate_filter(true);
> +               res =
> +                   ci_isp_set_filter_params(sys_conf->isp_cfg->
> +                       filter_level_noise_reduc,
> +                       sys_conf->isp_cfg->
> +                       filter_level_sharp);
> +               if (res != CI_STATUS_SUCCESS) {
> +                       DBG_OUT((DWARN, "WARN: failed to configure isp "
> +                           "filter, code(%d)", res));
> +               }
> +       } else {
> +               (void)ci_isp_activate_filter(false);
> +               res = CI_STATUS_SUCCESS;
> +       }
> +       return res;
> +}
> +
> +static int intel_initbls(const struct ci_pl_system_config *sys_conf)
> +{
> +       struct ci_isp_bls_config *bls_config =
> +           (struct ci_isp_bls_config *)&sys_conf->isp_cfg->bls_cfg;
> +       return ci_isp_bls_set_config(bls_config);
> +}
> +
> +
> +static void intel_dpinitisi(struct ci_sensor_config *isi_config,
> +    struct ci_sensor_caps *isi_caps)
> +{
> +       int      error       = CI_STATUS_SUCCESS;
> +       DBG_DD(("intel_dpinitisi\n"));
> +       ci_sensor_get_caps(isi_caps);
> +       ci_sensor_get_config(isi_config);
> +
> +       if (error != CI_STATUS_SUCCESS) {
> +               DBG_DD(("IsiGetSelectedSensorDefaultConfig() failed.\n"));
> +               /* unable to get the default configuration */
> +               ASSERT(false);
> +       }
> +}
> +
> +static void intel_enable_interrupt(void)
> +{
> +       struct isp_register *mrv_reg =
> +           (struct isp_register *) MEM_MRV_REG_BASE;
> +       u32 bit_mask = 0x00000001;
> +       REG_SET_SLICE(mrv_reg->isp_imsc, MRV_ISP_IMSC_ALL, ON);
> +       REG_WRITE(mrv_reg->mi_imsc, bit_mask);
> +       REG_SET_SLICE(mrv_reg->jpe_error_imr, MRV_JPE_ALL_ERR, ON);
> +       REG_SET_SLICE(mrv_reg->jpe_status_imr, MRV_JPE_ALL_STAT, ON);
> +       ci_isp_reset_interrupt_status();
> +}
> +
> +static int intel_dpinitmrv(const struct ci_pl_system_config *sys_conf)
> +{
> +       int error;
> +       u8 words_per_pixel;
> +       struct ci_isp_config *ptcfg;
> +       ptcfg = sys_conf->isp_cfg;
> +       DBG_DD(("entering intel_dpinitmrv\n"));
> +
> +       ci_isp_init();
> +       intel_enable_interrupt();
> +
> +       /* setup input acquisition according to image sensor settings */
> +       error = ci_isp_set_input_aquisition(sys_conf->isi_config);
> +       if (error) {
> +               DBG_DD(("ERR: () failed to configure input aquisition,"
> +                       "code(%d)\n", error));
> +               return error;
> +       }
> +
> +       /* setup functional blocks for Bayer pattern processing */
> +       if (ci_isp_select_path(sys_conf->isi_config, &words_per_pixel) ==
> +           CI_ISP_PATH_BAYER) {
> +               if (sys_conf->isp_cfg->flags.bls_dis) {
> +                       ci_isp_bls_set_config(NULL);
> +               } else {
> +                       error = intel_initbls(sys_conf);
> +                       if (error != CI_STATUS_SUCCESS)
> +                               return error;
> +               }
> +               DBG_DD(("finished ci_isp_bls_set_config\n"));
> +
> +               if (sys_conf->isp_cfg->flags.gamma2)
> +                       ci_isp_set_gamma2(&g45_th20_b5);
> +               else
> +                       ci_isp_set_gamma2(NULL);
> +
> +               DBG_DD(("finished ci_isp_set_gamma2\n"));
> +
> +               ci_isp_set_demosaic(sys_conf->isp_cfg->demosaic_mode,
> +                   sys_conf->isp_cfg->demosaic_th);
> +               DBG_DD(("finished ci_isp_set_demosaic\n"));
> +
> +               if (sys_conf->isp_cfg->flags.cconv) {
> +                       if (sys_conf->isp_cfg->flags.cconv_basic) {
> +                               if (error != CI_STATUS_SUCCESS)
> +                                       return error;
> +                       } else {
> +                               intel_mrvisp_set_colorconversion_ex();
> +
> +                               if (error != CI_STATUS_SUCCESS)
> +                                       return error;
> +                       }
> +               }
> +
> +               if (sys_conf->isp_cfg->flags.af_dis)
> +                       (void)ci_isp_set_auto_focus(NULL);
> +               else
> +                       (void)ci_isp_set_auto_focus(&sys_conf->isp_cfg->af_cfg);
> +               intel_init_mrv_ispfilter(sys_conf, true);
> +       }
> +
> +       ci_isp_col_set_color_processing(NULL);
> +       intel_init_mrv_image_effects(sys_conf, true);
> +       (void)intel_init_mrvisp_lensshade(sys_conf, true);
> +       (void)intel_init_mrvisp_badpixel(sys_conf, true);
> +       return CI_STATUS_SUCCESS;
> +}

The same comment about your own internal KABI layer applies to the above.

> +
> +/* ------------------------- V4L2 interface --------------------- */
> +static int intel_open(struct file *file)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct intel_isp_device *intel = video_get_drvdata(dev);
> +       DBG_DD(("intel_open\n"));
> +
> +       if (!intel) {
> +               DBG_DD(("Internal error, camera_data not found!\n"));
> +               return -ENODEV;
> +       }
> +
> +       if (intel->open)  {
> +               ++intel->open;
> +               DBG_DD(("device has opened already - %d\n", intel->open));
> +               return 0;
> +       }
> +
> +       file->private_data = dev;
> +       /* increment our usage count for the driver */
> +       ++intel->open;
> +       DBG_DD(("intel_open is %d\n", intel->open));
> +
> +       memset(&intel->sys_conf, 0, sizeof(struct ci_pl_system_config));
> +       memset(&isi_config, 0, sizeof(isi_config));
> +       memset(&isi_caps, 0, sizeof(isi_caps));
> +       memset(&s_config, 0, sizeof(s_config));
> +
> +       intel->sys_conf.isi_config = &isi_config;
> +       intel->sys_conf.isi_caps = &isi_caps;
> +       intel->sys_conf.isp_cfg = &s_config;
> +       s_config.jpeg_enc_ratio = 1;
> +
> +       intel->frame_size_used = 0;
> +
> +       /* default buf size and type*/
> +       intel->bufwidth = 0;
> +       intel->bufheight = 0;
> +       intel->depth = 0;
> +       intel->pixelformat = 0;
> +       return 0;
> +}

Open is not the proper place to clean the configuration, since a V4L2 device
should support more than one open. You can use a different userspace app to
control your device, while other application is streaming it.

In general, I personally do it: I like mplayer's V4L2 streaming implementation,
but it is easier to control a device using qv4l2.

Also, you should protect your changes with some memory barrier. I suspect that
you'll get an OOPS, if you start a stream app and then open your device again with another app.

> +
> +static int intel_close(struct file *file)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct intel_isp_device *intel = video_get_drvdata(dev);
> +
> +       DBG_DD(("intel_close,release resources\n"));
> +
> +       --intel->open;
> +       if (intel->open) {
> +               DBG_DD(("not the last close %d\n", intel->open));
> +               return 0;
> +       }
> +
> +       if (!intel->sys_conf.isp_hal_enable)
> +               ci_sensor_stop();
> +
> +       intel->fbuffer = NULL;
> +       intel->capbuf = NULL;
> +       return 0;
> +}

Same applies here. You need memory barriers (atomic count for open and/or memory lock).

> +
> +static ssize_t intel_read(struct file *file, char __user *buf,
> +    size_t count, loff_t *ppos)
> +{
> +       return 0;
> +
> +}
> +
> +static void intel_vma_open(struct vm_area_struct *vma)
> +{
> +       struct video_device *dev = vma->vm_private_data;
> +       struct intel_isp_device *intel = video_get_drvdata(dev);
> +       DBG_DD(("intel_vma_open %d\n", intel->vmas));
> +       intel->vmas++;
> +}
> +
> +static void intel_vma_close(struct vm_area_struct *vma)
> +{
> +       struct video_device *dev = vma->vm_private_data;
> +       struct intel_isp_device *intel = video_get_drvdata(dev);
> +       int i = 0;
> +
> +       DBG_DD(("intel_vma_close %d\n", intel->vmas));
> +       intel->vmas--;
> +
> +       /* docs say we should stop I/O too... */
> +       if (intel->vmas == 0) {
> +               DBG_DD(("clear the  ~V4L2_BUF_FLAG_MAPPED flag\n"));
> +               DBG_DD(("i %d, num_frame is %d\n", i, intel->num_frames));
> +               for (i = 0; i < intel->num_frames; i++) {
> +                       intel->frame_queue.info[i].flags &=
> +                       ~V4L2_BUF_FLAG_MAPPED;
> +                       DBG_DD(("%d frame queue flags %d\n", i,
> +                               intel->frame_queue.info[i].flags));
> +               }
> +       }
> +}
> +
> +static struct vm_operations_struct intel_vm_ops = {
> +       .open =     intel_vma_open,
> +       .close =    intel_vma_close
> +};
> +
> +static int km_mmap(struct video_device *dev, struct vm_area_struct *vma)
> +{
> +       const char *adr = (const char *)vma->vm_start;
> +       unsigned long size = vma->vm_end-vma->vm_start;
> +       unsigned long start = (unsigned long)adr;
> +       unsigned long pos, page = 0;
> +       unsigned long vsize;
> +       struct intel_isp_device *intel = video_get_drvdata(dev);
> +       u32 i;
> +
> +       /* check the size */
> +       vsize = (intel->num_frames) * PAGE_ALIGN(intel->frame_size);
> +
> +       if (!(vma->vm_flags & (VM_WRITE | VM_READ)))
> +               return -EACCES;
> +
> +       if (!(vma->vm_flags & VM_SHARED))
> +               return -EINVAL;
> +
> +       for (i = 0; i < intel->num_frames; i++) {
> +               if (((PAGE_ALIGN(intel->frame_size)*i) >> PAGE_SHIFT) ==
> +                   vma->vm_pgoff)
> +                       break;
> +       }
> +
> +       if (i == intel->num_frames) {
> +               DBG_DD(("mmap: mapping address is out of range\n"));
> +               return -EINVAL;
> +       }
> +
> +       if (size != PAGE_ALIGN(intel->frame_size)) {
> +               DBG_DD((" failed to check Capture buffer size\n"));
> +               return -EINVAL;
> +       }
> +
> +       /* VM_IO is eventually going to replace PageReserved altogether */
> +       vma->vm_flags |= VM_IO;
> +       vma->vm_flags |= VM_RESERVED;   /* avoid to swap out this VMA */
> +
> +       pos = (unsigned long)(intel->mb1_va+
> +               (intel->cap_frame * PAGE_ALIGN(intel->frame_size)));
> +
> +       page = kvirt_to_pa(pos);
> +       page = page >> PAGE_SHIFT;
> +       if (remap_pfn_range(vma, start, page, size, PAGE_SHARED)) {
> +               DBG_DD(("failed to put MMAP buffer to user space\n"));
> +               return -EAGAIN;
> +       }
> +       return 0;
> +}
> +
> +/* FIXME */
> +/* ------------------------------------------------------------------ */
> +static int intel_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +       struct video_device *dev = file->private_data;
> +       struct intel_isp_device *intel = video_get_drvdata(dev);
> +       int i = 0;
> +       int retval;
> +       retval = km_mmap(dev, vma);
> +       if (retval)
> +               return retval;
> +       vma->vm_ops = &intel_vm_ops;
> +       vma->vm_flags |= VM_DONTEXPAND;
> +       for (i = 0; i < intel->num_frames; i++) {
> +               intel->frame_queue.info[i].flags = V4L2_BUF_FLAG_MAPPED;
> +               DBG_DD(("frame queue flags %d\n",
> +                       intel->frame_queue.info[i].flags));
> +       }
> +       vma->vm_private_data = file->private_data;
> +       intel_vma_open(vma);
> +       return retval;
> +}

> +
> +
> +static int intel_g_fmt_cap(struct file *file, void *priv,
> +                               struct v4l2_format *f)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct intel_isp_device *intel = video_get_drvdata(dev);
> +       int ret;
> +
> +       DBG_DD(("intel_g_fmt_cap\n"));
> +       if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +               f->fmt.pix.width = intel->bufwidth;
> +               f->fmt.pix.height = intel->bufheight;
> +               f->fmt.pix.pixelformat = intel->pixelformat;
> +               f->fmt.pix.bytesperline =
> +                       (f->fmt.pix.width * intel->depth) >> 3;
> +               f->fmt.pix.sizeimage =
> +                   f->fmt.pix.height * f->fmt.pix.bytesperline;
> +               ret = 0;
> +       } else {
> +               ret = -EINVAL;
> +       }
> +       return ret;
> +
> +}

You need memory barriers on those calls, since you aren't protected by any lock.

> +
> +static struct intel_fmt *fmt_by_fourcc(unsigned int fourcc)
> +{
> +       unsigned int i;
> +
> +       for (i = 0; i < NUM_FORMATS; i++)
> +               if (fmts[i].fourcc == fourcc)
> +                       return fmts+i;
> +       return NULL;
> +}
> +
> +static int intel_try_fmt_cap(struct file *file, void *priv,
> +                                               struct v4l2_format *f)
> +{
> +       struct intel_fmt *fmt;
> +       int w, h;
> +       unsigned short sw, sh;
> +       int ret;
> +       struct ci_sensor_config *snr_cfg;
> +
> +       struct video_device *dev = video_devdata(file);
> +       struct intel_isp_device *intel = video_get_drvdata(dev);
> +
> +       snr_cfg = intel->sys_conf.isi_config;
> +       DBG_DD(("intel_try_fmt_cap\n"));
> +
> +       if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +               return -EINVAL;
> +
> +       fmt = fmt_by_fourcc(f->fmt.pix.pixelformat);
> +       if (NULL == fmt) {
> +               DBG_DD(("fmt not found\n"));
> +               return -EINVAL;
> +       }
> +
> +       w = f->fmt.pix.width;
> +       h = f->fmt.pix.height;
> +
> +       DBG_DD(("TRY_FMT: try before buf :w%d, h%d\n", w, h));
> +       if (intel->sys_conf.isp_hal_enable &&
> +               snr_cfg->type == SENSOR_TYPE_RAW) {
> +               ci_sensor_res2size(snr_cfg->res, &sw, &sh);
> +               DBG_DD(("libCI/raw sensor create frame, %dx%d\n", sw, sh));
> +               if (w > sw)
> +                       w = sw;
> +               if (h > sh)
> +                       h = sh;
> +       } else {
> +               DBG_DD(("v4l2 paht or SoC sensor create frame\n"));
> +               if (ci_sensor_try_mode(&w, &h))
> +                       return -EINVAL;
> +       }
> +
> +       /* RBG on self path */
> +       if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_RGB565 ||
> +           f->fmt.pix.pixelformat == V4L2_PIX_FMT_BGR32) {
> +               if (w < INTEL_MIN_WIDTH)
> +                       w = INTEL_MIN_WIDTH;
> +               if (w > INTEL_MAX_WIDTH)
> +                       w = INTEL_MAX_WIDTH;
> +               if (h < INTEL_MIN_HEIGHT)
> +                       h = INTEL_MIN_HEIGHT;
> +               if (h > INTEL_MAX_HEIGHT)
> +                       h = INTEL_MAX_HEIGHT;
> +               f->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
> +       } else {
> +               /* YUV and JPEG formats*/
> +               if (w < INTEL_MIN_WIDTH)
> +                       w = INTEL_MIN_WIDTH;
> +               if (w > INTEL_MAX_WIDTH_MP/*2048*/)
> +                       w = INTEL_MAX_WIDTH_MP;
> +               if (h < INTEL_MIN_HEIGHT)
> +                       h = INTEL_MIN_HEIGHT;
> +               if (h > INTEL_MAX_HEIGHT_MP/*1536*/)
> +                       h = INTEL_MAX_HEIGHT_MP;
> +               f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
> +       }
> +       /* Deal with the raw data bayer pattern */
> +       if (f->fmt.pix.pixelformat == INTEL_PIX_FMT_RAW08 ||
> +          f->fmt.pix.pixelformat == INTEL_PIX_FMT_RAW10 ||
> +          f->fmt.pix.pixelformat == INTEL_PIX_FMT_RAW12)
> +                       ret = 0;
> +       f->fmt.pix.width = w;
> +       f->fmt.pix.height = h;
> +       f->fmt.pix.field = V4L2_FIELD_NONE;
> +       f->fmt.pix.bytesperline = (w * h)/8;
> +       f->fmt.pix.sizeimage = (w * h * fmt->depth)/8;
> +       if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_JPEG)
> +               f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
> +       f->fmt.pix.priv = 0;
> +       ret = 0;

Hmm.. different max limits depending on the video format? Are you sure this is right?

> +
> +       DBG_DD(("TRY_FMT: try after buf :w%d, h%d\n", w, h));
> +       return ret;
> +}
> +
> +
> +static int intel_s_fmt_cap(struct file *file, void *priv,
> +                                       struct v4l2_format *f)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct intel_isp_device *intel = video_get_drvdata(dev);
> +       struct intel_fmt *fmt;
> +       int err;
> +
> +       DBG_DD(("intel_s_fmt_cap\n"));
> +
> +       if (!intel->sys_conf.isp_hal_enable) {
> +               DBG_DD(("v4l2 path intel_s_fmt_cap, sensor_start\n"));
> +               ci_sensor_start();
> +       } else
> +               DBG_DD(("isp hal path in intel_s_fmt_cap\n"));
> +
> +       err = intel_try_fmt_cap(file, priv, f);
> +       if (0 != err) {
> +               DBG_DD(("set format failed\n"));
> +               return err;
> +       }
> +
> +       fmt = fmt_by_fourcc(f->fmt.pix.pixelformat);
> +       /*
> +        * save the format into the driver
> +        */
> +       intel->pixelformat = fmt->fourcc;
> +       intel->depth = fmt->depth;
> +       intel->bufwidth = f->fmt.pix.width;
> +       intel->bufheight = f->fmt.pix.height;
> +       DBG_DD(("set fmt: w %d, h%d, fourcc: %lx\n", intel->bufwidth,
> +               intel->bufheight, fmt->fourcc));
> +       return 0;
> +}
> +
> +static int intel_queryctrl(struct file *file, void *priv,
> +       struct v4l2_queryctrl *c)
> +{
> +       DBG_DD(("intel_queryctrl\n"));
> +
> +       if ((c->id <  V4L2_CID_BASE) || (c->id >=  V4L2_CID_PRIVATE_BASE))
> +               return -EINVAL;
> +
> +       if (ci_sensor_queryctrl(c))
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +static int intel_g_ctrl(struct file *file, void *priv, struct v4l2_control *c)
> +{
> +       DBG_DD(("intel_g_ctrl\n"));
> +       return ci_sensor_get_ctrl(c);
> +}
> +
> +static int intel_s_ctrl(struct file *file, void *fh, struct v4l2_control *c)
> +{
> +       int ret = 0;
> +       struct ci_sensor_config *isi_config;
> +       DBG_DD(("intel_s_ctrl\n"));
> +       ret = ci_sensor_set_ctrl(c);
> +       if ((!ret) && (c->id == V4L2_CID_HFLIP)) {
> +               isi_config = kzalloc(sizeof(struct ci_sensor_config),
> +                                    GFP_KERNEL);
> +               if (isi_config == NULL)
> +                       return -ENOMEM;
> +               ci_sensor_get_config(isi_config);
> +               ci_isp_set_input_aquisition(isi_config);
> +       }
> +       return ret;
> +}

This doesn't seem to be right: Why are you allocating memory on every call to
s_ctrl? How do you intend to free that memory?

> +
> +static int intel_enum_input(struct file *file, void *priv,
> +       struct v4l2_input *input)
> +{
> +       int ret;
> +
> +       if (input->index != 0) {
> +               ret = -EINVAL;

Just do:

	if (input->index)
		return -EINVAL;

The same comment applies to other similar constructions. You only need to use a
var for ret if you're adding some memory barrier.

> +       } else {
> +               strlcpy(input->name, "mrst isp", sizeof(input->name));
> +               input->type = V4L2_INPUT_TYPE_CAMERA;
> +               input->audioset = 0;
> +               input->tuner = 0;
> +               input->std = V4L2_STD_UNKNOWN;
> +               input->status = 0;
> +               memset(input->reserved, 0, sizeof(input->reserved));
> +               ret = 0;
> +       }
> +       return ret;
> +}
> +
> +static int intel_g_input(struct file *file, void *priv, unsigned int *i)
> +{
> +       *i = 0;
> +       return 0;
> +}
> +
> +static int intel_s_input(struct file *file, void *priv, unsigned int i)
> +{
> +       return 0;
> +}
> +
> +static int intel_s_std(struct file *filp, void *priv, v4l2_std_id *a)
> +{
> +       return 0;
> +}
> +
> +static int intel_querycap(struct file *file, void  *priv,
> +       struct v4l2_capability *cap)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       memset(cap, 0, sizeof(struct v4l2_capability));

You don't need to do memset inside any calls. The V4L2 core already cleans what
needs to be cleaned.

> +       strlcpy(cap->driver, DRIVER_NAME, sizeof(cap->driver));
> +       strlcpy(cap->card, dev->name, sizeof(cap->card));
> +       memset(cap->bus_info, 0, sizeof(cap->bus_info));
> +       cap->version = INTEL_VERSION(0, 5, 0);

INTEL_VERSION??? Also, this should be at the top of your file, on some place
that it would be easier to be remembered.

> +       cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +
> +       return 0;
> +}
> +
> +static int intel_cropcap(struct file *file, void *priv,
> +                                       struct v4l2_cropcap *cap)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct intel_isp_device *intel = video_get_drvdata(dev);
> +
> +       if (cap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +               return -EINVAL;
> +
> +       cap->bounds.left = 0;
> +       cap->bounds.top = 0;
> +       cap->bounds.width = intel->bufwidth;
> +       cap->bounds.height = intel->bufheight;
> +       cap->defrect = cap->bounds;
> +       cap->pixelaspect.numerator   = 1;
> +       cap->pixelaspect.denominator = 1;
> +       return 0;
> +}
> +
> +static int intel_enum_fmt_cap(struct file *file, void  *priv,
> +                                       struct v4l2_fmtdesc *f)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct intel_isp_device *intel = video_get_drvdata(dev);
> +
> +       struct ci_sensor_config *snrcfg;
> +
> +       int ret;
> +       unsigned int index;
> +
> +       DBG_DD(("intel_enum_fmt_cap\n"));
> +       snrcfg = intel->sys_conf.isi_config;
> +       index = f->index;
> +
> +       if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +               ret = -EINVAL;
> +       else {
> +               if (snrcfg->type == SENSOR_TYPE_SOC)
> +                       if (index >= 8)
> +                               return -EINVAL;
> +               if (index >= sizeof(fmts) / sizeof(*fmts))
> +                       return -EINVAL;
> +               memset(f, 0, sizeof(*f));
> +               f->index = index;
> +               f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +               strlcpy(f->description, fmts[index].name,
> +                   sizeof(f->description));
> +               f->pixelformat = fmts[index].fourcc;
> +               if (fmts[index].fourcc == V4L2_PIX_FMT_JPEG)
> +                       f->flags = V4L2_FMT_FLAG_COMPRESSED;
> +               ret = 0;
> +       }
> +       return ret;
> +
> +}
> +
> +#define ALIGN4(x)       ((((long)(x)) & 0x3) == 0)
> +
> +static int intel_reqbufs(struct file *file, void *priv,
> +               struct v4l2_requestbuffers *req)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct intel_isp_device *intel = video_get_drvdata(dev);
> +       u32 w;
> +       u32 h;
> +       u32 depth;
> +       u32 fourcc;
> +       unsigned long vsize;
> +
> +       if (req->memory != V4L2_MEMORY_MMAP ||
> +           req->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> +           req->count < 0)  {
> +               return  -EINVAL;
> +       }
> +
> +       if (req->count == 0) {
> +               /* free the buffers */
> +               intel->fbuffer = NULL;
> +               intel->capbuf = NULL;
> +               intel->frame_size_used = 0;
> +               return 0;
> +       }
> +
> +       DBG_DD(("REQBUFS requested:%d max:%d, \n",
> +               req->count, INTEL_CAPTURE_BUFFERS));
> +
> +       if (req->count > INTEL_CAPTURE_BUFFERS)
> +               req->count = INTEL_CAPTURE_BUFFERS;
> +
> +       w = intel->bufwidth;
> +       h = intel->bufheight;
> +       depth = intel->depth;
> +       fourcc = intel->pixelformat;
> +
> +       if (fourcc == V4L2_PIX_FMT_JPEG) {
> +               DBG_DD(("JPEG\n"));
> +               intel->frame_size =
> +                       PAGE_ALIGN(intel->mb1_size/req->count) - PAGE_SIZE;
> +       } else if (fourcc == INTEL_PIX_FMT_RAW08 ||
> +               fourcc == INTEL_PIX_FMT_RAW10 ||
> +               fourcc == INTEL_PIX_FMT_RAW12) {
> +               DBG_DD(("Bayer Pattern\n"));
> +               intel->frame_size = (w * h * depth)/8;
> +       } else {
> +               DBG_DD(("YUV or RGB "));
> +               intel->frame_size = (w * h * depth)/8;
> +       }
> +
> +       DBG_DD(("frame size is %d\n", intel->frame_size));
> +       intel->num_frames = req->count;
> +
> +       /* allocate the memory */
> +       if (intel->fbuffer) {
> +               DBG_DD(("mem allocated, please free it first\n"));
> +               return -EINVAL;
> +       }
> +       vsize = intel->num_frames * PAGE_ALIGN(intel->frame_size);
> +       DBG_DD(("requested frame size is %ld, total is %ld\n", vsize,
> +               intel->mb1_size));
> +
> +       DBG_DD(("PCI space path\n"));
> +       if (vsize > intel->mb1_size)
> +               intel->fbuffer = NULL;
> +       else
> +               intel->fbuffer = intel->mb1_va;
> +
> +       if (intel->fbuffer) {
> +               DBG_DD(("for QA to test mmap: kernel address 0x%p\n",
> +                       intel->fbuffer));
> +       } else {
> +               DBG_DD(("failed to allocate fbuffer\n"));
> +               return -ENOMEM;
> +       }
> +
> +       if (!intel->capbuf) {
> +               if (vsize > intel->mb1_size)
> +                       intel->capbuf = NULL;
> +               else {
> +
> +                       intel->capbuf = intel->mb1_va;
> +                       intel->capbuf_pa = intel->mb1;
> +               }
> +
> +               if (!intel->capbuf || !ALIGN4(intel->capbuf)) {
> +                       DBG_DD(("failed to allocate cap buf\n"));
> +                       return -ENOMEM;
> +               }
> +       }
> +
> +       intel->vmas = 0;
> +       init_frame_queue(&intel->frame_queue);
> +       return 0;
> +
> +
> +}
> +
> +static int intel_querybuf(struct file *file, void *priv,
> +                                       struct v4l2_buffer *buf)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct intel_isp_device *intel = video_get_drvdata(dev);
> +
> +       if (buf->memory != V4L2_MEMORY_MMAP ||
> +           buf->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> +           buf->index >= intel->num_frames || buf->index < 0)
> +               return  -EINVAL;
> +
> +       buf->m.offset = PAGE_ALIGN(intel->frame_size) * buf->index;
> +       buf->length = PAGE_ALIGN(intel->frame_size);
> +       buf->flags = 0;
> +       buf->flags |= intel->frame_queue.info[buf->index].flags;
> +       DBG_DD(("buf flags is %x\n", buf->flags));
> +
> +       if (intel->frame_queue.info[buf->index].state == S_DONE)
> +               buf->flags |= V4L2_BUF_FLAG_DONE;
> +       else if (intel->frame_queue.info[buf->index].state == S_UNUSED)
> +               buf->flags |= V4L2_BUF_FLAG_QUEUED;
> +       buf->field = V4L2_FIELD_NONE;
> +       /* we know which one to map */
> +       intel->cap_frame = buf->index;
> +       return  0;
> +
> +}
> +
> +static int intel_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct intel_isp_device *intel = video_get_drvdata(dev);
> +
> +       DBG_DD(("+++ intel_qbuf, "));
> +
> +       if (buf->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
> +           buf->memory != V4L2_MEMORY_MMAP ||
> +           buf->index >= intel->num_frames || buf->index < 0)
> +               return -EINVAL;
> +
> +       if (intel->frame_queue.info[buf->index].state == S_QUEUED) {
> +               DBG_DD(("%d buf is already queued\n", buf->index));
> +               return -EINVAL;
> +       }
> +
> +       DBG_DD(("bufid %d enqueue\n", buf->index));
> +       buf->flags = 0;
> +       intel->frame_queue.info[buf->index].state = S_QUEUED;
> +       add_frame_to_queue(&intel->frame_queue, buf->index);
> +       buf->flags |= V4L2_BUF_FLAG_QUEUED;
> +       buf->flags &= ~V4L2_BUF_FLAG_DONE;
> +       buf->flags |= intel->frame_queue.info[buf->index].flags;
> +
> +       return 0;
> +
> +}
> +
> +static int intel_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct intel_isp_device *intel = video_get_drvdata(dev);
> +       char *bufbase;
> +       u16 vsize = 0;
> +       u16 hsize = 0;
> +       int ret;
> +       struct ci_sensor_config *isi_sensorcfg;
> +
> +       if (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +               return -EINVAL;
> +       if (b->memory != V4L2_MEMORY_MMAP)
> +               return -EINVAL;
> +
> +       isi_sensorcfg = intel->sys_conf.isi_config;
> +       (void)ci_sensor_res2size(isi_sensorcfg->res, &hsize, &vsize);
> +       intel->cap_frame = remove_frame_from_queue(&intel->frame_queue);
> +       b->index = intel->cap_frame;
> +
> +       if (intel->cap_frame < 0) {
> +               if (file->f_flags & O_NONBLOCK) {;
> +                       return -EAGAIN;
> +               }
> +               intel->cap_frame = 0;
> +       }
> +
> +       if (intel->frame_queue.info[b->index].state != S_QUEUED) {
> +               DBG_DD(("%d buf sate is not queued\n", b->index));
> +               return -EINVAL;
> +       }
> +
> +       DBG_DD(("bufid %d dequeue\n", intel->cap_frame));
> +       bufbase = (char *)(intel->fbuffer+
> +               intel->cap_frame * PAGE_ALIGN(intel->frame_size));
> +
> +       intel_update_marvinvfaddr(intel);
> +       ci_isp_reset_interrupt_status();
> +       ci_isp_mif_reset_offsets(CI_ISP_CFG_UPDATE_IMMEDIATE);
> +
> +       if (intel->pixelformat == V4L2_PIX_FMT_JPEG) {
> +               DBG_DD(("jpeg path\n"));
> +               ret = ci_isp_jpe_init_ex(intel->bufwidth, intel->bufheight,
> +                       s_config.jpeg_enc_ratio, true);
> +               if (ret != CI_STATUS_SUCCESS)
> +                       return -EAGAIN;
> +               if (ci_jpe_capture(CI_ISP_CFG_UPDATE_FRAME_SYNC) == 0)
> +                       return -EINVAL;
> +               intel->frame_size_used = ci_isp_mif_get_byte_cnt();
> +       } else if (intel->pixelformat == INTEL_PIX_FMT_RAW08 ||
> +               intel->pixelformat == INTEL_PIX_FMT_RAW10 ||
> +               intel->pixelformat == INTEL_PIX_FMT_RAW12) {
> +               DBG_DD(("raw path in dqbuf\n"));
> +               ci_isp_start(1, CI_ISP_CFG_UPDATE_FRAME_SYNC);
> +               ret = ci_isp_wait_for_frame_end();
> +               if (ret != CI_STATUS_SUCCESS)
> +                       return -EINVAL;
> +               intel->frame_size_used = ci_isp_mif_get_byte_cnt();
> +
> +       } else {
> +               /* reset interrupts and start Marvin for only one frame */
> +               DBG_DD(("yuv/rgb path in dqbuf\n"));
> +               ci_isp_start(1, CI_ISP_CFG_UPDATE_FRAME_SYNC);
> +               DBG_DD(("finished ci_isp_start\n"));
> +               (void)ci_isp_wait_for_frame_end();
> +               intel->frame_size_used = ci_isp_mif_get_byte_cnt();
> +       }
> +
> +       DBG_DD(("buffer in dqbuf, dst 0x%p, src 0x%p, size%dk\n",
> +       bufbase, intel->capbuf, intel->frame_size_used/1024));
> +
> +       do_gettimeofday(&b->timestamp);
> +
> +       intel->frame_queue.info[b->index].state = S_DONE;
> +       b->flags = V4L2_BUF_FLAG_MAPPED;
> +       b->flags &= ~V4L2_BUF_FLAG_DONE;
> +
> +       if (intel->frame_size_used)
> +               b->bytesused = intel->frame_size_used;
> +       else
> +               b->bytesused = intel->frame_size;
> +       b->memory = V4L2_MEMORY_MMAP;
> +       b->m.offset = intel->cap_frame * PAGE_ALIGN(intel->frame_size);
> +       b->length = PAGE_ALIGN(intel->frame_size);
> +       b->index = intel->cap_frame;
> +       b->sequence = intel->field_count;
> +
> +       return 0;
> +
> +}
> +
> +static int intel_streamon(struct file *file, void *priv,
> +                                       enum v4l2_buf_type type)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct intel_isp_device *intel = video_get_drvdata(dev);
> +
> +       if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE || !intel->fbuffer)
> +               return -EINVAL;
> +
> +       intel->cap_frame = 0;
> +       intel->state = S_STREAMING;
> +       if (!intel->sys_conf.isp_hal_enable) {
> +               DBG_DD(("v4l2 path enabled\n"));
> +               ci_sensor_set_mode(intel->bufwidth, intel->bufheight);
> +               intel_dpinitisi(&isi_config, &isi_caps);
> +               intel_defcfg_all_load(&s_config, &isi_config);
> +       } else
> +               DBG_DD(("isp hal path enabled\n"));
> +
> +       intel_dpinitmrv(&intel->sys_conf);
> +       intel_setup_viewfinder_path(intel, -1);
> +       return 0;
> +
> +}
> +
> +static int intel_streamoff(struct file *file, void *priv,
> +                                       enum v4l2_buf_type type)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct intel_isp_device *intel = video_get_drvdata(dev);
> +       if (!intel->sys_conf.isp_hal_enable &&
> +               (type != V4L2_BUF_TYPE_VIDEO_CAPTURE || !intel->fbuffer))
> +               return -EINVAL;
> +       intel->state = S_IDLE;
> +       ci_isp_stop(CI_ISP_CFG_UPDATE_FRAME_SYNC);
> +       init_frame_queue(&intel->frame_queue);
> +       return 0;
> +}

Use videobuf instead.

> +
> +static u32
> +copy_sensor_config_from_user(struct ci_sensor_config *des,
> +               struct ci_sensor_config *src)
> +{
> +       u32 ret = 0;
> +       ret = copy_from_user((void *)des, (const void *)src,
> +               sizeof(struct ci_sensor_config));
> +       if (ret)
> +               return -EFAULT;
> +       return ret;
> +}
> +
> +static u32
> +copy_sensor_caps_from_user(struct ci_sensor_caps *des,
> +               struct ci_sensor_caps *src)
> +{
> +       u32 ret = 0;
> +       ret = copy_from_user((void *)des, (const void *)src,
> +               sizeof(struct ci_sensor_caps));
> +       if (ret)
> +               return -EFAULT;
> +       return ret;
> +}
> +
> +static u32
> +copy_isp_config_from_user(struct ci_isp_config *des,
> +               struct ci_isp_config *src)
> +{
> +       u32 ret = 0;
> +       ret = copy_from_user((void *)des, (const void *)src,
> +               sizeof(struct ci_isp_config));
> +       if (ret)
> +               return -EFAULT;
> +       return ret;
> +}
> +
> +static int intel_set_cfg(struct file *file, void *priv,
> +                                       struct ci_pl_system_config *arg)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct intel_isp_device *intel = video_get_drvdata(dev);
> +
> +       if (arg == NULL) {
> +               printk(KERN_WARNING "NULL pointer in intel_set_cfg\n");
> +               return 0;
> +       }
> +
> +       DBG_DD(("intel_set_cfg ioctl,%d\n", arg->isp_hal_enable));
> +
> +       intel->sys_conf.isp_hal_enable = arg->isp_hal_enable;
> +
> +       if (intel->sys_conf.isp_hal_enable)
> +               DBG_DD(("isp hal path\n"));
> +
> +       if (arg->isi_config != NULL) {
> +               copy_sensor_config_from_user(intel->sys_conf.isi_config,
> +                       arg->isi_config);
> +       } else {
> +               printk(KERN_WARNING "NULL sensor config pointer\n");
> +               return CI_STATUS_NULL_POINTER;
> +       }
> +
> +       if (arg->isi_caps != NULL) {
> +               DBG_DD(("  sync isi caps\n"));
> +               copy_sensor_caps_from_user(intel->sys_conf.isi_caps,
> +                       arg->isi_caps);
> +       } else {
> +               printk(KERN_WARNING "NULL sensor caps pointer\n");
> +               return CI_STATUS_NULL_POINTER;
> +       }
> +
> +       if (arg->isp_cfg != NULL) {
> +               DBG_DD(("sync isp cfg\n"));
> +               copy_isp_config_from_user(intel->sys_conf.isp_cfg,
> +                       arg->isp_cfg);
> +       } else {
> +               printk(KERN_WARNING "NULL isp config pointer\n");
> +               return CI_STATUS_NULL_POINTER;
> +       }
> +
> +       return 0;
> +}
> +
> +/* for buffer sharing between CI and VA */
> +static int intel_get_frame_info(struct file *file, void *priv,
> +       struct ci_frame_info *arg)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct intel_isp_device *intel = video_get_drvdata(dev);
> +
> +       arg->width = intel->bufwidth;
> +       arg->height = intel->bufheight;
> +       arg->fourcc = intel->pixelformat;
> +       arg->stride = intel->bufwidth; /* should be 64 bit alignment*/
> +       arg->offset = arg->frame_id * PAGE_ALIGN(intel->frame_size);
> +       DBG_DD(("w=%d, h=%d, 4cc =%x, stride=%d, offset=%d,fsize=%d\n",
> +               arg->width, arg->height, arg->fourcc, arg->stride,
> +               arg->offset, intel->frame_size));
> +       return 0;
> +
> +}
> +
> +static int intel_set_jpg_enc_ratio(struct file *file, void *priv,
> +       int *arg)
> +{
> +       DBG_DD(("set jpg compression ratio is %d\n", *arg));
> +       s_config.jpeg_enc_ratio = *arg;
> +       return 0;
> +}
> +
> +/* intel private ioctl for libci  */
> +static int intel_v4l2p_ioctl(struct file *file,
> +       unsigned int cmd, void __user  *arg)
> +{
> +       void *priv = file->private_data;
> +
> +       switch (cmd) {
> +
> +       case VIDIOC_SET_SYS_CFG:
> +               return intel_set_cfg(file, priv,
> +                       (struct ci_pl_system_config *)arg);
> +
> +       case VIDIOC_SET_JPG_ENC_RATIO:
> +               return intel_set_jpg_enc_ratio(file, priv, (int *)arg);
> +
> +       case ISP_IOCTL_GET_FRAME_INFO:
> +               return intel_get_frame_info(file, priv,
> +                       (struct ci_frame_info *)arg);
> +
> +       default:
> +               return -EINVAL;
> +       }
> +}

Don't add private ioctls without previously discussing about them first.

> +
> +static long intel_ioctl_v4l2(struct file *file,
> +                              unsigned int cmd, void __user  *arg)
> +{
> +       void *priv = file->private_data;
> +
> +       switch (cmd) {
> +
> +       case VIDIOC_QUERYCAP:
> +               return intel_querycap(file, priv, arg);
> +
> +       case VIDIOC_ENUMINPUT:
> +               return intel_enum_input(file, priv, arg);
> +
> +       case VIDIOC_G_INPUT:
> +               return intel_g_input(file, priv, arg);
> +
> +       case VIDIOC_S_INPUT:
> +               return 0;
> +
> +       case VIDIOC_QUERYCTRL:
> +               return intel_queryctrl(file, priv, arg);
> +
> +       case VIDIOC_G_CTRL:
> +               return intel_g_ctrl(file, priv, arg);
> +
> +       case VIDIOC_S_CTRL:
> +               return intel_s_ctrl(file, priv, arg);
> +
> +       case VIDIOC_CROPCAP:
> +               return intel_cropcap(file, priv, arg);
> +
> +       case VIDIOC_G_CROP:
> +               return -EINVAL;
> +
> +       case VIDIOC_S_CROP:
> +               return -EINVAL;
> +
> +       case VIDIOC_ENUM_FMT:
> +               return intel_enum_fmt_cap(file, priv, arg);
> +
> +       case VIDIOC_G_FMT:
> +               return intel_g_fmt_cap(file, priv, arg);
> +
> +       case VIDIOC_TRY_FMT:
> +               return intel_try_fmt_cap(file, priv, arg);
> +
> +       case VIDIOC_S_FMT:
> +               return intel_s_fmt_cap(file, priv, arg);
> +
> +       case VIDIOC_REQBUFS:
> +               return intel_reqbufs(file, priv, arg);
> +
> +       case VIDIOC_QUERYBUF:
> +               return intel_querybuf(file, priv, arg);
> +
> +       case VIDIOC_QBUF:
> +               return intel_qbuf(file, priv, arg);
> +
> +       case VIDIOC_DQBUF:
> +               return intel_dqbuf(file, priv, arg);
> +
> +       case VIDIOC_STREAMON:
> +               return intel_streamon(file, priv, *(int *)arg);
> +
> +       case VIDIOC_STREAMOFF:
> +               return intel_streamoff(file, priv, *(int *)arg);
> +
> +       case VIDIOC_S_STD:
> +               return intel_s_std(file, priv, arg);
> +
> +       case VIDIOC_G_STD:
> +       case VIDIOC_QUERYSTD:
> +       case VIDIOC_ENUMSTD:
> +       case VIDIOC_QUERYMENU:
> +       case VIDIOC_ENUM_FRAMEINTERVALS:
> +               return -EINVAL;
> +
> +       default:
> +               return intel_v4l2p_ioctl(file, cmd, arg);
> +       }
> +}
> +
> +static long intel_ioctl(struct file *file,
> +                        unsigned int cmd, unsigned long arg)
> +{
> +
> +       return video_usercopy(file, cmd, arg, intel_ioctl_v4l2);
> +}
> +

Don't re-invent the wheel. Just use video_ioctl2.

> +
> +static const struct v4l2_file_operations intel_fops = {
> +       .owner = THIS_MODULE,
> +       .open = intel_open,
> +       .release = intel_close,
> +       .read = intel_read,
> +       .mmap = intel_mmap,
> +       .ioctl = intel_ioctl,
> +};
> +
> +static const struct v4l2_ioctl_ops intel_ioctl_ops = {
> +       .vidioc_querycap                = intel_querycap,
> +       .vidioc_enum_fmt_vid_cap        = intel_enum_fmt_cap,
> +       .vidioc_g_fmt_vid_cap           = intel_g_fmt_cap,
> +       .vidioc_try_fmt_vid_cap         = intel_try_fmt_cap,
> +       .vidioc_s_fmt_vid_cap           = intel_s_fmt_cap,
> +       .vidioc_cropcap                 = intel_cropcap,
> +       .vidioc_reqbufs                 = intel_reqbufs,
> +       .vidioc_querybuf                = intel_querybuf,
> +       .vidioc_qbuf                    = intel_qbuf,
> +       .vidioc_dqbuf                   = intel_dqbuf,
> +       .vidioc_enum_input              = intel_enum_input,
> +       .vidioc_g_input                 = intel_g_input,
> +       .vidioc_s_input                 = intel_s_input,
> +       .vidioc_s_std                   = intel_s_std,
> +       .vidioc_queryctrl               = intel_queryctrl,
> +       .vidioc_streamon                = intel_streamon,
> +       .vidioc_streamoff               = intel_streamoff,
> +       .vidioc_g_ctrl                  = intel_g_ctrl,
> +       .vidioc_s_ctrl                  = intel_s_ctrl,
> +};
> +
> +static struct video_device intel_template = {
> +       .name                           = "Moorestown Camera Imaging",
> +       .minor                          = -1,
> +       .fops                           = &intel_fops,
> +       .ioctl_ops                      = &intel_ioctl_ops,

No. Use video_ioctl2 instead of creating your own.

> +       .release                        = video_device_release,
> +};
> +
> +static void __devexit intel_pci_remove(struct pci_dev *pci_dev)
> +{
> +       struct intel_isp_device *intel = NULL;
> +
> +       if (pci_driver_loaded)
> +               intel = &intel_isp_v4l_device;
> +
> +       pci_driver_loaded = 0;
> +
> +       if (intel->fbuffer)
> +               vfree(intel->fbuffer);
> +       intel->fbuffer = NULL;
> +
> +       if (intel->capbuf) {
> +               if (intel->frame_size <= MAX_KMALLOC_MEM)
> +                       kfree(intel->capbuf);
> +               else
> +                       iounmap(intel->capbuf);
> +       }
> +
> +       intel->capbuf = NULL;
> +
> +       if (intel->regs)
> +               iounmap(intel->regs);
> +
> +       intel->regs = NULL;
> +
> +       if (intel->mb1_va)
> +               iounmap(intel->mb1_va);
> +
> +       intel->mb1_va = NULL;
> +
> +       video_unregister_device(intel->vdev);
> +       DBG_DD((" Remove v4l device. interrupt_count=%ld\n",
> +           intel->interrupt_count));
> +       pci_release_regions(pci_dev);
> +       if (!pci_driver_loaded)
> +               pci_set_drvdata(pci_dev, NULL);
> +
> +}
> +
> +static int __devinit intel_pci_probe(struct pci_dev *dev,
> +    const struct pci_device_id *pci_id)
> +{
> +       struct intel_isp_device *intel;
> +       int ret = 0;
> +       unsigned int start = 0;
> +       unsigned int len = 0;
> +       intel = &intel_isp_v4l_device;
> +       g_intel = &intel_isp_v4l_device;
> +       intel->pci_dev = dev;
> +       intel->interrupt_count = 0;
> +
> +       if (pci_enable_device(dev) < 0) {
> +               printk(KERN_INFO " can't enable device.\n");
> +               return -EIO;
> +       }
> +
> +       ret = pci_request_regions(dev, "intel_isp");
> +       if (ret) {
> +               DBG_DD(("failed to request I/O memory\n"));
> +               return -EIO;
> +       }
> +
> +       /* Determine the address of the I2C area */
> +       start = intel->mb0 = pci_resource_start(dev, 0);
> +       len = intel->mb0_size = pci_resource_len(dev, 0);
> +
> +       intel->regs = ioremap_nocache(start, len);
> +       if (intel->regs == NULL) {
> +               DBG_DD(("failed to ioremap\n"));
> +               return -ENXIO;
> +       }
> +       DBG_DD((" mmio address: 0x%p, lenght=0x%lx\n",
> +           intel->regs, intel->mb0_size));
> +
> +       /* mem base 1*/
> +       start = intel->mb1 = pci_resource_start(dev, 1);
> +       len = intel->mb1_size = pci_resource_len(dev, 1);
> +       intel->mb1_va = ioremap_nocache(start, len);
> +       if (intel->mb1_va == NULL) {
> +               DBG_DD(("failed to ioremap\n"));
> +               return -ENXIO;
> +       }
> +
> +       DBG_DD((" mmio address: 0x%p, lenght=0x%lx\n",
> +           intel->mb1_va, intel->mb1_size));
> +
> +       pci_read_config_word(dev, PCI_VENDOR_ID, &intel->vendorID);
> +       pci_read_config_word(dev, PCI_DEVICE_ID, &intel->deviceID);
> +
> +
> +       if (!pci_driver_loaded) {
> +               pci_driver_loaded = 1;
> +               pci_set_master(dev);
> +               pci_set_drvdata(dev, intel);
> +       }
> +
> +       g_intel->vdev = kmalloc(sizeof(struct video_device), GFP_KERNEL);
> +       memcpy(intel->vdev, &intel_template, sizeof(intel_template));
> +
> +       intel->vdev->parent = &dev->dev;
> +
> +       printk(KERN_INFO "reset ISP hardware ...\n");
> +       ci_isp_init();
> +       printk(KERN_INFO "reset ISP hardware - done\n");
> +       /* register v4l device */
> +       video_set_drvdata(g_intel->vdev, g_intel);
> +       if (video_register_device(intel->vdev, VFL_TYPE_GRABBER, video_nr)
> +           == -1) {
> +               printk(KERN_INFO "video_register_device failed\n");
> +               return -1;
> +       }
> +
> +       return 0;
> +
> +}
> +
> +static struct pci_device_id intel_isp_pci_tbl[] __devinitdata = {
> +       { PCI_DEVICE(0x8086, 0x080B) },
> +       {0,}
> +};
> +
> +MODULE_DEVICE_TABLE(pci, intel_isp_pci_tbl);
> +
> +static struct pci_driver intel_isp_pci_driver = {
> +       .name = "mrstisp",
> +       .id_table = intel_isp_pci_tbl,
> +       .probe = intel_pci_probe,
> +       .remove = intel_pci_remove,
> +};
> +
> +static int __init intel_pci_init(void)
> +{
> +       int ret = 0;
> +       ret = pci_register_driver(&intel_isp_pci_driver);
> +       if (ret) {
> +               printk(KERN_ERR "Unable to register intel_isp_pci driver\n");
> +               return ret;
> +       }
> +       return ret;
> +}
> +
> +static void __exit intel_pci_exit(void)
> +{
> +       struct intel_isp_device *intel = NULL;
> +       intel = &intel_isp_v4l_device;
> +
> +       DBG_DD((" v4l module cleanup.\n"));
> +       pci_unregister_driver(&intel_isp_pci_driver);
> +}
> +
> +module_init(intel_pci_init);
> +module_exit(intel_pci_exit);
> +
> +MODULE_DESCRIPTION("mrstisp.ko - CI/V4L2 driver for Moorestown");
> +MODULE_AUTHOR("Xiaolin Zhang <xiaolin.zhang@intel.com>");
> +MODULE_LICENSE("GPL");
> +MODULE_SUPPORTED_DEVICE("video");
> +
> +module_param(km_debug, int, 0);
> +MODULE_PARM_DESC(km_debug, "debug level (default: 0)");

I'll stop my review here. It makes no sense to keep looking on all the code
bellow, while you don't address the current issues.

Basically, your next steps:

1) discuss the needed V4L2 additions and propose a patch adding them into
videodev2.h and V4L2 API. The patch should be against:
	http://linuxtv.org/hg/v4l-dvb
since the V4L2 API files are only there.

2) discuss why you need those private ioctls;

3) after get an ack at the above, you should  get rid of your own abstraction
layer, and resubmit your patches 1/5 part 1 and 1/5 part 2, splitting they into
smaller chunks.

Only after (3), you should submit the other patches.

Also, please check every patch with checkpatch.pl for it to warn you about any
codingstyle and/or usage of old kernel API's.


> diff --git a/drivers/media/video/mrstci/mrstisp/mrv.c b/drivers/media/video/mrstci/mrstisp/mrv.c
> new file mode 100644
> index 0000000..4665a78

<tons of unreviewed code here>

> +int ci_jpe_encode(enum ci_isp_conf_update_time update_time,
> +       enum ci_isp_jpe_enc_mode mrv_jpe_encMode)
> +{
> +       ci_isp_jpe_prep_enc(mrv_jpe_encMode);
> +       /* start Marvin for 1 frame to capture */
> +       ci_isp_start(1, update_time);
> +       return ci_isp_jpe_wait_for_encode_done();
> +}
> +



Cheers,
Mauro
