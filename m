Return-path: <mchehab@gaivota>
Received: from mail-bw0-f66.google.com ([209.85.214.66]:41231 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758865Ab0LNBer convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 20:34:47 -0500
MIME-Version: 1.0
In-Reply-To: <201012131859.15152.strakh@ispras.ru>
References: <201012131859.15152.strakh@ispras.ru>
Date: Tue, 14 Dec 2010 09:34:46 +0800
Message-ID: <AANLkTi=4CZ2LD8cj_cjnb5yyyML+M6T=57EjT_hD4TBn@mail.gmail.com>
Subject: Re: BUG: double mutex_unlock in drivers/media/video/tlg2300/pd-video.c
From: Huang Shijie <shijie8@gmail.com>
To: Alexander Strakh <strakh@ispras.ru>
Cc: linux-kernel@vger.kernel.org, kangyong@telegent.com,
	xbzhang@telegent.com, zyziii@telegent.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Strakh:

Thanks for your patch.

But I prefer to remove the mutex_unlock() in the pd_vidioc_s_fmt(),
since the pd_vidioc_s_fmt() is also called in restore_v4l2_context().

would you please change the patch?
I will ack it.

Best Regards
Huang Shijie


2010/12/13 Alexander Strakh <strakh@ispras.ru>:
>        KERNEL_VERSION: 2.6.36
>        SUBJECT: double mutex_lock in drivers/media/video/tlg2300/pd-video.c
> in function vidioc_s_fmt
>        SUBSCRIBE:
>        First mutex_unlock in function pd_vidioc_s_fmt in line 767:
>
>  764        ret |= send_set_req(pd, VIDEO_ROSOLU_SEL,
>  765                                vid_resol, &cmd_status);
>  766        if (ret || cmd_status) {
>  767                mutex_unlock(&pd->lock);
>  768                return -EBUSY;
>  769        }
>
>        Second mutex_unlock in function vidioc_s_fmt in line 806:
>
>  805        pd_vidioc_s_fmt(pd, &f->fmt.pix);
>  806        mutex_unlock(&pd->lock);
>
> Found by Linux Device Drivers Verification Project
>
> Сhecks the return code of pd_vidioc_s_fm before mutex_unlocking.
>
> Signed-off-by: Alexander Strakh <strakh@ispras.ru>
>
> ---
> diff --git a/drivers/media/video/tlg2300/pd-video.c
> b/drivers/media/video/tlg2300/pd-video.c
> index a1ffe18..fe6bd2b 100644
> --- a/drivers/media/video/tlg2300/pd-video.c
> +++ b/drivers/media/video/tlg2300/pd-video.c
> @@ -802,8 +802,8 @@ static int vidioc_s_fmt(struct file *file, void *fh,
> struct v4l2_format *f)
>                return -EINVAL;
>        }
>
> -       pd_vidioc_s_fmt(pd, &f->fmt.pix);
> -       mutex_unlock(&pd->lock);
> +       if(!pd_vidioc_s_fmt(pd, &f->fmt.pix))
> +               mutex_unlock(&pd->lock);
>        return 0;
>  }
>
>
>
