Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:41323 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab3CUK2v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 06:28:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [RFC PATCH 04/10] bttv: rename field 'audio' in struct 'bttv' to 'audio_input'
Date: Thu, 21 Mar 2013 11:28:49 +0100
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
References: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com> <1363807490-3906-5-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1363807490-3906-5-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303211128.49273.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 20 March 2013 20:24:44 Frank Schäfer wrote:
> 'audio_input' better describes the meaning of this field.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/pci/bt8xx/bttv-cards.c  |    2 +-
>  drivers/media/pci/bt8xx/bttv-driver.c |   12 ++++++------
>  drivers/media/pci/bt8xx/bttvp.h       |    2 +-
>  3 Dateien geändert, 8 Zeilen hinzugefügt(+), 8 Zeilen entfernt(-)
> 
> diff --git a/drivers/media/pci/bt8xx/bttv-cards.c b/drivers/media/pci/bt8xx/bttv-cards.c
> index fa0faaa..b7dc921 100644
> --- a/drivers/media/pci/bt8xx/bttv-cards.c
> +++ b/drivers/media/pci/bt8xx/bttv-cards.c
> @@ -3947,7 +3947,7 @@ static void avermedia_eeprom(struct bttv *btv)
>  u32 bttv_tda9880_setnorm(struct bttv *btv, u32 gpiobits)
>  {
>  
> -	if (btv->audio == TVAUDIO_INPUT_TUNER) {
> +	if (btv->audio_input == TVAUDIO_INPUT_TUNER) {
>  		if (bttv_tvnorms[btv->tvnorm].v4l2_id & V4L2_STD_MN)
>  			gpiobits |= 0x10000;
>  		else
> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> index e01a8d8..81ee70d 100644
> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> @@ -1093,7 +1093,7 @@ audio_mux(struct bttv *btv, int input, int mute)
>  static inline int
>  audio_mute(struct bttv *btv, int mute)
>  {
> -	return audio_mux(btv, btv->audio, mute);
> +	return audio_mux(btv, btv->audio_input, mute);
>  }
>  
>  static inline int
> @@ -1195,9 +1195,9 @@ set_input(struct bttv *btv, unsigned int input, unsigned int norm)
>  	} else {
>  		video_mux(btv,input);
>  	}
> -	btv->audio = (btv->tuner_type != TUNER_ABSENT && input == 0) ?
> -			 TVAUDIO_INPUT_TUNER : TVAUDIO_INPUT_EXTERN;
> -	audio_input(btv, btv->audio);
> +	btv->audio_input = (btv->tuner_type != TUNER_ABSENT && input == 0) ?
> +				TVAUDIO_INPUT_TUNER : TVAUDIO_INPUT_EXTERN;
> +	audio_input(btv, btv->audio_input);
>  	set_tvnorm(btv, norm);
>  }
>  
> @@ -1706,8 +1706,8 @@ static void radio_enable(struct bttv *btv)
>  	if (!btv->has_radio_tuner) {
>  		btv->has_radio_tuner = 1;
>  		bttv_call_all(btv, tuner, s_radio);
> -		btv->audio = TVAUDIO_INPUT_RADIO;
> -		audio_input(btv, btv->audio);
> +		btv->audio_input = TVAUDIO_INPUT_RADIO;
> +		audio_input(btv, btv->audio_input);
>  	}
>  }
>  
> diff --git a/drivers/media/pci/bt8xx/bttvp.h b/drivers/media/pci/bt8xx/bttvp.h
> index e7910e0..9c1cc2c 100644
> --- a/drivers/media/pci/bt8xx/bttvp.h
> +++ b/drivers/media/pci/bt8xx/bttvp.h
> @@ -423,7 +423,7 @@ struct bttv {
>  
>  	/* video state */
>  	unsigned int input;
> -	unsigned int audio;
> +	unsigned int audio_input;
>  	unsigned int mute;
>  	unsigned long tv_freq;
>  	unsigned int tvnorm;
> 
