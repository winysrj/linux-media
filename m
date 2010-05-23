Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2878 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab0EWMbP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 08:31:15 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
Subject: Re: [PATCH v3 1/8] V4L2 subdev patchset for Intel Moorestown Camera Imaging Subsystem
Date: Sun, 23 May 2010 14:32:58 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <33AB447FBD802F4E932063B962385B351E89572D@shsmsx501.ccr.corp.intel.com>
In-Reply-To: <33AB447FBD802F4E932063B962385B351E89572D@shsmsx501.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005231432.58711.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Xiaolin,

Here is the review of this patch series.

On Tuesday 18 May 2010 11:22:04 Zhang, Xiaolin wrote:
> From 50009eae70b1e69f053cd567375d2394fd926203 Mon Sep 17 00:00:00 2001
> From: Xiaolin Zhang <xiaolin.zhang@intel.com>
> Date: Tue, 18 May 2010 15:20:59 +0800
> Subject: [PATCH 1/8] the common sensor v4l2-subdev private structures and resolutions definition
>  ued in ov2650, ov5630, ov9665, s5k4e1 v4l2-subdev sensor drivers.
> 
> Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
> ---
>  drivers/media/video/Kconfig              |   75 ++++++
>  drivers/media/video/Makefile             |    9 +

The changes for these files should be last in the patch series: otherwise
you introduce build errors since the files that the makefile refers to do
not exist yet.

>  drivers/media/video/mrst_sensor_common.h |  378 ++++++++++++++++++++++++++++++
>  3 files changed, 462 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/mrst_sensor_common.h
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 9644cf7..d23adcc 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -332,6 +332,79 @@ config VIDEO_TCM825X
>           This is a driver for the Toshiba TCM825x VGA camera sensor.
>           It is used for example in Nokia N800.
> 
> +config VIDEO_OV2650
> +        tristate "OmniVision OV2650 SoC Sensor support"
> +        depends on I2C && VIDEO_V4L2
> +
> +        ---help---
> +          This is a Video4Linux2 sensor-level driver for the OmniVision
> +          OV2650 2MP camera. It currently only works with the Intel Atom
> +          (Moorestown) platform.
> +
> +config VIDEO_OV9665
> +       tristate "OmniVision OV9665 SoC Sensor support"
> +       depends on I2C && VIDEO_V4L2
> +
> +       ---help---
> +         This is a Video4Linux2 sensor-level driver for the OmniVision
> +        OV9665 1.3MP camera. It currently only works with the Intel Atom
> +        (Moorestown) platform.
> +
> +config VIDEO_OV5630
> +       tristate "OmniVision OV5630 RAW Sensor support"
> +       depends on I2C && VIDEO_V4L2
> +
> +       ---help---
> +         This is a Video4Linux2 sensor-level driver for the OmniVision
> +        OV5630 5MP camera. It currently only works with the Intel Atom
> +        (Moorestown) platform.
> +
> +config VIDEO_S5K4E1
> +       tristate "Samsung s5k4e1 RAW Sensor support"
> +       depends on I2C && VIDEO_V4L2
> +
> +       ---help---
> +       This is a Video4Linux2 sensor-level driver for the Samsung
> +       s5k4e1 5MP camera. It currently only works with Intel Atom
> +       (Moorestown) platform.
> +
> +config VIDEO_OV5630_MOTOR
> +       tristate "Analog Devices AD5820 VCM (OVT OV5630) support"
> +       depends on I2C && VIDEO_V4L2 && VIDEO_OV5630
> +       default y
> +       ---help---
> +         This is a video4linux2 driver for the Analog Devices AD5820
> +         VCM Driver integrated into OVT OV5630 camera module
> +          which is curretly supported on Intel Atom
> +         (Moorestown)CMOS camera controller.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called ov5630_motor.ko.
> +
> +config VIDEO_S5K4E1_MOTOR
> +       tristate "Renesas VCM driver (KMOT IX51A) support"
> +       depends on I2C && VIDEO_V4L2 && VIDEO_S5K4E1
> +       default y
> +       ---help---
> +         This is a video4linux2 driver for the Renesas VCM driver R2A30419BX
> +         which is located in KMOT IX51A camera module which is curretly
> +         supported on Intel Atom (Moorestown)CMOS camera controller.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called s5k4e1_motor.ko.
> +
> +config VIDEO_MRSTFLASH
> +       tristate "National Semiconductor LM3553 Flash LED Driver support"
> +       depends on I2C && VIDEO_V4L2
> +       default y
> +       ---help---
> +         This is a video4linux2 driver for the National Semiconductor LM3553
> +         1.2A Dual Flas LED Driver which is curretly supported on Intel Atom
> +         (Moorestown)CMOS camera controller.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called lm3553.ko
> +
>  config VIDEO_SAA7110
>         tristate "Philips SAA7110 video decoder"
>         depends on VIDEO_V4L2 && I2C
> @@ -833,6 +906,8 @@ config VIDEO_CAFE_CCIC
>           CMOS camera controller.  This is the controller found on first-
>           generation OLPC systems.
> 
> +source "drivers/media/video/mrstisp/Kconfig"
> +
>  config SOC_CAMERA
>         tristate "SoC camera support"
>         depends on VIDEO_V4L2 && HAS_DMA && I2C
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index c51c386..d7eca01 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -70,6 +70,13 @@ obj-$(CONFIG_VIDEO_UPD64031A) += upd64031a.o
>  obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
>  obj-$(CONFIG_VIDEO_OV7670)     += ov7670.o
>  obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
> +obj-$(CONFIG_VIDEO_OV2650) += ov2650.o
> +obj-$(CONFIG_VIDEO_OV9665) += ov9665.o
> +obj-$(CONFIG_VIDEO_OV5630) += ov5630.o
> +obj-$(CONFIG_VIDEO_S5K4E1) += ovs5k4e1.o
> +obj-$(CONFIG_VIDEO_MRSTFLASH) += mrstflash.o
> +obj-$(CONFIG_VIDEO_OV5630_MOTOR) += ov5630_motor.o
> +obj-$(CONFIG_VIDEO_S5K4E1_MOTOR) += s5k4e1_motor.o
>  obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
>  obj-$(CONFIG_VIDEO_MT9V011) += mt9v011.o
> 
> @@ -123,6 +130,8 @@ obj-$(CONFIG_VIDEO_CX2341X) += cx2341x.o
> 
>  obj-$(CONFIG_VIDEO_CAFE_CCIC) += cafe_ccic.o
> 
> +obj-$(CONFIG_VIDEO_MRSTISP) += mrstisp/
> +
>  obj-$(CONFIG_USB_DABUSB)        += dabusb.o
>  obj-$(CONFIG_USB_OV511)         += ov511.o
>  obj-$(CONFIG_USB_SE401)         += se401.o
> diff --git a/drivers/media/video/mrst_sensor_common.h b/drivers/media/video/mrst_sensor_common.h
> new file mode 100644
> index 0000000..955e67f
> --- /dev/null
> +++ b/drivers/media/video/mrst_sensor_common.h
> @@ -0,0 +1,378 @@
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
> +#ifndef _SENSOR_FMT_COMMON_H
> +#define _SENSOR_FMT_COMMON_H
> +#include <media/v4l2-subdev.h>
> +
> +/*
> + * sensor capabilities struct: a struct member may have 0, 1 or several bits
> + * set according to the capabilities of the sensor. All struct members must be
> + * unsigned int and no padding is allowed. Thus, access to the fields is also
> + * possible by means of a field of unsigned int values. Indicees for the
> + * field-like access are given below.
> + */
> +struct ci_sensor_caps {
> +       unsigned int bus_width;
> +       unsigned int mode;
> +       unsigned int field_inv;
> +       unsigned int field_sel;
> +       unsigned int ycseq;
> +       unsigned int conv422;
> +       unsigned int bpat;
> +       unsigned int hpol;
> +       unsigned int vpol;
> +       unsigned int edge;
> +       unsigned int bls;
> +       unsigned int gamma;
> +       unsigned int cconv;
> +       unsigned int res;
> +       unsigned int dwn_sz;
> +       unsigned int blc;
> +       unsigned int agc;
> +       unsigned int awb;
> +       unsigned int aec;
> +       unsigned int cie_profile;
> +       unsigned int flicker_freq;
> +       unsigned int smia_mode;
> +       unsigned int mipi_mode;
> +       unsigned int type;
> +       char name[32];
> +
> +       struct v4l2_subdev sd;
> +};
> +
> +#define ci_sensor_config       ci_sensor_caps
> +
> +#define SENSOR_BPAT_RGRGGBGB       0x00000001
> +#define SENSOR_BPAT_GRGRBGBG       0x00000002
> +#define SENSOR_BPAT_GBGBRGRG       0x00000004
> +#define SENSOR_BPAT_BGBGGRGR       0x00000008
> +
> +#define SENSOR_BLC_AUTO            0x00000001
> +#define SENSOR_BLC_OFF             0x00000002
> +
> +#define SENSOR_AGC_AUTO            0x00000001
> +#define SENSOR_AGC_OFF             0x00000002
> +
> +#define SENSOR_AWB_AUTO            0x00000001
> +#define SENSOR_AWB_OFF             0x00000002
> +
> +#define SENSOR_AEC_AUTO            0x00000001
> +#define SENSOR_AEC_OFF             0x00000002
> +
> +/* turns on/off additional black lines at frame start */
> +#define SENSOR_BLS_OFF             0x00000001
> +#define SENSOR_BLS_TWO_LINES       0x00000002
> +#define SENSOR_BLS_FOUR_LINES      0x00000004
> +
> +/* turns on/off gamma correction in the sensor ISP */
> +#define SENSOR_GAMMA_ON            0x00000001
> +#define SENSOR_GAMMA_OFF           0x00000002
> +
> +/* 88x72 */
> +#define SENSOR_RES_QQCIF           0x00000001
> +/* 160x120 */
> +#define SENSOR_RES_QQVGA           0x00000002
> +/* 176x144 */
> +#define SENSOR_RES_QCIF            0x00000004
> +/* 320x240 */
> +#define SENSOR_RES_QVGA            0x00000008
> +/* 352x288 */
> +#define SENSOR_RES_CIF             0x00000010
> +/* 640x480 */
> +#define SENSOR_RES_VGA             0x00000020
> +/* 800x600 */
> +#define SENSOR_RES_SVGA            0x00000040
> +/* 1024x768 */
> +#define SENSOR_RES_XGA             0x00000080
> +/* 1280x960 max. resolution of OV9640 (QuadVGA) */
> +#define SENSOR_RES_XGA_PLUS        0x00000100
> +/* 1280x1024 */
> +#define SENSOR_RES_SXGA            0x00000200
> +/* 1600x1200 */
> +#define SENSOR_RES_UXGA            0x00000400
> +/* 2048x1536 */
> +#define SENSOR_RES_QXGA            0x00000800
> +#define SENSOR_RES_QXGA_PLUS       0x00001000
> +#define SENSOR_RES_RAWMAX          0x00002000
> +/* 4080x1024 */
> +#define SENSOR_RES_YUV_HMAX        0x00004000
> +/* 1024x4080 */
> +#define SENSOR_RES_YUV_VMAX        0x00008000
> +/* 720x480 */
> +#define SENSOR_RES_L_AFM           0x00020000
> +/* 128x96 */
> +#define SENSOR_RES_M_AFM           0x00040000
> +/* 64x32 */
> +#define SENSOR_RES_S_AFM           0x00080000
> +/* 352x240 */
> +#define SENSOR_RES_BP1             0x00100000
> +/* 2586x2048, quadruple SXGA, 5,3 Mpix */
> +#define SENSOR_RES_QSXGA           0x00200000
> +/* 2600x2048, max. resolution of M5, 5,32 Mpix */
> +#define SENSOR_RES_QSXGA_PLUS      0x00400000
> +/* 2600x1950 */
> +#define SENSOR_RES_QSXGA_PLUS2     0x00800000
> +/* 2686x2048,  5.30M */
> +#define SENSOR_RES_QSXGA_PLUS3     0x01000000
> +/* 3200x2048,  6.56M */
> +#define SENSOR_RES_WQSXGA          0x02000000
> +/* 3200x2400,  7.68M */
> +#define SENSOR_RES_QUXGA           0x04000000
> +/* 3840x2400,  9.22M */
> +#define SENSOR_RES_WQUXGA          0x08000000
> +/* 4096x3072, 12.59M */
> +#define SENSOR_RES_HXGA            0x10000000
> +#define SENSOR_RES_1080P                  0x20000000
> +/* 1280x720 */
> +#define SENSOR_RES_720P        0x40000000
> +
> +/* FIXME 1304x980*/
> +#define SENSOR_RES_VGA_PLUS    0x80000000
> +#define VGA_PLUS_SIZE_H                (1304)
> +#define VGA_PLUS_SIZE_V                (980)
> +#define QSXGA_PLUS4_SIZE_H     (2592)
> +#define QSXGA_PLUS4_SIZE_V     (1944)
> +#define RES_1080P_SIZE_H       (1920)
> +#define RES_1080P_SIZE_V       (1080)
> +#define RES_720P_SIZE_H        (1280)
> +#define RES_720P_SIZE_V        (720)
> +#define QQCIF_SIZE_H              (88)
> +#define QQCIF_SIZE_V              (72)
> +#define QQVGA_SIZE_H             (160)
> +#define QQVGA_SIZE_V             (120)
> +#define QCIF_SIZE_H              (176)
> +#define QCIF_SIZE_V              (144)
> +#define QVGA_SIZE_H              (320)
> +#define QVGA_SIZE_V              (240)
> +#define CIF_SIZE_H               (352)
> +#define CIF_SIZE_V               (288)
> +#define VGA_SIZE_H               (640)
> +#define VGA_SIZE_V               (480)
> +#define SVGA_SIZE_H              (800)
> +#define SVGA_SIZE_V              (600)
> +#define XGA_SIZE_H              (1024)
> +#define XGA_SIZE_V               (768)
> +#define XGA_PLUS_SIZE_H         (1280)
> +#define XGA_PLUS_SIZE_V          (960)
> +#define SXGA_SIZE_H             (1280)
> +#define SXGA_SIZE_V             (1024)
> +#define QSVGA_SIZE_H            (1600)
> +#define QSVGA_SIZE_V            (1200)
> +#define UXGA_SIZE_H             (1600)
> +#define UXGA_SIZE_V             (1200)
> +#define QXGA_SIZE_H             (2048)
> +#define QXGA_SIZE_V             (1536)
> +#define QXGA_PLUS_SIZE_H        (2592)
> +#define QXGA_PLUS_SIZE_V        (1944)
> +#define RAWMAX_SIZE_H           (4096)
> +#define RAWMAX_SIZE_V           (2048)
> +#define YUV_HMAX_SIZE_H         (4080)
> +#define YUV_HMAX_SIZE_V         (1024)
> +#define YUV_VMAX_SIZE_H         (1024)
> +#define YUV_VMAX_SIZE_V         (4080)
> +#define BP1_SIZE_H               (352)
> +#define BP1_SIZE_V               (240)
> +#define L_AFM_SIZE_H             (720)
> +#define L_AFM_SIZE_V             (480)
> +#define M_AFM_SIZE_H             (128)
> +#define M_AFM_SIZE_V              (96)
> +#define S_AFM_SIZE_H              (64)
> +#define S_AFM_SIZE_V              (32)
> +#define QSXGA_SIZE_H            (2560)
> +#define QSXGA_SIZE_V            (2048)
> +#define QSXGA_MINUS_SIZE_V      (1920)
> +#define QSXGA_PLUS_SIZE_H       (2600)
> +#define QSXGA_PLUS_SIZE_V       (2048)
> +#define QSXGA_PLUS2_SIZE_H      (2600)
> +#define QSXGA_PLUS2_SIZE_V      (1950)
> +#define QUXGA_SIZE_H            (3200)
> +#define QUXGA_SIZE_V            (2400)
> +#define SIZE_H_2500             (2500)
> +#define QSXGA_PLUS3_SIZE_H      (2686)
> +#define QSXGA_PLUS3_SIZE_V      (2048)
> +#define QSXGA_PLUS4_SIZE_V      (1944)
> +#define WQSXGA_SIZE_H           (3200)
> +#define WQSXGA_SIZE_V           (2048)
> +#define WQUXGA_SIZE_H           (3200)
> +#define WQUXGA_SIZE_V           (2400)
> +#define HXGA_SIZE_H             (4096)
> +#define HXGA_SIZE_V             (3072)
> +
> +static inline int ci_sensor_res2size(unsigned int res, unsigned short *h_size,
> +                      unsigned short *v_size)
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

Ditch this header. There is not reason whatsoever for the ci_sensor_res2size()
function: just use the actual sizes in drivers rather than these resolution
IDs.

Using the ci_sensor_caps/ci_sensor_config struct would tie these subdev drivers
into the moorestown infrastructure, preventing them from being reused, *and*
preventing Intel from benefiting from other developers improving on these
drivers. There does not seem to be any compelling reason for this header.
Instead use mbus_framefmt to pass resolution and bus format (influenced by
possible flip control settings) to the parent. And most of the img_ctrl
settings seem to map to existing controls. Should there be features missing
in the existing control list then make a proposal.

Regards,

	Hans

> --
> 1.6.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
