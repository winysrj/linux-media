Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:1660 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbZCNWUU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2009 18:20:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [RFC 6/7] ARM: DaVinci: DM646x Video: Add VPIF driver
Date: Sat, 14 Mar 2009 23:20:36 +0100
Cc: chaithrika@ti.com, linux-media@vger.kernel.org
References: <1236934943-32239-1-git-send-email-chaithrika@ti.com>
In-Reply-To: <1236934943-32239-1-git-send-email-chaithrika@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903142320.36399.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Phew, the last review.

First a comment on the vpif.h header (and the dm646x.h header as well, for
that matter): no need to use #ifdef __KERNEL__. You are by definition inside
the kernel and it isn't a public header either.

I also think that these headers belong next to the driver and not in
include/media: headers in that directory are for the use of other drivers and
not for a header that is only used by the driver itself.

My only other comment basically comes back to the same issue I've raised
before in that we need a better generic API to specify formats for digital
video timings. I don't like the timing tables in the vpif.c source. They
seem out of place to me.

Most of these tables just contain the timing specs from the CEA standard
and as such are really generic. Something like that certainly belongs in
a separate source and should probably be part of the generic v4l core.

What I would find a more logical organization is that the main dm646x
source looks up a specified video standard in this timing table and
just gives vpif.c those timings. That will also make it very natural
to have the user specify those timings explicitly since that just
bypasses the table lookup and allows the user to give the timings
directly to the vpif.

I admit that in my day time job I've had to edit these tables a lot
to get it to use my own custom timings, so I am probably biased. But I doubt
I am the only one who is going outside the box with this device. You need
to be able to set these timings explicitly in order to be reasonably future
proof, IMHO.

Regards,

	Hans

On Friday 13 March 2009 10:02:23 chaithrika@ti.com wrote:
> From: Chaithrika U S <chaithrika@ti.com>
> 
> Video Port Interface driver
> 
> Add VPIF driver for DM646x. This code be used by the display and
> capture drivers.
> 
> Signed-off-by: Chaithrika U S <chaithrika@ti.com>
> ---
> Applies to v4l-dvb repository located at
> http://linuxtv.org/hg/v4l-dvb/rev/1fd54a62abde
> 
>  drivers/media/video/davinci/vpif.c |  362 +++++++++++++++++++
>  include/media/davinci/vpif.h       |  672 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 1034 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/davinci/vpif.c
>  create mode 100644 include/media/davinci/vpif.h
> 
> diff --git a/drivers/media/video/davinci/vpif.c b/drivers/media/video/davinci/vpif.c
> new file mode 100644
> index 0000000..8dbe5a4
> --- /dev/null
> +++ b/drivers/media/video/davinci/vpif.c
> @@ -0,0 +1,362 @@
> +/*
> + * vpif - DM646x Video Port driver
> + *
> + * Copyright (C) 2009 Texas Instruments Incorporated - http://www.ti.com/
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed .as is. WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <media/davinci/vpif.h>
> +
> +#define VPIF_CH0_MAX_MODES	(22)
> +#define VPIF_CH1_MAX_MODES	(02)
> +#define VPIF_CH2_MAX_MODES	(15)
> +#define VPIF_CH3_MAX_MODES	(02)
> +
> +/* This structure is used to keep track of VPIF size register's offsets */
> +struct vpif_registers {
> +	u32 h_cfg, v_cfg_00, v_cfg_01, v_cfg_02, v_cfg, ch_ctrl;
> +	u32 line_offset, vanc0_strt, vanc0_size, vanc1_strt;
> +	u32 vanc1_size, width_mask, len_mask;
> +	u8 max_modes;
> +};
> +
> +static struct vpif_registers vpifregs[VPIF_NUM_CHANNELS] = {
> +	/* Channel0 */
> +	{VPIF_CH0_H_CFG, VPIF_CH0_V_CFG_00, VPIF_CH0_V_CFG_01,
> +	 VPIF_CH0_V_CFG_02, VPIF_CH0_V_CFG_03, VPIF_CH0_CTRL,
> +	 VPIF_CH0_IMG_ADD_OFST, 0, 0, 0, 0, 0x1FFF, 0xFFF, VPIF_CH0_MAX_MODES},
> +	/* Channel1 */
> +	{VPIF_CH1_H_CFG, VPIF_CH1_V_CFG_00, VPIF_CH1_V_CFG_01,
> +	 VPIF_CH1_V_CFG_02, VPIF_CH1_V_CFG_03, VPIF_CH1_CTRL,
> +	 VPIF_CH1_IMG_ADD_OFST, 0, 0, 0, 0, 0x1FFF, 0xFFF, VPIF_CH1_MAX_MODES},
> +	/* Channel2 */
> +	{VPIF_CH2_H_CFG, VPIF_CH2_V_CFG_00, VPIF_CH2_V_CFG_01,
> +	 VPIF_CH2_V_CFG_02, VPIF_CH2_V_CFG_03, VPIF_CH2_CTRL,
> +	 VPIF_CH2_IMG_ADD_OFST, VPIF_CH2_VANC0_STRT, VPIF_CH2_VANC0_SIZE,
> +	 VPIF_CH2_VANC1_STRT, VPIF_CH2_VANC1_SIZE, 0x7FF, 0x7FF,
> +	 VPIF_CH2_MAX_MODES},
> +	/* Channel3 */
> +	{VPIF_CH3_H_CFG, VPIF_CH3_V_CFG_00, VPIF_CH3_V_CFG_01,
> +	 VPIF_CH3_V_CFG_02, VPIF_CH3_V_CFG_03, VPIF_CH3_CTRL,
> +	 VPIF_CH3_IMG_ADD_OFST, VPIF_CH3_VANC0_STRT, VPIF_CH3_VANC0_SIZE,
> +	 VPIF_CH3_VANC1_STRT, VPIF_CH3_VANC1_SIZE, 0x7FF, 0x7FF,
> +	 VPIF_CH3_MAX_MODES}
> +};
> +
> +static struct vpif_channel_config_params ch0_params[VPIF_CH0_MAX_MODES] = {
> +	{"NTSC", 720, 480, 30, 0, 1, 268, 1440, 1, 23, 263, 266,
> +	286, 525, 525, 0, 1, 0, V4L2_STD_NTSC},
> +	{"PAL", 720, 576, 25, 0, 1, 280, 1440, 1, 23, 311, 313,
> +	336, 624, 625, 0, 1, 0, V4L2_STD_PAL},
> +	{"720P-60", 1280, 720, 60, 1, 0, 362, 1280, 1, 26, 746, 0,
> +	0, 0, 750, 0, 0, 1, V4L2_STD_720P_60},
> +	{"1080I-30", 1920, 1080, 30, 0, 0, 272, 1920, 1, 21, 561, 564,
> +	584, 1124, 1125, 0, 0, 1, V4L2_STD_1080I_30},
> +	{"1080I-25", 1920, 1080, 25, 0, 0, 712, 1920, 1, 21, 561, 564,
> +	584, 1124, 1125, 0, 0, 1, V4L2_STD_1080I_25},
> +	{"720P-25", 1280, 720, 25, 1, 0, 2672, 1280, 1, 26, 746, 0,
> +	0, 0, 750, 0, 0, 1, V4L2_STD_720P_25},
> +	{"720P-30", 1280, 720, 30, 1, 0, 2012, 1280, 1, 26, 746, 0,
> +	0, 0, 750, 0, 0, 1, V4L2_STD_720P_30},
> +	{"720P-50", 1280, 720, 50, 1, 0, 692, 1280, 1, 26, 746, 0,
> +	0, 0, 750, 0, 0, 1, V4L2_STD_720P_50},
> +	{"480P-60", 720, 480, 60, 1, 0, 130, 720, 1, 43, 525,
> +	0, 0, 0, 525, 0, 0, 0, V4L2_STD_480P_60},
> +	{"576P-50", 720, 576, 50, 1, 0, 136, 720, 1, 45, 621,
> +	0, 0, 0, 625, 0, 0, 0, V4L2_STD_576P_50},
> +};
> +static struct vpif_channel_config_params ch1_params[VPIF_CH1_MAX_MODES] = {
> +	{"NTSC", 720, 480, 30, 0, 1, 268, 1440, 1, 23, 263, 266,
> +	286, 525, 525, 0, 1, 0, V4L2_STD_NTSC},
> +	{"PAL", 720, 576, 25, 0, 1, 280, 1440, 1, 23, 311, 313,
> +	336, 624, 625, 0, 1, 0, V4L2_STD_PAL},
> +};
> +
> +
> +static struct vpif_channel_config_params ch2_params[VPIF_CH2_MAX_MODES] = {
> +	{"NTSC", 720, 480, 30, 0, 1, 268, 1440, 1, 23, 263, 266,
> +	286, 525, 525, 0, 1, 0, V4L2_STD_NTSC},
> +	{"PAL", 720, 576, 25, 0, 1, 280, 1440, 1, 23, 311, 313,
> +	336, 624, 625, 0, 1, 0i, V4L2_STD_PAL},
> +	{"720P-60", 1280, 720, 60, 1, 0, 362, 1280, 1, 26, 746, 0,
> +	0, 0, 750, 0, 0, 1, V4L2_STD_720P_60},
> +	{"1080I-30", 1920, 1080, 30, 0, 0, 272, 1920, 1, 21, 561, 564,
> +	584, 1124, 1125, 0, 0, 1, V4L2_STD_1080I_30},
> +	{"1080I-25", 1920, 1080, 25, 0, 0, 712, 1920, 1, 21, 561, 564,
> +	584, 1124, 1125, 0, 0, 1, V4L2_STD_1080I_25},
> +	{"480P-60", 720, 480, 60, 1, 0, 130, 720, 1, 43, 525,
> +	0, 0, 0, 525, 0, 0, 0, V4L2_STD_480P_60},
> +	{"576P-50", 720, 576, 50, 1, 0, 136, 720, 1, 45, 621,
> +	0, 0, 0, 625, 0, 0, 0, V4L2_STD_576P_50},
> +	{"720P-25", 1280, 720, 25, 1, 0, 2672, 1280, 1, 26, 746, 0,
> +	0, 0, 750, 0, 0, 1, V4L2_STD_720P_25},
> +	{"720P-30", 1280, 720, 30, 1, 0, 2012, 1280, 1, 26, 746, 0,
> +	0, 0, 750, 0, 0, 1, V4L2_STD_720P_30},
> +	{"720P-50", 1280, 720, 50, 1, 0, 692, 1280, 1, 26, 746, 0,
> +	0, 0, 750, 0, 0, 1, V4L2_STD_720P_50},
> +	{"1080P-24", 1920, 1080, 24, 1, 0, 822, 1920, 1, 42, 1122, 0,
> +	0, 0, 1125, 0, 0, 1, V4L2_STD_1080P_24},
> +	{"1080P-25", 1920, 1080, 25, 1, 0, 712, 1920, 1, 42, 1122, 0,
> +	0, 0, 1125, 0, 0, 1, V4L2_STD_1080P_25},
> +	{"1080P-30", 1920, 1080, 30, 1, 0, 272, 1920, 1, 42, 1122, 0,
> +	0, 0, 1125, 0, 0, 1, V4L2_STD_1080P_30},
> +};
> +
> +static struct vpif_channel_config_params
> +	*vpif_config_params[VPIF_NUM_CHANNELS] = {
> +	ch0_params,
> +	ch1_params,
> +	ch2_params,
> +	ch1_params
> +};
> +
> +/* vpif_set_mode_info:
> + * This function is used to set horizontal and vertical config parameters
> + * As per the standard in the channel, configure the values of L1, L3,
> + * L5, L7  L9, L11 in VPIF Register , also write width and height
> + */
> +static void vpif_set_mode_info(u8 index, u8 channel_id, u8 config_channel_id)
> +{
> +	u32 value;
> +	struct vpif_channel_config_params *config =
> +				&vpif_config_params[config_channel_id][index];
> +
> +
> +	value = (config->eav2sav & vpifregs[config_channel_id].width_mask);
> +	value <<= VPIF_CH_LEN_SHIFT;
> +	value |= (config->sav2eav & vpifregs[config_channel_id].width_mask);
> +
> +	regw(value, vpifregs[channel_id].h_cfg);
> +
> +	value = (config->l1 & vpifregs[config_channel_id].len_mask);
> +	value <<= VPIF_CH_LEN_SHIFT;
> +	value |= (config->l3 & vpifregs[config_channel_id].len_mask);
> +
> +	regw(value, vpifregs[channel_id].v_cfg_00);
> +
> +	value = (config->l5 & vpifregs[config_channel_id].len_mask);
> +	value <<= VPIF_CH_LEN_SHIFT;
> +	value |= (config->l7 & vpifregs[config_channel_id].len_mask);
> +
> +	regw(value, vpifregs[channel_id].v_cfg_01);
> +
> +	value = (config->l9 & vpifregs[config_channel_id].len_mask);
> +	value <<= VPIF_CH_LEN_SHIFT;
> +	value |= (config->l11 & vpifregs[config_channel_id].len_mask);
> +
> +	regw(value, vpifregs[channel_id].v_cfg_02);
> +
> +	value = (config->vsize & vpifregs[config_channel_id].len_mask);
> +	regw(value, vpifregs[channel_id].v_cfg);
> +}
> +
> +/* config_vpif_params
> + * Function to set the parameters of a channel
> + * Mainly modifies the channel ciontrol register
> + * It sets frame format, yc mux mode
> + */
> +static void config_vpif_params(struct vpif_params *vpifparams,
> +				struct vpif_channel_config_params *config,
> +				u8 channel_id, u8 found)
> +{
> +	int i;
> +	u32 value, ch_nip, reg;
> +	u8 start, end;
> +
> +	start = channel_id;
> +	end = channel_id + found;
> +
> +	for (i = start; i < end; i++) {
> +
> +		reg = vpifregs[i].ch_ctrl;
> +
> +		if (channel_id < 2)
> +			ch_nip = VPIF_CAPTURE_CH_NIP;
> +		else
> +			ch_nip = VPIF_DISPLAY_CH_NIP;
> +
> +		if (config->frm_fmt)	/* Progressive Frame Format */
> +			vpif_set_bit(reg, ch_nip);
> +		 else			/* Interlaced Frame Format */
> +			vpif_clr_bit(reg, ch_nip);
> +
> +		if (config->ycmux_mode)	/* YC Mux mode */
> +			vpif_set_bit(reg, VPIF_CH_YC_MUX_BIT);
> +		else
> +			vpif_clr_bit(reg, VPIF_CH_YC_MUX_BIT);
> +
> +		if (vpifparams->video_params.storage_mode)
> +			vpif_set_bit(reg, VPIF_CH_INPUT_FIELD_FRAME_BIT);
> +		else
> +			vpif_clr_bit(reg, VPIF_CH_INPUT_FIELD_FRAME_BIT);
> +
> +		/* Set raster scanning SDR Format */
> +		vpif_clr_bit(reg, VPIF_CH_SDR_FMT_BIT);
> +
> +		if (config->capture_format)
> +			vpif_set_bit(reg, VPIF_CH_DATA_MODE_BIT);
> +		else
> +			vpif_clr_bit(reg, VPIF_CH_DATA_MODE_BIT);
> +
> +		if (channel_id > 1)	/* Set the Pixel enable bit */
> +			vpif_set_bit(reg, VPIF_DISPLAY_PIX_EN_BIT);
> +		else if (config->capture_format) {
> +			/* Set the polarity of various pins */
> +
> +			if (vpifparams->params.raw_params.fid_pol)
> +				vpif_set_bit(reg, VPIF_CH_FID_POLARITY_BIT);
> +			else
> +				vpif_clr_bit(reg, VPIF_CH_FID_POLARITY_BIT);
> +
> +			if (vpifparams->params.raw_params.vd_pol)
> +				vpif_set_bit(reg, VPIF_CH_V_VALID_POLARITY_BIT);
> +			else
> +				vpif_clr_bit(reg, VPIF_CH_V_VALID_POLARITY_BIT);
> +
> +			if (vpifparams->params.raw_params.hd_pol)
> +				vpif_set_bit(reg, VPIF_CH_H_VALID_POLARITY_BIT);
> +			else
> +				vpif_clr_bit(reg, VPIF_CH_H_VALID_POLARITY_BIT);
> +
> +			value = regr(reg);
> +			/* Set data width */
> +			value &= ((~(unsigned int)(0x3)) <<
> +					VPIF_CH_DATA_WIDTH_BIT);
> +			value |= ((vpifparams->params.raw_params.data_sz) <<
> +						     VPIF_CH_DATA_WIDTH_BIT);
> +			regw(value, reg);
> +		}
> +
> +		/* Write the pitch in the driver */
> +		regw((vpifparams->video_params.hpitch),
> +						vpifregs[i].line_offset);
> +	}
> +}
> +
> +/* vpif_set_video_params
> + * This function is used to set video parameters in VPIF register
> + */
> +int vpif_set_video_params(struct vpif_params *vpifparams, u8 channel_id)
> +{
> +	int index, found = -1;
> +	u8 max_modes = vpifregs[channel_id].max_modes;
> +
> +	for (index = 0; index < max_modes; index++) {
> +		struct vpif_channel_config_params *config =
> +				&vpif_config_params[channel_id][index];
> +
> +		/* If the mode is found, set the parameter in VPIF register */
> +		if (config->stdid == vpifparams->video_params.stdid) {
> +			found = 1;
> +			vpif_set_mode_info(index, channel_id, channel_id);
> +			if (!(config->ycmux_mode)) {
> +				vpif_set_mode_info(index,
> +						   channel_id + 1, channel_id);
> +				found = 2;
> +			}
> +
> +			config_vpif_params(vpifparams, config, channel_id,
> +									found);
> +			break;
> +		}
> +	}
> +
> +	regw(0x80, VPIF_REQ_SIZE);
> +	regw(0x01, VPIF_EMULATION_CTRL);
> +
> +	return found;
> +}
> +EXPORT_SYMBOL(vpif_set_video_params);
> +
> +int vpif_set_vbi_display_params(struct vpif_vbi_params *vbiparams,
> +				u8 channel_id)
> +{
> +	u32 value;
> +
> +	value = 0x3F8 & (vbiparams->hstart0);
> +	value |= 0x3FFFFFF & ((vbiparams->vstart0) << 16);
> +	regw(value, vpifregs[channel_id].vanc0_strt);
> +
> +	value = 0x3F8 & (vbiparams->hstart1);
> +	value |= 0x3FFFFFF & ((vbiparams->vstart1) << 16);
> +	regw(value, vpifregs[channel_id].vanc1_strt);
> +
> +	value = 0x3F8 & (vbiparams->hsize0);
> +	value |= 0x3FFFFFF & ((vbiparams->vsize0) << 16);
> +	regw(value, vpifregs[channel_id].vanc0_size);
> +
> +	value = 0x3F8 & (vbiparams->hsize1);
> +	value |= 0x3FFFFFF & ((vbiparams->vsize1) << 16);
> +	regw(value, vpifregs[channel_id].vanc1_size);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(vpif_set_vbi_display_params);
> +
> +int vpif_get_mode_info(struct vpif_stdinfo *std_info)
> +{
> +	int index, found = -1;
> +	u8 channel_id;
> +	u8 max_modes;
> +
> +	if (!std_info)
> +		return found;
> +
> +	channel_id = std_info->channel_id;
> +
> +	if (channel_id != 0 && channel_id != 1 && channel_id != 2 &&
> +	    channel_id != 3) {
> +		return found;
> +	}
> +
> +	max_modes = vpifregs[channel_id].max_modes;
> +
> +	for (index = 0; index < max_modes; index++) {
> +
> +		struct vpif_channel_config_params *config =
> +				&vpif_config_params[channel_id][index];
> +
> +		if (config->stdid == std_info->stdid) {
> +			std_info->activelines = config->height;
> +			std_info->activepixels = config->width;
> +			std_info->fps = config->fps;
> +			std_info->frame_format = config->frm_fmt;
> +			std_info->ycmux_mode = config->ycmux_mode;
> +			std_info->vbi_supported = config->vbi_supported;
> +			std_info->hd_sd = config->hd_sd;
> +			found = 1;
> +			break;
> +		}
> +	}
> +	return found;
> +}
> +EXPORT_SYMBOL(vpif_get_mode_info);
> +
> +int vpif_channel_getfid(u8 channel_id)
> +{
> +	int val;
> +	val = ((regr(vpifregs[channel_id].ch_ctrl) & VPIF_CH_FID_MASK)
> +					>> VPIF_CH_FID_SHIFT);
> +
> +	return val;
> +}
> +EXPORT_SYMBOL(vpif_channel_getfid);
> +
> +void vpif_base_addr_init(void __iomem *base)
> +{
> +	vpif_base = base;
> +}
> +EXPORT_SYMBOL(vpif_base_addr_init);
> +
> +MODULE_LICENSE("GPL");
> diff --git a/include/media/davinci/vpif.h b/include/media/davinci/vpif.h
> new file mode 100644
> index 0000000..95ec860
> --- /dev/null
> +++ b/include/media/davinci/vpif.h
> @@ -0,0 +1,672 @@
> +/*
> + * VPIF header file
> + *
> + * Copyright (C) 2009 Texas Instruments Incorporated - http://www.ti.com/
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed .as is. WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef VPIF_H
> +#define VPIF_H
> +
> +#ifdef __KERNEL__
> +
> +#include <linux/io.h>
> +#include <linux/videodev2.h>
> +#include <mach/hardware.h>
> +
> +/* Maximum channel allowed */
> +#define VPIF_NUM_CHANNELS		(4)
> +#define VPIF_CAPTURE_NUM_CHANNELS	(2)
> +#define VPIF_DISPLAY_NUM_CHANNELS	(2)
> +
> +/* Macros to read/write registers */
> +static void __iomem *vpif_base;
> +#define regr(reg)               readl((reg) + vpif_base)
> +#define regw(value, reg)        writel(value, (reg + vpif_base))
> +
> +/* Register Addresss Offsets */
> +#define VPIF_PID			(0x0000)
> +#define VPIF_CH0_CTRL			(0x0004)
> +#define VPIF_CH1_CTRL			(0x0008)
> +#define VPIF_CH2_CTRL			(0x000C)
> +#define VPIF_CH3_CTRL			(0x0010)
> +
> +#define VPIF_INTEN			(0x0020)
> +#define VPIF_INTEN_SET			(0x0024)
> +#define VPIF_INTEN_CLR			(0x0028)
> +#define VPIF_STATUS			(0x002C)
> +#define VPIF_STATUS_CLR			(0x0030)
> +#define VPIF_EMULATION_CTRL		(0x0034)
> +#define VPIF_REQ_SIZE			(0x0038)
> +
> +#define VPIF_CH0_TOP_STRT_ADD_LUMA	(0x0040)
> +#define VPIF_CH0_BTM_STRT_ADD_LUMA	(0x0044)
> +#define VPIF_CH0_TOP_STRT_ADD_CHROMA	(0x0048)
> +#define VPIF_CH0_BTM_STRT_ADD_CHROMA	(0x004c)
> +#define VPIF_CH0_TOP_STRT_ADD_HANC	(0x0050)
> +#define VPIF_CH0_BTM_STRT_ADD_HANC	(0x0054)
> +#define VPIF_CH0_TOP_STRT_ADD_VANC	(0x0058)
> +#define VPIF_CH0_BTM_STRT_ADD_VANC	(0x005c)
> +#define VPIF_CH0_SP_CFG			(0x0060)
> +#define VPIF_CH0_IMG_ADD_OFST		(0x0064)
> +#define VPIF_CH0_HANC_ADD_OFST		(0x0068)
> +#define VPIF_CH0_H_CFG			(0x006c)
> +#define VPIF_CH0_V_CFG_00		(0x0070)
> +#define VPIF_CH0_V_CFG_01		(0x0074)
> +#define VPIF_CH0_V_CFG_02		(0x0078)
> +#define VPIF_CH0_V_CFG_03		(0x007c)
> +
> +#define VPIF_CH1_TOP_STRT_ADD_LUMA	(0x0080)
> +#define VPIF_CH1_BTM_STRT_ADD_LUMA	(0x0084)
> +#define VPIF_CH1_TOP_STRT_ADD_CHROMA	(0x0088)
> +#define VPIF_CH1_BTM_STRT_ADD_CHROMA	(0x008c)
> +#define VPIF_CH1_TOP_STRT_ADD_HANC	(0x0090)
> +#define VPIF_CH1_BTM_STRT_ADD_HANC	(0x0094)
> +#define VPIF_CH1_TOP_STRT_ADD_VANC	(0x0098)
> +#define VPIF_CH1_BTM_STRT_ADD_VANC	(0x009c)
> +#define VPIF_CH1_SP_CFG			(0x00a0)
> +#define VPIF_CH1_IMG_ADD_OFST		(0x00a4)
> +#define VPIF_CH1_HANC_ADD_OFST		(0x00a8)
> +#define VPIF_CH1_H_CFG			(0x00ac)
> +#define VPIF_CH1_V_CFG_00		(0x00b0)
> +#define VPIF_CH1_V_CFG_01		(0x00b4)
> +#define VPIF_CH1_V_CFG_02		(0x00b8)
> +#define VPIF_CH1_V_CFG_03		(0x00bc)
> +
> +#define VPIF_CH2_TOP_STRT_ADD_LUMA	(0x00c0)
> +#define VPIF_CH2_BTM_STRT_ADD_LUMA	(0x00c4)
> +#define VPIF_CH2_TOP_STRT_ADD_CHROMA	(0x00c8)
> +#define VPIF_CH2_BTM_STRT_ADD_CHROMA	(0x00cc)
> +#define VPIF_CH2_TOP_STRT_ADD_HANC	(0x00d0)
> +#define VPIF_CH2_BTM_STRT_ADD_HANC	(0x00d4)
> +#define VPIF_CH2_TOP_STRT_ADD_VANC	(0x00d8)
> +#define VPIF_CH2_BTM_STRT_ADD_VANC	(0x00dc)
> +#define VPIF_CH2_SP_CFG			(0x00e0)
> +#define VPIF_CH2_IMG_ADD_OFST		(0x00e4)
> +#define VPIF_CH2_HANC_ADD_OFST		(0x00e8)
> +#define VPIF_CH2_H_CFG			(0x00ec)
> +#define VPIF_CH2_V_CFG_00		(0x00f0)
> +#define VPIF_CH2_V_CFG_01		(0x00f4)
> +#define VPIF_CH2_V_CFG_02		(0x00f8)
> +#define VPIF_CH2_V_CFG_03		(0x00fc)
> +#define VPIF_CH2_HANC0_STRT		(0x0100)
> +#define VPIF_CH2_HANC0_SIZE		(0x0104)
> +#define VPIF_CH2_HANC1_STRT		(0x0108)
> +#define VPIF_CH2_HANC1_SIZE		(0x010c)
> +#define VPIF_CH2_VANC0_STRT		(0x0110)
> +#define VPIF_CH2_VANC0_SIZE		(0x0114)
> +#define VPIF_CH2_VANC1_STRT		(0x0118)
> +#define VPIF_CH2_VANC1_SIZE		(0x011c)
> +
> +#define VPIF_CH3_TOP_STRT_ADD_LUMA	(0x0140)
> +#define VPIF_CH3_BTM_STRT_ADD_LUMA	(0x0144)
> +#define VPIF_CH3_TOP_STRT_ADD_CHROMA	(0x0148)
> +#define VPIF_CH3_BTM_STRT_ADD_CHROMA	(0x014c)
> +#define VPIF_CH3_TOP_STRT_ADD_HANC	(0x0150)
> +#define VPIF_CH3_BTM_STRT_ADD_HANC	(0x0154)
> +#define VPIF_CH3_TOP_STRT_ADD_VANC	(0x0158)
> +#define VPIF_CH3_BTM_STRT_ADD_VANC	(0x015c)
> +#define VPIF_CH3_SP_CFG			(0x0160)
> +#define VPIF_CH3_IMG_ADD_OFST		(0x0164)
> +#define VPIF_CH3_HANC_ADD_OFST		(0x0168)
> +#define VPIF_CH3_H_CFG			(0x016c)
> +#define VPIF_CH3_V_CFG_00		(0x0170)
> +#define VPIF_CH3_V_CFG_01		(0x0174)
> +#define VPIF_CH3_V_CFG_02		(0x0178)
> +#define VPIF_CH3_V_CFG_03		(0x017c)
> +#define VPIF_CH3_HANC0_STRT		(0x0180)
> +#define VPIF_CH3_HANC0_SIZE		(0x0184)
> +#define VPIF_CH3_HANC1_STRT		(0x0188)
> +#define VPIF_CH3_HANC1_SIZE		(0x018c)
> +#define VPIF_CH3_VANC0_STRT		(0x0190)
> +#define VPIF_CH3_VANC0_SIZE		(0x0194)
> +#define VPIF_CH3_VANC1_STRT		(0x0198)
> +#define VPIF_CH3_VANC1_SIZE		(0x019c)
> +
> +#define VPIF_IODFT_CTRL			(0x01c0)
> +
> +/* Functions for bit Manipulation */
> +static inline void vpif_set_bit(u32 reg, u32 bit)
> +{
> +	regw((regr(reg)) | (0x01 << bit), reg);
> +}
> +
> +static inline void vpif_clr_bit(u32 reg, u32 bit)
> +{
> +	regw(((regr(reg)) & ~(0x01 << bit)), reg);
> +}
> +
> +/* Macro for Generating mask */
> +#ifdef GENERATE_MASK
> +#undef GENERATE_MASK
> +#endif
> +
> +#define GENERATE_MASK(bits, pos) \
> +		((((0xFFFFFFFF) << (32 - bits)) >> (32 - bits)) << pos)
> +
> +/* Bit positions in the channel control registers */
> +#define VPIF_CH_DATA_MODE_BIT	(2)
> +#define VPIF_CH_YC_MUX_BIT	(3)
> +#define VPIF_CH_SDR_FMT_BIT	(4)
> +#define VPIF_CH_HANC_EN_BIT	(8)
> +#define VPIF_CH_VANC_EN_BIT	(9)
> +
> +#define VPIF_CAPTURE_CH_NIP	(10)
> +#define VPIF_DISPLAY_CH_NIP	(11)
> +
> +#define VPIF_DISPLAY_PIX_EN_BIT	(10)
> +
> +#define VPIF_CH_INPUT_FIELD_FRAME_BIT	(12)
> +
> +#define VPIF_CH_FID_POLARITY_BIT	(15)
> +#define VPIF_CH_V_VALID_POLARITY_BIT	(14)
> +#define VPIF_CH_H_VALID_POLARITY_BIT	(13)
> +#define VPIF_CH_DATA_WIDTH_BIT		(28)
> +
> +#define VPIF_CH_CLK_EDGE_CTRL_BIT	(31)
> +
> +/* Mask various length */
> +#define VPIF_CH_EAVSAV_MASK	GENERATE_MASK(13, 0)
> +#define VPIF_CH_LEN_MASK	GENERATE_MASK(12, 0)
> +#define VPIF_CH_WIDTH_MASK	GENERATE_MASK(13, 0)
> +#define VPIF_CH_LEN_SHIFT	(16)
> +
> +/* VPIF masks for registers */
> +#define VPIF_REQ_SIZE_MASK	(0x1ff)
> +
> +/* bit posotion of interrupt vpif_ch_intr register */
> +#define VPIF_INTEN_FRAME_CH0	(0x00000001)
> +#define VPIF_INTEN_FRAME_CH1	(0x00000002)
> +#define VPIF_INTEN_FRAME_CH2	(0x00000004)
> +#define VPIF_INTEN_FRAME_CH3	(0x00000008)
> +
> +/* bit position of clock and channel enable in vpif_chn_ctrl register */
> +
> +#define VPIF_CH0_CLK_EN		(0x00000002)
> +#define VPIF_CH0_EN		(0x00000001)
> +#define VPIF_CH1_CLK_EN		(0x00000002)
> +#define VPIF_CH1_EN		(0x00000001)
> +#define VPIF_CH2_CLK_EN		(0x00000002)
> +#define VPIF_CH2_EN		(0x00000001)
> +#define VPIF_CH3_CLK_EN		(0x00000002)
> +#define VPIF_CH3_EN		(0x00000001)
> +#define VPIF_CH_CLK_EN		(0x00000002)
> +#define VPIF_CH_EN	        (0x00000001)
> +
> +#define VPIF_INT_TOP	(0x00)
> +#define VPIF_INT_BOTTOM	(0x01)
> +#define VPIF_INT_BOTH	(0x02)
> +
> +#define VPIF_CH0_INT_CTRL_SHIFT	(6)
> +#define VPIF_CH1_INT_CTRL_SHIFT	(6)
> +#define VPIF_CH2_INT_CTRL_SHIFT	(6)
> +#define VPIF_CH3_INT_CTRL_SHIFT	(6)
> +#define VPIF_CH_INT_CTRL_SHIFT	(6)
> +
> +/* enabled interrupt on both the fields on vpid_ch0_ctrl register */
> +#define channel0_intr_assert()	(regw((regr(VPIF_CH0_CTRL)|\
> +				(VPIF_INT_BOTH << \
> +				VPIF_CH0_INT_CTRL_SHIFT)), \
> +				VPIF_CH0_CTRL))
> +
> +/* enabled interrupt on both the fields on vpid_ch1_ctrl register */
> +#define channel1_intr_assert()	(regw((regr(VPIF_CH1_CTRL)|\
> +				(VPIF_INT_BOTH << \
> +				VPIF_CH1_INT_CTRL_SHIFT)), \
> +				VPIF_CH1_CTRL))
> +
> +/* enabled interrupt on both the fields on vpid_ch0_ctrl register */
> +#define channel2_intr_assert() 	(regw((regr(VPIF_CH2_CTRL)|\
> +				(VPIF_INT_BOTH << \
> +				VPIF_CH2_INT_CTRL_SHIFT)), \
> +				VPIF_CH2_CTRL))
> +
> +/* enabled interrupt on both the fields on vpid_ch1_ctrl register */
> +#define channel3_intr_assert() 	(regw((regr(VPIF_CH3_CTRL)|\
> +				(VPIF_INT_BOTH << \
> +				VPIF_CH3_INT_CTRL_SHIFT)), \
> +				VPIF_CH3_CTRL))
> +
> +#define VPIF_CH_FID_MASK	(0x20)
> +#define VPIF_CH_FID_SHIFT	(5)
> +
> +#define VPIF_NTSC_VBI_START_FIELD0	(1)
> +#define VPIF_NTSC_VBI_START_FIELD1	(263)
> +#define VPIF_PAL_VBI_START_FIELD0	(624)
> +#define VPIF_PAL_VBI_START_FIELD1	(311)
> +
> +#define VPIF_NTSC_HBI_START_FIELD0	(1)
> +#define VPIF_NTSC_HBI_START_FIELD1	(263)
> +#define VPIF_PAL_HBI_START_FIELD0	(624)
> +#define VPIF_PAL_HBI_START_FIELD1	(311)
> +
> +#define VPIF_NTSC_VBI_COUNT_FIELD0	(20)
> +#define VPIF_NTSC_VBI_COUNT_FIELD1	(19)
> +#define VPIF_PAL_VBI_COUNT_FIELD0	(24)
> +#define VPIF_PAL_VBI_COUNT_FIELD1	(25)
> +
> +#define VPIF_NTSC_HBI_COUNT_FIELD0	(263)
> +#define VPIF_NTSC_HBI_COUNT_FIELD1	(262)
> +#define VPIF_PAL_HBI_COUNT_FIELD0	(312)
> +#define VPIF_PAL_HBI_COUNT_FIELD1	(313)
> +
> +#define VPIF_NTSC_VBI_SAMPLES_PER_LINE	(720)
> +#define VPIF_PAL_VBI_SAMPLES_PER_LINE	(720)
> +#define VPIF_NTSC_HBI_SAMPLES_PER_LINE	(268)
> +#define VPIF_PAL_HBI_SAMPLES_PER_LINE	(280)
> +
> +#define VPIF_CH_VANC_EN			(0x20)
> +#define VPIF_DMA_REQ_SIZE		(0x080)
> +#define VPIF_EMULATION_DISABLE		(0x01)
> +
> +extern u8 irq_vpif_capture_channel[VPIF_NUM_CHANNELS];
> +
> +/* inline function to enable/disable channel0 */
> +static inline void enable_channel0(int enable)
> +{
> +	if (enable)
> +		regw((regr(VPIF_CH0_CTRL) | (VPIF_CH0_EN)), VPIF_CH0_CTRL);
> +	else
> +		regw((regr(VPIF_CH0_CTRL) & (~VPIF_CH0_EN)), VPIF_CH0_CTRL);
> +}
> +
> +/* inline function to enable/disable channel1 */
> +static inline void enable_channel1(int enable)
> +{
> +	if (enable)
> +		regw((regr(VPIF_CH1_CTRL) | (VPIF_CH1_EN)), VPIF_CH1_CTRL);
> +	else
> +		regw((regr(VPIF_CH1_CTRL) & (~VPIF_CH1_EN)), VPIF_CH1_CTRL);
> +}
> +
> +/* inline function to enable interrupt for channel0 */
> +static inline void channel0_intr_enable(int enable)
> +{
> +	if (enable) {
> +
> +		regw((regr(VPIF_INTEN) | 0x10), VPIF_INTEN);
> +		regw((regr(VPIF_INTEN_SET) | 0x10), VPIF_INTEN_SET);
> +
> +		regw((regr(VPIF_INTEN) | VPIF_INTEN_FRAME_CH0), VPIF_INTEN);
> +		regw((regr(VPIF_INTEN_SET) | VPIF_INTEN_FRAME_CH0),
> +							VPIF_INTEN_SET);
> +	} else {
> +		regw((regr(VPIF_INTEN) & (~VPIF_INTEN_FRAME_CH0)), VPIF_INTEN);
> +		regw((regr(VPIF_INTEN_SET) | VPIF_INTEN_FRAME_CH0),
> +							VPIF_INTEN_SET);
> +	}
> +}
> +
> +/* inline function to enable interrupt for channel1 */
> +static inline void channel1_intr_enable(int enable)
> +{
> +	if (enable) {
> +		regw((regr(VPIF_INTEN) | 0x10), VPIF_INTEN);
> +		regw((regr(VPIF_INTEN_SET) | 0x10), VPIF_INTEN_SET);
> +
> +		regw((regr(VPIF_INTEN) | VPIF_INTEN_FRAME_CH1), VPIF_INTEN);
> +		regw((regr(VPIF_INTEN_SET) | VPIF_INTEN_FRAME_CH1),
> +							VPIF_INTEN_SET);
> +	} else {
> +		regw((regr(VPIF_INTEN) & (~VPIF_INTEN_FRAME_CH1)), VPIF_INTEN);
> +		regw((regr(VPIF_INTEN_SET) | VPIF_INTEN_FRAME_CH1),
> +							VPIF_INTEN_SET);
> +	}
> +}
> +
> +/* inline function to set buffer addresses in case of Y/C non mux mode */
> +static inline void ch0_set_videobuf_addr_yc_nmux(unsigned long top_strt_luma,
> +						 unsigned long btm_strt_luma,
> +						 unsigned long top_strt_chroma,
> +						 unsigned long btm_strt_chroma)
> +{
> +	regw(top_strt_luma, VPIF_CH0_TOP_STRT_ADD_LUMA);
> +	regw(btm_strt_luma, VPIF_CH0_BTM_STRT_ADD_LUMA);
> +	regw(top_strt_chroma, VPIF_CH1_TOP_STRT_ADD_CHROMA);
> +	regw(btm_strt_chroma, VPIF_CH1_BTM_STRT_ADD_CHROMA);
> +}
> +
> +/* inline function to set buffer addresses in VPIF registers for video data */
> +static inline void ch0_set_videobuf_addr(unsigned long top_strt_luma,
> +					 unsigned long btm_strt_luma,
> +					 unsigned long top_strt_chroma,
> +					 unsigned long btm_strt_chroma)
> +{
> +	regw(top_strt_luma, VPIF_CH0_TOP_STRT_ADD_LUMA);
> +	regw(btm_strt_luma, VPIF_CH0_BTM_STRT_ADD_LUMA);
> +	regw(top_strt_chroma, VPIF_CH0_TOP_STRT_ADD_CHROMA);
> +	regw(btm_strt_chroma, VPIF_CH0_BTM_STRT_ADD_CHROMA);
> +}
> +
> +static inline void ch1_set_videobuf_addr(unsigned long top_strt_luma,
> +					 unsigned long btm_strt_luma,
> +					 unsigned long top_strt_chroma,
> +					 unsigned long btm_strt_chroma)
> +{
> +
> +	regw(top_strt_luma, VPIF_CH1_TOP_STRT_ADD_LUMA);
> +	regw(btm_strt_luma, VPIF_CH1_BTM_STRT_ADD_LUMA);
> +	regw(top_strt_chroma, VPIF_CH1_TOP_STRT_ADD_CHROMA);
> +	regw(btm_strt_chroma, VPIF_CH1_BTM_STRT_ADD_CHROMA);
> +}
> +
> +static inline void ch0_set_vbi_addr(unsigned long top_vbi,
> +	unsigned long btm_vbi, unsigned long a, unsigned long b)
> +{
> +	regw(top_vbi, VPIF_CH0_TOP_STRT_ADD_VANC);
> +	regw(btm_vbi, VPIF_CH0_BTM_STRT_ADD_VANC);
> +}
> +
> +static inline void ch0_set_hbi_addr(unsigned long top_vbi,
> +	unsigned long btm_vbi, unsigned long a, unsigned long b)
> +{
> +	regw(top_vbi, VPIF_CH0_TOP_STRT_ADD_HANC);
> +	regw(btm_vbi, VPIF_CH0_BTM_STRT_ADD_HANC);
> +}
> +
> +static inline void ch1_set_vbi_addr(unsigned long top_vbi,
> +	unsigned long btm_vbi, unsigned long a, unsigned long b)
> +{
> +	regw(top_vbi, VPIF_CH1_TOP_STRT_ADD_VANC);
> +	regw(btm_vbi, VPIF_CH1_BTM_STRT_ADD_VANC);
> +}
> +
> +static inline void ch1_set_hbi_addr(unsigned long top_vbi,
> +	unsigned long btm_vbi, unsigned long a, unsigned long b)
> +{
> +	regw(top_vbi, VPIF_CH1_TOP_STRT_ADD_HANC);
> +	regw(btm_vbi, VPIF_CH1_BTM_STRT_ADD_HANC);
> +}
> +
> +/* Inline function to enable raw vbi in the given channel */
> +static inline void disable_raw_feature(u8 channel_id, u8 index)
> +{
> +	u32 ctrl_reg;
> +	if (0 == channel_id)
> +		ctrl_reg = VPIF_CH0_CTRL;
> +	else
> +		ctrl_reg = VPIF_CH1_CTRL;
> +
> +	if (1 == index)
> +		vpif_clr_bit(ctrl_reg, VPIF_CH_VANC_EN_BIT);
> +	else
> +		vpif_clr_bit(ctrl_reg, VPIF_CH_HANC_EN_BIT);
> +
> +}
> +
> +static inline void enable_raw_feature(u8 channel_id, u8 index)
> +{
> +	u32 ctrl_reg;
> +	if (0 == channel_id)
> +		ctrl_reg = VPIF_CH0_CTRL;
> +	else
> +		ctrl_reg = VPIF_CH1_CTRL;
> +
> +	if (1 == index)
> +		vpif_set_bit(ctrl_reg, VPIF_CH_VANC_EN_BIT);
> +	else
> +		vpif_set_bit(ctrl_reg, VPIF_CH_HANC_EN_BIT);
> +
> +}
> +
> +/* inline function to enable/disable channel2 */
> +static inline void enable_channel2(int enable)
> +{
> +	if (enable) {
> +		regw((regr(VPIF_CH2_CTRL) | (VPIF_CH2_CLK_EN)), VPIF_CH2_CTRL);
> +		regw((regr(VPIF_CH2_CTRL) | (VPIF_CH2_EN)), VPIF_CH2_CTRL);
> +	} else {
> +		regw((regr(VPIF_CH2_CTRL) & (~VPIF_CH2_CLK_EN)), VPIF_CH2_CTRL);
> +		regw((regr(VPIF_CH2_CTRL) & (~VPIF_CH2_EN)), VPIF_CH2_CTRL);
> +	}
> +}
> +
> +/* inline function to enable/disable channel3 */
> +static inline void enable_channel3(int enable)
> +{
> +	if (enable) {
> +		regw((regr(VPIF_CH3_CTRL) | (VPIF_CH3_CLK_EN)), VPIF_CH3_CTRL);
> +		regw((regr(VPIF_CH3_CTRL) | (VPIF_CH3_EN)), VPIF_CH3_CTRL);
> +	} else {
> +		regw((regr(VPIF_CH3_CTRL) & (~VPIF_CH3_CLK_EN)), VPIF_CH3_CTRL);
> +		regw((regr(VPIF_CH3_CTRL) & (~VPIF_CH3_EN)), VPIF_CH3_CTRL);
> +	}
> +}
> +
> +/* inline function to enable interrupt for channel2 */
> +static inline void channel2_intr_enable(int enable)
> +{
> +	if (enable) {
> +		regw((regr(VPIF_INTEN) | 0x10), VPIF_INTEN);
> +		regw((regr(VPIF_INTEN_SET) | 0x10), VPIF_INTEN_SET);
> +
> +		regw((regr(VPIF_INTEN) | VPIF_INTEN_FRAME_CH2), VPIF_INTEN);
> +		regw((regr(VPIF_INTEN_SET) | VPIF_INTEN_FRAME_CH2),
> +							VPIF_INTEN_SET);
> +	} else {
> +		regw((regr(VPIF_INTEN) & (~VPIF_INTEN_FRAME_CH2)), VPIF_INTEN);
> +		regw((regr(VPIF_INTEN_SET) | VPIF_INTEN_FRAME_CH2),
> +							VPIF_INTEN_SET);
> +	}
> +}
> +
> +/* inline function to enable interrupt for channel3 */
> +static inline void channel3_intr_enable(int enable)
> +{
> +	if (enable) {
> +		regw((regr(VPIF_INTEN) | 0x10), VPIF_INTEN);
> +		regw((regr(VPIF_INTEN_SET) | 0x10), VPIF_INTEN_SET);
> +
> +		regw((regr(VPIF_INTEN) | VPIF_INTEN_FRAME_CH3), VPIF_INTEN);
> +		regw((regr(VPIF_INTEN_SET) | VPIF_INTEN_FRAME_CH3),
> +							VPIF_INTEN_SET);
> +	} else {
> +		regw((regr(VPIF_INTEN) & (~VPIF_INTEN_FRAME_CH3)), VPIF_INTEN);
> +		regw((regr(VPIF_INTEN_SET) | VPIF_INTEN_FRAME_CH3),
> +							VPIF_INTEN_SET);
> +	}
> +}
> +
> +/* inline function to enable raw vbi data for channel2 */
> +static inline void channel2_raw_enable(int enable, u8 index)
> +{
> +	u32 mask;
> +
> +	if (1 == index)
> +		mask = VPIF_CH_VANC_EN_BIT;
> +	else
> +		mask = VPIF_CH_HANC_EN_BIT;
> +
> +	if (enable)
> +		vpif_set_bit(VPIF_CH2_CTRL, mask);
> +	else
> +		vpif_clr_bit(VPIF_CH2_CTRL, mask);
> +
> +
> +}
> +
> +/* inline function to enable raw vbi data for channel3*/
> +static inline void channel3_raw_enable(int enable, u8 index)
> +{
> +	u32 mask;
> +
> +	if (1 == index)
> +		mask = VPIF_CH_VANC_EN_BIT;
> +	else
> +		mask = VPIF_CH_HANC_EN_BIT;
> +
> +	if (enable)
> +		vpif_set_bit(VPIF_CH3_CTRL, mask);
> +	else
> +		vpif_clr_bit(VPIF_CH3_CTRL, mask);
> +
> +}
> +
> +/* inline function to set buffer addresses in case of Y/C non mux mode */
> +static inline void ch2_set_videobuf_addr_yc_nmux(unsigned long top_strt_luma,
> +						 unsigned long btm_strt_luma,
> +						 unsigned long top_strt_chroma,
> +						 unsigned long btm_strt_chroma)
> +{
> +	regw(top_strt_luma, VPIF_CH2_TOP_STRT_ADD_LUMA);
> +	regw(btm_strt_luma, VPIF_CH2_BTM_STRT_ADD_LUMA);
> +	regw(top_strt_chroma, VPIF_CH3_TOP_STRT_ADD_CHROMA);
> +	regw(btm_strt_chroma, VPIF_CH3_BTM_STRT_ADD_CHROMA);
> +}
> +
> +/* inline function to set buffer addresses in VPIF registers for video data */
> +static inline void ch2_set_videobuf_addr(unsigned long top_strt_luma,
> +					 unsigned long btm_strt_luma,
> +					 unsigned long top_strt_chroma,
> +					 unsigned long btm_strt_chroma)
> +{
> +	regw(top_strt_luma, VPIF_CH2_TOP_STRT_ADD_LUMA);
> +	regw(btm_strt_luma, VPIF_CH2_BTM_STRT_ADD_LUMA);
> +	regw(top_strt_chroma, VPIF_CH2_TOP_STRT_ADD_CHROMA);
> +	regw(btm_strt_chroma, VPIF_CH2_BTM_STRT_ADD_CHROMA);
> +
> +}
> +
> +static inline void ch3_set_videobuf_addr(unsigned long top_strt_luma,
> +					 unsigned long btm_strt_luma,
> +					 unsigned long top_strt_chroma,
> +					 unsigned long btm_strt_chroma)
> +{
> +	regw(top_strt_luma, VPIF_CH3_TOP_STRT_ADD_LUMA);
> +	regw(btm_strt_luma, VPIF_CH3_BTM_STRT_ADD_LUMA);
> +	regw(top_strt_chroma, VPIF_CH3_TOP_STRT_ADD_CHROMA);
> +	regw(btm_strt_chroma, VPIF_CH3_BTM_STRT_ADD_CHROMA);
> +
> +}
> +
> +/* inline function to set buffer addresses in VPIF registers for vbi data */
> +static inline void ch2_set_vbi_addr(unsigned long top_strt_luma,
> +					 unsigned long btm_strt_luma,
> +					 unsigned long top_strt_chroma,
> +					 unsigned long btm_strt_chroma)
> +{
> +	regw(top_strt_luma, VPIF_CH2_TOP_STRT_ADD_VANC);
> +	regw(btm_strt_luma, VPIF_CH2_BTM_STRT_ADD_VANC);
> +}
> +
> +static inline void ch3_set_vbi_addr(unsigned long top_strt_luma,
> +					 unsigned long btm_strt_luma,
> +					 unsigned long top_strt_chroma,
> +					 unsigned long btm_strt_chroma)
> +{
> +	regw(top_strt_luma, VPIF_CH3_TOP_STRT_ADD_VANC);
> +	regw(btm_strt_luma, VPIF_CH3_BTM_STRT_ADD_VANC);
> +}
> +
> +#define VPIF_MAX_NAME	(30)
> +
> +/* This structure will store size parameters as per the mode selected by user */
> +struct vpif_channel_config_params {
> +	char name[VPIF_MAX_NAME];	/* Name of the mode */
> +	u16 width;			/* Indicates width of the image */
> +	u16 height;			/* Indicates height of the image */
> +	u8 fps;
> +	u8 frm_fmt;			/* Indicates whether this is interlaced
> +					   or progressive format */
> +	u8 ycmux_mode;			/* Indicates whether this mode requires
> +					   single or two channels */
> +	u16 eav2sav;			/* length of sav 2 eav */
> +	u16 sav2eav;			/* length of sav 2 eav */
> +	u16 l1, l3, l5, l7, l9, l11;	/* Other parameter configurations */
> +	u16 vsize;			/* Vertical size of the image */
> +	u8 capture_format;		/* Indicates whether capture format
> +					   is in BT or in CCD/CMOS */
> +	u8  vbi_supported;		/* Indicates whether this mode
> +					   supports capturing vbi or not */
> +	u8 hd_sd;
> +	v4l2_std_id stdid;
> +};
> +
> +struct vpif_stdinfo {
> +	u8 channel_id;
> +	u32 activepixels;
> +	u32 activelines;
> +	u16 fps;
> +	u8 frame_format;
> +	char name[VPIF_MAX_NAME];
> +	u8 ycmux_mode;
> +	u8 vbi_supported;	  /* Indicates whether this mode
> +				     supports capturing vbi or not */
> +	u8 hd_sd;
> +	v4l2_std_id stdid;
> +};
> +
> +struct vpif_interface;
> +struct vpif_params;
> +struct vpif_vbi_params;
> +
> +int vpif_get_mode_info(struct vpif_stdinfo *std_info);
> +
> +int vpif_set_video_params(struct vpif_params *, u8 channel_id);
> +
> +int vpif_set_vbi_display_params(struct vpif_vbi_params *vbiparams,
> +							u8 channel_id);
> +
> +int vpif_channel_getfid(u8 channel_id);
> +
> +void vpif_base_addr_init(void __iomem *base);
> +#endif				/* End of #ifdef __KERNEL__ */
> +
> +/* Enumerated data types */
> +enum vpif_capture_pinpol {
> +	VPIF_CAPTURE_PINPOL_SAME	= 0,
> +	VPIF_CAPTURE_PINPOL_INVERT	= 1
> +};
> +
> +enum data_size {
> +	_8BITS	= 0,
> +	_10BITS,
> +	_12BITS,
> +};
> +
> +struct vpif_capture_params_raw {
> +	enum data_size data_sz;
> +	enum vpif_capture_pinpol fid_pol;
> +	enum vpif_capture_pinpol vd_pol;
> +	enum vpif_capture_pinpol hd_pol;
> +};
> +
> +/* structure for vpif parameters */
> +struct vpif_interface {
> +	char name[25];
> +	__u8 storage_mode;	/* Indicates whether it is field or frame
> +				   based storage mode */
> +	unsigned long hpitch;
> +	v4l2_std_id stdid;
> +};
> +
> +/* Structure for vpif parameters for raw vbi data */
> +struct vpif_vbi_params {
> +	__u32 hstart0;  /* Horizontal start of raw vbi data for first field */
> +	__u32 vstart0;  /* Vertical start of raw vbi data for first field */
> +	__u32 hsize0;   /* Horizontal size of raw vbi data for first field */
> +	__u32 vsize0;   /* Vertical size of raw vbi data for first field */
> +	__u32 hstart1;  /* Horizontal start of raw vbi data for second field */
> +	__u32 vstart1;  /* Vertical start of raw vbi data for second field */
> +	__u32 hsize1;   /* Horizontal size of raw vbi data for second field */
> +	__u32 vsize1;   /* Vertical size of raw vbi data for second field */
> +};
> +
> +struct vpif_params {
> +	struct vpif_interface	video_params;
> +	union param{
> +		struct vpif_vbi_params	vbi_params;
> +		struct vpif_capture_params_raw	raw_params;
> +	} params;
> +};
> +
> +#endif				/* End of #ifndef VPIF_H */
> +



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
