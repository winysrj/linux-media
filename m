Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61290 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab2HCPFo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2012 11:05:44 -0400
Received: by yhmm54 with SMTP id m54so926825yhm.19
        for <linux-media@vger.kernel.org>; Fri, 03 Aug 2012 08:05:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <501AE81D.70608@gmail.com>
References: <1343914971-23007-1-git-send-email-sangwook.lee@linaro.org>
	<1343914971-23007-2-git-send-email-sangwook.lee@linaro.org>
	<501AE81D.70608@gmail.com>
Date: Fri, 3 Aug 2012 16:05:42 +0100
Message-ID: <CADPsn1YHJOcx3Faz++oq1eNtuzL6vawCdn5fyvC2gbmLXVDWWA@mail.gmail.com>
Subject: Re: [PATH v3 1/2] v4l: Add factory register values form S5K4ECGX sensor
From: Sangwook Lee <sangwook.lee@linaro.org>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, suapapa@insignal.co.kr,
	quartz.jang@samsung.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, usman.ahmad@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester

On 2 August 2012 21:50, Sylwester Nawrocki <sylvester.nawrocki@gmail.com> wrote:
> On 08/02/2012 03:42 PM, Sangwook Lee wrote:
>> Add factory default settings for S5K4ECGX sensor registers,
>> which was copied from the reference code of Samsung S.LSI.
>>
>> Signed-off-by: Sangwook Lee<sangwook.lee@linaro.org>
>> ---
>>   drivers/media/video/s5k4ecgx_regs.h | 3105 +++++++++++++++++++++++++++++++++++
>>   1 file changed, 3105 insertions(+)
>>   create mode 100644 drivers/media/video/s5k4ecgx_regs.h
>>
>> diff --git a/drivers/media/video/s5k4ecgx_regs.h b/drivers/media/video/s5k4ecgx_regs.h
>> new file mode 100644
>> index 0000000..ef87c09
>> --- /dev/null
>> +++ b/drivers/media/video/s5k4ecgx_regs.h
>> @@ -0,0 +1,3105 @@
>> +/*
>> + * Samsung S5K4ECGX register tables for default values
>> + *
>> + * Copyright (C) 2012 Linaro
>> + * Copyright (C) 2012 Insignal Co,. Ltd
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef __DRIVERS_MEDIA_VIDEO_S5K4ECGX_H__
>> +#define __DRIVERS_MEDIA_VIDEO_S5K4ECGX_H__
>> +
>> +struct regval_list {
>> +     u32     addr;
>> +     u16     val;
>> +};
>> +
>> +/*
>> + * FIXME:
>> + * The tables are default values of a S5K4ECGX sensor EVT1.1
>> + * from Samsung LSI. currently there is no information available
>> + * to the public in order to reduce these tables size.
>> + */
>> +static const struct regval_list s5k4ecgx_apb_regs[] = {
>
> <sniiip>
>
>> +/* configure 30 fps */
>> +static const struct regval_list s5k4ecgx_fps_30[] = {
>
> It really depends on sensor master clock frequency (as specified
> in FIMC driver platform data) and PLL setting what the resulting
> frame rate will be.
>
>> +     { 0x700002b4, 0x0052 },
>
> Looks surprising! Are we really just disabling horizontal/vertical
> image mirror here ?

I believe, this setting values are used still in Galaxy Nexus.
It might be some reasons  to set this values in the product, but I am not
sure of this.


>
>> +     { 0x700002d2, 0x0000 },
>
> REG_0TC_PCFG_uCaptureMirror
>
>> +     { 0x70000266, 0x0000 },
>
> REG_TC_GP_ActivePrevConfig
>
>> +     { 0x7000026a, 0x0001 },
>
> REG_TC_GP_PrevOpenAfterChange
>
>> +     { 0x7000024e, 0x0001 },
>
> REG_TC_GP_NewConfigSync
>
>> +     { 0x70000268, 0x0001 },
>
> REG_TC_GP_PrevConfigChanged
>
>
> Please have a look how it is handled in s5k6aa driver, it all looks
> pretty similar.
>
>> +     { 0xffffffff, 0x0000 },
>> +};
>> +
>> +static const struct regval_list s5k4ecgx_effect_normal[] = {
>> +     { 0x7000023c, 0x0000 },
>
> Just one register, why do we need an array for it ? And of course
> 0x0000 is default value after reset, so it seems sort of pointless
> doing this I2C write to set the default image effect value (disabled).
>
> These are possible values as found in the datasheet:
>
> 0x7000023C REG_TC_GP_SpecialEffects 0x0000 2 RW Special effect
>
> 0 : Normal
> 1 : MONOCHROME (BW)
> 2 : Negative Mono
> 3 : Negative Color
> 4 : Sepia
> 5 : AQUA
> 6 : Reddish
> 7 : Bluish
> 8 : Greenish
> 9 : Sketch
> 10 : Emboss color
> 11 : Emboss Mono
>
>> +     { 0xffffffff, 0x0000 },
>> +};
>> +
>> +static const struct regval_list s5k4ecgx_wb_auto[] = {
>> +     { 0x700004e6, 0x077f },
>
> Ditto - register REG_TC_DBG_AutoAlgEnBits. And 0x077f is the default
> value after reset...
>
>> +     { 0xffffffff, 0x0000 },
>> +};
>> +
>> +static const struct regval_list s5k4ecgx_iso_auto[] = {
>> +     { 0x70000938, 0x0000 },
>> +     { 0x70000f2a, 0x0001 },
>> +     { 0x700004e6, 0x077f },
>> +     { 0x700004d0, 0x0000 },
>> +     { 0x700004d2, 0x0000 },
>> +     { 0x700004d4, 0x0001 },
>> +     { 0x700006c2, 0x0200 },
>> +     { 0xffffffff, 0x0000 },
>> +};
>> +
>> +static const struct regval_list s5k4ecgx_contrast_default[] = {
>> +     { 0x70000232, 0x0000 },
>
> No need for an array, it's REG_TC_UserContrast.
>
>> +     { 0xffffffff, 0x0000 },
>> +};
>> +
>
[snip]
>> +     { 0xffffffff, 0x0000 },
>> +};
>
> You already use a sequence of i2c writes in s5k4ecgx_s_ctrl() function
> for V4L2_CID_SHARPNESS control. So why not just create e.g.
> s5k4ecgx_set_saturation() and send this array to /dev/null ?
> Also, invoking v4l2_ctrl_handler_setup() will cause a call to s5k4ecgx_s_ctrl()
> with default sharpness value (as specified during the control's creation).
>
> So I would say this array is redundant in two ways... :)

Thanks, let me change this.


>
> --
>
> Regards,
> Sylwester
