Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523Ab1IRP4V (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Sep 2011 11:56:21 -0400
Message-ID: <4E76149D.5050102@redhat.com>
Date: Sun, 18 Sep 2011 12:56:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Guennadi <g.liakhovetski@gmx.de>
CC: Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Linux-V4L2 <linux-media@vger.kernel.org>,
	Takashi.Namiki@renesas.com, Phil.Edworthy@renesas.com
Subject: Re: [PATCH 2/3] soc-camera: mt9t112: modify delay time after initialize
References: <uock8ky42.wl%morimoto.kuninori@renesas.com>
In-Reply-To: <uock8ky42.wl%morimoto.kuninori@renesas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 02-02-2010 02:54, Kuninori Morimoto escreveu:
> mt9t112 camera needs 100 milliseconds for initializing
> Special thanks to Phil
> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> Reported-by: Phil Edworthy <Phil.Edworthy@renesas.com>
> ---
>  drivers/media/video/mt9t112.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/mt9t112.c b/drivers/media/video/mt9t112.c
> index 7438f8d..e581d8a 100644
> --- a/drivers/media/video/mt9t112.c
> +++ b/drivers/media/video/mt9t112.c
> @@ -885,7 +885,7 @@ static int mt9t112_s_stream(struct v4l2_subdev *sd, int enable)
>  		/* Invert PCLK (Data sampled on falling edge of pixclk) */
>  		mt9t112_reg_write(ret, client, 0x3C20, param);
>  
> -		mdelay(5);
> +		mdelay(100);
>  
>  		priv->flags |= INIT_DONE;
>  	}

Hi Guennadi,

What's the status of this patch?

It applies ok for me, and I couldn't find any reference at the
ML why it was not applied yet.

Thanks,
Mauro

