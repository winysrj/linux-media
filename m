Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:34699 "EHLO
	mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbcDURtT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2016 13:49:19 -0400
Received: by mail-qk0-f181.google.com with SMTP id r184so28966443qkc.1
        for <linux-media@vger.kernel.org>; Thu, 21 Apr 2016 10:49:18 -0700 (PDT)
Date: Thu, 21 Apr 2016 14:49:14 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 2/2] tw686x-video: test for 60Hz instead of 50Hz
Message-ID: <20160421174913.GB3696@laptop.cereza>
References: <1461221420-45403-1-git-send-email-hverkuil@xs4all.nl>
 <1461221420-45403-2-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1461221420-45403-2-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21 Apr 08:50 AM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> When determining if the standard is 50 or 60 Hz it is standard
> practice to test for 60 Hz instead of 50 Hz.
> 
> This doesn't matter normally, except if the user specifies both
> 60 and 50 Hz standards.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>

Thanks for the fixes!

> ---
>  drivers/media/pci/tw686x/tw686x-video.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
> index 9a31de9..9cfee0a 100644
> --- a/drivers/media/pci/tw686x/tw686x-video.c
> +++ b/drivers/media/pci/tw686x/tw686x-video.c
> @@ -25,7 +25,7 @@
>  
>  #define TW686X_INPUTS_PER_CH		4
>  #define TW686X_VIDEO_WIDTH		720
> -#define TW686X_VIDEO_HEIGHT(id)		((id & V4L2_STD_625_50) ? 576 : 480)
> +#define TW686X_VIDEO_HEIGHT(id)		((id & V4L2_STD_525_60) ? 480 : 576)
>  
>  static const struct tw686x_format formats[] = {
>  	{
> @@ -518,10 +518,10 @@ static int tw686x_s_std(struct file *file, void *priv, v4l2_std_id id)
>  	reg_write(vc->dev, SDT[vc->ch], val);
>  
>  	val = reg_read(vc->dev, VIDEO_CONTROL1);
> -	if (id & V4L2_STD_625_50)
> -		val |= (1 << (SYS_MODE_DMA_SHIFT + vc->ch));
> -	else
> +	if (id & V4L2_STD_525_60)
>  		val &= ~(1 << (SYS_MODE_DMA_SHIFT + vc->ch));
> +	else
> +		val |= (1 << (SYS_MODE_DMA_SHIFT + vc->ch));
>  	reg_write(vc->dev, VIDEO_CONTROL1, val);
>  
>  	/*
> -- 
> 2.8.0.rc3
> 

-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar
