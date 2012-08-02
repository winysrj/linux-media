Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50169 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab2HBUul (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2012 16:50:41 -0400
Received: by bkwj10 with SMTP id j10so4433604bkw.19
        for <linux-media@vger.kernel.org>; Thu, 02 Aug 2012 13:50:39 -0700 (PDT)
Message-ID: <501AE81D.70608@gmail.com>
Date: Thu, 02 Aug 2012 22:50:37 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: linux-media@vger.kernel.org, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, suapapa@insignal.co.kr,
	quartz.jang@samsung.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, usman.ahmad@linaro.org
Subject: Re: [PATH v3 1/2] v4l: Add factory register values form S5K4ECGX
 sensor
References: <1343914971-23007-1-git-send-email-sangwook.lee@linaro.org> <1343914971-23007-2-git-send-email-sangwook.lee@linaro.org>
In-Reply-To: <1343914971-23007-2-git-send-email-sangwook.lee@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/02/2012 03:42 PM, Sangwook Lee wrote:
> Add factory default settings for S5K4ECGX sensor registers,
> which was copied from the reference code of Samsung S.LSI.
> 
> Signed-off-by: Sangwook Lee<sangwook.lee@linaro.org>
> ---
>   drivers/media/video/s5k4ecgx_regs.h | 3105 +++++++++++++++++++++++++++++++++++
>   1 file changed, 3105 insertions(+)
>   create mode 100644 drivers/media/video/s5k4ecgx_regs.h
> 
> diff --git a/drivers/media/video/s5k4ecgx_regs.h b/drivers/media/video/s5k4ecgx_regs.h
> new file mode 100644
> index 0000000..ef87c09
> --- /dev/null
> +++ b/drivers/media/video/s5k4ecgx_regs.h
> @@ -0,0 +1,3105 @@
> +/*
> + * Samsung S5K4ECGX register tables for default values
> + *
> + * Copyright (C) 2012 Linaro
> + * Copyright (C) 2012 Insignal Co,. Ltd
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __DRIVERS_MEDIA_VIDEO_S5K4ECGX_H__
> +#define __DRIVERS_MEDIA_VIDEO_S5K4ECGX_H__
> +
> +struct regval_list {
> +	u32	addr;
> +	u16	val;
> +};
> +
> +/*
> + * FIXME:
> + * The tables are default values of a S5K4ECGX sensor EVT1.1
> + * from Samsung LSI. currently there is no information available
> + * to the public in order to reduce these tables size.
> + */
> +static const struct regval_list s5k4ecgx_apb_regs[] = {

<sniiip>

> +/* configure 30 fps */
> +static const struct regval_list s5k4ecgx_fps_30[] = {

It really depends on sensor master clock frequency (as specified
in FIMC driver platform data) and PLL setting what the resulting
frame rate will be.

> +	{ 0x700002b4, 0x0052 },

REG_0TC_PCFG_PVIMask

> +	{ 0x700002be, 0x0000 },

REG_0TC_PCFG_usFrTimeType 

> +	{ 0x700002c0, 0x0001 },

REG_0TC_PCFG_FrRateQualityType 

> +	{ 0x700002c2, 0x014d },

REG_0TC_PCFG_usMaxFrTimeMsecMult10 

> +	{ 0x700002c4, 0x014d },

REG_0TC_PCFG_usMinFrTimeMsecMult10 

> +	{ 0x700002d0, 0x0000 },

REG_0TC_PCFG_uPrevMirror 

Looks surprising! Are we really just disabling horizontal/vertical
image mirror here ?

> +	{ 0x700002d2, 0x0000 },

REG_0TC_PCFG_uCaptureMirror 

> +	{ 0x70000266, 0x0000 },

REG_TC_GP_ActivePrevConfig 

> +	{ 0x7000026a, 0x0001 },

REG_TC_GP_PrevOpenAfterChange 

> +	{ 0x7000024e, 0x0001 },

REG_TC_GP_NewConfigSync 

> +	{ 0x70000268, 0x0001 },

REG_TC_GP_PrevConfigChanged 


Please have a look how it is handled in s5k6aa driver, it all looks 
pretty similar.

> +	{ 0xffffffff, 0x0000 },
> +};
> +
> +static const struct regval_list s5k4ecgx_effect_normal[] = {
> +	{ 0x7000023c, 0x0000 },

Just one register, why do we need an array for it ? And of course
0x0000 is default value after reset, so it seems sort of pointless
doing this I2C write to set the default image effect value (disabled).

These are possible values as found in the datasheet:

0x7000023C REG_TC_GP_SpecialEffects 0x0000 2 RW Special effect 

0 : Normal
1 : MONOCHROME (BW)
2 : Negative Mono
3 : Negative Color
4 : Sepia
5 : AQUA
6 : Reddish
7 : Bluish
8 : Greenish
9 : Sketch
10 : Emboss color
11 : Emboss Mono

> +	{ 0xffffffff, 0x0000 },
> +};
> +
> +static const struct regval_list s5k4ecgx_wb_auto[] = {
> +	{ 0x700004e6, 0x077f },

Ditto - register REG_TC_DBG_AutoAlgEnBits. And 0x077f is the default
value after reset...

> +	{ 0xffffffff, 0x0000 },
> +};
> +
> +static const struct regval_list s5k4ecgx_iso_auto[] = {
> +	{ 0x70000938, 0x0000 },
> +	{ 0x70000f2a, 0x0001 },
> +	{ 0x700004e6, 0x077f },
> +	{ 0x700004d0, 0x0000 },
> +	{ 0x700004d2, 0x0000 },
> +	{ 0x700004d4, 0x0001 },
> +	{ 0x700006c2, 0x0200 },
> +	{ 0xffffffff, 0x0000 },
> +};
> +
> +static const struct regval_list s5k4ecgx_contrast_default[] = {
> +	{ 0x70000232, 0x0000 },

No need for an array, it's REG_TC_UserContrast.

> +	{ 0xffffffff, 0x0000 },
> +};
> +
> +static const struct regval_list s5k4ecgx_scene_default[] = {
> +	{ 0x70001492, 0x0000 },
> +	{ 0x70001494, 0x0101 },
> +	{ 0x70001496, 0x0101 },
> +	{ 0x70001498, 0x0000 },
> +	{ 0x7000149a, 0x0101 },
> +	{ 0x7000149c, 0x0101 },
> +	{ 0x7000149e, 0x0101 },
> +	{ 0x700014a0, 0x0101 },
> +	{ 0x700014a2, 0x0201 },
> +	{ 0x700014a4, 0x0303 },
> +	{ 0x700014a6, 0x0303 },
> +	{ 0x700014a8, 0x0102 },
> +	{ 0x700014aa, 0x0201 },
> +	{ 0x700014ac, 0x0403 },
> +	{ 0x700014ae, 0x0304 },
> +	{ 0x700014b0, 0x0102 },
> +	{ 0x700014b2, 0x0201 },
> +	{ 0x700014b4, 0x0403 },
> +	{ 0x700014b6, 0x0304 },
> +	{ 0x700014b8, 0x0102 },
> +	{ 0x700014ba, 0x0201 },
> +	{ 0x700014bc, 0x0403 },
> +	{ 0x700014be, 0x0304 },
> +	{ 0x700014c0, 0x0102 },
> +	{ 0x700014c2, 0x0201 },
> +	{ 0x700014c4, 0x0303 },
> +	{ 0x700014c6, 0x0303 },
> +	{ 0x700014c8, 0x0102 },
> +	{ 0x700014ca, 0x0201 },
> +	{ 0x700014cc, 0x0202 },
> +	{ 0x700014ce, 0x0202 },
> +	{ 0x700014d0, 0x0102 },
> +	{ 0x70000938, 0x0000 },
> +	{ 0x700006b8, 0x452c },
> +	{ 0x700006ba, 0x000c },
> +	{ 0x70000f2a, 0x0001 },
> +	{ 0x70000f30, 0x0001 },
> +	{ 0x700004e6, 0x077f },
> +	{ 0x700004d0, 0x0000 },
> +	{ 0x700004d2, 0x0000 },
> +	{ 0x700004d4, 0x0001 },
> +	{ 0x700006c2, 0x0200 },
> +	{ 0x70002c66, 0x0001 },
> +	{ 0x70001484, 0x003c },
> +	{ 0x7000148a, 0x000f },
> +	{ 0x7000058c, 0x3520 },
> +	{ 0x7000058e, 0x0000 },
> +	{ 0x70000590, 0xc350 },
> +	{ 0x70000592, 0x0000 },
> +	{ 0x70000594, 0x3520 },
> +	{ 0x70000596, 0x0000 },
> +	{ 0x70000598, 0xc350 },
> +	{ 0x7000059a, 0x0000 },
> +	{ 0x7000059c, 0x0470 },
> +	{ 0x7000059e, 0x0c00 },
> +	{ 0x700005a0, 0x0100 },
> +	{ 0x700005a2, 0x1000 },
> +	{ 0x70000544, 0x0111 },
> +	{ 0x70000546, 0x00ef },
> +	{ 0x70000608, 0x0001 },
> +	{ 0x7000060a, 0x0001 },
> +	{ 0x70000a28, 0x6024 },
> +	{ 0x70000ade, 0x6024 },
> +	{ 0x70000b94, 0x6024 },
> +	{ 0x70000c4a, 0x6024 },
> +	{ 0x70000d00, 0x6024 },
> +	{ 0x70000234, 0x0000 },
> +	{ 0x70000638, 0x0001 },
> +	{ 0x7000063a, 0x0000 },
> +	{ 0x7000063c, 0x0a3c },
> +	{ 0x7000063e, 0x0000 },
> +	{ 0x70000640, 0x0d05 },
> +	{ 0x70000642, 0x0000 },
> +	{ 0x70000644, 0x3408 },
> +	{ 0x70000646, 0x0000 },
> +	{ 0x70000648, 0x3408 },
> +	{ 0x7000064a, 0x0000 },
> +	{ 0x7000064c, 0x6810 },
> +	{ 0x7000064e, 0x0000 },
> +	{ 0x70000650, 0x8214 },
> +	{ 0x70000652, 0x0000 },
> +	{ 0x70000654, 0xc350 },
> +	{ 0x70000656, 0x0000 },
> +	{ 0x70000658, 0xc350 },
> +	{ 0x7000065a, 0x0000 },
> +	{ 0x7000065c, 0xc350 },
> +	{ 0x7000065e, 0x0000 },
> +	{ 0x700002c2, 0x029a },
> +	/* #reg_0tc_pcfg_usmaxfrtimemsecmult10 */
> +	{ 0x700002c4, 0x014a },
> +	/* #reg_0tc_pcfg_usminfrtimemsecmult10 */
> +	{ 0x700003b4, 0x0535 },
> +	{ 0x700003b6, 0x029a },
> +	{ 0x70000266, 0x0000 },
> +	{ 0x7000026a, 0x0001 },
> +	{ 0x7000024e, 0x0001 },
> +	{ 0x70000268, 0x0001 },
> +	{ 0x70000270, 0x0001 },
> +	{ 0x7000023e, 0x0001 },
> +	{ 0x70000240, 0x0001 },
> +	{ 0xffffffff, 0x0000 },
> +};
> +
> +/* configure 720x480 preview size */
> +static const struct regval_list s5k4ecgx_720_preview[] = {
...
> +/* configure 640x480 preview size */
> +static const struct regval_list s5k4ecgx_640_preview[] = {
...
> +/* configure 352x288 preview size */
> +static const struct regval_list s5k4ecgx_352_preview[] = {
...
> +/* configure 176x144 preview size */
> +static const struct regval_list s5k4ecgx_176_preview[] = {
...
> +/* Default value for brightness */
> +static const struct regval_list s5k4ecgx_ev_default[] = {
> +	{ 0x70000230, 0x0000 },

REG_TC_UserBrightness 

> +	{ 0xffffffff, 0x0000 },
> +};
> +
> +/* Default value for saturation */
> +static const struct regval_list s5k4ecgx_saturation_default[] = {
> +	{ 0x70000234, 0x0000 },

REG_TC_UserSaturation 

> +	{ 0xffffffff, 0x0000 },
> +};
> +
> +/* Default value for sharpness */
> +static const struct regval_list s5k4ecgx_sharpness_default[] = {
> +	{ 0x70000a28, 0x6024 },
> +	{ 0x70000ade, 0x6024 },
> +	{ 0x70000b94, 0x6024 },
> +	{ 0x70000c4a, 0x6024 },
> +	{ 0x70000d00, 0x6024 },
> +	{ 0xffffffff, 0x0000 },
> +};

You already use a sequence of i2c writes in s5k4ecgx_s_ctrl() function
for V4L2_CID_SHARPNESS control. So why not just create e.g.
s5k4ecgx_set_saturation() and send this array to /dev/null ?
Also, invoking v4l2_ctrl_handler_setup() will cause a call to s5k4ecgx_s_ctrl()
with default sharpness value (as specified during the control's creation).

So I would say this array is redundant in two ways... :)

--

Regards,
Sylwester
