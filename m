Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:41752 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761111Ab3BJUV6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 15:21:58 -0500
Received: by mail-ee0-f53.google.com with SMTP id e53so2813750eek.26
        for <linux-media@vger.kernel.org>; Sun, 10 Feb 2013 12:21:54 -0800 (PST)
Message-ID: <51180191.4070100@googlemail.com>
Date: Sun, 10 Feb 2013 21:22:41 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hans.verkuil@cisco.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [REVIEWv2 PATCH 04/19] bttv: remove g/s_audio since there is
 only one audio input.
References: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl> <0681941b222b6cc9c0bb288f81019d4f90c9d683.1360500224.git.hans.verkuil@cisco.com>
In-Reply-To: <0681941b222b6cc9c0bb288f81019d4f90c9d683.1360500224.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hmm... G/S_AUDIO is also used to query/set the capabilities and the mode
of an input, which IMHO makes sense even if the input is the only one
the device has ?
Don't you think that it's also somehow inconsistent, because for the
video inputs (G/S_INPUT) the spec says:
"This ioctl will fail only when there are no video inputs, returning
EINVAL." ?


Regards,
Frank



Am 10.02.2013 13:49, schrieb Hans Verkuil:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/pci/bt8xx/bttv-driver.c |   19 -------------------
>  1 file changed, 19 deletions(-)
>
> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> index 6e61dbd..a02c031 100644
> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> @@ -3138,23 +3138,6 @@ static int bttv_s_crop(struct file *file, void *f, const struct v4l2_crop *crop)
>  	return 0;
>  }
>  
> -static int bttv_g_audio(struct file *file, void *priv, struct v4l2_audio *a)
> -{
> -	if (unlikely(a->index))
> -		return -EINVAL;
> -
> -	strcpy(a->name, "audio");
> -	return 0;
> -}
> -
> -static int bttv_s_audio(struct file *file, void *priv, const struct v4l2_audio *a)
> -{
> -	if (unlikely(a->index))
> -		return -EINVAL;
> -
> -	return 0;
> -}
> -
>  static ssize_t bttv_read(struct file *file, char __user *data,
>  			 size_t count, loff_t *ppos)
>  {
> @@ -3390,8 +3373,6 @@ static const struct v4l2_ioctl_ops bttv_ioctl_ops = {
>  	.vidioc_g_fmt_vbi_cap           = bttv_g_fmt_vbi_cap,
>  	.vidioc_try_fmt_vbi_cap         = bttv_try_fmt_vbi_cap,
>  	.vidioc_s_fmt_vbi_cap           = bttv_s_fmt_vbi_cap,
> -	.vidioc_g_audio                 = bttv_g_audio,
> -	.vidioc_s_audio                 = bttv_s_audio,
>  	.vidioc_cropcap                 = bttv_cropcap,
>  	.vidioc_reqbufs                 = bttv_reqbufs,
>  	.vidioc_querybuf                = bttv_querybuf,

