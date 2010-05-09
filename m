Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3610 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab0EIO6f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 May 2010 10:58:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
Subject: Re: [PATCH v2 2/10] V4L2 patches for Intel Moorestown Camera Imaging Drivers - part 1
Date: Sun, 9 May 2010 17:00:05 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Zhu, Daniel" <daniel.zhu@intel.com>,
	"Yu, Jinlu" <jinlu.yu@intel.com>,
	"Wang, Wen W" <wen.w.wang@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Hu, Gang A" <gang.a.hu@intel.com>,
	"Ba, Zheng" <zheng.ba@intel.com>
References: <33AB447FBD802F4E932063B962385B351D6D536E@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <33AB447FBD802F4E932063B962385B351D6D536E@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005091700.05738.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It's pretty huge, so I am not going to do a full in-depth review. Instead I
will just go through it and make a note of 'odd' things. I'm also not going
to repeat the comments I made before on March 29.

On Sunday 28 March 2010 16:42:30 Zhang, Xiaolin wrote:
> From 1c18c41be33246e4b766d0e95e28a72dded87475 Mon Sep 17 00:00:00 2001
> From: Xiaolin Zhang <xiaolin.zhang@intel.com>
> Date: Sun, 28 Mar 2010 21:31:24 +0800
> Subject: [PATCH 2/10] This patch is second part of intel moorestown isp driver and c files collection which is v4l2 implementation.
> 
> Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
> ---
>  drivers/media/video/mrstci/mrstisp/Kconfig         |   10 +
>  drivers/media/video/mrstci/mrstisp/Makefile        |    7 +
>  .../video/mrstci/mrstisp/__mrstisp_private_ioctl.c |  225 ++
>  drivers/media/video/mrstci/mrstisp/mrstisp_main.c  | 2656 ++++++++++++++++++++
>  4 files changed, 2898 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/mrstci/mrstisp/Kconfig
>  create mode 100644 drivers/media/video/mrstci/mrstisp/Makefile
>  create mode 100644 drivers/media/video/mrstci/mrstisp/__mrstisp_private_ioctl.c
>  create mode 100644 drivers/media/video/mrstci/mrstisp/mrstisp_main.c
> 
> diff --git a/drivers/media/video/mrstci/mrstisp/Kconfig b/drivers/media/video/mrstci/mrstisp/Kconfig
> new file mode 100644
> index 0000000..8e58a87
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/Kconfig
> @@ -0,0 +1,10 @@
> +config VIDEO_MRST_ISP
> +       tristate "Moorstown Marvin - ISP Driver"
> +       depends on VIDEO_V4L2
> +       select VIDEOBUF_DMA_CONTIG
> +       default y
> +       ---help---
> +         Say Y here if you want support for cameras based on the Intel Moorestown platform.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called mrstisp.ko.
> diff --git a/drivers/media/video/mrstci/mrstisp/Makefile b/drivers/media/video/mrstci/mrstisp/Makefile
> new file mode 100644
> index 0000000..30f4e62
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/Makefile
> @@ -0,0 +1,7 @@
> +mrstisp-objs   := mrstisp_main.o mrstisp_hw.o mrstisp_isp.o    \
> +                mrstisp_dp.o mrstisp_mif.o mrstisp_jpe.o       \
> +               __mrstisp_private_ioctl.o
> +
> +obj-$(CONFIG_VIDEO_MRST_ISP)    += mrstisp.o
> +
> +EXTRA_CFLAGS   +=      -I$(src)/../include -I$(src)/include
> diff --git a/drivers/media/video/mrstci/mrstisp/__mrstisp_private_ioctl.c b/drivers/media/video/mrstci/mrstisp/__mrstisp_private_ioctl.c
> new file mode 100644
> index 0000000..0b68cf3
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/__mrstisp_private_ioctl.c
> @@ -0,0 +1,225 @@
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
> +#include "mrstisp_stdinc.h"
> +
> +static void print_bls_cfg(struct ci_isp_config *isp_cfg)
> +{
> +       struct ci_isp_bls_config *bls_cfg = &isp_cfg->bls_cfg;
> +
> +       dprintk(4, "print_bls_cfg:");
> +       dprintk(4, "enable_automatic:%d", (bls_cfg->enable_automatic ? 1 : 0));
> +       dprintk(4, "disable_h:%d", (bls_cfg->disable_h ? 1 : 0));
> +       dprintk(4, "disable_v:%d", (bls_cfg->disable_v ? 1 : 0));
> +       dprintk(4, "enable_window1:%d",
> +               (bls_cfg->isp_bls_window1.enable_window ? 1 : 0));
> +       dprintk(4, "start_h:%d", (int)bls_cfg->isp_bls_window1.start_h);
> +       dprintk(4, "stop_h:%d", (int)bls_cfg->isp_bls_window1.stop_h);
> +       dprintk(4, "start_v:%d", (int)bls_cfg->isp_bls_window1.start_v);
> +       dprintk(4, "stop_v:%d", (int)bls_cfg->isp_bls_window1.stop_v);
> +       dprintk(4, "enable_window2: %d",
> +               (bls_cfg->isp_bls_window2.enable_window ? 1 : 0));
> +       dprintk(4, "start_h%d", (int)bls_cfg->isp_bls_window2.start_h);
> +       dprintk(4, "stop_h%d", (int)bls_cfg->isp_bls_window2.stop_h);
> +       dprintk(4, "start_v%d", (int)bls_cfg->isp_bls_window2.start_v);
> +       dprintk(4, "stop_v%d", (int)bls_cfg->isp_bls_window2.stop_v);
> +       dprintk(4, "bls_samples%d", (int)bls_cfg->bls_samples);
> +       dprintk(4, "fixed_a0x%02x", (int)bls_cfg->bls_subtraction.fixed_a);
> +       dprintk(4, "fixed_b0x%02x", (int)bls_cfg->bls_subtraction.fixed_b);
> +       dprintk(4, "fixed_c0x%02x", (int)bls_cfg->bls_subtraction.fixed_c);
> +       dprintk(4, "fixed_d0x%02x", (int)bls_cfg->bls_subtraction.fixed_d);
> +       dprintk(4, "\n");
> +}
> +
> +static int mrst_isp_set_cfg(struct file *file, void *priv,
> +                           struct ci_pl_system_config *arg)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(dev);
> +
> +       WARN_ON(priv != file->private_data);

Pointless warning. priv is *always* file->private_data.

> +
> +       if (arg == NULL) {
> +               eprintk("NULL pointer of arg");
> +               return 0;
> +       }
> +       mutex_lock(&isp->mutex);
> +       memcpy(&isp->sys_conf.isp_cfg, &arg->isp_cfg,
> +                    sizeof(struct ci_isp_config));
> +
> +       print_bls_cfg(&isp->sys_conf.isp_cfg);
> +       mutex_unlock(&isp->mutex);
> +
> +       isp->sys_conf.isp_hal_enable = 1;
> +       return 0;
> +}
> +
> +/* for buffer sharing between CI and VA */
> +static int mrst_isp_get_frame_info(struct file *file, void *priv,
> +                                  struct ci_frame_info *arg)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(dev);
> +
> +       WARN_ON(priv != file->private_data);
> +
> +       mutex_lock(&isp->mutex);
> +       arg->width = isp->bufwidth;
> +       arg->height = isp->bufheight;
> +       arg->fourcc = isp->pixelformat;
> +       arg->stride = isp->bufwidth; /* should be 64 bit alignment*/
> +       arg->offset = arg->frame_id * PAGE_ALIGN(isp->frame_size);
> +
> +       dprintk(2, "w=%d, h=%d, 4cc =%x, stride=%d, offset=%d,fsize=%d",
> +               arg->width, arg->height, arg->fourcc, arg->stride,
> +               arg->offset, isp->frame_size);
> +       mutex_unlock(&isp->mutex);
> +       return 0;
> +}
> +
> +static int mrst_isp_set_jpg_enc_ratio(struct file *file, void *priv, int *arg)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(dev);
> +
> +       WARN_ON(priv != file->private_data);
> +
> +       dprintk(2, "set jpg compression ratio is %d", *arg);
> +       mutex_lock(&isp->mutex);
> +       isp->sys_conf.isp_cfg.jpeg_enc_ratio = *arg;
> +       mutex_unlock(&isp->mutex);
> +
> +       return 0;
> +}
> +
> +int mrst_isp_get_isp_mem_info(struct file *file, void *priv,
> +                             struct ci_isp_mem_info *arg)
> +{
> +       u32 ret = 0;
> +       struct video_device *dev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(dev);
> +
> +       WARN_ON(priv != file->private_data);
> +
> +       mutex_lock(&isp->mutex);
> +       arg->isp_bar0_pa = isp->mb0;
> +       arg->isp_bar0_size = isp->mb0_size;
> +       arg->isp_bar1_pa = isp->mb1;
> +       arg->isp_bar1_size = isp->mb1_size;
> +       mutex_unlock(&isp->mutex);
> +
> +       return ret;
> +}
> +
> +int mrst_isp_create_jpg_review_frame(struct file *file, void *priv,
> +                                    struct v4l2_jpg_review_buffer *arg)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(dev);
> +
> +       u32 width = arg->width;
> +       u32 height = arg->height;
> +       u32 pix_fmt = arg->pix_fmt;
> +       u32 jpg_frame = arg->jpg_frame;
> +
> +       static struct v4l2_jpg_review_buffer *jpg_review;
> +
> +       jpg_review = &isp->sys_conf.jpg_review;
> +
> +       WARN_ON(priv != file->private_data);
> +
> +       if (width > 640 || height > 480 || width < 32 || height < 16) {
> +               eprintk("unsupported resolution: %d * %d", width, height);
> +               return -EINVAL;
> +       }
> +
> +       if (jpg_frame >= isp->num_frames) {
> +               eprintk("error jpeg frame id");
> +               return -1;
> +       }
> +
> +       jpg_review->width = width;
> +       jpg_review->height = height;
> +       jpg_review->pix_fmt = pix_fmt;
> +       jpg_review->jpg_frame = jpg_frame;
> +
> +       switch (arg->pix_fmt) {
> +       case V4L2_PIX_FMT_YUV422P:
> +               jpg_review->bytesperline = width * 2;
> +               jpg_review->frame_size = width * height * 2;
> +               break;
> +       case V4L2_PIX_FMT_YUV420:
> +       case V4L2_PIX_FMT_YVU420:
> +       case V4L2_PIX_FMT_NV12:
> +               jpg_review->bytesperline = width * 3/2;
> +               jpg_review->frame_size = width * height * 3/2;
> +               break;
> +       default:
> +               eprintk("unsupported pix_fmt: %d", arg->pix_fmt);
> +               return -EINVAL;
> +       }
> +
> +       jpg_review->offset = isp->mb1_size - 640*480*2;
> +       isp->sys_conf.jpg_review_enable = 1;
> +
> +       /* set user space data */
> +       arg->bytesperline = jpg_review->bytesperline;
> +       arg->frame_size = jpg_review->frame_size;
> +       arg->offset = jpg_review->offset;
> +
> +       return 0;
> +}
> +
> +/* isp private ioctl for libci */
> +long mrst_isp_vidioc_default(struct file *file, void *fh,
> +                            int cmd, void *arg)
> +{
> +       void *priv = file->private_data;
> +
> +       switch (cmd) {
> +       case VIDIOC_GET_ISP_MEM_INFO:
> +               return mrst_isp_get_isp_mem_info(file, priv,
> +                                                (struct ci_isp_mem_info *)arg);
> +
> +       case VIDIOC_SET_SYS_CFG:
> +               return mrst_isp_set_cfg(file, priv,
> +                                       (struct ci_pl_system_config *)arg);
> +
> +       case VIDIOC_SET_JPG_ENC_RATIO:
> +               return mrst_isp_set_jpg_enc_ratio(file, priv, (int *)arg);
> +
> +       case ISP_IOCTL_GET_FRAME_INFO:
> +               return mrst_isp_get_frame_info(file, priv,
> +                                              (struct ci_frame_info *)arg);
> +
> +       case VIDIOC_CREATE_JPG_REVIEW_BUF:
> +               return mrst_isp_create_jpg_review_frame(file, priv,
> +                                       (struct v4l2_jpg_review_buffer *)arg);
> +       default:
> +               v4l_print_ioctl("lnw_isp", cmd);
> +               dprintk(2, "VIDIOC_SET_SYS_CFG = %x", VIDIOC_SET_SYS_CFG);
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> diff --git a/drivers/media/video/mrstci/mrstisp/mrstisp_main.c b/drivers/media/video/mrstci/mrstisp/mrstisp_main.c
> new file mode 100644
> index 0000000..14198e2
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/mrstisp_main.c
> @@ -0,0 +1,2656 @@
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
> +#include "mrstisp_stdinc.h"
> +#include "ci_isp_fmts_common.h"
> +
> +#define GPIO_SCLK_25   44
> +#define GPIO_STDBY1_PIN        48
> +#define GPIO_STDBY2_PIN        49
> +#define GPIO_RESET_PIN 50
> +
> +int mrstisp_debug;
> +module_param(mrstisp_debug, int, 0644);
> +
> +static int frame_cnt;
> +static long mipi_error_num;
> +static u32 mipi_error_flag;
> +static long isp_error_num;
> +static u32 isp_error_flag;
> +static unsigned long jiffies_start;
> +static int mipi_flag;
> +
> +void intel_timer_start(void)
> +{
> +       jiffies_start = jiffies;
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
> +}
> +
> +
> +static inline struct mrst_isp_device *to_isp(struct v4l2_device *dev)
> +{
> +       return container_of(dev, struct mrst_isp_device, v4l2_dev);
> +}
> +
> +static struct mrst_camera mrst_camera_table[] = {
> +       {
> +               .type = MRST_CAMERA_SOC,
> +               .name = "ov2650",
> +               .sensor_addr = 0x30,
> +       },
> +       {
> +               .type = MRST_CAMERA_SOC,
> +               .name = "ov9665",
> +               .sensor_addr = 0x30,
> +       },
> +       {
> +               .type = MRST_CAMERA_RAW,
> +               .name = "ov5630",
> +               .sensor_addr = 0x36,
> +               .motor_name = "ov5630_motor",
> +               .motor_addr = (0x18 >> 1),
> +       },
> +       {
> +               .type = MRST_CAMERA_RAW,
> +               .name = "s5k4e1",
> +               .sensor_addr = 0x36,
> +               .motor_name = "s5k4e1_motor",
> +               .motor_addr = (0x18 >> 1),
> +       },
> +};
> +
> +#define N_CAMERA (ARRAY_SIZE(mrst_camera_table))
> +
> +struct videobuf_dma_contig_memory {
> +       u32 magic;
> +       void *vaddr;
> +       dma_addr_t dma_handle;
> +       unsigned long size;
> +       int is_userptr;
> +};
> +
> +#define MAGIC_DC_MEM 0x0733ac61
> +#define MAGIC_CHECK(is, should)                                                    \
> +       if (unlikely((is) != (should))) {                                   \
> +               pr_err("magic mismatch: %x expected %x\n", (is), (should)); \
> +               BUG();                                                      \
> +       }
> +/* flag to determine whether to do the handler of mblk_line irq */
> +int mrst_isp_to_do_mblk_line;
> +unsigned char *mrst_isp_regs;
> +
> +static inline struct ci_sensor_config *to_sensor_config(struct v4l2_subdev *sd)
> +{
> +       return container_of(sd, struct ci_sensor_config, sd);
> +}
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
> +static void print_snr_cfg(struct ci_sensor_config *cfg)
> +{
> +       dprintk(2, "bus width = %x", cfg->bus_width);
> +       dprintk(2, "mode = %x", cfg->mode);
> +       dprintk(2, "field_inv = %x", cfg->field_inv);
> +       dprintk(2, "field_sel = %x", cfg->field_sel);
> +       dprintk(2, "ycseq = %x", cfg->ycseq);
> +       dprintk(2, "conv422 = %x", cfg->conv422);
> +       dprintk(2, "bpat = %x", cfg->bpat);
> +       dprintk(2, "hpol = %x", cfg->hpol);
> +       dprintk(2, "vpol = %x", cfg->vpol);
> +       dprintk(2, "edge = %x", cfg->edge);
> +       dprintk(2, "bls = %x", cfg->bls);
> +       dprintk(2, "gamma = %x", cfg->gamma);
> +       dprintk(2, "cconv = %x", cfg->cconv);
> +       dprintk(2, "res = %x", cfg->res);
> +       dprintk(2, "blc = %x", cfg->blc);
> +       dprintk(2, "agc = %x", cfg->agc);
> +       dprintk(2, "awb = %x", cfg->awb);
> +       dprintk(2, "aec = %x", cfg->aec);
> +       dprintk(2, "cie_profile = %x", cfg->cie_profile);
> +       dprintk(2, "flicker_freq = %x", cfg->flicker_freq);
> +       dprintk(2, "smia_mode = %x", cfg->smia_mode);
> +       dprintk(2, "mipi_mode = %x", cfg->mipi_mode);
> +       dprintk(2, "type = %x", cfg->type);
> +       dprintk(2, "name = %s", cfg->name);
> +}
> +
> +static int mrst_isp_defcfg_all_load(struct ci_isp_config *isp_config)
> +{
> +       /* demosaic mode */
> +       isp_config->demosaic_mode = CI_ISP_DEMOSAIC_ENHANCED;
> +
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
> +       isp_config->af_cfg.wnd_pos_b.hoffs = 0;
> +       isp_config->af_cfg.wnd_pos_b.voffs = 0;
> +       isp_config->af_cfg.wnd_pos_b.hsize = 0;
> +       isp_config->af_cfg.wnd_pos_b.vsize = 0;
> +       isp_config->af_cfg.wnd_pos_c.hoffs = 0;
> +       isp_config->af_cfg.wnd_pos_c.voffs = 0;
> +       isp_config->af_cfg.wnd_pos_c.hsize = 0;
> +       isp_config->af_cfg.wnd_pos_c.vsize = 0;
> +       isp_config->af_cfg.threshold = 0x00000000;
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
> +       isp_config->flags.bls = 0;
> +       isp_config->flags.lsc = 0;
> +       isp_config->flags.bpc = 0;
> +       isp_config->flags.awb = 0;
> +       isp_config->flags.aec = 0;
> +       isp_config->flags.af = 0;
> +       isp_config->flags.cp = 0;
> +       isp_config->flags.gamma = 0;
> +       isp_config->flags.cconv = 0;
> +       isp_config->flags.demosaic = 0;
> +       isp_config->flags.gamma2 = 0;
> +       isp_config->flags.isp_filters = 0;
> +       isp_config->flags.cac = 0;
> +       isp_config->flags.cconv_basic = 0;
> +       isp_config->demosaic_th = 4;
> +
> +       isp_config->view_finder.flags = VFFLAG_HWRGB;
> +
> +       isp_config->afm_mode = 1;
> +       isp_config->filter_level_noise_reduc = 4;
> +       isp_config->filter_level_sharp = 4;
> +
> +       isp_config->jpeg_enc_ratio = 1;
> +
> +       return 0;
> +}
> +
> +static void mrst_isp_update_marvinvfaddr(struct mrst_isp_device *isp,
> +                                     u32 buffer_base,
> +                                     enum ci_isp_conf_update_time update_time)
> +{
> +       struct ci_isp_mi_path_conf isp_mi_path_conf;
> +       struct ci_isp_mi_path_conf isp_sf_mi_path_conf;
> +       static struct v4l2_jpg_review_buffer *jpg_review;
> +       u32 bufsize = 0;
> +       u32 w;
> +       u32 h;
> +
> +       jpg_review = &isp->sys_conf.jpg_review;
> +       memset(&isp_mi_path_conf, 0, sizeof(struct ci_isp_mi_path_conf));
> +       memset(&isp_sf_mi_path_conf, 0, sizeof(struct ci_isp_mi_path_conf));
> +
> +       w = isp_mi_path_conf.llength = isp->bufwidth;
> +       h = isp_mi_path_conf.ypic_height = isp->bufheight;
> +       isp_mi_path_conf.ypic_width = isp->bufwidth;
> +
> +       if (isp->sys_conf.jpg_review_enable) {
> +
> +               /* for self path, JPEG review */
> +               isp_sf_mi_path_conf.ypic_width = jpg_review->width;
> +               isp_sf_mi_path_conf.llength = jpg_review->width;
> +               isp_sf_mi_path_conf.ypic_height = jpg_review->height;
> +
> +               bufsize = jpg_review->width * jpg_review->height;
> +
> +               /* buffer size in bytes */
> +               if (jpg_review->pix_fmt == V4L2_PIX_FMT_YUV420
> +                   || jpg_review->pix_fmt == V4L2_PIX_FMT_YVU420) {

Use a switch here.

> +
> +                       dprintk(3, "VF yuv420 fmt");
> +                       isp_sf_mi_path_conf.ybuffer.size = bufsize;
> +                       isp_sf_mi_path_conf.cb_buffer.size = bufsize/4;
> +                       isp_sf_mi_path_conf.cr_buffer.size = bufsize/4;
> +
> +               } else if (jpg_review->pix_fmt == V4L2_PIX_FMT_YUV422P) {
> +
> +                       dprintk(3, "VF yuv422 fmt");
> +                       isp_sf_mi_path_conf.ybuffer.size = bufsize;
> +                       isp_sf_mi_path_conf.cb_buffer.size = bufsize/2;
> +                       isp_sf_mi_path_conf.cr_buffer.size = bufsize/2;
> +
> +               } else if (jpg_review->pix_fmt == V4L2_PIX_FMT_NV12) {
> +
> +                       dprintk(3, "VF nv12 fmt");
> +                       isp_sf_mi_path_conf.ybuffer.size = bufsize;
> +                       isp_sf_mi_path_conf.cb_buffer.size = bufsize/2;
> +                       isp_sf_mi_path_conf.cr_buffer.size = 0;
> +
> +               } else {
> +                       printk(KERN_ERR "mrstisp: no support jpg review fmt\n");
> +               }
> +
> +               /* buffer address */
> +               if (isp_sf_mi_path_conf.ybuffer.size != 0) {
> +                       isp_sf_mi_path_conf.ybuffer.pucbuffer =
> +                           (u8 *)(unsigned long)
> +                           isp->mb1 + isp->mb1_size - 640*480*2;
> +               }
> +
> +               if (isp_sf_mi_path_conf.cb_buffer.size != 0) {
> +                       isp_sf_mi_path_conf.cb_buffer.pucbuffer =
> +                               isp_sf_mi_path_conf.ybuffer.pucbuffer +
> +                               isp_sf_mi_path_conf.ybuffer.size;
> +               }
> +
> +               if (isp_sf_mi_path_conf.cr_buffer.size != 0) {
> +                       isp_sf_mi_path_conf.cr_buffer.pucbuffer =
> +                               isp_sf_mi_path_conf.cb_buffer.pucbuffer +
> +                               isp_sf_mi_path_conf.cb_buffer.size;
> +               }
> +
> +               if (jpg_review->pix_fmt == V4L2_PIX_FMT_YVU420) {
> +                       isp_sf_mi_path_conf.cr_buffer.pucbuffer =
> +                               isp_sf_mi_path_conf.ybuffer.pucbuffer +
> +                               isp_sf_mi_path_conf.ybuffer.size;
> +                       isp_sf_mi_path_conf.cb_buffer.pucbuffer =
> +                               isp_sf_mi_path_conf.cr_buffer.pucbuffer +
> +                               isp_sf_mi_path_conf.cr_buffer.size;
> +               }
> +
> +       }
> +
> +       if (isp->pixelformat == V4L2_PIX_FMT_YUV420 ||
> +               isp->pixelformat == V4L2_PIX_FMT_YVU420 ||
> +               isp->pixelformat == V4L2_PIX_FMT_YUV422P ||
> +               isp->pixelformat == V4L2_PIX_FMT_NV12) {
> +               bufsize = w*h;
> +       } else
> +               bufsize = isp->frame_size;
> +
> +       /* buffer size in bytes */
> +       if (isp->pixelformat == V4L2_PIX_FMT_YUV420
> +           || isp->pixelformat == V4L2_PIX_FMT_YVU420) {

Use a switch.

I've noticed more places where a switch would be more appropriate.

> +
> +               dprintk(3, "yuv420 fmt");
> +               isp_mi_path_conf.ybuffer.size = bufsize;
> +               isp_mi_path_conf.cb_buffer.size = bufsize/4;
> +               isp_mi_path_conf.cr_buffer.size = bufsize/4;
> +       } else if (isp->pixelformat == V4L2_PIX_FMT_YUV422P) {
> +
> +               dprintk(3, "yuv422 fmt");
> +               isp_mi_path_conf.ybuffer.size = bufsize;
> +               isp_mi_path_conf.cb_buffer.size = bufsize/2;
> +               isp_mi_path_conf.cr_buffer.size = bufsize/2;
> +       } else if (isp->pixelformat == V4L2_PIX_FMT_NV12) {
> +
> +               dprintk(3, "nv12 fmt");
> +               isp_mi_path_conf.ybuffer.size = bufsize;
> +               isp_mi_path_conf.cb_buffer.size = bufsize/2;
> +               isp_mi_path_conf.cr_buffer.size = 0;
> +       } else {
> +
> +               dprintk(3, "jpeg and rgb fmt");
> +               isp_mi_path_conf.ybuffer.size = bufsize;
> +               isp_mi_path_conf.cb_buffer.size = 0;
> +               isp_mi_path_conf.cr_buffer.size = 0;
> +       }
> +
> +       /* buffer address */
> +       if (isp_mi_path_conf.ybuffer.size != 0) {
> +               isp_mi_path_conf.ybuffer.pucbuffer =
> +                   (u8 *)(unsigned long) buffer_base;
> +       }
> +
> +       if (isp_mi_path_conf.cb_buffer.size != 0) {
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
> +
> +       if (isp->pixelformat == V4L2_PIX_FMT_YVU420) {
> +               isp_mi_path_conf.cr_buffer.pucbuffer =
> +                       isp_mi_path_conf.ybuffer.pucbuffer +
> +                       isp_mi_path_conf.ybuffer.size;
> +               isp_mi_path_conf.cb_buffer.pucbuffer =
> +                       isp_mi_path_conf.cr_buffer.pucbuffer +
> +                       isp_mi_path_conf.cr_buffer.size;
> +       }
> +
> +       if (isp->sys_conf.isp_cfg.view_finder.flags & VFFLAG_USE_MAINPATH) {
> +               ci_isp_mif_set_main_buffer(&isp_mi_path_conf, update_time);
> +               if (isp->pixelformat == V4L2_PIX_FMT_JPEG)
> +                       if (isp->sys_conf.jpg_review_enable)
> +                               ci_isp_mif_set_self_buffer(
> +                                   &isp_sf_mi_path_conf, update_time);
> +       } else {
> +               ci_isp_mif_set_self_buffer(&isp_mi_path_conf, update_time);
> +       }
> +}
> +
> +static int mrst_isp_setup_viewfinder_path(struct mrst_isp_device *isp,
> +                                         struct ci_sensor_config *isi_config,
> +                                         int zoom)
> +{
> +       int error = CI_STATUS_SUCCESS;
> +       struct ci_isp_datapath_desc dp_main;
> +       struct ci_isp_datapath_desc dp_self;
> +       struct ci_isp_rect self_rect;
> +       u16 isi_hsize;
> +       u16 isi_vsize;
> +       int jpe_scale;
> +       struct ci_pl_system_config *sys_conf = &isp->sys_conf;
> +       struct ci_isp_config *config = &sys_conf->isp_cfg;
> +       struct v4l2_jpg_review_buffer *jpg_review = &sys_conf->jpg_review;
> +       u32 dp_mode;
> +
> +       if (sys_conf->isp_cfg.flags.ycbcr_full_range)
> +               jpe_scale = false;
> +       else
> +               jpe_scale = true;
> +
> +       memset(&dp_main, 0, sizeof(struct ci_isp_datapath_desc));
> +       memset(&dp_self, 0, sizeof(struct ci_isp_datapath_desc));
> +
> +       self_rect.x = 0;
> +       self_rect.y = 0;
> +       self_rect.w = isp->bufwidth;
> +       self_rect.h = isp->bufheight;
> +
> +       if (isp->pixelformat == V4L2_PIX_FMT_JPEG) {
> +
> +               dprintk(1, "jpeg fmt");
> +
> +               dp_main.flags = CI_ISP_DPD_ENABLE | CI_ISP_DPD_MODE_ISPJPEG;
> +               config->view_finder.flags |= VFFLAG_USE_MAINPATH;
> +
> +               dp_main.out_w = (u16) isp->bufwidth;
> +               dp_main.out_h = (u16) isp->bufheight;
> +
> +               if (isp->sys_conf.jpg_review_enable) {
> +
> +                       dprintk(1, "jpg_review enabled in VF");
> +
> +                       self_rect.w = jpg_review->width;
> +                       self_rect.h = jpg_review->height;
> +
> +                       dp_self.flags = (CI_ISP_DPD_ENABLE
> +                                        | CI_ISP_DPD_MODE_ISPYC);
> +                       if (jpg_review->pix_fmt == V4L2_PIX_FMT_YUV420 ||
> +                               jpg_review->pix_fmt == V4L2_PIX_FMT_YVU420)
> +                               dp_self.flags |= CI_ISP_DPD_YUV_420
> +                                   | CI_ISP_DPD_CSS_V2;
> +                       else if (jpg_review->pix_fmt == V4L2_PIX_FMT_YUV422P)
> +                               dp_self.flags |= CI_ISP_DPD_YUV_422;
> +                       else if (jpg_review->pix_fmt == V4L2_PIX_FMT_NV12)
> +                               dp_self.flags |= CI_ISP_DPD_YUV_NV12
> +                                   | CI_ISP_DPD_CSS_V2;
> +                       else if (jpg_review->pix_fmt == V4L2_PIX_FMT_YUYV)
> +                               dp_self.flags |= CI_ISP_DPD_YUV_YUYV;
> +
> +                       dprintk(1, "dp_self.flags is 0x%x", dp_self.flags);
> +               }
> +
> +       } else if (isp->pixelformat == INTEL_PIX_FMT_RAW08) {
> +
> +               dp_main.flags = CI_ISP_DPD_ENABLE | CI_ISP_DPD_MODE_ISPRAW;
> +               config->view_finder.flags |= VFFLAG_USE_MAINPATH;
> +
> +               /*just take the output of the sensor without any resizing*/
> +               dp_main.flags |= CI_ISP_DPD_NORESIZE;
> +               (void)ci_sensor_res2size(isi_config->res,
> +                                        &(dp_main.out_w), &(dp_main.out_h));
> +
> +               dprintk(1, "RAW08 dp_main.flags is 0x%x", dp_main.flags);
> +
> +       } else if (isp->pixelformat == INTEL_PIX_FMT_RAW10
> +                  || isp->pixelformat == INTEL_PIX_FMT_RAW12) {
> +
> +               dp_main.flags = (CI_ISP_DPD_ENABLE
> +                                | CI_ISP_DPD_MODE_ISPRAW_16B);
> +               config->view_finder.flags |= VFFLAG_USE_MAINPATH;
> +
> +               /*just take the output of the sensor without any resizing*/
> +               dp_main.flags |= CI_ISP_DPD_NORESIZE;
> +               (void)ci_sensor_res2size(isi_config->res,
> +                                        &(dp_main.out_w), &(dp_main.out_h));
> +
> +               dprintk(1, "RAW10 dp_main.flags is 0x%x", dp_main.flags);
> +
> +       } else if (isp->bufwidth >= 32 && isp->bufheight >= 16) {
> +
> +               dp_main.flags = (CI_ISP_DPD_ENABLE | CI_ISP_DPD_MODE_ISPYC);
> +               dp_main.out_w = (u16) isp->bufwidth;
> +               dp_main.out_h = (u16) isp->bufheight;
> +               config->view_finder.flags |= VFFLAG_USE_MAINPATH;
> +
> +               if (isp->pixelformat == V4L2_PIX_FMT_YUV420 ||
> +                       isp->pixelformat == V4L2_PIX_FMT_YVU420)
> +                       dp_main.flags |= CI_ISP_DPD_YUV_420 | CI_ISP_DPD_CSS_V2;
> +               else if (isp->pixelformat == V4L2_PIX_FMT_YUV422P)
> +                       dp_main.flags |= CI_ISP_DPD_YUV_422;
> +               else if (isp->pixelformat == V4L2_PIX_FMT_NV12) {
> +                       /* to use crop set crop_flag first */
> +                       dp_main.flags |= CI_ISP_DPD_YUV_NV12;
> +                       if (!crop_flag)
> +                               dp_main.flags |= CI_ISP_DPD_CSS_V2;
> +               } else if (isp->pixelformat == V4L2_PIX_FMT_YUYV)
> +                       dp_main.flags |= CI_ISP_DPD_YUV_YUYV;
> +
> +               dprintk(1, "YUV dp_main.flags is 0x%x", dp_main.flags);
> +
> +       } else {
> +               dprintk(1, "wrong setting");
> +       }
> +
> +       dprintk(1, "sensor_res = %x", isi_config->res);
> +
> +       (void)ci_sensor_res2size(isi_config->res, &isi_hsize, &isi_vsize);
> +       dprintk(1, "self path: w:%d, h:%d; sensor: w:%d, h:%d",
> +               self_rect.w, self_rect.h, isi_hsize, isi_vsize);
> +       dprintk(1, "main path: out_w:%d, out_h:%d ",
> +               dp_main.out_w, dp_main.out_h);
> +
> +       /* no stretching/squeezing */
> +       if (dp_self.flags && CI_ISP_DPD_ENABLE)
> +               dp_self.flags |= CI_ISP_DPD_KEEPRATIO;
> +       else
> +               dp_main.flags |= CI_ISP_DPD_KEEPRATIO;
> +
> +       /* prepare datapath, 640x480, can changed to the bufsize */
> +       dp_self.out_w = (u16) self_rect.w;
> +       dp_self.out_h = (u16) self_rect.h;
> +
> +       if (sys_conf->isp_cfg.view_finder.flags & VFFLAG_HWRGB) {
> +               /* YCbCr to RGB conversion in hardware */
> +               if (isp->pixelformat == V4L2_PIX_FMT_RGB565)
> +                       dp_self.flags |= CI_ISP_DPD_HWRGB_565;
> +               if (isp->pixelformat == V4L2_PIX_FMT_BGR32)
> +                       dp_self.flags |= CI_ISP_DPD_HWRGB_888;
> +       }
> +
> +       if (sys_conf->isp_cfg.view_finder.flags & VFFLAG_MIRROR)
> +               dp_self.flags |= CI_ISP_DPD_H_FLIP;
> +
> +
> +       if (sys_conf->isp_cfg.view_finder.flags & VFFLAG_V_FLIP)
> +               dp_self.flags |= CI_ISP_DPD_V_FLIP;
> +
> +
> +       if (sys_conf->isp_cfg.view_finder.flags & VFFLAG_ROT90_CCW)
> +               dp_self.flags |= CI_ISP_DPD_90DEG_CCW;
> +
> +       /* setup self & main path with zoom */
> +       if (zoom < 0)
> +               zoom = sys_conf->isp_cfg.view_finder.zoom;
> +
> +       if (sys_conf->isp_cfg.view_finder.flags & VFFLAG_USE_MAINPATH) {
> +               /* For RAW snapshots, we have to bypass the ISP too */
> +               dp_mode = dp_main.flags & CI_ISP_DPD_MODE_MASK;
> +               if ((dp_mode == CI_ISP_DPD_MODE_ISPRAW) ||
> +                       (dp_mode == CI_ISP_DPD_MODE_ISPRAW_16B)) {
> +                       struct ci_sensor_config isi_conf;
> +                       isi_conf = *isi_config;
> +                       isi_conf.mode = SENSOR_MODE_PICT;
> +                       error = ci_isp_set_input_aquisition(&isi_conf);
> +                       if (error != CI_STATUS_SUCCESS)
> +                               eprintk("33");
> +               }
> +       }
> +       /* to use crop mode, set crop_flag */
> +       if (crop_flag)
> +               dp_main.flags |= CI_ISP_DPD_NORESIZE;
> +
> +       error = ci_datapath_isp(sys_conf, isi_config, &dp_main, &dp_self, zoom);
> +       if (error != CI_STATUS_SUCCESS) {
> +               printk(KERN_ERR "mrstisp: failed to setup marvins datapath\n");
> +               return error;
> +       }
> +
> +       DBG_leaving;
> +       return error;
> +}
> +
> +static int mrst_isp_init_mrv_image_effects(struct ci_pl_system_config *sys_conf,
> +                                          int enable)
> +{
> +       int res;
> +
> +       if (enable && sys_conf->isp_cfg.img_eff_cfg.mode
> +           != CI_ISP_IE_MODE_OFF) {
> +               res = ci_isp_ie_set_config(&(sys_conf->isp_cfg.img_eff_cfg));
> +               if (res != CI_STATUS_SUCCESS)
> +                       printk(KERN_ERR "mrstisp: error setting ie config\n");
> +       } else {
> +               (void)ci_isp_ie_set_config(NULL);
> +               res = CI_STATUS_SUCCESS;
> +       }
> +
> +       return res;
> +}
> +
> +static int mrst_isp_init_mrvisp_lensshade(struct ci_pl_system_config *sys_conf,
> +                                         int enable)
> +{
> +       if ((enable) && (sys_conf->isp_cfg.flags.lsc)) {
> +               ci_isp_set_ls_correction(&sys_conf->isp_cfg.lsc_cfg);
> +               ci_isp_ls_correction_on_off(1);
> +       } else {
> +               ci_isp_ls_correction_on_off(0);
> +       }
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +static int mrst_isp_init_mrvisp_badpixel(const struct ci_pl_system_config
> +                                        *sys_conf, int enable)
> +{
> +       if ((enable) && (sys_conf->isp_cfg.flags.bpc)) {
> +               (void)ci_bp_init(&sys_conf->isp_cfg.bpc_cfg,
> +                                &sys_conf->isp_cfg.bpd_cfg);
> +       } else {
> +               (void)ci_bp_end(&sys_conf->isp_cfg.bpc_cfg);
> +               (void)ci_isp_set_bp_correction(NULL);
> +               (void)ci_isp_set_bp_detection(NULL);
> +       }
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +static int mrst_isp_init_mrv_ispfilter(const struct ci_pl_system_config
> +                                      *sys_conf, int enable)
> +{
> +       int res;
> +
> +       if ((enable) && (sys_conf->isp_cfg.flags.isp_filters)) {
> +               ci_isp_activate_filter(true);
> +               res = ci_isp_set_filter_params(sys_conf->isp_cfg.
> +                                              filter_level_noise_reduc,
> +                                              sys_conf->isp_cfg.
> +                                              filter_level_sharp);
> +               if (res != CI_STATUS_SUCCESS)
> +                       printk(KERN_ERR "mrstisp: error set filter param\n");
> +       } else {
> +               ci_isp_activate_filter(false);
> +               res = CI_STATUS_SUCCESS;
> +       }
> +
> +       return res;
> +}
> +
> +static int mrst_isp_init_mrvisp_cac(const struct ci_pl_system_config *sys_conf,
> +                                   int enable)
> +{
> +       return 0;
> +}

Huh? Can this function be removed perhaps?

> +
> +static int mrst_isp_initbls(const struct ci_pl_system_config *sys_conf)
> +{
> +       struct ci_isp_bls_config *bls_config =
> +           (struct ci_isp_bls_config *)&sys_conf->isp_cfg.bls_cfg;
> +       return ci_isp_bls_set_config(bls_config);
> +}
> +
> +static int mrst_isp_dp_init(struct ci_pl_system_config *sys_conf,
> +                           struct ci_sensor_config *isi_config)
> +{
> +       int error;
> +       u8 words_per_pixel;
> +
> +       /* base initialisation of Marvin */
> +       ci_isp_init();
> +
> +       /* setup input acquisition according to image sensor settings */
> +       print_snr_cfg(isi_config);
> +       error = ci_isp_set_input_aquisition(isi_config);
> +       if (error) {
> +               printk(KERN_ERR "mrstisp: error setting input acquisition\n");
> +               return error;
> +       }
> +
> +       /* setup functional blocks for Bayer pattern processing */
> +       if (ci_isp_select_path(isi_config, &words_per_pixel)
> +           == CI_ISP_PATH_BAYER) {
> +
> +               /* black level */
> +               if (sys_conf->isp_cfg.flags.bls) {
> +                       error = mrst_isp_initbls(sys_conf);
> +                       if (error != CI_STATUS_SUCCESS) {
> +                               printk(KERN_ERR "mrstisp: error set bls\n");
> +                               return error;
> +                       }
> +               } else {
> +                       ci_isp_bls_set_config(NULL);
> +               }
> +
> +               /* gamma */
> +               if (sys_conf->isp_cfg.flags.gamma2) {
> +                       dprintk(1, "setting gamma 2 ");
> +                       ci_isp_set_gamma2(&g45_th20_b5);
> +               } else {
> +                       dprintk(1, "no setting gamma 2 ");
> +                       ci_isp_set_gamma2(NULL);
> +               }
> +
> +               /* demosaic */
> +               ci_isp_set_demosaic(sys_conf->isp_cfg.demosaic_mode,
> +                                   sys_conf->isp_cfg.demosaic_th);
> +
> +               /* color convertion */
> +               if (sys_conf->isp_cfg.flags.cconv) {
> +                       if (!sys_conf->isp_cfg.flags.cconv_basic) {
> +                               mrst_isp_set_color_conversion_ex();
> +                               if (error != CI_STATUS_SUCCESS) {
> +                                       printk(KERN_ERR "mrstisp: error set"
> +                                              " color conversion\n");
> +                                       return error;
> +                               }
> +                       }
> +               }
> +
> +               /* af setting */
> +               if (sys_conf->isp_cfg.flags.af)
> +                       ci_isp_set_auto_focus(&sys_conf->isp_cfg.af_cfg);
> +               else
> +                       ci_isp_set_auto_focus(NULL);
> +
> +               /* filter */
> +               mrst_isp_init_mrv_ispfilter(sys_conf, true);
> +
> +               /* cac */
> +               mrst_isp_init_mrvisp_cac(sys_conf, true);
> +       }
> +
> +       ci_isp_col_set_color_processing(NULL);
> +
> +       /* configure image effects */
> +       mrst_isp_init_mrv_image_effects(sys_conf, true);
> +
> +       /* configure lens shading correction */
> +       mrst_isp_init_mrvisp_lensshade(sys_conf, true);
> +
> +       /* configure bad pixel detection/correction */
> +       mrst_isp_init_mrvisp_badpixel(sys_conf, true);
> +
> +       DBG_leaving;
> +       return CI_STATUS_SUCCESS;
> +}
> +
> +int ci_jpe_encode(struct mrst_isp_device *intel,
> +                 enum ci_isp_conf_update_time update_time,
> +                 enum ci_isp_jpe_enc_mode mrv_jpe_encMode)
> +{
> +       ci_isp_jpe_prep_enc(mrv_jpe_encMode);
> +       ci_isp_start(1, update_time);
> +
> +       return ci_isp_jpe_wait_for_encode_done(intel);
> +}
> +
> +/* capture one frame */
> +u32 ci_jpe_capture(struct mrst_isp_device *isp,
> +                  enum ci_isp_conf_update_time update_time)
> +{
> +       int retval = CI_STATUS_SUCCESS;
> +
> +       /* generate header */
> +       retval = ci_isp_jpe_generate_header(isp, MRV_JPE_HEADER_MODE_JFIF);
> +       if (retval != CI_STATUS_SUCCESS)
> +               return 0;
> +
> +       /* now encode JPEG */
> +       retval = ci_jpe_encode(isp, update_time, CI_ISP_JPE_SINGLE_SHOT);
> +       if (retval != CI_STATUS_SUCCESS)
> +               return 0;
> +
> +       return 0;
> +}
> +
> +static int mrst_ci_capture(struct mrst_isp_device *isp)
> +{
> +       u32 bufbase;
> +       u32 mipi_data_id = 1;
> +       struct videobuf_buffer *vb;
> +       struct isp_register *mrv_reg =
> +           (struct isp_register *) MEM_MRV_REG_BASE;
> +
> +       bufbase = videobuf_to_dma_contig(isp->active);
> +       mrst_isp_update_marvinvfaddr(isp, bufbase, CI_ISP_CFG_UPDATE_IMMEDIATE);
> +       ci_isp_mif_reset_offsets(CI_ISP_CFG_UPDATE_IMMEDIATE);
> +
> +       ci_isp_reset_interrupt_status();
> +       mrst_isp_enable_interrupt(isp);
> +
> +       if (isp->pixelformat == V4L2_PIX_FMT_JPEG) {
> +               mrst_isp_disable_interrupt(isp);
> +               ci_isp_jpe_init_ex(isp->bufwidth, isp->bufheight,
> +                                  isp->sys_conf.isp_cfg.jpeg_enc_ratio,
> +                                  true);
> +               ci_jpe_capture(isp, CI_ISP_CFG_UPDATE_FRAME_SYNC);
> +
> +               vb = isp->active;
> +               vb->size = ci_isp_mif_get_byte_cnt();
> +               vb->state = VIDEOBUF_DONE;
> +               do_gettimeofday(&vb->ts);
> +               vb->field_count++;
> +               wake_up(&vb->done);
> +               isp->active = NULL;
> +
> +               dprintk(2, "countcount = %lx", vb->size);
> +       } else if (isp->pixelformat == INTEL_PIX_FMT_RAW08
> +                  || isp->pixelformat == INTEL_PIX_FMT_RAW10
> +                  || isp->pixelformat == INTEL_PIX_FMT_RAW12) {
> +                       mrst_isp_disable_interrupt(isp);
> +                       ci_isp_start(1, CI_ISP_CFG_UPDATE_FRAME_SYNC);
> +                       ci_isp_wait_for_frame_end(isp);
> +
> +                       /* update captured frame status */
> +                       vb = isp->active;
> +                       vb->state = VIDEOBUF_DONE;
> +                       do_gettimeofday(&vb->ts);
> +                       vb->field_count++;
> +                       wake_up(&vb->done);
> +                       isp->active = NULL;
> +                       dprintk(3, "captured  index = %d", vb->i);
> +       } else {
> +               ci_isp_start(0, CI_ISP_CFG_UPDATE_FRAME_SYNC);
> +               if (mipi_flag &&
> +                   (to_sensor_config(isp->sensor_curr))->mipi_mode) {
> +                       while (mipi_data_id) {
> +                               mipi_data_id =
> +                                   REG_READ_EX(mrv_reg->mipi_cur_data_id);
> +                               dprintk(5, "mipi_cur_data_id = %x",
> +                                       mipi_data_id);
> +                       }
> +                       mipi_flag = 0;
> +               }
> +
> +       }
> +
> +       return 0;
> +}
> +
> +static int buffer_setup(struct videobuf_queue *vq, unsigned int *count,
> +                       unsigned int *size)
> +{
> +       struct mrst_isp_fh  *fh = vq->priv_data;
> +       struct mrst_isp_device *isp  = fh->dev;
> +
> +       u32 w = isp->bufwidth;
> +       u32 h = isp->bufheight;
> +       u32 depth = isp->depth;
> +       u32 fourcc = isp->pixelformat;
> +
> +       if (fourcc == V4L2_PIX_FMT_JPEG) {
> +               *size = PAGE_ALIGN((isp->mb1_size
> +                                   - 640*480*2)/(*count)) - PAGE_SIZE;
> +       } else if (fourcc == INTEL_PIX_FMT_RAW08
> +                  || fourcc == INTEL_PIX_FMT_RAW10
> +                  || fourcc == INTEL_PIX_FMT_RAW12) {
> +               *size = (w * h * depth)/8;
> +       } else {
> +               *size = (w * h * depth)/8;
> +       }
> +
> +       isp->frame_size = *size;
> +       isp->num_frames = *count;
> +
> +       if (0 == *count)
> +               *count = 3;
> +
> +       while (*size * *count > isp->mb1_size)
> +               (*count)--;
> +
> +       dprintk(1, "count=%d, size=%d", *count, *size);
> +       return 0;
> +}
> +
> +static void free_buffer(struct videobuf_queue *vq, struct mrst_isp_buffer *buf)
> +{
> +       struct videobuf_buffer *vb = &buf->vb;
> +
> +       dprintk(1, "(vb=0x%p) baddr = 0x%08lx bsize = %d", vb,
> +               vb->baddr, vb->bsize);
> +
> +       videobuf_dma_contig_free(vq, vb);
> +
> +       buf->vb.state = VIDEOBUF_NEEDS_INIT;
> +       dprintk(1, "free_buffer: freed");
> +}
> +
> +static int buffer_prepare(struct videobuf_queue *vq,
> +                         struct videobuf_buffer *vb, enum v4l2_field field)
> +{
> +       struct mrst_isp_fh     *fh  = vq->priv_data;
> +       struct mrst_isp_device *isp = fh->dev;
> +       struct mrst_isp_buffer *buf = container_of(vb, struct mrst_isp_buffer,
> +                                                  vb);
> +       int ret;
> +
> +       if (vb->width != isp->bufwidth || vb->height != isp->bufheight
> +          || vb->field != field) {
> +               vb->width  = isp->bufwidth;
> +               vb->height = isp->bufheight;
> +               vb->field  = field;
> +               vb->state = VIDEOBUF_NEEDS_INIT;
> +       }
> +
> +       vb->size = isp->frame_size;
> +
> +       if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
> +               ret = videobuf_iolock(vq, vb, NULL);
> +               if (ret)
> +                       goto fail;
> +               vb->state = VIDEOBUF_PREPARED;
> +       }
> +
> +       return 0;
> +
> +fail:
> +       printk(KERN_ERR "mrstisp: error calling videobuf_iolock");
> +       free_buffer(vq, buf);
> +       return ret;
> +}
> +
> +static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
> +{
> +       struct mrst_isp_fh        *fh   = vq->priv_data;
> +       struct mrst_isp_device       *isp  = fh->dev;
> +
> +       vb->state = VIDEOBUF_QUEUED;
> +       dprintk(1, "buffer %d in buffer querue", vb->i);
> +       if (!isp->active) {
> +               dprintk(1, "no active queue");
> +               isp->active = vb;
> +               isp->active->state = VIDEOBUF_ACTIVE;
> +               mrst_isp_to_do_mblk_line = 1;
> +               mrst_ci_capture(isp);
> +       } else {
> +               dprintk(1, "capture to active queue");
> +               list_add_tail(&vb->queue, &isp->capture);
> +       }
> +
> +       return;
> +}
> +
> +static void buffer_release(struct videobuf_queue *vq,
> +                          struct videobuf_buffer *vb)
> +{
> +       struct mrst_isp_buffer *buf = container_of(vb,
> +                                                  struct mrst_isp_buffer, vb);
> +       free_buffer(vq, buf);
> +}
> +
> +static struct videobuf_queue_ops mrst_isp_videobuf_qops = {
> +       .buf_setup      = buffer_setup,
> +       .buf_prepare    = buffer_prepare,
> +       .buf_queue      = buffer_queue,
> +       .buf_release    = buffer_release,
> +};
> +
> +static int mrst_isp_open(struct file *file)
> +{
> +       struct video_device *vdev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(vdev);
> +       struct mrst_isp_fh *fh = NULL;
> +       struct v4l2_format sensor_format;
> +       int ret;
> +
> +       if (!isp) {
> +               printk(KERN_ERR "null in mrst_isp_open\n");
> +               return -ENODEV;
> +       }
> +
> +       dprintk(2, "open = %d", isp->open);
> +       mutex_lock(&isp->mutex);
> +    if (isp->open == 0) {
> +               if (isp->sensor_soc) {
> +                       dprintk(0, "cur senfor soc");
> +                       isp->sensor_curr = isp->sensor_soc;
> +               } else {
> +                       dprintk(0, "cur sensor raw");
> +                       isp->sensor_curr = isp->sensor_raw;
> +               }
> +       }
> +       ++isp->open;
> +
> +       ret = v4l2_subdev_call(isp->sensor_curr, video, g_fmt,
> +                              &sensor_format);
> +       if (ret) {
> +               printk(KERN_ERR "can't get current pix from sensor!\n");
> +               ret = -EINVAL;
> +               goto exit_unlock;
> +       }
> +
> +       dprintk(1, "current sensor format: %d x %d",
> +               sensor_format.fmt.pix.width,
> +               sensor_format.fmt.pix.height);
> +
> +       fh = kzalloc(sizeof(*fh), GFP_KERNEL);

Note: recently the v4l2_fh struct was introduced. I recommend that you embed
struct in mrst_isp_fh. Not only will it give you support for the new events API,
it will also be used in the near future for other things such as
VIDIOC_G/S_PRIORITY handling.

> +       if (NULL == fh) {
> +               printk(KERN_ERR "no mem for fh \n");
> +               ret = -ENOMEM;
> +               goto exit_unlock;
> +       }
> +
> +       file->private_data = fh;
> +       fh->dev = isp;
> +
> +       videobuf_queue_dma_contig_init(&fh->vb_q, &mrst_isp_videobuf_qops,
> +                                      vdev->parent, &isp->lock,
> +                                      V4L2_BUF_TYPE_VIDEO_CAPTURE,
> +                                      V4L2_FIELD_NONE,
> +                                      sizeof(struct mrst_isp_buffer), fh);
> +
> +exit_unlock:
> +       mutex_unlock(&isp->mutex);
> +       return 0;
> +}
> +
> +static int mrst_isp_close(struct file *file)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(dev);
> +       struct mrst_isp_fh  *fh = file->private_data;
> +       unsigned long flags;
> +
> +       mutex_lock(&isp->mutex);
> +       --isp->open;
> +       dprintk(2, "close = %d", isp->open);
> +       if (isp->open == 0)
> +               if (isp->streaming == 1) {

This doesn't seem right. The file handle that started streaming is also
the one that will have to stop it when it is closed. And not the last file
handle.

> +                       videobuf_streamoff(&fh->vb_q);
> +                       isp->streaming = 0;
> +                       isp->buffer_required = 0;
> +
> +                       spin_lock_irqsave(&isp->lock, flags);
> +                       INIT_LIST_HEAD(&isp->capture);
> +                       isp->active = NULL;
> +                       isp->next = NULL;
> +                       isp->sys_conf.isp_hal_enable = 0;
> +                       isp->sys_conf.jpg_review_enable = 0;
> +                       spin_unlock_irqrestore(&isp->lock, flags);
> +
> +                       ci_isp_stop(CI_ISP_CFG_UPDATE_FRAME_SYNC);
> +                       v4l2_subdev_call(isp->sensor_curr, video, s_stream, 0);
> +                       isp->sensor_curr = NULL;
> +               }
> +
> +       kfree(file->private_data);
> +
> +       mutex_unlock(&isp->mutex);
> +
> +       if (isp->open == 0)
> +               frame_cnt = 0;
> +
> +       DBG_leaving;
> +       return 0;
> +}
> +
> +static ssize_t mrst_isp_read(struct file *file, char __user *buf,
> +                            size_t count, loff_t *ppos)
> +{
> +       return 0;
> +}

??? I wouldn't implement read() at all if you don't do anything with it.

> +
> +static void mrst_isp_videobuf_vm_open(struct vm_area_struct *vma)
> +{
> +       struct videobuf_mapping *map = vma->vm_private_data;
> +
> +       dprintk(2, "vm_open %p [count=%u,vma=%08lx-%08lx]\n",
> +               map, map->count, vma->vm_start, vma->vm_end);
> +
> +       map->count++;
> +}
> +
> +static void mrst_isp_videobuf_vm_close(struct vm_area_struct *vma)
> +{
> +       struct videobuf_mapping *map = vma->vm_private_data;
> +       struct videobuf_queue *q = map->q;
> +       int i;
> +
> +       dprintk(2, "vm_close %p [count=%u,vma=%08lx-%08lx]\n",
> +               map, map->count, vma->vm_start, vma->vm_end);
> +
> +       map->count--;
> +       if (0 == map->count) {
> +               struct videobuf_dma_contig_memory *mem;
> +
> +               dprintk(2, "munmap %p q=%p\n", map, q);
> +               mutex_lock(&q->vb_lock);
> +
> +               /* We need first to cancel streams, before unmapping */
> +               if (q->streaming)
> +                       videobuf_queue_cancel(q);
> +
> +               for (i = 0; i < VIDEO_MAX_FRAME; i++) {
> +                       if (NULL == q->bufs[i])
> +                               continue;
> +
> +                       if (q->bufs[i]->map != map)
> +                               continue;
> +
> +                       mem = q->bufs[i]->priv;
> +                       if (mem) {
> +                               MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
> +                               dprintk(2, "buf[%d] freeing %p\n",
> +                                       i, mem->vaddr);
> +                               mem->vaddr = NULL;
> +                       }
> +
> +                       q->bufs[i]->map   = NULL;
> +                       q->bufs[i]->baddr = 0;
> +               }
> +
> +               kfree(map);
> +
> +               mutex_unlock(&q->vb_lock);
> +       }
> +}
> +
> +static struct vm_operations_struct mrst_isp_videobuf_vm_ops = {
> +       .open     = mrst_isp_videobuf_vm_open,
> +       .close    = mrst_isp_videobuf_vm_close,
> +};
> +
> +static int mrst_isp_mmap_mapper(struct videobuf_queue *q,
> +                                 struct vm_area_struct *vma)
> +{
> +       struct videobuf_dma_contig_memory *mem;
> +       struct videobuf_mapping *map;
> +       unsigned int first;
> +       int retval;
> +       unsigned long size, offset = vma->vm_pgoff << PAGE_SHIFT;
> +
> +       struct mrst_isp_fh  *fh = q->priv_data;
> +       struct mrst_isp_device *isp  = fh->dev;
> +
> +       if (!(vma->vm_flags & VM_WRITE) || !(vma->vm_flags & VM_SHARED))
> +               return -EINVAL;
> +
> +       /* look for first buffer to map */
> +       for (first = 0; first < VIDEO_MAX_FRAME; first++) {
> +               if (!q->bufs[first])
> +                       continue;
> +
> +               if (V4L2_MEMORY_MMAP != q->bufs[first]->memory)
> +                       continue;
> +               if (q->bufs[first]->boff == offset) {
> +                       dprintk(1, "buff id %d is mapped", first);
> +                       break;
> +               }
> +       }
> +       if (VIDEO_MAX_FRAME == first) {
> +               eprintk("invalid user space offset [offset=0x%lx]", offset);
> +               return -EINVAL;
> +       }
> +
> +       /* create mapping + update buffer list */
> +       map = kzalloc(sizeof(struct videobuf_mapping), GFP_KERNEL);
> +       if (!map)
> +               return -ENOMEM;
> +
> +       q->bufs[first]->map = map;
> +       map->start = vma->vm_start;
> +       map->end = vma->vm_end;
> +       map->q = q;
> +
> +       q->bufs[first]->baddr = vma->vm_start;
> +
> +       mem = q->bufs[first]->priv;
> +       BUG_ON(!mem);
> +       MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
> +
> +       mem->size = PAGE_ALIGN(q->bufs[first]->bsize);
> +       mem->dma_handle = isp->mb1 + (mem->size * first);
> +       mem->vaddr = (void *)0x1;
> +
> +       if (mem->size > isp->mb1_size) {
> +               eprintk("to big size, can not be mmapped");
> +               return -EINVAL;
> +       }
> +
> +       /* Try to remap memory */
> +       size = vma->vm_end - vma->vm_start;
> +       size = (size < mem->size) ? size : mem->size;
> +
> +       dprintk(1, "vm_end - vm_start = %ld, mem-size = %ld", size, mem->size);
> +
> +       vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +       retval = remap_pfn_range(vma, vma->vm_start,
> +                                mem->dma_handle >> PAGE_SHIFT,
> +                                size, vma->vm_page_prot);
> +       if (retval) {
> +               eprintk("mmap: remap failed with error %d. ", retval);
> +               goto error;
> +       }
> +
> +       vma->vm_ops          = &mrst_isp_videobuf_vm_ops;
> +       vma->vm_flags       |= VM_DONTEXPAND;
> +       vma->vm_private_data = map;
> +
> +       dprintk(1, "mmap %p: q=%p %08lx-%08lx (%lx) pgoff %08lx buf %d\n",
> +               map, q, vma->vm_start, vma->vm_end,
> +               (long int) q->bufs[first]->bsize,
> +               vma->vm_pgoff, first);
> +
> +       mrst_isp_videobuf_vm_open(vma);
> +
> +       return 0;
> +
> +error:
> +       kfree(map);
> +       return -ENOMEM;
> +}
> +
> +int mrst_isp_videobuf_mmap_mapper(struct videobuf_queue *q,
> +                        struct vm_area_struct *vma)
> +{
> +       MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
> +
> +       mutex_lock(&q->vb_lock);
> +       mrst_isp_mmap_mapper(q, vma);
> +       q->is_mmapped = 1;
> +       mutex_unlock(&q->vb_lock);
> +
> +       return 0;
> +}
> +static int mrst_isp_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +       int ret;
> +       int map_by_myself;
> +       struct mrst_isp_fh  *fh;
> +       struct video_device *dev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(dev);
> +       unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
> +       unsigned long size = vma->vm_end-vma->vm_start;
> +       unsigned long page;
> +
> +       /* temporarily put here */
> +       if (isp->open > 1) {
> +               printk(KERN_ERR "ISP already opened...");
> +               return -EINVAL;
> +       }
> +
> +       fh = file->private_data;
> +
> +       if (!(vma->vm_flags & (VM_WRITE | VM_READ))
> +           || !(vma->vm_flags & VM_SHARED)) {
> +               printk(KERN_ERR "mrstisp: wrong vma flag");
> +               return -EINVAL;
> +       }
> +
> +       /* to check whether if it is ISP bar 0 map */
> +       if (offset == isp->mb0_size + isp->mb1_size) {
> +               dprintk(1, "---- map bar0 ----");
> +               page = isp->mb0;
> +               map_by_myself = 1;
> +       } else if (offset == 0 && size == isp->mb1_size) {
> +               dprintk(1, "---- map bar1 ----");
> +               page = isp->mb1;
> +               map_by_myself = 1;
> +       } else if (isp->pixelformat == V4L2_PIX_FMT_JPEG
> +                  && isp->sys_conf.jpg_review_enable == 1
> +                  && offset == isp->sys_conf.jpg_review.offset) {
> +               dprintk(1, "---- map jpeg review buffer----");
> +               page = isp->mb1 + isp->sys_conf.jpg_review.offset;
> +               map_by_myself = 1;
> +       } else {
> +               dprintk(1, "----map one certain buffer----");
> +               map_by_myself = 0;
> +       }
> +
> +       if (map_by_myself) {
> +               vma->vm_flags |= VM_IO;
> +               vma->vm_flags |= VM_RESERVED;   /* avoid to swap out this VMA */
> +
> +               page = page >> PAGE_SHIFT;
> +
> +               if (remap_pfn_range(vma, vma->vm_start, page, size,
> +                                   PAGE_SHARED)) {
> +                       printk(KERN_ERR "fail to put MMAP buffer to user space\n");
> +                       return -EAGAIN;
> +               }
> +
> +               return 0;
> +       }
> +
> +       if (size > isp->num_frames * PAGE_ALIGN(isp->frame_size)) {
> +               eprintk("length is larger than num * size");
> +               return -EINVAL;
> +       }
> +
> +       ret = mrst_isp_videobuf_mmap_mapper(&fh->vb_q, vma);
> +
> +       dprintk(1, "vma start=0x%08lx, size=%ld, offset=%ld ret=%d",
> +               (unsigned long)vma->vm_start,
> +               (unsigned long)vma->vm_end-(unsigned long)vma->vm_start,
> +               (unsigned long)offset, ret);
> +
> +       return ret;
> +}
> +
> +static int mrst_isp_g_fmt_cap(struct file *file, void *priv,
> +                               struct v4l2_format *f)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(dev);
> +       int ret;
> +
> +       WARN_ON(priv != file->private_data);
> +
> +       if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +               f->fmt.pix.width = isp->bufwidth;
> +               f->fmt.pix.height = isp->bufheight;
> +               f->fmt.pix.pixelformat = isp->pixelformat;
> +               f->fmt.pix.bytesperline = (f->fmt.pix.width * isp->depth) >> 3;
> +               f->fmt.pix.sizeimage = f->fmt.pix.height
> +                   * f->fmt.pix.bytesperline;

Also set field and colorspace.

> +               ret = 0;
> +       } else {
> +               ret = -EINVAL;
> +       }
> +
> +       dprintk(1, "get fmt %d x %d ", f->fmt.pix.width, f->fmt.pix.height);
> +       DBG_leaving;
> +       return ret;
> +}
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
> +static int mrst_isp_try_fmt_cap(struct file *file, void *priv,
> +                               struct v4l2_format *f)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(dev);
> +
> +       struct intel_fmt *fmt;
> +       int w, h;
> +       int ret;
> +
> +       WARN_ON(priv != file->private_data);
> +
> +       mutex_lock(&isp->mutex);
> +
> +       fmt = fmt_by_fourcc(f->fmt.pix.pixelformat);
> +       if (NULL == fmt && f->fmt.pix.pixelformat != V4L2_PIX_FMT_MPEG) {
> +               printk(KERN_ERR "mrstisp: fmt not found\n");
> +               ret = -EINVAL;
> +               goto exit_unlock;
> +       }
> +
> +       w = f->fmt.pix.width;
> +       h = f->fmt.pix.height;
> +
> +       dprintk(1, "sensor name %s: before w = %d, h = %d",
> +               isp->sensor_curr->name, w, h);
> +
> +       ret = v4l2_subdev_call(isp->sensor_curr, video, try_fmt, f);

Note: I'm working on adding support for the new mediabus API in the video ops
of subdevices. This will replace the current enum/try/g/s_fmt functions.

So this will likely impact this code as well.

> +       if (ret)
> +               goto exit_unlock;
> +
> +
> +       w = f->fmt.pix.width;
> +       h = f->fmt.pix.height;
> +
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
> +               if (w < INTEL_MIN_WIDTH)
> +                       w = INTEL_MIN_WIDTH;
> +               if (w > INTEL_MAX_WIDTH_MP)
> +                       w = INTEL_MAX_WIDTH_MP;
> +               if (h < INTEL_MIN_HEIGHT)
> +                       h = INTEL_MIN_HEIGHT;
> +               if (h > INTEL_MAX_HEIGHT_MP)
> +                       h = INTEL_MAX_HEIGHT_MP;
> +               f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
> +       }
> +
> +       f->fmt.pix.width = w;
> +       f->fmt.pix.height = h;
> +
> +       f->fmt.pix.field = V4L2_FIELD_NONE;
> +       f->fmt.pix.bytesperline = (w * h)/8;
> +       if (fmt)
> +               f->fmt.pix.sizeimage = (w * h * fmt->depth)/8;
> +       if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_JPEG)
> +               f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
> +       f->fmt.pix.priv = 0;
> +
> +       dprintk(3, "after w = %d, h = %d", w, h);
> +       ret = 0;
> +
> +exit_unlock:
> +       mutex_unlock(&isp->mutex);
> +
> +       DBG_leaving;
> +       return ret;
> +}
> +
> +static int mrst_isp_s_fmt_cap(struct file *file, void *priv,
> +                                       struct v4l2_format *f)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(dev);
> +       struct intel_fmt *fmt;
> +       int ret;
> +       unsigned int width_o, height_o;
> +       unsigned short width_sensor, height_sensor;
> +       unsigned int w, h;
> +
> +       WARN_ON(priv != file->private_data);
> +
> +       mipi_flag = 1;
> +
> +       w = f->fmt.pix.width;
> +       h = f->fmt.pix.height;
> +
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
> +               if (w < INTEL_MIN_WIDTH)
> +                       w = INTEL_MIN_WIDTH;
> +               if (w > INTEL_MAX_WIDTH_MP)
> +                       w = INTEL_MAX_WIDTH_MP;
> +               if (h < INTEL_MIN_HEIGHT)
> +                       h = INTEL_MIN_HEIGHT;
> +               if (h > INTEL_MAX_HEIGHT_MP)
> +                       h = INTEL_MAX_HEIGHT_MP;
> +               f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
> +       }
> +
> +       f->fmt.pix.width = w;
> +       f->fmt.pix.height = h;
> +
> +       width_o = f->fmt.pix.width;
> +       height_o = f->fmt.pix.height;
> +
> +       (void)ci_sensor_res2size(to_sensor_config(isp->sensor_curr)->res,
> +                                &width_sensor, &height_sensor);
> +
> +       ret = mrst_isp_try_fmt_cap(file, priv, f);
> +       if (0 != ret) {
> +               printk(KERN_ERR "mrstisp: set format failed\n");
> +               return ret;
> +       }
> +
> +       /* set fmt for only sensor */
> +       if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_MPEG) {
> +               ret = v4l2_subdev_call(isp->sensor_curr, video, s_fmt, f);
> +               dprintk(1, "set fmt only for sensor (%d x %d)",
> +                       f->fmt.pix.width, f->fmt.pix.height);
> +               return ret;
> +       }
> +
> +       if (isp->sys_conf.isp_hal_enable) {
> +               /* set fmt for isp */
> +               mutex_lock(&isp->mutex);
> +               fmt = fmt_by_fourcc(f->fmt.pix.pixelformat);
> +
> +               isp->pixelformat = fmt->fourcc;
> +               isp->depth = fmt->depth;
> +
> +               dprintk(1, "sensor (%d x %d)", width_sensor, height_sensor);
> +               if (width_o < f->fmt.pix.width &&
> +                   height_o < f->fmt.pix.height) {
> +                       isp->bufwidth = width_o;
> +                       isp->bufheight = height_o;
> +               } else if (width_sensor < f->fmt.pix.width &&
> +                          height_sensor < f->fmt.pix.height) {
> +                       isp->bufwidth = width_sensor;
> +                       isp->bufheight = height_sensor;
> +                       f->fmt.pix.width = width_sensor;
> +                       f->fmt.pix.height = height_sensor;
> +               } else {
> +                       isp->bufwidth = f->fmt.pix.width;
> +                       isp->bufheight = f->fmt.pix.height;
> +               }
> +
> +               if (to_sensor_config(isp->sensor_curr)->res ==
> +                               SENSOR_RES_VGA_PLUS)
> +                       if (isp->bufwidth >= VGA_SIZE_H &&
> +                                       isp->bufheight >= VGA_SIZE_V) {
> +                               isp->bufwidth = VGA_SIZE_H;
> +                               isp->bufheight = VGA_SIZE_V;
> +                       }
> +
> +               mutex_unlock(&isp->mutex);
> +
> +               dprintk(1, "set fmt only to isp: w %d, h%d, "
> +                       "fourcc: %lx", isp->bufwidth,
> +                       isp->bufheight, fmt->fourcc);
> +       } else {
> +
> +               /* set fmt for both isp and sensor */
> +               mutex_lock(&isp->mutex);
> +               fmt = fmt_by_fourcc(f->fmt.pix.pixelformat);
> +
> +               isp->pixelformat = fmt->fourcc;
> +               isp->depth = fmt->depth;
> +               isp->bufwidth = width_o;
> +               isp->bufheight = height_o;
> +
> +               mutex_unlock(&isp->mutex);
> +
> +               dprintk(1, "set fmt for isp : w%d, h%d, fourcc: %lx",
> +                       isp->bufwidth, isp->bufheight, fmt->fourcc);
> +               dprintk(1, "set fmt for sesnro : w%d, h%d, fourcc: %lx",
> +                       f->fmt.pix.width, f->fmt.pix.height, fmt->fourcc);
> +
> +               ret = v4l2_subdev_call(isp->sensor_curr, video, s_fmt, f);
> +       }
> +
> +       return ret;
> +}
> +
> +static int mrst_isp_enum_framesizes(struct file *file, void *priv,
> +                                   struct v4l2_frmsizeenum *arg)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(dev);
> +       int ret;
> +
> +       WARN_ON(priv != file->private_data);
> +       ret = v4l2_subdev_call(isp->sensor_curr, video, enum_framesizes, arg);
> +       return ret;
> +}
> +
> +static int mrst_isp_enum_frameintervals(struct file *file, void *priv,
> +                                       struct v4l2_frmivalenum *arg)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(dev);
> +       int ret;
> +
> +       WARN_ON(priv != file->private_data);
> +
> +       ret = v4l2_subdev_call(isp->sensor_curr, video, enum_frameintervals,
> +                              arg);
> +       return ret;
> +}
> +
> +static int mrst_isp_queryctrl(struct file *file, void *priv,
> +       struct v4l2_queryctrl *c)
> +{
> +       struct video_device *vdev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(vdev);
> +
> +       WARN_ON(priv != file->private_data);
> +
> +       if (!v4l2_subdev_call(isp->sensor_curr, core, queryctrl, c))
> +               return 0;
> +       else if (!v4l2_subdev_call(isp->motor, core, queryctrl, c))
> +               return 0;
> +
> +       return -EINVAL;
> +}
> +
> +static int mrst_isp_g_ctrl(struct file *file, void *priv,
> +                          struct v4l2_control *c)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(dev);
> +       int ret;
> +
> +       WARN_ON(priv != file->private_data);
> +
> +       if (c->id == V4L2_CID_FOCUS_ABSOLUTE) {
> +               ret = v4l2_subdev_call(isp->motor, core, g_ctrl, c);
> +               dprintk(2, "get focus from motor : %d", c->value);
> +               return ret;
> +       } else {
> +               ret = v4l2_subdev_call(isp->sensor_curr, core, g_ctrl, c);
> +               dprintk(2, "get other cotrol from senrsor : %d", c->value);
> +               return ret;
> +       }
> +}
> +
> +static int mrst_isp_s_ctrl(struct file *file, void *fh, struct v4l2_control *c)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(dev);
> +
> +       if (c->id == V4L2_CID_FOCUS_ABSOLUTE) {
> +               dprintk(2, "setting focus %d to motor", c->value);
> +               return v4l2_subdev_call(isp->motor, core, s_ctrl, c);
> +       } else {
> +               dprintk(2, "setting other ctrls, value = %d", c->value);
> +               return v4l2_subdev_call(isp->sensor_curr, core, s_ctrl, c);
> +       }
> +}
> +
> +static int mrst_isp_index_to_camera(struct mrst_isp_device *isp, u32 index)
> +{
> +       int camera = MRST_CAMERA_NONE;
> +
> +       if (isp->sensor_soc && isp->sensor_raw) {
> +               switch (index) {
> +               case 0:
> +                       camera = isp->sensor_soc_index;
> +                       break;
> +               case 1:
> +                       camera = isp->sensor_raw_index;
> +                       break;
> +               }
> +       } else if (isp->sensor_soc) {
> +               switch (index) {
> +               case 0:
> +                       camera = isp->sensor_soc_index;
> +                       break;
> +               }
> +       } else if (isp->sensor_raw) {
> +               switch (index) {
> +               case 0:
> +                       camera = isp->sensor_raw_index;
> +                       break;
> +               }
> +       }
> +
> +       return camera;
> +}
> +
> +static int mrst_isp_enum_input(struct file *file, void *priv,
> +                           struct v4l2_input *i)
> +{
> +       struct video_device *vdev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(vdev);
> +       int camera;
> +
> +       WARN_ON(priv != file->private_data);
> +
> +       camera = mrst_isp_index_to_camera(isp, i->index);
> +       if (MRST_CAMERA_NONE == camera)
> +               return -EINVAL;
> +
> +       i->type = V4L2_INPUT_TYPE_CAMERA;
> +       i->std = V4L2_STD_UNKNOWN;
> +       strcpy(i->name, mrst_camera_table[camera].name);

Use strlcpy.

> +
> +       return 0;
> +}
> +
> +static int mrst_isp_g_input(struct file *file, void *priv, unsigned int *i)
> +{
> +       struct video_device *vdev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(vdev);
> +
> +       WARN_ON(priv != file->private_data);
> +
> +       if (isp->sensor_soc && isp->sensor_raw)
> +               if (isp->sensor_curr == isp->sensor_soc)
> +                       *i = 0;
> +               else
> +                       *i = 1;
> +       else
> +               *i = 0;
> +
> +       return 0;
> +}
> +
> +static int mrst_isp_s_input(struct file *file, void *priv, unsigned int i)
> +{
> +       struct video_device *vdev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(vdev);
> +
> +       int camera;
> +
> +       if (isp->streaming) {
> +               printk(KERN_WARNING "VIDIOC_S_INPUT error: ISP is streaming\n");
> +               return -EBUSY;
> +       }
> +
> +       camera = mrst_isp_index_to_camera(isp, i);
> +       if (MRST_CAMERA_NONE == camera)
> +               return -EINVAL;
> +
> +       if (mrst_camera_table[camera].type == MRST_CAMERA_SOC)
> +               isp->sensor_curr = isp->sensor_soc;
> +       else
> +               isp->sensor_curr = isp->sensor_raw;
> +
> +       dprintk(1, "set sensor %s as input", isp->sensor_curr->name);
> +
> +       return 0;
> +}
> +
> +static int mrst_isp_g_ext_ctrls(struct file *file,
> +                            void *fh,
> +                            struct v4l2_ext_controls *c)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(dev);
> +
> +       int ret = -EINVAL;
> +
> +       if (c->ctrl_class != V4L2_CTRL_CLASS_CAMERA) {
> +               printk(KERN_ERR "Invalid control class\n");
> +               return ret;
> +       }
> +
> +       c->error_idx = 0;
> +       if (isp->motor) {
> +               ret = v4l2_subdev_call(isp->motor, core, g_ext_ctrls, c);
> +               if (c->error_idx) {
> +                       printk(KERN_ERR "mrst: error call g_ext_ctrls\n");
> +                       return ret;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +static int mrst_isp_s_ext_ctrls(struct file *file, void *fh,
> +                            struct v4l2_ext_controls *c)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(dev);
> +
> +       int ret = -EINVAL;
> +
> +       if (c->ctrl_class != V4L2_CTRL_CLASS_CAMERA) {
> +               printk(KERN_INFO "Invalid control class\n");
> +               return ret;
> +       }
> +
> +       c->error_idx = 0;
> +       if (isp->motor) {
> +               ret = v4l2_subdev_call(isp->motor, core, s_ext_ctrls, c);
> +               if (c->error_idx) {
> +                       printk(KERN_ERR "mrst: error call s_ext_ctrls\n");
> +                       return ret;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +static int mrst_isp_s_std(struct file *filp, void *priv, v4l2_std_id *a)
> +{
> +       return 0;
> +}

Why implement this?

> +
> +static int mrst_isp_querycap(struct file *file, void  *priv,
> +       struct v4l2_capability *cap)
> +{
> +       struct video_device *dev = video_devdata(file);
> +
> +       strlcpy(cap->driver, DRIVER_NAME, sizeof(cap->driver));
> +       strlcpy(cap->card, dev->name, sizeof(cap->card));
> +
> +       cap->version = INTEL_VERSION(0, 5, 0);
> +       cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +       return 0;
> +}
> +
> +static int mrst_isp_cropcap(struct file *file, void *priv,
> +                                       struct v4l2_cropcap *cap)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(dev);
> +
> +       WARN_ON(priv != file->private_data);
> +
> +       if (cap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +               return -EINVAL;
> +
> +       cap->bounds.left = 0;
> +       cap->bounds.top = 0;
> +       cap->bounds.width = isp->bufwidth;
> +       cap->bounds.height = isp->bufheight;
> +       cap->defrect = cap->bounds;
> +       cap->pixelaspect.numerator   = 1;
> +       cap->pixelaspect.denominator = 1;
> +
> +       return 0;
> +}
> +
> +static int mrst_isp_enum_fmt_cap(struct file *file, void  *priv,
> +                                       struct v4l2_fmtdesc *f)
> +{
> +       struct video_device *dev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(dev);
> +
> +       unsigned int index;
> +
> +       index = f->index;
> +
> +       if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +               return -EINVAL;
> +       else {

No 'else' needed.

> +               if (isp->sensor_curr == isp->sensor_soc)
> +                       if (index >= 8)
> +                               return -EINVAL;
> +               if (index >= sizeof(fmts) / sizeof(*fmts))
> +                       return -EINVAL;
> +
> +               f->index = index;
> +               f->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +               strlcpy(f->description, fmts[index].name,
> +                       sizeof(f->description));
> +               f->pixelformat = fmts[index].fourcc;
> +               if (fmts[index].fourcc == V4L2_PIX_FMT_JPEG)
> +                       f->flags = V4L2_FMT_FLAG_COMPRESSED;
> +       }
> +
> +       return 0;
> +
> +}
> +
> +#define ALIGN4(x)       ((((long)(x)) & 0x3) == 0)
> +
> +static int mrst_isp_reqbufs(struct file *file, void *priv,
> +               struct v4l2_requestbuffers *req)
> +{
> +       int ret;
> +       struct mrst_isp_fh  *fh = file->private_data;
> +       struct video_device *dev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(dev);
> +
> +       WARN_ON(priv != file->private_data);
> +
> +       if (req->count == 0)
> +               return 0;
> +
> +       if (req->memory != V4L2_MEMORY_MMAP) {
> +               eprintk("wrong memory type");
> +               return -EINVAL;
> +       }
> +       ret = videobuf_reqbufs(&fh->vb_q, req);
> +       if (ret)
> +               eprintk("err calling videobuf_reqbufs ret = %d", ret);
> +
> +       if (!ret)
> +               isp->buffer_required = 1;
> +
> +       return ret;
> +}
> +
> +static int mrst_isp_querybuf(struct file *file, void *priv,
> +                                       struct v4l2_buffer *buf)
> +{
> +       int ret;
> +       struct mrst_isp_fh  *fh = file->private_data;
> +
> +       WARN_ON(priv != file->private_data);
> +
> +       ret = videobuf_querybuf(&fh->vb_q, buf);
> +       return ret;
> +}
> +
> +static int mrst_isp_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> +{
> +       int ret;
> +       struct mrst_isp_fh  *fh = file->private_data;
> +
> +       WARN_ON(priv != file->private_data);
> +
> +       ret = videobuf_qbuf(&fh->vb_q, buf);
> +       /* identify which video buffer was q-ed */
> +       if (ret == 0)
> +               fh->qbuf_flag |= (1<<buf->index);
> +       dprintk(1, "q-ed index = %d", buf->index);
> +
> +       return ret;
> +}
> +
> +static int mrst_isp_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
> +{
> +       int ret;
> +       struct mrst_isp_fh  *fh = file->private_data;
> +
> +       WARN_ON(priv != file->private_data);
> +
> +       if (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +               return -EINVAL;
> +       if (b->memory != V4L2_MEMORY_MMAP)
> +               return -EINVAL;
> +       if (fh->qbuf_flag == 0) {
> +               dprintk(1, "no buffer can be dq-ed\n");
> +               return -EINVAL;
> +       }
> +
> +       ret = videobuf_dqbuf(&fh->vb_q, b, 0);
> +       if (ret == 0)
> +               fh->qbuf_flag &= ~(1<<b->index);
> +
> +       ++frame_cnt;
> +
> +       dprintk(1, "dq-ed index = %d", b->index);
> +       return ret;
> +}
> +
> +static int mrst_isp_streamon(struct file *file, void *priv,
> +                            enum v4l2_buf_type type)
> +{
> +       struct mrst_isp_fh  *fh = file->private_data;
> +       struct video_device *dev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(dev);
> +       int ret;
> +
> +       if (!isp->buffer_required) {
> +               eprintk("buffer is not required, can not stream on ");
> +               return -EINVAL;
> +       }
> +
> +       dprintk(2, "gamma2 = %d", isp->sys_conf.isp_cfg.flags.gamma2);
> +       WARN_ON(priv != file->private_data);
> +
> +       if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +               return -EINVAL;
> +
> +       mutex_lock(&isp->mutex);
> +
> +       v4l2_subdev_call(isp->sensor_curr, video, s_stream, 1);
> +
> +       mrst_isp_dp_init(&isp->sys_conf, to_sensor_config(isp->sensor_curr));
> +       mrst_isp_setup_viewfinder_path(isp,
> +                                      to_sensor_config(isp->sensor_curr), -1);
> +
> +       ret = videobuf_streamon(&fh->vb_q);
> +       isp->streaming = 1;
> +
> +       mutex_unlock(&isp->mutex);
> +
> +       dprintk(1, "isp->active = %p", isp->active);
> +       return ret;
> +}
> +
> +static int mrst_isp_streamoff(struct file *file, void *priv,
> +                             enum v4l2_buf_type type)
> +{
> +       struct mrst_isp_fh  *fh = file->private_data;
> +       struct video_device *dev = video_devdata(file);
> +       struct mrst_isp_device *isp = video_get_drvdata(dev);
> +
> +       unsigned long flags;
> +       int ret;
> +
> +       WARN_ON(priv != file->private_data);
> +
> +       if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +               return -EINVAL;
> +
> +       mutex_lock(&isp->mutex);
> +
> +       ret = videobuf_streamoff(&fh->vb_q);
> +       dprintk(1, "ret of videobuf_streamoff = %d", ret);
> +       isp->streaming = 0;
> +
> +       spin_lock_irqsave(&isp->lock, flags);
> +       INIT_LIST_HEAD(&isp->capture);
> +       isp->active = NULL;
> +       isp->next = NULL;
> +       isp->sys_conf.isp_hal_enable = 0;
> +       isp->sys_conf.jpg_review_enable = 0;
> +       isp->sys_conf.isp_cfg.img_eff_cfg.mode = CI_ISP_IE_MODE_OFF;
> +       isp->sys_conf.isp_cfg.jpeg_enc_ratio = 1;
> +
> +       spin_unlock_irqrestore(&isp->lock, flags);
> +
> +       ci_isp_stop(CI_ISP_CFG_UPDATE_FRAME_SYNC);
> +       v4l2_subdev_call(isp->sensor_curr, video, s_stream, 0);
> +
> +       mutex_unlock(&isp->mutex);
> +       return ret;
> +}
> +
> +static const struct v4l2_file_operations mrst_isp_fops = {
> +       .owner = THIS_MODULE,
> +       .open = mrst_isp_open,
> +       .release = mrst_isp_close,
> +       .read = mrst_isp_read,
> +       .mmap = mrst_isp_mmap,
> +       .ioctl = video_ioctl2,
> +};
> +
> +static const struct v4l2_ioctl_ops mrst_isp_ioctl_ops = {
> +       .vidioc_querycap                = mrst_isp_querycap,
> +       .vidioc_enum_fmt_vid_cap        = mrst_isp_enum_fmt_cap,
> +       .vidioc_g_fmt_vid_cap           = mrst_isp_g_fmt_cap,
> +       .vidioc_try_fmt_vid_cap         = mrst_isp_try_fmt_cap,
> +       .vidioc_s_fmt_vid_cap           = mrst_isp_s_fmt_cap,
> +       .vidioc_cropcap                 = mrst_isp_cropcap,
> +       .vidioc_reqbufs                 = mrst_isp_reqbufs,
> +       .vidioc_querybuf                = mrst_isp_querybuf,
> +       .vidioc_qbuf                    = mrst_isp_qbuf,
> +       .vidioc_dqbuf                   = mrst_isp_dqbuf,
> +       .vidioc_enum_input              = mrst_isp_enum_input,
> +       .vidioc_g_input                 = mrst_isp_g_input,
> +       .vidioc_s_input                 = mrst_isp_s_input,
> +       .vidioc_s_std                   = mrst_isp_s_std,
> +       .vidioc_queryctrl               = mrst_isp_queryctrl,
> +       .vidioc_streamon                = mrst_isp_streamon,
> +       .vidioc_streamoff               = mrst_isp_streamoff,
> +       .vidioc_g_ctrl                  = mrst_isp_g_ctrl,
> +       .vidioc_s_ctrl                  = mrst_isp_s_ctrl,
> +       .vidioc_enum_framesizes         = mrst_isp_enum_framesizes,
> +       .vidioc_enum_frameintervals     = mrst_isp_enum_frameintervals,
> +       .vidioc_g_ext_ctrls             = mrst_isp_g_ext_ctrls,
> +       .vidioc_s_ext_ctrls             = mrst_isp_s_ext_ctrls,
> +       /* fixme: private ioctls */
> +       .vidioc_default                 = mrst_isp_vidioc_default,
> +};
> +
> +static struct video_device mrst_isp_vdev = {
> +       .name                           = "mrst_isp",
> +       .minor                          = -1,
> +       .fops                           = &mrst_isp_fops,
> +       .ioctl_ops                      = &mrst_isp_ioctl_ops,
> +       .release                        = video_device_release_empty,
> +};
> +
> +static int mrst_ci_sensor_probe(struct mrst_isp_device *isp)
> +{
> +       struct v4l2_subdev *sensor = NULL, *motor = NULL;
> +       int i;
> +       char *name;
> +       u8 addr;
> +
> +       isp->adapter_sensor = i2c_get_adapter(MRST_I2C_BUS_SENSOR);
> +       if (NULL == isp->adapter_sensor) {
> +               printk(KERN_ERR "mrstisp: no sensor i2c adapter\n");
> +               return -ENODEV;
> +       }
> +
> +       dprintk(1, "got sensor i2c adapter: %s", isp->adapter_sensor->name);
> +
> +       gpio_request(GPIO_STDBY1_PIN, "Sensor Standby1");
> +       gpio_request(GPIO_STDBY2_PIN, "Sensor Standby2");
> +       gpio_request(GPIO_RESET_PIN, "Sensor Reset");
> +       gpio_request(GPIO_SCLK_25, "Sensor clock");
> +       gpio_request(95, "Camera Motor");
> +
> +       /* Enable sensor related GPIO in system */
> +       gpio_direction_output(GPIO_STDBY1_PIN, 0);
> +       gpio_direction_output(GPIO_STDBY2_PIN, 0);
> +       gpio_direction_output(GPIO_RESET_PIN, 1);
> +       gpio_direction_output(GPIO_SCLK_25, 0);
> +
> +       for (i = 0; i < N_CAMERA; i++) {
> +               name = mrst_camera_table[i].name;
> +               addr = mrst_camera_table[i].sensor_addr;
> +               if (mrst_camera_table[i].type == MRST_CAMERA_SOC) {
> +#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 31))
> +                       sensor = v4l2_i2c_new_subdev(&isp->v4l2_dev,
> +                                                    isp->adapter_sensor,
> +                                                    name, name, addr);
> +#else
> +                       sensor = v4l2_i2c_new_subdev(&isp->v4l2_dev,
> +                                                    isp->adapter_sensor,
> +                                                    name, name, addr, NULL);
> +#endif
> +                       if (sensor == NULL) {
> +                               dprintk(2, "sensor %s not found", name);
> +                               continue;
> +                       }
> +                       isp->sensor_soc = sensor;
> +                       isp->sensor_soc_index = i;
> +                       dprintk(0, "soc camera sensor %s-%s successfully found",
> +                               name, sensor->name);
> +               }
> +
> +               if (mrst_camera_table[i].type == MRST_CAMERA_RAW) {
> +#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 31))
> +                       sensor = v4l2_i2c_new_subdev(&isp->v4l2_dev,
> +                                                    isp->adapter_sensor,
> +                                                    name, name, addr);
> +#else
> +                       sensor = v4l2_i2c_new_subdev(&isp->v4l2_dev,
> +                                                    isp->adapter_sensor,
> +                                                    name, name, addr, NULL);
> +#endif
> +
> +                       if (sensor == NULL) {
> +                               dprintk(2, "sensor %s not found", name);
> +                               continue;
> +                       }
> +                       isp->sensor_raw = sensor;
> +                       isp->sensor_raw_index = i;
> +                       dprintk(0, "raw camera sensor %s successfully found",
> +                               name);
> +                       name = mrst_camera_table[i].motor_name;
> +                       addr = mrst_camera_table[i].motor_addr;
> +
> +#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 31))
> +                       motor = v4l2_i2c_new_subdev(&isp->v4l2_dev,
> +                                                   isp->adapter_sensor,
> +                                                   name, name, addr);
> +#else
> +                       motor = v4l2_i2c_new_subdev(&isp->v4l2_dev,
> +                                                   isp->adapter_sensor,
> +                                                   name, name, addr, NULL);
> +#endif
> +
> +                       if (motor == NULL)
> +                               dprintk(2, "motor %s not found", name);
> +                       else {
> +                               isp->motor = motor;
> +                               dprintk(0, "motor %s successfully found", name);
> +                       }
> +               }
> +       }
> +
> +       if (!isp->sensor_soc && !isp->sensor_raw) {
> +               dprintk(0, "no camera sensor device attached");
> +               return -ENODEV;
> +       } else {
> +               if (isp->sensor_soc)
> +                       isp->sensor_curr = isp->sensor_soc;
> +               else
> +                       isp->sensor_curr = isp->sensor_raw;
> +               return 0;
> +       }
> +}
> +
> +static int mrst_ci_flash_probe(struct mrst_isp_device *isp)
> +{
> +       struct v4l2_subdev *flash = NULL;
> +       char *name = "mrst_camera_flash";
> +
> +       gpio_request(45, "Camera Flash");
> +       gpio_direction_output(45, 0);
> +
> +       isp->adapter_flash = i2c_get_adapter(MRST_I2C_BUS_FLASH);
> +       if (NULL == isp->adapter_flash) {
> +               dprintk(0, "no flash i2c adapter\n");
> +               return -ENODEV;
> +       }
> +
> +       dprintk(1, "got flash i2c adapter: %s", isp->adapter_flash->name);
> +
> +#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 31))
> +       flash = v4l2_i2c_new_subdev(&isp->v4l2_dev,
> +                                   isp->adapter_flash,
> +                                   name, name, 0x53);
> +#else
> +       flash = v4l2_i2c_new_subdev(&isp->v4l2_dev,
> +                                   isp->adapter_flash,
> +                                   name, name, 0x53, NULL);
> +#endif
> +
> +       if (flash == NULL) {
> +               dprintk(0, "no flash IC found\n");
> +               return -ENODEV;
> +       }
> +
> +       dprintk(0, "flash IC found");
> +       return 0;
> +}
> +
> +static irqreturn_t mrst_isp_irq_handler(int this_irq, void *dev_id)
> +{
> +       struct isp_register *mrv_reg =
> +           (struct isp_register *) MEM_MRV_REG_BASE;
> +       struct mrst_isp_device *isp = dev_id;
> +       struct videobuf_buffer *vb;
> +       unsigned long flags;
> +
> +       u32     mi_mask = ci_isp_get_frame_end_irq_mask_isp();
> +       u32     isp_mask = MRV_ISP_RIS_DATA_LOSS_MASK
> +           | MRV_ISP_RIS_PIC_SIZE_ERR_MASK;
> +       u32     jpe_status_mask = MRV_JPE_ALL_STAT_MASK;
> +       u32     jpe_error_mask = MRV_JPE_ALL_ERR_MASK;
> +       u32     mblk_line_mask = MRV_MI_MBLK_LINE_MASK;
> +
> +       u32     isp_irq;
> +       u32     mi_irq;
> +       u32     jpe_status_irq;
> +       u32     jpe_error_irq;
> +       u32     mipi_irq;
> +       u32     mblk_line;
> +       u32     bufbase;
> +
> +       isp_irq = REG_READ_EX(mrv_reg->isp_ris) & isp_mask;
> +       mi_irq = REG_READ_EX(mrv_reg->mi_ris) & mi_mask;
> +
> +       mblk_line = REG_READ_EX(mrv_reg->mi_ris) & mblk_line_mask;
> +
> +       jpe_status_irq = REG_READ_EX(mrv_reg->jpe_status_ris) & jpe_status_mask;
> +       jpe_error_irq = REG_READ_EX(mrv_reg->jpe_error_ris) & jpe_error_mask;
> +
> +       mipi_irq = REG_READ_EX(mrv_reg->mipi_ris) & 0x00f00000;
> +
> +       dprintk(3, "IRQ: mblk_line = %x, mi_irq = %x, jpe_status_irq = %x,"
> +               " jpe_error_irq = %x, isp_irq = %x", mblk_line, mi_irq,
> +               jpe_status_irq, jpe_error_irq, isp_irq);
> +
> +       if (!(isp_irq | mi_irq | jpe_status_irq | jpe_error_irq | mblk_line
> +             | mipi_irq)) {
> +               dprintk(2, "unknown interrupt");
> +               return IRQ_HANDLED;
> +       }
> +
> +       REG_SET_SLICE_EX(mrv_reg->isp_icr, MRV_ISP_ICR_ALL, ON);
> +       REG_SET_SLICE_EX(mrv_reg->mi_icr, MRV_MI_ALLIRQS, ON);
> +       REG_SET_SLICE_EX(mrv_reg->jpe_error_icr, MRV_JPE_ALL_ERR, ON);
> +       REG_SET_SLICE_EX(mrv_reg->jpe_status_icr, MRV_JPE_ALL_STAT, ON);
> +       REG_WRITE_EX(mrv_reg->mipi_icr, 0xffffffff);
> +
> +       if (isp_irq) {
> +               /* Currently we don't reset hardware even error detect */
> +               dprintk(3, "ISP error IRQ received %x", isp_irq);
> +               isp_error_num++;
> +               isp_error_flag |= isp_irq;
> +               return IRQ_HANDLED;
> +       }
> +
> +       if (mipi_irq) {
> +               dprintk(3, "error in mipi_irq %x", mipi_irq);
> +               mipi_error_num++;
> +               mipi_error_flag |= mipi_irq;
> +               return IRQ_HANDLED;
> +       }
> +
> +       if (mblk_line && mrst_isp_to_do_mblk_line) {
> +               REG_SET_SLICE(mrv_reg->mi_imsc, MRV_MI_MBLK_LINE, OFF);
> +               dprintk(3, "enter mblk_line irq");
> +
> +               if (!(isp->active && !isp->next)) {
> +                       dprintk(3, "wrong isq status");
> +                       if (isp->active)
> +                               dprintk(2, "actie->i = %d", isp->active->i);
> +                       else
> +                               dprintk(2, "actie = NULL");
> +                       if (isp->next)
> +                               dprintk(2, "next->i = %d", isp->next->i);
> +                       else
> +                               dprintk(2, "next = NULL");
> +                       return IRQ_HANDLED;
> +               }
> +
> +               spin_lock_irqsave(&isp->lock, flags);
> +
> +               if (!list_empty(&isp->capture)) {
> +                       isp->next = list_entry(isp->capture.next,
> +                                              struct videobuf_buffer, queue);
> +                       isp->next->state = VIDEOBUF_ACTIVE;
> +                       bufbase = videobuf_to_dma_contig(isp->next);
> +                       mrst_isp_update_marvinvfaddr(isp, bufbase,
> +                                            CI_ISP_CFG_UPDATE_FRAME_SYNC);
> +                       dprintk(1, "updating new addr, next = %d",
> +                               isp->next->i);
> +               } else {
> +                       ci_isp_stop(CI_ISP_CFG_UPDATE_FRAME_SYNC);
> +                       dprintk(0, "stop isp");
> +               }
> +
> +               mrst_isp_to_do_mblk_line = 0;
> +
> +               spin_unlock_irqrestore(&isp->lock, flags);
> +
> +       }
> +
> +       if (mi_irq && isp->pixelformat != V4L2_PIX_FMT_JPEG &&
> +           !jpe_status_irq) {
> +               dprintk(1, "view finding case");
> +
> +               if (!isp->active) {
> +                       dprintk(0, "no active queue, You should not go here");
> +                       ci_isp_stop(CI_ISP_CFG_UPDATE_IMMEDIATE);
> +                       return IRQ_HANDLED;
> +               }
> +
> +               spin_lock_irqsave(&isp->lock, flags);
> +
> +               /* update captured frame status */
> +               vb = isp->active;
> +               dprintk(1, "buf %d size = %lx", vb->i, vb->size);
> +               vb->state = VIDEOBUF_DONE;
> +               do_gettimeofday(&vb->ts);
> +               vb->field_count++;
> +               wake_up(&vb->done);
> +               isp->active = NULL;
> +
> +               if (!isp->next) {
> +                       if (!list_empty(&isp->capture)) {
> +                               isp->active = list_entry(isp->capture.next,
> +                                                struct videobuf_buffer, queue);
> +                               list_del_init(&isp->active->queue);
> +                               isp->active->state = VIDEOBUF_ACTIVE;
> +                               mrst_ci_capture(isp);
> +                               dprintk(3, "start next frame %d",
> +                                       isp->active->i);
> +                               mrst_isp_to_do_mblk_line = 1;
> +                               REG_SET_SLICE(mrv_reg->mi_imsc,
> +                                             MRV_MI_MBLK_LINE, ON);
> +                       } else {
> +                               dprintk(3, "no frame right now");
> +                       }
> +               } else {
> +                       isp->active = isp->next;
> +                       list_del_init(&isp->next->queue);
> +                       isp->next = NULL;
> +                       dprintk(1, "active = next = %d, next = NULL",
> +                               isp->active->i);
> +                       mrst_isp_to_do_mblk_line = 1;
> +                       REG_SET_SLICE(mrv_reg->mi_imsc, MRV_MI_MBLK_LINE, ON);
> +               }
> +
> +               spin_unlock_irqrestore(&isp->lock, flags);
> +               return IRQ_HANDLED;
> +       }
> +
> +       if (jpe_status_irq) {
> +               dprintk(2, "jpeg capture case");
> +               if (!isp->active)
> +                       return IRQ_HANDLED;
> +
> +               spin_lock_irqsave(&isp->lock, flags);
> +
> +               vb = isp->active;
> +               vb->size = ci_isp_mif_get_byte_cnt();
> +               vb->state = VIDEOBUF_DONE;
> +               do_gettimeofday(&vb->ts);
> +               vb->field_count++;
> +               wake_up(&vb->done);
> +               isp->active = NULL;
> +
> +               dprintk(2, "index =%d, bufsize = %lx", vb->i, vb->size);
> +
> +               spin_unlock_irqrestore(&isp->lock, flags);
> +
> +               return IRQ_HANDLED;
> +       }
> +
> +       if (jpe_error_irq)
> +               dprintk(2, "entered jpe_error_irq");
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static void __devexit mrst_isp_pci_remove(struct pci_dev *pdev)
> +{
> +       struct v4l2_device *v4l2_dev = dev_get_drvdata(&pdev->dev);
> +       struct mrst_isp_device *isp = to_isp(v4l2_dev);
> +
> +       ci_isp_stop(CI_ISP_CFG_UPDATE_FRAME_SYNC);
> +       mrst_isp_disable_interrupt(isp);
> +
> +       free_irq(pdev->irq, isp);
> +
> +       if (isp->vdev) {
> +               dprintk(2, "isp->vdev = %p", isp->vdev);
> +               video_unregister_device(isp->vdev);
> +       }
> +
> +       dma_release_declared_memory(&pdev->dev);
> +       iounmap(isp->regs);
> +       pci_release_regions(pdev);
> +       pci_disable_device(pdev);
> +       v4l2_device_unregister(&isp->v4l2_dev);
> +       kfree(isp);
> +
> +}
> +
> +static int __devinit mrst_isp_pci_probe(struct pci_dev *pdev,
> +                                       const struct pci_device_id *pci_id)
> +{
> +       struct mrst_isp_device *isp;
> +       unsigned int start = 0;
> +       unsigned int len = 0;
> +       int ret = 0;
> +
> +       /* alloc device struct */
> +       isp = kzalloc(sizeof(struct mrst_isp_device), GFP_KERNEL);
> +       if (NULL == isp) {
> +               printk(KERN_ERR "mrstisp: fail to kzalloc mrst_isp_device\n");
> +               ret = -ENOMEM;
> +               goto exit;
> +       }
> +
> +       /* register v4l2 device */
> +       ret = v4l2_device_register(&pdev->dev, &isp->v4l2_dev);
> +       if (ret) {
> +               printk(KERN_ERR "mrstisp: fail to register v4l2 device\n");
> +               goto exit_free_isp;
> +       }
> +
> +       /* PCI operations */
> +       ret = pci_enable_device(pdev);
> +       if (ret) {
> +               printk(KERN_ERR "mrstisp: can't enable isp\n");
> +               goto exit_unregister_v4l2;
> +       }
> +
> +       pci_set_master(pdev);
> +
> +       ret = pci_request_regions(pdev, "mrst isp");
> +       if (ret) {
> +               printk(KERN_ERR "mrstisp: can't request regions\n");
> +               goto exit_disable_isp;
> +       }
> +
> +       /* mem bar 0 */
> +       start = isp->mb0 = pci_resource_start(pdev, 0);
> +       len = isp->mb0_size = pci_resource_len(pdev, 0);
> +
> +       isp->regs = ioremap_nocache(start, len);
> +       mrst_isp_regs = isp->regs;
> +       if (isp->regs == NULL) {
> +               printk(KERN_ERR "mrstisp: fail to ioremap isp registers\n");
> +               goto exit_release_regions;
> +       }
> +
> +       dprintk(1, "isp mb0 = %lx, mb0_size = %lx, regs = %p",
> +               isp->mb0, isp->mb0_size, isp->regs);
> +
> +       /* mem bar 1 */
> +       start = isp->mb1 = pci_resource_start(pdev, 1);
> +       len = isp->mb1_size = pci_resource_len(pdev, 1);
> +
> +       dprintk(1, "isp mb1 = %lx, mb1_size = %lx", isp->mb1, isp->mb1_size);
> +
> +       ret = dma_declare_coherent_memory(&pdev->dev, start,
> +                                         start, len,
> +                                         DMA_MEMORY_MAP);
> +       if (!ret) {
> +               dprintk(0, "failed to declare dma memory");
> +               ret = -ENXIO;
> +               goto exit_iounmap;
> +       }
> +
> +       /* init device struct */
> +       INIT_LIST_HEAD(&isp->capture);
> +       spin_lock_init(&isp->lock);
> +       mutex_init(&isp->mutex);
> +
> +       pci_read_config_word(pdev, PCI_VENDOR_ID, &isp->vendorID);
> +       pci_read_config_word(pdev, PCI_DEVICE_ID, &isp->deviceID);
> +
> +       mrst_isp_defcfg_all_load(&isp->sys_conf.isp_cfg);
> +
> +       isp->bufwidth = 640;
> +       isp->bufheight = 480;
> +       isp->depth = 12;
> +       isp->pixelformat = V4L2_PIX_FMT_YVU420;
> +       isp->streaming = 0;
> +       isp->buffer_required = 0;
> +
> +
> +       /* probe sensor */
> +       ret = mrst_ci_sensor_probe(isp);
> +       if (ret) {
> +               dprintk(0, "failed to sensor probe\n");
> +               goto exit_dma_release;
> +       }
> +
> +       /* regiter video device */
> +       isp->vdev = &mrst_isp_vdev;
> +       isp->vdev->parent = &pdev->dev;
> +       video_set_drvdata(isp->vdev, isp);
> +
> +       ret = video_register_device(isp->vdev, VFL_TYPE_GRABBER, -1);

Register the device as the very last thing. Apps can start to use it as soon
as this device node is created so you have to be sure that everything else is
working.

> +       if (ret) {
> +               dprintk(0, "fail to register video deivice");
> +               goto exit_dma_release;
> +       }
> +
> +       dprintk(0, "registered dev/video%d", isp->vdev->num);
> +       dprintk(0, "isp->vdev = %p", isp->vdev);
> +
> +#if IRQ
> +       /* request irq */
> +       ret = request_irq(pdev->irq, mrst_isp_irq_handler, IRQF_SHARED,
> +                         "mrst_camera_imaging", isp);
> +       if (ret) {
> +               dprintk(0, "fail to request irq");
> +               goto exit_unregister_video;
> +       }
> +
> +       mrst_isp_disable_interrupt(isp);
> +#endif
> +
> +       /* probe flash */
> +       mrst_ci_flash_probe(isp);
> +
> +       mrst_isp_to_do_mblk_line = 0;
> +
> +       dprintk(0, "mrstisp driver module successfully loaded");
> +       return 0;
> +
> +exit_unregister_video:
> +       video_unregister_device(isp->vdev);
> +exit_dma_release:
> +       dma_release_declared_memory(&pdev->dev);
> +exit_iounmap:
> +       iounmap(isp->regs);
> +exit_release_regions:
> +       pci_release_regions(pdev);
> +exit_disable_isp:
> +       pci_disable_device(pdev);
> +exit_unregister_v4l2:
> +       v4l2_device_unregister(&isp->v4l2_dev);
> +exit_free_isp:
> +       kfree(isp);
> +exit:
> +       return ret;
> +}
> +
> +#ifdef CONFIG_PM
> +static int mrst_isp_pci_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +       int ret;
> +
> +       ci_isp_off();
> +
> +       ret = pci_save_state(pdev);
> +       if (ret) {
> +               printk(KERN_ERR "mrstisp: pci_save_state failed %d\n", ret);
> +               return ret;
> +       }
> +
> +       ret = pci_set_power_state(pdev, PCI_D3cold);
> +       if (ret) {
> +               printk(KERN_ERR "mrstisp: fail to set power state\n");
> +               return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +static int mrst_isp_pci_resume(struct pci_dev *pdev)
> +{
> +       int ret;
> +       pci_set_power_state(pdev, PCI_D0);
> +       pci_restore_state(pdev);
> +
> +       ret = pci_enable_device(pdev);
> +       if (ret) {
> +               printk(KERN_ERR "mrstisp: fail to enable device in resume\n");
> +               return ret;
> +       }
> +
> +       ci_isp_init();
> +       return 0;
> +}
> +#endif
> +
> +static struct pci_device_id mrst_isp_pci_tbl[] __devinitdata = {
> +       { PCI_DEVICE(0x8086, 0x080B) },
> +       {0,}
> +};
> +
> +MODULE_DEVICE_TABLE(pci, mrst_isp_pci_tbl);
> +
> +static struct pci_driver mrst_isp_pci_driver = {
> +       .name = "mrstisp",
> +       .id_table = mrst_isp_pci_tbl,
> +       .probe = mrst_isp_pci_probe,
> +       .remove = mrst_isp_pci_remove,
> +       #ifdef CONFIG_PM
> +       .suspend = mrst_isp_pci_suspend,
> +       .resume = mrst_isp_pci_resume,
> +       #endif
> +};
> +
> +static int __init mrst_isp_pci_init(void)
> +{
> +       int ret;
> +       ret = pci_register_driver(&mrst_isp_pci_driver);
> +       if (ret) {
> +               printk(KERN_ERR "mrstisp: Unable to register driver\n");
> +               return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +static void __exit mrst_isp_pci_exit(void)
> +{
> +       pci_unregister_driver(&mrst_isp_pci_driver);
> +}
> +
> +module_init(mrst_isp_pci_init);
> +module_exit(mrst_isp_pci_exit);
> +
> +MODULE_DESCRIPTION("Intel Moorestown ISP driver");
> +MODULE_AUTHOR("Xiaolin Zhang <xiaolin.zhang@intel.com>");
> +MODULE_LICENSE("GPL");
> +MODULE_SUPPORTED_DEVICE("video");
> +
> --
> 1.6.3.2

Other than the dma_contig re-implementation this driver looks quite decent.
Good work!

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
