Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:58719 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724AbcDWJvo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2016 05:51:44 -0400
Subject: Re: [PATCH] [media] tvp686x: Don't go past array
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <d25dd8ca8edffc6cc8cee2dac9b907c333a0aa84.1461403421.git.mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <571B45A9.5020207@xs4all.nl>
Date: Sat, 23 Apr 2016 11:51:37 +0200
MIME-Version: 1.0
In-Reply-To: <d25dd8ca8edffc6cc8cee2dac9b907c333a0aa84.1461403421.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/23/2016 11:23 AM, Mauro Carvalho Chehab wrote:
> Depending on the compiler version, currently it produces the
> following warnings:
> 	tw686x-video.c: In function 'tw686x_video_init':
> 	tw686x-video.c:65:543: warning: array subscript is above array bounds [-Warray-bounds]

I posted two patches fixing this and another issue:

https://patchwork.linuxtv.org/patch/33942/
https://patchwork.linuxtv.org/patch/33943/

I noticed that I accidentally set them to 'Accepted', so that might be
why you didn't see them.

I was planning on making a pull request for these on Monday, but you can
also take them now since Ezequiel already Acked them.

Regards,

	Hans

> 
> This is actually bogus with the current code, as it currently
> hardcodes the framerate to 30 frames/sec, however a potential
> use after the array size could happen when the driver adds support
> for setting the framerate. So, fix it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  drivers/media/pci/tw686x/tw686x-video.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
> index 118e9fac9f28..1ff59084ce08 100644
> --- a/drivers/media/pci/tw686x/tw686x-video.c
> +++ b/drivers/media/pci/tw686x/tw686x-video.c
> @@ -61,8 +61,19 @@ static unsigned int tw686x_fields_map(v4l2_std_id std, unsigned int fps)
>  		   8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 0, 0
>  	};
>  
> -	unsigned int i =
> -		(std & V4L2_STD_625_50) ? std_625_50[fps] : std_525_60[fps];
> +	unsigned int i;
> +
> +	if (std & V4L2_STD_625_50) {
> +		if (unlikely(i > ARRAY_SIZE(std_625_50)))
> +			i = 14;		/* 25 fps */
> +		else
> +			i = std_625_50[fps];
> +	} else {
> +		if (unlikely(i > ARRAY_SIZE(std_525_60)))
> +			i = 0;		/* 30 fps */
> +		else
> +			i = std_525_60[fps];
> +	}
>  
>  	return map[i];
>  }
> 

