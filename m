Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1368 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab0EIObb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 May 2010 10:31:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
Subject: Re: [PATCH v2 1/10] V4L2 patches for Intel Moorestown Camera Imaging Drivers
Date: Sun, 9 May 2010 16:33:03 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Zhu, Daniel" <daniel.zhu@intel.com>,
	"Yu, Jinlu" <jinlu.yu@intel.com>,
	"Wang, Wen W" <wen.w.wang@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Hu, Gang A" <gang.a.hu@intel.com>,
	"Ba, Zheng" <zheng.ba@intel.com>
References: <33AB447FBD802F4E932063B962385B351D6D534B@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <33AB447FBD802F4E932063B962385B351D6D534B@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005091633.03109.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 28 March 2010 09:46:52 Zhang, Xiaolin wrote:
> From 7e2f1f0d8dff9051d234a69d73655c730ad1c16c Mon Sep 17 00:00:00 2001
> From: Xiaolin Zhang <xiaolin.zhang@intel.com>
> Date: Sun, 28 Mar 2010 13:44:05 +0800
> Subject: [PATCH 01/10] This patch is first part of the intel moorestown isp driver and header files collection
>  including register spec, frame formats, etc.
> 
> Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
> ---
>  drivers/media/video/mrstci/include/ci_isp_common.h |  937 ++++
>  .../video/mrstci/include/ci_isp_fmts_common.h      |  124 +
>  .../media/video/mrstci/include/ci_sensor_common.h  | 1157 +++++
>  drivers/media/video/mrstci/include/ci_va.h         |   46 +
>  .../media/video/mrstci/include/v4l2_jpg_review.h   |   47 +
>  drivers/media/video/mrstci/mrstisp/include/def.h   |  111 +
>  .../media/video/mrstci/mrstisp/include/mrstisp.h   |  245 ++
>  .../video/mrstci/mrstisp/include/mrstisp_dp.h      |  257 ++
>  .../video/mrstci/mrstisp/include/mrstisp_hw.h      |  176 +
>  .../video/mrstci/mrstisp/include/mrstisp_isp.h     |   42 +
>  .../video/mrstci/mrstisp/include/mrstisp_jpe.h     |  416 ++
>  .../video/mrstci/mrstisp/include/mrstisp_reg.h     | 4499 ++++++++++++++++++++
>  .../video/mrstci/mrstisp/include/mrstisp_stdinc.h  |  115 +
>  .../video/mrstci/mrstisp/include/reg_access.h      |  119 +
>  14 files changed, 8291 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/mrstci/include/ci_isp_common.h
>  create mode 100644 drivers/media/video/mrstci/include/ci_isp_fmts_common.h
>  create mode 100644 drivers/media/video/mrstci/include/ci_sensor_common.h
>  create mode 100644 drivers/media/video/mrstci/include/ci_va.h
>  create mode 100644 drivers/media/video/mrstci/include/v4l2_jpg_review.h
>  create mode 100644 drivers/media/video/mrstci/mrstisp/include/def.h
>  create mode 100644 drivers/media/video/mrstci/mrstisp/include/mrstisp.h
>  create mode 100644 drivers/media/video/mrstci/mrstisp/include/mrstisp_dp.h
>  create mode 100644 drivers/media/video/mrstci/mrstisp/include/mrstisp_hw.h
>  create mode 100644 drivers/media/video/mrstci/mrstisp/include/mrstisp_isp.h
>  create mode 100644 drivers/media/video/mrstci/mrstisp/include/mrstisp_jpe.h
>  create mode 100644 drivers/media/video/mrstci/mrstisp/include/mrstisp_reg.h
>  create mode 100644 drivers/media/video/mrstci/mrstisp/include/mrstisp_stdinc.h
>  create mode 100644 drivers/media/video/mrstci/mrstisp/include/reg_access.h
> 
> diff --git a/drivers/media/video/mrstci/include/ci_isp_common.h b/drivers/media/video/mrstci/include/ci_isp_common.h
> new file mode 100644
> index 0000000..83b5624
> --- /dev/null
> +++ b/drivers/media/video/mrstci/include/ci_isp_common.h
> @@ -0,0 +1,937 @@

<cut>

> +/* intel private ioctl code for ci isp hal interface */
> +#define BASE BASE_VIDIOC_PRIVATE
> +
> +#define VIDIOC_SET_SYS_CFG _IOWR('V', BASE + 1, struct ci_pl_system_config)

I think this is next to impossible to manage. The ci_pl_system_config struct is
huge. You really need to think about splitting this up into smaller chunks and
also think about how this can be done when we have subdev device nodes. Because
much that is here (or even everything) belongs in a subdev.

Video handling is very complex. The only way to manage it is to make sure that
the system comes up in a sensible state and then give the user the ability to
make changes to the various functionality blocks without having to configure
the whole system. Divide and conquer...

So if you have a demosaic block, then make ioctls that configure just this
block. Perhaps you might even want to implement it as a sub-device, depending
on the complexity.

> +#define VIDIOC_SET_JPG_ENC_RATIO _IOWR('V', BASE + 2, int)

Can VIDIOC_S_JPEGCOMP be used for this? It has a 'quality' argument which has
a similar meaning.

> +#define VIDIOC_GET_ISP_MEM_INFO _IOWR('V', BASE + 4, struct ci_isp_mem_info)

Huh? Returning the bar size/addresses? Seems dubious to me.

> +
> +/* buffer sharing with video subsystem */
> +#include "ci_va.h"
> +
> +/* support camera flash on CDK */
> +struct ci_isp_flash_cmd {
> +       int preflash_on;
> +       int flash_on;
> +       int prelight_on;
> +};
> +
> +struct ci_isp_flash_config {
> +       int prelight_off_at_end_of_flash;
> +       int vsync_edge_positive;
> +       int output_polarity_low_active;
> +       int use_external_trigger;
> +       u8 capture_delay;
> +};
> +#endif
> diff --git a/drivers/media/video/mrstci/include/ci_isp_fmts_common.h b/drivers/media/video/mrstci/include/ci_isp_fmts_common.h
> new file mode 100644
> index 0000000..b01d38f
> --- /dev/null
> +++ b/drivers/media/video/mrstci/include/ci_isp_fmts_common.h
> @@ -0,0 +1,124 @@
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
> +#ifndef _ISP_FMTS_COMMON_H
> +#define _ISP_FMTS_COMMON_H
> +
> +#define intel_fourcc(d, c, b, a) \
> +       (((__u32)(d)<<0)|((__u32)(c)<<8)|((__u32)(b)<<16)|((__u32)(a)<<24))
> +
> +/* bayer pattern formats support by ISP */
> +#define INTEL_PIX_FMT_RAW08  intel_fourcc('R', 'W', '0', '8')
> +#define INTEL_PIX_FMT_RAW10 intel_fourcc('R', 'W', '1', '0')
> +#define INTEL_PIX_FMT_RAW12  intel_fourcc('R', 'W', '1', '2')
> +
> +
> +/*
> + * various config and info structs concentrated into one struct
> + * for simplification
> + */
> +#define FORMAT_FLAGS_DITHER       0x01
> +#define FORMAT_FLAGS_PACKED       0x02
> +#define FORMAT_FLAGS_PLANAR       0x04
> +#define FORMAT_FLAGS_RAW          0x08
> +#define FORMAT_FLAGS_CrCb         0x10
> +
> +struct intel_fmt {
> +       char *name;
> +       unsigned long fourcc; /* v4l2 format id */
> +       int depth;
> +       int flags;
> +};
> +
> +static struct intel_fmt fmts[] = {
> +       {
> +       .name = "565 bpp RGB",
> +       .fourcc = V4L2_PIX_FMT_RGB565,
> +       .depth = 16,
> +       .flags = FORMAT_FLAGS_PACKED,
> +       },
> +       {
> +       .name = "888 bpp BGR",
> +       .fourcc = V4L2_PIX_FMT_BGR32,
> +       .depth = 32,
> +       .flags = FORMAT_FLAGS_PLANAR,
> +       },
> +       {
> +       .name = "4:2:2, packed, YUYV",
> +       .fourcc = V4L2_PIX_FMT_YUYV,
> +       .depth = 16,
> +       .flags = FORMAT_FLAGS_PACKED,
> +       },
> +       {
> +       .name = "4:2:2 planar, YUV422P",
> +       .fourcc = V4L2_PIX_FMT_YUV422P,
> +       .depth = 16,
> +       .flags = FORMAT_FLAGS_PLANAR,
> +       },
> +       {
> +       .name = "4:2:0 planar, YUV420",
> +       .fourcc = V4L2_PIX_FMT_YUV420,
> +       .depth = 12,
> +       .flags = FORMAT_FLAGS_PLANAR,
> +       },
> +       {
> +       .name = "4:2:0 planar, YVU420",
> +       .fourcc = V4L2_PIX_FMT_YVU420,
> +       .depth = 12,
> +       .flags = FORMAT_FLAGS_PLANAR,
> +       },
> +       {
> +       .name = "4:2:0 semi planar, NV12",
> +       .fourcc = V4L2_PIX_FMT_NV12,
> +       .depth = 12,
> +       .flags = FORMAT_FLAGS_PLANAR,
> +       },
> +       {
> +       .name = "Compressed format, JPEG",
> +       .fourcc = V4L2_PIX_FMT_JPEG,
> +       .depth = 12,
> +       .flags = FORMAT_FLAGS_PLANAR,
> +       },
> +       {
> +       .name = "Sequential RGB",
> +       .fourcc = INTEL_PIX_FMT_RAW08,
> +       .depth = 8,
> +       .flags = FORMAT_FLAGS_RAW,
> +       },
> +       {
> +       .name = "Sequential RGB",
> +       .fourcc = INTEL_PIX_FMT_RAW10,
> +       .depth = 16,
> +       .flags = FORMAT_FLAGS_RAW,
> +       },
> +       {
> +       .name = "Sequential RGB",
> +       .fourcc = INTEL_PIX_FMT_RAW12,
> +       .depth = 16,
> +       .flags = FORMAT_FLAGS_RAW,
> +       },

Please add these intel formats to include/linux/videodev2.h with proper
defines.

> +};
> +
> +static int NUM_FORMATS = sizeof(fmts) / sizeof(struct intel_fmt);
> +#endif /* _ISP_FMTS_H */
> +
> diff --git a/drivers/media/video/mrstci/include/ci_sensor_common.h b/drivers/media/video/mrstci/include/ci_sensor_common.h
> new file mode 100644
> index 0000000..8d8a40b
> --- /dev/null
> +++ b/drivers/media/video/mrstci/include/ci_sensor_common.h
> @@ -0,0 +1,1157 @@

<cut>

> +/*
> + * sensor capabilities struct: a struct member may have 0, 1 or several bits
> + * set according to the capabilities of the sensor. All struct members must be
> + * unsigned int and no padding is allowed. Thus, access to the fields is also
> + * possible by means of a field of unsigned int values. Indicees for the
> + * field-like access are given below.
> + */
> +struct ci_sensor_caps{

Space before '{'. Seems to be wrong in all structs in this header.

<cut>

> +/* Bad Pixel table */
> +struct ci_sensor_bp_table{
> +       unsigned int bp_number;
> +       struct ci_sensor_bp_table_elem *bp_table_elem;
> +       unsigned int bp_table_elem_num;
> +};
> +
> +#define        SENSOR_CTRL_TYPE_INTEGER        1
> +#define        SENSOR_CTRL_TYPE_BOOLEAN        2
> +#define        SENSOR_CTRL_TYPE_MENU           3
> +#define        SENSOR_CTRL_TYPE_BUTTON         4
> +#define        SENSOR_CTRL_TYPE_INTEGER64      5
> +#define        SENSOR_CTRL_TYPE_CTRL_CLASS     6
> +
> +#define SENSOR_CTRL_CLASS_USER 0x00980000
> +#define SENSOR_CID_BASE                        (SENSOR_CTRL_CLASS_USER | 0x900)
> +#define SENSOR_CID_USER_BASE           SENSOR_CID_BASE
> +
> +/*  IDs reserved for driver specific controls */
> +#define SENSOR_CID_PRIVATE_BASE                0x08000000
> +
> +#define SENSOR_CID_USER_CLASS          (SENSOR_CTRL_CLASS_USER | 1)
> +#define SENSOR_CID_BRIGHTNESS          (SENSOR_CID_BASE+0)
> +#define SENSOR_CID_CONTRAST            (SENSOR_CID_BASE+1)
> +#define SENSOR_CID_SATURATION          (SENSOR_CID_BASE+2)
> +#define SENSOR_CID_HUE                 (SENSOR_CID_BASE+3)
> +#define SENSOR_CID_AUDIO_VOLUME                (SENSOR_CID_BASE+5)
> +#define SENSOR_CID_AUDIO_BALANCE       (SENSOR_CID_BASE+6)
> +#define SENSOR_CID_AUDIO_BASS          (SENSOR_CID_BASE+7)
> +#define SENSOR_CID_AUDIO_TREBLE                (SENSOR_CID_BASE+8)
> +#define SENSOR_CID_AUDIO_MUTE          (SENSOR_CID_BASE+9)
> +#define SENSOR_CID_AUDIO_LOUDNESS      (SENSOR_CID_BASE+10)
> +#define SENSOR_CID_BLACK_LEVEL         (SENSOR_CID_BASE+11)
> +#define SENSOR_CID_AUTO_WHITE_BALANCE  (SENSOR_CID_BASE+12)
> +#define SENSOR_CID_DO_WHITE_BALANCE    (SENSOR_CID_BASE+13)
> +#define SENSOR_CID_RED_BALANCE         (SENSOR_CID_BASE+14)
> +#define SENSOR_CID_BLUE_BALANCE                (SENSOR_CID_BASE+15)
> +#define SENSOR_CID_GAMMA               (SENSOR_CID_BASE+16)
> +#define SENSOR_CID_WHITENESS           (SENSOR_CID_GAMMA)
> +#define SENSOR_CID_EXPOSURE            (SENSOR_CID_BASE+17)
> +#define SENSOR_CID_AUTOGAIN            (SENSOR_CID_BASE+18)
> +#define SENSOR_CID_GAIN                        (SENSOR_CID_BASE+19)
> +#define SENSOR_CID_HFLIP               (SENSOR_CID_BASE+20)
> +#define SENSOR_CID_VFLIP               (SENSOR_CID_BASE+21)
> +#define SENSOR_CID_HCENTER             (SENSOR_CID_BASE+22)
> +#define SENSOR_CID_VCENTER             (SENSOR_CID_BASE+23)
> +#define SENSOR_CID_LASTP1              (SENSOR_CID_BASE+24)

Huh? Redefining control types? What's up with that?

> +
> +struct ci_sensor_parm{
> +       unsigned int index;
> +       int value;
> +       int max;
> +       int min;
> +       int info;
> +       int type;
> +       char name[32];
> +       int step;
> +       int def_value;
> +       int flags;
> +};
> +
> +#define MRV_GRAD_TBL_SIZE      8
> +#define MRV_DATA_TBL_SIZE      289
> +
> +struct ci_sensor_ls_corr_config{
> +       unsigned short ls_rdata_tbl[MRV_DATA_TBL_SIZE];
> +       unsigned short ls_gdata_tbl[MRV_DATA_TBL_SIZE];
> +       unsigned short ls_bdata_tbl[MRV_DATA_TBL_SIZE];
> +       unsigned short ls_xgrad_tbl[MRV_GRAD_TBL_SIZE];
> +       unsigned short ls_ygrad_tbl[MRV_GRAD_TBL_SIZE];
> +       unsigned short ls_xsize_tbl[MRV_GRAD_TBL_SIZE];
> +       unsigned short ls_ysize_tbl[MRV_GRAD_TBL_SIZE];
> +};
> +
> +struct ci_sensor_reg{
> +       unsigned int addr;
> +       unsigned int value;
> +};
> +
> +struct ci_sensor_loc_dist{
> +       float pca1_low_temp;
> +       float pca1_high_temp;
> +       float locus_distance;
> +       float a2;
> +       float a1;
> +       float a0;
> +};
> +
> +static inline int ci_sensor_res2size(unsigned int res, unsigned short *h_size,
> +                      unsigned short *v_size)

This is *way* too big for an inline function.

> +{
> +       unsigned short hsize;
> +       unsigned short vsize;
> +       int err = 0;
> +
> +       switch (res) {
> +       case SENSOR_RES_QQCIF:
> +               hsize = QQCIF_SIZE_H;
> +               vsize = QQCIF_SIZE_V;
> +               break;
> +       case SENSOR_RES_QQVGA:
> +               hsize = QQVGA_SIZE_H;
> +               vsize = QQVGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_QCIF:
> +               hsize = QCIF_SIZE_H;
> +               vsize = QCIF_SIZE_V;
> +               break;
> +       case SENSOR_RES_QVGA:
> +               hsize = QVGA_SIZE_H;
> +               vsize = QVGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_CIF:
> +               hsize = CIF_SIZE_H;
> +               vsize = CIF_SIZE_V;
> +               break;
> +       case SENSOR_RES_VGA:
> +               hsize = VGA_SIZE_H;
> +               vsize = VGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_SVGA:
> +               hsize = SVGA_SIZE_H;
> +               vsize = SVGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_XGA:
> +               hsize = XGA_SIZE_H;
> +               vsize = XGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_XGA_PLUS:
> +               hsize = XGA_PLUS_SIZE_H;
> +               vsize = XGA_PLUS_SIZE_V;
> +               break;
> +       case SENSOR_RES_SXGA:
> +               hsize = SXGA_SIZE_H;
> +               vsize = SXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_UXGA:
> +               hsize = UXGA_SIZE_H;
> +               vsize = UXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_QXGA:
> +               hsize = QXGA_SIZE_H;
> +               vsize = QXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_QSXGA:
> +               hsize = QSXGA_SIZE_H;
> +               vsize = QSXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_QSXGA_PLUS:
> +               hsize = QSXGA_PLUS_SIZE_H;
> +               vsize = QSXGA_PLUS_SIZE_V;
> +               break;
> +       case SENSOR_RES_QSXGA_PLUS2:
> +               hsize = QSXGA_PLUS2_SIZE_H;
> +               vsize = QSXGA_PLUS2_SIZE_V;
> +               break;
> +       case SENSOR_RES_QSXGA_PLUS3:
> +               hsize = QSXGA_PLUS3_SIZE_H;
> +               vsize = QSXGA_PLUS3_SIZE_V;
> +               break;
> +       case SENSOR_RES_WQSXGA:
> +               hsize = WQSXGA_SIZE_H;
> +               vsize = WQSXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_QUXGA:
> +               hsize = QUXGA_SIZE_H;
> +               vsize = QUXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_WQUXGA:
> +               hsize = WQUXGA_SIZE_H;
> +               vsize = WQUXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_HXGA:
> +               hsize = HXGA_SIZE_H;
> +               vsize = HXGA_SIZE_V;
> +               break;
> +       case SENSOR_RES_RAWMAX:
> +               hsize = RAWMAX_SIZE_H;
> +               vsize = RAWMAX_SIZE_V;
> +               break;
> +       case SENSOR_RES_YUV_HMAX:
> +               hsize = YUV_HMAX_SIZE_H;
> +               vsize = YUV_HMAX_SIZE_V;
> +               break;
> +       case SENSOR_RES_YUV_VMAX:
> +               hsize = YUV_VMAX_SIZE_H;
> +               vsize = YUV_VMAX_SIZE_V;
> +               break;
> +       case SENSOR_RES_BP1:
> +               hsize = BP1_SIZE_H;
> +               vsize = BP1_SIZE_V;
> +               break;
> +       case SENSOR_RES_L_AFM:
> +               hsize = L_AFM_SIZE_H;
> +               vsize = L_AFM_SIZE_V;
> +               break;
> +       case SENSOR_RES_M_AFM:
> +               hsize = M_AFM_SIZE_H;
> +               vsize = M_AFM_SIZE_V;
> +               break;
> +       case SENSOR_RES_S_AFM:
> +               hsize = S_AFM_SIZE_H;
> +               vsize = S_AFM_SIZE_V;
> +               break;
> +
> +       case SENSOR_RES_QXGA_PLUS:
> +               hsize = QXGA_PLUS_SIZE_H;
> +               vsize = QXGA_PLUS_SIZE_V;
> +               break;
> +
> +       case SENSOR_RES_1080P:
> +               hsize = RES_1080P_SIZE_H;
> +               vsize = 1080;
> +               break;
> +
> +       case SENSOR_RES_720P:
> +               hsize = RES_720P_SIZE_H;
> +               vsize = RES_720P_SIZE_V;
> +               break;
> +
> +       case SENSOR_RES_VGA_PLUS:
> +               hsize = VGA_PLUS_SIZE_H;
> +               vsize = VGA_PLUS_SIZE_V;
> +               break;
> +
> +       default:
> +               hsize = 0;
> +               vsize = 0;
> +               err = -1;
> +               printk(KERN_ERR "ci_sensor_res2size: Resolution 0x%08x"
> +                      "unknown\n", res);
> +               break;
> +       }
> +
> +       if (h_size != NULL)
> +               *h_size = hsize;
> +       if (v_size != NULL)
> +               *v_size = vsize;
> +
> +       return err;
> +}
> +#endif

<cut>

> diff --git a/drivers/media/video/mrstci/mrstisp/include/def.h b/drivers/media/video/mrstci/mrstisp/include/def.h
> new file mode 100644
> index 0000000..75bcbec
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/include/def.h
> @@ -0,0 +1,111 @@
> +/*
> + * Support for Moorestown Langwell Camera Imaging ISP subsystem.
> + *
> + * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
> + *
> + * Copyright (c) Silicon Image 2008  www.siliconimage.com
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
> +#ifndef _DEF_H
> +#define _DEF_H
> +
> +#include <linux/stddef.h>
> +
> +#ifndef ON
> +/* all bits to '1' but prevent "shift overflow" warning */
> +#define ON   -1
> +#endif
> +
> +#ifndef OFF
> +#define OFF  0
> +#endif
> +
> +#ifndef ENABLE
> +/* all bits to '1' but prevent "shift overflow" warning */
> +#define ENABLE   -1
> +#endif
> +
> +#ifndef DISABLE
> +#define DISABLE  0
> +#endif

ON/OFF/ENABLE/DISABLE: Hmmm, do you really need this?

> +
> +#define crop_flag 0

???

> +#define CI_STATUS_SUCCESS         0
> +#define CI_STATUS_FAILURE         1
> +#define CI_STATUS_NOTSUPP         2
> +#define CI_STATUS_BUSY            3
> +#define CI_STATUS_CANCELED        4
> +#define CI_STATUS_OUTOFMEM        5
> +#define CI_STATUS_OUTOFRANGE      6
> +#define CI_STATUS_IDLE            7
> +#define CI_STATUS_WRONG_HANDLE    8
> +#define CI_STATUS_NULL_POINTER    9
> +#define CI_STATUS_NOTAVAILABLE    10
> +
> +#ifndef UNUSED_PARAM
> +#define UNUSED_PARAM(x)   ((x) = (x))
> +#endif
> +
> +/* to avoid Lint warnings, use it within const context */
> +#ifndef UNUSED_PARAM1
> +#define UNUSED_PARAM1(x)
> +#endif

UNUSED_PARAM should not be necessary. And is very ugly.

> +
> +/*
> + * documentation keywords for pointer arguments, to tell the direction of the
> + * passing
> + */
> +
> +#ifndef OUT
> +/* pointer content is expected to be filled by called function */
> +#define OUT
> +#endif
> +
> +#ifndef IN
> +/* pointer content contains parameters from the caller */
> +#define IN
> +#endif

Not needed, just make it a const pointer.

> +
> +#ifndef INOUT
> +/* content is expected to be read and changed */
> +#define INOUT
> +#endif

Just make a comment to differentiate between OUT and INOUT rather than
redefining the language.

> +
> +/* some useful macros */
> +#ifndef MIN
> +#define MIN(x, y)            ((x) < (y) ? (x) : (y))
> +#endif
> +
> +#ifndef MAX
> +#define MAX(x, y)            ((x) > (y) ? (x) : (y))
> +#endif
> +
> +#ifndef ABS
> +#define ABS(val)            ((val) < 0 ? -(val) : (val))
> +#endif

min, max and abs are all available in linux/kernel.h.

> +
> +/*
> + * converts a term to a string (two macros are required, never use _VAL2STR()
> + * directly)
> + */
> +#define _VAL2STR(x) #x
> +#define VAL2STR(x) _VAL2STR(x)

Use stringify.h

> +#endif

<cut>

> diff --git a/drivers/media/video/mrstci/mrstisp/include/mrstisp_hw.h b/drivers/media/video/mrstci/mrstisp/include/mrstisp_hw.h
> new file mode 100644
> index 0000000..a9b54d5
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/include/mrstisp_hw.h
> @@ -0,0 +1,176 @@
> +/*
> + * Support for Moorestown Langwell Camera Imaging ISP subsystem.
> + *
> + * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
> + *
> + * Copyright (c) Silicon Image 2008  www.siliconimage.com
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
> +#ifndef _MRV_H
> +#define _MRV_H
> +
> +/* move structure definination to ci_isp_common.h */
> +#include "ci_isp_common.h"
> +
> +/* sensor struct related functions */
> +int ci_isp_bp_write_table(
> +       const struct ci_sensor_bp_table *bp_table
> +);
> +int ci_isp_bp_read_table(struct ci_sensor_bp_table *bp_table);
> +enum ci_isp_path ci_isp_select_path(
> +       const struct ci_sensor_config *isi_cfg,
> +       u8 *words_per_pixel
> +);
> +int ci_isp_set_input_aquisition(
> +       const struct ci_sensor_config *isi_cfg
> +);
> +void ci_isp_set_gamma(
> +       const struct ci_sensor_gamma_curve *r,
> +       const struct ci_sensor_gamma_curve *g,
> +       const struct ci_sensor_gamma_curve *b
> +);
> +int ci_isp_get_wb_meas(struct ci_sensor_awb_mean *awb_mean);
> +int ci_isp_set_bp_correction(
> +       const struct ci_isp_bp_corr_config *bp_corr_config
> +);
> +int ci_isp_set_bp_detection(
> +       const struct ci_isp_bp_det_config *bp_det_config
> +);
> +int ci_isp_clear_bp_int(void);
> +u32 ci_isp_get_frame_end_irq_mask_dma(void);
> +u32 ci_isp_get_frame_end_irq_mask_isp(void);
> +int ci_isp_wait_for_frame_end(struct mrst_isp_device *intel);
> +void ci_isp_set_output_formatter(
> +       const struct ci_isp_window *window,
> +       enum ci_isp_conf_update_time update_time
> +);
> +
> +int ci_isp_is_set_config(const struct ci_isp_is_config *is_config);
> +int ci_isp_set_data_path(
> +       enum ci_isp_ycs_chn_mode ycs_chn_mode,
> +       enum ci_isp_dp_switch dp_switch
> +);
> +void ci_isp_res_set_main_resize(const struct ci_isp_scale *scale,
> +       enum ci_isp_conf_update_time update_time,
> +       const struct ci_isp_rsz_lut *rsz_lut
> +);
> +void ci_isp_res_get_main_resize(struct ci_isp_scale *scale);
> +void ci_isp_res_set_self_resize(const struct ci_isp_scale *scale,
> +       enum ci_isp_conf_update_time update_time,
> +       const struct ci_isp_rsz_lut *rsz_lut
> +);
> +void ci_isp_res_get_self_resize(struct ci_isp_scale *scale);
> +int ci_isp_mif_set_main_buffer(
> +       const struct ci_isp_mi_path_conf *mrv_mi_path_conf,
> +       enum ci_isp_conf_update_time update_time
> +);
> +int ci_isp_mif_set_self_buffer(
> +       const struct ci_isp_mi_path_conf *mrv_mi_path_conf,
> +       enum ci_isp_conf_update_time update_time
> +);
> +
> +int ci_isp_mif_set_dma_buffer(
> +       const struct ci_isp_mi_path_conf *mrv_mi_path_conf
> +);
> +
> +void ci_isp_mif_disable_all_paths(int perform_wait_for_frame_end);
> +int ci_isp_mif_get_main_buffer(
> +       struct ci_isp_mi_path_conf *mrv_mi_path_conf
> +);
> +int ci_isp_mif_get_self_buffer(
> +       struct ci_isp_mi_path_conf *mrv_mi_path_conf
> +);
> +int ci_isp_mif_set_path_and_orientation(
> +       const struct ci_isp_mi_ctrl *mrv_mi_ctrl
> +);
> +int ci_isp_mif_get_path_and_orientation(
> +       struct ci_isp_mi_ctrl *mrv_mi_ctrl
> +);
> +int ci_isp_mif_set_configuration(
> +       const struct ci_isp_mi_ctrl *mrv_mi_ctrl,
> +       const struct ci_isp_mi_path_conf *mrv_mi_mp_path_conf,
> +       const struct ci_isp_mi_path_conf *mrv_mi_sp_path_conf,
> +       const struct ci_isp_mi_dma_conf *mrv_mi_dma_conf
> +);
> +int ci_isp_mif_set_dma_config(
> +       const struct ci_isp_mi_dma_conf *mrv_mi_dma_conf
> +);
> +int ci_isp_mif_get_pixel_per32_bit_of_line(
> +       u8 *pixel_per32_bit,
> +       enum ci_isp_mif_col_format mrv_mif_sp_format,
> +       enum ci_isp_mif_pic_form mrv_mif_pic_form,
> +       int luminance_buffer
> +);
> +void ci_isp_set_ext_ycmode(void);
> +int ci_isp_set_mipi_smia(u32 mode);
> +void ci_isp_sml_out_set_path(enum ci_isp_data_path main_path);
> +u32 ci_isp_mif_get_byte_cnt(void);
> +void ci_isp_start(
> +       u16 number_of_frames,
> +       enum ci_isp_conf_update_time update_time
> +);
> +int ci_isp_jpe_init_ex(
> +       u16 hsize,
> +       u16 vsize,
> +       u8 compression_ratio,
> +       u8 jpe_scale
> +);
> +void ci_isp_reset_interrupt_status(void);
> +void ci_isp_get_output_formatter(struct ci_isp_window *window);
> +int ci_isp_set_auto_focus(const struct ci_isp_af_config *af_config);
> +void ci_isp_get_auto_focus_meas(struct ci_isp_af_meas *af_meas);
> +int ci_isp_chk_bp_int_stat(void);
> +int ci_isp_bls_get_measured_values(
> +       struct ci_isp_bls_measured *bls_measured
> +);
> +int ci_isp_get_wb_measConfig(

Don't use camelCase.

> +       struct ci_isp_wb_meas_config *wb_meas_config
> +);
> +void ci_isp_col_set_color_processing(
> +       const struct ci_isp_color_settings *col
> +);
> +int ci_isp_ie_set_config(const struct ci_isp_ie_config *ie_config);
> +int ci_isp_set_ls_correction(struct ci_sensor_ls_corr_config *ls_corr_config);
> +int ci_isp_ls_correction_on_off(int ls_corr_on_off);
> +int ci_isp_activate_filter(int activate_filter);
> +int ci_isp_set_filter_params(u8 noise_reduc_level, u8 sharp_level);
> +int ci_isp_bls_set_config(const struct ci_isp_bls_config *bls_config);
> +int ci_isp_set_wb_mode(enum ci_isp_awb_mode wb_mode);
> +int ci_isp_set_wb_meas_config(
> +       const struct ci_isp_wb_meas_config *wb_meas_config
> +);
> +int ci_isp_set_wb_auto_hw_config(
> +       const struct ci_isp_wb_auto_hw_config *wb_auto_hw_config
> +);
> +void ci_isp_init(void);
> +void ci_isp_off(void);
> +void ci_isp_stop(enum ci_isp_conf_update_time update_time);
> +void ci_isp_mif_reset_offsets(enum ci_isp_conf_update_time update_time);
> +int ci_isp_get_wb_measConfig(
> +       struct ci_isp_wb_meas_config *wb_meas_config
> +);

Ditto.

> +void ci_isp_set_gamma2(const struct ci_isp_gamma_out_curve *gamma);
> +void ci_isp_set_demosaic(
> +       enum ci_isp_demosaic_mode demosaic_mode,
> +       u8 demosaic_th
> +);
> +void mrst_isp_disable_interrupt(struct mrst_isp_device *isp);
> +void mrst_isp_enable_interrupt(struct mrst_isp_device *isp);
> +#endif
> diff --git a/drivers/media/video/mrstci/mrstisp/include/mrstisp_stdinc.h b/drivers/media/video/mrstci/mrstisp/include/mrstisp_stdinc.h
> new file mode 100644
> index 0000000..033a104
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/include/mrstisp_stdinc.h
> @@ -0,0 +1,115 @@
> +/*
> + * Support for Moorestown Langwell Camera Imaging ISP subsystem.
> + *
> + * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
> + *
> + * Copyright (c) Silicon Image 2008  www.siliconimage.com
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
> +#ifndef _MRSTISP_STDINC_H
> +#define _MRSTISP_STDINC_H
> +
> +#ifdef __KERNEL__
> +#include <linux/module.h>
> +#include <linux/version.h>
> +#include <linux/moduleparam.h>
> +#include <linux/init.h>
> +#include <linux/fs.h>
> +
> +#include <linux/proc_fs.h>
> +#include <linux/ctype.h>
> +#include <linux/pagemap.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +
> +#include <linux/uaccess.h>
> +#include <linux/videodev2.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-ioctl.h>
> +
> +#include <linux/mutex.h>
> +#include <linux/list.h>
> +#include <linux/string.h>
> +#include <linux/slab.h>
> +#include <linux/vmalloc.h>
> +#include <linux/types.h>
> +#include <linux/errno.h>
> +#include <linux/sched.h>
> +#include <linux/moduleparam.h>
> +#include <linux/smp_lock.h>
> +#include <asm/kmap_types.h>
> +#include <linux/delay.h>
> +#include <linux/pci.h>
> +#include <linux/interrupt.h>
> +#include <linux/timer.h>
> +#include <asm/system.h>
> +#include <asm/page.h>
> +#include <asm/pgtable.h>
> +#include <linux/time.h>
> +#include <linux/syscalls.h>
> +
> +#include <linux/i2c.h>
> +#include <linux/gpio.h>
> +#include <linux/dma-mapping.h>
> +#include <media/videobuf-core.h>
> +#include <media/videobuf-dma-contig.h>
> +
> +#ifdef CONFIG_KMOD
> +#include <linux/kmod.h>
> +#endif
> +
> +#include "ci_sensor_common.h"
> +#include "ci_isp_common.h"
> +#include "ci_va.h"
> +#include "v4l2_jpg_review.h"
> +
> +#include "def.h"
> +#include "mrstisp_reg.h"
> +#include "mrstisp.h"
> +#include "mrstisp_isp.h"
> +#include "mrstisp_hw.h"
> +#include "mrstisp_jpe.h"
> +#include "mrstisp_dp.h"
> +
> +extern unsigned char *mrst_isp_regs;
> +#define MEM_CSC_REG_BASE                (0x08500000)
> +#define MEM_MRV_REG_BASE (mrst_isp_regs)
> +#define ALIGN_TO_4(f)  (((f) + 3) & ~3)
> +
> +/* for debug */
> +extern int mrstisp_debug;
> +#define dprintk(level, fmt, arg...) do {                       \
> +       if (mrstisp_debug >= level)                                     \
> +               printk(KERN_DEBUG "mrstisp@%s: " fmt "\n", \
> +                      __func__, ## arg); } \
> +       while (0)
> +
> +#define eprintk(fmt, arg...)   \
> +       printk(KERN_ERR "mrstisp@%s" fmt "\n",  \
> +              __func__, ## arg);
> +
> +#define DBG_entering   dprintk(1, "entering");
> +#define DBG_leaving    dprintk(1, "leaving");
> +#define DBG_line       dprintk(1, " line: %d", __LINE__);

As mentioned earlier: these DBG_ defines seem like overkill to me.

> +
> +#include "reg_access.h"
> +
> +#endif
> +#endif
> diff --git a/drivers/media/video/mrstci/mrstisp/include/reg_access.h b/drivers/media/video/mrstci/mrstisp/include/reg_access.h
> new file mode 100644
> index 0000000..1f905fe
> --- /dev/null
> +++ b/drivers/media/video/mrstci/mrstisp/include/reg_access.h
> @@ -0,0 +1,119 @@
> +/*
> + * Support for Moorestown Langwell Camera Imaging ISP subsystem.
> + *
> + * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
> + *
> + * Copyright (c) Silicon Image 2008  www.siliconimage.com
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
> +#ifndef _REG_ACCESS_H
> +#define _REG_ACCESS_H
> +
> +#define DBG_DD(x) \
> +       do { \
> +               if (mrstisp_debug >= 4) {       \
> +                       printk(KERN_INFO "mrstisp@%s ", __func__);      \
> +                       printk x; \
> +               }       \
> +       } while (0)
> +
> +static inline u32 _reg_read(u32 reg, const char *text)
> +{
> +       u32 variable = reg;
> +       DBG_DD((text, variable));
> +       return variable;
> +}
> +
> +#define REG_READ(reg) \
> +_reg_read((reg),  "REG_READ(" VAL2STR(reg) "): 0x%08X\n")
> +
> +static inline u32 _reg_read_ex(u32 reg, const char *text)
> +{
> +       u32 variable = reg;
> +       DBG_DD((text, variable));
> +       return variable;
> +}
> +
> +#define REG_READ_EX(reg) \
> +_reg_read_ex((reg),  "REG_READ_EX(" VAL2STR(reg) "): 0x%08X\n")
> +
> +#define REG_WRITE(reg, value) \
> +{ \
> +       dprintk(4, \
> +       "REG_WRITE(" VAL2STR(reg) ", " VAL2STR(value) "): 0x%08X", (value)); \
> +       (reg) = (value); \
> +}
> +
> +#define REG_WRITE_EX(reg, value) \
> +{ \
> +       (reg) = (value); \
> +}
> +
> +static inline u32 _reg_get_slice(const char *text, u32 val)
> +{
> +       u32 variable = val;
> +       DBG_DD((text, variable));
> +       return val;
> +}
> +
> +#define REG_GET_SLICE_EX(reg, name) \
> +       (((reg) & (name##_MASK)) >> (name##_SHIFT))
> +
> +#define REG_GET_SLICE(reg, name) \
> +       _reg_get_slice("REG_GET_SLICE(" VAL2STR(reg) ", " VAL2STR(name) \
> +                      "): 0x%08X\n" , \
> +       (((reg) & (name##_MASK)) >> (name##_SHIFT)))
> +
> +#define REG_SET_SLICE(reg, name, value) \
> +{ \
> +       dprintk(4, \
> +               "REG_SET_SLICE(" VAL2STR(reg) ", " VAL2STR(name) \
> +               ", " VAL2STR(value) "): 0x%08X", \
> +               (value));       \
> +               ((reg) = (((reg) & ~(name##_MASK)) | \
> +               (((value) << (name##_SHIFT)) & (name##_MASK)))); \
> +}
> +
> +#define REG_SET_SLICE_EX(reg, name, value) \
> +{ \
> +               ((reg) = (((reg) & ~(name##_MASK)) | \
> +               (((value) << (name##_SHIFT)) & (name##_MASK)))); \
> +}
> +
> +#define REG_GET_ARRAY_ELEM1(areg, name, idx) \
> +((idx < name##_ARR_SIZE) \
> +? areg[idx] \
> +: 0)
> +
> +#define REG_SET_ARRAY_ELEM1(areg, name, idx, value) \
> +((idx < name##_ARR_SIZE) \
> +? areg[idx] = value \
> +: 0)
> +
> +#define REG_GET_ARRAY_ELEM2(areg, name, idx1, idx2) \
> +(((idx1 < name##_ARR_SIZE1) && (idx2 < name##_ARR_SIZE2)) \
> +? areg[(idx1 * name##_ARR_OFS1) + (idx2 * name##_ARR_OFS2)] \
> +: 0)
> +
> +#define REG_SET_ARRAY_ELEM2(areg, name, idx1, idx2, value) \
> +(((idx1 < name##_ARR_SIZE1) && (idx2 < name##_ARR_SIZE2)) \
> +? areg[(idx1 * name##_ARR_OFS1) + (idx2 * name##_ARR_OFS2)] = value \
> +: 0)
> +#endif

The same is true here: too much debugging. This probably leads to a substantial
increase of code size.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
