Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:39741 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935154AbdLRTSs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 14:18:48 -0500
Received: by mail-oi0-f67.google.com with SMTP id r63so11315274oia.6
        for <linux-media@vger.kernel.org>; Mon, 18 Dec 2017 11:18:48 -0800 (PST)
Subject: Re: [PATCH] staging: android: ion: Fix dma direction for
 dma_sync_sg_for_cpu/device
To: Sushmita Susheelendra <ssusheel@codeaurora.org>
Cc: sumit.semwal@linaro.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, devel@driverdev.osuosl.org,
        linux-media@vger.kernel.org, Liam Mark <lmark@codeaurora.org>
References: <1513371553-24774-1-git-send-email-ssusheel@codeaurora.org>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <5821c2b1-c3ee-5081-33b9-cca1257f9541@redhat.com>
Date: Mon, 18 Dec 2017 11:18:45 -0800
MIME-Version: 1.0
In-Reply-To: <1513371553-24774-1-git-send-email-ssusheel@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/15/2017 12:59 PM, Sushmita Susheelendra wrote:
> Use the direction argument passed into begin_cpu_access
> and end_cpu_access when calling the dma_sync_sg_for_cpu/device.
> The actual cache primitive called depends on the direction
> passed in.
> 

Acked-by: Laura Abbott <labbott@redhat.com>

> Signed-off-by: Sushmita Susheelendra <ssusheel@codeaurora.org>
> ---
>   drivers/staging/android/ion/ion.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
> index a7d9b0e..f480885 100644
> --- a/drivers/staging/android/ion/ion.c
> +++ b/drivers/staging/android/ion/ion.c
> @@ -346,7 +346,7 @@ static int ion_dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
>   	mutex_lock(&buffer->lock);
>   	list_for_each_entry(a, &buffer->attachments, list) {
>   		dma_sync_sg_for_cpu(a->dev, a->table->sgl, a->table->nents,
> -				    DMA_BIDIRECTIONAL);
> +				    direction);
>   	}
>   	mutex_unlock(&buffer->lock);
>   
> @@ -368,7 +368,7 @@ static int ion_dma_buf_end_cpu_access(struct dma_buf *dmabuf,
>   	mutex_lock(&buffer->lock);
>   	list_for_each_entry(a, &buffer->attachments, list) {
>   		dma_sync_sg_for_device(a->dev, a->table->sgl, a->table->nents,
> -				       DMA_BIDIRECTIONAL);
> +				       direction);
>   	}
>   	mutex_unlock(&buffer->lock);
>   
> 
