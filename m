Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:51226 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbbAEFM2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Jan 2015 00:12:28 -0500
From: Tony K Nadackal <tony.kn@samsung.com>
To: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org
Cc: mchehab@osg.samsung.com, j.anaszewski@samsung.com,
	kgene@kernel.org, k.debski@samsung.com, s.nawrocki@samsung.com,
	bhushan.r@samsung.com, tony.kn@samsung.com
References: <1418800881-7428-1-git-send-email-tony.kn@samsung.com>
In-reply-to: <1418800881-7428-1-git-send-email-tony.kn@samsung.com>
Subject: RE: [PATCH] [media] s5p-jpeg: Initialize cb and cr to zero.
Date: Mon, 05 Jan 2015 10:43:08 +0530
Message-id: <000201d028a6$55a31e20$00e95a60$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-us
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gentle Reminder.

Thanks,
Tony

> -----Original Message-----
> From: Tony K Nadackal [mailto:tony.kn@samsung.com]
> Sent: Wednesday, December 17, 2014 12:51 PM
> To: linux-media@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> samsung-soc@vger.kernel.org
> Cc: mchehab@osg.samsung.com; j.anaszewski@samsung.com;
> kgene@kernel.org; k.debski@samsung.com; s.nawrocki@samsung.com;
> bhushan.r@samsung.com; Tony K Nadackal
> Subject: [PATCH] [media] s5p-jpeg: Initialize cb and cr to zero.
> 
> To avoid garbage value written into image base address planes, initialize cb
and cr
> of structure s5p_jpeg_addr to zero.
> 
> Signed-off-by: Tony K Nadackal <tony.kn@samsung.com>
> ---
> This patch is created and tested on top of linux-next-20141210.
> It can be cleanly applied on media-next and kgene/for-next.
> 
>  drivers/media/platform/s5p-jpeg/jpeg-core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 91bd3e6..54fa5d9 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -1845,6 +1845,9 @@ static void exynos4_jpeg_set_img_addr(struct
> s5p_jpeg_ctx *ctx)
>  	struct s5p_jpeg_addr jpeg_addr;
>  	u32 pix_size, padding_bytes = 0;
> 
> +	jpeg_addr.cb = 0;
> +	jpeg_addr.cr = 0;
> +
>  	pix_size = ctx->cap_q.w * ctx->cap_q.h;
> 
>  	if (ctx->mode == S5P_JPEG_ENCODE) {
> --
> 2.2.0

