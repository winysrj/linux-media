Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50822 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260AbZKXMzQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Nov 2009 07:55:16 -0500
Message-ID: <4B0BD795.1040709@infradead.org>
Date: Tue, 24 Nov 2009 10:54:45 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: German Galkin <galkinga@gmail.com>
CC: linux-media@vger.kernel.org, Brian Johnson <brijohn@gmail.com>
Subject: Re: [PATCH] sn9c20x: fixed exposure control for HV7131R sensor
References: <1255989349.4536.22.camel@pexis.zodiac.net>
In-Reply-To: <1255989349.4536.22.camel@pexis.zodiac.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi German,

Your patch got line-wrapped. Also, it doesn't apply. Please, resubmit it against
the latest development tree.

Cheers,
Mauro.

German Galkin wrote:
> Made the range of exposure values (0-0x1770) distribute evenly through
> HV7131R's exposure control bytes.
> 
> Signed-off-by: German Galkin <galkinga@gmail.com>
> ---
> diff --git a/drivers/media/video/gspca/sn9c20x.c
> b/drivers/media/video/gspca/sn9c20x.c
> index 99632a7..f173b35 100644
> --- a/drivers/media/video/gspca/sn9c20x.c
> +++ b/drivers/media/video/gspca/sn9c20x.c
> @@ -1656,9 +1656,9 @@ static int set_exposure(struct gspca_dev
> *gspca_dev)
>         case SENSOR_HV7131R:
>                 exp[0] |= (4 << 4);
>                 exp[2] = 0x25;
> -               exp[3] = ((sd->exposure * 0xffffff) / 0xffff) >> 16;
> -               exp[4] = ((sd->exposure * 0xffffff) / 0xffff) >> 8;
> -               exp[5] = ((sd->exposure * 0xffffff) / 0xffff) & 0xff;
> +               exp[3] = (sd->exposure >> 5) & 0xff;
> +               exp[4] = (sd->exposure << 3) & 0xff;
> +               exp[5] = 0;
>                 break;
>         default:
>                 return 0;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

