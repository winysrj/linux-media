Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:51686 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab3CUKh7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 06:37:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [RFC PATCH 06/10] bttv: untangle audio input and mute setting
Date: Thu, 21 Mar 2013 11:37:58 +0100
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
References: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com> <1363807490-3906-7-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1363807490-3906-7-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303211137.58139.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 20 March 2013 20:24:46 Frank Schäfer wrote:
> Split function audio_mux():
> move the mute setting part to function audio_mute() and the input setting part
> to function audio_input().

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/pci/bt8xx/bttv-driver.c |   51 ++++++++++++++++-----------------
>  1 Datei geändert, 24 Zeilen hinzugefügt(+), 27 Zeilen entfernt(-)
> 
> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> index f1cb0db..0df4a16 100644
> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> @@ -1022,18 +1022,37 @@ audio_mux_gpio(struct bttv *btv, int input, int mute)
>  }
>  
>  static int
> -audio_mux(struct bttv *btv, int input, int mute)
> +audio_mute(struct bttv *btv, int mute)
>  {
>  	struct v4l2_ctrl *ctrl;
>  
> -	audio_mux_gpio(btv, input, mute);
> +	audio_mux_gpio(btv, btv->audio_input, mute);
>  
>  	if (btv->sd_msp34xx) {
> -		u32 in;
> -
>  		ctrl = v4l2_ctrl_find(btv->sd_msp34xx->ctrl_handler, V4L2_CID_AUDIO_MUTE);
>  		if (ctrl)
>  			v4l2_ctrl_s_ctrl(ctrl, mute);
> +	}
> +	if (btv->sd_tvaudio) {
> +		ctrl = v4l2_ctrl_find(btv->sd_tvaudio->ctrl_handler, V4L2_CID_AUDIO_MUTE);
> +		if (ctrl)
> +			v4l2_ctrl_s_ctrl(ctrl, mute);
> +	}
> +	if (btv->sd_tda7432) {
> +		ctrl = v4l2_ctrl_find(btv->sd_tda7432->ctrl_handler, V4L2_CID_AUDIO_MUTE);
> +		if (ctrl)
> +			v4l2_ctrl_s_ctrl(ctrl, mute);
> +	}
> +	return 0;
> +}
> +
> +static int
> +audio_input(struct bttv *btv, int input)
> +{
> +	audio_mux_gpio(btv, input, btv->mute);
> +
> +	if (btv->sd_msp34xx) {
> +		u32 in;
>  
>  		/* Note: the inputs tuner/radio/extern/intern are translated
>  		   to msp routings. This assumes common behavior for all msp3400
> @@ -1079,34 +1098,12 @@ audio_mux(struct bttv *btv, int input, int mute)
>  			       in, MSP_OUTPUT_DEFAULT, 0);
>  	}
>  	if (btv->sd_tvaudio) {
> -		ctrl = v4l2_ctrl_find(btv->sd_tvaudio->ctrl_handler, V4L2_CID_AUDIO_MUTE);
> -
> -		if (ctrl)
> -			v4l2_ctrl_s_ctrl(ctrl, mute);
>  		v4l2_subdev_call(btv->sd_tvaudio, audio, s_routing,
> -				input, 0, 0);
> -	}
> -	if (btv->sd_tda7432) {
> -		ctrl = v4l2_ctrl_find(btv->sd_tda7432->ctrl_handler, V4L2_CID_AUDIO_MUTE);
> -
> -		if (ctrl)
> -			v4l2_ctrl_s_ctrl(ctrl, mute);
> +				 input, 0, 0);
>  	}
>  	return 0;
>  }
>  
> -static inline int
> -audio_mute(struct bttv *btv, int mute)
> -{
> -	return audio_mux(btv, btv->audio_input, mute);
> -}
> -
> -static inline int
> -audio_input(struct bttv *btv, int input)
> -{
> -	return audio_mux(btv, input, btv->mute);
> -}
> -
>  static void
>  bttv_crop_calc_limits(struct bttv_crop *c)
>  {
> 
