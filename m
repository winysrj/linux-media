Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f41.google.com ([209.85.212.41]:60571 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936306Ab3DHPe3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 11:34:29 -0400
Received: by mail-vb0-f41.google.com with SMTP id f13so3946671vbg.28
        for <linux-media@vger.kernel.org>; Mon, 08 Apr 2013 08:34:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365418061-23694-2-git-send-email-hverkuil@xs4all.nl>
References: <1365418061-23694-1-git-send-email-hverkuil@xs4all.nl>
	<1365418061-23694-2-git-send-email-hverkuil@xs4all.nl>
Date: Mon, 8 Apr 2013 11:34:28 -0400
Message-ID: <CAC-25o8D+0TRChtcCB9aNoRasUZnXAZNGwUumD_iS6qL1e-X1A@mail.gmail.com>
Subject: Re: [REVIEW PATCH 1/7] radio-si4713: remove audout ioctls
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, Apr 8, 2013 at 6:47 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> The audout ioctls are not appropriate for radio transmitters, they apply to
> video output devices only. Remove them from this driver.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Eduardo Valentin <edubezval@gmail.com>
Tested-by: Eduardo Valentin <edubezval@gmail.com>


Output of v4l2-compliant is the same as the one send against patch 00/07
> ---
>  drivers/media/radio/radio-si4713.c |   32 --------------------------------
>  1 file changed, 32 deletions(-)
>
> diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
> index 38b3f15..320f301 100644
> --- a/drivers/media/radio/radio-si4713.c
> +++ b/drivers/media/radio/radio-si4713.c
> @@ -59,35 +59,6 @@ static const struct v4l2_file_operations radio_si4713_fops = {
>  };
>
>  /* Video4Linux Interface */
> -static int radio_si4713_fill_audout(struct v4l2_audioout *vao)
> -{
> -       /* TODO: check presence of audio output */
> -       strlcpy(vao->name, "FM Modulator Audio Out", 32);
> -
> -       return 0;
> -}
> -
> -static int radio_si4713_enumaudout(struct file *file, void *priv,
> -                                               struct v4l2_audioout *vao)
> -{
> -       return radio_si4713_fill_audout(vao);
> -}
> -
> -static int radio_si4713_g_audout(struct file *file, void *priv,
> -                                       struct v4l2_audioout *vao)
> -{
> -       int rval = radio_si4713_fill_audout(vao);
> -
> -       vao->index = 0;
> -
> -       return rval;
> -}
> -
> -static int radio_si4713_s_audout(struct file *file, void *priv,
> -                                       const struct v4l2_audioout *vao)
> -{
> -       return vao->index ? -EINVAL : 0;
> -}
>
>  /* radio_si4713_querycap - query device capabilities */
>  static int radio_si4713_querycap(struct file *file, void *priv,
> @@ -229,9 +200,6 @@ static long radio_si4713_default(struct file *file, void *p,
>  }
>
>  static struct v4l2_ioctl_ops radio_si4713_ioctl_ops = {
> -       .vidioc_enumaudout      = radio_si4713_enumaudout,
> -       .vidioc_g_audout        = radio_si4713_g_audout,
> -       .vidioc_s_audout        = radio_si4713_s_audout,
>         .vidioc_querycap        = radio_si4713_querycap,
>         .vidioc_queryctrl       = radio_si4713_queryctrl,
>         .vidioc_g_ext_ctrls     = radio_si4713_g_ext_ctrls,
> --
> 1.7.10.4
>



-- 
Eduardo Bezerra Valentin
