Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1662 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149AbZJOQOK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2009 12:14:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH 5/6 v5] TVP7002 driver for DM365
Date: Thu, 15 Oct 2009 18:13:03 +0200
Cc: santiago.nunez@ridgerun.com, todd.fischer@ridgerun.com,
	linux-media@vger.kernel.org
References: <1255617834-1483-1-git-send-email-santiago.nunez@ridgerun.com>
In-Reply-To: <1255617834-1483-1-git-send-email-santiago.nunez@ridgerun.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910151813.03893.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 15 October 2009 16:43:54 santiago.nunez@ridgerun.com wrote:
> From: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
> 
> This patch provides the implementation of the TVP7002 decoder
> driver for DM365.
> 
> Signed-off-by: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
> ---
>  drivers/media/video/tvp7002.c | 1585 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 1585 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/tvp7002.c
> 
> diff --git a/drivers/media/video/tvp7002.c b/drivers/media/video/tvp7002.c
> new file mode 100644
> index 0000000..1452599
> --- /dev/null
> +++ b/drivers/media/video/tvp7002.c
> @@ -0,0 +1,1585 @@
> +/* Texas Instruments Triple 8-/10-BIT 165-/110-MSPS Video and Graphics
> + * Digitizer with Horizontal PLL registers
> + *
> + * Copyright (C) 2009 Texas Instruments Inc
> + * Author: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
> + *
> + * This code is partially based upon the TVP5150 driver
> + * written by Mauro Carvalho Chehab (mchehab@infradead.org),
> + * the TVP514x driver written by Vaibhav Hiremath <hvaibhav@ti.com>
> + * and the TVP7002 driver in the TI LSP 2.10.00.14. Revisions by
> + * Muralidharan Karicheri and Snehaprabha Narnakaje (TI).
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +#include <linux/delay.h>
> +#include <linux/i2c.h>
> +#include <linux/videodev2.h>
> +#include <media/davinci/videohd.h>
> +#include <media/tvp7002.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-chip-ident.h>
> +#include "tvp7002_reg.h"
> +
> +MODULE_DESCRIPTION("TI TVP7002 Video and Graphics Digitizer driver");
> +MODULE_AUTHOR("Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>");
> +MODULE_LICENSE("GPL");
> +
> +/* Module Name */
> +#define TVP7002_MODULE_NAME		"tvp7002"
> +
> +/* I2C retry attempts */
> +#define I2C_RETRY_COUNT			(5)
> +
> +/* Debug functions */
> +static int debug;
> +module_param(debug, bool, 0644);
> +MODULE_PARM_DESC(debug, "Debug level (0-2)");
> +
> +/* Structure for register values */
> +struct i2c_reg_value {
> +	u8 reg;
> +	u8 value;
> +	u8 type;
> +};
> +
> +/*
> + * Register default values (according to tvp7002 datasheet)
> + * In the case of read-only registers, the value (0xff) is
> + * never written. R/W functionality is controlled by the
> + * writable bit in the register struct definition.
> + */
> +static const struct i2c_reg_value tvp7002_init_default[] = {
> +	{ TVP7002_CHIP_REV, 0xff, TVP7002_READ },
> +	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x67, TVP7002_WRITE },
> +	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x20, TVP7002_WRITE },
> +	{ TVP7002_HPLL_CRTL, 0xa0, TVP7002_WRITE },
> +	{ TVP7002_HPLL_PHASE_SEL, 0x80, TVP7002_WRITE },
> +	{ TVP7002_CLAMP_START, 0x32, TVP7002_WRITE },
> +	{ TVP7002_CLAMP_W, 0x20, TVP7002_WRITE },
> +	{ TVP7002_HSYNC_OUT_W, 0x60, TVP7002_WRITE },
> +	{ TVP7002_B_FINE_GAIN, 0x00, TVP7002_WRITE },
> +	{ TVP7002_G_FINE_GAIN, 0x00, TVP7002_WRITE },
> +	{ TVP7002_R_FINE_GAIN, 0x00, TVP7002_WRITE },
> +	{ TVP7002_B_FINE_OFF_MSBS, 0x80, TVP7002_WRITE },
> +	{ TVP7002_G_FINE_OFF_MSBS, 0x80, TVP7002_WRITE },
> +	{ TVP7002_R_FINE_OFF_MSBS, 0x80, TVP7002_WRITE },
> +	{ TVP7002_SYNC_CTL_1, 0x20, TVP7002_WRITE },
> +	{ TVP7002_HPLL_AND_CLAMP_CTL, 0x2e, TVP7002_WRITE },
> +	{ TVP7002_SYNC_ON_G_THRS, 0x5d, TVP7002_WRITE },
> +	{ TVP7002_SYNC_SEPARATOR_THRS, 0x47, TVP7002_WRITE },
> +	{ TVP7002_HPLL_PRE_COAST, 0x00, TVP7002_WRITE },
> +	{ TVP7002_HPLL_POST_COAST, 0x00, TVP7002_WRITE },
> +	{ TVP7002_SYNC_DETECT_STAT, 0xff, TVP7002_READ },
> +	{ TVP7002_OUT_FORMATTER, 0x47, TVP7002_WRITE },
> +	{ TVP7002_MISC_CTL_1, 0x01, TVP7002_WRITE },
> +	{ TVP7002_MISC_CTL_2, 0x00, TVP7002_WRITE },
> +	{ TVP7002_MISC_CTL_3, 0x01, TVP7002_WRITE },
> +	{ TVP7002_IN_MUX_SEL_1, 0x00, TVP7002_WRITE },
> +	{ TVP7002_IN_MUX_SEL_2, 0x67, TVP7002_WRITE },
> +	{ TVP7002_B_AND_G_COARSE_GAIN, 0x77, TVP7002_WRITE },
> +	{ TVP7002_R_COARSE_GAIN, 0x07, TVP7002_WRITE },
> +	{ TVP7002_FINE_OFF_LSBS, 0x00, TVP7002_WRITE },
> +	{ TVP7002_B_COARSE_OFF, 0x10, TVP7002_WRITE },
> +	{ TVP7002_G_COARSE_OFF, 0x10, TVP7002_WRITE },
> +	{ TVP7002_R_COARSE_OFF, 0x10, TVP7002_WRITE },
> +	{ TVP7002_HSOUT_OUT_START, 0x08, TVP7002_WRITE },
> +	{ TVP7002_MISC_CTL_4, 0x00, TVP7002_WRITE },
> +	{ TVP7002_B_DGTL_ALC_OUT_LSBS, 0xff, TVP7002_READ },
> +	{ TVP7002_G_DGTL_ALC_OUT_LSBS, 0xff, TVP7002_READ },
> +	{ TVP7002_R_DGTL_ALC_OUT_LSBS, 0xff, TVP7002_READ },
> +	{ TVP7002_AUTO_LVL_CTL_ENABLE, 0x80, TVP7002_WRITE },
> +	{ TVP7002_DGTL_ALC_OUT_MSBS, 0xff, TVP7002_READ },
> +	{ TVP7002_AUTO_LVL_CTL_FILTER, 0x53, TVP7002_WRITE },
> +	{ 0x29, 0x08, TVP7002_RESERVED },
> +	{ TVP7002_FINE_CLAMP_CTL, 0x07, TVP7002_WRITE },
> +	/* PWR_CTL is controlled only by the probe and reset functions */
> +	{ TVP7002_PWR_CTL, 0x00, TVP7002_RESERVED },
> +	{ TVP7002_ADC_SETUP, 0x50, TVP7002_WRITE },
> +	{ TVP7002_COARSE_CLAMP_CTL, 0x00, TVP7002_WRITE },
> +	{ TVP7002_SOG_CLAMP, 0x80, TVP7002_WRITE },
> +	{ TVP7002_RGB_COARSE_CLAMP_CTL, 0x00, TVP7002_WRITE },
> +	{ TVP7002_SOG_COARSE_CLAMP_CTL, 0x04, TVP7002_WRITE },
> +	{ TVP7002_ALC_PLACEMENT, 0x5a, TVP7002_WRITE },
> +	{ 0x32, 0x18, TVP7002_RESERVED },
> +	{ 0x33, 0x60, TVP7002_RESERVED },
> +	{ TVP7002_MVIS_STRIPPER_W, 0xff, TVP7002_RESERVED },
> +	{ TVP7002_VSYNC_ALGN, 0x10, TVP7002_WRITE },
> +	{ TVP7002_SYNC_BYPASS, 0x00, TVP7002_WRITE },
> +	{ TVP7002_L_FRAME_STAT_LSBS, 0xff, TVP7002_READ },
> +	{ TVP7002_L_FRAME_STAT_MSBS, 0xff, TVP7002_READ },
> +	{ TVP7002_CLK_L_STAT_LSBS, 0xff, TVP7002_READ },
> +	{ TVP7002_CLK_L_STAT_MSBS, 0xff, TVP7002_READ },
> +	{ TVP7002_HSYNC_W, 0xff, TVP7002_READ },
> +	{ TVP7002_VSYNC_W, 0xff, TVP7002_READ },
> +	{ TVP7002_L_LENGTH_TOL, 0x03, TVP7002_WRITE },
> +	{ 0x3e, 0x60, TVP7002_RESERVED },
> +	{ TVP7002_VIDEO_BWTH_CTL, 0x01, TVP7002_WRITE },
> +	{ TVP7002_AVID_START_PIXEL_LSBS, 0x01, TVP7002_WRITE },
> +	{ TVP7002_AVID_START_PIXEL_MSBS, 0x2c, TVP7002_WRITE },
> +	{ TVP7002_AVID_STOP_PIXEL_LSBS, 0x06, TVP7002_WRITE },
> +	{ TVP7002_AVID_STOP_PIXEL_MSBS, 0x2c, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_0_START_L_OFF, 0x05, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_1_START_L_OFF, 0x00, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_0_DURATION, 0x1e, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_1_DURATION, 0x00, TVP7002_WRITE },
> +	{ TVP7002_FBIT_F_0_START_L_OFF, 0x00, TVP7002_WRITE },
> +	{ TVP7002_FBIT_F_1_START_L_OFF, 0x00, TVP7002_WRITE },
> +	{ TVP7002_YUV_Y_G_COEF_LSBS, 0xe3, TVP7002_WRITE },
> +	{ TVP7002_YUV_Y_G_COEF_MSBS, 0x16, TVP7002_WRITE },
> +	{ TVP7002_YUV_Y_B_COEF_LSBS, 0x4f, TVP7002_WRITE },
> +	{ TVP7002_YUV_Y_B_COEF_MSBS, 0x02, TVP7002_WRITE },
> +	{ TVP7002_YUV_Y_R_COEF_LSBS, 0xce, TVP7002_WRITE },
> +	{ TVP7002_YUV_Y_R_COEF_MSBS, 0x06, TVP7002_WRITE },
> +	{ TVP7002_YUV_U_G_COEF_LSBS, 0xab, TVP7002_WRITE },
> +	{ TVP7002_YUV_U_G_COEF_MSBS, 0xf3, TVP7002_WRITE },
> +	{ TVP7002_YUV_U_B_COEF_LSBS, 0x00, TVP7002_WRITE },
> +	{ TVP7002_YUV_U_B_COEF_MSBS, 0x10, TVP7002_WRITE },
> +	{ TVP7002_YUV_U_R_COEF_LSBS, 0x55, TVP7002_WRITE },
> +	{ TVP7002_YUV_U_R_COEF_MSBS, 0xfc, TVP7002_WRITE },
> +	{ TVP7002_YUV_V_G_COEF_LSBS, 0x78, TVP7002_WRITE },
> +	{ TVP7002_YUV_V_G_COEF_MSBS, 0xf1, TVP7002_WRITE },
> +	{ TVP7002_YUV_V_B_COEF_LSBS, 0x88, TVP7002_WRITE },
> +	{ TVP7002_YUV_V_B_COEF_MSBS, 0xfe, TVP7002_WRITE },
> +	{ TVP7002_YUV_V_R_COEF_LSBS, 0x00, TVP7002_WRITE },
> +	{ TVP7002_YUV_V_R_COEF_MSBS, 0x10, TVP7002_WRITE },
> +	/* This signals end of register values */
> +	{ 0x5c, 0xff, TVP7002_RESERVED }
> +};
> +
> +/* Register parameters for 480P */
> +static const struct i2c_reg_value tvp7002_parms_480P[] = {
> +	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x35, TVP7002_WRITE },
> +	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x0a, TVP7002_WRITE },
> +	{ TVP7002_HPLL_CRTL, 0x02, TVP7002_WRITE },
> +	{ TVP7002_HPLL_PHASE_SEL, 0x14, TVP7002_WRITE },
> +	{ TVP7002_AVID_START_PIXEL_LSBS, 0x91, TVP7002_WRITE },
> +	{ TVP7002_AVID_START_PIXEL_MSBS, 0x00, TVP7002_WRITE },
> +	{ TVP7002_AVID_STOP_PIXEL_LSBS, 0x0B, TVP7002_WRITE },
> +	{ TVP7002_AVID_STOP_PIXEL_MSBS, 0x00, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_0_START_L_OFF, 0x03, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_1_START_L_OFF, 0x01, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_0_DURATION, 0x13, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_1_DURATION, 0x13, TVP7002_WRITE },
> +	{ TVP7002_ALC_PLACEMENT, 0x18, TVP7002_WRITE },
> +	{ TVP7002_CLAMP_START, 0x06, TVP7002_WRITE },
> +	{ TVP7002_CLAMP_W, 0x10, TVP7002_WRITE },
> +	{ TVP7002_HPLL_PRE_COAST, 0x03, TVP7002_WRITE },
> +	{ TVP7002_HPLL_POST_COAST, 0x03, TVP7002_WRITE },
> +	{ 0x5c, 0xff, TVP7002_RESERVED }
> +};
> +
> +/* Register parameters for 576P */
> +static const struct i2c_reg_value tvp7002_parms_576P[] = {
> +	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x36, TVP7002_WRITE },
> +	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x00, TVP7002_WRITE },
> +	{ TVP7002_HPLL_CRTL, 0x18, TVP7002_WRITE },
> +	{ TVP7002_HPLL_PHASE_SEL, 0x14, TVP7002_WRITE },
> +	{ TVP7002_AVID_START_PIXEL_LSBS, 0x9B, TVP7002_WRITE },
> +	{ TVP7002_AVID_START_PIXEL_MSBS, 0x00, TVP7002_WRITE },
> +	{ TVP7002_AVID_STOP_PIXEL_LSBS, 0x0F, TVP7002_WRITE },
> +	{ TVP7002_AVID_STOP_PIXEL_MSBS, 0x00, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_0_START_L_OFF, 0x00, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_1_START_L_OFF, 0x00, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_0_DURATION, 0x2D, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_1_DURATION, 0x00, TVP7002_WRITE },
> +	{ TVP7002_ALC_PLACEMENT, 0x18, TVP7002_WRITE },
> +	{ TVP7002_CLAMP_START, 0x06, TVP7002_WRITE },
> +	{ TVP7002_CLAMP_W, 0x10, TVP7002_WRITE },
> +	{ TVP7002_HPLL_PRE_COAST, 0x03, TVP7002_WRITE },
> +	{ TVP7002_HPLL_POST_COAST, 0x03, TVP7002_WRITE },
> +	{ 0x5c, 0xff, TVP7002_RESERVED }
> +};
> +
> +/* Register parameters for 1080I60 */
> +static const struct i2c_reg_value tvp7002_parms_1080I60[] = {
> +	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x89, TVP7002_WRITE },
> +	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x08, TVP7002_WRITE },
> +	{ TVP7002_HPLL_CRTL, 0x98, TVP7002_WRITE },
> +	{ TVP7002_HPLL_PHASE_SEL, 0x14, TVP7002_WRITE },
> +	{ TVP7002_AVID_START_PIXEL_LSBS, 0x06, TVP7002_WRITE },
> +	{ TVP7002_AVID_START_PIXEL_MSBS, 0x01, TVP7002_WRITE },
> +	{ TVP7002_AVID_STOP_PIXEL_LSBS, 0x8a, TVP7002_WRITE },
> +	{ TVP7002_AVID_STOP_PIXEL_MSBS, 0x08, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_0_START_L_OFF, 0x02, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_1_START_L_OFF, 0x02, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_0_DURATION, 0x16, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_1_DURATION, 0x17, TVP7002_WRITE },
> +	{ TVP7002_ALC_PLACEMENT, 0x5a, TVP7002_WRITE },
> +	{ TVP7002_CLAMP_START, 0x32, TVP7002_WRITE },
> +	{ TVP7002_CLAMP_W, 0x20, TVP7002_WRITE },
> +	{ TVP7002_HPLL_PRE_COAST, 0x01, TVP7002_WRITE },
> +	{ TVP7002_HPLL_POST_COAST, 0x00, TVP7002_WRITE },
> +	{ 0x5c, 0xff, TVP7002_RESERVED }
> +};
> +
> +/* Register parameters for 1080I50 */
> +static const struct i2c_reg_value tvp7002_parms_1080I50[] = {
> +	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0xa5, TVP7002_WRITE },
> +	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x00, TVP7002_WRITE },
> +	{ TVP7002_HPLL_CRTL, 0x98, TVP7002_WRITE },
> +	{ TVP7002_HPLL_PHASE_SEL, 0x14, TVP7002_WRITE },
> +	{ TVP7002_AVID_START_PIXEL_LSBS, 0x06, TVP7002_WRITE },
> +	{ TVP7002_AVID_START_PIXEL_MSBS, 0x01, TVP7002_WRITE },
> +	{ TVP7002_AVID_STOP_PIXEL_LSBS, 0x8a, TVP7002_WRITE },
> +	{ TVP7002_AVID_STOP_PIXEL_MSBS, 0x08, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_0_START_L_OFF, 0x02, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_1_START_L_OFF, 0x02, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_0_DURATION, 0x16, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_1_DURATION, 0x17, TVP7002_WRITE },
> +	{ TVP7002_ALC_PLACEMENT, 0x5a, TVP7002_WRITE },
> +	{ TVP7002_CLAMP_START, 0x32, TVP7002_WRITE },
> +	{ TVP7002_CLAMP_W, 0x20, TVP7002_WRITE },
> +	{ TVP7002_HPLL_PRE_COAST, 0x01, TVP7002_WRITE },
> +	{ TVP7002_HPLL_POST_COAST, 0x00, TVP7002_WRITE },
> +	{ 0x5c, 0xff, TVP7002_RESERVED }
> +};
> +
> +/* Register parameters for 720P60 */
> +static const struct i2c_reg_value tvp7002_parms_720P60[] = {
> +	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x67, TVP7002_WRITE },
> +	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x02, TVP7002_WRITE },
> +	{ TVP7002_HPLL_CRTL, 0xa0, TVP7002_WRITE },
> +	{ TVP7002_HPLL_PHASE_SEL, 0x16, TVP7002_WRITE },
> +	{ TVP7002_AVID_START_PIXEL_LSBS, 0x47, TVP7002_WRITE },
> +	{ TVP7002_AVID_START_PIXEL_MSBS, 0x01, TVP7002_WRITE },
> +	{ TVP7002_AVID_STOP_PIXEL_LSBS, 0x4B, TVP7002_WRITE },
> +	{ TVP7002_AVID_STOP_PIXEL_MSBS, 0x06, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_0_START_L_OFF, 0x05, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_1_START_L_OFF, 0x00, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_0_DURATION, 0x2D, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_1_DURATION, 0x00, TVP7002_WRITE },
> +	{ TVP7002_ALC_PLACEMENT, 0x5a, TVP7002_WRITE },
> +	{ TVP7002_CLAMP_START, 0x32, TVP7002_WRITE },
> +	{ TVP7002_CLAMP_W, 0x20, TVP7002_WRITE },
> +	{ TVP7002_HPLL_PRE_COAST, 0x00, TVP7002_WRITE },
> +	{ TVP7002_HPLL_POST_COAST, 0x00, TVP7002_WRITE },
> +	{ 0x5c, 0xff, TVP7002_RESERVED }
> +};
> +
> +/* Register parameters for 720P50 */
> +static const struct i2c_reg_value tvp7002_parms_720P50[] = {
> +	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x7b, TVP7002_WRITE },
> +	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x0c, TVP7002_WRITE },
> +	{ TVP7002_HPLL_CRTL, 0x98, TVP7002_WRITE },
> +	{ TVP7002_HPLL_PHASE_SEL, 0x16, TVP7002_WRITE },
> +	{ TVP7002_AVID_START_PIXEL_LSBS, 0x47, TVP7002_WRITE },
> +	{ TVP7002_AVID_START_PIXEL_MSBS, 0x01, TVP7002_WRITE },
> +	{ TVP7002_AVID_STOP_PIXEL_LSBS, 0x4B, TVP7002_WRITE },
> +	{ TVP7002_AVID_STOP_PIXEL_MSBS, 0x06, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_0_START_L_OFF, 0x05, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_1_START_L_OFF, 0x00, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_0_DURATION, 0x2D, TVP7002_WRITE },
> +	{ TVP7002_VBLK_F_1_DURATION, 0x00, TVP7002_WRITE },
> +	{ TVP7002_ALC_PLACEMENT, 0x5a, TVP7002_WRITE },
> +	{ TVP7002_CLAMP_START, 0x32, TVP7002_WRITE },
> +	{ TVP7002_CLAMP_W, 0x20, TVP7002_WRITE },
> +	{ TVP7002_HPLL_PRE_COAST, 0x01, TVP7002_WRITE },
> +	{ TVP7002_HPLL_POST_COAST, 0x00, TVP7002_WRITE },
> +	{ 0x5c, 0xff, TVP7002_RESERVED }
> +};
> +
> +/* Struct list for available formats */
> +static const struct v4l2_fmtdesc tvp7002_fmt_list[] = {
> +	{
> +	 .index = 0,
> +	 .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> +	 .flags = 0,
> +	 .description = "8-bit UYVY 4:2:2 Format",
> +	 .pixelformat = V4L2_PIX_FMT_UYVY,
> +	},
> +};
> +
> +/* Struct list for available standards */
> +static struct v4l2_standard tvp7002_standards[] = {
> +	{
> +		.index = 0,
> +		.id = V4L2_STD_720P_60,
> +		.name = "720P-60",
> +		.frameperiod = {1, 60},
> +		.framelines = 720
> +	},
> +	{
> +		.index = 1,
> +		.id = V4L2_STD_1080I_60,
> +		.name = "1080I-30",
> +		.frameperiod = {1, 30},
> +		.framelines = 1080
> +	},
> +	{
> +		.index = 2,
> +		.id = V4L2_STD_1080I_50,
> +		.name = "1080I-25",
> +		.frameperiod = {1, 25},
> +		.framelines = 1080
> +	},
> +	{
> +		.index = 3,
> +		.id = V4L2_STD_720P_50,
> +		.name = "720P-50",
> +		.frameperiod = {1, 50},
> +		.framelines = 720
> +	},
> +	{
> +		.index = 4,
> +		.id = V4L2_STD_525P_60,
> +		.name = "480P-60",
> +		.frameperiod = {1, 60},
> +		.framelines = 525
> +	},
> +	{
> +		.index = 5,
> +		.id = V4L2_STD_625P_50,
> +		.name = "576P-50",
> +		.frameperiod = {1, 50},
> +		.framelines = 625
> +	},
> +};
> +
> +/* Device definition */
> +struct tvp7002 {
> +	struct v4l2_subdev sd;
> +	const struct tvp7002_config *pdata;
> +	struct i2c_reg_value registers[ARRAY_SIZE(tvp7002_init_default)];
> +
> +	int ver;
> +	int streaming;
> +
> +	struct v4l2_pix_format pix;
> +	const struct v4l2_fmtdesc *fmt_list;
> +	int num_fmts;
> +
> +	struct v4l2_standard *std_list;
> +	v4l2_std_id current_std;
> +	int num_stds;
> +};
> +
> +/*
> + * to_tvp7002 - Obtain device handler TVP7002
> + * @sd: ptr to v4l2_subdev struct
> + *
> + * Returns device handler tvp7002.
> + */
> +static inline struct tvp7002 *to_tvp7002(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct tvp7002, sd);
> +}
> +
> +/*
> + * tvp7002_read - Read a value from a register in an TVP7002
> + * @sd: ptr to v4l2_subdev struct
> + * @reg: TVP7002 register address
> + * @dst: pointer to 8-bit destination
> + *
> + * Returns value read if successful, or non-zero (-1) otherwise.
> + */
> +static int tvp7002_read(struct v4l2_subdev *sd, u8 addr, u8 *dst)
> +{
> +	struct i2c_client *c = v4l2_get_subdevdata(sd);
> +	int retry;
> +	int error;
> +
> +	for (retry = 0; retry < I2C_RETRY_COUNT; retry++) {
> +		error = i2c_smbus_read_byte_data(c, addr);
> +
> +		if (error >= 0) {
> +			*dst = (u8)error;
> +			return 0;
> +		}
> +
> +		msleep_interruptible(10);
> +	}
> +	v4l2_err(sd, "TVP7002 read error %d\n", error);
> +	return error;
> +}
> +
> +/*
> + * tvp7002_write() - Write a value to a register in TVP7002
> + * @sd: ptr to v4l2_subdev struct
> + * @addr: TVP7002 register address
> + * @value: value to be written to the register
> + *
> + * Write a value to a register in an TVP7002 decoder device.
> + * Returns zero if successful, or non-zero otherwise.
> + */
> +static int tvp7002_write(struct v4l2_subdev *sd, u8 addr, u8 value)
> +{
> +	struct i2c_client *c;
> +	int retry;
> +	int error;
> +
> +	c = v4l2_get_subdevdata(sd);
> +
> +	for (retry = 0; retry < I2C_RETRY_COUNT; retry++) {
> +		error = i2c_smbus_write_byte_data(c, addr, value);
> +
> +		if (error >= 0)
> +			return 0;
> +
> +		v4l2_warn(sd, "Write: retry ... %d\n", retry);
> +		msleep_interruptible(10);
> +	}
> +	v4l2_err(sd, "TVP7002 write error %d\n", error);
> +	return error;
> +}
> +
> +/*
> + * tvp7002_write_err() - Write a register value with error code
> + * @sd: pointer to standard V4L2 sub-device structure
> + * @reg: destination register
> + * @val: value to be written
> + * @error: pointer to error value
> + *
> + * Write a value in a register and save error value in pointer.
> + * Also update the register table if successful
> + */
> +static inline void tvp7002_write_err(struct v4l2_subdev *sd, u8 reg,
> +							u8 val, int *err)
> +{
> +	if (!*err)
> +		*err = tvp7002_write(sd, reg, val);
> +	else
> +		v4l2_err(sd, "Unable to write in register 0x%02X", reg);

Please don't report this error again: tvp7002_write will already report this.

> +}
> +
> +/*
> + * tvp7002_log_chk() - Check reading the value of a register
> + * @sd: ptr to v4l2_subdev struct
> + * @reg: register to read
> + * @message: register name/function
> + *
> + * Check procedure for reading a register.
> + * Returns nothing (void).
> + */
> +static inline void tvp7002_log_chk(struct v4l2_subdev *sd, u8 reg,
> +							const char *message)
> +{
> +	int error;
> +	u8 result;
> +
> +	error = tvp7002_read(sd, reg, &result);
> +
> +	if (error >= 0)
> +		v4l2_info(sd, "%s (0x%02x) = 0x%02x\n", message, reg, result);
> +	else
> +		v4l2_info(sd, "Error reading 0x%02x\n", reg);

Ditto: no need to report an error if tvp7002_read will already do that for you.

> +}
> +
> +/*
> + * tvp7002_log_status() - Print information about register settings
> + * @sd: ptr to v4l2_subdev struct
> + *
> + * Log register values of a TVP7002 decoder device.
> + * Returns zero or -EINVAL if read operation fails.
> + */
> +static int tvp7002_log_status(struct v4l2_subdev *sd)
> +{
> +	tvp7002_log_chk(sd, TVP7002_CHIP_REV, "Chip revision number");
> +	tvp7002_log_chk(sd, TVP7002_HPLL_FDBK_DIV_LSBS,
> +						"H-PLL feedback div LSB");
> +	tvp7002_log_chk(sd, TVP7002_HPLL_FDBK_DIV_MSBS,
> +						"H-PLL feedback div MSB");
> +	tvp7002_log_chk(sd, TVP7002_HPLL_CRTL,
> +						"VCO freq range selector");
> +	tvp7002_log_chk(sd, TVP7002_HPLL_PHASE_SEL,
> +						"ADC sampling clk phase sel");
> +	tvp7002_log_chk(sd, TVP7002_CLAMP_START, "Clamp start");
> +	tvp7002_log_chk(sd, TVP7002_CLAMP_W, "Clamp width");
> +	tvp7002_log_chk(sd, TVP7002_HSYNC_OUT_W, "HSYNC output width");
> +	tvp7002_log_chk(sd, TVP7002_B_FINE_GAIN, "Digital fine grain B ch");
> +	tvp7002_log_chk(sd, TVP7002_G_FINE_GAIN, "Digital fine grain G ch");
> +	tvp7002_log_chk(sd, TVP7002_R_FINE_GAIN, "Digital fine grain R ch");
> +	tvp7002_log_chk(sd, TVP7002_B_FINE_OFF_MSBS,
> +						"Digital fine grain off B ch");
> +	tvp7002_log_chk(sd, TVP7002_G_FINE_OFF_MSBS,
> +						"Digital fine grain off G ch");
> +	tvp7002_log_chk(sd, TVP7002_R_FINE_OFF_MSBS,
> +						"Digital fine grain off R ch");
> +	tvp7002_log_chk(sd, TVP7002_FINE_OFF_LSBS, "Dig fine grain off LSBs");
> +	tvp7002_log_chk(sd, TVP7002_SYNC_CTL_1, "Sync control 1");
> +	tvp7002_log_chk(sd, TVP7002_HPLL_AND_CLAMP_CTL,
> +						"H-PLL and clamp control");
> +	tvp7002_log_chk(sd, TVP7002_SYNC_ON_G_THRS, "Sync-On-Green threshold");
> +	tvp7002_log_chk(sd, TVP7002_SYNC_SEPARATOR_THRS,
> +						"Sync separator thrshold");
> +	tvp7002_log_chk(sd, TVP7002_HPLL_PRE_COAST, "H-PLL pre-coast");
> +	tvp7002_log_chk(sd, TVP7002_HPLL_POST_COAST, "H-PLL post-coast");
> +	tvp7002_log_chk(sd, TVP7002_SYNC_DETECT_STAT, "Sync detect status");
> +	tvp7002_log_chk(sd, TVP7002_OUT_FORMATTER, "Output formatter");
> +	tvp7002_log_chk(sd, TVP7002_MISC_CTL_1, "Miscelaneous control 1");
> +	tvp7002_log_chk(sd, TVP7002_MISC_CTL_2, "Miscelaneous control 2");
> +	tvp7002_log_chk(sd, TVP7002_MISC_CTL_3, "Miscelaneous control 3");
> +	tvp7002_log_chk(sd, TVP7002_IN_MUX_SEL_1, "Input Mux Selector 1");
> +	tvp7002_log_chk(sd, TVP7002_IN_MUX_SEL_2, "Input Mux Selector 2");
> +	tvp7002_log_chk(sd, TVP7002_B_AND_G_COARSE_GAIN, "B, G coarse gain");
> +	tvp7002_log_chk(sd, TVP7002_R_COARSE_GAIN, "R coarse gain");
> +	tvp7002_log_chk(sd, TVP7002_B_COARSE_OFF, "Coarse offset for B ch");
> +	tvp7002_log_chk(sd, TVP7002_G_COARSE_OFF, "Coarse offset for G ch");
> +	tvp7002_log_chk(sd, TVP7002_R_COARSE_OFF, "Coarse offset for R ch");
> +	tvp7002_log_chk(sd, TVP7002_HSOUT_OUT_START,
> +						"HSYNC lead edge out start");
> +	tvp7002_log_chk(sd, TVP7002_MISC_CTL_4, "Miscelaneous control 4");
> +	tvp7002_log_chk(sd, TVP7002_B_DGTL_ALC_OUT_LSBS,
> +						"Flt ALC out B ch LSBs");
> +	tvp7002_log_chk(sd, TVP7002_G_DGTL_ALC_OUT_LSBS,
> +						"Flt ALC out G ch LSBs");
> +	tvp7002_log_chk(sd, TVP7002_R_DGTL_ALC_OUT_LSBS,
> +						"Flt ALC out R ch LSBs");
> +	tvp7002_log_chk(sd, TVP7002_AUTO_LVL_CTL_ENABLE,
> +						"Auto level ctrl enable");
> +	tvp7002_log_chk(sd, TVP7002_DGTL_ALC_OUT_MSBS,
> +						"Filt ALC out RGB chs MSB");
> +	tvp7002_log_chk(sd, TVP7002_AUTO_LVL_CTL_FILTER,
> +						"Auto level ctrl filter");
> +	tvp7002_log_chk(sd, 0x29, "Reserved register");
> +	tvp7002_log_chk(sd, TVP7002_FINE_CLAMP_CTL, "Fine clamp control");
> +	tvp7002_log_chk(sd, TVP7002_PWR_CTL, "Power control");
> +	tvp7002_log_chk(sd, TVP7002_ADC_SETUP, "ADC setup");
> +	tvp7002_log_chk(sd, TVP7002_COARSE_CLAMP_CTL, "Coarse clamp ctrl");
> +	tvp7002_log_chk(sd, TVP7002_SOG_CLAMP, "Sync-On-Green clamp");
> +	tvp7002_log_chk(sd, TVP7002_RGB_COARSE_CLAMP_CTL,
> +						"RGB coarse clamp ctrl");
> +	tvp7002_log_chk(sd, TVP7002_SOG_COARSE_CLAMP_CTL,
> +						"SOG coarse clamp ctrl");
> +	tvp7002_log_chk(sd, TVP7002_ALC_PLACEMENT, "ALC placement");
> +	tvp7002_log_chk(sd, 0x32, "Reserved register");
> +	tvp7002_log_chk(sd, 0x33, "Reserved register");
> +	tvp7002_log_chk(sd, TVP7002_MVIS_STRIPPER_W,
> +						"Macrovision stripper width");
> +	tvp7002_log_chk(sd, TVP7002_SYNC_BYPASS, "Sync bypass");
> +	tvp7002_log_chk(sd, TVP7002_L_FRAME_STAT_LSBS,
> +						"Lines p Frame status LSBs");
> +	tvp7002_log_chk(sd, TVP7002_L_FRAME_STAT_MSBS,
> +						"Lines p Frame status MSBs");
> +	tvp7002_log_chk(sd, TVP7002_CLK_L_STAT_LSBS, "Clks p line stat LSBs");
> +	tvp7002_log_chk(sd, TVP7002_CLK_L_STAT_MSBS, "Clks p line stat MSBs");
> +	tvp7002_log_chk(sd, TVP7002_HSYNC_W, "HSYNC width");
> +	tvp7002_log_chk(sd, TVP7002_VSYNC_W, "VSYNC width");
> +	tvp7002_log_chk(sd, TVP7002_L_LENGTH_TOL, "Line length tolerance");
> +	tvp7002_log_chk(sd, 0x3e, "Reserved register");

Why log reserved registers?

> +	tvp7002_log_chk(sd, TVP7002_VIDEO_BWTH_CTL, "Video bandwth control");
> +	tvp7002_log_chk(sd, TVP7002_AVID_START_PIXEL_LSBS,
> +						"AVID start pixel LSBs");
> +	tvp7002_log_chk(sd, TVP7002_AVID_START_PIXEL_MSBS,
> +						"AVID start pixel MSBs");
> +	tvp7002_log_chk(sd, TVP7002_AVID_STOP_PIXEL_LSBS,
> +						"AVID stop pixel LSBs");
> +	tvp7002_log_chk(sd, TVP7002_AVID_STOP_PIXEL_MSBS,
> +						"AVID stop pixel MSBs");
> +	tvp7002_log_chk(sd, TVP7002_VBLK_F_0_START_L_OFF,
> +						"VBLK start line off 0");
> +	tvp7002_log_chk(sd, TVP7002_VBLK_F_1_START_L_OFF,
> +						"VBLK start line off 1");
> +	tvp7002_log_chk(sd, TVP7002_VBLK_F_0_DURATION, "VBLK duration 0");
> +	tvp7002_log_chk(sd, TVP7002_VBLK_F_1_DURATION, "VBLK duration 1");
> +	tvp7002_log_chk(sd, TVP7002_FBIT_F_0_START_L_OFF,
> +						"FBIT start line off 0");
> +	tvp7002_log_chk(sd, TVP7002_FBIT_F_1_START_L_OFF,
> +						"FBIT start line off 1");
> +	tvp7002_log_chk(sd, TVP7002_YUV_Y_G_COEF_LSBS, "YUV Y G LSBs");
> +	tvp7002_log_chk(sd, TVP7002_YUV_Y_G_COEF_MSBS, "YUV Y G MSBs");
> +	tvp7002_log_chk(sd, TVP7002_YUV_Y_B_COEF_LSBS, "YUV Y B LSBs");
> +	tvp7002_log_chk(sd, TVP7002_YUV_Y_B_COEF_MSBS, "YUV Y B MSBs");
> +	tvp7002_log_chk(sd, TVP7002_YUV_Y_R_COEF_LSBS, "YUV Y R LSBs");
> +	tvp7002_log_chk(sd, TVP7002_YUV_Y_R_COEF_MSBS, "YUV Y R MSBs");
> +	tvp7002_log_chk(sd, TVP7002_YUV_U_G_COEF_LSBS, "YUV U G LSBs");
> +	tvp7002_log_chk(sd, TVP7002_YUV_U_G_COEF_MSBS, "YUV U G MSBs");
> +	tvp7002_log_chk(sd, TVP7002_YUV_U_B_COEF_LSBS, "YUV U B LSBs");
> +	tvp7002_log_chk(sd, TVP7002_YUV_U_B_COEF_MSBS, "YUV U B MSBs");
> +	tvp7002_log_chk(sd, TVP7002_YUV_U_R_COEF_LSBS, "YUV U R LSBs");
> +	tvp7002_log_chk(sd, TVP7002_YUV_U_R_COEF_MSBS, "YUV U R MSBs");
> +	tvp7002_log_chk(sd, TVP7002_YUV_V_G_COEF_LSBS, "YUV V G LSBs");
> +	tvp7002_log_chk(sd, TVP7002_YUV_V_G_COEF_MSBS, "YUV V G MSBs");
> +	tvp7002_log_chk(sd, TVP7002_YUV_V_B_COEF_LSBS, "YUV V B LSBs");
> +	tvp7002_log_chk(sd, TVP7002_YUV_V_B_COEF_MSBS, "YUV V B MSBs");
> +	tvp7002_log_chk(sd, TVP7002_YUV_V_R_COEF_LSBS, "YUV V R LSBs");
> +	tvp7002_log_chk(sd, TVP7002_YUV_V_R_COEF_MSBS, "YUV V R MSBs");

Wouldn't it make more sense to create a log_chk16 and print these values
as full 16-bit numbers?

To be honest, are you sure you want to dump all these registers?

To get a register dump you can also adapt the v4l2-dbg.cpp tool.

LOG_STATUS is really meant to get concise high-level status information.
To give an example: this is what the saa7115 and saa7127 log as status:

   saa7115 6-0021: Audio frequency: 48000 Hz
   saa7115 6-0021: Input:           Composite 4
   saa7115 6-0021: Video signal:    bad
   saa7115 6-0021: Frequency:       50 Hz
   saa7115 6-0021: Detected format: BW/No color
   saa7115 6-0021: Width, Height:   720, 576
   saa7127 6-0044: Standard: 50 Hz
   saa7127 6-0044: Input:    normal
   saa7127 6-0044: Output:   S-Video + Composite
   saa7127 6-0044: WSS:      disabled
   saa7127 6-0044: VPS:      disabled
   saa7127 6-0044: CC:       disabled

These days I'd probably shorten this even more, for example by combining the
last three lines of the saa7127 status info.

The idea of LOG_STATUS isn't to do a reg dump but to provide a quick overview
of the internal state of the device: e.g. what output is it using? what's the
resolution? is it connected to a display? is it receiving stable video? etc.

To get a reg dump the v4l2-dbg tool is much more appropriate.

> +
> +	return 0;
> +}
> +
> +/*
> + * tvp7002_g_chip_ident() - Get chip identification number
> + * @sd: ptr to v4l2_subdev struct
> + * @chip: ptr to v4l2_dbg_chip_ident struct
> + *
> + * Obtains the chip's identification number.
> + * Returns zero or -EINVAL if read operation fails.
> + */
> +static int tvp7002_g_chip_ident(struct v4l2_subdev *sd,
> +					struct v4l2_dbg_chip_ident *chip)
> +{
> +	u8 rev;
> +	int error;
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	error = tvp7002_read(sd, TVP7002_CHIP_REV, &rev);
> +
> +	if (error < 0)
> +		return -EINVAL;
> +
> +	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_TVP7002,
> +									rev);
> +}
> +
> +/*
> + * tvp7002_write_inittab() - Write initialization values
> + * @sd: ptr to v4l2_subdev struct
> + * @regs: ptr to i2c_reg_value struct
> + *
> + * Write initialization values.
> + * Returns zero or -EINVAL if read operation fails.
> + */
> +static int tvp7002_write_inittab(struct v4l2_subdev *sd,
> +					const struct i2c_reg_value *regs)
> +{
> +	int error = 0;
> +
> +	/* Initialize the first (defined) registers */
> +	while (0x5c != regs->reg) {
> +		if (TVP7002_WRITE == regs->type)
> +			error = tvp7002_write(sd, regs->reg, regs->value);
> +		if (error < 0)
> +			return -EINVAL;

Why not propagate the tvp7002_write error?

> +		regs++;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * tvp7002_update_dev_tab() - Update device's register table
> + * @sd: pointer to standard V4L2 sub-device structure
> + * @tab: pointer to device table
> + *
> + * Update state information in the device's register table.
> + * Returns 0 on success or -EINVAL on error.
> + */
> +static int tvp7002_update_dev_tab(struct v4l2_subdev *sd,
> +					const struct i2c_reg_value *regs)
> +{
> +	struct tvp7002 *device = to_tvp7002(sd);
> +
> +	if (!regs)
> +		return -EINVAL;
> +
> +	while (0x5c != regs->reg) {

Magic number 0x5c?

> +		device->registers[regs->reg].value = regs->value;
> +		regs++;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * tvp7002_set_fmt_parms() - Write parameters to set video mode
> + * @sd: pointer to standard V4L2 sub-device structure
> + * @regs: pointer to register table
> + *
> + * Set video mode register-dependent parameters
> + * Returns 0 on success or -EINVAL on error.
> + */
> +static int tvp7002_set_fmt_parms(struct v4l2_subdev *sd,
> +						struct i2c_reg_value *regs){
> +	int error;
> +
> +	v4l2_dbg(1, debug, sd, "Setting format parameters...\n");
> +
> +	if (regs == NULL) {
> +		v4l2_err(sd, "Parameter reference is NULL.\n");
> +		return -EINVAL;
> +	}
> +
> +	error = tvp7002_write_inittab(sd, regs);
> +
> +	if (error < 0) {
> +		v4l2_err(sd, "Error in setting video parameters\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Update our device device information */
> +	error = tvp7002_update_dev_tab(sd, regs);

Just do return tvp7002_update_dev_tab(sd, regs);

> +
> +	return error;
> +}
> +
> +/*
> + * tvp7002_map_set_std() - Map and set video standard to register parameters
> + * @std: v4l2_std_id (u64) integer
> + *
> + * Returns 0 if successful or -EINVAL on error.
> + */
> +static int tvp7002_map_set_std(struct v4l2_subdev *sd, v4l2_std_id std)
> +{
> +	int error;
> +
> +	switch (std) {
> +	case V4L2_STD_525P_60:
> +		error = tvp7002_set_fmt_parms(sd,
> +				(struct i2c_reg_value *)tvp7002_parms_480P);
> +		break;
> +	case V4L2_STD_625P_50:
> +		error = tvp7002_set_fmt_parms(sd,
> +				(struct i2c_reg_value *)tvp7002_parms_576P);
> +		break;
> +	case V4L2_STD_720P_50:
> +		error = tvp7002_set_fmt_parms(sd,
> +				(struct i2c_reg_value *)tvp7002_parms_720P50);
> +		break;
> +	case V4L2_STD_720P_60:
> +		error = tvp7002_set_fmt_parms(sd,
> +				(struct i2c_reg_value *)tvp7002_parms_720P60);
> +		break;
> +	case V4L2_STD_1080I_50:
> +		error = tvp7002_set_fmt_parms(sd,
> +				(struct i2c_reg_value *)tvp7002_parms_1080I50);
> +		break;
> +	case V4L2_STD_1080I_60:
> +		error = tvp7002_set_fmt_parms(sd,
> +				(struct i2c_reg_value *)tvp7002_parms_1080I60);
> +		break;
> +	default:
> +		error = -EINVAL;
> +		break;
> +	}
> +
> +	return error;

Ditto, just do return tvp...

> +}
> +
> +/*
> + * tvp7002_s_std() - Set current standard
> + * @sd: ptr to v4l2_subdev struct
> + * @std: id of the standard to be set
> + *
> + * Set a control for a TVP7002 decoder device.
> + * Returns zero when successful or -EINVAL if register access fails.
> + */
> +static int tvp7002_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
> +{
> +	struct tvp7002 *device = to_tvp7002(sd);
> +	struct v4l2_standard *standard;
> +	int error = 0;
> +	int i;
> +
> +	for (i = 0; i < device->num_stds; i++) {
> +		standard = &device->std_list[i];
> +		if (standard->id & std)
> +			break;
> +	}
> +	if (i == device->num_stds) {
> +		v4l2_err(sd, "Invalid standard id\n");

A general remark: do not print error messages when the application gives you
incorrect arguments. Just return an error in that case. Alternatively you can
use v4l2_dbg to give more information when the user turns on debugging.

Remember, it is perfectly legal for the user to give you invalid arguments.
So this isn't something that needs to be logged.

This seems to happen in lots of places, so please review your code for this.

> +		return -EINVAL;
> +	}
> +
> +	error = tvp7002_map_set_std(sd, standard->id);
> +	if (error < 0) {
> +		v4l2_err(sd, "Error in S_STD\n");
> +		return error;
> +	}
> +
> +	return error;
> +}
> +
> +/*
> + * tvp7002_g_ctrl() - Get a control
> + * @sd: ptr to v4l2_subdev struct
> + * @ctrl: ptr to v4l2_control struct
> + *
> + * Get a control for a TVP7002 decoder device.
> + * Returns zero when successful or -EINVAL if register access fails.
> + */
> +static int tvp7002_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +{
> +	int errorr;
> +	int errorg;
> +	int errorb;
> +	u8 rval;
> +	u8 gval;
> +	u8 bval;
> +	int res;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_GAIN:
> +		errorr = tvp7002_read(sd, TVP7002_R_FINE_GAIN, &rval);
> +		errorg = tvp7002_read(sd, TVP7002_G_FINE_GAIN, &gval);
> +		errorb = tvp7002_read(sd, TVP7002_B_FINE_GAIN, &bval);
> +
> +		if (errorr < 0 || errorg < 0 || errorb < 0) {
> +			res = -1;

Use some appropriate errno.h code here instead of -1.

> +		} else if (rval != gval || rval != bval) {
> +			res = -1;
> +		} else {
> +			ctrl->value = rval & 0x0F;
> +			res = ctrl->value;

Huh? Just do a return 0 here.

> +		}
> +		break;
> +	default:
> +		res = -1;
> +		break;
> +	}
> +
> +	return res < 0 ? res : 0;
> +}
> +
> +/*
> + * tvp7002_s_ctrl() - Set a control
> + * @sd: ptr to v4l2_subdev struct
> + * @ctrl: ptr to v4l2_control struct
> + *
> + * Set a control in TVP7002 decoder device.
> + * Returns zero when successful or -EINVAL if register access fails.
> + */
> +static int tvp7002_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +{
> +	struct tvp7002 *device = to_tvp7002(sd);
> +	int rval, gval, bval;
> +	int error;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_GAIN:
> +		rval = tvp7002_write(sd, TVP7002_R_FINE_GAIN,
> +							ctrl->value & 0xff);
> +		gval = tvp7002_write(sd, TVP7002_G_FINE_GAIN,
> +							ctrl->value & 0xff);
> +		bval = tvp7002_write(sd, TVP7002_B_FINE_GAIN,
> +							ctrl->value & 0xff);
> +		device->registers[TVP7002_R_FINE_GAIN].value = rval;
> +		device->registers[TVP7002_G_FINE_GAIN].value = gval;
> +		device->registers[TVP7002_B_FINE_GAIN].value = bval;

Huh? You're mixing register values and result codes here.

> +
> +		if (rval < 0  || gval < 0 || bval < 0)
> +			error = -1;

Use a proper error code.

> +		else
> +			error = rval;

Just to return 0 here.

> +		break;
> +	default:
> +		error = -1;
> +		break;
> +	}
> +
> +	return error < 0 ? -EINVAL : 0;
> +}
> +
> +/*
> + * tvp7002_queryctrl() - Query a control
> + * @sd: ptr to v4l2_subdev struct
> + * @ctrl: ptr to v4l2_queryctrl struct
> + *
> + * Query a control of a TVP7002 decoder device.
> + * Returns zero when successful or -EINVAL if register read fails.
> + */
> +static int tvp7002_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
> +{
> +	int error;
> +	error = -EINVAL;
> +
> +	if (qc == NULL)
> +		return error;

No need to test this.

> +
> +	v4l2_info(sd, "queryctrl called\n");

Stop spammed the kernel log. Use v4l2_dbg if you really want this.

Again, normal use of this driver should not result in any kernel logging
except during load or unload of the driver.

> +
> +	switch (qc->id) {
> +	case V4L2_CID_GAIN:
> +		/*
> +		 * Gain is supported [0-255, default=0, step=1]
> +		 */
> +		error = v4l2_ctrl_query_fill(qc, 0, 255, 1, 0);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return error;
> +}

Way too verbose, just do this:

static int tvp7002_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
{
	switch (qc->id) {
	case V4L2_CID_GAIN:
		return v4l2_ctrl_query_fill(qc, 0, 255, 1, 0);
	default:
		return -EINVAL;
	}
}

> +
> +/*
> + * tvp7002_colorspace - Find the color space of a video format
> + * @std: v4l2_std_id (u64) integer
> + *
> + * Returns color space for a standard id
> + */
> +static inline enum v4l2_colorspace tvp7002_colorspace(v4l2_std_id std)
> +{
> +	switch (std) {
> +	case V4L2_STD_525P_60:
> +	case V4L2_STD_625P_50:
> +		return V4L2_COLORSPACE_SMPTE170M;
> +	case V4L2_STD_720P_50:
> +	case V4L2_STD_720P_60:
> +	case V4L2_STD_1080I_50:
> +	case V4L2_STD_1080I_60:
> +		return V4L2_COLORSPACE_REC709;
> +	default:
> +		return 0;
> +	}
> +}
> +
> +/*
> + * tvp7002_scanmode - Find the scan mode of a video format
> + * @std: v4l2_std_id (u64) integer
> + *
> + * Returns color space for a standard id
> + */
> +static inline enum v4l2_field tvp7002_scanmode(v4l2_std_id std)
> +{
> +	switch (std) {
> +	case V4L2_STD_525P_60:
> +	case V4L2_STD_625P_50:
> +	case V4L2_STD_720P_50:
> +	case V4L2_STD_720P_60:
> +		return V4L2_FIELD_INTERLACED;
> +	case V4L2_STD_1080I_50:
> +	case V4L2_STD_1080I_60:
> +		return V4L2_FIELD_INTERLACED;
> +	default:
> +		return V4L2_FIELD_NONE;
> +	}
> +}
> +
> +/*
> + * tvp7002_get_pixels - Find the active pixels for a video standard
> + * @std: v4l2_std_id (u64) integer
> + *
> + * Returns number of active pixels for a standard id
> + */
> +static inline int tvp7002_get_pixels(v4l2_std_id std)
> +{
> +	switch (std) {
> +	case V4L2_STD_525P_60:
> +	case V4L2_STD_625P_50:
> +		return 720;
> +	case V4L2_STD_720P_50:
> +	case V4L2_STD_720P_60:
> +		return 1280;
> +	case V4L2_STD_1080I_50:
> +	case V4L2_STD_1080I_60:
> +		return 1920;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +/*
> + * tvp7002_get_lines - Find the active lines for a video standard
> + * @std: v4l2_std_id (u64) integer
> + *
> + * Returns number of active lines for a standard id
> + */
> +static inline int tvp7002_get_lines(v4l2_std_id std)
> +{
> +	switch (std) {
> +	case V4L2_STD_525P_60:
> +		return 480;
> +	case V4L2_STD_625P_50:
> +		return 576;
> +	case V4L2_STD_720P_50:
> +	case V4L2_STD_720P_60:
> +		return 720;
> +	case V4L2_STD_1080I_50:
> +	case V4L2_STD_1080I_60:
> +		return 1080;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +/*
> + * tvp7002_try_fmt_cap() - V4L2 decoder interface handler for try_fmt
> + * @sd: pointer to standard V4L2 sub-device structure
> + * @f: pointer to standard V4L2 VIDIOC_TRY_FMT ioctl structure
> + *
> + * Implement the VIDIOC_TRY_FMT ioctl for the CAPTURE buffer type. This
> + * ioctl is used to negotiate the image capture size and pixel format
> + * without actually making it take effect.
> + */
> +static int tvp7002_try_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
> +{
> +	struct tvp7002 *device = to_tvp7002(sd);
> +	struct v4l2_pix_format *pix;
> +	v4l2_std_id current_std;
> +
> +	if (f == NULL)
> +		return -EINVAL;
> +
> +	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		/* only capture is supported */
> +		return -EINVAL;
> +
> +	pix = &f->fmt.pix;
> +
> +	/* Calculate height and width based on current standard */
> +	current_std = device->current_std;
> +
> +	pix->width = tvp7002_get_pixels(current_std);
> +	pix->height = tvp7002_get_lines(current_std);
> +
> +	pix->pixelformat = V4L2_PIX_FMT_UYVY;
> +
> +	pix->field = tvp7002_scanmode(current_std);
> +	pix->bytesperline = pix->width * 2;
> +	pix->sizeimage = pix->bytesperline * pix->height;
> +	pix->colorspace = tvp7002_colorspace(current_std);
> +	pix->priv = 0;
> +
> +	v4l2_dbg(1, debug, sd, "Try FMT: pixelformat - %s, bytesperline - %d"
> +			"Width - %d, Height - %d",
> +			"8-bit UYVY 4:2:2 Format", pix->bytesperline,
> +			pix->width, pix->height);
> +	return 0;
> +}
> +
> +/*
> + * tvp7002_s_fmt() - V4L2 decoder interface handler for s_fmt
> + * @sd: pointer to standard V4L2 sub-device structure
> + * @f: pointer to standard V4L2 VIDIOC_S_FMT ioctl structure
> + *
> + * If the requested format is supported, configures the HW to use that
> + * format, returns error code if format not supported or HW can't be
> + * correctly configured.
> + */
> +static int tvp7002_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
> +{
> +	struct tvp7002 *decoder = to_tvp7002(sd);
> +	struct v4l2_pix_format *pix;
> +	int rval;
> +
> +	if (f == NULL)
> +		return -EINVAL;

No need to test this. In general there is no need to check for argument NULL
pointers since that is already done at the higher levels.

> +
> +	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		/* only capture is supported */
> +		return -EINVAL;
> +
> +	pix = &f->fmt.pix;
> +	rval = tvp7002_try_fmt_cap(sd, f);
> +	if (rval)
> +		return rval;
> +
> +	decoder->pix = *pix;
> +
> +	return rval;
> +}
> +
> +/*
> + * tvp7002_g_fmt() - V4L2 decoder interface handler for tvp7002_g_fmt
> + * @sd: pointer to standard V4L2 sub-device structure
> + * @f: pointer to standard V4L2 v4l2_format structure
> + *
> + * Returns the decoder's current pixel format in the v4l2_format
> + * parameter.
> + */
> +static int tvp7002_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
> +{
> +	struct tvp7002 *decoder = to_tvp7002(sd);
> +
> +	if (f == NULL)
> +		return -EINVAL;
> +
> +	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		/* only capture is supported */
> +		return -EINVAL;
> +
> +	f->fmt.pix = decoder->pix;
> +
> +	v4l2_dbg(1, debug, sd, "Current FMT: bytesperline - %d"
> +			"Width - %d, Height - %d",
> +			decoder->pix.bytesperline,
> +			decoder->pix.width, decoder->pix.height);
> +	return 0;
> +}
> +
> +/*
> + * tvp7002_querystd() - V4L2 decoder interface handler for querystd
> + * @sd: pointer to standard V4L2 sub-device structure
> + * @std_id: standard V4L2 std_id ioctl enum
> + *
> + * Returns the current standard detected by TVP7002. If no active input is
> + * detected, returns -EINVAL
> + */
> +static int tvp7002_querystd(struct v4l2_subdev *sd, v4l2_std_id *id)
> +{
> +	struct tvp7002 *device;
> +	u32 lines_per_frame;
> +	u32 clocks_per_line;
> +	u8 progressive;
> +	int errorl;
> +	int errorm;
> +	u8 lpf_lsb;
> +	u8 lpf_msb;
> +	u8 cpl_lsb;
> +	u8 cpl_msb;
> +
> +	device = to_tvp7002(sd);
> +
> +	if (id == NULL)
> +		return -EINVAL;
> +
> +	/* Read standards from device registers */
> +
> +	errorl = tvp7002_read(sd, TVP7002_L_FRAME_STAT_LSBS, &lpf_lsb);
> +	errorm = tvp7002_read(sd, TVP7002_L_FRAME_STAT_MSBS, &lpf_msb);
> +
> +	if (errorl < 0 || errorm < 0) {
> +		v4l2_err(sd, "LPF status unreadable\n");
> +		return -EINVAL;
> +	}
> +
> +	errorl = tvp7002_read(sd, TVP7002_CLK_L_STAT_LSBS, &cpl_lsb);
> +	errorm = tvp7002_read(sd, TVP7002_CLK_L_STAT_MSBS, &cpl_msb);
> +
> +	if (errorl < 0 || errorm < 0) {
> +		v4l2_err(sd, "CPL status unreadable\n");
> +		return -EINVAL;
> +	}
> +
> +	/* Get lines per frame, clocks per line and interlaced/progresive */
> +	lines_per_frame = lpf_lsb | ((TVP7002_CL_MASK & lpf_msb) <<
> +							TVP7002_CL_SHIFT);
> +	clocks_per_line = cpl_lsb | ((TVP7002_CL_MASK & cpl_msb) <<
> +							TVP7002_CL_SHIFT);
> +	progressive = (lpf_msb & TVP7002_INPR_MASK) >> TVP7002_IP_SHIFT;
> +
> +	/* Check read values */
> +	if (!progressive
> +	    && (TVP7002_LINES_1080_60 == lines_per_frame) &&
> +		(clocks_per_line >= TVP7002_CPL_1080_60_LOWER &&
> +		clocks_per_line <= TVP7002_CPL_1080_60_UPPER))
> +		*id = V4L2_STD_1080I_60;
> +	else if (!progressive
> +		&& (TVP7002_LINES_1080_50 == lines_per_frame) &&
> +		    (clocks_per_line >= TVP7002_CPL_1080_50_LOWER &&
> +		    clocks_per_line <= TVP7002_CPL_1080_50_UPPER))
> +		*id = V4L2_STD_1080I_50;
> +	else if (progressive
> +		   && (TVP7002_LINES_720 == lines_per_frame) &&
> +		   (clocks_per_line >= TVP7002_CPL_720P_50_LOWER &&
> +		   clocks_per_line <= TVP7002_CPL_720P_50_UPPER))
> +		*id = V4L2_STD_720P_50;
> +	else if (progressive
> +		   && (TVP7002_LINES_720 == lines_per_frame) &&
> +		   (clocks_per_line >= TVP7002_CPL_720P_60_LOWER &&
> +		   clocks_per_line <= TVP7002_CPL_720P_60_UPPER))
> +		*id = V4L2_STD_720P_60;
> +	else if (progressive
> +		   && (525 == lines_per_frame))
> +		*id = V4L2_STD_525P_60;
> +	else if (progressive
> +		   && (625 == lines_per_frame))
> +		*id = V4L2_STD_625P_50;
> +	else if (!progressive
> +		   && (525 == lines_per_frame))
> +		*id = V4L2_STD_NTSC;
> +	else if (!progressive
> +		   && (625 == lines_per_frame))
> +		*id = V4L2_STD_PAL;
> +	else {
> +		v4l2_err(sd, "querystd error, lpf = %x, cpl = %x\n",
> +					lines_per_frame, clocks_per_line);
> +		return -EINVAL;
> +	}
> +
> +	device->current_std = *id;
> +	errorl = tvp7002_s_std(sd, *id);
> +
> +	/* Update lines per frame and clocks per line info */
> +
> +	v4l2_info(sd, "Current STD: %d %d", tvp7002_get_pixels(*id),
> +						tvp7002_get_lines(*id));
> +
> +	return errorl;
> +}
> +
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +/*
> + * tvp7002_g_register() - Get the value of a register
> + * @sd: ptr to v4l2_subdev struct
> + * @vreg: ptr to v4l2_dbg_register struct
> + *
> + * Get the value of a TVP7002 decoder device register.
> + * Returns zero when successful, -EINVAL if register read fails or
> + * access to I2C client fails, -EPERM if the call is not allowed
> + * by diabled CAP_SYS_ADMIN.
> + */
> +static int tvp7002_g_register(struct v4l2_subdev *sd,
> +						struct v4l2_dbg_register *reg)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	if (!v4l2_chip_match_i2c_client(client, &reg->match))
> +		return -EINVAL;
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	return reg->val < 0 ? -EINVAL : 0;
> +}
> +
> +/*
> + * tvp7002_s_register() - set a control
> + * @sd: ptr to v4l2_subdev struct
> + * @ctrl: ptr to v4l2_control struct
> + *
> + * Get the value of a TVP7002 decoder device register.
> + * Returns zero when successful or -EINVAL if register read fails.
> + */
> +static int tvp7002_s_register(struct v4l2_subdev *sd,
> +						struct v4l2_dbg_register *reg)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct tvp7002 *device = to_tvp7002(sd);
> +	int wres;
> +
> +	if (!v4l2_chip_match_i2c_client(client, &reg->match))
> +		return -EINVAL;
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	wres = tvp7002_write(sd, reg->reg & 0xff, reg->val & 0xff);
> +
> +	/* Update the register value in device's table */
> +	if (!wres)
> +		device->registers[reg->reg].value = reg->val;
> +
> +	return wres < 0 ? -EINVAL : 0;
> +}
> +#endif
> +
> +/*
> + * tvp7002_enum_fmt() - Enum supported formats
> + * @sd: pointer to standard V4L2 sub-device structure
> + * @enable: pointer to format struct
> + *
> + * Sets streaming to enable or disable, if possible.
> + */
> +
> +static int tvp7002_enum_fmt(struct v4l2_subdev *sd,
> +						struct v4l2_fmtdesc *fmtdesc)
> +{
> +	struct tvp7002 *device = to_tvp7002(sd);
> +
> +	if (fmtdesc == NULL)
> +		return -EINVAL;
> +
> +	memcpy(fmtdesc, device->fmt_list, sizeof(device->fmt_list));
> +
> +	return 0;
> +}
> +
> +/*
> + * tvp7002_s_stream() - V4L2 decoder i/f handler for s_stream
> + * @sd: pointer to standard V4L2 sub-device structure
> + * @enable: streaming enable or disable
> + *
> + * Sets streaming to enable or disable, if possible.
> + */
> +static int tvp7002_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	struct tvp7002 *device = to_tvp7002(sd);
> +	int error = 0;
> +
> +	if (device->streaming == enable)
> +		return 0;
> +
> +	if (enable) {
> +		/* Set output state on (low impedance means stream on) */
> +		device->registers[TVP7002_MISC_CTL_2].value = 0x00;
> +		/* Power off chip */
> +		error = tvp7002_write(sd, TVP7002_PWR_CTL, 0x7f);
> +		if (error) {
> +			v4l2_err(sd, "Unable to start streaming\n");
> +			error = -EINVAL;
> +		}
> +		/* Power on chip */
> +		error = tvp7002_write(sd, TVP7002_PWR_CTL, 0x00);
> +		if (error) {
> +			v4l2_err(sd, "Unable to start streaming\n");
> +			return error;
> +		}
> +		/* Re-set register values with stored ones */
> +		error = tvp7002_write_inittab(sd, device->registers);
> +
> +		if (error < 0) {
> +			v4l2_err(sd, "Unable to start streaming\n");
> +			return error;
> +		}
> +		device->streaming = enable;
> +	} else {
> +		/* Set output state off (low impedance means stream off) */
> +		device->registers[TVP7002_MISC_CTL_2].value = 0x03;
> +		error = tvp7002_write(sd, TVP7002_MISC_CTL_2, 0x03);
> +		if (error) {
> +			v4l2_err(sd, "Unable to stop streaming\n");
> +			error = -EINVAL;
> +		}
> +
> +		device->streaming = enable;
> +	}
> +
> +	return error;
> +}
> +
> +/*
> + * tvp7002_reset - Reset a TVP7002 device
> + * @sd: ptr to v4l2_subdev struct
> + * @val: unsigned integer (not used)
> + *
> + * Reset the TVP7002 device
> + * Returns zero when successful or -EINVAL if register read fails.
> + */
> +static int tvp7002_reset(struct v4l2_subdev *sd, u32 val)
> +{
> +	struct tvp7002 *device = to_tvp7002(sd);
> +	int polarity_a;
> +	int polarity_b;
> +	u8 revision;
> +	int error;
> +
> +	error = tvp7002_read(sd, TVP7002_CHIP_REV, &revision);
> +	if (error < 0) {
> +		error = -EINVAL;
> +		goto found_error;
> +	}
> +
> +	if (revision == 0x02) {
> +		v4l2_info(sd, "Rev. %02x detected.\n", revision);
> +	} else {
> +		v4l2_info(sd, "Unknown revision detected.\n");
> +		v4l2_info(sd, "Revision number is %02x\n", revision);
> +	}

Simpler:

	v4l2_info(sd, "Rev. %02x detected.\n", revision);
	if (revision != 0x02)
		v4l2_info(sd, "Unknown revision detected.\n");

> +
> +	/* Power down and up */
> +	error = tvp7002_write(sd, TVP7002_PWR_CTL, 0x7f);
> +	if (error < 0) {
> +		error = -EINVAL;
> +		goto found_error;
> +	}
> +
> +	error = tvp7002_write(sd, TVP7002_PWR_CTL, 0x00);
> +	if (error < 0) {
> +		error = -EINVAL;
> +		goto found_error;
> +	}
> +
> +	/* Set the default register values */
> +	memcpy(device->registers, tvp7002_init_default,
> +					sizeof(tvp7002_init_default));
> +
> +	/* Initializes TVP7002 to its default values */
> +	error = tvp7002_write_inittab(sd, device->registers);
> +
> +	if (error < 0) {
> +		error = -EINVAL;
> +		goto found_error;
> +	}
> +
> +	/* Set polarity information after registers have been set */
> +
> +	polarity_a = 0x20 | device->pdata->hs_polarity << 5
> +			| device->pdata->vs_polarity << 2;
> +	error = tvp7002_write(sd, TVP7002_SYNC_CTL_1, polarity_a);
> +	if (error < 0) {
> +		error = -EINVAL;
> +		goto found_error;

Or just do 'return error;'

> +	}
> +
> +	polarity_b = 0x01  | device->pdata->fid_polarity << 2
> +			| device->pdata->sog_polarity << 1
> +			| device->pdata->clk_polarity;
> +	error = tvp7002_write(sd, TVP7002_MISC_CTL_3, polarity_b);
> +	if (error < 0) {
> +		error = -EINVAL;
> +		goto found_error;
> +	}
> +
> +	/* Save polarity information in register */
> +	device->registers[TVP7002_SYNC_CTL_1].value = polarity_a;
> +	device->registers[TVP7002_MISC_CTL_3].value = polarity_b;
> +	/* Set registers according to default video mode */
> +	error = tvp7002_s_std(sd, device->current_std);
> +
> +found_error:
> +	return error;
> +};
> +
> +/* V4L2 core operation handlers */
> +static const struct v4l2_subdev_core_ops tvp7002_core_ops = {
> +	.g_chip_ident = tvp7002_g_chip_ident,
> +	.log_status = tvp7002_log_status,
> +	.g_ctrl = tvp7002_g_ctrl,
> +	.s_ctrl = tvp7002_s_ctrl,
> +	.queryctrl = tvp7002_queryctrl,
> +	.s_std = tvp7002_s_std,
> +	.reset = tvp7002_reset,
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +	.g_register = tvp7002_g_register,
> +	.s_register = tvp7002_s_register,
> +#endif
> +};
> +
> +/* Specific video subsystem operation handlers */
> +static const struct v4l2_subdev_video_ops tvp7002_video_ops = {
> +	.querystd = tvp7002_querystd,
> +	.s_stream = tvp7002_s_stream,
> +	.g_fmt = tvp7002_g_fmt,
> +	.s_fmt = tvp7002_s_fmt,
> +	.enum_fmt = tvp7002_enum_fmt,
> +};
> +
> +/* V4L2 top level operation handlers */
> +static const struct v4l2_subdev_ops tvp7002_ops = {
> +	.core = &tvp7002_core_ops,
> +	.video = &tvp7002_video_ops,
> +};
> +
> +static struct tvp7002 tvp7002_dev = {
> +	.streaming = 0,
> +
> +	.fmt_list = tvp7002_fmt_list,
> +	.num_fmts = ARRAY_SIZE(tvp7002_fmt_list),
> +
> +	.pix = {
> +		/* Default to NTSC 8-bit YUV 422 */
> +		.width = HD_720_NUM_ACTIVE_PIXELS,
> +		.height = HD_720_NUM_ACTIVE_LINES,
> +		.pixelformat = V4L2_PIX_FMT_UYVY,
> +		.field = V4L2_FIELD_NONE,
> +		.bytesperline = HD_720_NUM_ACTIVE_PIXELS * 2,
> +		.sizeimage =
> +		HD_720_NUM_ACTIVE_PIXELS * 2 * HD_720_NUM_ACTIVE_LINES,
> +		.colorspace = V4L2_COLORSPACE_SMPTE170M,
> +		},
> +
> +	.current_std = V4L2_STD_720P_60,
> +	.std_list = (struct v4l2_standard *)tvp7002_standards,
> +	.num_stds = ARRAY_SIZE(tvp7002_standards),
> +};
> +
> +/*
> + * tvp7002_probe - Probe a TVP7002 device
> + * @sd: ptr to v4l2_subdev struct
> + * @ctrl: ptr to i2c_device_id struct
> + *
> + * Initialize the TVP7002 device
> + * Returns zero when successful or -EINVAL if register read fails.
> + */
> +static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
> +{
> +	struct v4l2_subdev *sd;
> +	struct tvp7002 *device;
> +	int error;
> +
> +	/* Check if the adapter supports the needed features */
> +	if (!i2c_check_functionality(c->adapter,
> +		I2C_FUNC_SMBUS_READ_BYTE | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
> +		return -EIO;
> +
> +	if (!c->dev.platform_data) {
> +		v4l2_err(c, "No platform data!!\n");
> +		return -ENODEV;
> +	}
> +
> +	device = (struct tvp7002 *) kmalloc(sizeof(struct tvp7002),
> +								GFP_KERNEL);
> +
> +	if (!device)
> +		return -ENOMEM;
> +
> +	memcpy(device, &tvp7002_dev, sizeof(struct tvp7002));
> +	sd = &device->sd;
> +	device->pdata = c->dev.platform_data;
> +
> +	/* Tell v4l2 the device is ready */
> +	v4l2_i2c_subdev_init(sd, c, &tvp7002_ops);
> +	v4l_info(c, "tvp7002 found @ 0x%02x (%s)\n",
> +					c->addr, c->adapter->name);
> +
> +	/* Initialize device internals */
> +	error = tvp7002_reset(sd, 0);
> +	if (error < 0) {
> +		error = -EINVAL;
> +		goto found_error;
> +	}
> +
> +	/* Print status log */
> +	tvp7002_log_status(sd);

Yuck. Please remove this.

> +
> +found_error:
> +	if (error < 0)
> +		kfree(device);
> +
> +	return error;
> +}
> +
> +/*
> + * tvp7002_remove - Remove TVP7002 device support
> + * @c: ptr to i2c_client struct
> + *
> + * Reset the TVP7002 device
> + * Returns zero.
> + */
> +static int tvp7002_remove(struct i2c_client *c)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(c);
> +	struct tvp7002 *device = to_tvp7002(sd);
> +
> +	v4l2_dbg(1, debug, sd, "Removing tvp7002 adapter"
> +				"on address 0x%x\n", c->addr);
> +
> +	v4l2_device_unregister_subdev(sd);
> +	kfree(device);
> +	return 0;
> +}
> +
> +/* I2C Device ID table */
> +static const struct i2c_device_id tvp7002_id[] = {
> +	{ "tvp7002", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, tvp7002_id);
> +
> +/* I2C driver data */
> +static struct i2c_driver tvp7002_driver = {
> +	.driver = {
> +		.owner = THIS_MODULE,
> +		.name = TVP7002_MODULE_NAME,
> +	},
> +	.probe = tvp7002_probe,
> +	.remove = tvp7002_remove,
> +	.id_table = tvp7002_id,
> +};
> +
> +/*
> + * tvp7002_init - Initialize driver via I2C interface
> + *
> + * Register the TVP7002 driver.
> + * Returns 0 on success or < 0 on failure.
> + */
> +static int __init tvp7002_init(void)
> +{
> +	return i2c_add_driver(&tvp7002_driver);
> +}
> +
> +/*
> + * tvp7002_exit - Remove driver via I2C interface
> + *
> + * Unregister the TVP7002 driver.
> + * Returns 0 on success or < 0 on failure.
> + */
> +static void __exit tvp7002_exit(void)
> +{
> +	i2c_del_driver(&tvp7002_driver);
> +}
> +
> +module_init(tvp7002_init);
> +module_exit(tvp7002_exit);

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
