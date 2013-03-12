Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:48367 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab3CLNmB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 09:42:01 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [RFC PATCH v2 2/6] bttv: audio_mux(): do not change the value of the v4l2 mute control
Date: Tue, 12 Mar 2013 14:41:16 +0100
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
References: <1362952434-2974-1-git-send-email-fschaefer.oss@googlemail.com> <1362952434-2974-3-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1362952434-2974-3-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303121441.16715.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun 10 March 2013 22:53:50 Frank Schäfer wrote:
> There are cases where we want to call audio_mux() without changing the value of
> the v4l2 mute control, for example
> - mute mute on last close
> - mute on device probing
> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>


Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

I think it might be a good idea to take this one step further: pull the
btv->audio assignment out of audio_mux as well. In other words, audio_mux
no longer changes the bttv state.

I also think that the audio_mute and audio_input functions should be
removed, just let the code call audio_mux directly. I think that is more
transparent and one less intermediate call.

A next step would be to untangle the audio routing code and mute code
from audio_mux: that's probably the core of all the confusion. The code
relating to the input selection should be put in a separate function that
is called only when you really want to switch inputs.

I'm not sure if you want to spend time on that last step, if not, then just
do the first two suggestions and I'll test the result. But without really
going to the core of the problem (one function mixing up muting and input
selection) it remains hard to prove correctness of the code. If you have
some time, then it would be very nice if this mess can be resolved once and
for all.

Regards,

	Hans

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
