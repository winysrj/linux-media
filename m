Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2764 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab3CJMBJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 08:01:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [RFC PATCH 1/2] bttv: fix audio mute on device close for the video device node
Date: Sun, 10 Mar 2013 13:00:59 +0100
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
References: <1362915635-5431-1-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1362915635-5431-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303101301.00039.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun March 10 2013 12:40:34 Frank Schäfer wrote:
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>

Could you describe exactly what bug is fixed? I tested it a fair amount
when I created my bttv patches, so I'd like to know what I missed.

Regards,

	Hans

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
> 
