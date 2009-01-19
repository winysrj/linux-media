Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:34922 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbZASSVy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2009 13:21:54 -0500
Date: Mon, 19 Jan 2009 10:21:38 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Roel Kluin <roel.kluin@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: Re: [PATCH] Bttv: move check on unsigned
In-Reply-To: <497250C7.6030502@gmail.com>
Message-ID: <Pine.LNX.4.58.0901191020460.11165@shell2.speakeasy.net>
References: <497250C7.6030502@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 17 Jan 2009, Roel Kluin wrote:
> Please review, this patch was not tested.
>
> The static function set_tvnorm is called in
> drivers/media/video/bt8xx/bttv-driver.c:
>
> 1355:   set_tvnorm(btv, norm);
> 1868:   set_tvnorm(btv, i);
> 3273:   set_tvnorm(btv,btv->tvnorm);
>
> in the first two with an unsigned, but bttv->tvnorm is signed.

Probably better to just change bttv->tvnorm is unsigned if we can.

>
> see vi drivers/media/video/bt8xx/bttvp.h +381
> since norm is unsigned in set_tvnorm, a negative won't get noticed.
> so remove the redundant check and move it to the caller.
>
> My question is: should we error return like this?
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
> index c71f394..6f50f90 100644
> --- a/drivers/media/video/bt8xx/bttv-driver.c
> +++ b/drivers/media/video/bt8xx/bttv-driver.c
> @@ -1290,7 +1290,7 @@ set_tvnorm(struct bttv *btv, unsigned int norm)
>  	const struct bttv_tvnorm *tvnorm;
>  	v4l2_std_id id;
>
> -	if (norm < 0 || norm >= BTTV_TVNORMS)
> +	if (norm >= BTTV_TVNORMS)
>  		return -EINVAL;
>
>  	tvnorm = &bttv_tvnorms[norm];
> @@ -3266,6 +3266,10 @@ static int bttv_open(struct file *file)
>  			    V4L2_FIELD_SEQ_TB,
>  			    sizeof(struct bttv_buffer),
>  			    fh);
> +	if (btv->norm < 0) {
> +                unlock_kernel();
> +                return -EINVAL;
> +        }
>  	set_tvnorm(btv,btv->tvnorm);
>  	set_input(btv, btv->input, btv->tvnorm);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
