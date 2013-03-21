Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:20366 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab3CUK0q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 06:26:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [RFC PATCH 02/10] bttv: audio_mux(): do not change the value of the v4l2 mute control
Date: Thu, 21 Mar 2013 11:26:44 +0100
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
References: <1363807490-3906-1-git-send-email-fschaefer.oss@googlemail.com> <1363807490-3906-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1363807490-3906-3-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303211126.44343.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 20 March 2013 20:24:42 Frank Schäfer wrote:
> There are cases where we want to call audio_mux() without changing the value of
> the v4l2 mute control, for example
> - mute mute on last close
> - mute on device probing

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/pci/bt8xx/bttv-driver.c |    8 ++++----
>  1 Datei geändert, 4 Zeilen hinzugefügt(+), 4 Zeilen entfernt(-)
> 
> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> index a584d82..a082ab4 100644
> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> @@ -999,7 +999,6 @@ audio_mux(struct bttv *btv, int input, int mute)
>  		   bttv_tvcards[btv->c.type].gpiomask);
>  	signal = btread(BT848_DSTATUS) & BT848_DSTATUS_HLOC;
>  
> -	btv->mute = mute;
>  	btv->audio = input;
>  
>  	/* automute */
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
> 
