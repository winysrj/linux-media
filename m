Return-path: <linux-media-owner@vger.kernel.org>
Received: from pegasos-out.vodafone.de ([80.84.1.38]:34920 "EHLO
        pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752484AbdBUOGG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 09:06:06 -0500
Subject: Re: [PATCH] dma-buf: add support for compat ioctl
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <CGME20170221132114eucas1p2e527d5b5516494ba54aa91f48b3e227f@eucas1p2.samsung.com>
 <1487683261-2655-1-git-send-email-m.szyprowski@samsung.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <deathsimple@vodafone.de>
Message-ID: <917aff70-64f7-7224-a015-0e77951bbc1d@vodafone.de>
Date: Tue, 21 Feb 2017 14:59:18 +0100
MIME-Version: 1.0
In-Reply-To: <1487683261-2655-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 21.02.2017 um 14:21 schrieb Marek Szyprowski:
> Add compat ioctl support to dma-buf. This lets one to use DMA_BUF_IOCTL_SYNC
> ioctl from 32bit application on 64bit kernel. Data structures for both 32
> and 64bit modes are same, so there is no need for additional translation
> layer.

Well I might be wrong, but IIRC compat_ioctl was just optional and if 
not specified unlocked_ioctl was called instead.

If that is true your patch wouldn't have any effect at all.

Regards,
Christian.

>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>   drivers/dma-buf/dma-buf.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 718f832a5c71..0007b792827b 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -325,6 +325,9 @@ static long dma_buf_ioctl(struct file *file,
>   	.llseek		= dma_buf_llseek,
>   	.poll		= dma_buf_poll,
>   	.unlocked_ioctl	= dma_buf_ioctl,
> +#ifdef CONFIG_COMPAT
> +	.compat_ioctl	= dma_buf_ioctl,
> +#endif
>   };
>   
>   /*
