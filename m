Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:62913 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3CJLmZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 07:42:25 -0400
Received: by mail-ee0-f51.google.com with SMTP id d17so1708152eek.10
        for <linux-media@vger.kernel.org>; Sun, 10 Mar 2013 04:42:23 -0700 (PDT)
Message-ID: <513C71CF.2040508@googlemail.com>
Date: Sun, 10 Mar 2013 12:43:11 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: mchehab@redhat.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH 1/2] bttv: fix audio mute on device close for the
 video device node
References: <1362915635-5431-1-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1362915635-5431-1-git-send-email-fschaefer.oss@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 10.03.2013 12:40, schrieb Frank Schäfer:
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/pci/bt8xx/bttv-driver.c |   22 +++++++++++-----------
>  1 Datei geändert, 11 Zeilen hinzugefügt(+), 11 Zeilen entfernt(-)
>
> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> index 8610b6a..2c09bc5 100644
> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> @@ -992,21 +992,20 @@ static char *audio_modes[] = {
>  static int
>  audio_mux(struct bttv *btv, int input, int mute)
>  {
> -	int gpio_val, signal;
> +	int gpio_val, signal, mute_gpio;
>  	struct v4l2_ctrl *ctrl;
>  
>  	gpio_inout(bttv_tvcards[btv->c.type].gpiomask,
>  		   bttv_tvcards[btv->c.type].gpiomask);
>  	signal = btread(BT848_DSTATUS) & BT848_DSTATUS_HLOC;
>  
> -	btv->mute = mute;
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
> @@ -1022,7 +1021,7 @@ audio_mux(struct bttv *btv, int input, int mute)
>  	}
>  
>  	if (bttv_gpio)
> -		bttv_gpio_tracking(btv, audio_modes[mute ? 4 : input]);
> +		bttv_gpio_tracking(btv, audio_modes[mute_gpio ? 4 : input]);
>  	if (in_interrupt())
>  		return 0;
>  
> @@ -1031,7 +1030,7 @@ audio_mux(struct bttv *btv, int input, int mute)
>  
>  		ctrl = v4l2_ctrl_find(btv->sd_msp34xx->ctrl_handler, V4L2_CID_AUDIO_MUTE);
>  		if (ctrl)
> -			v4l2_ctrl_s_ctrl(ctrl, btv->mute);
> +			v4l2_ctrl_s_ctrl(ctrl, mute);
>  
>  		/* Note: the inputs tuner/radio/extern/intern are translated
>  		   to msp routings. This assumes common behavior for all msp3400
> @@ -1080,7 +1079,7 @@ audio_mux(struct bttv *btv, int input, int mute)
>  		ctrl = v4l2_ctrl_find(btv->sd_tvaudio->ctrl_handler, V4L2_CID_AUDIO_MUTE);
>  
>  		if (ctrl)
> -			v4l2_ctrl_s_ctrl(ctrl, btv->mute);
> +			v4l2_ctrl_s_ctrl(ctrl, mute);
>  		v4l2_subdev_call(btv->sd_tvaudio, audio, s_routing,
>  				input, 0, 0);
>  	}
> @@ -1088,7 +1087,7 @@ audio_mux(struct bttv *btv, int input, int mute)
>  		ctrl = v4l2_ctrl_find(btv->sd_tda7432->ctrl_handler, V4L2_CID_AUDIO_MUTE);
>  
>  		if (ctrl)
> -			v4l2_ctrl_s_ctrl(ctrl, btv->mute);
> +			v4l2_ctrl_s_ctrl(ctrl, mute);
>  	}
>  	return 0;
>  }
> @@ -1300,6 +1299,7 @@ static int bttv_s_ctrl(struct v4l2_ctrl *c)
>  		break;
>  	case V4L2_CID_AUDIO_MUTE:
>  		audio_mute(btv, c->val);
> +		btv->mute = c->val;
>  		break;
>  	case V4L2_CID_AUDIO_VOLUME:
>  		btv->volume_gpio(btv, c->val);
> @@ -3062,8 +3062,7 @@ static int bttv_open(struct file *file)
>  			    sizeof(struct bttv_buffer),
>  			    fh, &btv->lock);
>  	set_tvnorm(btv,btv->tvnorm);
> -	set_input(btv, btv->input, btv->tvnorm);
> -
> +	set_input(btv, btv->input, btv->tvnorm); /* also (un)mutes audio */
>  
>  	/* The V4L2 spec requires one global set of cropping parameters
>  	   which only change on request. These are stored in btv->crop[1].
> @@ -3124,7 +3123,7 @@ static int bttv_release(struct file *file)
>  	bttv_field_count(btv);
>  
>  	if (!btv->users)
> -		audio_mute(btv, btv->mute);
> +		audio_mute(btv, 1);
>  

Btw, what about the interaction between the video and the radio device
node ?
With the current code it is possible to open the video and the radio
device node at the same time, so I wonder if we need an additional patch
changing this to

                if (!btv->users && !btv->radio_user)


Regards,
Frank

>  	v4l2_fh_del(&fh->fh);
>  	v4l2_fh_exit(&fh->fh);
> @@ -4209,6 +4208,7 @@ static int bttv_probe(struct pci_dev *dev, const struct pci_device_id *pci_id)
>  	btv->std = V4L2_STD_PAL;
>  	init_irqreg(btv);
>  	v4l2_ctrl_handler_setup(hdl);
> +	audio_mute(btv, 1);
>  
>  	if (hdl->error) {
>  		result = hdl->error;

