Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f41.google.com ([209.85.210.41]:58678 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab3BCPNH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2013 10:13:07 -0500
Received: by mail-da0-f41.google.com with SMTP id e20so2310894dak.14
        for <linux-media@vger.kernel.org>; Sun, 03 Feb 2013 07:13:06 -0800 (PST)
Message-ID: <510F3620.2040004@gmail.com>
Date: Sun, 03 Feb 2013 23:16:32 -0500
From: Huang Shijie <shijie8@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 04/18] tlg2300: remove ioctls that are invalid for
 radio devices.
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl> <fa815493501dbc166181e228f66319ac3398cd2c.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <fa815493501dbc166181e228f66319ac3398cd2c.1359627298.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

于 2013年01月31日 05:25, Hans Verkuil 写道:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> The input and audio ioctls are only valid for video/vbi nodes.

I remember that if you do not set these ioctrls, the mplayer will not works.

I can not download the mplayer in my home, so i can not test it.
I will test it in my office.

thanks
Huang Shijie

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/usb/tlg2300/pd-radio.c |   27 ---------------------------
>  1 file changed, 27 deletions(-)
>
> diff --git a/drivers/media/usb/tlg2300/pd-radio.c b/drivers/media/usb/tlg2300/pd-radio.c
> index c4feffb..4c76e089 100644
> --- a/drivers/media/usb/tlg2300/pd-radio.c
> +++ b/drivers/media/usb/tlg2300/pd-radio.c
> @@ -350,36 +350,9 @@ static int vidioc_s_tuner(struct file *file, void *priv, struct v4l2_tuner *vt)
>  {
>  	return vt->index > 0 ? -EINVAL : 0;
>  }
> -static int vidioc_s_audio(struct file *file, void *priv, const struct v4l2_audio *va)
> -{
> -	return (va->index != 0) ? -EINVAL : 0;
> -}
> -
> -static int vidioc_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
> -{
> -	a->index    = 0;
> -	a->mode    = 0;
> -	a->capability = V4L2_AUDCAP_STEREO;
> -	strcpy(a->name, "Radio");
> -	return 0;
> -}
> -
> -static int vidioc_s_input(struct file *filp, void *priv, u32 i)
> -{
> -	return (i != 0) ? -EINVAL : 0;
> -}
> -
> -static int vidioc_g_input(struct file *filp, void *priv, u32 *i)
> -{
> -	return (*i != 0) ? -EINVAL : 0;
> -}
>  
>  static const struct v4l2_ioctl_ops poseidon_fm_ioctl_ops = {
>  	.vidioc_querycap    = vidioc_querycap,
> -	.vidioc_g_audio     = vidioc_g_audio,
> -	.vidioc_s_audio     = vidioc_s_audio,
> -	.vidioc_g_input     = vidioc_g_input,
> -	.vidioc_s_input     = vidioc_s_input,
>  	.vidioc_queryctrl   = tlg_fm_vidioc_queryctrl,
>  	.vidioc_querymenu   = tlg_fm_vidioc_querymenu,
>  	.vidioc_g_ctrl      = tlg_fm_vidioc_g_ctrl,

