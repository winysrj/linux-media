Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2072 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaICUuf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:50:35 -0400
Message-ID: <54077EEB.4040701@xs4all.nl>
Date: Wed, 03 Sep 2014 22:49:47 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 04/46] [media] vivid-vid-out: use memdup_user()
References: <cover.1409775488.git.m.chehab@samsung.com> <8e3336dbdbd26a56fb6817a4dc7cb31d860e8c5d.1409775488.git.m.chehab@samsung.com>
In-Reply-To: <8e3336dbdbd26a56fb6817a4dc7cb31d860e8c5d.1409775488.git.m.chehab@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/03/2014 10:32 PM, Mauro Carvalho Chehab wrote:
> Instead of allocating and coping from __user, do it using
> one atomic call. That makes the code simpler. Also,

Also what?

Anyway, looks good to me:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> Found by coccinelle.
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> 
> diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
> index c983461f29d5..8ed9f6d9f505 100644
> --- a/drivers/media/platform/vivid/vivid-vid-out.c
> +++ b/drivers/media/platform/vivid/vivid-vid-out.c
> @@ -897,14 +897,10 @@ int vidioc_s_fmt_vid_out_overlay(struct file *file, void *priv,
>  		return ret;
>  
>  	if (win->bitmap) {
> -		new_bitmap = kzalloc(bitmap_size, GFP_KERNEL);
> +		new_bitmap = memdup_user(win->bitmap, bitmap_size);
>  
> -		if (new_bitmap == NULL)
> -			return -ENOMEM;
> -		if (copy_from_user(new_bitmap, win->bitmap, bitmap_size)) {
> -			kfree(new_bitmap);
> -			return -EFAULT;
> -		}
> +		if (IS_ERR(new_bitmap))
> +			return PTR_ERR(new_bitmap);
>  	}
>  
>  	dev->overlay_out_top = win->w.top;
> 

