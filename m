Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:8973 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992Ab0GJS2X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jul 2010 14:28:23 -0400
Subject: Re: [PATCH] Add support for AUX_PLL on cx2583x chips
From: Andy Walls <awalls@md.metrocast.net>
To: Sven Barth <pascaldragon@googlemail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Mike Isely <isely@isely.net>
In-Reply-To: <4C38B5AD.9070104@googlemail.com>
References: <4C38B5AD.9070104@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Jul 2010 14:28:15 -0400
Message-ID: <1278786495.2273.288.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-07-10 at 20:02 +0200, Sven Barth wrote:
> This adds support for the AUX_PLL in cx2583x chips which is available in 
> those although the audio part of the chip is not.
> The AUX_PLL is used at least by Terratec in their Grabster AV400 device.
> 
> Signed-off-by: Sven Barth <pascaldragon@googlemail.com>
> Acked-By: Mike Isely <isely@pobox.com>

Reviewed-by: Andy Walls <awalls@md.metrocast.net>
Acked-by: Andy Walls <awalls@md.metrocast.net>

>From my recollection of our previous emails, this patch looks right and
is the right approach.

Regards,
Andy

> diff -aur v4l-src/linux/drivers/media/video/cx25840//cx25840-audio.c 
> v4l-build/linux/drivers/media/video/cx25840//cx25840-audio.c
> --- v4l-src/linux/drivers/media/video/cx25840//cx25840-audio.c 
> 2009-10-18 21:08:26.497700904 +0200
> +++ v4l-build/linux/drivers/media/video/cx25840//cx25840-audio.c 
> 2010-07-09 22:35:31.067718241 +0200
> @@ -438,41 +438,45 @@
>   {
>   	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
> 
> -	/* assert soft reset */
> -	cx25840_and_or(client, 0x810, ~0x1, 0x01);
> -
> -	/* stop microcontroller */
> -	cx25840_and_or(client, 0x803, ~0x10, 0);
> -
> -	/* Mute everything to prevent the PFFT! */
> -	cx25840_write(client, 0x8d3, 0x1f);
> -
> -	if (state->aud_input == CX25840_AUDIO_SERIAL) {
> -		/* Set Path1 to Serial Audio Input */
> -		cx25840_write4(client, 0x8d0, 0x01011012);
> -
> -		/* The microcontroller should not be started for the
> -		 * non-tuner inputs: autodetection is specific for
> -		 * TV audio. */
> -	} else {
> -		/* Set Path1 to Analog Demod Main Channel */
> -		cx25840_write4(client, 0x8d0, 0x1f063870);
> -	}
> +        if (!is_cx2583x(state)) {
> +		/* assert soft reset */
> +		cx25840_and_or(client, 0x810, ~0x1, 0x01);
> +
> +		/* stop microcontroller */
> +		cx25840_and_or(client, 0x803, ~0x10, 0);
> +
> +		/* Mute everything to prevent the PFFT! */
> +		cx25840_write(client, 0x8d3, 0x1f);
> +
> +		if (state->aud_input == CX25840_AUDIO_SERIAL) {
> +			/* Set Path1 to Serial Audio Input */
> +			cx25840_write4(client, 0x8d0, 0x01011012);
> +
> +			/* The microcontroller should not be started for the
> +			 * non-tuner inputs: autodetection is specific for
> +			 * TV audio. */
> +		} else {
> +			/* Set Path1 to Analog Demod Main Channel */
> +			cx25840_write4(client, 0x8d0, 0x1f063870);
> +		}
> +        }
> 
>   	set_audclk_freq(client, state->audclk_freq);
> 
> -	if (state->aud_input != CX25840_AUDIO_SERIAL) {
> -		/* When the microcontroller detects the
> -		 * audio format, it will unmute the lines */
> -		cx25840_and_or(client, 0x803, ~0x10, 0x10);
> -	}
> -
> -	/* deassert soft reset */
> -	cx25840_and_or(client, 0x810, ~0x1, 0x00);
> -
> -	/* Ensure the controller is running when we exit */
> -	if (is_cx2388x(state) || is_cx231xx(state))
> -		cx25840_and_or(client, 0x803, ~0x10, 0x10);
> +        if (!is_cx2583x(state)) {
> +		if (state->aud_input != CX25840_AUDIO_SERIAL) {
> +			/* When the microcontroller detects the
> +			 * audio format, it will unmute the lines */
> +			cx25840_and_or(client, 0x803, ~0x10, 0x10);
> +		}
> +
> +		/* deassert soft reset */
> +		cx25840_and_or(client, 0x810, ~0x1, 0x00);
> +
> +		/* Ensure the controller is running when we exit */
> +		if (is_cx2388x(state) || is_cx231xx(state))
> +			cx25840_and_or(client, 0x803, ~0x10, 0x10);
> +        }
>   }
> 
>   static int get_volume(struct i2c_client *client)
> diff -aur v4l-src/linux/drivers/media/video/cx25840//cx25840-core.c 
> v4l-build/linux/drivers/media/video/cx25840//cx25840-core.c
> --- v4l-src/linux/drivers/media/video/cx25840//cx25840-core.c	2010-06-26 
> 17:56:26.238525747 +0200
> +++ v4l-build/linux/drivers/media/video/cx25840//cx25840-core.c 
> 2010-07-09 23:28:36.784067005 +0200
> @@ -691,6 +691,11 @@
>   	}
>   	cx25840_and_or(client, 0x401, ~0x60, 0);
>   	cx25840_and_or(client, 0x401, ~0x60, 0x60);
> +
> +        /* Don't write into audio registers on cx2583x chips */
> +        if (is_cx2583x(state))
> +        	return;
> +
>   	cx25840_and_or(client, 0x810, ~0x01, 1);
> 
>   	if (state->radio) {
> @@ -849,10 +854,8 @@
> 
>   	state->vid_input = vid_input;
>   	state->aud_input = aud_input;
> -	if (!is_cx2583x(state)) {
> -		cx25840_audio_set_path(client);
> -		input_change(client);
> -	}
> +	cx25840_audio_set_path(client);
> +	input_change(client);
> 
>   	if (is_cx2388x(state)) {
>   		/* Audio channel 1 src : Parallel 1 */
> @@ -1482,8 +1485,6 @@
>   	struct cx25840_state *state = to_state(sd);
>   	struct i2c_client *client = v4l2_get_subdevdata(sd);
> 
> -	if (is_cx2583x(state))
> -		return -EINVAL;
>   	return set_input(client, state->vid_input, input);
>   }
> 
> @@ -1492,8 +1493,7 @@
>   	struct cx25840_state *state = to_state(sd);
>   	struct i2c_client *client = v4l2_get_subdevdata(sd);
> 
> -	if (!is_cx2583x(state))
> -		input_change(client);
> +	input_change(client);
>   	return 0;
>   }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


