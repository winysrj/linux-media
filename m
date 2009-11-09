Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:1921 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149AbZKIPrB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 10:47:01 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: santiago.nunez@ridgerun.com
Subject: Re: [PATCH 3/4 v6] TVP7002 driver for DM365
Date: Mon, 9 Nov 2009 16:46:54 +0100
Cc: davinci-linux-open-source@linux.davincidsp.com,
	linux-media@vger.kernel.org, nsnehaprabha@ti.com,
	m-karicheri2@ti.com, diego.dompe@ridgerun.com,
	todd.fischer@ridgerun.com, mgrosen@ti.com
References: <1257522176-25893-1-git-send-email-santiago.nunez@ridgerun.com>
In-Reply-To: <1257522176-25893-1-git-send-email-santiago.nunez@ridgerun.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911091646.54410.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Santiago,

See review comments below:

On Friday 06 November 2009 16:42:56 santiago.nunez@ridgerun.com wrote:
> From: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
> 
> This patch provides the implementation of the TVP7002 decoder
> driver for DM365. Implemented using the V4L2 DV presets API.
> 
> Signed-off-by: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
> ---
>  drivers/media/video/tvp7002.c | 1423 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 1423 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/tvp7002.c
> 
> diff --git a/drivers/media/video/tvp7002.c b/drivers/media/video/tvp7002.c
> new file mode 100644
> index 0000000..7d945d9
> --- /dev/null
> +++ b/drivers/media/video/tvp7002.c
> @@ -0,0 +1,1423 @@
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
> +/* End of registers */
> +#define TVP7002_EOR			0x5c
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
> +	{ TVP7002_EOR, 0xff, TVP7002_RESERVED }
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
> +	{ TVP7002_EOR, 0xff, TVP7002_RESERVED }
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
> +	{ TVP7002_EOR, 0xff, TVP7002_RESERVED }
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
> +	{ TVP7002_EOR, 0xff, TVP7002_RESERVED }
> +};
> +
> +/* Register parameters for 1080P60 */
> +static const struct i2c_reg_value tvp7002_parms_1080P60[] = {
> +	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x89, TVP7002_WRITE },
> +	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x08, TVP7002_WRITE },
> +	{ TVP7002_HPLL_CRTL, 0xE0, TVP7002_WRITE },
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
> +	{ TVP7002_EOR, 0xff, TVP7002_RESERVED }
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
> +	{ TVP7002_EOR, 0xff, TVP7002_RESERVED }
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
> +	{ TVP7002_EOR, 0xff, TVP7002_RESERVED }
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
> +	{ TVP7002_EOR, 0xff, TVP7002_RESERVED }
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
> +/* Struct list for digital video presents */
> +static struct v4l2_dv_enum_preset tvp7002_presets[] = {

Why isn't this const?

> +	{
> +		.index = INDEX_720P60,
> +		.preset = V4L2_DV_720P60,
> +		.name = "720P-60",
> +		.width = 1280,
> +		.height = 720,
> +	},
> +	{
> +		.index = INDEX_1080I60,
> +		.preset = V4L2_DV_1080I60,
> +		.name = "1080I-30",
> +		.width = 1920,
> +		.height = 1080,
> +	},
> +	{
> +		.index = INDEX_1080I50,
> +		.preset = V4L2_DV_1080I50,
> +		.name = "1080I-25",
> +		.width = 1920,
> +		.height = 1080,
> +	},
> +	{
> +		.index = INDEX_720P50,
> +		.preset = V4L2_DV_720P50,
> +		.name = "720P-50",
> +		.width = 1280,
> +		.height = 720,
> +	},
> +	{
> +		.index = INDEX_1080P60,
> +		.preset = V4L2_DV_1080P60,
> +		.name = "1080P-60",
> +		.width = 1920,
> +		.height = 1080,
> +	},
> +	{
> +		.index = INDEX_480P59_94,
> +		.preset = V4L2_DV_480P59_94,
> +		.name = "480P-60",
> +		.width = 720,
> +		.height = 480,
> +	},
> +	{
> +		.index = INDEX_576P50,
> +		.preset = V4L2_DV_576P50,
> +		.name = "576P-50",
> +		.width = 720,
> +		.height = 576,
> +	},
> +};

We should probably make a new core function in v4l2-common.c that will fill in
name, width and height based on the preset. That will ensure consistency over
the various HDTV drivers. The input to the function is the preset and a pointer
to the v4l2_dv_enum_preset struct.

> +
> +/* Device definition */
> +struct tvp7002 {
> +	struct v4l2_subdev sd;
> +	const struct tvp7002_config *pdata;
> +	struct i2c_reg_value registers[ARRAY_SIZE(tvp7002_init_default)];

Why do we need to keep a copy of the registers around? Usually the only valid
reason for doing that is if the registers are write-only. But I can't imagine
that that's the case for this device.

> +
> +	int ver;
> +	int streaming;
> +
> +	struct v4l2_pix_format pix;
> +	const struct v4l2_fmtdesc *fmt_list;
> +	int num_fmts;
> +
> +	struct v4l2_dv_enum_preset *preset_list;

Why isn't this const?

> +	int current_preset;
> +	int num_presets;
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

Change to 'return error;'

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
> +	while (TVP7002_EOR != regs->reg) {
> +		if (TVP7002_WRITE == regs->type)
> +			tvp7002_write_err(sd, regs->reg, regs->value, &error);
> +		regs++;
> +	}
> +
> +	return error;
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
> +	while (TVP7002_EOR != regs->reg) {
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
> +		v4l2_dbg(1, debug, sd, "Parameter reference is NULL.\n");
> +		return -EINVAL;
> +	}
> +
> +	error = tvp7002_write_inittab(sd, regs);
> +
> +	if (error < 0) {
> +		v4l2_dbg(1, debug, sd, "Error in setting video parameters\n");
> +		return -EINVAL;

return error;

> +	}
> +
> +	/* Update our device device information */
> +	return tvp7002_update_dev_tab(sd, regs);
> +}
> +
> +/*
> + * tvp7002_map_set_preset() - Map and set video preset to register parameters
> + * @std: v4l2_std_id (u64) integer
> + *
> + * Returns 0 if successful or -EINVAL on error.
> + */
> +static int tvp7002_map_set_preset(struct v4l2_subdev *sd, u32 preset)
> +{
> +	switch (preset) {
> +	case V4L2_DV_480P59_94:
> +		return tvp7002_set_fmt_parms(sd,
> +				(struct i2c_reg_value *)tvp7002_parms_480P);

Cast shouldn't be needed. Just make sure you use the right 'const' type
modifiers.

> +	case V4L2_DV_576P50:
> +		return tvp7002_set_fmt_parms(sd,
> +				(struct i2c_reg_value *)tvp7002_parms_576P);
> +	case V4L2_DV_720P50:
> +		return tvp7002_set_fmt_parms(sd,
> +				(struct i2c_reg_value *)tvp7002_parms_720P50);
> +	case V4L2_DV_720P60:
> +		return tvp7002_set_fmt_parms(sd,
> +				(struct i2c_reg_value *)tvp7002_parms_720P60);
> +	case V4L2_DV_1080I50:
> +		return tvp7002_set_fmt_parms(sd,
> +				(struct i2c_reg_value *)tvp7002_parms_1080I50);
> +	case V4L2_DV_1080I60:
> +		return tvp7002_set_fmt_parms(sd,
> +				(struct i2c_reg_value *)tvp7002_parms_1080I60);
> +	case V4L2_DV_1080P60:
> +			return tvp7002_set_fmt_parms(sd,
> +				(struct i2c_reg_value *)tvp7002_parms_1080P60);
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +/*
> + * tvp7002_s_dv_preset() - Set digital video preset
> + * @sd: ptr to v4l2_subdev struct
> + * @std: id of the standard to be set
> + *
> + * Set the digital video preset for a TVP7002 decoder device.
> + * Returns zero when successful or -EINVAL if register access fails.
> + */
> +static int tvp7002_s_dv_preset(struct v4l2_subdev *sd,
> +					struct v4l2_dv_preset *dv_preset)
> +{
> +	struct tvp7002 *device = to_tvp7002(sd);
> +	struct v4l2_dv_enum_preset *preset;
> +	int i;
> +
> +	for (i = 0; i < device->num_presets; i++) {
> +		preset = &device->preset_list[i];
> +		if (preset->preset == dv_preset->preset)
> +			break;
> +	}
> +
> +	if (i == device->num_presets)
> +		return -EINVAL;
> +
> +	return tvp7002_map_set_preset(sd, preset->preset);
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
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_GAIN:
> +		errorr = tvp7002_read(sd, TVP7002_R_FINE_GAIN, &rval);
> +		errorg = tvp7002_read(sd, TVP7002_G_FINE_GAIN, &gval);
> +		errorb = tvp7002_read(sd, TVP7002_B_FINE_GAIN, &bval);
> +
> +		if (errorr < 0 || errorg < 0 || errorb < 0) {
> +			return -EINVAL;
> +		} else if (rval != gval || rval != bval) {

No need for the misleading 'else' here.

> +			return -EINVAL;
> +		} else {

Ditto.

> +			ctrl->value = rval & 0x0F;
> +			return 0;
> +		}
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +}

Wouldn't it be easier to just have a 'gain' field in struct tvp7002 that is
set when calling s_ctrl, and that is just returned when g_ctrl is called?

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
> +	int errorr;
> +	int errorg;
> +	int errorb;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_GAIN:
> +		errorr = tvp7002_write(sd, TVP7002_R_FINE_GAIN,
> +							ctrl->value & 0xff);
> +		errorg = tvp7002_write(sd, TVP7002_G_FINE_GAIN,
> +							ctrl->value & 0xff);
> +		errorb = tvp7002_write(sd, TVP7002_B_FINE_GAIN,
> +							ctrl->value & 0xff);
> +
> +		if (errorr < 0  || errorg < 0 || errorb < 0)
> +			return -EINVAL;
> +		else {
> +			device->registers[TVP7002_R_FINE_GAIN].value =
> +								ctrl->value;
> +			device->registers[TVP7002_G_FINE_GAIN].value =
> +								ctrl->value;
> +			device->registers[TVP7002_B_FINE_GAIN].value =
> +								ctrl->value;

As mentioned at the top: what's the point of these shadow registers?

> +			return 0;
> +		}
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
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
> +	switch (qc->id) {
> +	case V4L2_CID_GAIN:
> +		/*
> +		 * Gain is supported [0-255, default=0, step=1]
> +		 */
> +		return v4l2_ctrl_query_fill(qc, 0, 255, 1, 0);
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +/*
> + * tvp7002_colorspace - Find the color space of a video format
> + * @std: v4l2_std_id (u64) integer
> + *
> + * Returns color space for a standard id
> + */
> +static inline enum v4l2_colorspace tvp7002_colorspace(int preset)
> +{
> +	switch (preset) {
> +	case INDEX_480P59_94:
> +	case INDEX_576P50:
> +		return V4L2_COLORSPACE_SMPTE170M;
> +	case INDEX_720P50:
> +	case INDEX_720P60:
> +	case INDEX_1080I50:
> +	case INDEX_1080I60:
> +	case INDEX_1080P60:
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
> +	case INDEX_480P59_94:
> +	case INDEX_576P50:
> +	case INDEX_720P50:
> +	case INDEX_720P60:
> +	case INDEX_1080P60:
> +		return V4L2_FIELD_SEQ_TB;
> +	case INDEX_1080I50:
> +	case INDEX_1080I60:
> +		return V4L2_FIELD_INTERLACED;
> +	default:
> +		return V4L2_FIELD_NONE;
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
> +	u32 current_preset;
> +
> +	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		/* only capture is supported */
> +		return -EINVAL;
> +
> +	pix = &f->fmt.pix;
> +
> +	/* Calculate height and width based on current standard */
> +	current_preset = device->current_preset;
> +
> +	pix->width = device->preset_list[current_preset].width;
> +	pix->height = device->preset_list[current_preset].height;
> +
> +	pix->pixelformat = V4L2_PIX_FMT_UYVY;
> +
> +	pix->field = tvp7002_scanmode(current_preset);
> +	pix->bytesperline = pix->width * 2;
> +	pix->sizeimage = pix->bytesperline * pix->height;
> +	pix->colorspace = tvp7002_colorspace(current_preset);
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
> +static int tvp7002_query_dv_preset(struct v4l2_subdev *sd,
> +						struct v4l2_dv_preset *qpreset)
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
> +	int index;
> +
> +	device = to_tvp7002(sd);
> +
> +	/* Read standards from device registers */
> +
> +	errorl = tvp7002_read(sd, TVP7002_L_FRAME_STAT_LSBS, &lpf_lsb);
> +	errorm = tvp7002_read(sd, TVP7002_L_FRAME_STAT_MSBS, &lpf_msb);
> +
> +	if (errorl < 0 || errorm < 0)
> +		return -EINVAL;

It might be easier to introduce a tvp7002_read_err function: then you can
just return 'error' here (i.e. the first error that was found).

> +
> +	errorl = tvp7002_read(sd, TVP7002_CLK_L_STAT_LSBS, &cpl_lsb);
> +	errorm = tvp7002_read(sd, TVP7002_CLK_L_STAT_MSBS, &cpl_msb);
> +
> +	if (errorl < 0 || errorm < 0)
> +		return -EINVAL;
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
> +		index =  INDEX_1080I60;
> +	else if (progressive
> +		    && (TVP7002_LINES_1080_60 == lines_per_frame) &&
> +			(clocks_per_line >= TVP7002_CPL_1080P_60_LOWER &&
> +			clocks_per_line <= TVP7002_CPL_1080P_60_UPPER))
> +			index = INDEX_1080P60;
> +	else if (!progressive
> +		&& (TVP7002_LINES_1080_50 == lines_per_frame) &&
> +		    (clocks_per_line >= TVP7002_CPL_1080_50_LOWER &&
> +		    clocks_per_line <= TVP7002_CPL_1080_50_UPPER))
> +		index = INDEX_1080I50;
> +	else if (progressive
> +		   && (TVP7002_LINES_720 == lines_per_frame) &&
> +		   (clocks_per_line >= TVP7002_CPL_720P_50_LOWER &&
> +		   clocks_per_line <= TVP7002_CPL_720P_50_UPPER))
> +		index = INDEX_720P50;
> +	else if (progressive
> +		   && (TVP7002_LINES_720 == lines_per_frame) &&
> +		   (clocks_per_line >= TVP7002_CPL_720P_60_LOWER &&
> +		   clocks_per_line <= TVP7002_CPL_720P_60_UPPER))
> +		index = INDEX_720P60;
> +	else if (progressive
> +		   && (525 == lines_per_frame))
> +		index = INDEX_480P59_94;
> +	else if (progressive
> +		   && (625 == lines_per_frame))
> +		index = INDEX_576P50;

Can this be put into an array or something? I can't help thinking that this
can be implemented in a more readable manner.

> +	else {
> +		v4l2_err(sd, "querystd error, lpf = %x, cpl = %x\n",
> +					lines_per_frame, clocks_per_line);
> +		return -EINVAL;
> +	}
> +
> +	/* Set values in found preset */
> +	qpreset->preset = device->preset_list[index].preset;
> +
> +	device->current_preset = index;
> +	errorl = tvp7002_s_dv_preset(sd, qpreset);
> +
> +	/* Update lines per frame and clocks per line info */
> +	v4l2_dbg(1, debug, sd, "Current preset: %d %d",
> +					device->preset_list[index].width,
> +					device->preset_list[index].height);
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
> +	memcpy(fmtdesc, device->fmt_list, sizeof(device->fmt_list));

This is wrong. It should be sizeof(device->fmt_list[0]) for one (or
'sizeof(*fmtdesc)'). And you should return device->fmt_list + fmtdesc->index,
and you should check that fmtdev->index is within range.

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
> +			v4l2_dbg(1, debug, sd, "Unable to start streaming\n");
> +			error = -EINVAL;
> +		}
> +		/* Power on chip */
> +		error = tvp7002_write(sd, TVP7002_PWR_CTL, 0x00);
> +		if (error) {
> +			v4l2_dbg(1, debug, sd, "Unable to start streaming\n");
> +			return error;
> +		}
> +		/* Re-set register values with stored ones */
> +		error = tvp7002_write_inittab(sd, device->registers);
> +
> +		if (error < 0) {
> +			v4l2_dbg(1, debug, sd, "Unable to start streaming\n");
> +			return error;
> +		}
> +		device->streaming = enable;
> +	} else {
> +		/* Set output state off (low impedance means stream off) */
> +		device->registers[TVP7002_MISC_CTL_2].value = 0x03;
> +		error = tvp7002_write(sd, TVP7002_MISC_CTL_2, 0x03);
> +		if (error) {
> +			v4l2_dbg(1, debug, sd, "Unable to stop streaming\n");
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
> +	struct tvp7002 *device = to_tvp7002(sd);
> +	struct v4l2_dv_preset preset;
> +	int i;
> +
> +	tvp7002_log_chk(sd, TVP7002_CHIP_REV, "Chip revision number");
> +
> +	/* Find my current standard*/
> +	tvp7002_query_dv_preset(sd, &preset);
> +
> +	/* Print standard related code values */
> +	for (i = 0; i < device->num_presets; i++)
> +		if (device->preset_list[i].preset == preset.preset)
> +			break;
> +
> +	if (i == device->num_presets)
> +		return -EINVAL;
> +
> +	v4l2_info(sd, "DV Preset: %s\n", device->preset_list[i].name);
> +	v4l2_info(sd, "Pixels per line: %u\n", device->preset_list[i].width);
> +	v4l2_info(sd, "Lines per frame: %u\n", device->preset_list[i].height);
> +	v4l2_info(sd, "Stream state: %s\n", device->streaming ? "on" : "off");
> +
> +	/* Print values of the gain control */
> +	tvp7002_log_chk(sd, TVP7002_B_FINE_GAIN, "Digital fine gain B ch");
> +	tvp7002_log_chk(sd, TVP7002_G_FINE_GAIN, "Digital fine gain G ch");
> +	tvp7002_log_chk(sd, TVP7002_R_FINE_GAIN, "Digital fine gain R ch");
> +

One empty line too many.

> +
> +	return 0;
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
> +	struct v4l2_dv_preset preset;
> +	int polarity_a;
> +	int polarity_b;
> +	u8 revision;
> +	int error;
> +
> +	error = tvp7002_read(sd, TVP7002_CHIP_REV, &revision);
> +	if (error < 0) {
> +		error = -EINVAL;
> +		goto found_error;

Why throw away the actual error code and why not just do 'return error;'?

> +	}
> +
> +	/* Get revision number */
> +	v4l2_info(sd, "Rev. %02x detected.\n", revision);
> +	if (revision != 0x02)
> +		v4l2_info(sd, "Unknown revision detected.\n");
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
> +	preset.preset = device->preset_list[device->current_preset].preset;
> +	error = tvp7002_s_dv_preset(sd, &preset);
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
> +	.reset = tvp7002_reset,
> +#ifdef CONFIG_VIDEO_ADV_DEBUG
> +	.g_register = tvp7002_g_register,
> +	.s_register = tvp7002_s_register,
> +#endif
> +};
> +
> +/* Specific video subsystem operation handlers */
> +static const struct v4l2_subdev_video_ops tvp7002_video_ops = {
> +	.s_dv_preset = tvp7002_s_dv_preset,
> +	.query_dv_preset = tvp7002_query_dv_preset,
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

Why is this part of this state struct? It's just a static piece of global
information. No need to make that part of this state struct.

> +
> +	.pix = {
> +		/* Default to NTSC 8-bit YUV 422 */

This is definitely not NTSC, so the comment is probably outdated.

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
> +	.current_preset = INDEX_720P60,
> +	.preset_list = (struct v4l2_dv_enum_preset *) tvp7002_presets,

Why the cast? And why is this part of this struct anyway?

> +	.num_presets = ARRAY_SIZE(tvp7002_presets),
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
> +	device = kmalloc(sizeof(struct tvp7002), GFP_KERNEL);
> +
> +	if (!device)
> +		return -ENOMEM;
> +
> +	memcpy(device, &tvp7002_dev, sizeof(struct tvp7002));

I'm never very keen on such struct copies. Usually it is much clearer if you
just fill in the fields explicitly. There are not that many fields that need
to be set here.

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
> +found_error:
> +	if (error < 0)
> +		kfree(device);
> +
> +	return error;

It's easier if you replace this last part with:

	error = tvp7002_reset(sd, 0);
	if (error < 0) {
		kfree(device);
		return error;
	}
	return 0;

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

Thanks for all your work on this i2c driver!

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
