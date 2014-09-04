Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3837 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaIDQVP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Sep 2014 12:21:15 -0400
Message-ID: <5408914B.5070701@xs4all.nl>
Date: Thu, 04 Sep 2014 18:20:27 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 2/3] [media] tw68: Remove a sparse warning
References: <ce9e1ac1b9becb9481f8492d9ccf713398a07ef8.1409841955.git.m.chehab@samsung.com> <fafeea3682cc2da98f05138ec4b1c8ebc6798b5d.1409841955.git.m.chehab@samsung.com>
In-Reply-To: <fafeea3682cc2da98f05138ec4b1c8ebc6798b5d.1409841955.git.m.chehab@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/04/2014 04:46 PM, Mauro Carvalho Chehab wrote:
> drivers/media/pci/tw68/tw68-video.c:351:9: warning: incorrect type in argument 1 (different base types)
> drivers/media/pci/tw68/tw68-video.c:351:9:    expected unsigned int [unsigned] val
> drivers/media/pci/tw68/tw68-video.c:351:9:    got restricted __le32 [usertype] <noident>
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

Nacked-by: Hans Verkuil <hverkuil@xs4all.nl>

tw_writel maps to writel which already does cpu_to_le32(), so doing it again is once
too many. I'll post a patch that removes the bogus cpu_to_le32().

	Hans

> 
> diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
> index 66fae2345fdd..4dd38578cf1b 100644
> --- a/drivers/media/pci/tw68/tw68-video.c
> +++ b/drivers/media/pci/tw68/tw68-video.c
> @@ -348,7 +348,7 @@ int tw68_video_start_dma(struct tw68_dev *dev, struct tw68_buf *buf)
>  	 *  a new address can be set.
>  	 */
>  	tw_clearl(TW68_DMAC, TW68_DMAP_EN);
> -	tw_writel(TW68_DMAP_SA, cpu_to_le32(buf->dma));
> +	tw_writel(TW68_DMAP_SA, (__force u32)cpu_to_le32(buf->dma));
>  	/* Clear any pending interrupts */
>  	tw_writel(TW68_INTSTAT, dev->board_virqmask);
>  	/* Enable the risc engine and the fifo */
> 

