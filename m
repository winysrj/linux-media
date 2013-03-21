Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:41043 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab3CUK2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 06:28:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [RFC PATCH 03/10] bttv: do not save the audio input in audio_mux()
Date: Thu, 21 Mar 2013 11:28:10 +0100
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
References: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com> <1363807490-3906-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1363807490-3906-4-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303211128.10361.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 20 March 2013 20:24:43 Frank Schäfer wrote:
> We can't and do not save the mute setting in function audio_mux(), so we
> should also not save the input in this function for consistency.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/pci/bt8xx/bttv-driver.c |   10 +++++-----
>  1 Datei geändert, 5 Zeilen hinzugefügt(+), 5 Zeilen entfernt(-)
> 
> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> index a082ab4..e01a8d8 100644
> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> @@ -999,8 +999,6 @@ audio_mux(struct bttv *btv, int input, int mute)
>  		   bttv_tvcards[btv->c.type].gpiomask);
>  	signal = btread(BT848_DSTATUS) & BT848_DSTATUS_HLOC;
>  
> -	btv->audio = input;
> -
>  	/* automute */
>  	mute_gpio = mute || (btv->opt_automute && (!signal || !btv->users)
>  				&& !btv->has_radio_tuner);
> @@ -1197,8 +1195,9 @@ set_input(struct bttv *btv, unsigned int input, unsigned int norm)
>  	} else {
>  		video_mux(btv,input);
>  	}
> -	audio_input(btv, (btv->tuner_type != TUNER_ABSENT && input == 0) ?
> -			 TVAUDIO_INPUT_TUNER : TVAUDIO_INPUT_EXTERN);
> +	btv->audio = (btv->tuner_type != TUNER_ABSENT && input == 0) ?
> +			 TVAUDIO_INPUT_TUNER : TVAUDIO_INPUT_EXTERN;
> +	audio_input(btv, btv->audio);
>  	set_tvnorm(btv, norm);
>  }
>  
> @@ -1707,7 +1706,8 @@ static void radio_enable(struct bttv *btv)
>  	if (!btv->has_radio_tuner) {
>  		btv->has_radio_tuner = 1;
>  		bttv_call_all(btv, tuner, s_radio);
> -		audio_input(btv, TVAUDIO_INPUT_RADIO);
> +		btv->audio = TVAUDIO_INPUT_RADIO;
> +		audio_input(btv, btv->audio);
>  	}
>  }
>  
> 
