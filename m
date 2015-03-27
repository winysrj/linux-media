Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out4.electric.net ([192.162.216.181]:50585 "EHLO
	smtp-out4.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbbC0SUn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Mar 2015 14:20:43 -0400
Message-ID: <551565F6.5090909@ad-holdings.co.uk>
Date: Fri, 27 Mar 2015 14:15:18 +0000
From: Ian Molton <imolton@ad-holdings.co.uk>
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Kamil Debski <k.debski@samsung.com>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] [media] coda: drop dma_sync_single_for_device in coda_bitstream_queue
References: <1427301909-17640-1-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1427301909-17640-1-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/03/15 16:45, Philipp Zabel wrote:
> Issuing a cache flush for the whole bitstream buffer is not optimal in the first
> place when only a part of it was written. But given that the buffer is mapped in
> writecombine mode, it is not needed at all.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Tested-by: Ian Molton <imolton@ad-holdings.co.uk>

> ---
>   drivers/media/platform/coda/coda-bit.c | 4 ----
>   1 file changed, 4 deletions(-)
>
> diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
> index d39789d..d336cb6 100644
> --- a/drivers/media/platform/coda/coda-bit.c
> +++ b/drivers/media/platform/coda/coda-bit.c
> @@ -181,10 +181,6 @@ static int coda_bitstream_queue(struct coda_ctx *ctx,
>   	if (n < src_size)
>   		return -ENOSPC;
>
> -	dma_sync_single_for_device(&ctx->dev->plat_dev->dev,
> -				   ctx->bitstream.paddr, ctx->bitstream.size,
> -				   DMA_TO_DEVICE);
> -
>   	src_buf->v4l2_buf.sequence = ctx->qsequence++;
>
>   	return 0;
>

