Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44234 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752318AbdLKP1v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 10:27:51 -0500
Date: Mon, 11 Dec 2017 13:27:38 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Michael Krufky <mkrufky@linuxtv.org>,
        Andy Walls <awalls@md.metrocast.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 1/6] cx25840: add pin to pad mapping and output
 format configuration
Message-ID: <20171211132738.42476937@vento.lan>
In-Reply-To: <0bccfd81-e224-ffcc-bc95-d23ddd7d00b9@maciej.szmigiero.name>
References: <0bccfd81-e224-ffcc-bc95-d23ddd7d00b9@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 10 Oct 2017 23:34:45 +0200
"Maciej S. Szmigiero" <mail@maciej.szmigiero.name> escreveu:

> This commit adds pin to pad mapping and output format configuration support
> in CX2584x-series chips to cx25840 driver.
> 
> This functionality is then used to allow disabling ivtv-specific hacks
> (called a "generic mode"), so cx25840 driver can be used for other devices
> not needing them without risking compatibility problems.
> 
> Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
> ---
>  drivers/media/i2c/cx25840/cx25840-core.c | 394 ++++++++++++++++++++++++++++++-
>  drivers/media/i2c/cx25840/cx25840-core.h |  11 +
>  drivers/media/i2c/cx25840/cx25840-vbi.c  |   3 +
>  drivers/media/pci/ivtv/ivtv-i2c.c        |   1 +
>  include/media/drv-intf/cx25840.h         |  74 +++++-
>  5 files changed, 481 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
> index f38bf819d805..a1efc975852c 100644
> --- a/drivers/media/i2c/cx25840/cx25840-core.c
> +++ b/drivers/media/i2c/cx25840/cx25840-core.c
> @@ -21,6 +21,9 @@
>   * CX23888 DIF support for the HVR1850
>   * Copyright (C) 2011 Steven Toth <stoth@kernellabs.com>
>   *
> + * CX2584x pin to pad mapping and output format configuration support are
> + * Copyright (C) 2011 Maciej S. Szmigiero <mail@maciej.szmigiero.name>
> + *
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public License
>   * as published by the Free Software Foundation; either version 2
> @@ -316,6 +319,260 @@ static int cx23885_s_io_pin_config(struct v4l2_subdev *sd, size_t n,
>  	return 0;
>  }
>  
> +static u8 cx25840_function_to_pad(struct i2c_client *client, u8 function)
> +{
> +	switch (function) {
> +	case CX25840_PAD_ACTIVE:
> +		return 1;
> +
> +	case CX25840_PAD_VACTIVE:
> +		return 2;
> +
> +	case CX25840_PAD_CBFLAG:
> +		return 3;
> +
> +	case CX25840_PAD_VID_DATA_EXT0:
> +		return 4;
> +
> +	case CX25840_PAD_VID_DATA_EXT1:
> +		return 5;
> +
> +	case CX25840_PAD_GPO0:
> +		return 6;
> +
> +	case CX25840_PAD_GPO1:
> +		return 7;
> +
> +	case CX25840_PAD_GPO2:
> +		return 8;
> +
> +	case CX25840_PAD_GPO3:
> +		return 9;
> +
> +	case CX25840_PAD_IRQ_N:
> +		return 10;
> +
> +	case CX25840_PAD_AC_SYNC:
> +		return 11;
> +
> +	case CX25840_PAD_AC_SDOUT:
> +		return 12;
> +
> +	case CX25840_PAD_PLL_CLK:
> +		return 13;
> +
> +	case CX25840_PAD_VRESET:
> +		return 14;
> +
> +	default:
> +		if (function != CX25840_PAD_DEFAULT)
> +			v4l_err(client,
> +				"invalid function %u, assuming default\n",
> +				(unsigned int)function);
> +		return 0;
> +	}
> +}
> +
> +static void cx25840_set_invert(u8 *pinctrl3, u8 *voutctrl4, u8 function,
> +			       u8 pin, bool invert)
> +{
> +	switch (function) {
> +	case CX25840_PAD_IRQ_N:
> +		if (invert)
> +			*pinctrl3 &= ~2;
> +		else
> +			*pinctrl3 |= 2;
> +		break;
> +
> +	case CX25840_PAD_ACTIVE:
> +		if (invert)
> +			*voutctrl4 |= BIT(2);
> +		else
> +			*voutctrl4 &= ~BIT(2);
> +		break;
> +
> +	case CX25840_PAD_VACTIVE:
> +		if (invert)
> +			*voutctrl4 |= BIT(5);
> +		else
> +			*voutctrl4 &= ~BIT(5);
> +		break;
> +
> +	case CX25840_PAD_CBFLAG:
> +		if (invert)
> +			*voutctrl4 |= BIT(4);
> +		else
> +			*voutctrl4 &= ~BIT(4);
> +		break;
> +
> +	case CX25840_PAD_VRESET:
> +		if (invert)
> +			*voutctrl4 |= BIT(0);
> +		else
> +			*voutctrl4 &= ~BIT(0);
> +		break;
> +	}
> +
> +	if (function != CX25840_PAD_DEFAULT)
> +		return;
> +
> +	switch (pin) {
> +	case CX25840_PIN_DVALID_PRGM0:
> +		if (invert)
> +			*voutctrl4 |= BIT(6);
> +		else
> +			*voutctrl4 &= ~BIT(6);
> +		break;
> +
> +	case CX25840_PIN_HRESET_PRGM2:
> +		if (invert)
> +			*voutctrl4 |= BIT(1);
> +		else
> +			*voutctrl4 &= ~BIT(1);
> +		break;
> +	}
> +}
> +
> +static int cx25840_s_io_pin_config(struct v4l2_subdev *sd, size_t n,
> +				   struct v4l2_subdev_io_pin_config *p)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	unsigned int i;
> +	u8 pinctrl[6], pinconf[10], voutctrl4;
> +
> +	for (i = 0; i < 6; i++)
> +		pinctrl[i] = cx25840_read(client, 0x114 + i);
> +
> +	for (i = 0; i < 10; i++)
> +		pinconf[i] = cx25840_read(client, 0x11c + i);
> +
> +	voutctrl4 = cx25840_read(client, 0x407);
> +
> +	for (i = 0; i < n; i++) {
> +		u8 strength = p[i].strength;
> +
> +		if (strength != CX25840_PIN_DRIVE_SLOW &&
> +		    strength != CX25840_PIN_DRIVE_MEDIUM &&
> +		    strength != CX25840_PIN_DRIVE_FAST) {
> +
> +			v4l_err(client,
> +				"invalid drive speed for pin %u (%u), assuming fast\n",
> +				(unsigned int)p[i].pin,
> +				(unsigned int)strength);
> +
> +			strength = CX25840_PIN_DRIVE_FAST;
> +		}
> +
> +		switch (p[i].pin) {
> +		case CX25840_PIN_DVALID_PRGM0:
> +			if (p[i].flags & V4L2_SUBDEV_IO_PIN_DISABLE)
> +				pinctrl[0] &= ~BIT(6);
> +			else
> +				pinctrl[0] |= BIT(6);
> +
> +			pinconf[3] &= 0xf0;
> +			pinconf[3] |= cx25840_function_to_pad(client,
> +							      p[i].function);
> +
> +			cx25840_set_invert(&pinctrl[3], &voutctrl4,
> +					   p[i].function,
> +					   CX25840_PIN_DVALID_PRGM0,
> +					   p[i].flags &
> +					   V4L2_SUBDEV_IO_PIN_ACTIVE_LOW);
> +
> +			pinctrl[4] &= ~(3 << 2); /* CX25840_PIN_DRIVE_MEDIUM */
> +			switch (strength) {
> +			case CX25840_PIN_DRIVE_SLOW:
> +				pinctrl[4] |= 1 << 2;
> +				break;
> +
> +			case CX25840_PIN_DRIVE_FAST:
> +				pinctrl[4] |= 2 << 2;
> +				break;
> +			}
> +
> +			break;
> +
> +		case CX25840_PIN_HRESET_PRGM2:
> +			if (p[i].flags & V4L2_SUBDEV_IO_PIN_DISABLE)
> +				pinctrl[1] &= ~BIT(0);
> +			else
> +				pinctrl[1] |= BIT(0);
> +
> +			pinconf[4] &= 0xf0;
> +			pinconf[4] |= cx25840_function_to_pad(client,
> +							      p[i].function);
> +
> +			cx25840_set_invert(&pinctrl[3], &voutctrl4,
> +					   p[i].function,
> +					   CX25840_PIN_HRESET_PRGM2,
> +					   p[i].flags &
> +					   V4L2_SUBDEV_IO_PIN_ACTIVE_LOW);
> +
> +			pinctrl[4] &= ~(3 << 2); /* CX25840_PIN_DRIVE_MEDIUM */
> +			switch (strength) {
> +			case CX25840_PIN_DRIVE_SLOW:
> +				pinctrl[4] |= 1 << 2;
> +				break;
> +
> +			case CX25840_PIN_DRIVE_FAST:
> +				pinctrl[4] |= 2 << 2;
> +				break;
> +			}
> +
> +			break;
> +
> +		case CX25840_PIN_PLL_CLK_PRGM7:
> +			if (p[i].flags & V4L2_SUBDEV_IO_PIN_DISABLE)
> +				pinctrl[2] &= ~BIT(2);
> +			else
> +				pinctrl[2] |= BIT(2);
> +
> +			switch (p[i].function) {
> +			case CX25840_PAD_XTI_X5_DLL:
> +				pinconf[6] = 0;
> +				break;
> +
> +			case CX25840_PAD_AUX_PLL:
> +				pinconf[6] = 1;
> +				break;
> +
> +			case CX25840_PAD_VID_PLL:
> +				pinconf[6] = 5;
> +				break;
> +
> +			case CX25840_PAD_XTI:
> +				pinconf[6] = 2;
> +				break;
> +
> +			default:
> +				pinconf[6] = 3;
> +				pinconf[6] |=
> +					cx25840_function_to_pad(client,
> +								p[i].function)
> +					<< 4;
> +			}
> +
> +			break;
> +
> +		default:
> +			v4l_err(client, "invalid or unsupported pin %u\n",
> +				(unsigned int)p[i].pin);
> +			break;
> +		}
> +	}
> +
> +	cx25840_write(client, 0x407, voutctrl4);
> +
> +	for (i = 0; i < 6; i++)
> +		cx25840_write(client, 0x114 + i, pinctrl[i]);
> +
> +	for (i = 0; i < 10; i++)
> +		cx25840_write(client, 0x11c + i, pinconf[i]);
> +
> +	return 0;
> +}
> +
>  static int common_s_io_pin_config(struct v4l2_subdev *sd, size_t n,
>  				      struct v4l2_subdev_io_pin_config *pincfg)
>  {
> @@ -323,6 +580,8 @@ static int common_s_io_pin_config(struct v4l2_subdev *sd, size_t n,
>  
>  	if (is_cx2388x(state))
>  		return cx23885_s_io_pin_config(sd, n, pincfg);
> +	else if (is_cx2584x(state))
> +		return cx25840_s_io_pin_config(sd, n, pincfg);
>  	return 0;
>  }
>  
> @@ -455,6 +714,22 @@ static void cx25840_initialize(struct i2c_client *client)
>  	/* (re)set input */
>  	set_input(client, state->vid_input, state->aud_input);
>  
> +	if (state->generic_mode) {
> +		/* set datasheet video output defaults */
> +		cx25840_vconfig(client, CX25840_VCONFIG_FMT_BT656 |
> +				CX25840_VCONFIG_RES_8BIT |
> +				CX25840_VCONFIG_VBIRAW_DISABLED |
> +				CX25840_VCONFIG_ANCDATA_ENABLED |
> +				CX25840_VCONFIG_TASKBIT_ONE |
> +				CX25840_VCONFIG_ACTIVE_HORIZONTAL |
> +				CX25840_VCONFIG_VALID_NORMAL |
> +				CX25840_VCONFIG_HRESETW_NORMAL |
> +				CX25840_VCONFIG_CLKGATE_NONE |
> +				CX25840_VCONFIG_DCMODE_DWORDS |
> +				CX25840_VCONFIG_IDID0S_NORMAL |
> +				CX25840_VCONFIG_VIPCLAMP_DISABLED);
> +	}
> +
>  	/* start microcontroller */
>  	cx25840_and_or(client, 0x803, ~0x10, 0x10);
>  }
> @@ -1387,7 +1662,9 @@ static int cx25840_set_fmt(struct v4l2_subdev *sd,
>  		Hsrc |= (cx25840_read(client, 0x471) & 0xf0) >> 4;
>  	}
>  
> -	Vlines = fmt->height + (is_50Hz ? 4 : 7);
> +	Vlines = fmt->height;
> +	if (!state->generic_mode)
> +		Vlines += is_50Hz ? 4 : 7;
>  
>  	/*
>  	 * We keep 1 margin for the Vsrc < Vlines check since the
> @@ -1630,6 +1907,117 @@ static void log_audio_status(struct i2c_client *client)
>  	}
>  }
>  
> +#define CX25840_VCONFIG_OPTION(option_mask)				\
> +	do {								\
> +		if (config_in & (option_mask)) {			\
> +			state->vid_config &= ~(option_mask);		\
> +			state->vid_config |= config_in & (option_mask); \

Don't do that: the "config_in" var is not at the macro's parameter.
It only works if this macro is called at cx25840_vconfig() function.
The same applies to state. That makes harder for anyone reviewing the
code to understand it. Also, makes harder to use it on any other place.

If you want to use a macro, please add all required vars to the macro
parameters.

> +		}							\
> +	} while (0)
> +
> +#define CX25840_VCONFIG_SET_BIT(optionmask, reg, bit, oneval)		\
> +	do {								\
> +		if (state->vid_config & (optionmask)) {		\
> +			if ((state->vid_config & (optionmask)) ==	\
> +			    (oneval))					\
> +				voutctrl[reg] |= BIT(bit);		\
> +			else						\
> +				voutctrl[reg] &= ~BIT(bit);		\
> +		}							\
> +	} while (0)

Same applies here: state and voutctrl aren't at macro's parameters.

> +
> +int cx25840_vconfig(struct i2c_client *client, u32 config_in)
> +{
> +	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
> +	u8 voutctrl[3];
> +	unsigned int i;
> +
> +	/* apply incoming options to the current state */
> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_FMT_MASK);
> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_RES_MASK);
> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_VBIRAW_MASK);
> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_ANCDATA_MASK);
> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_TASKBIT_MASK);
> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_ACTIVE_MASK);
> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_VALID_MASK);
> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_HRESETW_MASK);
> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_CLKGATE_MASK);
> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_DCMODE_MASK);
> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_IDID0S_MASK);
> +	CX25840_VCONFIG_OPTION(CX25840_VCONFIG_VIPCLAMP_MASK);

The entire logic here sounds complex, without need. Wouldn't be
better/clearer if you rewrite it as:

	u32 option_mask = CX25840_VCONFIG_FMT_MASK
	       | CX25840_VCONFIG_RES_MASK
...
	       | CX25840_VCONFIG_VIPCLAMP_MASK;

	state->vid_config &= ~option_mask;
	state->vid_config |= config_in & option_mask;


> +
> +	for (i = 0; i < 3; i++)
> +		voutctrl[i] = cx25840_read(client, 0x404 + i);
> +
> +	/* apply state to hardware regs */
> +	if (state->vid_config & CX25840_VCONFIG_FMT_MASK)
> +		voutctrl[0] &= ~(3);
> +	switch (state->vid_config & CX25840_VCONFIG_FMT_MASK) {
> +	case CX25840_VCONFIG_FMT_BT656:
> +		voutctrl[0] |= 1;
> +		break;
> +
> +	case CX25840_VCONFIG_FMT_VIP11:
> +		voutctrl[0] |= 2;
> +		break;
> +
> +	case CX25840_VCONFIG_FMT_VIP2:
> +		voutctrl[0] |= 3;
> +		break;
> +
> +	case CX25840_VCONFIG_FMT_BT601: /* zero */
> +	default:
> +		break;
> +	}
> +
> +	CX25840_VCONFIG_SET_BIT(CX25840_VCONFIG_RES_MASK, 0, 2,
> +				CX25840_VCONFIG_RES_10BIT);
> +	CX25840_VCONFIG_SET_BIT(CX25840_VCONFIG_VBIRAW_MASK, 0, 3,
> +				CX25840_VCONFIG_VBIRAW_ENABLED);
> +	CX25840_VCONFIG_SET_BIT(CX25840_VCONFIG_ANCDATA_MASK, 0, 4,
> +				CX25840_VCONFIG_ANCDATA_ENABLED);
> +	CX25840_VCONFIG_SET_BIT(CX25840_VCONFIG_TASKBIT_MASK, 0, 5,
> +				CX25840_VCONFIG_TASKBIT_ONE);
> +	CX25840_VCONFIG_SET_BIT(CX25840_VCONFIG_ACTIVE_MASK, 1, 2,
> +				CX25840_VCONFIG_ACTIVE_HORIZONTAL);
> +	CX25840_VCONFIG_SET_BIT(CX25840_VCONFIG_VALID_MASK, 1, 3,
> +				CX25840_VCONFIG_VALID_ANDACTIVE);
> +	CX25840_VCONFIG_SET_BIT(CX25840_VCONFIG_HRESETW_MASK, 1, 4,
> +				CX25840_VCONFIG_HRESETW_PIXCLK);
> +
> +	if (state->vid_config & CX25840_VCONFIG_CLKGATE_MASK)
> +		voutctrl[1] &= ~(3 << 6);
> +	switch (state->vid_config & CX25840_VCONFIG_CLKGATE_MASK) {
> +	case CX25840_VCONFIG_CLKGATE_VALID:
> +		voutctrl[1] |= 2;
> +		break;
> +
> +	case CX25840_VCONFIG_CLKGATE_VALIDACTIVE:
> +		voutctrl[1] |= 3;
> +		break;
> +
> +	case CX25840_VCONFIG_CLKGATE_NONE: /* zero */
> +	default:
> +		break;
> +	}
> +
> +
> +	CX25840_VCONFIG_SET_BIT(CX25840_VCONFIG_DCMODE_MASK, 2, 0,
> +				CX25840_VCONFIG_DCMODE_BYTES);
> +	CX25840_VCONFIG_SET_BIT(CX25840_VCONFIG_IDID0S_MASK, 2, 1,
> +				CX25840_VCONFIG_IDID0S_LINECNT);
> +	CX25840_VCONFIG_SET_BIT(CX25840_VCONFIG_VIPCLAMP_MASK, 2, 4,
> +				CX25840_VCONFIG_VIPCLAMP_ENABLED);
> +
> +	for (i = 0; i < 3; i++)
> +		cx25840_write(client, 0x404 + i, voutctrl[i]);
> +
> +	return 0;
> +}
> +
> +#undef CX25840_VCONFIG_SET_BIT
> +#undef CX25840_VCONFIG_OPTION
> +
>  /* ----------------------------------------------------------------------- */
>  
>  /* This load_fw operation must be called to load the driver's firmware.
> @@ -1819,6 +2207,9 @@ static int cx25840_s_video_routing(struct v4l2_subdev *sd,
>  	if (is_cx23888(state))
>  		cx23888_std_setup(client);
>  
> +	if (is_cx2584x(state) && state->generic_mode)
> +		cx25840_vconfig(client, config);
> +
>  	return set_input(client, input, state->aud_input);
>  }
>  
> @@ -5318,6 +5709,7 @@ static int cx25840_probe(struct i2c_client *client,
>  		struct cx25840_platform_data *pdata = client->dev.platform_data;
>  
>  		state->pvr150_workaround = pdata->pvr150_workaround;
> +		state->generic_mode = pdata->generic_mode;
>  	}
>  
>  	cx25840_ir_probe(sd);
> diff --git a/drivers/media/i2c/cx25840/cx25840-core.h b/drivers/media/i2c/cx25840/cx25840-core.h
> index 55432ed42714..ea7952551a29 100644
> --- a/drivers/media/i2c/cx25840/cx25840-core.h
> +++ b/drivers/media/i2c/cx25840/cx25840-core.h
> @@ -55,9 +55,11 @@ struct cx25840_state {
>  		struct v4l2_ctrl *mute;
>  	};
>  	int pvr150_workaround;
> +	int generic_mode;
>  	int radio;
>  	v4l2_std_id std;
>  	enum cx25840_video_input vid_input;
> +	u32 vid_config;
>  	enum cx25840_audio_input aud_input;
>  	u32 audclk_freq;
>  	int audmode;

Please add some descriptions to those new parameters. Ideally, the
best would be to write a kernel-doc comment before cx25840_state,
document everything there.

> @@ -90,6 +92,14 @@ static inline bool is_cx2583x(struct cx25840_state *state)
>  	       state->id == CX25837;
>  }
>  
> +static inline bool is_cx2584x(struct cx25840_state *state)
> +{
> +	return state->id == CX25840 ||
> +	       state->id == CX25841 ||
> +	       state->id == CX25842 ||
> +	       state->id == CX25843;
> +}
> +
>  static inline bool is_cx231xx(struct cx25840_state *state)
>  {
>  	return state->id == CX2310X_AV;
> @@ -127,6 +137,7 @@ int cx25840_and_or(struct i2c_client *client, u16 addr, unsigned mask, u8 value)
>  int cx25840_and_or4(struct i2c_client *client, u16 addr, u32 and_mask,
>  		    u32 or_value);
>  void cx25840_std_setup(struct i2c_client *client);
> +int cx25840_vconfig(struct i2c_client *client, u32 config_in);
>  
>  /* ----------------------------------------------------------------------- */
>  /* cx25850-firmware.c                                                      */
> diff --git a/drivers/media/i2c/cx25840/cx25840-vbi.c b/drivers/media/i2c/cx25840/cx25840-vbi.c
> index 8c99a79fb726..23b7c1fb28ab 100644
> --- a/drivers/media/i2c/cx25840/cx25840-vbi.c
> +++ b/drivers/media/i2c/cx25840/cx25840-vbi.c
> @@ -95,6 +95,7 @@ int cx25840_g_sliced_fmt(struct v4l2_subdev *sd, struct v4l2_sliced_vbi_format *
>  	memset(svbi->service_lines, 0, sizeof(svbi->service_lines));
>  	svbi->service_set = 0;
>  	/* we're done if raw VBI is active */
> +	/* this will have to be changed for generic_mode VBI */
>  	if ((cx25840_read(client, 0x404) & 0x10) == 0)
>  		return 0;
>  
> @@ -137,6 +138,7 @@ int cx25840_s_raw_fmt(struct v4l2_subdev *sd, struct v4l2_vbi_format *fmt)
>  		cx25840_write(client, 0x54f, vbi_offset);
>  	else
>  		cx25840_write(client, 0x47f, vbi_offset);
> +	/* this will have to be changed for generic_mode VBI */
>  	cx25840_write(client, 0x404, 0x2e);
>  	return 0;
>  }
> @@ -157,6 +159,7 @@ int cx25840_s_sliced_fmt(struct v4l2_subdev *sd, struct v4l2_sliced_vbi_format *
>  	cx25840_std_setup(client);
>  
>  	/* Sliced VBI */
> +	/* this will have to be changed for generic_mode VBI */
>  	cx25840_write(client, 0x404, 0x32);	/* Ancillary data */
>  	cx25840_write(client, 0x406, 0x13);
>  	if (is_cx23888(state))
> diff --git a/drivers/media/pci/ivtv/ivtv-i2c.c b/drivers/media/pci/ivtv/ivtv-i2c.c
> index 893962ac85de..ad32a55b90e8 100644
> --- a/drivers/media/pci/ivtv/ivtv-i2c.c
> +++ b/drivers/media/pci/ivtv/ivtv-i2c.c
> @@ -305,6 +305,7 @@ int ivtv_i2c_register(struct ivtv *itv, unsigned idx)
>  			.platform_data = &pdata,
>  		};
>  
> +		memset(&pdata, 0, sizeof(pdata));

This probably could be on a separate patch.

>  		pdata.pvr150_workaround = itv->pvr150_workaround;
>  		sd = v4l2_i2c_new_subdev_board(&itv->v4l2_dev, adap,
>  				&cx25840_info, NULL);
> diff --git a/include/media/drv-intf/cx25840.h b/include/media/drv-intf/cx25840.h
> index 783c5bdd63eb..dbd742bbbf58 100644
> --- a/include/media/drv-intf/cx25840.h
> +++ b/include/media/drv-intf/cx25840.h
> @@ -88,6 +88,70 @@ enum cx25840_video_input {
>  	CX25840_DIF_ON = 0x80000400,
>  };
>  
> +/* arguments to video s_routing config param */
> +#define CX25840_VCONFIG_FMT_SHIFT 0
> +#define CX25840_VCONFIG_FMT_MASK 7
> +#define CX25840_VCONFIG_FMT_BT601 1
> +#define CX25840_VCONFIG_FMT_BT656 2
> +#define CX25840_VCONFIG_FMT_VIP11 3
> +#define CX25840_VCONFIG_FMT_VIP2 4
> +
> +#define CX25840_VCONFIG_RES_SHIFT 3
> +#define CX25840_VCONFIG_RES_MASK (3 << 3)

The better would be to use Kernel macros for the bit masks. For single
bit ones, you should use BIT(n). For other thinks like the above,
GENMASK(), e. g.: 

	#define CX25840_VCONFIG_RES_MASK GENMASK(5, 3)

See include/linux/bitops.h.




> +#define CX25840_VCONFIG_RES_8BIT (1 << 3)
> +#define CX25840_VCONFIG_RES_10BIT (2 << 3)
> +
> +#define CX25840_VCONFIG_VBIRAW_SHIFT 5
> +#define CX25840_VCONFIG_VBIRAW_MASK (3 << 5)
> +#define CX25840_VCONFIG_VBIRAW_DISABLED (1 << 5)
> +#define CX25840_VCONFIG_VBIRAW_ENABLED (2 << 5)
> +
> +#define CX25840_VCONFIG_ANCDATA_SHIFT 7
> +#define CX25840_VCONFIG_ANCDATA_MASK (3 << 7)
> +#define CX25840_VCONFIG_ANCDATA_DISABLED (1 << 7)
> +#define CX25840_VCONFIG_ANCDATA_ENABLED (2 << 7)
> +
> +#define CX25840_VCONFIG_TASKBIT_SHIFT 9
> +#define CX25840_VCONFIG_TASKBIT_MASK (3 << 9)
> +#define CX25840_VCONFIG_TASKBIT_ZERO (1 << 9)
> +#define CX25840_VCONFIG_TASKBIT_ONE (2 << 9)
> +
> +#define CX25840_VCONFIG_ACTIVE_SHIFT 11
> +#define CX25840_VCONFIG_ACTIVE_MASK (3 << 11)
> +#define CX25840_VCONFIG_ACTIVE_COMPOSITE (1 << 11)
> +#define CX25840_VCONFIG_ACTIVE_HORIZONTAL (2 << 11)
> +
> +#define CX25840_VCONFIG_VALID_SHIFT 13
> +#define CX25840_VCONFIG_VALID_MASK (3 << 13)
> +#define CX25840_VCONFIG_VALID_NORMAL (1 << 13)
> +#define CX25840_VCONFIG_VALID_ANDACTIVE (2 << 13)
> +
> +#define CX25840_VCONFIG_HRESETW_SHIFT 15
> +#define CX25840_VCONFIG_HRESETW_MASK (3 << 15)
> +#define CX25840_VCONFIG_HRESETW_NORMAL (1 << 15)
> +#define CX25840_VCONFIG_HRESETW_PIXCLK (2 << 15)
> +
> +#define CX25840_VCONFIG_CLKGATE_SHIFT 17
> +#define CX25840_VCONFIG_CLKGATE_MASK (3 << 17)
> +#define CX25840_VCONFIG_CLKGATE_NONE (1 << 17)
> +#define CX25840_VCONFIG_CLKGATE_VALID (2 << 17)
> +#define CX25840_VCONFIG_CLKGATE_VALIDACTIVE (3 << 17)
> +
> +#define CX25840_VCONFIG_DCMODE_SHIFT 19
> +#define CX25840_VCONFIG_DCMODE_MASK (3 << 19)
> +#define CX25840_VCONFIG_DCMODE_DWORDS (1 << 19)
> +#define CX25840_VCONFIG_DCMODE_BYTES (2 << 19)
> +
> +#define CX25840_VCONFIG_IDID0S_SHIFT 21
> +#define CX25840_VCONFIG_IDID0S_MASK (3 << 21)
> +#define CX25840_VCONFIG_IDID0S_NORMAL (1 << 21)
> +#define CX25840_VCONFIG_IDID0S_LINECNT (2 << 21)
> +
> +#define CX25840_VCONFIG_VIPCLAMP_SHIFT 23
> +#define CX25840_VCONFIG_VIPCLAMP_MASK (3 << 23)
> +#define CX25840_VCONFIG_VIPCLAMP_ENABLED (1 << 23)
> +#define CX25840_VCONFIG_VIPCLAMP_DISABLED (2 << 23)
> +
>  enum cx25840_audio_input {
>  	/* Audio inputs: serial or In4-In8 */
>  	CX25840_AUDIO_SERIAL,
> @@ -180,9 +244,17 @@ enum cx23885_io_pad {
>     audio autodetect fails on some channels for these models and the workaround
>     is to select the audio standard explicitly. Many thanks to Hauppauge for
>     providing this information.
> -   This platform data only needs to be supplied by the ivtv driver. */
> +   This platform data only needs to be supplied by the ivtv driver.
> +
> +   generic_mode disables some of the ivtv-related hacks in this driver,
> +   enables setting video output config and sets it according to datasheet
> +   defaults on initialization.
> +   This flag is to be used for example with USB video capture devices
> +   using this chip.
> +*/
>  struct cx25840_platform_data {
>  	int pvr150_workaround;
> +	int generic_mode;
>  };
>  
>  #endif
> 



Thanks,
Mauro
