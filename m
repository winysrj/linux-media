Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:28011 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab3CLN0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 09:26:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [RFC PATCH v2 1/6] bttv: audio_mux() use a local variable "gpio_mute" instead of modifying the function parameter "mute"
Date: Tue, 12 Mar 2013 14:25:22 +0100
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
References: <1362952434-2974-1-git-send-email-fschaefer.oss@googlemail.com> <1362952434-2974-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1362952434-2974-2-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303121425.22469.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun 10 March 2013 22:53:49 Frank Schäfer wrote:
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
