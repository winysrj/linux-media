Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:19762 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbaKYKec (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Nov 2014 05:34:32 -0500
Message-id: <54745B2F.70003@samsung.com>
Date: Tue, 25 Nov 2014 11:34:23 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Josh Wu <josh.wu@atmel.com>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	linux-kernel@vger.kernel.org, g.liakhovetski@gmx.de
Subject: Re: [PATCH 1/2] media: v4l2-image-sizes.h: add SVGA,
 XGA and UXGA size definitions
References: <1416905668-23029-1-git-send-email-josh.wu@atmel.com>
In-reply-to: <1416905668-23029-1-git-send-email-josh.wu@atmel.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

On 25/11/14 09:54, Josh Wu wrote:
> Add SVGA, UXGA and XGA size definitions to v4l2-image-sizes.h.
> The definitions are sorted by alphabet order.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
>  include/media/v4l2-image-sizes.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/include/media/v4l2-image-sizes.h b/include/media/v4l2-image-sizes.h
> index 10daf92..c70c917 100644
> --- a/include/media/v4l2-image-sizes.h
> +++ b/include/media/v4l2-image-sizes.h
> @@ -25,10 +25,19 @@
>  #define QVGA_WIDTH	320
>  #define QVGA_HEIGHT	240
>  
> +#define SVGA_WIDTH	800
> +#define SVGA_HEIGHT	680

I think this should be 600. With that fixed, for both patches:

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

>  #define SXGA_WIDTH	1280
>  #define SXGA_HEIGHT	1024
>  
>  #define VGA_WIDTH	640
>  #define VGA_HEIGHT	480
>  
> +#define UXGA_WIDTH	1600
> +#define UXGA_HEIGHT	1200
> +
> +#define XGA_WIDTH	1024
> +#define XGA_HEIGHT	768
> +
>  #endif /* _IMAGE_SIZES_H */

--
Regards,
Sylwester
