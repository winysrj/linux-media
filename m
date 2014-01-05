Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:41184 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaAEL2H (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jan 2014 06:28:07 -0500
Received: by mail-ee0-f52.google.com with SMTP id d17so7411925eek.39
        for <linux-media@vger.kernel.org>; Sun, 05 Jan 2014 03:28:03 -0800 (PST)
Message-ID: <52C94207.1050101@googlemail.com>
Date: Sun, 05 Jan 2014 12:29:11 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 13/22] [media] em28xx: initialize audio latter
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com> <1388832951-11195-14-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1388832951-11195-14-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 04.01.2014 11:55, schrieb Mauro Carvalho Chehab:
> Better to first write the GPIOs of the input mux, before initializing
> the audio.
Why are you making this change ?

> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/usb/em28xx/em28xx-video.c | 40 ++++++++++++++++-----------------
>  1 file changed, 20 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> index b767262c642b..328d724a13ea 100644
> --- a/drivers/media/usb/em28xx/em28xx-video.c
> +++ b/drivers/media/usb/em28xx/em28xx-video.c
> @@ -2291,26 +2291,6 @@ static int em28xx_v4l2_init(struct em28xx *dev)
>  	em28xx_tuner_setup(dev);
>  	em28xx_init_camera(dev);
>  
> -	/* Configure audio */
> -	ret = em28xx_audio_setup(dev);
> -	if (ret < 0) {
> -		em28xx_errdev("%s: Error while setting audio - error [%d]!\n",
> -			__func__, ret);
> -		goto err;
> -	}
> -	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
> -		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
> -			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
> -		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
> -			V4L2_CID_AUDIO_VOLUME, 0, 0x1f, 1, 0x1f);
> -	} else {
> -		/* install the em28xx notify callback */
> -		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_MUTE),
> -				em28xx_ctrl_notify, dev);
> -		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_VOLUME),
> -				em28xx_ctrl_notify, dev);
> -	}
> -
>  	/* wake i2c devices */
>  	em28xx_wake_i2c(dev);
>  
> @@ -2356,6 +2336,26 @@ static int em28xx_v4l2_init(struct em28xx *dev)
>  
>  	video_mux(dev, 0);
>  
> +	/* Configure audio */
> +	ret = em28xx_audio_setup(dev);
> +	if (ret < 0) {
> +		em28xx_errdev("%s: Error while setting audio - error [%d]!\n",
> +			__func__, ret);
> +		goto err;
> +	}
> +	if (dev->audio_mode.ac97 != EM28XX_NO_AC97) {
> +		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
> +			V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
> +		v4l2_ctrl_new_std(hdl, &em28xx_ctrl_ops,
> +			V4L2_CID_AUDIO_VOLUME, 0, 0x1f, 1, 0x1f);
> +	} else {
> +		/* install the em28xx notify callback */
> +		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_MUTE),
> +				em28xx_ctrl_notify, dev);
> +		v4l2_ctrl_notify(v4l2_ctrl_find(hdl, V4L2_CID_AUDIO_VOLUME),
> +				em28xx_ctrl_notify, dev);
> +	}
> +
>  	/* Audio defaults */
>  	dev->mute = 1;
>  	dev->volume = 0x1f;
Well, the v4l/core split didn't change the order.
And if the current order would be wrong, then you would also have to
call audio_setup() each time the user switches the input.

So unless you are trying to fix a real bug, I wouldn't change it.
The current order is sane and we likely could never change it back later
without risking regressions...


