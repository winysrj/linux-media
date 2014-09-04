Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:51332 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaIDOzQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Sep 2014 10:55:16 -0400
Message-ID: <54087D2E.806@cisco.com>
Date: Thu, 04 Sep 2014 16:54:38 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 2/3] [media] tw68: Remove a sparse warning
References: <ce9e1ac1b9becb9481f8492d9ccf713398a07ef8.1409841955.git.m.chehab@samsung.com> <fafeea3682cc2da98f05138ec4b1c8ebc6798b5d.1409841955.git.m.chehab@samsung.com>
In-Reply-To: <fafeea3682cc2da98f05138ec4b1c8ebc6798b5d.1409841955.git.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'll need to review this as well. Perhaps tw_writel should expect a __le32?

	Hans

On 09/04/14 16:46, Mauro Carvalho Chehab wrote:
> drivers/media/pci/tw68/tw68-video.c:351:9: warning: incorrect type in argument 1 (different base types)
> drivers/media/pci/tw68/tw68-video.c:351:9:    expected unsigned int [unsigned] val
> drivers/media/pci/tw68/tw68-video.c:351:9:    got restricted __le32 [usertype] <noident>
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
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
