Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:3068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952Ab1EZAH2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 20:07:28 -0400
Message-ID: <4DDD99B5.2050105@redhat.com>
Date: Wed, 25 May 2011 21:07:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: jean-francois Moine <moinejf@free.fr>
CC: Hans Petter Selasky <hselasky@c2i.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Make nchg variable signed because the code compares this
 variable against negative values.
References: <201105231309.54265.hselasky@c2i.net>
In-Reply-To: <201105231309.54265.hselasky@c2i.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Jean-François,

This patch looks ok to me, although the description is not 100%. 

The sonixj driver compares the value for nchg with
		if (sd->nchg < -6 || sd->nchg >= 12) {

With u8, negative values won't work.

Please check.

Thanks!
Mauro



Em 23-05-2011 08:09, Hans Petter Selasky escreveu:
> --HPS
> 
> 
> dvb-usb-0006.patch
> 
> 
> From b05d4913df24f11c7b7a2e07201bb87a04a949bc Mon Sep 17 00:00:00 2001
> From: Hans Petter Selasky <hselasky@c2i.net>
> Date: Mon, 23 May 2011 13:09:18 +0200
> Subject: [PATCH] Make nchg variable signed because the code compares this variable against negative values.
> 
> Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
> ---
>  drivers/media/video/gspca/sonixj.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/gspca/sonixj.c b/drivers/media/video/gspca/sonixj.c
> index 6415aff..81b8a60 100644
> --- a/drivers/media/video/gspca/sonixj.c
> +++ b/drivers/media/video/gspca/sonixj.c
> @@ -60,7 +60,7 @@ struct sd {
>  
>  	u32 pktsz;			/* (used by pkt_scan) */
>  	u16 npkt;
> -	u8 nchg;
> +	s8 nchg;
>  	s8 short_mark;
>  
>  	u8 quality;			/* image quality */
> -- 1.7.1.1


