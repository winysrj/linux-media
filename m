Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46796 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab2IYNjN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 09:39:13 -0400
Received: from eusync4.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAW000DCR9WZ8B0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Sep 2012 14:39:32 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0MAW00DQLR9AT080@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Sep 2012 14:39:11 +0100 (BST)
Message-id: <5061B3FE.1030103@samsung.com>
Date: Tue, 25 Sep 2012 15:39:10 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	patches@linaro.org
Subject: Re: [PATCH] [media] s5p-fimc: Fix incorrect condition in
 fimc_lite_reqbufs()
References: <1348571944-7139-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1348571944-7139-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 09/25/2012 01:19 PM, Sachin Kamat wrote:
> When precedence rules are applied, the condition always evaluates
> to be false which was not the intention. Adding the missing braces
> for correct evaluation of the expression and subsequent functionality.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/media/platform/s5p-fimc/fimc-lite.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
> index 9289008..20e5e24 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-lite.c
> +++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
> @@ -825,7 +825,7 @@ static int fimc_lite_reqbufs(struct file *file, void *priv,
>  
>  	reqbufs->count = max_t(u32, FLITE_REQ_BUFS_MIN, reqbufs->count);
>  	ret = vb2_reqbufs(&fimc->vb_queue, reqbufs);
> -	if (!ret < 0)
> +	if (!(ret < 0))
>  		fimc->reqbufs_count = reqbufs->count;

Thanks for the catch. It looks like my search/replace oversight..
I think it's better to just make it

	if (!ret)
  		fimc->reqbufs_count = reqbufs->count;

Since this bug is relatively harmless I could queue it for v3.7, with the
above change if you are OK with that. Or would you like to resend this
patch with changed summary ?

>  
>  	return ret;

Regards,
Sylwester
