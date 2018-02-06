Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:52851 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752324AbeBFLxL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 06:53:11 -0500
Subject: Re: [PATCH v7 4/6] media: i2c: Add TDA1997x HDMI receiver driver
To: Tim Harvey <tharvey@gateworks.com>, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1517373374-12041-1-git-send-email-tharvey@gateworks.com>
 <1517373374-12041-5-git-send-email-tharvey@gateworks.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0c4d3e8e-dafc-c700-ad16-474140e9ac5c@xs4all.nl>
Date: Tue, 6 Feb 2018 12:53:04 +0100
MIME-Version: 1.0
In-Reply-To: <1517373374-12041-5-git-send-email-tharvey@gateworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/31/18 05:36, Tim Harvey wrote:
> Add support for the TDA1997x HDMI receivers.
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
> ---
> v7:
>  - fix interlaced mode
>  - support no AVI infoframe (ie DVI) (Hans)
>  - add support for multiple output formats (Hans)
> 
> v6:
>  - fix return on regulator enablei in tda1997x_set_power()
>  - replace copyright with SPDX tag
>  - fix colorspace handling
> 
> v5:
>  - uppercase string constants
>  - use v4l2_hdmi_rx_coloriemtry to fill format
>  - fix V4L2_CID_DV_RX_RGB_RANGE
>  - fix interlaced mode format
> 
> v4:
>  - move include/dt-bindings/media/tda1997x.h to bindings patch
>  - fix typos
>  - fix default quant range for VGA
>  - fix quant range handling and conv matrix
>  - add additional standards and capabilities to timings_cap
> 
> v3:
>  - use V4L2_DV_BT_FRAME_WIDTH/HEIGHT macros
>  - fixed missing break
>  - use only hdmi_infoframe_log for infoframe logging
>  - simplify tda1997x_s_stream error handling
>  - add delayed work proc to handle hotplug enable/disable
>  - fix set_edid (disable HPD before writing, enable after)
>  - remove enabling edid by default
>  - initialize timings
>  - take quant range into account in colorspace conversion
>  - remove vendor/product tracking (we provide this in log_status via infoframes)
>  - add v4l_controls
>  - add more detail to log_status
>  - calculate vhref generator timings
>  - timing detection fixes (rounding errors, hswidth errors)
>  - rename configure_input/configure_conv functions
> 
> v2:
>  - implement dv timings enum/cap
>  - remove deprecated g_mbus_config op
>  - fix dv_query_timings
>  - add EDID get/set handling
>  - remove max-pixel-rate support
>  - add audio codec DAI support
>  - change audio bindings
> ---
>  drivers/media/i2c/Kconfig    |    9 +
>  drivers/media/i2c/Makefile   |    1 +
>  drivers/media/i2c/tda1997x.c | 3501 ++++++++++++++++++++++++++++++++++++++++++
>  include/media/i2c/tda1997x.h |   42 +
>  4 files changed, 3553 insertions(+)
>  create mode 100644 drivers/media/i2c/tda1997x.c
>  create mode 100644 include/media/i2c/tda1997x.h
> 
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 3c6d642..abf24b9 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -56,6 +56,15 @@ config VIDEO_TDA9840
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called tda9840.
>  
> +config VIDEO_TDA1997X
> +	tristate "NXP TDA1997x HDMI receiver"
> +	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
> +	---help---
> +	  V4L2 subdevice driver for the NXP TDA1997x HDMI receivers.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called tda1997x.
> +
>  config VIDEO_TEA6415C
>  	tristate "Philips TEA6415C audio processor"
>  	depends on I2C
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index 548a9ef..adfcae9 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -13,6 +13,7 @@ obj-$(CONFIG_VIDEO_TVAUDIO) += tvaudio.o
>  obj-$(CONFIG_VIDEO_TDA7432) += tda7432.o
>  obj-$(CONFIG_VIDEO_SAA6588) += saa6588.o
>  obj-$(CONFIG_VIDEO_TDA9840) += tda9840.o
> +obj-$(CONFIG_VIDEO_TDA1997X) += tda1997x.o
>  obj-$(CONFIG_VIDEO_TEA6415C) += tea6415c.o
>  obj-$(CONFIG_VIDEO_TEA6420) += tea6420.o
>  obj-$(CONFIG_VIDEO_SAA7110) += saa7110.o
> diff --git a/drivers/media/i2c/tda1997x.c b/drivers/media/i2c/tda1997x.c
> new file mode 100644
> index 0000000..f3720c1
> --- /dev/null
> +++ b/drivers/media/i2c/tda1997x.c
> @@ -0,0 +1,3501 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2017 Gateworks Corporation
> + */
> +#include <linux/delay.h>
> +#include <linux/hdmi.h>
> +#include <linux/i2c.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of_graph.h>
> +#include <linux/platform_device.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/types.h>
> +#include <linux/v4l2-dv-timings.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-dv-timings.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-fwnode.h>
> +#include <media/i2c/tda1997x.h>
> +
> +#include <sound/core.h>
> +#include <sound/pcm.h>
> +#include <sound/pcm_params.h>
> +#include <sound/soc.h>
> +
> +#include <dt-bindings/media/tda1997x.h>
> +
> +/* debug level */
> +static int debug;
> +module_param(debug, int, 0644);
> +MODULE_PARM_DESC(debug, "debug level (0-2)");
> +
> +/* Page 0x00 - General Control */
> +#define REG_VERSION		0x0000
> +#define REG_INPUT_SEL		0x0001
> +#define REG_SVC_MODE		0x0002
> +#define REG_HPD_MAN_CTRL	0x0003
> +#define REG_RT_MAN_CTRL		0x0004
> +#define REG_STANDBY_SOFT_RST	0x000A
> +#define REG_HDMI_SOFT_RST	0x000B
> +#define REG_HDMI_INFO_RST	0x000C
> +#define REG_INT_FLG_CLR_TOP	0x000E
> +#define REG_INT_FLG_CLR_SUS	0x000F
> +#define REG_INT_FLG_CLR_DDC	0x0010
> +#define REG_INT_FLG_CLR_RATE	0x0011
> +#define REG_INT_FLG_CLR_MODE	0x0012
> +#define REG_INT_FLG_CLR_INFO	0x0013
> +#define REG_INT_FLG_CLR_AUDIO	0x0014
> +#define REG_INT_FLG_CLR_HDCP	0x0015
> +#define REG_INT_FLG_CLR_AFE	0x0016
> +#define REG_INT_MASK_TOP	0x0017
> +#define REG_INT_MASK_SUS	0x0018
> +#define REG_INT_MASK_DDC	0x0019
> +#define REG_INT_MASK_RATE	0x001A
> +#define REG_INT_MASK_MODE	0x001B
> +#define REG_INT_MASK_INFO	0x001C
> +#define REG_INT_MASK_AUDIO	0x001D
> +#define REG_INT_MASK_HDCP	0x001E
> +#define REG_INT_MASK_AFE	0x001F
> +#define REG_DETECT_5V		0x0020
> +#define REG_SUS_STATUS		0x0021
> +#define REG_V_PER		0x0022
> +#define REG_H_PER		0x0025
> +#define REG_HS_WIDTH		0x0027
> +#define REG_FMT_H_TOT		0x0029
> +#define REG_FMT_H_ACT		0x002b
> +#define REG_FMT_H_FRONT		0x002d
> +#define REG_FMT_H_SYNC		0x002f
> +#define REG_FMT_H_BACK		0x0031
> +#define REG_FMT_V_TOT		0x0033
> +#define REG_FMT_V_ACT		0x0035
> +#define REG_FMT_V_FRONT_F1	0x0037
> +#define REG_FMT_V_FRONT_F2	0x0038
> +#define REG_FMT_V_SYNC		0x0039
> +#define REG_FMT_V_BACK_F1	0x003a
> +#define REG_FMT_V_BACK_F2	0x003b
> +#define REG_FMT_DE_ACT		0x003c
> +#define REG_RATE_CTRL		0x0040
> +#define REG_CLK_MIN_RATE	0x0043
> +#define REG_CLK_MAX_RATE	0x0046
> +#define REG_CLK_A_STATUS	0x0049
> +#define REG_CLK_A_RATE		0x004A
> +#define REG_DRIFT_CLK_A_REG	0x004D
> +#define REG_CLK_B_STATUS	0x004E
> +#define REG_CLK_B_RATE		0x004F
> +#define REG_DRIFT_CLK_B_REG	0x0052
> +#define REG_HDCP_CTRL		0x0060
> +#define REG_HDCP_KDS		0x0061
> +#define REG_HDCP_BCAPS		0x0063
> +#define REG_HDCP_KEY_CTRL	0x0064
> +#define REG_INFO_CTRL		0x0076
> +#define REG_INFO_EXCEED		0x0077
> +#define REG_PIX_REPEAT		0x007B
> +#define REG_AUDIO_PATH		0x007C
> +#define REG_AUDCFG		0x007D
> +#define REG_AUDIO_OUT_ENABLE	0x007E
> +#define REG_AUDIO_OUT_HIZ	0x007F
> +#define REG_VDP_CTRL		0x0080
> +#define REG_VDP_MATRIX		0x0081
> +#define REG_VHREF_CTRL		0x00A0
> +#define REG_PXCNT_PR		0x00A2
> +#define REG_PXCNT_NPIX		0x00A4
> +#define REG_LCNT_PR		0x00A6
> +#define REG_LCNT_NLIN		0x00A8
> +#define REG_HREF_S		0x00AA
> +#define REG_HREF_E		0x00AC
> +#define REG_HS_S		0x00AE
> +#define REG_HS_E		0x00B0
> +#define REG_VREF_F1_S		0x00B2
> +#define REG_VREF_F1_WIDTH	0x00B4
> +#define REG_VREF_F2_S		0x00B5
> +#define REG_VREF_F2_WIDTH	0x00B7
> +#define REG_VS_F1_LINE_S	0x00B8
> +#define REG_VS_F1_LINE_WIDTH	0x00BA
> +#define REG_VS_F2_LINE_S	0x00BB
> +#define REG_VS_F2_LINE_WIDTH	0x00BD
> +#define REG_VS_F1_PIX_S		0x00BE
> +#define REG_VS_F1_PIX_E		0x00C0
> +#define REG_VS_F2_PIX_S		0x00C2
> +#define REG_VS_F2_PIX_E		0x00C4
> +#define REG_FREF_F1_S		0x00C6
> +#define REG_FREF_F2_S		0x00C8
> +#define REG_FDW_S		0x00ca
> +#define REG_FDW_E		0x00cc
> +#define REG_BLK_GY		0x00da
> +#define REG_BLK_BU		0x00dc
> +#define REG_BLK_RV		0x00de
> +#define REG_FILTERS_CTRL	0x00e0
> +#define REG_DITHERING_CTRL	0x00E9
> +#define REG_OF			0x00EA
> +#define REG_PCLK		0x00EB
> +#define REG_HS_HREF		0x00EC
> +#define REG_VS_VREF		0x00ED
> +#define REG_DE_FREF		0x00EE
> +#define REG_VP35_32_CTRL	0x00EF
> +#define REG_VP31_28_CTRL	0x00F0
> +#define REG_VP27_24_CTRL	0x00F1
> +#define REG_VP23_20_CTRL	0x00F2
> +#define REG_VP19_16_CTRL	0x00F3
> +#define REG_VP15_12_CTRL	0x00F4
> +#define REG_VP11_08_CTRL	0x00F5
> +#define REG_VP07_04_CTRL	0x00F6
> +#define REG_VP03_00_CTRL	0x00F7
> +#define REG_CURPAGE_00H		0xFF
> +
> +#define MASK_VPER		0x3fffff
> +#define MASK_VHREF		0x3fff
> +#define MASK_HPER		0x0fff
> +#define MASK_HSWIDTH		0x03ff
> +
> +/* HPD Detection */
> +#define DETECT_UTIL		BIT(7)	/* utility of HDMI level */
> +#define DETECT_HPD		BIT(6)	/* HPD of HDMI level */
> +#define DETECT_5V_SEL		BIT(2)	/* 5V present on selected input */
> +#define DETECT_5V_B		BIT(1)	/* 5V present on input B */
> +#define DETECT_5V_A		BIT(0)	/* 5V present on input A */
> +
> +/* Input Select */
> +#define INPUT_SEL_RST_FMT	BIT(7)	/* 1=reset format measurement */
> +#define INPUT_SEL_RST_VDP	BIT(2)	/* 1=reset video data path */
> +#define INPUT_SEL_OUT_MODE	BIT(1)	/* 0=loop 1=bypass */
> +#define INPUT_SEL_B		BIT(0)	/* 0=inputA 1=inputB */
> +
> +/* Service Mode */
> +#define SVC_MODE_CLK2_MASK	0xc0
> +#define SVC_MODE_CLK2_SHIFT	6
> +#define SVC_MODE_CLK2_XTL	0L
> +#define SVC_MODE_CLK2_XTLDIV2	1L
> +#define SVC_MODE_CLK2_HDMIX2	3L
> +#define SVC_MODE_CLK1_MASK	0x30
> +#define SVC_MODE_CLK1_SHIFT	4
> +#define SVC_MODE_CLK1_XTAL	0L
> +#define SVC_MODE_CLK1_XTLDIV2	1L
> +#define SVC_MODE_CLK1_HDMI	3L
> +#define SVC_MODE_RAMP		BIT(3)	/* 0=colorbar 1=ramp */
> +#define SVC_MODE_PAL		BIT(2)	/* 0=NTSC(480i/p) 1=PAL(576i/p) */
> +#define SVC_MODE_INT_PROG	BIT(1)	/* 0=interlaced 1=progressive */
> +#define SVC_MODE_SM_ON		BIT(0)	/* Enable color bars and tone gen */
> +
> +/* HDP Manual Control */
> +#define HPD_MAN_CTRL_HPD_PULSE	BIT(7)	/* HPD Pulse low 110ms */
> +#define HPD_MAN_CTRL_5VEN	BIT(2)	/* Output 5V */
> +#define HPD_MAN_CTRL_HPD_B	BIT(1)	/* Assert HPD High for Input A */
> +#define HPD_MAN_CTRL_HPD_A	BIT(0)	/* Assert HPD High for Input A */
> +
> +/* RT_MAN_CTRL */
> +#define RT_MAN_CTRL_RT_AUTO	BIT(7)
> +#define RT_MAN_CTRL_RT		BIT(6)
> +#define RT_MAN_CTRL_RT_B	BIT(1)	/* enable TMDS pull-up on Input B */
> +#define RT_MAN_CTRL_RT_A	BIT(0)	/* enable TMDS pull-up on Input A */
> +
> +/* VDP_CTRL */
> +#define VDP_CTRL_COMPDEL_BP	BIT(5)	/* bypass compdel */
> +#define VDP_CTRL_FORMATTER_BP	BIT(4)	/* bypass formatter */
> +#define VDP_CTRL_PREFILTER_BP	BIT(1)	/* bypass prefilter */
> +#define VDP_CTRL_MATRIX_BP	BIT(0)	/* bypass matrix conversion */
> +
> +/* REG_VHREF_CTRL */
> +#define VHREF_INT_DET		BIT(7)	/* interlace detect: 1=alt 0=frame */
> +#define VHREF_VSYNC_MASK	0x60
> +#define VHREF_VSYNC_SHIFT	6
> +#define VHREF_VSYNC_AUTO	0L
> +#define VHREF_VSYNC_FDW		1L
> +#define VHREF_VSYNC_EVEN	2L
> +#define VHREF_VSYNC_ODD		3L
> +#define VHREF_STD_DET_MASK	0x18
> +#define VHREF_STD_DET_SHIFT	3
> +#define VHREF_STD_DET_PAL	0L
> +#define VHREF_STD_DET_NTSC	1L
> +#define VHREF_STD_DET_AUTO	2L
> +#define VHREF_STD_DET_OFF	3L
> +#define VHREF_VREF_SRC_STD	BIT(2)	/* 1=from standard 0=manual */
> +#define VHREF_HREF_SRC_STD	BIT(1)	/* 1=from standard 0=manual */
> +#define VHREF_HSYNC_SEL_HS	BIT(0)	/* 1=HS 0=VS */
> +
> +/* AUDIO_OUT_ENABLE */
> +#define AUDIO_OUT_ENABLE_ACLK	BIT(5)
> +#define AUDIO_OUT_ENABLE_WS	BIT(4)
> +#define AUDIO_OUT_ENABLE_AP3	BIT(3)
> +#define AUDIO_OUT_ENABLE_AP2	BIT(2)
> +#define AUDIO_OUT_ENABLE_AP1	BIT(1)
> +#define AUDIO_OUT_ENABLE_AP0	BIT(0)
> +
> +/* Prefilter Control */
> +#define FILTERS_CTRL_BU_MASK	0x0c
> +#define FILTERS_CTRL_BU_SHIFT	2
> +#define FILTERS_CTRL_RV_MASK	0x03
> +#define FILTERS_CTRL_RV_SHIFT	0
> +#define FILTERS_CTRL_OFF	0L	/* off */
> +#define FILTERS_CTRL_2TAP	1L	/* 2 Taps */
> +#define FILTERS_CTRL_7TAP	2L	/* 7 Taps */
> +#define FILTERS_CTRL_2_7TAP	3L	/* 2/7 Taps */
> +
> +/* PCLK Configuration */
> +#define PCLK_DELAY_MASK		0x70
> +#define PCLK_DELAY_SHIFT	4	/* Pixel delay (-8..+7) */
> +#define PCLK_INV_SHIFT		2
> +#define PCLK_SEL_MASK		0x03	/* clock scaler */
> +#define PCLK_SEL_SHIFT		0
> +#define PCLK_SEL_X1		0L
> +#define PCLK_SEL_X2		1L
> +#define PCLK_SEL_DIV2		2L
> +#define PCLK_SEL_DIV4		3L
> +
> +/* Pixel Repeater */
> +#define PIX_REPEAT_MASK_UP_SEL	0x30
> +#define PIX_REPEAT_MASK_REP	0x0f
> +#define PIX_REPEAT_SHIFT	4
> +#define PIX_REPEAT_CHROMA	1
> +
> +/* Page 0x01 - HDMI info and packets */
> +#define REG_HDMI_FLAGS		0x0100
> +#define REG_DEEP_COLOR_MODE	0x0101
> +#define REG_AUDIO_FLAGS		0x0108
> +#define REG_AUDIO_FREQ		0x0109
> +#define REG_ACP_PACKET_TYPE	0x0141
> +#define REG_ISRC1_PACKET_TYPE	0x0161
> +#define REG_ISRC2_PACKET_TYPE	0x0181
> +#define REG_GBD_PACKET_TYPE	0x01a1
> +
> +/* HDMI_FLAGS */
> +#define HDMI_FLAGS_AUDIO	BIT(7)	/* Audio packet in last videoframe */
> +#define HDMI_FLAGS_HDMI		BIT(6)	/* HDMI detected */
> +#define HDMI_FLAGS_EESS		BIT(5)	/* EESS detected */
> +#define HDMI_FLAGS_HDCP		BIT(4)	/* HDCP detected */
> +#define HDMI_FLAGS_AVMUTE	BIT(3)	/* AVMUTE */
> +#define HDMI_FLAGS_AUD_LAYOUT	BIT(2)	/* Layout status Audio sample packet */
> +#define HDMI_FLAGS_AUD_FIFO_OF	BIT(1)	/* FIFO read/write pointers crossed */
> +#define HDMI_FLAGS_AUD_FIFO_LOW	BIT(0)	/* FIFO read ptr within 2 of write */
> +
> +/* Page 0x12 - HDMI Extra control and debug */
> +#define REG_CLK_CFG		0x1200
> +#define REG_CLK_OUT_CFG		0x1201
> +#define REG_CFG1		0x1202
> +#define REG_CFG2		0x1203
> +#define REG_WDL_CFG		0x1210
> +#define REG_DELOCK_DELAY	0x1212
> +#define REG_PON_OVR_EN		0x12A0
> +#define REG_PON_CBIAS		0x12A1
> +#define REG_PON_RESCAL		0x12A2
> +#define REG_PON_RES		0x12A3
> +#define REG_PON_CLK		0x12A4
> +#define REG_PON_PLL		0x12A5
> +#define REG_PON_EQ		0x12A6
> +#define REG_PON_DES		0x12A7
> +#define REG_PON_OUT		0x12A8
> +#define REG_PON_MUX		0x12A9
> +#define REG_MODE_REC_CFG1	0x12F8
> +#define REG_MODE_REC_CFG2	0x12F9
> +#define REG_MODE_REC_STS	0x12FA
> +#define REG_AUDIO_LAYOUT	0x12D0
> +
> +#define PON_EN			1
> +#define PON_DIS			0
> +
> +/* CLK CFG */
> +#define CLK_CFG_INV_OUT_CLK	BIT(7)
> +#define CLK_CFG_INV_BUS_CLK	BIT(6)
> +#define CLK_CFG_SEL_ACLK_EN	BIT(1)
> +#define CLK_CFG_SEL_ACLK	BIT(0)
> +#define CLK_CFG_DIS		0
> +
> +/* Page 0x13 - HDMI Extra control and debug */
> +#define REG_DEEP_COLOR_CTRL	0x1300
> +#define REG_CGU_DBG_SEL		0x1305
> +#define REG_HDCP_DDC_ADDR	0x1310
> +#define REG_HDCP_KIDX		0x1316
> +#define REG_DEEP_PLL7_BYP	0x1347
> +#define REG_HDCP_DE_CTRL	0x1370
> +#define REG_HDCP_EP_FILT_CTRL	0x1371
> +#define REG_HDMI_CTRL		0x1377
> +#define REG_HMTP_CTRL		0x137a
> +#define REG_TIMER_D		0x13CF
> +#define REG_SUS_SET_RGB0	0x13E1
> +#define REG_SUS_SET_RGB1	0x13E2
> +#define REG_SUS_SET_RGB2	0x13E3
> +#define REG_SUS_SET_RGB3	0x13E4
> +#define REG_SUS_SET_RGB4	0x13E5
> +#define REG_MAN_SUS_HDMI_SEL	0x13E8
> +#define REG_MAN_HDMI_SET	0x13E9
> +#define REG_SUS_CLOCK_GOOD	0x13EF
> +
> +/* HDCP DE Control */
> +#define HDCP_DE_MODE_MASK	0xc0	/* DE Measurement mode */
> +#define HDCP_DE_MODE_SHIFT	6
> +#define HDCP_DE_REGEN_EN	BIT(5)	/* enable regen mode */
> +#define HDCP_DE_FILTER_MASK	0x18	/* DE filter sensitivity */
> +#define HDCP_DE_FILTER_SHIFT	3
> +#define HDCP_DE_COMP_MASK	0x07	/* DE Composition mode */
> +#define HDCP_DE_COMP_MIXED	6L
> +#define HDCP_DE_COMP_OR		5L
> +#define HDCP_DE_COMP_AND	4L
> +#define HDCP_DE_COMP_CH3	3L
> +#define HDCP_DE_COMP_CH2	2L
> +#define HDCP_DE_COMP_CH1	1L
> +#define HDCP_DE_COMP_CH0	0L
> +
> +/* HDCP EP Filter Control */
> +#define HDCP_EP_FIL_CTL_MASK	0x30
> +#define HDCP_EP_FIL_CTL_SHIFT	4
> +#define HDCP_EP_FIL_VS_MASK	0x0c
> +#define HDCP_EP_FIL_VS_SHIFT	2
> +#define HDCP_EP_FIL_HS_MASK	0x03
> +#define HDCP_EP_FIL_HS_SHIFT	0
> +
> +/* HDMI_CTRL */
> +#define HDMI_CTRL_MUTE_MASK	0x0c
> +#define HDMI_CTRL_MUTE_SHIFT	2
> +#define HDMI_CTRL_MUTE_AUTO	0L
> +#define HDMI_CTRL_MUTE_OFF	1L
> +#define HDMI_CTRL_MUTE_ON	2L
> +#define HDMI_CTRL_HDCP_MASK	0x03
> +#define HDMI_CTRL_HDCP_SHIFT	0
> +#define HDMI_CTRL_HDCP_EESS	2L
> +#define HDMI_CTRL_HDCP_OESS	1L
> +#define HDMI_CTRL_HDCP_AUTO	0L
> +
> +/* CGU_DBG_SEL bits */
> +#define CGU_DBG_CLK_SEL_MASK	0x18
> +#define CGU_DBG_CLK_SEL_SHIFT	3
> +#define CGU_DBG_XO_FRO_SEL	BIT(2)
> +#define CGU_DBG_VDP_CLK_SEL	BIT(1)
> +#define CGU_DBG_PIX_CLK_SEL	BIT(0)
> +
> +/* REG_MAN_SUS_HDMI_SEL / REG_MAN_HDMI_SET bits */
> +#define MAN_DIS_OUT_BUF		BIT(7)
> +#define MAN_DIS_ANA_PATH	BIT(6)
> +#define MAN_DIS_HDCP		BIT(5)
> +#define MAN_DIS_TMDS_ENC	BIT(4)
> +#define MAN_DIS_TMDS_FLOW	BIT(3)
> +#define MAN_RST_HDCP		BIT(2)
> +#define MAN_RST_TMDS_ENC	BIT(1)
> +#define MAN_RST_TMDS_FLOW	BIT(0)
> +
> +/* Page 0x14 - Audio Extra control and debug */
> +#define REG_FIFO_LATENCY_VAL	0x1403
> +#define REG_AUDIO_CLOCK		0x1411
> +#define REG_TEST_NCTS_CTRL	0x1415
> +#define REG_TEST_AUDIO_FREQ	0x1426
> +#define REG_TEST_MODE		0x1437
> +
> +/* Audio Clock Configuration */
> +#define AUDIO_CLOCK_PLL_PD	BIT(7)	/* powerdown PLL */
> +#define AUDIO_CLOCK_SEL_MASK	0x7f
> +#define AUDIO_CLOCK_SEL_16FS	0L	/* 16*fs */
> +#define AUDIO_CLOCK_SEL_32FS	1L	/* 32*fs */
> +#define AUDIO_CLOCK_SEL_64FS	2L	/* 64*fs */
> +#define AUDIO_CLOCK_SEL_128FS	3L	/* 128*fs */
> +#define AUDIO_CLOCK_SEL_256FS	4L	/* 256*fs */
> +#define AUDIO_CLOCK_SEL_512FS	5L	/* 512*fs */
> +
> +/* Page 0x20: EDID and Hotplug Detect */
> +#define REG_EDID_IN_BYTE0	0x2000 /* EDID base */
> +#define REG_EDID_IN_VERSION	0x2080
> +#define REG_EDID_ENABLE		0x2081
> +#define REG_HPD_POWER		0x2084
> +#define REG_HPD_AUTO_CTRL	0x2085
> +#define REG_HPD_DURATION	0x2086
> +#define REG_RX_HPD_HEAC		0x2087
> +
> +/* EDID_ENABLE */
> +#define EDID_ENABLE_NACK_OFF	BIT(7)
> +#define EDID_ENABLE_EDID_ONLY	BIT(6)
> +#define EDID_ENABLE_B_EN	BIT(1)
> +#define EDID_ENABLE_A_EN	BIT(0)
> +
> +/* HPD Power */
> +#define HPD_POWER_BP_MASK	0x0c
> +#define HPD_POWER_BP_SHIFT	2
> +#define HPD_POWER_BP_LOW	0L
> +#define HPD_POWER_BP_HIGH	1L
> +#define HPD_POWER_EDID_ONLY	BIT(1)
> +
> +/* HPD Auto control */
> +#define HPD_AUTO_READ_EDID	BIT(7)
> +#define HPD_AUTO_HPD_F3TECH	BIT(5)
> +#define HPD_AUTO_HP_OTHER	BIT(4)
> +#define HPD_AUTO_HPD_UNSEL	BIT(3)
> +#define HPD_AUTO_HPD_ALL_CH	BIT(2)
> +#define HPD_AUTO_HPD_PRV_CH	BIT(1)
> +#define HPD_AUTO_HPD_NEW_CH	BIT(0)
> +
> +/* Page 0x21 - EDID content */
> +#define REG_EDID_IN_BYTE128	0x2100 /* CEA Extension block */
> +#define REG_EDID_IN_SPA_SUB	0x2180
> +#define REG_EDID_IN_SPA_AB_A	0x2181
> +#define REG_EDID_IN_SPA_CD_A	0x2182
> +#define REG_EDID_IN_CKSUM_A	0x2183
> +#define REG_EDID_IN_SPA_AB_B	0x2184
> +#define REG_EDID_IN_SPA_CD_B	0x2185
> +#define REG_EDID_IN_CKSUM_B	0x2186
> +
> +/* Page 0x30 - NV Configuration */
> +#define REG_RT_AUTO_CTRL	0x3000
> +#define REG_EQ_MAN_CTRL0	0x3001
> +#define REG_EQ_MAN_CTRL1	0x3002
> +#define REG_OUTPUT_CFG		0x3003
> +#define REG_MUTE_CTRL		0x3004
> +#define REG_SLAVE_ADDR		0x3005
> +#define REG_CMTP_REG6		0x3006
> +#define REG_CMTP_REG7		0x3007
> +#define REG_CMTP_REG8		0x3008
> +#define REG_CMTP_REG9		0x3009
> +#define REG_CMTP_REGA		0x300A
> +#define REG_CMTP_REGB		0x300B
> +#define REG_CMTP_REGC		0x300C
> +#define REG_CMTP_REGD		0x300D
> +#define REG_CMTP_REGE		0x300E
> +#define REG_CMTP_REGF		0x300F
> +#define REG_CMTP_REG10		0x3010
> +#define REG_CMTP_REG11		0x3011
> +
> +/* Page 0x80 - CEC */
> +#define REG_PWR_CONTROL		0x80F4
> +#define REG_OSC_DIVIDER		0x80F5
> +#define REG_EN_OSC_PERIOD_LSB	0x80F8
> +#define REG_CONTROL		0x80FF
> +
> +/* global interrupt flags (INT_FLG_CRL_TOP) */
> +#define INTERRUPT_AFE		BIT(7) /* AFE module */
> +#define INTERRUPT_HDCP		BIT(6) /* HDCP module */
> +#define INTERRUPT_AUDIO		BIT(5) /* Audio module */
> +#define INTERRUPT_INFO		BIT(4) /* Infoframe module */
> +#define INTERRUPT_MODE		BIT(3) /* HDMI mode module */
> +#define INTERRUPT_RATE		BIT(2) /* rate module */
> +#define INTERRUPT_DDC		BIT(1) /* DDC module */
> +#define INTERRUPT_SUS		BIT(0) /* SUS module */
> +
> +/* INT_FLG_CLR_HDCP bits */
> +#define MASK_HDCP_MTP		BIT(7) /* HDCP MTP busy */
> +#define MASK_HDCP_DLMTP		BIT(4) /* HDCP end download MTP to SRAM */
> +#define MASK_HDCP_DLRAM		BIT(3) /* HDCP end download keys from SRAM */
> +#define MASK_HDCP_ENC		BIT(2) /* HDCP ENC */
> +#define MASK_STATE_C5		BIT(1) /* HDCP State C5 reached */
> +#define MASK_AKSV		BIT(0) /* AKSV received (start of auth) */
> +
> +/* INT_FLG_CLR_RATE bits */
> +#define MASK_RATE_B_DRIFT	BIT(7) /* Rate measurement drifted */
> +#define MASK_RATE_B_ST		BIT(6) /* Rate measurement stability change */
> +#define MASK_RATE_B_ACT		BIT(5) /* Rate measurement activity change */
> +#define MASK_RATE_B_PST		BIT(4) /* Rate measreument presence change */
> +#define MASK_RATE_A_DRIFT	BIT(3) /* Rate measurement drifted */
> +#define MASK_RATE_A_ST		BIT(2) /* Rate measurement stability change */
> +#define MASK_RATE_A_ACT		BIT(1) /* Rate measurement presence change */
> +#define MASK_RATE_A_PST		BIT(0) /* Rate measreument presence change */
> +
> +/* INT_FLG_CLR_SUS (Start Up Sequencer) bits */
> +#define MASK_MPT		BIT(7) /* Config MTP end of process */
> +#define MASK_FMT		BIT(5) /* Video format changed */
> +#define MASK_RT_PULSE		BIT(4) /* End of termination resistance pulse */
> +#define MASK_SUS_END		BIT(3) /* SUS last state reached */
> +#define MASK_SUS_ACT		BIT(2) /* Activity of selected input changed */
> +#define MASK_SUS_CH		BIT(1) /* Selected input changed */
> +#define MASK_SUS_ST		BIT(0) /* SUS state changed */
> +
> +/* INT_FLG_CLR_DDC bits */
> +#define MASK_EDID_MTP		BIT(7) /* EDID MTP end of process */
> +#define MASK_DDC_ERR		BIT(6) /* master DDC error */
> +#define MASK_DDC_CMD_DONE	BIT(5) /* master DDC cmd send correct */
> +#define MASK_READ_DONE		BIT(4) /* End of down EDID read */
> +#define MASK_RX_DDC_SW		BIT(3) /* Output DDC switching finished */
> +#define MASK_HDCP_DDC_SW	BIT(2) /* HDCP DDC switching finished */
> +#define MASK_HDP_PULSE_END	BIT(1) /* End of Hot Plug Detect pulse */
> +#define MASK_DET_5V		BIT(0) /* Detection of +5V */
> +
> +/* INT_FLG_CLR_MODE bits */
> +#define MASK_HDMI_FLG		BIT(7) /* HDMI mode/avmute/encrypt/FIFO fail */
> +#define MASK_GAMUT		BIT(6) /* Gamut packet */
> +#define MASK_ISRC2		BIT(5) /* ISRC2 packet */
> +#define MASK_ISRC1		BIT(4) /* ISRC1 packet */
> +#define MASK_ACP		BIT(3) /* Audio Content Protection packet */
> +#define MASK_DC_NO_GCP		BIT(2) /* GCP not received in 5 frames */
> +#define MASK_DC_PHASE		BIT(1) /* deepcolor pixel phase needs update */
> +#define MASK_DC_MODE		BIT(0) /* deepcolor color depth changed */
> +
> +/* INT_FLG_CLR_INFO bits (Infoframe Change Status) */
> +#define MASK_MPS_IF		BIT(6) /* MPEG Source Product */
> +#define MASK_AUD_IF		BIT(5) /* Audio */
> +#define MASK_SPD_IF		BIT(4) /* Source Product Descriptor */
> +#define MASK_AVI_IF		BIT(3) /* Auxiliary Video IF */
> +#define MASK_VS_IF_OTHER_BK2	BIT(2) /* Vendor Specific (bank2) */
> +#define MASK_VS_IF_OTHER_BK1	BIT(1) /* Vendor Specific (bank1) */
> +#define MASK_VS_IF_HDMI		BIT(0) /* Vendor Specific (w/ HDMI LLC code) */
> +
> +/* INT_FLG_CLR_AUDIO bits */
> +#define MASK_AUDIO_FREQ_FLG	BIT(5) /* Audio freq change */
> +#define MASK_AUDIO_FLG		BIT(4) /* DST, OBA, HBR, ASP change */
> +#define MASK_MUTE_FLG		BIT(3) /* Audio Mute */
> +#define MASK_CH_STATE		BIT(2) /* Channel status */
> +#define MASK_UNMUTE_FIFO	BIT(1) /* Audio Unmute */
> +#define MASK_ERROR_FIFO_PT	BIT(0) /* Audio FIFO pointer error */
> +
> +/* INT_FLG_CLR_AFE bits */
> +#define MASK_AFE_WDL_UNLOCKED	BIT(7) /* Wordlocker was unlocked */
> +#define MASK_AFE_GAIN_DONE	BIT(6) /* Gain calibration done */
> +#define MASK_AFE_OFFSET_DONE	BIT(5) /* Offset calibration done */
> +#define MASK_AFE_ACTIVITY_DET	BIT(4) /* Activity detected on data */
> +#define MASK_AFE_PLL_LOCK	BIT(3) /* TMDS PLL is locked */
> +#define MASK_AFE_TRMCAL_DONE	BIT(2) /* Termination calibration done */
> +#define MASK_AFE_ASU_STATE	BIT(1) /* ASU state is reached */
> +#define MASK_AFE_ASU_READY	BIT(0) /* AFE calibration done: TMDS ready */
> +
> +/* Audio Output */
> +#define AUDCFG_CLK_INVERT	BIT(7)	/* invert A_CLK polarity */
> +#define AUDCFG_TEST_TONE	BIT(6)	/* enable test tone generator */
> +#define AUDCFG_BUS_SHIFT	5
> +#define AUDCFG_BUS_I2S		0L
> +#define AUDCFG_BUS_SPDIF	1L
> +#define AUDCFG_I2SW_SHIFT	4
> +#define AUDCFG_I2SW_16		0L
> +#define AUDCFG_I2SW_32		1L
> +#define AUDCFG_AUTO_MUTE_EN	BIT(3)	/* Enable Automatic audio mute */
> +#define AUDCFG_HBR_SHIFT	2
> +#define AUDCFG_HBR_STRAIGHT	0L	/* straight via AP0 */
> +#define AUDCFG_HBR_DEMUX	1L	/* demuxed via AP0:AP3 */
> +#define AUDCFG_TYPE_MASK	0x03
> +#define AUDCFG_TYPE_SHIFT	0
> +#define AUDCFG_TYPE_DST		3L	/* Direct Stream Transfer (DST) */
> +#define AUDCFG_TYPE_OBA		2L	/* One Bit Audio (OBA) */
> +#define AUDCFG_TYPE_HBR		1L	/* High Bit Rate (HBR) */
> +#define AUDCFG_TYPE_PCM		0L	/* Audio samples */
> +
> +/* Video Formatter */
> +#define OF_VP_ENABLE		BIT(7)	/* VP[35:0]/HS/VS/DE/CLK */
> +#define OF_BLK			BIT(4)	/* blanking codes */
> +#define OF_TRC			BIT(3)	/* timing codes (SAV/EAV) */
> +#define OF_FMT_MASK		0x3
> +#define OF_FMT_444		0L	/* RGB444/YUV444 */
> +#define OF_FMT_422_SMPT		1L	/* YUV422 semi-planar */
> +#define OF_FMT_422_CCIR		2L	/* YUV422 CCIR656 */
> +
> +/* HS/HREF output control */
> +#define HS_HREF_DELAY_MASK	0xf0
> +#define HS_HREF_DELAY_SHIFT	4	/* Pixel delay (-8..+7) */
> +#define HS_HREF_PXQ_SHIFT	3	/* Timing codes from HREF */
> +#define HS_HREF_INV_SHIFT	2	/* polarity (1=invert) */
> +#define HS_HREF_SEL_MASK	0x03
> +#define HS_HREF_SEL_SHIFT	0
> +#define HS_HREF_SEL_HS_VHREF	0L	/* HS from VHREF */
> +#define HS_HREF_SEL_HREF_VHREF	1L	/* HREF from VHREF */
> +#define HS_HREF_SEL_HREF_HDMI	2L	/* HREF from HDMI */
> +#define HS_HREF_SEL_NONE	3L	/* not generated */
> +
> +/* VS output control */
> +#define VS_VREF_DELAY_MASK	0xf0
> +#define VS_VREF_DELAY_SHIFT	4	/* Pixel delay (-8..+7) */
> +#define VS_VREF_INV_SHIFT	2	/* polarity (1=invert) */
> +#define VS_VREF_SEL_MASK	0x03
> +#define VS_VREF_SEL_SHIFT	0
> +#define VS_VREF_SEL_VS_VHREF	0L	/* VS from VHREF */
> +#define VS_VREF_SEL_VREF_VHREF	1L	/* VREF from VHREF */
> +#define VS_VREF_SEL_VREF_HDMI	2L	/* VREF from HDMI */
> +#define VS_VREF_SEL_NONE	3L	/* not generated */
> +
> +/* DE/FREF output control */
> +#define DE_FREF_DELAY_MASK	0xf0
> +#define DE_FREF_DELAY_SHIFT	4	/* Pixel delay (-8..+7) */
> +#define DE_FREF_DE_PXQ_SHIFT	3	/* Timing codes from DE */
> +#define DE_FREF_INV_SHIFT	2	/* polarity (1=invert) */
> +#define DE_FREF_SEL_MASK	0x03
> +#define DE_FREF_SEL_SHIFT	0
> +#define DE_FREF_SEL_DE_VHREF	0L	/* DE from VHREF (HREF and not(VREF) */
> +#define DE_FREF_SEL_FREF_VHREF	1L	/* FREF from VHREF */
> +#define DE_FREF_SEL_FREF_HDMI	2L	/* FREF from HDMI */
> +#define DE_FREF_SEL_NONE	3L	/* not generated */
> +
> +/* HDMI_SOFT_RST bits */
> +#define RESET_DC		BIT(7)	/* Reset deep color module */
> +#define RESET_HDCP		BIT(6)	/* Reset HDCP module */
> +#define RESET_KSV		BIT(5)	/* Reset KSV-FIFO */
> +#define RESET_SCFG		BIT(4)	/* Reset HDCP and repeater function */
> +#define RESET_HCFG		BIT(3)	/* Reset HDCP DDC part */
> +#define RESET_PA		BIT(2)	/* Reset polarity adjust */
> +#define RESET_EP		BIT(1)	/* Reset Error protection */
> +#define RESET_TMDS		BIT(0)	/* Reset TMDS (calib, encoding, flow) */
> +
> +/* HDMI_INFO_RST bits */
> +#define NACK_HDCP		BIT(7)	/* No ACK on HDCP request */
> +#define RESET_FIFO		BIT(4)	/* Reset Audio FIFO control */
> +#define RESET_GAMUT		BIT(3)	/* Clear Gamut packet */
> +#define RESET_AI		BIT(2)	/* Clear ACP and ISRC packets */
> +#define RESET_IF		BIT(1)	/* Clear all Audio infoframe packets */
> +#define RESET_AUDIO		BIT(0)	/* Reset Audio FIFO control */
> +
> +/* HDCP_BCAPS bits */
> +#define HDCP_HDMI		BIT(7)	/* HDCP suports HDMI (vs DVI only) */
> +#define HDCP_REPEATER		BIT(6)	/* HDCP supports repeater function */
> +#define HDCP_READY		BIT(5)	/* set by repeater function */
> +#define HDCP_FAST		BIT(4)	/* Up to 400kHz */
> +#define HDCP_11			BIT(1)	/* HDCP 1.1 supported */
> +#define HDCP_FAST_REAUTH	BIT(0)	/* fast reauthentication supported */
> +
> +/* Audio output formatter */
> +#define AUDIO_LAYOUT_SP_FLAG	BIT(2)	/* sp flag used by FIFO */
> +#define AUDIO_LAYOUT_MANUAL	BIT(1)	/* manual layout (vs per pkt) */
> +#define AUDIO_LAYOUT_LAYOUT1	BIT(0)  /* Layout1: AP0-3 vs Layout0:AP0 */
> +
> +/* masks for interrupt status registers */
> +#define MASK_SUS_STATUS		0x1F
> +#define LAST_STATE_REACHED	0x1B
> +#define MASK_CLK_STABLE		0x04
> +#define MASK_CLK_ACTIVE		0x02
> +#define MASK_SUS_STATE		0x10
> +#define MASK_SR_FIFO_FIFO_CTRL	0x30
> +#define MASK_AUDIO_FLAG		0x10
> +
> +/* Rate measurement */
> +#define RATE_REFTIM_ENABLE	0x01
> +#define CLK_MIN_RATE		0x0057e4
> +#define CLK_MAX_RATE		0x0395f8
> +#define WDL_CFG_VAL		0x82
> +#define DC_FILTER_VAL		0x31
> +
> +/* Infoframe */
> +#define VS_HDMI_IF_UPDATE	0x0200
> +#define VS_HDMI_IF		0x0201
> +#define VS_BK1_IF_UPDATE	0x0220
> +#define VS_BK1_IF		0x0221
> +#define VS_BK2_IF_UPDATE	0x0240
> +#define VS_BK2_IF		0x0241
> +#define AVI_IF_UPDATE		0x0260
> +#define AVI_IF			0x0261
> +#define SPD_IF_UPDATE		0x0280
> +#define SPD_IF			0x0281
> +#define AUD_IF_UPDATE		0x02a0
> +#define AUD_IF			0x02a1
> +#define MPS_IF_UPDATE		0x02c0
> +#define MPS_IF			0x02c1

May I suggest to split this off into a tda1997x-regs.h?
It's up to you, but I think it makes the source easier to
manage.

> +
> +/* Audio formats */
> +static const char * const audtype_names[] = {
> +	"PCM",			/* PCM Samples */
> +	"HBR",			/* High Bit Rate Audio */
> +	"OBA",			/* One-Bit Audio */
> +	"DST"			/* Direct Stream Transfer */
> +};
> +
> +/* Audio output port formats */
> +enum audfmt_types {
> +	AUDFMT_TYPE_DISABLED = 0,
> +	AUDFMT_TYPE_I2S,
> +	AUDFMT_TYPE_SPDIF,
> +};
> +static const char * const audfmt_names[] = {
> +	"Disabled",
> +	"I2S",
> +	"SPDIF",
> +};
> +
> +/* Video input formats */
> +static const char * const hdmi_colorspace_names[] = {
> +	"RGB", "YUV422", "YUV444", "YUV420", "", "", "", "",
> +};
> +static const char * const hdmi_colorimetry_names[] = {
> +	"", "ITU601", "ITU709", "Extended",
> +};
> +static const char * const v4l2_quantization_names[] = {
> +	"Default",
> +	"Rull Range (0-255)",
> +	"Limited Range (16-235)",
> +};
> +
> +/* Video output port formats */
> +static const char * const vidfmt_names[] = {
> +	"RGB444/YUV444",	/* RGB/YUV444 16bit data bus, 8bpp */
> +	"YUV422 semi-planar",	/* YUV422 16bit data base, 8bpp */
> +	"YUV422 CCIR656",	/* BT656 (YUV 8bpp 2 clock per pixel) */
> +	"Invalid",
> +};
> +
> +/*
> + * Colorspace conversion matrices
> + */
> +struct color_matrix_coefs {
> +	const char *name;
> +	/* Input offsets */
> +	s16 offint1;
> +	s16 offint2;
> +	s16 offint3;
> +	/* Coeficients */
> +	s16 p11coef;
> +	s16 p12coef;
> +	s16 p13coef;
> +	s16 p21coef;
> +	s16 p22coef;
> +	s16 p23coef;
> +	s16 p31coef;
> +	s16 p32coef;
> +	s16 p33coef;
> +	/* Output offsets */
> +	s16 offout1;
> +	s16 offout2;
> +	s16 offout3;
> +};
> +
> +enum {
> +	ITU709_RGBFULL,
> +	ITU601_RGBFULL,
> +	RGBLIMITED_RGBFULL,
> +	RGBLIMITED_ITU601,
> +	RGBLIMITED_ITU709,
> +	RGBFULL_ITU601,
> +	RGBFULL_ITU709,
> +};
> +
> +/* NB: 4096 is 1.0 using fixed point numbers */
> +static const struct color_matrix_coefs conv_matrix[] = {
> +	{
> +		"YUV709 -> RGB full",
> +		 -256, -2048,  -2048,
> +		 4769, -2183,   -873,
> +		 4769,  7343,      0,
> +		 4769,     0,   8652,
> +		    0,     0,      0,
> +	},
> +	{
> +		"YUV601 -> RGB full",
> +		 -256, -2048,  -2048,
> +		 4769, -3330,  -1602,
> +		 4769,  6538,      0,
> +		 4769,     0,   8264,
> +		  256,   256,    256,
> +	},
> +	{
> +		"RGB limited -> RGB full",
> +		 -256,  -256,   -256,
> +		    0,  4769,      0,
> +		    0,     0,   4769,
> +		 4769,     0,      0,
> +		    0,     0,      0,
> +	},
> +	{
> +		"RGB limited -> ITU601",
> +		 -256,  -256,   -256,
> +		 2404,  1225,    467,
> +		-1754,  2095,   -341,
> +		-1388,  -707,   2095,
> +		  256,  2048,   2048,
> +	},
> +	{
> +		"RGB limited -> ITU709",
> +		 -256,  -256,   -256,
> +		 2918,   867,    295,
> +		-1894,  2087,   -190,
> +		-1607,  -477,   2087,
> +		  256,  2048,   2048,
> +	},
> +	{
> +		"RGB full -> ITU601",
> +		    0,     0,      0,
> +		 2065,  1052,    401,
> +		-1506,  1799,   -293,
> +		-1192,  -607,   1799,
> +		  256,  2048,   2048,
> +	},
> +	{
> +		"RGB full -> ITU709",
> +		    0,     0,      0,
> +		 2506,   745,    253,
> +		-1627,  1792,   -163,
> +		-1380,  -410,   1792,
> +		  256,  2048,   2048,
> +	},
> +};
> +
> +static const struct v4l2_dv_timings_cap tda1997x_dv_timings_cap = {
> +	.type = V4L2_DV_BT_656_1120,
> +	/* keep this initialization for compatibility with GCC < 4.4.6 */
> +	.reserved = { 0 },
> +
> +	V4L2_INIT_BT_TIMINGS(
> +		640, 1920,			/* min/max width */
> +		480, 1080,			/* min/max height */
> +		13000000, 165000000,		/* min/max pixelclock */
> +		/* standards */
> +		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
> +			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
> +		/* capabilities */
> +		V4L2_DV_BT_CAP_INTERLACED | V4L2_DV_BT_CAP_PROGRESSIVE |
> +			V4L2_DV_BT_CAP_REDUCED_BLANKING |
> +			V4L2_DV_BT_CAP_CUSTOM
> +	)
> +};
> +
> +/*
> + * Video Input formats
> + */
> +static const struct v4l2_dv_timings tda1997x_hdmi_modes[] = {
> +	V4L2_DV_BT_DMT_640X350P85,
> +	V4L2_DV_BT_DMT_640X400P85,
> +	V4L2_DV_BT_DMT_640X480P60,
> +	V4L2_DV_BT_DMT_640X480P72,
> +	V4L2_DV_BT_DMT_640X480P75,
> +	V4L2_DV_BT_DMT_720X400P85,
> +	V4L2_DV_BT_CEA_720X480I59_94,
> +	V4L2_DV_BT_CEA_720X480P59_94,
> +	V4L2_DV_BT_CEA_720X576I50,
> +	V4L2_DV_BT_CEA_720X576P50,
> +	V4L2_DV_BT_DMT_800X600P60,
> +	V4L2_DV_BT_DMT_800X600P72,
> +	V4L2_DV_BT_DMT_800X600P75,
> +	V4L2_DV_BT_DMT_800X600P85,
> +	V4L2_DV_BT_DMT_1024X768P60,
> +	V4L2_DV_BT_DMT_1024X768P70,
> +	V4L2_DV_BT_DMT_1024X768P75,
> +	V4L2_DV_BT_DMT_1024X768P85,
> +	V4L2_DV_BT_CEA_1280X720P24,
> +	V4L2_DV_BT_CEA_1280X720P25,
> +	V4L2_DV_BT_CEA_1280X720P30,
> +	V4L2_DV_BT_CEA_1280X720P50,
> +	V4L2_DV_BT_CEA_1280X720P60,
> +	V4L2_DV_BT_DMT_1280X768P60_RB,
> +	V4L2_DV_BT_DMT_1280X768P75,
> +	V4L2_DV_BT_DMT_1280X768P85,
> +	V4L2_DV_BT_DMT_1280X960P60,
> +	V4L2_DV_BT_DMT_1280X1024P60,
> +	V4L2_DV_BT_DMT_1280X1024P85,
> +	V4L2_DV_BT_DMT_1280X1024P75,
> +	V4L2_DV_BT_DMT_1360X768P60,
> +	V4L2_DV_BT_DMT_1440X900P60,
> +	V4L2_DV_BT_DMT_1400X1050P60_RB,
> +	V4L2_DV_BT_DMT_1400X1050P60,
> +	V4L2_DV_BT_DMT_1600X1200P60,
> +	V4L2_DV_BT_DMT_1680X1050P60_RB,
> +	V4L2_DV_BT_CEA_1920X1080P24,
> +	V4L2_DV_BT_CEA_1920X1080P25,
> +	V4L2_DV_BT_CEA_1920X1080P30,
> +	V4L2_DV_BT_CEA_1920X1080I50,
> +	V4L2_DV_BT_CEA_1920X1080P50,
> +	V4L2_DV_BT_CEA_1920X1080I60,
> +	V4L2_DV_BT_CEA_1920X1080P60,
> +	V4L2_DV_BT_DMT_1920X1200P60_RB,
> +};
> +
> +/* regulator supplies */
> +static const char * const tda1997x_supply_name[] = {
> +	"DOVDD", /* Digital I/O supply */
> +	"DVDD",  /* Digital Core supply */
> +	"AVDD",  /* Analog supply */
> +};
> +
> +#define TDA1997X_NUM_SUPPLIES ARRAY_SIZE(tda1997x_supply_name)
> +
> +enum tda1997x_type {
> +	TDA19971,
> +	TDA19973,
> +};
> +
> +enum tda1997x_hdmi_pads {
> +	TDA1997X_PAD_SOURCE,
> +	TDA1997X_NUM_PADS,
> +};
> +
> +struct tda1997x_chip_info {
> +	enum tda1997x_type type;
> +	const char *name;
> +};
> +
> +struct tda1997x_state {
> +	const struct tda1997x_chip_info *info;
> +	struct tda1997x_platform_data pdata;
> +	struct i2c_client *client;
> +	struct i2c_client *client_cec;
> +	struct v4l2_subdev sd;
> +	struct regulator_bulk_data supplies[TDA1997X_NUM_SUPPLIES];
> +	struct media_pad pads[TDA1997X_NUM_PADS];
> +	struct mutex lock;
> +	struct mutex page_lock;
> +	char page;
> +
> +	/* detected info from chip */
> +	int chip_revision;
> +	char port_30bit;
> +	char output_2p5;
> +	char tmdsb_clk;
> +	char tmdsb_soc;
> +
> +	/* status info */
> +	char hdmi_status;
> +	char mptrw_in_progress;
> +	char state_c5_reached;
> +	char activity_status;
> +	char input_detect[2];
> +
> +	/* video */
> +	struct hdmi_avi_infoframe avi_infoframe;
> +	struct v4l2_hdmi_colorimetry colorimetry;
> +	u32 rgb_quantization_range;
> +	struct v4l2_dv_timings timings;
> +	const struct v4l2_dv_timings *detected_timings;
> +	int fps;
> +	const struct color_matrix_coefs *conv;
> +	u32 mbus_codes[5];	/* available modes */

I would make a define for the array size.

> +	u32 mbus_code;		/* current mode */
> +	u8 vid_fmt;
> +
> +	/* controls */
> +	struct v4l2_ctrl_handler hdl;
> +	struct v4l2_ctrl *detect_tx_5v_ctrl;
> +	struct v4l2_ctrl *rgb_quantization_range_ctrl;
> +
> +	/* audio */
> +	u8  audio_ch_alloc;
> +	int audio_samplerate;
> +	int audio_channels;
> +	int audio_samplesize;
> +	int audio_type;
> +	struct mutex audio_lock;
> +	struct snd_pcm_substream *audio_stream;
> +
> +	/* EDID */
> +	struct {
> +		u8 edid[256];
> +		u32 present;
> +		unsigned int blocks;
> +	} edid;
> +	struct delayed_work delayed_work_enable_hpd;
> +};
> +
> +static const struct v4l2_event tda1997x_ev_fmt = {
> +	.type = V4L2_EVENT_SOURCE_CHANGE,
> +	.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
> +};
> +
> +static const struct tda1997x_chip_info tda1997x_chip_info[] = {
> +	[TDA19971] = {
> +		.type = TDA19971,
> +		.name = "tda19971",
> +	},
> +	[TDA19973] = {
> +		.type = TDA19973,
> +		.name = "tda19973",
> +	},
> +};
> +
> +static inline struct tda1997x_state *to_state(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct tda1997x_state, sd);
> +}
> +
> +static inline struct v4l2_subdev *to_sd(struct v4l2_ctrl *ctrl)
> +{
> +	return &container_of(ctrl->handler, struct tda1997x_state, hdl)->sd;
> +}
> +
> +static int tda1997x_cec_read(struct v4l2_subdev *sd, u8 reg)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +	int val;
> +
> +	val = i2c_smbus_read_byte_data(state->client_cec, reg);
> +	if (val < 0) {
> +		v4l_err(state->client, "read reg error: reg=%2x\n", reg);
> +		val = -1;
> +	}
> +
> +	return val;
> +}
> +
> +static int tda1997x_cec_write(struct v4l2_subdev *sd, u8 reg, u8 val)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +	int ret = 0;
> +
> +	ret = i2c_smbus_write_byte_data(state->client_cec, reg, val);
> +	if (ret < 0) {
> +		v4l_err(state->client, "write reg error:reg=%2x,val=%2x\n",
> +			reg, val);
> +		ret = -1;
> +	}
> +
> +	return ret;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * I2C transfer
> + */
> +
> +static int tda1997x_setpage(struct v4l2_subdev *sd, u8 page)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +	int ret;
> +
> +	if (state->page != page) {
> +		ret = i2c_smbus_write_byte_data(state->client,
> +			REG_CURPAGE_00H, page);
> +		if (ret < 0) {
> +			v4l_err(state->client,
> +				"write reg error:reg=%2x,val=%2x\n",
> +				REG_CURPAGE_00H, page);
> +			return ret;
> +		}
> +		state->page = page;
> +	}
> +	return 0;
> +}
> +
> +static inline int io_read(struct v4l2_subdev *sd, u16 reg)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +	int val;
> +
> +	mutex_lock(&state->page_lock);
> +	if (tda1997x_setpage(sd, reg >> 8)) {
> +		val = -1;
> +		goto out;
> +	}
> +
> +	val = i2c_smbus_read_byte_data(state->client, reg&0xff);
> +	if (val < 0) {
> +		v4l_err(state->client, "read reg error: reg=%2x\n", reg & 0xff);
> +		val = -1;
> +		goto out;
> +	}
> +
> +out:
> +	mutex_unlock(&state->page_lock);
> +	return val;
> +}
> +
> +static inline long io_read16(struct v4l2_subdev *sd, u16 reg)
> +{
> +	u8 val;
> +	long lval = 0;
> +
> +	val = io_read(sd, reg);
> +	if (val < 0)
> +		return val;
> +	lval |= (val << 8);
> +	val = io_read(sd, reg + 1);
> +	if (val < 0)
> +		return val;
> +	lval |= val;
> +
> +	return lval;
> +}
> +
> +static inline long io_read24(struct v4l2_subdev *sd, u16 reg)
> +{
> +	u8 val;
> +	long lval = 0;
> +
> +	val = io_read(sd, reg);
> +	if (val < 0)
> +		return val;
> +	lval |= (val << 16);
> +	val = io_read(sd, reg + 1);
> +	if (val < 0)
> +		return val;
> +	lval |= (val << 8);
> +	val = io_read(sd, reg + 2);
> +	if (val < 0)
> +		return val;
> +	lval |= val;
> +
> +	return lval;
> +}
> +
> +static unsigned int io_readn(struct v4l2_subdev *sd, u16 reg, u8 len, u8 *data)
> +{
> +	int i;
> +	int sz = 0;
> +	u8 val;
> +
> +	for (i = 0; i < len; i++) {
> +		val = io_read(sd, reg + i);
> +		if (val < 0)
> +			break;
> +		data[i] = val;
> +		sz++;
> +	}
> +
> +	return sz;
> +}
> +
> +static int io_write(struct v4l2_subdev *sd, u16 reg, u8 val)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +	s32 ret = 0;
> +
> +	mutex_lock(&state->page_lock);
> +	if (tda1997x_setpage(sd, reg >> 8)) {
> +		ret = -1;
> +		goto out;
> +	}
> +
> +	ret = i2c_smbus_write_byte_data(state->client, reg & 0xff, val);
> +	if (ret < 0) {
> +		v4l_err(state->client, "write reg error:reg=%2x,val=%2x\n",
> +			reg&0xff, val);
> +		ret = -1;
> +		goto out;
> +	}
> +
> +out:
> +	mutex_unlock(&state->page_lock);
> +	return ret;
> +}
> +
> +static int io_write16(struct v4l2_subdev *sd, u16 reg, u16 val)
> +{
> +	int ret;
> +
> +	ret = io_write(sd, reg, (val >> 8) & 0xff);
> +	if (ret < 0)
> +		return ret;
> +	ret = io_write(sd, reg + 1, val & 0xff);
> +	if (ret < 0)
> +		return ret;
> +	return 0;
> +}
> +
> +static int io_write24(struct v4l2_subdev *sd, u16 reg, u32 val)
> +{
> +	int ret;
> +
> +	ret = io_write(sd, reg, (val >> 16) & 0xff);
> +	if (ret < 0)
> +		return ret;
> +	ret = io_write(sd, reg + 1, (val >> 8) & 0xff);
> +	if (ret < 0)
> +		return ret;
> +	ret = io_write(sd, reg + 2, val & 0xff);
> +	if (ret < 0)
> +		return ret;
> +	return 0;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Hotplug
> + */
> +
> +enum hpd_mode {
> +	HPD_LOW_BP,	/* HPD low and pulse of at least 100ms */
> +	HPD_LOW_OTHER,	/* HPD low and pulse of at least 100ms */
> +	HPD_HIGH_BP,	/* HIGH */
> +	HPD_HIGH_OTHER,
> +	HPD_PULSE,	/* HPD low pulse */
> +};
> +
> +/* manual HPD (Hot Plug Detect) control */
> +static int tda1997x_manual_hpd(struct v4l2_subdev *sd, enum hpd_mode mode)
> +{
> +	u8 hpd_auto, hpd_pwr, hpd_man;
> +
> +	hpd_auto = io_read(sd, REG_HPD_AUTO_CTRL);
> +	hpd_pwr = io_read(sd, REG_HPD_POWER);
> +	hpd_man = io_read(sd, REG_HPD_MAN_CTRL);
> +
> +	/* mask out unused bits */
> +	hpd_man &= (HPD_MAN_CTRL_HPD_PULSE |
> +		    HPD_MAN_CTRL_5VEN |
> +		    HPD_MAN_CTRL_HPD_B |
> +		    HPD_MAN_CTRL_HPD_A);
> +
> +	switch (mode) {
> +	/* HPD low and pulse of at least 100ms */
> +	case HPD_LOW_BP:
> +		/* hpd_bp=0 */
> +		hpd_pwr &= ~HPD_POWER_BP_MASK;
> +		/* disable HPD_A and HPD_B */
> +		hpd_man &= ~(HPD_MAN_CTRL_HPD_A | HPD_MAN_CTRL_HPD_B);
> +		io_write(sd, REG_HPD_POWER, hpd_pwr);
> +		io_write(sd, REG_HPD_MAN_CTRL, hpd_man);
> +		break;
> +	/* HPD high */
> +	case HPD_HIGH_BP:
> +		/* hpd_bp=1 */
> +		hpd_pwr &= ~HPD_POWER_BP_MASK;
> +		hpd_pwr |= 1 << HPD_POWER_BP_SHIFT;
> +		io_write(sd, REG_HPD_POWER, hpd_pwr);
> +		break;
> +	/* HPD low and pulse of at least 100ms */
> +	case HPD_LOW_OTHER:
> +		/* disable HPD_A and HPD_B */
> +		hpd_man &= ~(HPD_MAN_CTRL_HPD_A | HPD_MAN_CTRL_HPD_B);
> +		/* hp_other=0 */
> +		hpd_auto &= ~HPD_AUTO_HP_OTHER;
> +		io_write(sd, REG_HPD_AUTO_CTRL, hpd_auto);
> +		io_write(sd, REG_HPD_MAN_CTRL, hpd_man);
> +		break;
> +	/* HPD high */
> +	case HPD_HIGH_OTHER:
> +		hpd_auto |= HPD_AUTO_HP_OTHER;
> +		io_write(sd, REG_HPD_AUTO_CTRL, hpd_auto);
> +		break;
> +	/* HPD low pulse */
> +	case HPD_PULSE:
> +		/* disable HPD_A and HPD_B */
> +		hpd_man &= ~(HPD_MAN_CTRL_HPD_A | HPD_MAN_CTRL_HPD_B);
> +		io_write(sd, REG_HPD_MAN_CTRL, hpd_man);
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static void tda1997x_delayed_work_enable_hpd(struct work_struct *work)
> +{
> +	struct delayed_work *dwork = to_delayed_work(work);
> +	struct tda1997x_state *state = container_of(dwork,
> +						    struct tda1997x_state,
> +						    delayed_work_enable_hpd);
> +	struct v4l2_subdev *sd = &state->sd;
> +
> +	v4l2_dbg(2, debug, sd, "%s:\n", __func__);
> +
> +	/* Set HPD high */
> +	tda1997x_manual_hpd(sd, HPD_HIGH_OTHER);
> +	tda1997x_manual_hpd(sd, HPD_HIGH_BP);
> +
> +	state->edid.present = 1;
> +}
> +
> +static void tda1997x_disable_edid(struct v4l2_subdev *sd)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +
> +	v4l2_dbg(1, debug, sd, "%s\n", __func__);
> +	cancel_delayed_work_sync(&state->delayed_work_enable_hpd);
> +
> +	/* Set HPD low */
> +	tda1997x_manual_hpd(sd, HPD_LOW_BP);
> +}
> +
> +static void tda1997x_enable_edid(struct v4l2_subdev *sd)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +
> +	v4l2_dbg(1, debug, sd, "%s\n", __func__);
> +
> +	/* Enable hotplug after 100ms */
> +	schedule_delayed_work(&state->delayed_work_enable_hpd, HZ / 10);
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Signal Control
> + */
> +
> +/*
> + * configure vid_fmt based on mbus_code
> + */
> +static int
> +tda1997x_setup_format(struct tda1997x_state *state, u32 code)
> +{
> +	v4l_dbg(1, debug, state->client, "%s code=0x%x\n", __func__, code);
> +	switch (code) {
> +	case MEDIA_BUS_FMT_RGB121212_1X36:
> +	case MEDIA_BUS_FMT_RGB888_1X24:
> +	case MEDIA_BUS_FMT_YUV12_1X36:
> +	case MEDIA_BUS_FMT_YUV8_1X24:
> +		state->vid_fmt = OF_FMT_444;
> +		break;
> +	case MEDIA_BUS_FMT_UYVY12_1X24:
> +	case MEDIA_BUS_FMT_UYVY10_1X20:
> +	case MEDIA_BUS_FMT_UYVY8_1X16:
> +		state->vid_fmt = OF_FMT_422_SMPT;
> +		break;
> +	case MEDIA_BUS_FMT_UYVY12_2X12:
> +	case MEDIA_BUS_FMT_UYVY10_2X10:
> +	case MEDIA_BUS_FMT_UYVY8_2X8:
> +		state->vid_fmt = OF_FMT_422_CCIR;
> +		break;
> +	default:
> +		v4l_err(state->client, "incompatible format (0x%x)\n", code);
> +		return -EINVAL;
> +	}
> +	v4l_dbg(1, debug, state->client, "%s code=0x%x fmt=%s\n", __func__,
> +		code, vidfmt_names[state->vid_fmt]);
> +	state->mbus_code = code;
> +
> +	return 0;
> +}
> +
> +/*
> + * The color conversion matrix will convert between the colorimetry of the
> + * HDMI input to the desired output format RGB|YUV. RGB output is to be
> + * full-range and YUV is to be limited range.
> + *
> + * RGB full-range uses values from 0 to 255 which is recommended on a monitor
> + * and RGB Limited uses values from 16 to 236 (16=black, 235=white) which is
> + * typically recommended on a TV.
> + */
> +static int
> +tda1997x_configure_csc(struct v4l2_subdev *sd)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +	struct hdmi_avi_infoframe *avi = &state->avi_infoframe;
> +	struct v4l2_hdmi_colorimetry *c = &state->colorimetry;
> +	/* Blanking code values depend on output colorspace (RGB or YUV) */
> +	struct blanking_codes {
> +		s16 code_gy;
> +		s16 code_bu;
> +		s16 code_rv;
> +	};
> +	static const struct blanking_codes rgb_blanking = { 64, 64, 64 };
> +	static const struct blanking_codes yuv_blanking = { 64, 512, 512 };
> +	const struct blanking_codes *blanking_codes = NULL;
> +	u8 reg;
> +
> +	v4l_dbg(1, debug, state->client, "input:%s quant:%s output:%s\n",
> +		hdmi_colorspace_names[avi->colorspace],
> +		v4l2_quantization_names[c->quantization],
> +		vidfmt_names[state->vid_fmt]);
> +	state->conv = NULL;
> +	switch (state->vid_fmt) {
> +	/* RGB output */
> +	case OF_FMT_444:
> +		blanking_codes = &rgb_blanking;
> +		if (c->colorspace == V4L2_COLORSPACE_SRGB) {
> +			if (c->quantization == V4L2_QUANTIZATION_LIM_RANGE)
> +				state->conv = &conv_matrix[RGBLIMITED_RGBFULL];
> +		} else {
> +			if (c->colorspace == V4L2_COLORSPACE_REC709)
> +				state->conv = &conv_matrix[ITU709_RGBFULL];
> +			else if (c->colorspace == V4L2_COLORSPACE_SMPTE170M)
> +				state->conv = &conv_matrix[ITU601_RGBFULL];
> +		}
> +		break;
> +
> +	/* YUV output */
> +	case OF_FMT_422_SMPT: /* semi-planar */
> +	case OF_FMT_422_CCIR: /* CCIR656 */
> +		blanking_codes = &yuv_blanking;
> +		if ((c->colorspace == V4L2_COLORSPACE_SRGB) &&
> +		    (c->quantization == V4L2_QUANTIZATION_FULL_RANGE)) {
> +			if (state->timings.bt.height <= 576)
> +				state->conv = &conv_matrix[RGBFULL_ITU601];
> +			else
> +				state->conv = &conv_matrix[RGBFULL_ITU709];
> +		} else if ((c->colorspace == V4L2_COLORSPACE_SRGB) &&
> +			   (c->quantization == V4L2_QUANTIZATION_LIM_RANGE)) {
> +			if (state->timings.bt.height <= 576)
> +				state->conv = &conv_matrix[RGBLIMITED_ITU601];
> +			else
> +				state->conv = &conv_matrix[RGBLIMITED_ITU709];
> +		}
> +		break;
> +	}
> +
> +	if (state->conv) {
> +		v4l_dbg(1, debug, state->client, "%s\n",
> +			state->conv->name);
> +		/* enable matrix conversion */
> +		reg = io_read(sd, REG_VDP_CTRL);
> +		reg &= ~VDP_CTRL_MATRIX_BP;
> +		io_write(sd, REG_VDP_CTRL, reg);
> +		/* offset inputs */
> +		io_write16(sd, REG_VDP_MATRIX + 0, state->conv->offint1);
> +		io_write16(sd, REG_VDP_MATRIX + 2, state->conv->offint2);
> +		io_write16(sd, REG_VDP_MATRIX + 4, state->conv->offint3);
> +		/* coefficients */
> +		io_write16(sd, REG_VDP_MATRIX + 6, state->conv->p11coef);
> +		io_write16(sd, REG_VDP_MATRIX + 8, state->conv->p12coef);
> +		io_write16(sd, REG_VDP_MATRIX + 10, state->conv->p13coef);
> +		io_write16(sd, REG_VDP_MATRIX + 12, state->conv->p21coef);
> +		io_write16(sd, REG_VDP_MATRIX + 14, state->conv->p22coef);
> +		io_write16(sd, REG_VDP_MATRIX + 16, state->conv->p23coef);
> +		io_write16(sd, REG_VDP_MATRIX + 18, state->conv->p31coef);
> +		io_write16(sd, REG_VDP_MATRIX + 20, state->conv->p32coef);
> +		io_write16(sd, REG_VDP_MATRIX + 22, state->conv->p33coef);
> +		/* offset outputs */
> +		io_write16(sd, REG_VDP_MATRIX + 24, state->conv->offout1);
> +		io_write16(sd, REG_VDP_MATRIX + 26, state->conv->offout2);
> +		io_write16(sd, REG_VDP_MATRIX + 28, state->conv->offout3);
> +	} else {
> +		/* disable matrix conversion */
> +		reg = io_read(sd, REG_VDP_CTRL);
> +		reg |= VDP_CTRL_MATRIX_BP;
> +		io_write(sd, REG_VDP_CTRL, reg);
> +	}
> +
> +	/* SetBlankingCodes */
> +	if (blanking_codes) {
> +		io_write16(sd, REG_BLK_GY, blanking_codes->code_gy);
> +		io_write16(sd, REG_BLK_BU, blanking_codes->code_bu);
> +		io_write16(sd, REG_BLK_RV, blanking_codes->code_rv);
> +	}
> +
> +	return 0;
> +}
> +
> +/* Configure frame detection window and VHREF timing generator */
> +static int
> +tda1997x_configure_vhref(struct v4l2_subdev *sd)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +	const struct v4l2_bt_timings *bt;
> +	int width, lines;
> +	u16 href_start, href_end;
> +	u16 vref_f1_start, vref_f2_start;
> +	u8 vref_f1_width, vref_f2_width;
> +	u8 field_polarity;
> +	u16 fieldref_f1_start, fieldref_f2_start;
> +	u8 reg;
> +
> +	if (!state->detected_timings)
> +		return -EINVAL;
> +	bt = &state->detected_timings->bt;
> +	href_start = bt->hbackporch + bt->hsync + 1;
> +	href_end = href_start + bt->width;
> +	vref_f1_start = bt->height + bt->vbackporch + bt->vsync +
> +			bt->il_vbackporch + bt->il_vsync +
> +			bt->il_vfrontporch;
> +	vref_f1_width = bt->vbackporch + bt->vsync + bt->vfrontporch;
> +	vref_f2_start = 0;
> +	vref_f2_width = 0;
> +	fieldref_f1_start = 0;
> +	fieldref_f2_start = 0;
> +	if (bt->interlaced) {
> +		vref_f2_start = (bt->height / 2) +
> +				(bt->il_vbackporch + bt->il_vsync - 1);
> +		vref_f2_width = bt->il_vbackporch + bt->il_vsync +
> +				bt->il_vfrontporch;
> +		fieldref_f2_start = vref_f2_start + bt->il_vfrontporch +
> +				    fieldref_f1_start;
> +	}
> +	field_polarity = 0;
> +
> +	width = V4L2_DV_BT_FRAME_WIDTH(bt);
> +	lines = V4L2_DV_BT_FRAME_HEIGHT(bt);
> +
> +	/*
> +	 * Configure Frame Detection Window:
> +	 *  horiz area where the VHREF module consider a VSYNC a new frame
> +	 */
> +	io_write16(sd, REG_FDW_S, 0x2ef); /* start position */
> +	io_write16(sd, REG_FDW_E, 0x141); /* end position */
> +
> +	/* Set Pixel And Line Counters */
> +	if (state->chip_revision == 0)
> +		io_write16(sd, REG_PXCNT_PR, 4);
> +	else
> +		io_write16(sd, REG_PXCNT_PR, 1);
> +	io_write16(sd, REG_PXCNT_NPIX, width & MASK_VHREF);
> +	io_write16(sd, REG_LCNT_PR, 1);
> +	io_write16(sd, REG_LCNT_NLIN, lines & MASK_VHREF);
> +
> +	/*
> +	 * Configure the VHRef timing generator responsible for rebuilding all
> +	 * horiz and vert synch and ref signals from its input allowing auto
> +	 * detection algorithms and forcing predefined modes (480i & 576i)
> +	 */
> +	reg = VHREF_STD_DET_OFF << VHREF_STD_DET_SHIFT;
> +	io_write(sd, REG_VHREF_CTRL, reg);
> +
> +	/*
> +	 * Configure the VHRef timing values. In case the VHREF generator has
> +	 * been configured in manual mode, this will allow to manually set all
> +	 * horiz and vert ref values (non-active pixel areas) of the generator
> +	 * and allows setting the frame reference params.
> +	 */
> +	/* horizontal reference start/end */
> +	io_write16(sd, REG_HREF_S, href_start & MASK_VHREF);
> +	io_write16(sd, REG_HREF_E, href_end & MASK_VHREF);
> +	/* vertical reference f1 start/end */
> +	io_write16(sd, REG_VREF_F1_S, vref_f1_start & MASK_VHREF);
> +	io_write(sd, REG_VREF_F1_WIDTH, vref_f1_width);
> +	/* vertical reference f2 start/end */
> +	io_write16(sd, REG_VREF_F2_S, vref_f2_start & MASK_VHREF);
> +	io_write(sd, REG_VREF_F2_WIDTH, vref_f2_width);
> +
> +	/* F1/F2 FREF, field polarity */
> +	reg = fieldref_f1_start & MASK_VHREF;
> +	reg |= field_polarity << 8;
> +	io_write16(sd, REG_FREF_F1_S, reg);
> +	reg = fieldref_f2_start & MASK_VHREF;
> +	io_write16(sd, REG_FREF_F2_S, reg);
> +
> +	return 0;
> +}
> +
> +/* Configure Video Output port signals */
> +static int
> +tda1997x_configure_vidout(struct tda1997x_state *state)
> +{
> +	struct v4l2_subdev *sd = &state->sd;
> +	struct tda1997x_platform_data *pdata = &state->pdata;
> +	u8 prefilter;
> +	u8 reg;
> +
> +	/* Configure pixel clock generator: delay, polarity, rate */
> +	reg = (state->vid_fmt == OF_FMT_422_CCIR) ?
> +	       PCLK_SEL_X2 : PCLK_SEL_X1;
> +	reg |= pdata->vidout_delay_pclk << PCLK_DELAY_SHIFT;
> +	reg |= pdata->vidout_inv_pclk << PCLK_INV_SHIFT;
> +	io_write(sd, REG_PCLK, reg);
> +
> +	/* Configure pre-filter */
> +	prefilter = 0; /* filters off */
> +	/* YUV422 mode requires conversion */
> +	if ((state->vid_fmt == OF_FMT_422_SMPT)
> +	 || (state->vid_fmt == OF_FMT_422_CCIR)) {

Odd alignment. Usually the || goes to the end of the previous line.

> +		/* 2/7taps for Rv and Bu */

Space after '2/7'?

> +		prefilter = FILTERS_CTRL_2_7TAP << FILTERS_CTRL_BU_SHIFT |
> +			    FILTERS_CTRL_2_7TAP << FILTERS_CTRL_RV_SHIFT;
> +	}
> +	io_write(sd, REG_FILTERS_CTRL, prefilter);
> +
> +	/* Configure video port */
> +	reg = state->vid_fmt & OF_FMT_MASK;
> +	if (state->vid_fmt == OF_FMT_422_CCIR)
> +		reg |= (OF_BLK | OF_TRC);
> +	reg |= OF_VP_ENABLE;
> +	io_write(sd, REG_OF, reg);
> +
> +	/* Configure formatter and conversions */
> +	reg = io_read(sd, REG_VDP_CTRL);
> +	/* pre-filter is needed unless (REG_FILTERS_CTRL == 0) */
> +	if (!prefilter)
> +		reg |= VDP_CTRL_PREFILTER_BP;
> +	else
> +		reg &= ~VDP_CTRL_PREFILTER_BP;
> +	/* formatter is needed for YUV422 and for trc/blc codes */
> +	if (state->vid_fmt == OF_FMT_444)
> +		reg |= VDP_CTRL_FORMATTER_BP;
> +	/* formatter and compdel needed for timing/blanking codes */
> +	else
> +		reg &= ~(VDP_CTRL_FORMATTER_BP | VDP_CTRL_COMPDEL_BP);
> +	/* activate compdel for small sync delays */
> +	if ((pdata->vidout_delay_vs < 4) || (pdata->vidout_delay_hs < 4))
> +		reg &= ~VDP_CTRL_COMPDEL_BP;
> +	io_write(sd, REG_VDP_CTRL, reg);
> +
> +	/* Configure DE output signal: delay, polarity, and source */
> +	reg = pdata->vidout_delay_de << DE_FREF_DELAY_SHIFT |
> +	      pdata->vidout_inv_de << DE_FREF_INV_SHIFT |
> +	      pdata->vidout_sel_de << DE_FREF_SEL_SHIFT;
> +	io_write(sd, REG_DE_FREF, reg);
> +
> +	/* Configure HS/HREF output signal: delay, polarity, and source */
> +	if (state->vid_fmt != OF_FMT_422_CCIR) {
> +		reg = pdata->vidout_delay_hs << HS_HREF_DELAY_SHIFT |
> +		      pdata->vidout_inv_hs << HS_HREF_INV_SHIFT |
> +		      pdata->vidout_sel_hs << HS_HREF_SEL_SHIFT;
> +	} else
> +		reg = HS_HREF_SEL_NONE << HS_HREF_SEL_SHIFT;
> +	io_write(sd, REG_HS_HREF, reg);
> +
> +	/* Configure VS/VREF output signal: delay, polarity, and source */
> +	if (state->vid_fmt != OF_FMT_422_CCIR) {
> +		reg = pdata->vidout_delay_vs << VS_VREF_DELAY_SHIFT |
> +		      pdata->vidout_inv_vs << VS_VREF_INV_SHIFT |
> +		      pdata->vidout_sel_vs << VS_VREF_SEL_SHIFT;
> +	} else
> +		reg = VS_VREF_SEL_NONE << VS_VREF_SEL_SHIFT;
> +	io_write(sd, REG_VS_VREF, reg);
> +
> +	return 0;
> +}
> +
> +/* Configure Audio output port signals */
> +static int
> +tda1997x_configure_audout(struct v4l2_subdev *sd, u8 channel_assignment)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +	struct tda1997x_platform_data *pdata = &state->pdata;
> +	bool sp_used_by_fifo = 1;
> +	u8 reg;
> +
> +	if (!pdata->audout_format)
> +		return 0;
> +
> +	/* channel assignment (CEA-861-D Table 20) */
> +	io_write(sd, REG_AUDIO_PATH, channel_assignment);
> +
> +	/* Audio output configuration */
> +	reg = 0;
> +	switch (pdata->audout_format) {
> +	case AUDFMT_TYPE_I2S:
> +		reg |= AUDCFG_BUS_I2S << AUDCFG_BUS_SHIFT;
> +		break;
> +	case AUDFMT_TYPE_SPDIF:
> +		reg |= AUDCFG_BUS_SPDIF << AUDCFG_BUS_SHIFT;
> +		break;
> +	}
> +	switch (state->audio_type) {
> +	case AUDCFG_TYPE_PCM:
> +		reg |= AUDCFG_TYPE_PCM << AUDCFG_TYPE_SHIFT;
> +		break;
> +	case AUDCFG_TYPE_OBA:
> +		reg |= AUDCFG_TYPE_OBA << AUDCFG_TYPE_SHIFT;
> +		break;
> +	case AUDCFG_TYPE_DST:
> +		reg |= AUDCFG_TYPE_DST << AUDCFG_TYPE_SHIFT;
> +		sp_used_by_fifo = 0;
> +		break;
> +	case AUDCFG_TYPE_HBR:
> +		reg |= AUDCFG_TYPE_HBR << AUDCFG_TYPE_SHIFT;
> +		if (pdata->audout_layout == 1) {
> +			/* demuxed via AP0:AP3 */
> +			reg |= AUDCFG_HBR_DEMUX << AUDCFG_HBR_SHIFT;
> +			if (pdata->audout_format == AUDFMT_TYPE_SPDIF)
> +				sp_used_by_fifo = 0;
> +		} else {
> +			/* straight via AP0 */
> +			reg |= AUDCFG_HBR_STRAIGHT << AUDCFG_HBR_SHIFT;
> +		}
> +		break;
> +	}
> +	if (pdata->audout_width == 32)
> +		reg |= AUDCFG_I2SW_32 << AUDCFG_I2SW_SHIFT;
> +	else
> +		reg |= AUDCFG_I2SW_16 << AUDCFG_I2SW_SHIFT;
> +
> +	/* automatic hardware mute */
> +	if (pdata->audio_auto_mute)
> +		reg |= AUDCFG_AUTO_MUTE_EN;
> +	/* clock polarity */
> +	if (pdata->audout_invert_clk)
> +		reg |= AUDCFG_CLK_INVERT;
> +	io_write(sd, REG_AUDCFG, reg);
> +
> +	/* audio layout */
> +	reg = (pdata->audout_layout) ? AUDIO_LAYOUT_LAYOUT1 : 0;
> +	if (!pdata->audout_layoutauto)
> +		reg |= AUDIO_LAYOUT_MANUAL;
> +	if (sp_used_by_fifo)
> +		reg |= AUDIO_LAYOUT_SP_FLAG;
> +	io_write(sd, REG_AUDIO_LAYOUT, reg);
> +
> +	/* FIFO Latency value */
> +	io_write(sd, REG_FIFO_LATENCY_VAL, 0x80);
> +
> +	/* Audio output port config */
> +	if (sp_used_by_fifo) {
> +		reg = AUDIO_OUT_ENABLE_AP0;
> +		if (channel_assignment >= 0x01)
> +			reg |= AUDIO_OUT_ENABLE_AP1;
> +		if (channel_assignment >= 0x04)
> +			reg |= AUDIO_OUT_ENABLE_AP2;
> +		if (channel_assignment >= 0x0c)
> +			reg |= AUDIO_OUT_ENABLE_AP3;
> +		/* specific cases where AP1 is not used */
> +		if ((channel_assignment == 0x04)
> +		 || (channel_assignment == 0x08)
> +		 || (channel_assignment == 0x0c)
> +		 || (channel_assignment == 0x10)
> +		 || (channel_assignment == 0x14)
> +		 || (channel_assignment == 0x18)
> +		 || (channel_assignment == 0x1c))
> +			reg &= ~AUDIO_OUT_ENABLE_AP1;
> +		/* specific cases where AP2 is not used */
> +		if ((channel_assignment >= 0x14)
> +		 && (channel_assignment <= 0x17))
> +			reg &= ~AUDIO_OUT_ENABLE_AP2;
> +	} else {
> +		reg = AUDIO_OUT_ENABLE_AP3 |
> +		      AUDIO_OUT_ENABLE_AP2 |
> +		      AUDIO_OUT_ENABLE_AP1 |
> +		      AUDIO_OUT_ENABLE_AP0;
> +	}
> +	if (pdata->audout_format == AUDFMT_TYPE_I2S)
> +		reg |= (AUDIO_OUT_ENABLE_ACLK | AUDIO_OUT_ENABLE_WS);
> +	io_write(sd, REG_AUDIO_OUT_ENABLE, reg);
> +
> +	/* reset test mode to normal audio freq auto selection */
> +	io_write(sd, REG_TEST_MODE, 0x00);
> +
> +	return 0;
> +}
> +
> +/* Soft Reset of specific hdmi info */
> +static int
> +tda1997x_hdmi_info_reset(struct v4l2_subdev *sd, u8 info_rst, bool reset_sus)
> +{
> +	u8 reg;
> +
> +	/* reset infoframe engine packets */
> +	reg = io_read(sd, REG_HDMI_INFO_RST);
> +	io_write(sd, REG_HDMI_INFO_RST, info_rst);
> +
> +	/* if infoframe engine has been reset clear INT_FLG_MODE */
> +	if (reg & RESET_IF) {
> +		reg = io_read(sd, REG_INT_FLG_CLR_MODE);
> +		io_write(sd, REG_INT_FLG_CLR_MODE, reg);
> +	}
> +
> +	/* Disable REFTIM to restart start-up-sequencer (SUS) */
> +	reg = io_read(sd, REG_RATE_CTRL);
> +	reg &= ~RATE_REFTIM_ENABLE;
> +	if (!reset_sus)
> +		reg |= RATE_REFTIM_ENABLE;
> +	reg = io_write(sd, REG_RATE_CTRL, reg);
> +
> +	return 0;
> +}
> +
> +static void
> +tda1997x_power_mode(struct tda1997x_state *state, bool enable)
> +{
> +	struct v4l2_subdev *sd = &state->sd;
> +	u8 reg;
> +
> +	if (enable) {
> +		/* Automatic control of TMDS */
> +		io_write(sd, REG_PON_OVR_EN, PON_DIS);
> +		/* Enable current bias unit */
> +		io_write(sd, REG_CFG1, PON_EN);
> +		/* Enable deep color PLL */
> +		io_write(sd, REG_DEEP_PLL7_BYP, PON_DIS);
> +		/* Output buffers active */
> +		reg = io_read(sd, REG_OF);
> +		reg &= ~OF_VP_ENABLE;
> +		io_write(sd, REG_OF, reg);
> +	} else {
> +		/* Power down EDID mode sequence */
> +		/* Output buffers in HiZ */
> +		reg = io_read(sd, REG_OF);
> +		reg |= OF_VP_ENABLE;
> +		io_write(sd, REG_OF, reg);
> +		/* Disable deep color PLL */
> +		io_write(sd, REG_DEEP_PLL7_BYP, PON_EN);
> +		/* Disable current bias unit */
> +		io_write(sd, REG_CFG1, PON_DIS);
> +		/* Manual control of TMDS */
> +		io_write(sd, REG_PON_OVR_EN, PON_EN);
> +	}
> +}
> +
> +static bool
> +tda1997x_detect_tx_5v(struct v4l2_subdev *sd)
> +{
> +	u8 reg = io_read(sd, REG_DETECT_5V);
> +
> +	return ((reg & DETECT_5V_SEL) ? 1 : 0);
> +}
> +
> +static bool
> +tda1997x_detect_tx_hpd(struct v4l2_subdev *sd)
> +{
> +	u8 reg = io_read(sd, REG_DETECT_5V);
> +
> +	return ((reg & DETECT_HPD) ? 1 : 0);
> +}
> +
> +static int
> +tda1997x_detect_std(struct tda1997x_state *state)
> +{
> +	struct v4l2_subdev *sd = &state->sd;
> +	u32 vper;
> +	u16 hper;
> +	u16 hsper;
> +	int i;
> +
> +	/*
> +	 * Read the FMT registers
> +	 *   REG_V_PER: Period of a frame (or two fields) in MCLK(27MHz) cycles
> +	 *   REG_H_PER: Period of a line in MCLK(27MHz) cycles
> +	 *   REG_HS_WIDTH: Period of horiz sync pulse in MCLK(27MHz) cycles
> +	 */
> +	vper = io_read24(sd, REG_V_PER) & MASK_VPER;
> +	hper = io_read16(sd, REG_H_PER) & MASK_HPER;
> +	hsper = io_read16(sd, REG_HS_WIDTH) & MASK_HSWIDTH;
> +	if (!vper || !hper || !hsper)
> +		return -ENOLINK;
> +	v4l2_dbg(1, debug, sd, "Signal Timings: %u/%u/%u\n", vper, hper, hsper);
> +
> +	/* look for matching timings */
> +	for (i = 0; i < ARRAY_SIZE(tda1997x_hdmi_modes); i++) {
> +		const struct v4l2_bt_timings *bt = &tda1997x_hdmi_modes[i].bt;
> +		u32 lines, width, _hper, _hsper;
> +		u32 vmin, vmax, hmin, hmax, hsmin, hsmax;
> +		bool vmatch, hmatch, hsmatch;
> +
> +		width = V4L2_DV_BT_FRAME_WIDTH(bt);
> +		lines = V4L2_DV_BT_FRAME_HEIGHT(bt);
> +		_hper = (u32)bt->pixelclock / width;
> +		if (bt->interlaced)
> +			lines /= 2;
> +		/* vper +/- 0.7% */
> +		vmin = ((27000000 / 1000) * 993) / _hper * lines;
> +		vmax = ((27000000 / 1000) * 1007) / _hper * lines;
> +		/* hper +/- 1.0% */
> +		hmin = ((27000000 / 100) * 99) / _hper;
> +		hmax = ((27000000 / 100) * 101) / _hper;
> +		/* hsper +/- 2 (take care to avoid 32bit overflow) */
> +		_hsper = 27000 * bt->hsync / ((u32)bt->pixelclock/1000);
> +		hsmin = _hsper - 2;
> +		hsmax = _hsper + 2;
> +
> +		/* vmatch matches the framerate */
> +		vmatch = ((vper <= vmax) && (vper >= vmin)) ? 1 : 0;
> +		/* hmatch matches the width */
> +		hmatch = ((hper <= hmax) && (hper >= hmin)) ? 1 : 0;
> +		/* hsmatch matches the hswidth */
> +		hsmatch = ((hsper <= hsmax) && (hsper >= hsmin)) ? 1 : 0;
> +		if (hmatch && vmatch && hsmatch) {
> +			state->detected_timings = &tda1997x_hdmi_modes[i];
> +			v4l2_print_dv_timings(sd->name, "Detected format: ",
> +					      state->detected_timings, false);
> +			return 0;
> +		}
> +	}
> +
> +	v4l_err(state->client, "no resolution match for timings: %d/%d/%d\n",
> +		vper, hper, hsper);
> +	return -EINVAL;
> +}
> +
> +/* some sort of errata workaround for chip revision 0 (N1) */
> +static void tda1997x_reset_n1(struct tda1997x_state *state)
> +{
> +	struct v4l2_subdev *sd = &state->sd;
> +	u8 reg;
> +
> +	/* clear HDMI mode flag in BCAPS */
> +	io_write(sd, REG_CLK_CFG, CLK_CFG_SEL_ACLK_EN | CLK_CFG_SEL_ACLK);
> +	io_write(sd, REG_PON_OVR_EN, PON_EN);
> +	io_write(sd, REG_PON_CBIAS, PON_EN);
> +	io_write(sd, REG_PON_PLL, PON_EN);
> +
> +	reg = io_read(sd, REG_MODE_REC_CFG1);
> +	reg &= ~0x06;
> +	reg |= 0x02;
> +	io_write(sd, REG_MODE_REC_CFG1, reg);
> +	io_write(sd, REG_CLK_CFG, CLK_CFG_DIS);
> +	io_write(sd, REG_PON_OVR_EN, PON_DIS);
> +	reg = io_read(sd, REG_MODE_REC_CFG1);
> +	reg &= ~0x06;
> +	io_write(sd, REG_MODE_REC_CFG1, reg);
> +}
> +
> +/*
> + * Activity detection must only be notified when stable_clk_x AND active_x
> + * bits are set to 1. If only stable_clk_x bit is set to 1 but not
> + * active_x, it means that the TMDS clock is not in the defined range
> + * and activity detection must not be notified.
> + */
> +static u8
> +tda1997x_read_activity_status_regs(struct v4l2_subdev *sd)
> +{
> +	u8 reg, status = 0;
> +
> +	/* Read CLK_A_STATUS register */
> +	reg = io_read(sd, REG_CLK_A_STATUS);
> +	/* when stable_clk_x is set to 1, check active_x bit */
> +	if ((reg & MASK_CLK_STABLE) && !(reg & MASK_CLK_ACTIVE))
> +		reg &= ~MASK_CLK_STABLE;
> +	status |= ((reg & MASK_CLK_STABLE) >> 2);
> +
> +	/* Read CLK_B_STATUS register */
> +	reg = io_read(sd, REG_CLK_B_STATUS);
> +	/* when stable_clk_x is set to 1, check active_x bit */
> +	if ((reg & MASK_CLK_STABLE) && !(reg & MASK_CLK_ACTIVE))
> +		reg &= ~MASK_CLK_STABLE;
> +	status |= ((reg & MASK_CLK_STABLE) >> 1);
> +
> +	/* Read the SUS_STATUS register */
> +	reg = io_read(sd, REG_SUS_STATUS);
> +
> +	/* If state = 5 => TMDS is locked */
> +	if ((reg & MASK_SUS_STATUS) == LAST_STATE_REACHED)
> +		status |= MASK_SUS_STATE;
> +	else
> +		status &= ~MASK_SUS_STATE;
> +
> +	return status;
> +}
> +
> +/* parse an infoframe and do some sanity checks on it */
> +static unsigned int
> +tda1997x_parse_infoframe(struct tda1997x_state *state, u16 addr)
> +{
> +	struct v4l2_subdev *sd = &state->sd;
> +	struct v4l2_hdmi_colorimetry *c = &state->colorimetry;
> +	union hdmi_infoframe frame;
> +	u8 buffer[40];
> +	u8 reg;
> +	int len, err;
> +
> +	/* read data */
> +	len = io_readn(sd, addr, sizeof(buffer), buffer);
> +	err = hdmi_infoframe_unpack(&frame, buffer);
> +	if (err) {
> +		v4l_err(state->client,
> +			"failed parsing %d byte infoframe: 0x%04x/0x%02x\n",
> +			len, addr, buffer[0]);
> +		return err;
> +	}
> +	hdmi_infoframe_log(KERN_INFO, &state->client->dev, &frame);
> +	switch (frame.any.type) {
> +	/* Audio InfoFrame: see HDMI spec 8.2.2 */
> +	case HDMI_INFOFRAME_TYPE_AUDIO:
> +		/* sample rate */
> +		switch (frame.audio.sample_frequency) {
> +		case HDMI_AUDIO_SAMPLE_FREQUENCY_32000:
> +			state->audio_samplerate = 32000;
> +			break;
> +		case HDMI_AUDIO_SAMPLE_FREQUENCY_44100:
> +			state->audio_samplerate = 44100;
> +			break;
> +		case HDMI_AUDIO_SAMPLE_FREQUENCY_48000:
> +			state->audio_samplerate = 48000;
> +			break;
> +		case HDMI_AUDIO_SAMPLE_FREQUENCY_88200:
> +			state->audio_samplerate = 88200;
> +			break;
> +		case HDMI_AUDIO_SAMPLE_FREQUENCY_96000:
> +			state->audio_samplerate = 96000;
> +			break;
> +		case HDMI_AUDIO_SAMPLE_FREQUENCY_176400:
> +			state->audio_samplerate = 176400;
> +			break;
> +		case HDMI_AUDIO_SAMPLE_FREQUENCY_192000:
> +			state->audio_samplerate = 192000;
> +			break;
> +		default:
> +		case HDMI_AUDIO_SAMPLE_FREQUENCY_STREAM:
> +			break;
> +		}
> +
> +		/* sample size */
> +		switch (frame.audio.sample_size) {
> +		case HDMI_AUDIO_SAMPLE_SIZE_16:
> +			state->audio_samplesize = 16;
> +			break;
> +		case HDMI_AUDIO_SAMPLE_SIZE_20:
> +			state->audio_samplesize = 20;
> +			break;
> +		case HDMI_AUDIO_SAMPLE_SIZE_24:
> +			state->audio_samplesize = 24;
> +			break;
> +		case HDMI_AUDIO_SAMPLE_SIZE_STREAM:
> +		default:
> +			break;
> +		}
> +
> +		/* Channel Count */
> +		state->audio_channels = frame.audio.channels;
> +		if (frame.audio.channel_allocation &&
> +		    frame.audio.channel_allocation != state->audio_ch_alloc) {
> +			/* use the channel assignment from the infoframe */
> +			state->audio_ch_alloc = frame.audio.channel_allocation;
> +			tda1997x_configure_audout(sd, state->audio_ch_alloc);
> +			/* reset the audio FIFO */
> +			tda1997x_hdmi_info_reset(sd, RESET_AUDIO, false);
> +		}
> +		break;
> +
> +	/* Auxiliary Video information (AVI) InfoFrame: see HDMI spec 8.2.1 */
> +	case HDMI_INFOFRAME_TYPE_AVI:
> +		state->avi_infoframe = frame.avi;
> +		state->colorimetry = v4l2_hdmi_rx_colorimetry(&frame.avi, NULL,
> +					state->timings.bt.height);
> +		/* If ycbcr_enc is V4L2_YCBCR_ENC_DEFAULT, we receive RGB */
> +		if (c->ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT) {
> +			switch (state->rgb_quantization_range) {
> +			case V4L2_DV_RGB_RANGE_LIMITED:
> +				c->quantization = V4L2_QUANTIZATION_FULL_RANGE;
> +				break;
> +			case V4L2_DV_RGB_RANGE_FULL:
> +				c->quantization = V4L2_QUANTIZATION_LIM_RANGE;
> +				break;
> +			}
> +		}
> +		v4l_dbg(1, debug, state->client,
> +			"colorspace=%d/%d colorimetry=%d range=%s content=%d\n",
> +			frame.avi.colorspace, c->colorspace,
> +			frame.avi.colorimetry,
> +			v4l2_quantization_names[c->quantization],
> +			frame.avi.content_type);
> +
> +		/* configure upsampler: 0=bypass 1=repeatchroma 2=interpolate */
> +		reg = io_read(sd, REG_PIX_REPEAT);
> +		reg &= ~PIX_REPEAT_MASK_UP_SEL;
> +		if (frame.avi.colorspace == HDMI_COLORSPACE_YUV422)
> +			reg |= (PIX_REPEAT_CHROMA << PIX_REPEAT_SHIFT);
> +		io_write(sd, REG_PIX_REPEAT, reg);
> +
> +		/* ConfigurePixelRepeater: repeat n-times each pixel */
> +		reg = io_read(sd, REG_PIX_REPEAT);
> +		reg &= ~PIX_REPEAT_MASK_REP;
> +		reg |= frame.avi.pixel_repeat;
> +		io_write(sd, REG_PIX_REPEAT, reg);
> +
> +		/* configure the receiver with the new colorspace */
> +		tda1997x_configure_csc(sd);
> +		break;
> +	default:
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static void tda1997x_irq_sus(struct tda1997x_state *state, u8 *flags)
> +{
> +	struct v4l2_subdev *sd = &state->sd;
> +	u8 reg, source;
> +
> +	source = io_read(sd, REG_INT_FLG_CLR_SUS);
> +	io_write(sd, REG_INT_FLG_CLR_SUS, source);
> +
> +	if (source & MASK_MPT) {
> +		/* reset MTP in use flag if set */
> +		if (state->mptrw_in_progress)
> +			state->mptrw_in_progress = 0;
> +	}
> +
> +	if (source & MASK_SUS_END) {
> +		/* reset audio FIFO */
> +		reg = io_read(sd, REG_HDMI_INFO_RST);
> +		reg |= MASK_SR_FIFO_FIFO_CTRL;
> +		io_write(sd, REG_HDMI_INFO_RST, reg);
> +		reg &= ~MASK_SR_FIFO_FIFO_CTRL;
> +		io_write(sd, REG_HDMI_INFO_RST, reg);
> +
> +		/* reset HDMI flags */
> +		state->hdmi_status = 0;
> +	}
> +
> +	/* filter FMT interrupt based on SUS state */
> +	reg = io_read(sd, REG_SUS_STATUS);
> +	if (((reg & MASK_SUS_STATUS) != LAST_STATE_REACHED)
> +	   || (source & MASK_MPT)) {
> +		source &= ~MASK_FMT;
> +	}
> +
> +	if (source & (MASK_FMT | MASK_SUS_END)) {
> +		reg = io_read(sd, REG_SUS_STATUS);
> +		if ((reg & MASK_SUS_STATUS) != LAST_STATE_REACHED) {
> +			v4l_err(state->client, "BAD SUS STATUS\n");
> +			return;
> +		}
> +
> +		/* There is new activity, the status for HDCP repeater state */
> +		state->state_c5_reached = 0;
> +
> +		/* Detect the new resolution */
> +		if (!tda1997x_detect_std(state))
> +			v4l2_subdev_notify_event(&state->sd, &tda1997x_ev_fmt);
> +	}
> +}
> +
> +static void tda1997x_irq_ddc(struct tda1997x_state *state, u8 *flags)
> +{
> +	struct v4l2_subdev *sd = &state->sd;
> +	u8 source;
> +
> +	source = io_read(sd, REG_INT_FLG_CLR_DDC);
> +	io_write(sd, REG_INT_FLG_CLR_DDC, source);
> +	if (source & MASK_EDID_MTP) {
> +		/* reset MTP in use flag if set */
> +		if (state->mptrw_in_progress)
> +			state->mptrw_in_progress = 0;
> +	}
> +
> +	/* Detection of +5V */
> +	if (source & MASK_DET_5V) {
> +		v4l2_ctrl_s_ctrl(state->detect_tx_5v_ctrl,
> +				 tda1997x_detect_tx_5v(sd));
> +	}
> +}
> +
> +static void tda1997x_irq_rate(struct tda1997x_state *state, u8 *flags)
> +{
> +	struct v4l2_subdev *sd = &state->sd;
> +	u8 reg, source;
> +
> +	u8 irq_status, last_irq_status;
> +
> +	source = io_read(sd, REG_INT_FLG_CLR_RATE);
> +	io_write(sd, REG_INT_FLG_CLR_RATE, source);
> +
> +	/* read status regs */
> +	last_irq_status = irq_status = tda1997x_read_activity_status_regs(sd);
> +
> +	/*
> +	 * read clock status reg until INT_FLG_CLR_RATE is still 0
> +	 * after the read to make sure its the last one
> +	 */
> +	reg = source;
> +	while (reg != 0) {
> +		irq_status = tda1997x_read_activity_status_regs(sd);
> +		reg = io_read(sd, REG_INT_FLG_CLR_RATE);
> +		io_write(sd, REG_INT_FLG_CLR_RATE, reg);
> +		source |= reg;
> +	}
> +
> +	/* we only pay attention to stability change events */
> +	if (source & (MASK_RATE_A_ST | MASK_RATE_B_ST)) {
> +		int input = (source & MASK_RATE_A_ST)?0:1;
> +		u8 mask = 1<<input;
> +
> +		/* state change */
> +		if ((irq_status & mask) != (state->activity_status & mask)) {
> +			/* activity lost */
> +			if ((irq_status & mask) == 0) {
> +				v4l_info(state->client,
> +					 "HDMI-%c: Digital Activity Lost\n",
> +					 input+'A');
> +
> +				/* bypass up/down sampler and pixel repeater */
> +				reg = io_read(sd, REG_PIX_REPEAT);
> +				reg &= ~PIX_REPEAT_MASK_UP_SEL;
> +				reg &= ~PIX_REPEAT_MASK_REP;
> +				io_write(sd, REG_PIX_REPEAT, reg);
> +
> +				if (state->chip_revision == 0)
> +					tda1997x_reset_n1(state);
> +
> +				state->detected_timings = NULL;
> +				state->input_detect[input] = 0;
> +				v4l2_subdev_notify_event(sd, &tda1997x_ev_fmt);
> +			}
> +
> +			/* activity detected */
> +			else {
> +				v4l_info(state->client,
> +					 "HDMI-%c: Digital Activity Detected\n",
> +					 input+'A');
> +				state->input_detect[input] = 1;
> +			}
> +
> +			/* hold onto current state */
> +			state->activity_status = (irq_status & mask);
> +		}
> +	}
> +}
> +
> +static void tda1997x_irq_info(struct tda1997x_state *state, u8 *flags)
> +{
> +	struct v4l2_subdev *sd = &state->sd;
> +	u8 source;
> +
> +	source = io_read(sd, REG_INT_FLG_CLR_INFO);
> +	io_write(sd, REG_INT_FLG_CLR_INFO, source);
> +
> +	/* Audio infoframe */
> +	if (source & MASK_AUD_IF) {
> +		tda1997x_parse_infoframe(state, AUD_IF);
> +		source &= ~MASK_AUD_IF;
> +	}
> +
> +	/* Source Product Descriptor infoframe change */
> +	if (source & MASK_SPD_IF) {
> +		tda1997x_parse_infoframe(state, SPD_IF);
> +		source &= ~MASK_SPD_IF;
> +	}
> +
> +	/* Auxiliary Video Information infoframe */
> +	if (source & MASK_AVI_IF) {
> +		tda1997x_parse_infoframe(state, AVI_IF);
> +		source &= ~MASK_AVI_IF;
> +	}
> +}
> +
> +static void tda1997x_irq_audio(struct tda1997x_state *state, u8 *flags)
> +{
> +	struct v4l2_subdev *sd = &state->sd;
> +	u8 reg, source;
> +
> +	source = io_read(sd, REG_INT_FLG_CLR_AUDIO);
> +	io_write(sd, REG_INT_FLG_CLR_AUDIO, source);
> +
> +	/* reset audio FIFO on FIFO pointer error or audio mute */
> +	if (source & MASK_ERROR_FIFO_PT ||
> +	    source & MASK_MUTE_FLG) {
> +		/* audio reset audio FIFO */
> +		reg = io_read(sd, REG_SUS_STATUS);
> +		if ((reg & MASK_SUS_STATUS) == LAST_STATE_REACHED) {
> +			reg = io_read(sd, REG_HDMI_INFO_RST);
> +			reg |= MASK_SR_FIFO_FIFO_CTRL;
> +			io_write(sd, REG_HDMI_INFO_RST, reg);
> +			reg &= ~MASK_SR_FIFO_FIFO_CTRL;
> +			io_write(sd, REG_HDMI_INFO_RST, reg);
> +			/* reset channel status IT if present */
> +			source &= ~(MASK_CH_STATE);
> +		}
> +	}
> +	if (source & MASK_AUDIO_FREQ_FLG) {
> +		static const int freq[] = {
> +			0, 32000, 44100, 48000, 88200, 96000, 176400, 192000
> +		};
> +
> +		reg = io_read(sd, REG_AUDIO_FREQ);
> +		state->audio_samplerate = freq[reg & 7];
> +		v4l_info(state->client, "Audio Frequency Change: %dHz\n",
> +			 state->audio_samplerate);
> +	}
> +	if (source & MASK_AUDIO_FLG) {
> +		reg = io_read(sd, REG_AUDIO_FLAGS);
> +		if (reg & BIT(AUDCFG_TYPE_DST))
> +			state->audio_type = AUDCFG_TYPE_DST;
> +		if (reg & BIT(AUDCFG_TYPE_OBA))
> +			state->audio_type = AUDCFG_TYPE_OBA;
> +		if (reg & BIT(AUDCFG_TYPE_HBR))
> +			state->audio_type = AUDCFG_TYPE_HBR;
> +		if (reg & BIT(AUDCFG_TYPE_PCM))
> +			state->audio_type = AUDCFG_TYPE_PCM;
> +		v4l_info(state->client, "Audio Type: %s\n",
> +			 audtype_names[state->audio_type]);
> +	}
> +}
> +
> +static void tda1997x_irq_hdcp(struct tda1997x_state *state, u8 *flags)
> +{
> +	struct v4l2_subdev *sd = &state->sd;
> +	u8 reg, source;
> +
> +	source = io_read(sd, REG_INT_FLG_CLR_HDCP);
> +	io_write(sd, REG_INT_FLG_CLR_HDCP, source);
> +
> +	/* reset MTP in use flag if set */
> +	if (source & MASK_HDCP_MTP)
> +		state->mptrw_in_progress = 0;
> +	if (source & MASK_STATE_C5) {
> +		/* REPEATER: mask AUDIO and IF irqs to avoid IF during auth */
> +		reg = io_read(sd, REG_INT_MASK_TOP);
> +		reg &= ~(INTERRUPT_AUDIO | INTERRUPT_INFO);
> +		io_write(sd, REG_INT_MASK_TOP, reg);
> +		*flags &= (INTERRUPT_AUDIO | INTERRUPT_INFO);
> +	}
> +}
> +
> +static irqreturn_t tda1997x_isr_thread(int irq, void *d)
> +{
> +	struct tda1997x_state *state = d;
> +	struct v4l2_subdev *sd = &state->sd;
> +	u8 flags;
> +
> +	mutex_lock(&state->lock);
> +	do {
> +		/* read interrupt flags */
> +		flags = io_read(sd, REG_INT_FLG_CLR_TOP);
> +		if (flags == 0)
> +			break;
> +
> +		/* SUS interrupt source (Input activity events) */
> +		if (flags & INTERRUPT_SUS)
> +			tda1997x_irq_sus(state, &flags);
> +		/* DDC interrupt source (Display Data Channel) */
> +		else if (flags & INTERRUPT_DDC)
> +			tda1997x_irq_ddc(state, &flags);
> +		/* RATE interrupt source (Digital Input activity) */
> +		else if (flags & INTERRUPT_RATE)
> +			tda1997x_irq_rate(state, &flags);
> +		/* Infoframe change interrupt */
> +		else if (flags & INTERRUPT_INFO)
> +			tda1997x_irq_info(state, &flags);
> +		/* Audio interrupt source:
> +		 *   freq change, DST,OBA,HBR,ASP flags, mute, FIFO err
> +		 */
> +		else if (flags & INTERRUPT_AUDIO)
> +			tda1997x_irq_audio(state, &flags);
> +		/* HDCP interrupt source (content protection) */
> +		if (flags & INTERRUPT_HDCP)
> +			tda1997x_irq_hdcp(state, &flags);
> +	} while (flags != 0);
> +	mutex_unlock(&state->lock);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static bool tda1997x_check_dv_timings(const struct v4l2_dv_timings *timings,
> +				      void *hdl)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(tda1997x_hdmi_modes); i++) {
> +		if (v4l2_match_dv_timings(timings, &tda1997x_hdmi_modes[i],
> +					  0, false))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * v4l2_subdev_video_ops
> + */
> +
> +static int
> +tda1997x_g_input_status(struct v4l2_subdev *sd, u32 *status)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +
> +	mutex_lock(&state->lock);
> +	if (state->detected_timings)
> +		*status = 0;
> +	else
> +		*status |= V4L2_IN_ST_NO_SIGNAL;
> +	mutex_unlock(&state->lock);
> +
> +	return 0;
> +};
> +
> +static int tda1997x_s_dv_timings(struct v4l2_subdev *sd,
> +				struct v4l2_dv_timings *timings)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +	int ret;
> +
> +	v4l_dbg(1, debug, state->client, "%s\n", __func__);
> +	if (!timings)
> +		return -EINVAL;
> +
> +	if (v4l2_match_dv_timings(&state->timings, timings, 0, false))
> +		return 0; /* no changes */
> +
> +	if (!v4l2_valid_dv_timings(timings, &tda1997x_dv_timings_cap,
> +				   tda1997x_check_dv_timings, state))
> +		return -ERANGE;
> +
> +	mutex_lock(&state->lock);
> +	state->timings = *timings;
> +	/* setup frame detection window and VHREF timing generator */
> +	ret = tda1997x_configure_vhref(sd);
> +	if (ret)
> +		goto error;
> +	/* configure colorspace conversion */
> +	ret = tda1997x_configure_csc(sd);
> +	if (ret)
> +		goto error;
> +	mutex_unlock(&state->lock);
> +
> +	return 0;
> +
> +error:
> +	mutex_unlock(&state->lock);
> +	return ret;
> +}
> +
> +static int tda1997x_g_dv_timings(struct v4l2_subdev *sd,
> +				 struct v4l2_dv_timings *timings)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +
> +	v4l_dbg(1, debug, state->client, "%s\n", __func__);
> +	if (!timings)
> +		return -EINVAL;
> +
> +	mutex_lock(&state->lock);
> +	*timings = state->timings;
> +	mutex_unlock(&state->lock);
> +
> +	return 0;
> +}
> +
> +static int tda1997x_query_dv_timings(struct v4l2_subdev *sd,
> +				     struct v4l2_dv_timings *timings)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +	int ret;
> +
> +	v4l_dbg(1, debug, state->client, "%s\n", __func__);
> +	if (!timings)
> +		return -EINVAL;
> +
> +	memset(timings, 0, sizeof(struct v4l2_dv_timings));
> +	mutex_lock(&state->lock);
> +	ret = tda1997x_detect_std(state);
> +	if (!ret)
> +		*timings = *state->detected_timings;
> +	mutex_unlock(&state->lock);
> +
> +	return ret;
> +}
> +
> +static int tda1997x_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +
> +	v4l_dbg(1, debug, state->client, "%s %d\n", __func__, enable);
> +	mutex_lock(&state->lock);
> +	if (!state->detected_timings)
> +		v4l_dbg(1, debug, state->client, "Invalid HDMI signal\n");
> +	mutex_unlock(&state->lock);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_video_ops tda1997x_video_ops = {
> +	.g_input_status = tda1997x_g_input_status,
> +	.s_dv_timings = tda1997x_s_dv_timings,
> +	.g_dv_timings = tda1997x_g_dv_timings,
> +	.query_dv_timings = tda1997x_query_dv_timings,
> +	.s_stream = tda1997x_s_stream,
> +};
> +
> +
> +/* -----------------------------------------------------------------------------
> + * v4l2_subdev_pad_ops
> + */
> +
> +static int tda1997x_enum_mbus_code(struct v4l2_subdev *sd,
> +				  struct v4l2_subdev_pad_config *cfg,
> +				  struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +
> +	v4l_dbg(1, debug, state->client, "%s %d/%d\n", __func__,
> +		code->index, ARRAY_SIZE(state->mbus_codes));
> +	if (code->index >= ARRAY_SIZE(state->mbus_codes))
> +		return -EINVAL;
> +
> +	if (!state->mbus_codes[code->index])
> +		return -EINVAL;
> +
> +	code->code = state->mbus_codes[code->index];
> +
> +	return 0;
> +}
> +
> +static int tda1997x_fill_format(struct tda1997x_state *state,
> +				struct v4l2_mbus_framefmt *format)
> +{
> +	const struct v4l2_bt_timings *bt;
> +
> +	v4l_dbg(1, debug, state->client, "%s\n", __func__);
> +
> +	if (!state->detected_timings)
> +		return -EINVAL;
> +
> +	memset(format, 0, sizeof(*format));
> +	bt = &state->detected_timings->bt;
> +	format->width = bt->width;
> +	format->height = bt->height;
> +	format->colorspace = state->colorimetry.colorspace;
> +	format->field = (bt->interlaced) ?
> +		V4L2_FIELD_SEQ_TB : V4L2_FIELD_NONE;
> +
> +	return 0;
> +}
> +
> +static int tda1997x_get_format(struct v4l2_subdev *sd,
> +			       struct v4l2_subdev_pad_config *cfg,
> +			       struct v4l2_subdev_format *format)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +
> +	v4l_dbg(1, debug, state->client, "%s pad=%d which=%d\n",
> +		__func__, format->pad, format->which);
> +	if (format->pad != TDA1997X_PAD_SOURCE)
> +		return -EINVAL;
> +
> +	tda1997x_fill_format(state, &format->format);
> +
> +	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		struct v4l2_mbus_framefmt *fmt;
> +
> +		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
> +		format->format.code = fmt->code;

As we discovered this failed with v4l2-compliance. I did some digging
and there are two options:

1) Implement the init_cfg pad op to initialize fmt->code with a valid
code.

2) If you see here that fmt->code == 0, then change it to a valid code.

I think 2 is easiest but 1 is a bit cleaner.

When the filehandle is opened the cfg array is zeroed, so that's why
fmt->code is 0 initially.

> +	} else
> +		format->format.code = state->mbus_code;
> +
> +	return 0;
> +}
> +
> +static int tda1997x_set_format(struct v4l2_subdev *sd,
> +			       struct v4l2_subdev_pad_config *cfg,
> +			       struct v4l2_subdev_format *format)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +	u32 code = format->format.code;
> +
> +	v4l_dbg(1, debug, state->client, "%s pad=%d which=%d fmt=0x%x\n",
> +		__func__, format->pad, format->which, format->format.code);
> +	if (format->pad != TDA1997X_PAD_SOURCE)
> +		return -EINVAL;
> +
> +	tda1997x_fill_format(state, &format->format);
> +	format->format.code = code;

This doesn't check if the code is valid! If it is not a known code, then
just pick the first code from the list.

> +
> +	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
> +		struct v4l2_mbus_framefmt *fmt;
> +
> +		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
> +		*fmt = format->format;
> +	} else {
> +		int ret = tda1997x_setup_format(state, format->format.code);
> +		if (ret)
> +			return ret;
> +		/* mbus_code has changed - re-configure csc/vidout */
> +		tda1997x_configure_csc(sd);
> +		tda1997x_configure_vidout(state);
> +	}
> +
> +	return 0;
> +}
> +
> +static int tda1997x_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +
> +	v4l_dbg(1, debug, state->client, "%s pad=%d\n", __func__, edid->pad);
> +	memset(edid->reserved, 0, sizeof(edid->reserved));
> +
> +	if (!state->edid.present)
> +		return -ENODATA;
> +
> +	if (edid->start_block == 0 && edid->blocks == 0) {
> +		edid->blocks = state->edid.blocks;
> +		return 0;
> +	}
> +
> +	if (edid->start_block >= state->edid.blocks)
> +		return -EINVAL;
> +
> +	if (edid->start_block + edid->blocks > state->edid.blocks)
> +		edid->blocks = state->edid.blocks - edid->start_block;
> +
> +	memcpy(edid->edid, state->edid.edid + edid->start_block * 128,
> +	       edid->blocks * 128);
> +
> +	return 0;
> +}
> +
> +static int tda1997x_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +	int i;
> +
> +	v4l_dbg(1, debug, state->client, "%s pad=%d\n", __func__, edid->pad);
> +	memset(edid->reserved, 0, sizeof(edid->reserved));
> +
> +	if (edid->start_block != 0)
> +		return -EINVAL;
> +
> +	if (edid->blocks == 0) {
> +		state->edid.blocks = 0;
> +		state->edid.present = 0;
> +		tda1997x_disable_edid(sd);
> +		return 0;
> +	}
> +
> +	if (edid->blocks > 2) {
> +		edid->blocks = 2;
> +		return -E2BIG;
> +	}
> +
> +	tda1997x_disable_edid(sd);
> +
> +	/* write base EDID */
> +	for (i = 0; i < 128; i++)
> +		io_write(sd, REG_EDID_IN_BYTE0 + i, edid->edid[i]);
> +
> +	/* write CEA Extension */
> +	for (i = 0; i < 128; i++)
> +		io_write(sd, REG_EDID_IN_BYTE128 + i, edid->edid[i+128]);
> +
> +	tda1997x_enable_edid(sd);
> +
> +	return 0;
> +}
> +
> +static int tda1997x_get_dv_timings_cap(struct v4l2_subdev *sd,
> +				       struct v4l2_dv_timings_cap *cap)
> +{

Needs a pad check.

> +	*cap = tda1997x_dv_timings_cap;
> +	return 0;
> +}
> +
> +static int tda1997x_enum_dv_timings(struct v4l2_subdev *sd,
> +				    struct v4l2_enum_dv_timings *timings)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +

Ditto.

> +	return v4l2_enum_dv_timings_cap(timings, &tda1997x_dv_timings_cap,
> +					tda1997x_check_dv_timings, state);
> +}
> +
> +static const struct v4l2_subdev_pad_ops tda1997x_pad_ops = {
> +	.enum_mbus_code = tda1997x_enum_mbus_code,
> +	.get_fmt = tda1997x_get_format,
> +	.set_fmt = tda1997x_set_format,
> +	.get_edid = tda1997x_get_edid,
> +	.set_edid = tda1997x_set_edid,
> +	.dv_timings_cap = tda1997x_get_dv_timings_cap,
> +	.enum_dv_timings = tda1997x_enum_dv_timings,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * v4l2_subdev_core_ops
> + */
> +
> +static int tda1997x_log_infoframe(struct v4l2_subdev *sd, int addr)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +	union hdmi_infoframe frame;
> +	u8 buffer[40];
> +	int len, err;
> +
> +	/* read data */
> +	len = io_readn(sd, addr, sizeof(buffer), buffer);
> +	v4l2_dbg(1, debug, sd, "infoframe: addr=%d len=%d\n", addr, len);
> +	err = hdmi_infoframe_unpack(&frame, buffer);
> +	if (err) {
> +		v4l_err(state->client,
> +			"failed parsing %d byte infoframe: 0x%04x/0x%02x\n",
> +			len, addr, buffer[0]);
> +		return err;
> +	}
> +	hdmi_infoframe_log(KERN_INFO, &state->client->dev, &frame);
> +
> +	return 0;
> +}
> +
> +static int tda1997x_log_status(struct v4l2_subdev *sd)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +	struct v4l2_dv_timings timings;
> +	struct hdmi_avi_infoframe *avi = &state->avi_infoframe;
> +
> +	v4l2_info(sd, "-----Chip status-----\n");
> +	v4l2_info(sd, "Chip: %s N%d\n", state->info->name,
> +		  state->chip_revision + 1);
> +	v4l2_info(sd, "EDID Enabled: %s\n", state->edid.present ? "yes" : "no");
> +
> +	v4l2_info(sd, "-----Signal status-----\n");
> +	v4l2_info(sd, "Cable detected (+5V power): %s\n",
> +		  tda1997x_detect_tx_5v(sd) ? "yes" : "no");
> +	v4l2_info(sd, "HPD detected: %s\n",
> +		  tda1997x_detect_tx_hpd(sd) ? "yes" : "no");
> +
> +	v4l2_info(sd, "-----Video Timings-----\n");
> +	if (tda1997x_query_dv_timings(sd, &timings))
> +		v4l2_info(sd, "No video detected\n");
> +	else
> +		v4l2_print_dv_timings(sd->name, "Detected format: ",
> +				      &timings, true);
> +	v4l2_print_dv_timings(sd->name, "Configured format: ",
> +			      &state->timings, true);
> +
> +	v4l2_info(sd, "-----Color space-----\n");
> +	v4l2_info(sd, "Input color space: %s %s %s",
> +		  hdmi_colorspace_names[avi->colorspace],
> +		  (avi->colorspace == HDMI_COLORSPACE_RGB) ? "" :
> +			hdmi_colorimetry_names[avi->colorimetry],
> +		  v4l2_quantization_names[state->colorimetry.quantization]);
> +	v4l2_info(sd, "Output color space: %s",
> +		  vidfmt_names[state->vid_fmt]);
> +	v4l2_info(sd, "Color space conversion: %s", state->conv ?
> +		  state->conv->name : "None");
> +
> +	v4l2_info(sd, "-----Audio-----\n");
> +	if (state->audio_channels) {
> +		v4l2_info(sd, "audio: %dch %dHz\n", state->audio_channels,
> +			  state->audio_samplerate);
> +	} else {
> +		v4l2_info(sd, "audio: none\n");
> +	}
> +
> +	v4l2_info(sd, "-----Infoframes-----\n");
> +	tda1997x_log_infoframe(sd, AUD_IF);
> +	tda1997x_log_infoframe(sd, SPD_IF);
> +	tda1997x_log_infoframe(sd, AVI_IF);
> +
> +	return 0;
> +}
> +
> +static int tda1997x_subscribe_event(struct v4l2_subdev *sd,
> +				    struct v4l2_fh *fh,
> +				    struct v4l2_event_subscription *sub)
> +{
> +	switch (sub->type) {
> +	case V4L2_EVENT_SOURCE_CHANGE:
> +		return v4l2_src_change_event_subdev_subscribe(sd, fh, sub);
> +	case V4L2_EVENT_CTRL:
> +		return v4l2_ctrl_subdev_subscribe_event(sd, fh, sub);
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static const struct v4l2_subdev_core_ops tda1997x_core_ops = {
> +	.log_status = tda1997x_log_status,
> +	.subscribe_event = tda1997x_subscribe_event,
> +	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * v4l2_subdev_ops
> + */
> +
> +static const struct v4l2_subdev_ops tda1997x_subdev_ops = {
> +	.core = &tda1997x_core_ops,
> +	.video = &tda1997x_video_ops,
> +	.pad = &tda1997x_pad_ops,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * v4l2_controls
> + */
> +
> +static int tda1997x_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct v4l2_subdev *sd = to_sd(ctrl);
> +	struct tda1997x_state *state = to_state(sd);
> +
> +	switch (ctrl->id) {
> +	/* allow overriding the default RGB quantization range */
> +	case V4L2_CID_DV_RX_RGB_RANGE:
> +		state->rgb_quantization_range = ctrl->val;
> +		tda1997x_configure_csc(sd);
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +};
> +
> +static int tda1997x_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct v4l2_subdev *sd = to_sd(ctrl);
> +	struct tda1997x_state *state = to_state(sd);
> +
> +	if (ctrl->id == V4L2_CID_DV_RX_IT_CONTENT_TYPE) {
> +		ctrl->val = state->avi_infoframe.content_type;
> +		return 0;
> +	}
> +	return -EINVAL;
> +};
> +
> +static const struct v4l2_ctrl_ops tda1997x_ctrl_ops = {
> +	.s_ctrl = tda1997x_s_ctrl,
> +	.g_volatile_ctrl = tda1997x_g_volatile_ctrl,
> +};
> +
> +static int tda1997x_core_init(struct v4l2_subdev *sd)
> +{
> +	struct tda1997x_state *state = to_state(sd);
> +	struct tda1997x_platform_data *pdata = &state->pdata;
> +	u8 reg;
> +	int i;
> +
> +	/* disable HPD */
> +	io_write(sd, REG_HPD_AUTO_CTRL, HPD_AUTO_HPD_UNSEL);
> +	if (state->chip_revision == 0) {
> +		io_write(sd, REG_MAN_SUS_HDMI_SEL, MAN_DIS_HDCP | MAN_RST_HDCP);
> +		io_write(sd, REG_CGU_DBG_SEL, 1 << CGU_DBG_CLK_SEL_SHIFT);
> +	}
> +
> +	/* reset infoframe at end of start-up-sequencer */
> +	io_write(sd, REG_SUS_SET_RGB2, 0x06);
> +	io_write(sd, REG_SUS_SET_RGB3, 0x06);
> +
> +	/* Enable TMDS pull-ups */
> +	io_write(sd, REG_RT_MAN_CTRL, RT_MAN_CTRL_RT |
> +		 RT_MAN_CTRL_RT_B | RT_MAN_CTRL_RT_A);
> +
> +	/* enable sync measurement timing */
> +	tda1997x_cec_write(sd, REG_PWR_CONTROL & 0xff, 0x04);
> +	/* adjust CEC clock divider */
> +	tda1997x_cec_write(sd, REG_OSC_DIVIDER & 0xff, 0x03);
> +	tda1997x_cec_write(sd, REG_EN_OSC_PERIOD_LSB & 0xff, 0xa0);
> +	io_write(sd, REG_TIMER_D, 0x54);
> +	/* enable power switch */
> +	reg = tda1997x_cec_read(sd, REG_CONTROL & 0xff);
> +	reg |= 0x20;
> +	tda1997x_cec_write(sd, REG_CONTROL & 0xff, reg);
> +	mdelay(50);
> +
> +	/* read the chip version */
> +	reg = io_read(sd, REG_VERSION);
> +	/* get the chip configuration */
> +	reg = io_read(sd, REG_CMTP_REG10);
> +
> +	/* enable interrupts we care about */
> +	io_write(sd, REG_INT_MASK_TOP,
> +		 INTERRUPT_HDCP | INTERRUPT_AUDIO | INTERRUPT_INFO |
> +		 INTERRUPT_RATE | INTERRUPT_SUS);
> +	/* config_mtp,fmt,sus_end,sus_st */
> +	io_write(sd, REG_INT_MASK_SUS, MASK_MPT | MASK_FMT | MASK_SUS_END);
> +	/* rate stability change for inputs A/B */
> +	io_write(sd, REG_INT_MASK_RATE, MASK_RATE_B_ST | MASK_RATE_A_ST);
> +	/* aud,spd,avi*/
> +	io_write(sd, REG_INT_MASK_INFO,
> +		 MASK_AUD_IF | MASK_SPD_IF | MASK_AVI_IF);
> +	/* audio_freq,audio_flg,mute_flg,fifo_err */
> +	io_write(sd, REG_INT_MASK_AUDIO,
> +		 MASK_AUDIO_FREQ_FLG | MASK_AUDIO_FLG | MASK_MUTE_FLG |
> +		 MASK_ERROR_FIFO_PT);
> +	/* HDCP C5 state reached */
> +	io_write(sd, REG_INT_MASK_HDCP, MASK_STATE_C5);
> +	/* 5V detect and HDP pulse end */
> +	io_write(sd, REG_INT_MASK_DDC, MASK_DET_5V);
> +	/* don't care about AFE/MODE */
> +	io_write(sd, REG_INT_MASK_AFE, 0);
> +	io_write(sd, REG_INT_MASK_MODE, 0);
> +
> +	/* clear all interrupts */
> +	io_write(sd, REG_INT_FLG_CLR_TOP, 0xff);
> +	io_write(sd, REG_INT_FLG_CLR_SUS, 0xff);
> +	io_write(sd, REG_INT_FLG_CLR_DDC, 0xff);
> +	io_write(sd, REG_INT_FLG_CLR_RATE, 0xff);
> +	io_write(sd, REG_INT_FLG_CLR_MODE, 0xff);
> +	io_write(sd, REG_INT_FLG_CLR_INFO, 0xff);
> +	io_write(sd, REG_INT_FLG_CLR_AUDIO, 0xff);
> +	io_write(sd, REG_INT_FLG_CLR_HDCP, 0xff);
> +	io_write(sd, REG_INT_FLG_CLR_AFE, 0xff);
> +
> +	/* init TMDS equalizer */
> +	if (state->chip_revision == 0)
> +		io_write(sd, REG_CGU_DBG_SEL, 1 << CGU_DBG_CLK_SEL_SHIFT);
> +	io_write24(sd, REG_CLK_MIN_RATE, CLK_MIN_RATE);
> +	io_write24(sd, REG_CLK_MAX_RATE, CLK_MAX_RATE);
> +	if (state->chip_revision == 0)
> +		io_write(sd, REG_WDL_CFG, WDL_CFG_VAL);
> +	/* DC filter */
> +	io_write(sd, REG_DEEP_COLOR_CTRL, DC_FILTER_VAL);
> +	/* disable test pattern */
> +	io_write(sd, REG_SVC_MODE, 0x00);
> +	/* update HDMI INFO CTRL */
> +	io_write(sd, REG_INFO_CTRL, 0xff);
> +	/* write HDMI INFO EXCEED value */
> +	io_write(sd, REG_INFO_EXCEED, 3);
> +
> +	if (state->chip_revision == 0)
> +		tda1997x_reset_n1(state);
> +
> +	/*
> +	 * No HDCP acknowledge when HDCP is disabled
> +	 * and reset SUS to force format detection
> +	 */
> +	tda1997x_hdmi_info_reset(sd, NACK_HDCP, true);
> +
> +	/* Set HPD low */
> +	tda1997x_manual_hpd(sd, HPD_LOW_BP);
> +
> +	/* Configure receiver capabilities */
> +	io_write(sd, REG_HDCP_BCAPS, HDCP_HDMI | HDCP_FAST_REAUTH);
> +
> +	/* Configure HDMI: Auto HDCP mode, packet controlled mute */
> +	reg = HDMI_CTRL_MUTE_AUTO << HDMI_CTRL_MUTE_SHIFT;
> +	reg |= HDMI_CTRL_HDCP_AUTO << HDMI_CTRL_HDCP_SHIFT;
> +	io_write(sd, REG_HDMI_CTRL, reg);
> +
> +	/* reset start-up-sequencer to force format detection */
> +	tda1997x_hdmi_info_reset(sd, 0, true);
> +
> +	/* disable matrix conversion */
> +	reg = io_read(sd, REG_VDP_CTRL);
> +	reg |= VDP_CTRL_MATRIX_BP;
> +	io_write(sd, REG_VDP_CTRL, reg);
> +
> +	/* set video output mode */
> +	tda1997x_configure_vidout(state);
> +
> +	/* configure video output port */
> +	for (i = 0; i < 9; i++) {
> +		v4l_dbg(1, debug, state->client, "vidout_cfg[%d]=0x%02x\n", i,
> +			pdata->vidout_port_cfg[i]);
> +		io_write(sd, REG_VP35_32_CTRL + i, pdata->vidout_port_cfg[i]);
> +	}
> +
> +	/* configure audio output port */
> +	tda1997x_configure_audout(sd, 0);
> +
> +	/* configure audio clock freq */
> +	switch (pdata->audout_mclk_fs) {
> +	case 512:
> +		reg = AUDIO_CLOCK_SEL_512FS;
> +		break;
> +	case 256:
> +		reg = AUDIO_CLOCK_SEL_256FS;
> +		break;
> +	case 128:
> +		reg = AUDIO_CLOCK_SEL_128FS;
> +		break;
> +	case 64:
> +		reg = AUDIO_CLOCK_SEL_64FS;
> +		break;
> +	case 32:
> +		reg = AUDIO_CLOCK_SEL_32FS;
> +		break;
> +	default:
> +		reg = AUDIO_CLOCK_SEL_16FS;
> +		break;
> +	}
> +	io_write(sd, REG_AUDIO_CLOCK, reg);
> +
> +	/* reset advanced infoframes (ISRC1/ISRC2/ACP) */
> +	tda1997x_hdmi_info_reset(sd, RESET_AI, false);
> +	/* reset infoframe */
> +	tda1997x_hdmi_info_reset(sd, RESET_IF, false);
> +	/* reset audio infoframes */
> +	tda1997x_hdmi_info_reset(sd, RESET_AUDIO, false);
> +	/* reset gamut */
> +	tda1997x_hdmi_info_reset(sd, RESET_GAMUT, false);
> +
> +	/* get initial HDMI status */
> +	state->hdmi_status = io_read(sd, REG_HDMI_FLAGS);
> +
> +	return 0;
> +}
> +
> +static int tda1997x_set_power(struct tda1997x_state *state, bool on)
> +{
> +	int ret = 0;
> +
> +	if (on) {
> +		ret = regulator_bulk_enable(TDA1997X_NUM_SUPPLIES,
> +					     state->supplies);
> +		msleep(300);
> +	} else {
> +		ret = regulator_bulk_disable(TDA1997X_NUM_SUPPLIES,
> +					     state->supplies);
> +	}
> +
> +	return ret;
> +}
> +
> +static const struct i2c_device_id tda1997x_i2c_id[] = {
> +	{"tda19971", (kernel_ulong_t)&tda1997x_chip_info[TDA19971]},
> +	{"tda19973", (kernel_ulong_t)&tda1997x_chip_info[TDA19973]},
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(i2c, tda1997x_i2c_id);
> +
> +static const struct of_device_id tda1997x_of_id[] __maybe_unused = {
> +	{ .compatible = "nxp,tda19971", .data = &tda1997x_chip_info[TDA19971] },
> +	{ .compatible = "nxp,tda19973", .data = &tda1997x_chip_info[TDA19973] },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, tda1997x_of_id);
> +
> +static int tda1997x_parse_dt(struct tda1997x_state *state)
> +{
> +	struct tda1997x_platform_data *pdata = &state->pdata;
> +	struct v4l2_fwnode_endpoint bus_cfg;
> +	struct device_node *ep;
> +	struct device_node *np;
> +	unsigned int flags;
> +	const char *str;
> +	int ret;
> +	u32 v;
> +
> +	/*
> +	 * setup default values:
> +	 * - HREF: active high from start to end of row
> +	 * - VS: Vertical Sync active high at beginning of frame
> +	 * - DE: Active high when data valid
> +	 * - A_CLK: 128*Fs
> +	 */
> +	pdata->vidout_sel_hs = HS_HREF_SEL_HREF_VHREF;
> +	pdata->vidout_sel_vs = VS_VREF_SEL_VREF_HDMI;
> +	pdata->vidout_sel_de = DE_FREF_SEL_DE_VHREF;
> +
> +	np = state->client->dev.of_node;
> +	ep = of_graph_get_next_endpoint(np, NULL);
> +	if (!ep)
> +		return -EINVAL;
> +
> +	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &bus_cfg);
> +	if (ret) {
> +		of_node_put(ep);
> +		return ret;
> +	}
> +	of_node_put(ep);
> +	pdata->vidout_bus_type = bus_cfg.bus_type;
> +
> +	/* polarity of HS/VS/DE */
> +	flags = bus_cfg.bus.parallel.flags;
> +	if (flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
> +		pdata->vidout_inv_hs = 1;
> +	if (flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
> +		pdata->vidout_inv_vs = 1;
> +	if (flags & V4L2_MBUS_DATA_ACTIVE_LOW)
> +		pdata->vidout_inv_de = 1;
> +	pdata->vidout_bus_width = bus_cfg.bus.parallel.bus_width;
> +
> +	/* video output port config */
> +	ret = of_property_count_u32_elems(np, "nxp,vidout-portcfg");
> +	if (ret > 0) {
> +		u32 reg, val, i;
> +
> +		for (i = 0; i < ret / 2 && i < 9; i++) {
> +			of_property_read_u32_index(np, "nxp,vidout-portcfg",
> +						   i * 2, &reg);
> +			of_property_read_u32_index(np, "nxp,vidout-portcfg",
> +						   i * 2 + 1, &val);
> +			if (reg < 9)
> +				pdata->vidout_port_cfg[reg] = val;
> +		}
> +	} else {
> +		v4l_err(state->client, "nxp,vidout-portcfg missing\n");
> +		return -EINVAL;
> +	}
> +
> +	/* default to channel layout dictated by packet header */
> +	pdata->audout_layoutauto = true;
> +
> +	pdata->audout_format = AUDFMT_TYPE_DISABLED;
> +	if (!of_property_read_string(np, "nxp,audout-format", &str)) {
> +		if (strcmp(str, "i2s") == 0)
> +			pdata->audout_format = AUDFMT_TYPE_I2S;
> +		else if (strcmp(str, "spdif") == 0)
> +			pdata->audout_format = AUDFMT_TYPE_SPDIF;
> +		else {
> +			v4l_err(state->client, "nxp,audout-format invalid\n");
> +			return -EINVAL;
> +		}
> +		if (!of_property_read_u32(np, "nxp,audout-layout", &v)) {
> +			switch (v) {
> +			case 0:
> +			case 1:
> +				break;
> +			default:
> +				v4l_err(state->client,
> +					"nxp,audout-layout invalid\n");
> +				return -EINVAL;
> +			}
> +			pdata->audout_layout = v;
> +		}
> +		if (!of_property_read_u32(np, "nxp,audout-width", &v)) {
> +			switch (v) {
> +			case 16:
> +			case 32:
> +				break;
> +			default:
> +				v4l_err(state->client,
> +					"nxp,audout-width invalid\n");
> +				return -EINVAL;
> +			}
> +			pdata->audout_width = v;
> +		}
> +		if (!of_property_read_u32(np, "nxp,audout-mclk-fs", &v)) {
> +			switch (v) {
> +			case 512:
> +			case 256:
> +			case 128:
> +			case 64:
> +			case 32:
> +			case 16:
> +				break;
> +			default:
> +				v4l_err(state->client,
> +					"nxp,audout-mclk-fs invalid\n");
> +				return -EINVAL;
> +			}
> +			pdata->audout_mclk_fs = v;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int tda1997x_get_regulators(struct tda1997x_state *state)
> +{
> +	int i;
> +
> +	for (i = 0; i < TDA1997X_NUM_SUPPLIES; i++)
> +		state->supplies[i].supply = tda1997x_supply_name[i];
> +
> +	return devm_regulator_bulk_get(&state->client->dev,
> +				       TDA1997X_NUM_SUPPLIES,
> +				       state->supplies);
> +}
> +
> +static int tda1997x_identify_module(struct tda1997x_state *state)
> +{
> +	struct v4l2_subdev *sd = &state->sd;
> +	enum tda1997x_type type;
> +	u8 reg;
> +
> +	/* Read chip configuration*/
> +	reg = io_read(sd, REG_CMTP_REG10);
> +	state->tmdsb_clk = (reg >> 6) & 0x01; /* use tmds clock B_inv for B */
> +	state->tmdsb_soc = (reg >> 5) & 0x01; /* tmds of input B */
> +	state->port_30bit = (reg >> 2) & 0x03; /* 30bit vs 24bit */
> +	state->output_2p5 = (reg >> 1) & 0x01; /* output supply 2.5v */
> +	switch ((reg >> 4) & 0x03) {
> +	case 0x00:
> +		type = TDA19971;
> +		break;
> +	case 0x02:
> +	case 0x03:
> +		type = TDA19973;
> +		break;
> +	default:
> +		dev_err(&state->client->dev, "unsupported chip ID\n");
> +		return -EIO;
> +	}
> +	if (state->info->type != type) {
> +		dev_err(&state->client->dev, "chip id mismatch\n");
> +		return -EIO;
> +	}
> +
> +	/* read chip revision */
> +	state->chip_revision = io_read(sd, REG_CMTP_REG11);
> +
> +	return 0;
> +}
> +
> +static const struct media_entity_operations tda1997x_media_ops = {
> +	.link_validate = v4l2_subdev_link_validate,
> +};
> +
> +
> +/* -----------------------------------------------------------------------------
> + * HDMI Audio Codec
> + */
> +
> +/* refine sample-rate based on HDMI source */
> +static int tda1997x_pcm_startup(struct snd_pcm_substream *substream,
> +				struct snd_soc_dai *dai)
> +{
> +	struct tda1997x_state *state = snd_soc_dai_get_drvdata(dai);
> +	struct snd_soc_codec *codec = dai->codec;
> +	struct snd_pcm_runtime *rtd = substream->runtime;
> +	int rate, err;
> +
> +	rate = state->audio_samplerate;
> +	err = snd_pcm_hw_constraint_minmax(rtd, SNDRV_PCM_HW_PARAM_RATE,
> +					   rate, rate);
> +	if (err < 0) {
> +		dev_err(codec->dev, "failed to constrain samplerate to %dHz\n",
> +			rate);
> +		return err;
> +	}
> +	dev_info(codec->dev, "set samplerate constraint to %dHz\n", rate);
> +
> +	return 0;
> +}
> +
> +static const struct snd_soc_dai_ops tda1997x_dai_ops = {
> +	.startup = tda1997x_pcm_startup,
> +};
> +
> +static struct snd_soc_dai_driver tda1997x_audio_dai = {
> +	.name = "tda1997x",
> +	.capture = {
> +		.stream_name = "Capture",
> +		.channels_min = 2,
> +		.channels_max = 8,
> +		.rates = SNDRV_PCM_RATE_32000 | SNDRV_PCM_RATE_44100 |
> +			 SNDRV_PCM_RATE_48000 | SNDRV_PCM_RATE_88200 |
> +			 SNDRV_PCM_RATE_96000 | SNDRV_PCM_RATE_176400 |
> +			 SNDRV_PCM_RATE_192000,
> +	},
> +	.ops = &tda1997x_dai_ops,
> +};
> +
> +static int tda1997x_codec_probe(struct snd_soc_codec *codec)
> +{
> +	return 0;
> +}
> +
> +static int tda1997x_codec_remove(struct snd_soc_codec *codec)
> +{
> +	return 0;
> +}
> +
> +static struct snd_soc_codec_driver tda1997x_codec_driver = {
> +	.probe = tda1997x_codec_probe,
> +	.remove = tda1997x_codec_remove,
> +	.reg_word_size = sizeof(u16),
> +};
> +
> +static int tda1997x_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *id)
> +{
> +	struct tda1997x_state *state;
> +	struct tda1997x_platform_data *pdata;
> +	struct v4l2_subdev *sd;
> +	struct v4l2_ctrl_handler *hdl;
> +	struct v4l2_ctrl *ctrl;
> +	static const struct v4l2_dv_timings cea1920x1080 =
> +		V4L2_DV_BT_CEA_1920X1080P60;
> +	u32 *mbus_codes;
> +	int i, ret;
> +
> +	/* Check if the adapter supports the needed features */
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> +		return -EIO;
> +
> +	state = kzalloc(sizeof(struct tda1997x_state), GFP_KERNEL);
> +	if (!state)
> +		return -ENOMEM;
> +
> +	state->client = client;
> +	pdata = &state->pdata;
> +	if (IS_ENABLED(CONFIG_OF) && client->dev.of_node) {
> +		const struct of_device_id *oid;
> +
> +		oid = of_match_node(tda1997x_of_id, client->dev.of_node);
> +		state->info = oid->data;
> +
> +		ret = tda1997x_parse_dt(state);
> +		if (ret < 0) {
> +			v4l_err(client, "DT parsing error\n");
> +			goto err_free_state;
> +		}
> +	} else if (client->dev.platform_data) {
> +		struct tda1997x_platform_data *pdata =
> +			client->dev.platform_data;
> +		state->info =
> +			(const struct tda1997x_chip_info *)id->driver_data;
> +		state->pdata = *pdata;
> +	} else {
> +		v4l_err(client, "No platform data\n");
> +		ret = -ENODEV;
> +		goto err_free_state;
> +	}
> +
> +	ret = tda1997x_get_regulators(state);
> +	if (ret)
> +		goto err_free_state;
> +
> +	ret = tda1997x_set_power(state, 1);
> +	if (ret)
> +		goto err_free_state;
> +
> +	mutex_init(&state->page_lock);
> +	mutex_init(&state->lock);
> +	state->page = 0xff;
> +
> +	INIT_DELAYED_WORK(&state->delayed_work_enable_hpd,
> +			  tda1997x_delayed_work_enable_hpd);
> +
> +	/* set video format based on chip and bus width */
> +	ret = tda1997x_identify_module(state);
> +	if (ret)
> +		goto err_free_mutex;
> +
> +	/* initialize subdev */
> +	sd = &state->sd;
> +	v4l2_i2c_subdev_init(sd, client, &tda1997x_subdev_ops);
> +	snprintf(sd->name, sizeof(sd->name), "%s %d-%04x",
> +		 id->name, i2c_adapter_id(client->adapter),
> +		 client->addr);
> +	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
> +	sd->entity.ops = &tda1997x_media_ops;
> +
> +	/* set allowed mbus modes based on chip, bus-type, and bus-width */
> +	i = 0;
> +	mbus_codes = state->mbus_codes;
> +	switch (state->info->type) {
> +	case TDA19973:
> +		switch (pdata->vidout_bus_type) {
> +		case V4L2_MBUS_PARALLEL:
> +			switch (pdata->vidout_bus_width) {
> +			case 36:
> +				mbus_codes[i++] = MEDIA_BUS_FMT_RGB121212_1X36;
> +				mbus_codes[i++] = MEDIA_BUS_FMT_YUV12_1X36;
> +				/* fall-through */
> +			case 24:
> +				mbus_codes[i++] = MEDIA_BUS_FMT_UYVY12_1X24;
> +				break;
> +			}
> +			break;
> +		case V4L2_MBUS_BT656:
> +			switch (pdata->vidout_bus_width) {
> +			case 36:
> +			case 24:
> +			case 12:
> +				mbus_codes[i++] = MEDIA_BUS_FMT_UYVY12_2X12;
> +				mbus_codes[i++] = MEDIA_BUS_FMT_UYVY10_2X10;
> +				mbus_codes[i++] = MEDIA_BUS_FMT_UYVY8_2X8;
> +				break;
> +			}
> +			break;
> +		default:
> +			break;
> +		}
> +		break;
> +	case TDA19971:
> +		switch (pdata->vidout_bus_type) {
> +		case V4L2_MBUS_PARALLEL:
> +			switch (pdata->vidout_bus_width) {
> +			case 24:
> +				mbus_codes[i++] = MEDIA_BUS_FMT_RGB888_1X24;
> +				mbus_codes[i++] = MEDIA_BUS_FMT_YUV8_1X24;
> +				mbus_codes[i++] = MEDIA_BUS_FMT_UYVY12_1X24;
> +				/* fall through */
> +			case 20:
> +				mbus_codes[i++] = MEDIA_BUS_FMT_UYVY10_1X20;
> +				/* fall through */
> +			case 16:
> +				mbus_codes[i++] = MEDIA_BUS_FMT_UYVY8_1X16;
> +				break;
> +			}
> +			break;
> +		case V4L2_MBUS_BT656:
> +			switch (pdata->vidout_bus_width) {
> +			case 12:
> +				mbus_codes[i++] = MEDIA_BUS_FMT_UYVY12_2X12;
> +				/* fall through */
> +			case 10:
> +				mbus_codes[i++] = MEDIA_BUS_FMT_UYVY10_2X10;
> +				/* fall through */
> +			case 8:
> +				mbus_codes[i++] = MEDIA_BUS_FMT_UYVY8_2X8;
> +				break;
> +			}
> +			break;
> +		default:
> +			break;
> +		}
> +		break;
> +	}

Add a sanity check here:

	if (WARN_ON(i > ARRAY_SIZE(state->mbus_codes))
		// bail out

It's all to easy to forget to increase the mbus_codes array if a new code is
added later.

> +
> +	/* default format */
> +	tda1997x_setup_format(state, state->mbus_codes[0]);
> +	state->timings = cea1920x1080;
> +
> +	/*
> +	 * default to SRGB full range quantization
> +	 * (in case we don't get an infoframe such as DVI signal
> +	 */
> +	state->colorimetry.colorspace = V4L2_COLORSPACE_SRGB;
> +	state->colorimetry.quantization = V4L2_QUANTIZATION_FULL_RANGE;
> +
> +	/* disable/reset HDCP to get correct I2C access to Rx HDMI */
> +	io_write(sd, REG_MAN_SUS_HDMI_SEL, MAN_RST_HDCP | MAN_DIS_HDCP);
> +
> +	/*
> +	 * if N2 version, reset compdel_bp as it may generate some small pixel
> +	 * shifts in case of embedded sync/or delay lower than 4
> +	 */
> +	if (state->chip_revision != 0) {
> +		io_write(sd, REG_MAN_SUS_HDMI_SEL, 0x00);
> +		io_write(sd, REG_VDP_CTRL, 0x1f);
> +	}
> +
> +	v4l_info(client, "NXP %s N%d detected\n", state->info->name,
> +		 state->chip_revision + 1);
> +	v4l_info(client, "video: %dbit %s %d formats available\n",
> +		pdata->vidout_bus_width,
> +		(pdata->vidout_bus_type == V4L2_MBUS_PARALLEL) ?
> +			"parallel" : "BT656",
> +		i);
> +	if (pdata->audout_format) {
> +		v4l_info(client, "audio: %dch %s layout%d sysclk=%d*fs\n",
> +			 pdata->audout_layout ? 2 : 8,
> +			 audfmt_names[pdata->audout_format],
> +			 pdata->audout_layout,
> +			 pdata->audout_mclk_fs);
> +	}
> +
> +	ret = 0x34 + ((io_read(sd, REG_SLAVE_ADDR)>>4) & 0x03);
> +	state->client_cec = i2c_new_dummy(client->adapter, ret);
> +	v4l_info(client, "CEC slave address 0x%02x\n", ret);
> +
> +	ret = tda1997x_core_init(sd);
> +	if (ret)
> +		goto err_free_mutex;
> +
> +	/* control handlers */
> +	hdl = &state->hdl;
> +	v4l2_ctrl_handler_init(hdl, 5);
> +	ctrl = v4l2_ctrl_new_std_menu(hdl, &tda1997x_ctrl_ops,
> +			V4L2_CID_DV_RX_IT_CONTENT_TYPE,
> +			V4L2_DV_IT_CONTENT_TYPE_NO_ITC, 0,
> +			V4L2_DV_IT_CONTENT_TYPE_NO_ITC);
> +	if (ctrl)
> +		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
> +	/* custom controls */
> +	state->detect_tx_5v_ctrl = v4l2_ctrl_new_std(hdl, NULL,
> +			V4L2_CID_DV_RX_POWER_PRESENT, 0, 1, 0, 0);
> +	state->rgb_quantization_range_ctrl = v4l2_ctrl_new_std_menu(hdl,
> +			&tda1997x_ctrl_ops,
> +			V4L2_CID_DV_RX_RGB_RANGE, V4L2_DV_RGB_RANGE_FULL, 0,
> +			V4L2_DV_RGB_RANGE_AUTO);
> +
> +	/* initialize source pads */
> +	state->pads[TDA1997X_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
> +	ret = media_entity_pads_init(&sd->entity, TDA1997X_NUM_PADS,
> +		state->pads);
> +	if (ret) {
> +		v4l_err(client, "failed entity_init: %d", ret);
> +		goto err_free_mutex;
> +	}
> +
> +	ret = v4l2_async_register_subdev(sd);
> +	if (ret)
> +		goto err_free_media;
> +
> +	/* register audio DAI */
> +	if (pdata->audout_format) {
> +		u64 formats;
> +
> +		if (pdata->audout_width == 32)
> +			formats = SNDRV_PCM_FMTBIT_S32_LE;
> +		else
> +			formats = SNDRV_PCM_FMTBIT_S16_LE;
> +		tda1997x_audio_dai.capture.formats = formats;
> +		ret = snd_soc_register_codec(&state->client->dev,
> +					     &tda1997x_codec_driver,
> +					     &tda1997x_audio_dai, 1);
> +		if (ret) {
> +			dev_err(&client->dev, "register audio codec failed\n");
> +			goto err_free_media;
> +		}
> +		dev_set_drvdata(&state->client->dev, state);
> +		v4l_info(state->client, "registered audio codec\n");
> +	}
> +
> +	/* request irq */
> +	ret = devm_request_threaded_irq(&client->dev, client->irq,
> +					NULL, tda1997x_isr_thread,
> +					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> +					KBUILD_MODNAME, state);
> +	if (ret) {
> +		v4l_err(client, "irq%d reg failed: %d\n", client->irq, ret);
> +		goto err_free_media;
> +	}
> +
> +	return 0;
> +
> +err_free_media:
> +	media_entity_cleanup(&sd->entity);
> +err_free_mutex:
> +	cancel_delayed_work(&state->delayed_work_enable_hpd);
> +	mutex_destroy(&state->page_lock);
> +	mutex_destroy(&state->lock);
> +err_free_state:
> +	kfree(state);
> +	dev_err(&client->dev, "%s failed: %d\n", __func__, ret);
> +
> +	return ret;
> +}
> +
> +static int tda1997x_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct tda1997x_state *state = to_state(sd);
> +	struct tda1997x_platform_data *pdata = &state->pdata;
> +
> +	if (pdata->audout_format) {
> +		snd_soc_unregister_codec(&client->dev);
> +		mutex_destroy(&state->audio_lock);
> +	}
> +
> +	disable_irq(state->client->irq);
> +	tda1997x_power_mode(state, 0);
> +
> +	v4l2_async_unregister_subdev(sd);
> +	media_entity_cleanup(&sd->entity);
> +	regulator_bulk_disable(TDA1997X_NUM_SUPPLIES, state->supplies);
> +	i2c_unregister_device(state->client_cec);
> +	cancel_delayed_work(&state->delayed_work_enable_hpd);
> +	mutex_destroy(&state->page_lock);
> +	mutex_destroy(&state->lock);
> +
> +	kfree(state);
> +
> +	return 0;
> +}
> +
> +static struct i2c_driver tda1997x_i2c_driver = {
> +	.driver = {
> +		.name = "tda1997x",
> +		.owner = THIS_MODULE,
> +		.of_match_table = of_match_ptr(tda1997x_of_id),
> +	},
> +	.probe = tda1997x_probe,
> +	.remove = tda1997x_remove,
> +	.id_table = tda1997x_i2c_id,
> +};
> +
> +module_i2c_driver(tda1997x_i2c_driver);
> +
> +MODULE_AUTHOR("Tim Harvey <tharvey@gateworks.com>");
> +MODULE_DESCRIPTION("TDA1997X HDMI Receiver driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/media/i2c/tda1997x.h b/include/media/i2c/tda1997x.h
> new file mode 100644
> index 0000000..c6c2a8a
> --- /dev/null
> +++ b/include/media/i2c/tda1997x.h
> @@ -0,0 +1,42 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * tda1997x - NXP HDMI receiver
> + *
> + * Copyright 2017 Tim Harvey <tharvey@gateworks.com>
> + *
> + */
> +
> +#ifndef _TDA1997X_
> +#define _TDA1997X_
> +
> +/* Platform Data */
> +struct tda1997x_platform_data {
> +	enum v4l2_mbus_type vidout_bus_type;
> +	u32 vidout_bus_width;
> +	u8 vidout_port_cfg[9];
> +	/* pin polarity (1=invert) */
> +	bool vidout_inv_de;
> +	bool vidout_inv_hs;
> +	bool vidout_inv_vs;
> +	bool vidout_inv_pclk;
> +	/* clock delays (0=-8, 1=-7 ... 15=+7 pixels) */
> +	u8 vidout_delay_hs;
> +	u8 vidout_delay_vs;
> +	u8 vidout_delay_de;
> +	u8 vidout_delay_pclk;
> +	/* sync selections (controls how sync pins are derived) */
> +	u8 vidout_sel_hs;
> +	u8 vidout_sel_vs;
> +	u8 vidout_sel_de;
> +
> +	/* Audio Port Output */
> +	int audout_format;
> +	u32 audout_mclk_fs;	/* clock multiplier */
> +	u32 audout_width;	/* 13 or 32 bit */
> +	u32 audout_layout;	/* layout0=AP0 layout1=AP0,AP1,AP2,AP3 */
> +	bool audout_layoutauto;	/* audio layout dictated by pkt header */
> +	bool audout_invert_clk;	/* data valid on rising edge of BCLK */
> +	bool audio_auto_mute;	/* enable hardware audio auto-mute */
> +};
> +
> +#endif
> 

Regards,

	Hans
