Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:57138 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZDZSfs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Apr 2009 14:35:48 -0400
Date: Sun, 26 Apr 2009 11:35:48 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Roel Kluin <roel.kluin@gmail.com>
cc: mjpeg-users@lists.sourceforge.net, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] zoran: invalid test on unsigned
In-Reply-To: <49F48183.50302@gmail.com>
Message-ID: <Pine.LNX.4.58.0904261127210.3753@shell2.speakeasy.net>
References: <49F48183.50302@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 26 Apr 2009, Roel Kluin wrote:
> fmt->index is unsigned. test doesn't work
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Is there another test required?

This is an old driver and I think back in v4l1 the indexes weren't all
unsigned.  There were a number of tests like this in it.  Patch is fine.

Acked-by: Trent Piepho <xyzzy@speakeasy.org>

>
> diff --git a/drivers/media/video/zoran/zoran_driver.c b/drivers/media/video/zoran/zoran_driver.c
> index 092333b..0db5d0f 100644
> --- a/drivers/media/video/zoran/zoran_driver.c
> +++ b/drivers/media/video/zoran/zoran_driver.c
> @@ -1871,7 +1871,7 @@ static int zoran_enum_fmt(struct zoran *zr, struct v4l2_fmtdesc *fmt, int flag)
>  		if (num == fmt->index)
>  			break;
>  	}
> -	if (fmt->index < 0 /* late, but not too late */  || i == NUM_FORMATS)
> +	if (i == NUM_FORMATS)
>  		return -EINVAL;
>
>  	strncpy(fmt->description, zoran_formats[i].name, sizeof(fmt->description)-1);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
