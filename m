Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:61569 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab3BDPAB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Feb 2013 10:00:01 -0500
Received: by mail-ie0-f176.google.com with SMTP id k13so4034682iea.35
        for <linux-media@vger.kernel.org>; Mon, 04 Feb 2013 07:00:01 -0800 (PST)
Message-ID: <51108498.4090406@gmail.com>
Date: Mon, 04 Feb 2013 23:03:36 -0500
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
>
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

I tested this patch. it seems ok.
thanks.

Acked-by: Huang Shijie <shijie8@gmail.com>
