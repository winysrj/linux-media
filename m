Return-path: <linux-media-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40381 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754554AbZD0Pxm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2009 11:53:42 -0400
Date: Mon, 27 Apr 2009 16:52:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: MJPEG-tools user list <mjpeg-users@lists.sourceforge.net>
Cc: roel.kluin@gmail.com, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Mjpeg-users] [PATCH] zoran: invalid test on unsigned
Message-ID: <20090427165256.57940d06@lxorguk.ukuu.org.uk>
In-Reply-To: <49F48183.50302@gmail.com>
References: <49F48183.50302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 26 Apr 2009 17:45:07 +0200
Roel Kluin <roel.kluin@gmail.com> wrote:

> fmt->index is unsigned. test doesn't work
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Is there another test required?
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

If it's unsigned then don't we need i >= NUM_FORMATS ?
