Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113Ab2B1RXl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Feb 2012 12:23:41 -0500
Message-ID: <4F4D0D98.5040108@redhat.com>
Date: Tue, 28 Feb 2012 14:23:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?TWlyb3NsYXYgU2x1Z2XFiA==?= <thunder.mmm@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: cx25840: improve audio for cx2388x drivers
References: <CAEN_-SDUfyu34YSV6Lr4yADkNmr6=+TALN0xvrCODFPeRedkFA@mail.gmail.com>
In-Reply-To: <CAEN_-SDUfyu34YSV6Lr4yADkNmr6=+TALN0xvrCODFPeRedkFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-01-2012 16:44, Miroslav Slugeň escreveu:
> Searching for testers, this patch is big one, it was more then week of
> work and testing, so i appriciate any comments and recommendations.
> 
> 
> cx25840_audio_fixes.patch
> 
> 
> Signed-off-by: Miroslav Slugen <thunder.mmm@gmail.com>
> From: Miroslav Slugen <thunder.mmm@gmail.com>
> Date: Mon, 12 Dec 2011 00:19:34 +0100
> Subject: [PATCH] This patch should fix many analog audio issues for cx23885 based cards.
> 
> 1. Rewrite part of set_input to cx25840_audio_set_path, this part should be
>  set only when soft reset is asserted and microcontroler is stopped.
>  
> 2. While using AUDIO6 and AUDIO7 inputs we should always stop microcontroler,
>  because they are not tuner inputs, this should fix no-audio for composite
>  s-video and componnet input on many types of tuners.
> 
> 3. Add radio_deemphasis support, in Europe we use 50us, with 75us sound is not so cool.
> 
> 4. Add audio_standard_force support. On many types of cards autodetection of
>  audio standard just doesn't work, my research in this shows that it could be
>  just in wrong registers settings or in detection algorithm, so if we want to
>  have audio on such broken tuners we have to force audio standard, this is done
>  in input_change and should not introduce any regression, i tested this behavior
>  on card with working autodetection Leadtek DVR3200H_xc4000 and with not working
>  DVR3200H_xc3028, first card has audio even with previouse code, but xc3028
>  (older model) has no audio, to get audio support it require to set AUD_STANDARD
>  register, of course forced mode is available in driver level (pvr150_workaround)
>  or as option to module.
>  
> 5. Improve format detection as writen in cx25840 datasheet, this is done in
>  cx23885_initialize and in input_change functions.
>  In init it is necesary to reset tuner autodetection and tuner.
>  In input change i just add others formats from datasheet, previouse code was
>  just for NTSC detection, and it is also necesary to reset microcontroler, but
>  only if it is running.


Your Signed-off-by: is missing on this patch.

> 
> ---
> diff -Naurp a/drivers/media/video/cx25840/cx25840-audio.c b/drivers/media/video/cx25840/cx25840-audio.c
> --- a/drivers/media/video/cx25840/cx25840-audio.c	2012-01-05 00:55:44.000000000 +0100
> +++ b/drivers/media/video/cx25840/cx25840-audio.c	2012-01-14 16:05:38.616366747 +0100
> @@ -446,14 +446,45 @@ void cx25840_audio_set_path(struct i2c_c
>  
>  		/* Mute everything to prevent the PFFT! */
>  		cx25840_write(client, 0x8d3, 0x1f);
> +		cx25840_write(client, 0x8e3, 0x03);
>  
> -		if (state->aud_input == CX25840_AUDIO_SERIAL) {
> +		if (is_cx231xx(state) || is_cx2388x(state)) {
> +			/* Path1 require different GPIO0 pin mux */
> +			if ((state->aud_input == CX25840_AUDIO6) ||
> +			    (state->aud_input == CX25840_AUDIO7)) {
> +				cx25840_write(client, 0x124, 0x00);
> +			} else {
> +				/* Audio channel 1 src : Parallel 1 */
> +				cx25840_write(client, 0x124, 0x03);
> +			}
> +
> +			/* Select AFE clock pad output source */
> +			if (is_cx2388x(state))
> +				cx25840_write(client, 0x144, 0x05);
> +
> +			/* I2S_IN_CTL: I2S_IN_SONY_MODE, LEFT SAMPLE on WS=1 */
> +			cx25840_write(client, 0x914, 0xa0);
> +
> +			/* I2S_OUT_CTL:
> +			 * I2S_IN_SONY_MODE, LEFT SAMPLE on WS=1
> +			 * I2S_OUT_MASTER_MODE = Master
> +			 */
> +			cx25840_write(client, 0x918, 0xa0);
> +			cx25840_write(client, 0x919, 0x01);
> +
> +			if ((state->aud_input == CX25840_AUDIO6) ||
> +			    (state->aud_input == CX25840_AUDIO7)) {
> +				cx25840_write4(client, 0x910, 0);
> +				cx25840_write4(client, 0x8d0, 0x00063073);
> +				/* Reset path1 volume control */
> +				cx25840_write4(client, 0x8d4, 0x7fff0024);
> +			} else { /* default for all sources, not only AUDIO8 */
> +				cx25840_write4(client, 0x910, 0x12b000c9);
> +				cx25840_write4(client, 0x8d0, 0x1f063870);
> +			}
> +		} else if (state->aud_input == CX25840_AUDIO_SERIAL) {
>  			/* Set Path1 to Serial Audio Input */
>  			cx25840_write4(client, 0x8d0, 0x01011012);
> -
> -			/* The microcontroller should not be started for the
> -			 * non-tuner inputs: autodetection is specific for
> -			 * TV audio. */
>  		} else {
>  			/* Set Path1 to Analog Demod Main Channel */
>  			cx25840_write4(client, 0x8d0, 0x1f063870);
> @@ -463,7 +494,12 @@ void cx25840_audio_set_path(struct i2c_c
>  	set_audclk_freq(client, state->audclk_freq);
>  
>  	if (!is_cx2583x(state)) {
> -		if (state->aud_input != CX25840_AUDIO_SERIAL) {
> +		/* The microcontroller should not be started for the
> +		 * non-tuner inputs: autodetection is specific for
> +		 * TV audio. */
> +		if ((state->aud_input != CX25840_AUDIO_SERIAL) &&
> +		    (state->aud_input != CX25840_AUDIO6) &&
> +		    (state->aud_input != CX25840_AUDIO7)) {
>  			/* When the microcontroller detects the
>  			 * audio format, it will unmute the lines */
>  			cx25840_and_or(client, 0x803, ~0x10, 0x10);
> @@ -471,10 +507,6 @@ void cx25840_audio_set_path(struct i2c_c
>  
>  		/* deassert soft reset */
>  		cx25840_and_or(client, 0x810, ~0x1, 0x00);
> -
> -		/* Ensure the controller is running when we exit */
> -		if (is_cx2388x(state) || is_cx231xx(state))
> -			cx25840_and_or(client, 0x803, ~0x10, 0x10);
>  	}
>  }
>  
> diff -Naurp a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
> --- a/drivers/media/video/cx25840/cx25840-core.c	2012-01-14 18:02:41.968366747 +0100
> +++ b/drivers/media/video/cx25840/cx25840-core.c	2012-01-14 18:03:33.024366746 +0100
> @@ -73,11 +73,18 @@ MODULE_LICENSE("GPL");
>  #define CX25840_IR_IRQEN_REG	0x214
>  
>  static int cx25840_debug;
> -
> -module_param_named(debug,cx25840_debug, int, 0644);
> -
> +module_param_named(debug, cx25840_debug, int, 0644);
>  MODULE_PARM_DESC(debug, "Debugging messages [0=Off (default) 1=On]");
>  
> +static unsigned int radio_deemphasis = 0;
> +module_param(radio_deemphasis, int, 0644);
> +MODULE_PARM_DESC(radio_deemphasis, "Radio deemphasis time constant "
> +				   "[0=75us (USA) 1=50us (elsewhere)]");
> +
> +static unsigned int audio_standard_force = 0;
> +module_param(audio_standard_force, int, 0644);
> +MODULE_PARM_DESC(audio_standard_force, "Force audio standard for tuners with broken"
> +				       "microcontroler autodetection [0=Off (default) 1=TV 2=TV+FM]");
>  
>  /* ----------------------------------------------------------------------- */
>  
> @@ -474,7 +481,7 @@ static void cx23885_initialize(struct i2
>  	cx25840_and_or(client, 0x102, ~0x01, 0x01);
>  	cx25840_and_or(client, 0x102, ~0x01, 0x00);
>  
> -	/* Stop microcontroller */
> +	/* 2. Stop microcontroller */
>  	cx25840_and_or(client, 0x803, ~0x10, 0x00);
>  
>  	/* DIF in reset? */
> @@ -536,12 +543,6 @@ static void cx23885_initialize(struct i2
>  	cx25840_write4(client, 0x10c, 0x002be2c9);
>  	cx25840_write4(client, 0x108, 0x0000040f);
>  
> -	/* Luma */
> -	cx25840_write4(client, 0x414, 0x00107d12);
> -
> -	/* Chroma */
> -	cx25840_write4(client, 0x420, 0x3d008282);
> -
>  	/*
>  	 * Aux PLL
>  	 * Initial setup for audio sample clock:
> @@ -586,12 +587,6 @@ static void cx23885_initialize(struct i2
>  	/* VIN1 & VIN5 */
>  	cx25840_write(client, 0x103, 0x11);
>  
> -	/* Enable format auto detect */
> -	cx25840_write(client, 0x400, 0);
> -	/* Fast subchroma lock */
> -	/* White crush, Chroma AGC & Chroma Killer enabled */
> -	cx25840_write(client, 0x401, 0xe8);
> -
>  	/* Select AFE clock pad output source */
>  	cx25840_write(client, 0x144, 0x05);
>  
> @@ -604,7 +599,14 @@ static void cx23885_initialize(struct i2
>  	cx25840_write(client, 0x160, 0x1d);
>  	cx25840_write(client, 0x164, 0x00);
>  
> -	/* Do the firmware load in a work handler to prevent.
> +	/* Enable format auto detect */
> +	cx25840_write(client, 0x400, 0);
> +
> +	/* 4. Reset tuner autodetection */
> +	cx25840_and_or(client, 0x13c, ~0x01, 0x01);
> +	cx25840_and_or(client, 0x13c, ~0x01, 0x00);
> +
> +	/* 5. Do the firmware load in a work handler to prevent.
>  	   Otherwise the kernel is blocked waiting for the
>  	   bit-banging i2c interface to finish uploading the
>  	   firmware. */
> @@ -617,13 +619,32 @@ static void cx23885_initialize(struct i2
>  	finish_wait(&state->fw_wait, &wait);
>  	destroy_workqueue(q);
>  
> +	/* 7. Reset and initialize video decoder */
> +	cx25840_write4(client, 0x4a4, 0x8000);
> +	cx25840_write4(client, 0x4a4, 0);
> +	cx25840_write(client, 0x402, 0x00);
> +
> +	/* 8. White crush, Chroma AGC & Chroma Killer enabled.
> +	 * From datasheet and spoted from Leadtek drivers we
> +	 * should not set Fast Lock and Auto Chroma Lock Speed.
> +	 */
> +	cx25840_write(client, 0x401, 0xe0);
> +
> +	/* Luma */
> +	cx25840_write4(client, 0x414, 0x00107d12);
> +
> +	/* Chroma */
> +	cx25840_write4(client, 0x420, 0x3d008282);
> +
>  	cx25840_std_setup(client);
>  
>  	/* (re)set input */
>  	set_input(client, state->vid_input, state->aud_input);
>  
> -	/* start microcontroller */
> -	cx25840_and_or(client, 0x803, ~0x10, 0x10);
> +	/* start microcontroller only for tuner inputs */
> +	if ((state->aud_input != CX25840_AUDIO6) &&
> +	    (state->aud_input != CX25840_AUDIO7))
> +		cx25840_and_or(client, 0x803, ~0x10, 0x10);
>  
>  	/* Disable and clear video interrupts - we don't use them */
>  	cx25840_write4(client, CX25840_VID_INT_STAT_REG, 0xffffffff);
> @@ -678,6 +699,7 @@ static void cx231xx_initialize(struct i2
>  
>  	/* Enable format auto detect */
>  	cx25840_write(client, 0x400, 0);
> +
>  	/* Fast subchroma lock */
>  	/* White crush, Chroma AGC & Chroma Killer enabled */
>  	cx25840_write(client, 0x401, 0xe8);
> @@ -866,72 +888,112 @@ static void input_change(struct i2c_clie
>  {
>  	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
>  	v4l2_std_id std = state->std;
> +	u8 fmt = cx25840_read(client, 0x40D);
> +	int hw_fix = (audio_standard_force > state->pvr150_workaround) ?
> +			audio_standard_force : state->pvr150_workaround;
>  
>  	/* Follow step 8c and 8d of section 3.16 in the cx25840 datasheet */
>  	if (std & V4L2_STD_SECAM) {
>  		cx25840_write(client, 0x402, 0);
> -	}
> -	else {
> +	} else {
>  		cx25840_write(client, 0x402, 0x04);
>  		cx25840_write(client, 0x49f, (std & V4L2_STD_NTSC) ? 0x14 : 0x11);
>  	}
> -	cx25840_and_or(client, 0x401, ~0x60, 0);
> -	cx25840_and_or(client, 0x401, ~0x60, 0x60);
> +
> +	/* Step 9. Improve format detection */
> +	if (((fmt & 0x0f) > 0x3) ||
> +	    ((fmt & 0x0f) < 0x9)) {
> +		/* Switch to NTSC and back */
> +		u8 val = cx25840_read(client, 0x400);
> +		cx25840_and_or(client, 0x400, ~0x0f, 0x01);
> +		/* Disable LCOMB_3LN_EN and LCOMB_2LN_EN */
> +		cx25840_and_or(client, 0x47b, ~0x06, 0);
> +		cx25840_and_or(client, 0x400, ~0x0f, (val & 0x0f));
> +
> +		/* Toggle CAGCEN and CKILLEN */
> +		cx25840_and_or(client, 0x401, ~0x60, 0);
> +		cx25840_and_or(client, 0x401, ~0x60, 0x60);
> +	} else if ((fmt & 0x0f) == 0x9) {
> +		/* Toggle CKILLEN */
> +		cx25840_and_or(client, 0x401, ~0x20, 0);
> +		cx25840_and_or(client, 0x401, ~0x20, 0x20);
> +		/* Standard autodetection */
> +		cx25840_and_or(client, 0x400, ~0x0f, 0x00);
> +	} else {
> +		/* Toggle CAGCEN and CKILLEN */
> +		cx25840_and_or(client, 0x401, ~0x60, 0);
> +		cx25840_and_or(client, 0x401, ~0x60, 0x60);
> +	}
>  
>  	/* Don't write into audio registers on cx2583x chips */
>  	if (is_cx2583x(state))
>  		return;
>  
> +	/* Toggle microcontroller only when running */
> +	if (cx25840_read(client, 0x803) & 0x10) {
> +		cx25840_and_or(client, 0x803, ~0x10, 0x00);
> +		msleep(1);
> +		cx25840_and_or(client, 0x803, ~0x10, 0x10);
> +	}
> +
>  	cx25840_and_or(client, 0x810, ~0x01, 1);
>  
> +	/* Use default audio format control */
> +	cx25840_write(client, 0x80b, 0);
> +
>  	if (state->radio) {
> -		cx25840_write(client, 0x808, 0xf9);
> -		cx25840_write(client, 0x80b, 0x00);
> -	}
> -	else if (std & V4L2_STD_525_60) {
> -		/* Certain Hauppauge PVR150 models have a hardware bug
> -		   that causes audio to drop out. For these models the
> -		   audio standard must be set explicitly.
> -		   To be precise: it affects cards with tuner models
> -		   85, 99 and 112 (model numbers from tveeprom). */
> -		int hw_fix = state->pvr150_workaround;
> -
> -		if (std == V4L2_STD_NTSC_M_JP) {
> -			/* Japan uses EIAJ audio standard */
> -			cx25840_write(client, 0x808, hw_fix ? 0x2f : 0xf7);
> -		} else if (std == V4L2_STD_NTSC_M_KR) {
> -			/* South Korea uses A2 audio standard */
> -			cx25840_write(client, 0x808, hw_fix ? 0x3f : 0xf8);
> -		} else {
> -			/* Others use the BTSC audio standard */
> -			cx25840_write(client, 0x808, hw_fix ? 0x1f : 0xf6);
> -		}
> -		cx25840_write(client, 0x80b, 0x00);
> -	} else if (std & V4L2_STD_PAL) {
> -		/* Autodetect audio standard and audio system */
> +		/* Disable fm_deviation, set deemphasis, don't mute and prefer stereo */
> +		cx25840_write(client, 0x809, radio_deemphasis ? 0x24 : 0x04);
> +		/* For FM mode hw_fix is not necessary */
> +		cx25840_write(client, 0x808, (hw_fix > 1) ? 0xef : 0xf9);
> +	} else if (std == V4L2_STD_NTSC_M_JP) {
> +		/* Japan uses EIAJ audio standard */
> +		cx25840_write(client, 0x808, hw_fix ? 0x2f : 0xf7);
> +	} else if (std == V4L2_STD_NTSC_M_KR) {
> +		/* South Korea uses A2 audio standard */
> +		cx25840_write(client, 0x808, hw_fix ? 0x3f : 0xf8);
> +	} else if (std & (V4L2_STD_525_60 | V4L2_STD_PAL_N | V4L2_STD_PAL_Nc)) {
> +		/* NTSC, PAL-60, PAL-M and PAL-N uses BTSC audio standard */
> +		cx25840_write(client, 0x808, hw_fix ? 0x1f : 0xf6);
> +	} else if ((std & (V4L2_STD_PAL_BG | V4L2_STD_PAL_H)) &&
> +		   !(std & V4L2_STD_PAL_DK) &&
> +		   !(std & V4L2_STD_PAL_I)) {
> +		/* A2-BG */
> +		cx25840_write(client, 0x808, hw_fix ? 0x4f : 0xf0);
> +	} else if (!(std & (V4L2_STD_PAL_BG | V4L2_STD_PAL_H)) &&
> +		    (std & V4L2_STD_PAL_DK) &&
> +		   !(std & V4L2_STD_PAL_I)) {
> +		/* A2-DK1 */
> +		cx25840_write(client, 0x808, hw_fix ? 0x5f : 0xf1);
> +	} else if (!(std & (V4L2_STD_PAL_BG | V4L2_STD_PAL_H)) &&
> +		   !(std & V4L2_STD_PAL_DK) &&
> +		    (std & V4L2_STD_PAL_I)) {
> +		/* A1 */
> +		cx25840_write(client, 0x808, hw_fix ? 0x8f : 0xf4);
> +	} else if ((std & (V4L2_STD_SECAM_B | V4L2_STD_SECAM_G | V4L2_STD_SECAM_H)) &&
> +		   !(std & V4L2_STD_SECAM_DK) &&
> +		   !(std & (V4L2_STD_SECAM_L | V4L2_STD_SECAM_LC))) {
> +		/* NICAM-BG */
> +		cx25840_write(client, 0x808, hw_fix ? 0xaf : 0xf0);
> +	} else if (!(std & (V4L2_STD_SECAM_B | V4L2_STD_SECAM_G | V4L2_STD_SECAM_H)) &&
> +		    (std & V4L2_STD_SECAM_DK) &&
> +		   !(std & (V4L2_STD_SECAM_L | V4L2_STD_SECAM_LC))) {
> +		/* NICAM-DK */
> +		cx25840_write(client, 0x808, hw_fix ? 0xbf : 0xf1);
> +	} else if (!(std & (V4L2_STD_SECAM_B | V4L2_STD_SECAM_G | V4L2_STD_SECAM_H)) &&
> +		   !(std & V4L2_STD_SECAM_DK) &&
> +		    (std & (V4L2_STD_SECAM_L | V4L2_STD_SECAM_LC))) {
> +		/* 6.5 MHz carrier to be interpreted as System L */
> +		cx25840_write(client, 0x80b, 0x08);
> +		/* NICAM-L */
> +		cx25840_write(client, 0x808, hw_fix ? 0xdf : 0xf5);
> +        } else if (std & V4L2_STD_SECAM) {
> +		/* 6.5 MHz carrier to be autodetected */
> +		cx25840_write(client, 0x80b, 0x10);
>  		cx25840_write(client, 0x808, 0xff);
> -		/* Since system PAL-L is pretty much non-existent and
> -		   not used by any public broadcast network, force
> -		   6.5 MHz carrier to be interpreted as System DK,
> -		   this avoids DK audio detection instability */
> -	       cx25840_write(client, 0x80b, 0x00);
> -	} else if (std & V4L2_STD_SECAM) {
> -		/* Autodetect audio standard and audio system */
> +	} else {
> +		/* Audio standard autodetection - not working on some cards */
>  		cx25840_write(client, 0x808, 0xff);
> -		/* If only one of SECAM-DK / SECAM-L is required, then force
> -		  6.5MHz carrier, else autodetect it */
> -		if ((std & V4L2_STD_SECAM_DK) &&
> -		    !(std & (V4L2_STD_SECAM_L | V4L2_STD_SECAM_LC))) {
> -			/* 6.5 MHz carrier to be interpreted as System DK */
> -			cx25840_write(client, 0x80b, 0x00);
> -	       } else if (!(std & V4L2_STD_SECAM_DK) &&
> -			  (std & (V4L2_STD_SECAM_L | V4L2_STD_SECAM_LC))) {
> -			/* 6.5 MHz carrier to be interpreted as System L */
> -			cx25840_write(client, 0x80b, 0x08);
> -	       } else {
> -			/* 6.5 MHz carrier to be autodetected */
> -			cx25840_write(client, 0x80b, 0x10);
> -	       }
>  	}
>  
>  	cx25840_and_or(client, 0x810, ~0x01, 0);
> @@ -950,7 +1012,7 @@ static int set_input(struct i2c_client *
>  	u8 reg;
>  
>  	v4l_dbg(1, cx25840_debug, client,
> -		"decoder set video input %d, audio input %d\n",
> +		"decoder set video input 0x%x, audio input 0x%x\n",
>  		vid_input, aud_input);
>  
>  	if (vid_input >= CX25840_VIN1_CH1) {
> @@ -1043,49 +1105,6 @@ static int set_input(struct i2c_client *
>  	cx25840_audio_set_path(client);
>  	input_change(client);
>  
> -	if (is_cx2388x(state)) {
> -		/* Audio channel 1 src : Parallel 1 */
> -		cx25840_write(client, 0x124, 0x03);
> -
> -		/* Select AFE clock pad output source */
> -		cx25840_write(client, 0x144, 0x05);
> -
> -		/* I2S_IN_CTL: I2S_IN_SONY_MODE, LEFT SAMPLE on WS=1 */
> -		cx25840_write(client, 0x914, 0xa0);
> -
> -		/* I2S_OUT_CTL:
> -		 * I2S_IN_SONY_MODE, LEFT SAMPLE on WS=1
> -		 * I2S_OUT_MASTER_MODE = Master
> -		 */
> -		cx25840_write(client, 0x918, 0xa0);
> -		cx25840_write(client, 0x919, 0x01);
> -	} else if (is_cx231xx(state)) {
> -		/* Audio channel 1 src : Parallel 1 */
> -		cx25840_write(client, 0x124, 0x03);
> -
> -		/* I2S_IN_CTL: I2S_IN_SONY_MODE, LEFT SAMPLE on WS=1 */
> -		cx25840_write(client, 0x914, 0xa0);
> -
> -		/* I2S_OUT_CTL:
> -		 * I2S_IN_SONY_MODE, LEFT SAMPLE on WS=1
> -		 * I2S_OUT_MASTER_MODE = Master
> -		 */
> -		cx25840_write(client, 0x918, 0xa0);
> -		cx25840_write(client, 0x919, 0x01);
> -	}
> -
> -	if (is_cx2388x(state) && ((aud_input == CX25840_AUDIO7) ||
> -		(aud_input == CX25840_AUDIO6))) {
> -		/* Configure audio from LR1 or LR2 input */
> -		cx25840_write4(client, 0x910, 0);
> -		cx25840_write4(client, 0x8d0, 0x63073);
> -	} else
> -	if (is_cx2388x(state) && (aud_input == CX25840_AUDIO8)) {
> -		/* Configure audio from tuner/sif input */
> -		cx25840_write4(client, 0x910, 0x12b000c9);
> -		cx25840_write4(client, 0x8d0, 0x1f063870);
> -	}
> -
>  	return 0;
>  }
>  
> 

