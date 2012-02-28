Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239Ab2B1R3L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Feb 2012 12:29:11 -0500
Message-ID: <4F4D0EE2.4030908@redhat.com>
Date: Tue, 28 Feb 2012 14:29:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?TWlyb3NsYXYgU2x1Z2XFiA==?= <thunder.mmm@gmail.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: cx25840: allow setting radio audio mode stereo/mono
References: <CAEN_-SB9X_3OrLAG7D6kotprtu6Xza3=XSeVZFsV937tWJK3yQ@mail.gmail.com>
In-Reply-To: <CAEN_-SB9X_3OrLAG7D6kotprtu6Xza3=XSeVZFsV937tWJK3yQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 16-01-2012 13:32, Miroslav Slugeň escreveu:
> 
> cx25840_s_tuner_radio_support.patch

Signed-off-by: is missing.
> 
> 
> Signed-off-by: Miroslav Slugen <thunder.mmm@gmail.com>
> From: Miroslav Slugen <thunder.mmm@gmail.com>
> Date: Mon, 12 Dec 2011 00:19:34 +0100
> Subject: [PATCH] cx25840_s_tuner should support also radio mode for setting
>  stereo and mono.
> 
> ---
> diff -Naurp a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
> --- a/drivers/media/video/cx25840/cx25840-core.c	2012-01-12 20:42:45.000000000 +0100
> +++ b/drivers/media/video/cx25840/cx25840-core.c	2012-01-16 16:18:06.181583026 +0100
> @@ -1628,9 +1628,14 @@ static int cx25840_s_tuner(struct v4l2_s
>  	struct cx25840_state *state = to_state(sd);
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  
> -	if (state->radio || is_cx2583x(state))
> +	if (is_cx2583x(state))
>  		return 0;
>  
> +	/* FM radio supports only mono and stereo modes */
> +	if ((state->radio) &&
> +	    (vt->audmode != V4L2_TUNER_MODE_MONO) &&
> +	    (vt->audmode != V4L2_TUNER_MODE_STEREO)) return -EINVAL;
> +

Well, this is true for all radio devices: only mono/stereo modes are supported.
A check like that probably makes sense at the V4L2 core [1], as otherwise, the
same test would be needed on all radio drivers.

[1] drivers/media/video/v4l2-ioctl.c

Regards,
Mauro

>  	switch (vt->audmode) {
>  		case V4L2_TUNER_MODE_MONO:
>  			/* mono      -> mono
> -- 1.7.2.3
> 

