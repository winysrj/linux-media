Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41842 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab2HPMw5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 08:52:57 -0400
Received: from eusync4.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8U00FFDMGYJE80@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Aug 2012 13:53:22 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0M8U00EGGMG60720@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Aug 2012 13:52:55 +0100 (BST)
Message-id: <502CED26.9010705@samsung.com>
Date: Thu, 16 Aug 2012 14:52:54 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	andrzej.p@samsung.com, patches@linaro.org
Subject: Re: [PATCH Trivial] [media] s5p-jpeg: Add missing braces around sizeof
References: <1345117978-3374-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1345117978-3374-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/16/2012 01:52 PM, Sachin Kamat wrote:
> Silences the following warning:
> WARNING: sizeof *ctx should be sizeof(*ctx)
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Thanks Sachin, I've added this to my tree for v3.7.

> ---
>  drivers/media/platform/s5p-jpeg/jpeg-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 72c3e52..ae916cd 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -288,7 +288,7 @@ static int s5p_jpeg_open(struct file *file)
>  	struct s5p_jpeg_fmt *out_fmt;
>  	int ret = 0;
>  
> -	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
> +	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
>  	if (!ctx)
>  		return -ENOMEM;

Regards,
Sylwester
