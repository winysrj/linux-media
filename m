Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:53984 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab3HBWPY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Aug 2013 18:15:24 -0400
Received: by mail-ee0-f43.google.com with SMTP id e52so565657eek.2
        for <linux-media@vger.kernel.org>; Fri, 02 Aug 2013 15:15:22 -0700 (PDT)
Message-ID: <51FC2F78.1000902@googlemail.com>
Date: Sat, 03 Aug 2013 00:15:20 +0200
From: Gregor Jasny <gjasny@googlemail.com>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] libv4lconvert: Support for RGB32 and BGR32 format
References: <1375362294-30741-1-git-send-email-ricardo.ribalda@gmail.com> <1375362294-30741-3-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1375362294-30741-3-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 8/1/13 3:04 PM, Ricardo Ribalda Delgado wrote:
> --- a/lib/libv4lconvert/libv4lconvert-priv.h
> +++ b/lib/libv4lconvert/libv4lconvert-priv.h
> @@ -108,7 +108,7 @@ unsigned char *v4lconvert_alloc_buffer(int needed,
>   int v4lconvert_oom_error(struct v4lconvert_data *data);
>
>   void v4lconvert_rgb24_to_yuv420(const unsigned char *src, unsigned char *dest,
> -		const struct v4l2_format *src_fmt, int bgr, int yvu);
> +		const struct v4l2_format *src_fmt, int bgr, int yvu, int rgb32);
>
>   void v4lconvert_yuv420_to_rgb24(const unsigned char *src, unsigned char *dst,
>   		int width, int height, int yvu);

> @@ -47,9 +47,15 @@ void v4lconvert_rgb24_to_yuv420(const unsigned char *src, unsigned char *dest,
>   				RGB2Y(src[2], src[1], src[0], *dest++);
>   			else
>   				RGB2Y(src[0], src[1], src[2], *dest++);
> -			src += 3;
> +			if (rgb32)
> +				src += 4;
> +			else
> +				src += 3;

Instead of passing a 0/1 flag here I would call this variable 
bits_per_pixel or bpp and pass 3 or 4 here. This would reduce the if 
condition ugliness.

Thanks,
Gregor

