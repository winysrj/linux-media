Return-path: <mchehab@pedra>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:50187 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752787Ab1DSGmM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 02:42:12 -0400
Message-ID: <4DAD2EBE.3060000@arcor.de>
Date: Tue, 19 Apr 2011 08:42:06 +0200
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v1] tm6000: rework standards
References: <4CAD5A78.3070803@redhat.com> <4CB492D4.1000609@arcor.de> <20101129174412.08f2001c@glory.local> <4CF51C9E.6040600@arcor.de> <20101201144704.43b58f2c@glory.local> <4CF67AB9.6020006@arcor.de> <20101202134128.615bbfa0@glory.local> <4CF71CF6.7080603@redhat.com> <20101206010934.55d07569@glory.local> <4CFBF62D.7010301@arcor.de> <20101206190230.2259d7ab@glory.local> <4CFEA3D2.4050309@arcor.de> <20101208125539.739e2ed2@glory.local> <4CFFAD1E.7040004@arcor.de> <20101214122325.5cdea67e@glory.local> <4D079ADF.2000705@arcor.de> <20101215164634.44846128@glory.local> <4D08E43C.8080002@arcor.de> <20101216183844.6258734e@glory.local> <4D0A4883.20804@arcor.de> <20101217104633.7c9d10d7@glory.local> <4D0AF2A7.6080100@arcor.de> <20101217160854.16a1f754@glory.local> <4D0BFF4B.3060001@redhat.com> <20110120150508.53c9b55e@glory.local> <4D388C44.7040500@arcor.de> <20110217141257.6d1b578b@glory.local> <4D5D8BFB.4070802@redhat.com> <20110419152937.1ea64fb3@glory.local>
In-Reply-To: <20110419152937.1ea64fb3@glory.local>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Am 19.04.2011 07:29, schrieb Dmitri Belimov:
> Hi
>
> Add audio configuration for composite input.
> Rework init process of the tm6010.
> Rework configure video standards.
>
> diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
> index 146c7e8..9cf1abd 100644
> --- a/drivers/staging/tm6000/tm6000-cards.c
> +++ b/drivers/staging/tm6000/tm6000-cards.c
> @@ -68,6 +68,7 @@ struct tm6000_board {
>   	struct tm6000_capabilities caps;
>   	enum            tm6000_inaudio aradio;
>   	enum            tm6000_inaudio avideo;
> +	enum            tm6000_inaudio acomposite;
>
>   	enum		tm6000_devtype type;	/* variant of the chipset */
>   	int             tuner_type;     /* type of the tuner */
> @@ -234,6 +235,7 @@ struct tm6000_board tm6000_boards[] = {
>   		.type         = TM6010,
>   		.avideo       = TM6000_AIP_SIF1,
>   		.aradio       = TM6000_AIP_LINE1,
> +		.acomposite   = TM6000_AIP_LINE2,
>   		.caps = {
>   			.has_tuner      = 1,
>   			.has_dvb        = 1,
> @@ -256,6 +258,7 @@ struct tm6000_board tm6000_boards[] = {
>   		.type         = TM6010,
>   		.avideo       = TM6000_AIP_SIF1,
>   		.aradio       = TM6000_AIP_LINE1,
> +		.acomposite   = TM6000_AIP_LINE2,
>   		.caps = {
>   			.has_tuner      = 1,
>   			.has_dvb        = 0,
> @@ -330,6 +333,7 @@ struct tm6000_board tm6000_boards[] = {
>   		.type         = TM6010,
>   		.avideo       = TM6000_AIP_SIF1,
>   		.aradio       = TM6000_AIP_LINE1,
> +		.acomposite   = TM6000_AIP_LINE2,
>   		.caps = {
>   			.has_tuner      = 1,
>   			.has_dvb        = 1,
> @@ -352,6 +356,7 @@ struct tm6000_board tm6000_boards[] = {
>   		.type         = TM6010,
>   		.avideo       = TM6000_AIP_SIF1,
>   		.aradio       = TM6000_AIP_LINE1,
> +		.acomposite   = TM6000_AIP_LINE2,
>   		.caps = {
>   			.has_tuner      = 1,
>   			.has_dvb        = 0,
> @@ -753,6 +758,7 @@ static int tm6000_init_dev(struct tm6000_core *dev)
>
>   	dev->avideo = tm6000_boards[dev->model].avideo;
>   	dev->aradio = tm6000_boards[dev->model].aradio;
> +	dev->acomposite = tm6000_boards[dev->model].acomposite;
>   	/* initialize hardware */
>   	rc = tm6000_init(dev);
>   	if (rc<  0)
> diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
> index 778e534..ec7f613 100644
> --- a/drivers/staging/tm6000/tm6000-core.c
> +++ b/drivers/staging/tm6000/tm6000-core.c
> @@ -201,68 +201,6 @@ void tm6000_set_fourcc_format(struct tm6000_core *dev)
>   	}
>   }
>
> -static void tm6000_set_vbi(struct tm6000_core *dev)
> -{
> -	/*
> -	 * FIXME:
> -	 * VBI lines and start/end are different between 60Hz and 50Hz
> -	 * So, it is very likely that we need to change the config to
> -	 * something that takes it into account, doing something different
> -	 * if (dev->norm&  V4L2_STD_525_60)
> -	 */
> -
> -	if (dev->dev_type == TM6010) {
> -		tm6000_set_reg(dev, TM6010_REQ07_R3F_RESET, 0x01);
> -		tm6000_set_reg(dev, TM6010_REQ07_R41_TELETEXT_VBI_CODE1, 0x27);
> -		tm6000_set_reg(dev, TM6010_REQ07_R42_VBI_DATA_HIGH_LEVEL, 0x55);
> -		tm6000_set_reg(dev, TM6010_REQ07_R43_VBI_DATA_TYPE_LINE7, 0x66);
> -		tm6000_set_reg(dev, TM6010_REQ07_R44_VBI_DATA_TYPE_LINE8, 0x66);
> -		tm6000_set_reg(dev, TM6010_REQ07_R45_VBI_DATA_TYPE_LINE9, 0x66);
> -		tm6000_set_reg(dev,
> -			TM6010_REQ07_R46_VBI_DATA_TYPE_LINE10, 0x66);
> -		tm6000_set_reg(dev,
> -			TM6010_REQ07_R47_VBI_DATA_TYPE_LINE11, 0x66);
> -		tm6000_set_reg(dev,
> -			TM6010_REQ07_R48_VBI_DATA_TYPE_LINE12, 0x66);
> -		tm6000_set_reg(dev,
> -			TM6010_REQ07_R49_VBI_DATA_TYPE_LINE13, 0x66);
> -		tm6000_set_reg(dev,
> -			TM6010_REQ07_R4A_VBI_DATA_TYPE_LINE14, 0x66);
> -		tm6000_set_reg(dev,
> -			TM6010_REQ07_R4B_VBI_DATA_TYPE_LINE15, 0x66);
> -		tm6000_set_reg(dev,
> -			TM6010_REQ07_R4C_VBI_DATA_TYPE_LINE16, 0x66);
> -		tm6000_set_reg(dev,
> -			TM6010_REQ07_R4D_VBI_DATA_TYPE_LINE17, 0x66);
> -		tm6000_set_reg(dev,
> -			TM6010_REQ07_R4E_VBI_DATA_TYPE_LINE18, 0x66);
> -		tm6000_set_reg(dev,
> -			TM6010_REQ07_R4F_VBI_DATA_TYPE_LINE19, 0x66);
> -		tm6000_set_reg(dev,
> -			TM6010_REQ07_R50_VBI_DATA_TYPE_LINE20, 0x66);
> -		tm6000_set_reg(dev,
> -			TM6010_REQ07_R51_VBI_DATA_TYPE_LINE21, 0x66);
> -		tm6000_set_reg(dev,
> -			TM6010_REQ07_R52_VBI_DATA_TYPE_LINE22, 0x66);
> -		tm6000_set_reg(dev,
> -			TM6010_REQ07_R53_VBI_DATA_TYPE_LINE23, 0x00);
> -		tm6000_set_reg(dev,
> -			TM6010_REQ07_R54_VBI_DATA_TYPE_RLINES, 0x00);
> -		tm6000_set_reg(dev,
> -			TM6010_REQ07_R55_VBI_LOOP_FILTER_GAIN, 0x01);
> -		tm6000_set_reg(dev,
> -			TM6010_REQ07_R56_VBI_LOOP_FILTER_I_GAIN, 0x00);
> -		tm6000_set_reg(dev,
> -			TM6010_REQ07_R57_VBI_LOOP_FILTER_P_GAIN, 0x02);
> -		tm6000_set_reg(dev, TM6010_REQ07_R58_VBI_CAPTION_DTO1, 0x35);
> -		tm6000_set_reg(dev, TM6010_REQ07_R59_VBI_CAPTION_DTO0, 0xa0);
> -		tm6000_set_reg(dev, TM6010_REQ07_R5A_VBI_TELETEXT_DTO1, 0x11);
> -		tm6000_set_reg(dev, TM6010_REQ07_R5B_VBI_TELETEXT_DTO0, 0x4c);
> -		tm6000_set_reg(dev, TM6010_REQ07_R40_TELETEXT_VBI_CODE0, 0x01);
> -		tm6000_set_reg(dev, TM6010_REQ07_R3F_RESET, 0x00);
> -	}
> -}
> -
>   int tm6000_init_analog_mode(struct tm6000_core *dev)
>   {
>   	struct v4l2_frequency f;
> @@ -275,7 +213,6 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
>   		tm6000_set_reg_mask(dev, TM6010_REQ07_RC0_ACTIVE_VIDEO_SOURCE,
>   							0x00, 0x40);
>   		tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc);
> -
>   	} else {
>   		/* Enables soft reset */
>   		tm6000_set_reg(dev, TM6010_REQ07_R3F_RESET, 0x01);
> @@ -328,7 +265,6 @@ int tm6000_init_analog_mode(struct tm6000_core *dev)
>
>   	msleep(100);
>   	tm6000_set_standard(dev,&dev->norm);
> -	tm6000_set_vbi(dev);
>   	tm6000_set_audio_bitrate(dev, 48000);
>
>   	/* switch dvb led off */
> @@ -504,12 +440,13 @@ struct reg_init tm6010_init_tab[] = {
>   	{ TM6010_REQ07_R01_VIDEO_CONTROL1, 0x07 },
>   	{ TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f },
>   	{ TM6010_REQ07_R03_YC_SEP_CONTROL, 0x00 },
> -	{ TM6010_REQ07_R05_NOISE_THRESHOLD, 0x64 },
> +	{ TM6010_REQ07_R05_NOISE_THRESHOLD, 0x50 },
>   	{ TM6010_REQ07_R07_OUTPUT_CONTROL, 0x01 },
>   	{ TM6010_REQ07_R08_LUMA_CONTRAST_ADJ, 0x82 },
>   	{ TM6010_REQ07_R09_LUMA_BRIGHTNESS_ADJ, 0x36 },
>   	{ TM6010_REQ07_R0A_CHROMA_SATURATION_ADJ, 0x50 },
>   	{ TM6010_REQ07_R0C_CHROMA_AGC_CONTROL, 0x6a },
> +	{ TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x17},
>   	{ TM6010_REQ07_R11_AGC_PEAK_CONTROL, 0xc9 },
>   	{ TM6010_REQ07_R12_AGC_GATE_STARTH, 0x07 },
>   	{ TM6010_REQ07_R13_AGC_GATE_STARTL, 0x3b },
> @@ -524,8 +461,8 @@ struct reg_init tm6010_init_tab[] = {
>   	{ TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc },
>   	{ TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc },
>   	{ TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd },
> -	{ TM6010_REQ07_R20_HSYNC_RISING_EDGE_TIME, 0x3c },
> -	{ TM6010_REQ07_R21_HSYNC_PHASE_OFFSET, 0x3c },
> +	{ TM6010_REQ07_R20_HSYNC_RISING_EDGE_TIME, 0x3e },
> +	{ TM6010_REQ07_R21_HSYNC_PHASE_OFFSET, 0x3e },
>   	{ TM6010_REQ07_R2D_CHROMA_BURST_END, 0x48 },
>   	{ TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x88 },
>   	{ TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x22 },
> @@ -544,12 +481,18 @@ struct reg_init tm6010_init_tab[] = {
>   	{ TM6010_REQ07_R57_VBI_LOOP_FILTER_P_GAIN, 0x02 },
>   	{ TM6010_REQ07_R58_VBI_CAPTION_DTO1, 0x35 },
>   	{ TM6010_REQ07_R59_VBI_CAPTION_DTO0, 0xa0 },
> +	{ TM6010_REQ07_R5A_VBI_TELETEXT_DTO1, 0x11},
> +	{ TM6010_REQ07_R5B_VBI_TELETEXT_DTO0, 0x4c},
> +	{ TM6010_REQ07_R60_TELETEXT_FRAME_START, 0x52},
> +	{ TM6010_REQ07_R68_VBI_TELETEXT_START, 0x32},
>   	{ TM6010_REQ07_R80_COMB_FILTER_TRESHOLD, 0x15 },
>   	{ TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42 },
> +	{ TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0xa9},
>   	{ TM6010_REQ07_RC1_TRESHOLD, 0xd0 },
>   	{ TM6010_REQ07_RC3_HSTART1, 0x88 },
>   	{ TM6010_REQ07_R3F_RESET, 0x00 },
>
> +	{ TM6010_REQ07_R3F_RESET, 0x00 },
>   	{ TM6010_REQ05_R18_IMASK7, 0x00 },
>
>   	{ TM6010_REQ07_RD8_IR_LEADER1, 0xaa },
> @@ -615,6 +558,38 @@ int tm6000_init(struct tm6000_core *dev)
>   	return rc;
>   }
>
> +void tm6000_init_demdec(struct tm6000_core *dev)
> +{
> +	/* Set GCD2 to autogain */
> +	tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
> +	/* Reduce SIF amplitude */
> +	tm6000_set_reg(dev, TM6010_REQ08_R04_A_SIF_AMP_CTRL, 0x80);
> +	/* Set autodetect threshold */
> +	tm6000_set_reg(dev, TM6010_REQ08_R0C_A_ASD_THRES2, 0x0a);
> +	/* Set auto-dematrix threshold */
> +	tm6000_set_reg(dev, TM6010_REQ08_R0D_A_AMD_THRES, 0x40);
> +	/* Set NICAM error limits max */
> +	tm6000_set_reg(dev, TM6010_REQ08_R1A_A_NICAM_SER_MAX, 0x64);
> +	/* Set NICAM error limits min */
> +	tm6000_set_reg(dev, TM6010_REQ08_R1B_A_NICAM_SER_MIN, 0x20);
> +	/* Set gain max +6dB */
> +	tm6000_set_reg(dev, TM6010_REQ08_R16_A_AGC_GAIN_MAX, 0xfe);
> +	/* Set gain min -6dB */
> +	tm6000_set_reg(dev, TM6010_REQ08_R17_A_AGC_GAIN_MIN, 0x01);
> +	/* Enable ADC (always use) */
> +	tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc);
> +}
> +EXPORT_SYMBOL_GPL(tm6000_init_demdec);
> +
> +void tm6000_reset_demdec(struct tm6000_core *dev)
> +{
> +	/* Set DemDec to IDLE */
> +	tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
> +	/* Set DemDec to Restart */
> +	tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
> +}
> +EXPORT_SYMBOL_GPL(tm6000_reset_demdec);
> +
>   int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate)
>   {
>   	int val = 0;
> @@ -662,11 +637,13 @@ int tm6000_set_audio_input(struct tm6000_core *dev, enum tm6000_inaudio ainp)
>   	if (dev->dev_type == TM6010) {
>   		/* Audio crossbar setting, default SIF1 */
>   		u8 areg_f0 = 0x03;
> +		u8 areg_07 = 0x10;
>
>   		switch (ainp) {
>   		case TM6000_AIP_SIF1:
>   		case TM6000_AIP_SIF2:
>   			areg_f0 = 0x03;
> +			areg_07 = 0x30;
>   			break;
>   		case TM6000_AIP_LINE1:
>   			areg_f0 = 0x00;
> @@ -681,6 +658,10 @@ int tm6000_set_audio_input(struct tm6000_core *dev, enum tm6000_inaudio ainp)
>   		/* Set audio input crossbar */
>   		tm6000_set_reg_mask(dev, TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG,
>   							areg_f0, 0x0f);
> +
> +		/* Mux overflow workaround */
> +		tm6000_set_reg_mask(dev, TM6010_REQ07_R07_OUTPUT_CONTROL,
> +							areg_07, 0xf0);
>   	} else {
>   		/* Audio setting, default LINE1 */
>   		u8 areg_eb = 0x00;
> @@ -802,8 +783,10 @@ void tm6000_set_volume(struct tm6000_core *dev, int vol)
>   	if (dev->radio) {
>   		ainp = dev->aradio;
>   		vol += 8; /* Offset to 0 dB */
> -	} else
> -		ainp = dev->avideo;
> +	} else if (dev->input != TM6000_INPUT_COMPOSITE)
> +			ainp = dev->avideo;
> +		else
> +			ainp = dev->acomposite;
>
>   	switch (ainp) {
>   	case TM6000_AIP_SIF1:
> diff --git a/drivers/staging/tm6000/tm6000-stds.c b/drivers/staging/tm6000/tm6000-stds.c
> index da3e51b..fdb0280 100644
> --- a/drivers/staging/tm6000/tm6000-stds.c
> +++ b/drivers/staging/tm6000/tm6000-stds.c
> @@ -22,12 +22,6 @@
>   #include "tm6000.h"
>   #include "tm6000-regs.h"
>
> -struct tm6000_reg_settings {
> -	unsigned char req;
> -	unsigned char reg;
> -	unsigned char value;
> -};
> -
>   enum tm6000_audio_std {
>   	BG_NICAM,
>   	BTSC,
> @@ -40,909 +34,6 @@ enum tm6000_audio_std {
>   	L_NICAM,
>   };
>
> -struct tm6000_std_tv_settings {
> -	v4l2_std_id id;
> -	enum tm6000_audio_std audio_default_std;
> -
> -	struct tm6000_reg_settings sif[12];
> -	struct tm6000_reg_settings nosif[12];
> -	struct tm6000_reg_settings common[26];
> -};
> -
> -struct tm6000_std_settings {
> -	v4l2_std_id id;
> -	enum tm6000_audio_std audio_default_std;
> -	struct tm6000_reg_settings common[37];
> -};
> -
> -static struct tm6000_std_tv_settings tv_stds[] = {
> -	{
> -		.id = V4L2_STD_PAL_M,
> -		.audio_default_std = BTSC,
> -		.sif = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x08},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x62},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfe},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0xcb},
> -			{0, 0, 0},
> -		},
> -		.nosif = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x60},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
> -			{0, 0, 0},
> -		},
> -		.common = {
> -			{TM6010_REQ07_R3F_RESET, 0x01},
> -			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x04},
> -			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
> -			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
> -			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x00},
> -			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
> -			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x1e},
> -			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x83},
> -			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0x0a},
> -			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xe0},
> -			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
> -			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
> -			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
> -			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
> -			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x88},
> -			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x20},
> -			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0x61},
> -			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x0c},
> -			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
> -			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x52},
> -			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
> -
> -			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
> -			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
> -
> -			{TM6010_REQ07_R3F_RESET, 0x00},
> -
> -			{0, 0, 0},
> -		},
> -	}, {
> -		.id = V4L2_STD_PAL_Nc,
> -		.audio_default_std = BTSC,
> -		.sif = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x08},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x62},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfe},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0xcb},
> -			{0, 0, 0},
> -		},
> -		.nosif = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x60},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
> -			{0, 0, 0},
> -		},
> -		.common = {
> -			{TM6010_REQ07_R3F_RESET, 0x01},
> -			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x36},
> -			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
> -			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
> -			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x02},
> -			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
> -			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x1e},
> -			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x91},
> -			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0x1f},
> -			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0x0c},
> -			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
> -			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
> -			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
> -			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
> -			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
> -			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2c},
> -			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
> -			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x0c},
> -			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
> -			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x52},
> -			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
> -
> -			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
> -			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
> -
> -			{TM6010_REQ07_R3F_RESET, 0x00},
> -
> -			{0, 0, 0},
> -		},
> -	}, {
> -		.id = V4L2_STD_PAL,
> -		.audio_default_std = BG_A2,
> -		.sif = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x08},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x62},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfe},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0xcb},
> -			{0, 0, 0}
> -		},
> -		.nosif = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x60},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
> -			{0, 0, 0},
> -		},
> -		.common = {
> -			{TM6010_REQ07_R3F_RESET, 0x01},
> -			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x32},
> -			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
> -			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
> -			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x02},
> -			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
> -			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x25},
> -			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0xd5},
> -			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0x63},
> -			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0x50},
> -			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
> -			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
> -			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
> -			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
> -			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
> -			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2c},
> -			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
> -			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x0c},
> -			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
> -			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x52},
> -			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
> -
> -			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
> -			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
> -
> -			{TM6010_REQ07_R3F_RESET, 0x00},
> -
> -			{0, 0, 0},
> -		},
> -	}, {
> -		.id = V4L2_STD_SECAM_B | V4L2_STD_SECAM_G,
> -		.audio_default_std = BG_NICAM,
> -		.sif = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x08},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x62},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfe},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0xcb},
> -			{0, 0, 0},
> -		},
> -		.nosif = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x60},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
> -			{0, 0, 0},
> -		},
> -		.common = {
> -			{TM6010_REQ07_R3F_RESET, 0x01},
> -			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x38},
> -			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
> -			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
> -			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x02},
> -			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
> -			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x24},
> -			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x92},
> -			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0xe8},
> -			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xed},
> -			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
> -			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
> -			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
> -			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
> -			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
> -			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2c},
> -			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
> -			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x2c},
> -			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x18},
> -			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
> -			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0xFF},
> -
> -			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
> -
> -			{TM6010_REQ07_R3F_RESET, 0x00},
> -			{0, 0, 0},
> -		},
> -	}, {
> -		.id = V4L2_STD_SECAM_DK,
> -		.audio_default_std = DK_NICAM,
> -		.sif = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x08},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x62},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfe},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0xcb},
> -			{0, 0, 0},
> -		},
> -		.nosif = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x60},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
> -			{0, 0, 0},
> -		},
> -		.common = {
> -			{TM6010_REQ07_R3F_RESET, 0x01},
> -			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x38},
> -			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
> -			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
> -			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x02},
> -			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
> -			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x24},
> -			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x92},
> -			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0xe8},
> -			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xed},
> -			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
> -			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
> -			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
> -			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
> -			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
> -			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2c},
> -			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
> -			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x2c},
> -			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x18},
> -			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
> -			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0xFF},
> -
> -			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
> -
> -			{TM6010_REQ07_R3F_RESET, 0x00},
> -			{0, 0, 0},
> -		},
> -	}, {
> -		.id = V4L2_STD_NTSC,
> -		.audio_default_std = BTSC,
> -		.sif = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x08},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x62},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfe},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0xcb},
> -			{0, 0, 0},
> -		},
> -		.nosif = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x60},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
> -			{0, 0, 0},
> -		},
> -		.common = {
> -			{TM6010_REQ07_R3F_RESET, 0x01},
> -			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x00},
> -			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0f},
> -			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
> -			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x00},
> -			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
> -			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x1e},
> -			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x8b},
> -			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0xa2},
> -			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xe9},
> -			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
> -			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
> -			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
> -			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
> -			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x88},
> -			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x22},
> -			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0x61},
> -			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x1c},
> -			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
> -			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
> -			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
> -
> -			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdd},
> -			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
> -
> -			{TM6010_REQ07_R3F_RESET, 0x00},
> -
> -			{0, 0, 0},
> -		},
> -	},
> -};
> -
> -static struct tm6000_std_settings composite_stds[] = {
> -	{
> -		.id = V4L2_STD_PAL_M,
> -		.audio_default_std = BTSC,
> -		.common = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
> -
> -			{TM6010_REQ07_R3F_RESET, 0x01},
> -			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x04},
> -			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
> -			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
> -			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x00},
> -			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
> -			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x1e},
> -			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x83},
> -			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0x0a},
> -			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xe0},
> -			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
> -			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
> -			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
> -			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
> -			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x88},
> -			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x20},
> -			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0x61},
> -			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x0c},
> -			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
> -			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x52},
> -			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
> -
> -			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
> -			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
> -			{TM6010_REQ07_R3F_RESET, 0x00},
> -			{0, 0, 0},
> -		},
> -	 }, {
> -		.id = V4L2_STD_PAL_Nc,
> -		.audio_default_std = BTSC,
> -		.common = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
> -
> -			{TM6010_REQ07_R3F_RESET, 0x01},
> -			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x36},
> -			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
> -			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
> -			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x02},
> -			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
> -			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x1e},
> -			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x91},
> -			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0x1f},
> -			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0x0c},
> -			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
> -			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
> -			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
> -			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
> -			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
> -			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2c},
> -			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
> -			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x0c},
> -			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
> -			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x52},
> -			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
> -
> -			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
> -			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
> -			{TM6010_REQ07_R3F_RESET, 0x00},
> -			{0, 0, 0},
> -		},
> -	}, {
> -		.id = V4L2_STD_PAL,
> -		.audio_default_std = BG_A2,
> -		.common = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
> -
> -			{TM6010_REQ07_R3F_RESET, 0x01},
> -			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x32},
> -			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
> -			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
> -			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x02},
> -			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
> -			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x25},
> -			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0xd5},
> -			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0x63},
> -			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0x50},
> -			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
> -			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
> -			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
> -			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
> -			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
> -			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2c},
> -			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
> -			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x0c},
> -			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
> -			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x52},
> -			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
> -
> -			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
> -			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
> -			{TM6010_REQ07_R3F_RESET, 0x00},
> -			{0, 0, 0},
> -		},
> -	 }, {
> -		.id = V4L2_STD_SECAM,
> -		.audio_default_std = BG_NICAM,
> -		.common = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
> -
> -			{TM6010_REQ07_R3F_RESET, 0x01},
> -			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x38},
> -			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
> -			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
> -			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x02},
> -			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
> -			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x24},
> -			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x92},
> -			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0xe8},
> -			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xed},
> -			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
> -			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
> -			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
> -			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
> -			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
> -			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2c},
> -			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
> -			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x2c},
> -			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x18},
> -			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
> -			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0xFF},
> -
> -			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
> -			{TM6010_REQ07_R3F_RESET, 0x00},
> -			{0, 0, 0},
> -		},
> -	}, {
> -		.id = V4L2_STD_SECAM_DK,
> -		.audio_default_std = DK_NICAM,
> -		.common = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
> -
> -			{TM6010_REQ07_R3F_RESET, 0x01},
> -			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x38},
> -			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
> -			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
> -			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x02},
> -			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
> -			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x24},
> -			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x92},
> -			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0xe8},
> -			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xed},
> -			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
> -			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
> -			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
> -			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
> -			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
> -			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2c},
> -			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
> -			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x2c},
> -			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x18},
> -			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
> -			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0xFF},
> -
> -			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
> -			{TM6010_REQ07_R3F_RESET, 0x00},
> -			{0, 0, 0},
> -		},
> -	}, {
> -		.id = V4L2_STD_NTSC,
> -		.audio_default_std = BTSC,
> -		.common = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf1},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe8},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0x8b},
> -
> -			{TM6010_REQ07_R3F_RESET, 0x01},
> -			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x00},
> -			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0f},
> -			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
> -			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x00},
> -			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
> -			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x1e},
> -			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x8b},
> -			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0xa2},
> -			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xe9},
> -			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
> -			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
> -			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
> -			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
> -			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x88},
> -			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x22},
> -			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0x61},
> -			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x1c},
> -			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
> -			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
> -			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
> -
> -			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdd},
> -			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
> -			{TM6010_REQ07_R3F_RESET, 0x00},
> -			{0, 0, 0},
> -		},
> -	},
> -};
> -
> -static struct tm6000_std_settings svideo_stds[] = {
> -	{
> -		.id = V4L2_STD_PAL_M,
> -		.audio_default_std = BTSC,
> -		.common = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf8},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x00},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf2},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe0},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0x8a},
> -
> -			{TM6010_REQ07_R3F_RESET, 0x01},
> -			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x05},
> -			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
> -			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
> -			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x04},
> -			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
> -			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x1e},
> -			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x83},
> -			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0x0a},
> -			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xe0},
> -			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
> -			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
> -			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
> -			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
> -			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x88},
> -			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x22},
> -			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0x61},
> -			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x0c},
> -			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
> -			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x52},
> -			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
> -
> -			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
> -			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
> -			{TM6010_REQ07_R3F_RESET, 0x00},
> -			{0, 0, 0},
> -		},
> -	}, {
> -		.id = V4L2_STD_PAL_Nc,
> -		.audio_default_std = BTSC,
> -		.common = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf8},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x00},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf2},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe0},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0x8a},
> -
> -			{TM6010_REQ07_R3F_RESET, 0x01},
> -			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x37},
> -			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
> -			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
> -			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x04},
> -			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
> -			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x1e},
> -			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x91},
> -			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0x1f},
> -			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0x0c},
> -			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
> -			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
> -			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
> -			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
> -			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x88},
> -			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x22},
> -			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
> -			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x0c},
> -			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
> -			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x52},
> -			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
> -
> -			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
> -			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
> -			{TM6010_REQ07_R3F_RESET, 0x00},
> -			{0, 0, 0},
> -		},
> -	}, {
> -		.id = V4L2_STD_PAL,
> -		.audio_default_std = BG_A2,
> -		.common = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf8},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x00},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf2},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe0},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0x8a},
> -
> -			{TM6010_REQ07_R3F_RESET, 0x01},
> -			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x33},
> -			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
> -			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
> -			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x04},
> -			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x30},
> -			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x25},
> -			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0xd5},
> -			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0x63},
> -			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0x50},
> -			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
> -			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
> -			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
> -			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
> -			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
> -			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2a},
> -			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
> -			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x0c},
> -			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
> -			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x52},
> -			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
> -
> -			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdc},
> -			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
> -			{TM6010_REQ07_R3F_RESET, 0x00},
> -			{0, 0, 0},
> -		},
> -	 }, {
> -		.id = V4L2_STD_SECAM,
> -		.audio_default_std = BG_NICAM,
> -		.common = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf8},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x00},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf2},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe0},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0x8a},
> -
> -			{TM6010_REQ07_R3F_RESET, 0x01},
> -			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x39},
> -			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
> -			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
> -			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x03},
> -			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
> -			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x24},
> -			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x92},
> -			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0xe8},
> -			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xed},
> -			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
> -			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
> -			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
> -			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
> -			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
> -			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2a},
> -			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
> -			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x2c},
> -			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x18},
> -			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
> -			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0xFF},
> -
> -			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
> -			{TM6010_REQ07_R3F_RESET, 0x00},
> -			{0, 0, 0},
> -		},
> -	}, {
> -		.id = V4L2_STD_SECAM_DK,
> -		.audio_default_std = DK_NICAM,
> -		.common = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf8},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x00},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf2},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe0},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0x8a},
> -
> -			{TM6010_REQ07_R3F_RESET, 0x01},
> -			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x39},
> -			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0e},
> -			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
> -			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x03},
> -			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x31},
> -			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x24},
> -			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x92},
> -			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0xe8},
> -			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xed},
> -			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
> -			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
> -			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
> -			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
> -			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x8c},
> -			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x2a},
> -			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0xc1},
> -			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x2c},
> -			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x18},
> -			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
> -			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0xFF},
> -
> -			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
> -			{TM6010_REQ07_R3F_RESET, 0x00},
> -			{0, 0, 0},
> -		},
> -	}, {
> -		.id = V4L2_STD_NTSC,
> -		.audio_default_std = BTSC,
> -		.common = {
> -			{TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0},
> -			{TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc},
> -			{TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf8},
> -			{TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x00},
> -			{TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf2},
> -			{TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0},
> -			{TM6010_REQ08_REC_REVERSE_YC_CTRL, 0xc2},
> -			{TM6010_REQ08_RED_GAIN_SEL, 0xe0},
> -			{TM6010_REQ08_RF0_DAUDIO_INPUT_CONFIG, 0x68},
> -			{TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc},
> -			{TM6010_REQ07_RFE_POWER_DOWN, 0x8a},
> -
> -			{TM6010_REQ07_R3F_RESET, 0x01},
> -			{TM6010_REQ07_R00_VIDEO_CONTROL0, 0x01},
> -			{TM6010_REQ07_R01_VIDEO_CONTROL1, 0x0f},
> -			{TM6010_REQ07_R02_VIDEO_CONTROL2, 0x5f},
> -			{TM6010_REQ07_R03_YC_SEP_CONTROL, 0x03},
> -			{TM6010_REQ07_R07_OUTPUT_CONTROL, 0x30},
> -			{TM6010_REQ07_R17_HLOOP_MAXSTATE, 0x8b},
> -			{TM6010_REQ07_R18_CHROMA_DTO_INCREMENT3, 0x1e},
> -			{TM6010_REQ07_R19_CHROMA_DTO_INCREMENT2, 0x8b},
> -			{TM6010_REQ07_R1A_CHROMA_DTO_INCREMENT1, 0xa2},
> -			{TM6010_REQ07_R1B_CHROMA_DTO_INCREMENT0, 0xe9},
> -			{TM6010_REQ07_R1C_HSYNC_DTO_INCREMENT3, 0x1c},
> -			{TM6010_REQ07_R1D_HSYNC_DTO_INCREMENT2, 0xcc},
> -			{TM6010_REQ07_R1E_HSYNC_DTO_INCREMENT1, 0xcc},
> -			{TM6010_REQ07_R1F_HSYNC_DTO_INCREMENT0, 0xcd},
> -			{TM6010_REQ07_R2E_ACTIVE_VIDEO_HSTART, 0x88},
> -			{TM6010_REQ07_R30_ACTIVE_VIDEO_VSTART, 0x22},
> -			{TM6010_REQ07_R31_ACTIVE_VIDEO_VHIGHT, 0x61},
> -			{TM6010_REQ07_R33_VSYNC_HLOCK_MAX, 0x1c},
> -			{TM6010_REQ07_R35_VSYNC_AGC_MAX, 0x1c},
> -			{TM6010_REQ07_R82_COMB_FILTER_CONFIG, 0x42},
> -			{TM6010_REQ07_R83_CHROMA_LOCK_CONFIG, 0x6F},
> -
> -			{TM6010_REQ07_R04_LUMA_HAGC_CONTROL, 0xdd},
> -			{TM6010_REQ07_R0D_CHROMA_KILL_LEVEL, 0x07},
> -			{TM6010_REQ07_R3F_RESET, 0x00},
> -			{0, 0, 0},
> -		},
> -	},
> -};
> -
> -
>   static int tm6000_set_audio_std(struct tm6000_core *dev,
>   				enum tm6000_audio_std std)
>   {
> @@ -952,22 +43,6 @@ static int tm6000_set_audio_std(struct tm6000_core *dev,
>   	uint8_t mono_flag = 0;  /* No mono */
>   	uint8_t nicam_flag = 0; /* No NICAM */
>
> -	if (dev->radio) {
> -		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
> -		tm6000_set_reg(dev, TM6010_REQ08_R02_A_FIX_GAIN_CTRL, 0x04);
> -		tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
> -		tm6000_set_reg(dev, TM6010_REQ08_R04_A_SIF_AMP_CTRL, 0x80);
> -		tm6000_set_reg(dev, TM6010_REQ08_R05_A_STANDARD_MOD, 0x0c);
> -		tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x00);
> -		tm6000_set_reg(dev, TM6010_REQ08_R09_A_MAIN_VOL, 0x18);
> -		tm6000_set_reg(dev, TM6010_REQ08_R0C_A_ASD_THRES2, 0x0a);
> -		tm6000_set_reg(dev, TM6010_REQ08_R0D_A_AMD_THRES, 0x40);
> -		tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc);
> -		tm6000_set_reg(dev, TM6010_REQ08_R1E_A_GAIN_DEEMPH_OUT, 0x13);
> -		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
> -		return 0;
> -	}
> -
>   	switch (std) {
>   #if 0
>   	case DK_MONO:
> @@ -1012,6 +87,21 @@ static int tm6000_set_audio_std(struct tm6000_core *dev,
>   		areg_05 = 0x0a;
>   		nicam_flag = 1;
>   		break;
> +	case FM_RADIO:
> +		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
> +		tm6000_set_reg(dev, TM6010_REQ08_R02_A_FIX_GAIN_CTRL, 0x04);
> +		tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
> +		tm6000_set_reg(dev, TM6010_REQ08_R04_A_SIF_AMP_CTRL, 0x80);
> +		tm6000_set_reg(dev, TM6010_REQ08_R05_A_STANDARD_MOD, 0x0c);
> +		tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x00);
> +		tm6000_set_reg(dev, TM6010_REQ08_R09_A_MAIN_VOL, 0x18);
> +		tm6000_set_reg(dev, TM6010_REQ08_R0C_A_ASD_THRES2, 0x0a);
> +		tm6000_set_reg(dev, TM6010_REQ08_R0D_A_AMD_THRES, 0x40);
> +		tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc);
> +		tm6000_set_reg(dev, TM6010_REQ08_R1E_A_GAIN_DEEMPH_OUT, 0x13);
> +		tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
> +		return 0;
> +		break;
>   	default:
>   		/* do nothink */
>   		break;
> @@ -1036,39 +126,10 @@ static int tm6000_set_audio_std(struct tm6000_core *dev,
>
>   	tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x00);
>   	tm6000_set_reg(dev, TM6010_REQ08_R02_A_FIX_GAIN_CTRL, areg_02);
> -	tm6000_set_reg(dev, TM6010_REQ08_R03_A_AUTO_GAIN_CTRL, 0x00);
> -	tm6000_set_reg(dev, TM6010_REQ08_R04_A_SIF_AMP_CTRL, 0xa0);
>   	tm6000_set_reg(dev, TM6010_REQ08_R05_A_STANDARD_MOD, areg_05);
>   	tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, areg_06);
> -	tm6000_set_reg(dev, TM6010_REQ08_R07_A_LEFT_VOL, 0x00);
> -	tm6000_set_reg(dev, TM6010_REQ08_R08_A_RIGHT_VOL, 0x00);
>   	tm6000_set_reg(dev, TM6010_REQ08_R09_A_MAIN_VOL, 0x08);
> -	tm6000_set_reg(dev, TM6010_REQ08_R0A_A_I2S_MOD, 0x91);
> -	tm6000_set_reg(dev, TM6010_REQ08_R0B_A_ASD_THRES1, 0x20);
> -	tm6000_set_reg(dev, TM6010_REQ08_R0C_A_ASD_THRES2, 0x12);
> -	tm6000_set_reg(dev, TM6010_REQ08_R0D_A_AMD_THRES, 0x20);
> -	tm6000_set_reg(dev, TM6010_REQ08_R0E_A_MONO_THRES1, 0xf0);
> -	tm6000_set_reg(dev, TM6010_REQ08_R0F_A_MONO_THRES2, 0x80);
> -	tm6000_set_reg(dev, TM6010_REQ08_R10_A_MUTE_THRES1, 0xc0);
> -	tm6000_set_reg(dev, TM6010_REQ08_R11_A_MUTE_THRES2, 0x80);
> -	tm6000_set_reg(dev, TM6010_REQ08_R12_A_AGC_U, 0x12);
> -	tm6000_set_reg(dev, TM6010_REQ08_R13_A_AGC_ERR_T, 0xfe);
> -	tm6000_set_reg(dev, TM6010_REQ08_R14_A_AGC_GAIN_INIT, 0x20);
> -	tm6000_set_reg(dev, TM6010_REQ08_R15_A_AGC_STEP_THR, 0x14);
> -	tm6000_set_reg(dev, TM6010_REQ08_R16_A_AGC_GAIN_MAX, 0xfe);
> -	tm6000_set_reg(dev, TM6010_REQ08_R17_A_AGC_GAIN_MIN, 0x01);
> -	tm6000_set_reg(dev, TM6010_REQ08_R18_A_TR_CTRL, 0xa0);
> -	tm6000_set_reg(dev, TM6010_REQ08_R19_A_FH_2FH_GAIN, 0x32);
> -	tm6000_set_reg(dev, TM6010_REQ08_R1A_A_NICAM_SER_MAX, 0x64);
> -	tm6000_set_reg(dev, TM6010_REQ08_R1B_A_NICAM_SER_MIN, 0x20);
> -	tm6000_set_reg(dev, REQ_08_SET_GET_AVREG_BIT, 0x1c, 0x00);
> -	tm6000_set_reg(dev, REQ_08_SET_GET_AVREG_BIT, 0x1d, 0x00);
>   	tm6000_set_reg(dev, TM6010_REQ08_R1E_A_GAIN_DEEMPH_OUT, 0x13);
> -	tm6000_set_reg(dev, TM6010_REQ08_R1F_A_TEST_INTF_SEL, 0x00);
> -	tm6000_set_reg(dev, TM6010_REQ08_R20_A_TEST_PIN_SEL, 0x00);
> -	tm6000_set_reg(dev, TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf3);
> -	tm6000_set_reg(dev, TM6010_REQ08_R06_A_SOUND_MOD, 0x00);
> -	tm6000_set_reg(dev, TM6010_REQ08_RF1_AADC_POWER_DOWN, 0xfc);
>   	tm6000_set_reg(dev, TM6010_REQ08_R01_A_INIT, 0x80);
>
>   	return 0;
> @@ -1085,106 +146,419 @@ void tm6000_get_std_res(struct tm6000_core *dev)
>   	dev->width = 720;
>   }
>
> -static int tm6000_load_std(struct tm6000_core *dev,
> -			   struct tm6000_reg_settings *set, int max_size)
> +int tm6000_config_video_input(struct tm6000_core *dev)
>   {
> -	int i, rc;
> -
> -	/* Load board's initialization table */
> -	for (i = 0; max_size; i++) {
> -		if (!set[i].req)
> -			return 0;
> -
> -		if ((dev->dev_type != TM6010)&&
> -		    (set[i].req == REQ_08_SET_GET_AVREG_BIT))
> -				continue;
> -
> -		rc = tm6000_set_reg(dev, set[i].req, set[i].reg, set[i].value);
> -		if (rc<  0) {
> -			printk(KERN_ERR "Error %i while setting "
> -			       "req %d, reg %d to value %d\n",
> -			       rc, set[i].req, set[i].reg, set[i].value);
> -			return rc;
> -		}
> +	switch (dev->input) {
> +	case TM6000_INPUT_TV:
> +		/* Enable ADC2 (without clamp?) */
> +		tm6000_set_reg(dev, TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x08);
> +		/* Power Up CLAMP, LPF BW = SIF mode */
> +		tm6000_set_reg(dev, TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf2);
> +		/* Set ADC1 input = CVBS1 */
> +		tm6000_set_reg(dev, TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf8);
> +		/* Set ADC2 input = SIF1 or SIF2 */
> +		tm6000_set_reg(dev, TM6010_REQ08_RE4_ADC_IN2_SEL,
> +				(dev->avideo == TM6000_AIP_SIF1) ? 0xf7 : 0xf3);
> +		/* Clamping level control in ADC2 = SIF signal */
> +		tm6000_set_reg(dev, TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf6);
> +		/* SIF gain control enable signal = SIF signal */
> +		tm6000_set_reg(dev, TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xe0);
> +		/* GAIN selection = Y and SIF */
> +		tm6000_set_reg(dev, TM6010_REQ08_RED_GAIN_SEL, 0xe8);
> +		break;
> +	case TM6000_INPUT_SVIDEO:
> +		/* Enable ADC2 */
> +		tm6000_set_reg(dev, TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x00);
> +		/* Power Up CLAMP, LPF BW<>  SIF mode */
> +		tm6000_set_reg(dev, TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0);
> +		/* Set ADC1 input = Y */
> +		tm6000_set_reg(dev, TM6010_REQ08_RE3_ADC_IN1_SEL, 0xfc);
> +		/* Set ADC2 input = C */
> +		tm6000_set_reg(dev, TM6010_REQ08_RE4_ADC_IN2_SEL, 0xf8);
> +		/* Clamping level control in ADC2 = C signal */
> +		tm6000_set_reg(dev, TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf2);
> +		/* SIF gain control enable signal = C signal */
> +		tm6000_set_reg(dev, TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0);
> +		/* GAIN selection = Y and C */
> +		tm6000_set_reg(dev, TM6010_REQ08_RED_GAIN_SEL, 0xe0);
> +		break;
> +	case TM6000_INPUT_COMPOSITE:
> +		/* Set ADC1 input = CVBS2 */
> +		tm6000_set_reg(dev, TM6010_REQ08_RE3_ADC_IN1_SEL, 0xf4);
> +		/* Power Up CLAMP, LPF BW<>  SIF mode */
> +		tm6000_set_reg(dev, TM6010_REQ08_RE2_POWER_DOWN_CTRL1, 0xf0);
> +		/* Set ADC2 input = none */
> +		tm6000_set_reg(dev, TM6010_REQ08_RE4_ADC_IN2_SEL, 0xfc);
> +		/* Disable ADC2 */
> +		tm6000_set_reg(dev, TM6010_REQ08_RE6_POWER_DOWN_CTRL2, 0x0f);
> +		/* Clamping level control in ADC2 = C signal */
> +		tm6000_set_reg(dev, TM6010_REQ08_REA_BUFF_DRV_CTRL, 0xf2);
> +		/* SIF gain control enable signal = C signal */
> +		tm6000_set_reg(dev, TM6010_REQ08_REB_SIF_GAIN_CTRL, 0xf0);
> +		/* GAIN selection = Y and C */
> +		tm6000_set_reg(dev, TM6010_REQ08_RED_GAIN_SEL, 0xe0);
> +		/* Set audio input */
> +		tm6000_set_audio_input(dev, dev->acomposite);
> +		tm6000_set_volume(dev, dev->ctl_volume);
> +		break;
> +	default:
> +		printk(KERN_ERR "Error video input source - %d\n", dev->input);
> +		return -EINVAL;
> +		break;
>   	}
>
>   	return 0;
>   }
>
> -static int tm6000_set_tv(struct tm6000_core *dev, int pos)
> +int tm6000_config_video_std(struct tm6000_core *dev, v4l2_std_id *norm)
>   {
> -	int rc;
> +	int rc = 0;
> +	uint8_t k;
> +	uint8_t areg_D5 = 0x4f;
> +	uint16_t tm_regs[0x90];
> +	bool pal_fl = true;
> +	bool f50hz_fl = true;
> +
> +	memset(tm_regs, 0xffff, sizeof(tm_regs));
> +
> +	dev->norm = *norm;
> +	tm6000_get_std_res(dev);
>
> -	/* FIXME: This code is for tm6010 - not tested yet - doesn't work with
> -	   tm5600
> -	 */
> +	/* Chroma AGC target */
> +	tm_regs[0x0c] = 0x6a;
> +	/* HSYNC rising-edge occurrence time */
> +	tm_regs[0x20] = 0x3e;
> +	/* backporch start/end */
> +	tm_regs[0x28] = 0x22;
> +	tm_regs[0x29] = 0x4e;
> +	/* Chroma burst start/end */
> +	tm_regs[0x2c] = 0x2c;
> +	tm_regs[0x2d] = 0x48;
> +	/* VSYNC H lockout start/end */
> +	tm_regs[0x32] = 0x74;
> +	tm_regs[0x33] = 0x0c;
> +	/* VSYNC AGC lockout start/end */
> +	tm_regs[0x34] = 0x74;
> +	tm_regs[0x35] = 0x1c;
> +	/* Comb filter config (PAL off) */
> +	tm_regs[0x82] = 0x42;
> +
> +	switch (*norm) {
> +	case V4L2_STD_SECAM:
> +	case V4L2_STD_SECAM_B:
> +	case V4L2_STD_SECAM_G:
> +	case V4L2_STD_SECAM_DK:
> +		/* SECAM */
> +		tm_regs[0x00] = 0x08;
> +		tm_regs[0x01] = 0x02;
> +		/* Full 2-D adaptive comb */
> +		tm_regs[0x03] = 0x00;
> +		/* HAGC = 220 */
> +		tm_regs[0x04] = 0xdc;
> +		/* DTO = 17.144 */
> +		tm_regs[0x18] = 0x24;
> +		tm_regs[0x19] = 0x92;
> +		tm_regs[0x1a] = 0xe8;
> +		tm_regs[0x1b] = 0xed;
> +		/* backporch start/end */
> +		tm_regs[0x28] = 0x42;
> +		tm_regs[0x29] = 0x62;
> +		/* Chroma burst start/end */
> +		tm_regs[0x2c] = 0x44;
> +		tm_regs[0x2d] = 0x60;
> +		/* VSYNC H lockout start/end */
> +		tm_regs[0x32] = 0x74;
> +		tm_regs[0x33] = 0x2c;
> +		/* VSYNC AGC lockout start/end */
> +		tm_regs[0x34] = 0x74;
> +		tm_regs[0x35] = 0x18;
> +		pal_fl = false;
> +		break;
> +	case V4L2_STD_PAL:
> +		/* PAL */
> +		tm_regs[0x00] = 0x02;
> +		tm_regs[0x01] = 0x02;
> +		/* PAL fix (basic luma notch comb filter) */
> +		tm_regs[0x03] = 0x03;
> +		/* HAGC = 220 */
> +		tm_regs[0x04] = 0xdc;
> +		/* DTO = 17.734475 */
> +		tm_regs[0x18] = 0x25;
> +		tm_regs[0x19] = 0xD5;
> +		tm_regs[0x1a] = 0x63;
> +		tm_regs[0x1b] = 0x50;
> +		break;
> +	case V4L2_STD_PAL_N:
> +	case V4L2_STD_PAL_M:
> +		/* PAL MN */
> +		tm_regs[0x00] = 0x04;
> +		tm_regs[0x01] = 0x02;
> +		/* PAL fix (basic luma notch comb filter) */
> +		tm_regs[0x03] = 0x03;
> +		/* HAGC = 221 */
> +		tm_regs[0x04] = 0xdd;
> +		/* DTO = 17.734475 */
> +		tm_regs[0x18] = 0x25;
> +		tm_regs[0x19] = 0xD5;
> +		tm_regs[0x1a] = 0x63;
> +		tm_regs[0x1b] = 0x50;
> +		break;
> +	case V4L2_STD_PAL_Nc:
> +		/* PAL Nc */
> +		tm_regs[0x00] = 0x06;
> +		tm_regs[0x01] = 0x02;
> +		/* PAL fix (basic luma notch comb filter) */
> +		tm_regs[0x03] = 0x03;
> +		/* HAGC = 220 */
> +		tm_regs[0x04] = 0xdc;
> +		/* DTO = 14.328225 */
> +		tm_regs[0x18] = 0x1e;
> +		tm_regs[0x19] = 0x91;
> +		tm_regs[0x1a] = 0x1f;
> +		tm_regs[0x1b] = 0x0c;
> +		break;
> +	case V4L2_STD_PAL_60:
> +		/* PAL */
> +		tm_regs[0x00] = 0x02;
> +		tm_regs[0x01] = 0x02;
> +		/* PAL fix (basic luma notch comb filter) */
> +		tm_regs[0x03] = 0x03;
> +		/* HAGC = 220 */
> +		tm_regs[0x04] = 0xdc;
> +		/* DTO = 17.734475 */
> +		tm_regs[0x18] = 0x25;
> +		tm_regs[0x19] = 0xd5;
> +		tm_regs[0x1a] = 0x63;
> +		tm_regs[0x1b] = 0x50;
> +		/* HSYNC rising-edge occurrence time */
> +		tm_regs[0x20] = 0x4c;
> +		f50hz_fl = false;
> +		break;
> +	case V4L2_STD_NTSC_M:
> +	case V4L2_STD_NTSC_M_JP:
> +	case V4L2_STD_NTSC_M_KR:
> +		/* NTSC */
> +		tm_regs[0x00] = 0x00;
> +		/* Ped = 1 */
> +		tm_regs[0x01] = 0x03;
> +		/* Full 2-D adaptive comb */
> +		tm_regs[0x03] = 0x00;
> +		/* HAGC = 221 */
> +		tm_regs[0x04] = 0xdd;
> +		/* Chroma AGC target */
> +		tm_regs[0x0c] = 0x8a;
> +		/* DTO = 14.31818182 */
> +		tm_regs[0x18] = 0x1e;
> +		tm_regs[0x19] = 0x8b;
> +		tm_regs[0x1a] = 0xa2;
> +		tm_regs[0x1b] = 0xe9;
> +		tm_regs[0x33] = 0x1c;
> +		f50hz_fl = false;
> +		pal_fl = false;
> +		if (*norm == V4L2_STD_NTSC_M_JP) {
> +			/* Ped = 0*/
> +			tm_regs[0x01] = 0x02;
> +			/* HAGC  205 */
> +			tm_regs[0x04] = 0xcd;
> +		}
> +		break;
> +	case V4L2_STD_NTSC_443:
> +		/* NTSC */
> +		tm_regs[0x00] = 0x00;
> +		/* Ped = 1 */
> +		tm_regs[0x01] = 0x03;
> +		/* Full 2-D adaptive comb */
> +		tm_regs[0x03] = 0x00;
> +		/* HAGC = 221 */
> +		tm_regs[0x04] = 0xdd;
> +		/* Chroma AGC target */
> +		tm_regs[0x0c] = 0x8a;
> +		/* DTO = 17.734475 */
> +		tm_regs[0x18] = 0x25;
> +		tm_regs[0x19] = 0xd5;
> +		tm_regs[0x1a] = 0x63;
> +		tm_regs[0x1b] = 0x50;
> +		tm_regs[0x33] = 0x1c;
> +		pal_fl = false;
> +		break;
> +	}
>
> -	/* FIXME: This is tuner-dependent */
> -	int nosif = 0;
> +	if (pal_fl) {
> +		/* UV_FLT_EN = 1 */
> +		areg_D5 |= 0x10;
> +		/* comb_wide_band = 1 */
> +		tm_regs[0x82] |= 0x10;
> +	}
>
> -	if (nosif) {
> -		rc = tm6000_load_std(dev, tv_stds[pos].nosif,
> -				     sizeof(tv_stds[pos].nosif));
> +	if (f50hz_fl) {
> +		/* vline_625 = 1, hpixel = 864 */
> +		tm_regs[0x00] |= 0x30;
> +		/* hactive_start = 138 */
> +		tm_regs[0x2e] = 0x8a;
> +		/* vactive_start = 42 */
> +		tm_regs[0x30] = 0x2a;
> +		/* vactive_hight = 171 */
> +		tm_regs[0x31] = 0xc1;
> +		/* VBI FRAME CODE */
> +		tm_regs[0x41] = 0x27;
> +		/* data high level */
> +		tm_regs[0x42] = 0x5e;
> +		/* vbil7 */
> +		tm_regs[0x43] = 0x66;
> +		/* vbil8 */
> +		tm_regs[0x44] = 0x66;
> +		/* vbil9 */
> +		tm_regs[0x45] = 0x66;
> +		/* vbil10 */
> +		tm_regs[0x46] = 0x66;
> +		/* vbil11 */
> +		tm_regs[0x47] = 0x66;
> +		/* vbil12 */
> +		tm_regs[0x48] = 0x66;
> +		/* vbil13 */
> +		tm_regs[0x49] = 0x66;
> +		/* vbil14 */
> +		tm_regs[0x4a] = 0x66;
> +		/* vbil15 */
> +		tm_regs[0x4b] = 0x66;
> +		/* vbil16 */
> +		tm_regs[0x4c] = 0x66;
> +		/* vbil17 */
> +		tm_regs[0x4d] = 0x66;
> +		/* vbil18 */
> +		tm_regs[0x4e] = 0x66;
> +		/* vbil19 */
> +		tm_regs[0x4f] = 0x66;
> +		/* vbil20 */
> +		tm_regs[0x50] = 0x66;
> +		/* vbil21 */
> +		tm_regs[0x51] = 0x66;
> +		/* vbil22 */
> +		tm_regs[0x52] = 0x66;
> +		/* vbil23 = WSS */
> +		tm_regs[0x53] = 0x00;
> +		/* vbil24 */
> +		tm_regs[0x54] = 0x00;
>   	} else {
> -		rc = tm6000_load_std(dev, tv_stds[pos].sif,
> -				     sizeof(tv_stds[pos].sif));
> +		/* vline_625 = 0, hpixel = 858 */
> +		tm_regs[0x00]&= 0xcf;
> +		/* hactive_start = 134 */
> +		tm_regs[0x2e] = 0x86;
> +		/* vactive_start = 34 */
> +		tm_regs[0x30] = 0x22;
> +		/* vactive_hight = 121 */
> +		tm_regs[0x31] = 0x61;
> +		/* VBI FRAME CODE */
> +		tm_regs[0x41] = 0xe7;
> +		/* data high level */
> +		tm_regs[0x42] = 0x58;
> +		/* vbil7 */
> +		tm_regs[0x43] = 0x00;
> +		/* vbil8 */
> +		tm_regs[0x44] = 0x00;
> +		/* vbil9 */
> +		tm_regs[0x45] = 0x00;
> +		/* vbil10 */
> +		tm_regs[0x46] = 0x00;
> +		/* vbil11 */
> +		tm_regs[0x47] = 0x00;
> +		/* vbil12 */
> +		tm_regs[0x48] = 0x00;
> +		/* vbil13 */
> +		tm_regs[0x49] = 0x00;
> +		/* vbil14 */
> +		tm_regs[0x4a] = 0x00;
> +		/* vbil15 */
> +		tm_regs[0x4b] = 0x00;
> +		/* vbil16 */
> +		tm_regs[0x4c] = 0x00;
> +		/* vbil17 */
> +		tm_regs[0x4d] = 0x00;
> +		/* vbil18 */
> +		tm_regs[0x4e] = 0x00;
> +		/* vbil19 */
> +		tm_regs[0x4f] = 0x00;
> +		/* vbil20 */
> +		tm_regs[0x50] = 0x00;
> +		/* vbil21 = CC */
> +		tm_regs[0x51] = 0x11;
> +		/* vbil22 */
> +		tm_regs[0x52] = 0x00;
> +		/* vbil23 */
> +		tm_regs[0x53] = 0x00;
> +		/* vbil24 */
> +		tm_regs[0x54] = 0x00;
> +	}
> +
> +	if (dev->input == TM6000_INPUT_SVIDEO) {
> +		/* Y_C = ON */
> +		tm_regs[0x00] |= 0x01;
> +		/* chroma_bw_lo = wide */
> +		tm_regs[0x01] |= 0x04;
> +		/* basic luma notch filter mode */
> +		tm_regs[0x03] = 0x03;
>   	}
> -	if (rc<  0)
> -		return rc;
> -	rc = tm6000_load_std(dev, tv_stds[pos].common,
> -			     sizeof(tv_stds[pos].common));
>
> -	tm6000_set_audio_std(dev, tv_stds[pos].audio_default_std);
> +	/* Set HV filter for PAL */
> +	tm6000_set_reg(dev, TM6010_REQ07_RD5_POWERSAVE, areg_D5);
> +
> +	for (k = 0; k<  0x90; k++) {
> +		if (tm_regs[k] != 0xffff) {
> +			rc = tm6000_set_reg(dev, 0x07, k, (uint8_t)tm_regs[k]);
> +			if (rc<  0) {
> +				printk(KERN_ERR "Error %i while setting "
> +			       "req %d, reg %d to value %d\n",
> +			       rc, 0x07, k, (uint8_t)tm_regs[k]);
> +				return rc;
> +			}
> +		}
> +	}
>
> -	return rc;
> +	/* TCD2 SW Reset ON */
> +	tm6000_set_reg(dev, TM6010_REQ07_R3F_RESET, 0x01);
> +	/* TCD2 SW Reset OFF */
> +	tm6000_set_reg(dev, TM6010_REQ07_R3F_RESET, 0x00);
> +
> +	return 0;
>   }
>
>   int tm6000_set_standard(struct tm6000_core *dev, v4l2_std_id * norm)
>   {
> -	int i, rc = 0;
> +	int rc = 0;
>
>   	dev->norm = *norm;
> -	tm6000_get_std_res(dev);
>
> -	switch (dev->input) {
> -	case TM6000_INPUT_TV:
> -		for (i = 0; i<  ARRAY_SIZE(tv_stds); i++) {
> -			if (*norm&  tv_stds[i].id) {
> -				rc = tm6000_set_tv(dev, i);
> -				goto ret;
> -			}
> -		}
> -		return -EINVAL;
> -	case TM6000_INPUT_SVIDEO:
> -		for (i = 0; i<  ARRAY_SIZE(svideo_stds); i++) {
> -			if (*norm&  svideo_stds[i].id) {
> -				rc = tm6000_load_std(dev, svideo_stds[i].common,
> -						     sizeof(svideo_stds[i].
> -							    common));
> -				goto ret;
> -			}
> -		}
> -		return -EINVAL;
> -	case TM6000_INPUT_COMPOSITE:
> -		for (i = 0; i<  ARRAY_SIZE(composite_stds); i++) {
> -			if (*norm&  composite_stds[i].id) {
> -				rc = tm6000_load_std(dev,
> -						     composite_stds[i].common,
> -						     sizeof(composite_stds[i].
> -							    common));
> -				tm6000_set_audio_std(dev, composite_stds[i].audio_default_std);
> -				goto ret;
> -			}
> -		}
> -		return -EINVAL;
> -	}
> +	rc = tm6000_config_video_input(dev);
> +	if (rc<  0)
> +		return rc;
>
> -ret:
> +	rc = tm6000_config_video_std(dev, norm);
>   	if (rc<  0)
>   		return rc;
>
> -	msleep(40);
> +	if (dev->radio) {
> +		tm6000_set_audio_std(dev, FM_RADIO);
> +		return 0;
> +	}
>
> +	switch (*norm) {
> +	case V4L2_STD_PAL_M:
> +	case V4L2_STD_PAL_N:
> +	case V4L2_STD_PAL_Nc:
> +	case V4L2_STD_NTSC:
> +		tm6000_set_audio_std(dev, BTSC);
> +		break;
> +	case V4L2_STD_PAL:
> +		tm6000_set_audio_std(dev, BG_A2);
> +		break;
> +	case V4L2_STD_SECAM_B:
> +	case V4L2_STD_SECAM_G:
> +		tm6000_set_audio_std(dev, BG_NICAM);
> +		break;
> +	case V4L2_STD_SECAM_DK:
> +		tm6000_set_audio_std(dev, DK_NICAM);
> +		break;
> +	}
>
>   	return 0;
>   }
> diff --git a/drivers/staging/tm6000/tm6000-video.c b/drivers/staging/tm6000/tm6000-video.c
> index c80a316..ef31da1 100644
> --- a/drivers/staging/tm6000/tm6000-video.c
> +++ b/drivers/staging/tm6000/tm6000-video.c
> @@ -1510,6 +1510,7 @@ static int tm6000_open(struct file *file)
>   			V4L2_FIELD_INTERLACED,
>   			sizeof(struct tm6000_buffer), fh,&dev->lock);
>
> +	tm6000_init_demdec(dev);
>   	if (fh->radio) {
>   		dprintk(dev, V4L2_DEBUG_OPEN, "video_open: setting radio device\n");
>   		tm6000_set_audio_input(dev, dev->aradio);
> diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
> index 99ae50e..2db8f2d 100644
> --- a/drivers/staging/tm6000/tm6000.h
> +++ b/drivers/staging/tm6000/tm6000.h
> @@ -228,6 +228,7 @@ struct tm6000_core {
>   	atomic_t			stream_started;  /* stream should be running if true */
>   	enum tm6000_inaudio		avideo;
>   	enum tm6000_inaudio		aradio;
> +	enum tm6000_inaudio		acomposite;
>
>   	struct tm6000_IR		*ir;
>
> @@ -305,6 +306,8 @@ int tm6000_set_audio_bitrate(struct tm6000_core *dev, int bitrate);
>   int tm6000_set_audio_input(struct tm6000_core *dev, enum tm6000_inaudio ainp);
>   int tm6000_tvaudio_set_mute(struct tm6000_core *dev, u8 mute);
>   void tm6000_set_volume(struct tm6000_core *dev, int vol);
> +void tm6000_init_demdec(struct tm6000_core *dev);
> +void tm6000_reset_demdec(struct tm6000_core *dev);
>
>   int tm6000_v4l2_register(struct tm6000_core *dev);
>   int tm6000_v4l2_unregister(struct tm6000_core *dev);
>
> Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov<d.belimov@gmail.com>
>
>
> With my best regards, Dmitry.
Not bad. But what is if a device use two composite config (see TerraTec 
Grabstar)? Or Tuner is connected by other video port, or using gpio's to 
switch external audiodecoder ... Yours doesn't give answers to that. 
Then the audio standard is not complete the decoder can more

I have:
For video norm
PAL_BGH, SECAM_BGH -> BG_A2 and BG_NICAM  -> mode 5 and 7
PAL_DK1, SECAM_DK1 -> DK1_A2 and DK_NICAM -> mode 9 and 6
PAL_DK3, SECAM_DK3 -> DK3_A2 and DK_NICAM -> mode b
PAL_I , SECAM_I -> I_NICAM -> mode 8
PAL_L, SECAM_L -> L_NICAM -> mode a
NTSC_M, PAL-M, PAL_N  -> BTSC -> mode 2
NTSC__M_JP -> EIAJ -> mode 3
NTSC_M_KR -> Korea -> mode 4
for PAL_Nc -> only auto with carier (or ...)
auto mode -> mode 1:
