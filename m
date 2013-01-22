Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:56124 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab3AVJ2U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 04:28:20 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MH000EX8SWK3G10@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Jan 2013 09:28:18 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MH000G8XSYK2F60@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 22 Jan 2013 09:28:18 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, patches@linaro.org
References: <1358830806-5610-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1358830806-5610-1-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH 1/1] [media] s5p-mfc: Use WARN_ON(condition) directly
Date: Tue, 22 Jan 2013 10:27:55 +0100
Message-id: <031301cdf882$c3ae7640$4b0b62c0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, 

Thanks for the patch.

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


> -----Original Message-----
> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> Sent: Tuesday, January 22, 2013 6:00 AM
> To: linux-media@vger.kernel.org
> Cc: k.debski@samsung.com; s.nawrocki@samsung.com;
> sachin.kamat@linaro.org; patches@linaro.org
> Subject: [PATCH 1/1] [media] s5p-mfc: Use WARN_ON(condition) directly
> 
> Use WARN_ON(condition) directly instead of wrapping around an if
> condition.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index b1d7f9a..37a17b8 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -596,8 +596,7 @@ static void s5p_mfc_handle_stream_complete(struct
> s5p_mfc_ctx *ctx,
> 
>  	clear_work_bit(ctx);
> 
> -	if (test_and_clear_bit(0, &dev->hw_lock) == 0)
> -		WARN_ON(1);
> +	WARN_ON(test_and_clear_bit(0, &dev->hw_lock) == 0);
> 
>  	s5p_mfc_clock_off();
>  	wake_up(&ctx->queue);
> --
> 1.7.4.1


