Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:59781 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757615AbcKDKFL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2016 06:05:11 -0400
Subject: Re: [PATCH] media: s5p-mfc include buffer size in error message
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <b1a9fa02-6821-7637-881c-a31719e891c9@samsung.com>
Date: Fri, 04 Nov 2016 11:05:02 +0100
MIME-version: 1.0
In-reply-to: <20161018004337.26831-1-shuahkh@osg.samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <20161018004337.26831-1-shuahkh@osg.samsung.com>
 <CGME20161104100504eucas1p196456ab351847ffabb60f51e76eab707@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/18/2016 02:43 AM, Shuah Khan wrote:
> Include buffer size in s5p_mfc_alloc_priv_buf() the error message when it
> fails to allocate the buffer. Remove the debug message that does the same.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_opr.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
> index 1e72502..eee16a1 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
> @@ -40,12 +40,11 @@ void s5p_mfc_init_regs(struct s5p_mfc_dev *dev)
>  int s5p_mfc_alloc_priv_buf(struct device *dev, dma_addr_t base,
>  					struct s5p_mfc_priv_buf *b)
>  {
> -	mfc_debug(3, "Allocating priv: %zu\n", b->size);

How about keeping this debug message, I think it would be useful
to leave that information in the debug logs.

>  	b->virt = dma_alloc_coherent(dev, b->size, &b->dma, GFP_KERNEL);
>  
>  	if (!b->virt) {
> -		mfc_err("Allocating private buffer failed\n");
> +		mfc_err("Allocating private buffer of size %zu failed\n",
> +			b->size);
>  		return -ENOMEM;
>  	}

--
Thanks,
Sylwester
