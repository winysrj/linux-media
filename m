Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:10769 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab3CUKY6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 06:24:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [RFC PATCH 01/10] bttv: audio_mux(): use a local variable "gpio_mute" instead of modifying the function parameter "mute"
Date: Thu, 21 Mar 2013 11:24:55 +0100
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
References: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com> <1363807490-3906-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1363807490-3906-2-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303211124.55708.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 20 March 2013 20:24:41 Frank Schäfer wrote:
> Function audio_mux() actually deals with two types of mute: gpio mute and
> subdevice muting.
> This patch claryfies the meaning of these values, but mainly prepares the code for
> the next patch.
> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/pci/bt8xx/bttv-driver.c |    8 ++++----
>  1 Datei geändert, 4 Zeilen hinzugefügt(+), 4 Zeilen entfernt(-)
> 
> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> index 8610b6a..a584d82 100644
> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> @@ -992,7 +992,7 @@ static char *audio_modes[] = {
>  static int
>  audio_mux(struct bttv *btv, int input, int mute)
>  {
> -	int gpio_val, signal;
> +	int gpio_val, signal, mute_gpio;
>  	struct v4l2_ctrl *ctrl;
>  
>  	gpio_inout(bttv_tvcards[btv->c.type].gpiomask,
> @@ -1003,10 +1003,10 @@ audio_mux(struct bttv *btv, int input, int mute)
>  	btv->audio = input;
>  
>  	/* automute */
> -	mute = mute || (btv->opt_automute && (!signal || !btv->users)
> +	mute_gpio = mute || (btv->opt_automute && (!signal || !btv->users)
>  				&& !btv->has_radio_tuner);
>  
> -	if (mute)
> +	if (mute_gpio)
>  		gpio_val = bttv_tvcards[btv->c.type].gpiomute;
>  	else
>  		gpio_val = bttv_tvcards[btv->c.type].gpiomux[input];
> @@ -1022,7 +1022,7 @@ audio_mux(struct bttv *btv, int input, int mute)
>  	}
>  
>  	if (bttv_gpio)
> -		bttv_gpio_tracking(btv, audio_modes[mute ? 4 : input]);
> +		bttv_gpio_tracking(btv, audio_modes[mute_gpio ? 4 : input]);
>  	if (in_interrupt())
>  		return 0;
>  
> 
