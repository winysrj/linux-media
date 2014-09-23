Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1630 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbaIWLJs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 07:09:48 -0400
Message-ID: <542154C7.1090802@xs4all.nl>
Date: Tue, 23 Sep 2014 13:08:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/2] [media] saa7134: Remove some casting warnings
References: <37b38486a1497804b63482af58a945f0eee8893f.1411469967.git.mchehab@osg.samsung.com>
In-Reply-To: <37b38486a1497804b63482af58a945f0eee8893f.1411469967.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/23/14 12:59, Mauro Carvalho Chehab wrote:
> drivers/media/pci/saa7134/saa7134-go7007.c:247:17: warning: incorrect type in argument 1 (different base types)
> drivers/media/pci/saa7134/saa7134-go7007.c:247:17:    expected unsigned int [unsigned] val
> drivers/media/pci/saa7134/saa7134-go7007.c:247:17:    got restricted __le32 [usertype] <noident>
> drivers/media/pci/saa7134/saa7134-go7007.c:252:17: warning: incorrect type in argument 1 (different base types)
> drivers/media/pci/saa7134/saa7134-go7007.c:252:17:    expected unsigned int [unsigned] val
> drivers/media/pci/saa7134/saa7134-go7007.c:252:17:    got restricted __le32 [usertype] <noident>
> drivers/media/pci/saa7134/saa7134-go7007.c:299:9: warning: incorrect type in argument 1 (different base types)
> drivers/media/pci/saa7134/saa7134-go7007.c:299:9:    expected unsigned int [unsigned] val
> drivers/media/pci/saa7134/saa7134-go7007.c:299:9:    got restricted __le32 [usertype] <noident>
> drivers/media/pci/saa7134/saa7134-go7007.c:300:9: warning: incorrect type in argument 1 (different base types)
> drivers/media/pci/saa7134/saa7134-go7007.c:300:9:    expected unsigned int [unsigned] val
> drivers/media/pci/saa7134/saa7134-go7007.c:300:9:    got restricted __le32 [usertype] <noident>
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/drivers/media/pci/saa7134/saa7134-go7007.c b/drivers/media/pci/saa7134/saa7134-go7007.c
> index 3e9ca4821b8c..d9af6f3dc8af 100644
> --- a/drivers/media/pci/saa7134/saa7134-go7007.c
> +++ b/drivers/media/pci/saa7134/saa7134-go7007.c
> @@ -244,12 +244,12 @@ static void saa7134_go7007_irq_ts_done(struct saa7134_dev *dev,
>  		dma_sync_single_for_cpu(&dev->pci->dev,
>  					saa->bottom_dma, PAGE_SIZE, DMA_FROM_DEVICE);
>  		go7007_parse_video_stream(go, saa->bottom, PAGE_SIZE);
> -		saa_writel(SAA7134_RS_BA2(5), cpu_to_le32(saa->bottom_dma));
> +		saa_writel(SAA7134_RS_BA2(5), (__force u32)cpu_to_le32(saa->bottom_dma));

saa_writel is a define for writel, which already does cpu_to_le32. So the correct
solution is to drop the cpu_to_le32 entirely.

I should have seen that.

Will you update your patch or shall I repost my patch with this fix included?

Regards,

	Hans

>  	} else {
>  		dma_sync_single_for_cpu(&dev->pci->dev,
>  					saa->top_dma, PAGE_SIZE, DMA_FROM_DEVICE);
>  		go7007_parse_video_stream(go, saa->top, PAGE_SIZE);
> -		saa_writel(SAA7134_RS_BA1(5), cpu_to_le32(saa->top_dma));
> +		saa_writel(SAA7134_RS_BA1(5), (__force u32)cpu_to_le32(saa->top_dma));
>  	}
>  }
>  
> @@ -296,8 +296,8 @@ static int saa7134_go7007_stream_start(struct go7007 *go)
>  	/* Enable video streaming mode */
>  	saa_writeb(SAA7134_GPIO_GPSTATUS2, GPIO_COMMAND_VIDEO);
>  
> -	saa_writel(SAA7134_RS_BA1(5), cpu_to_le32(saa->top_dma));
> -	saa_writel(SAA7134_RS_BA2(5), cpu_to_le32(saa->bottom_dma));
> +	saa_writel(SAA7134_RS_BA1(5), (__force u32)cpu_to_le32(saa->top_dma));
> +	saa_writel(SAA7134_RS_BA2(5), (__force u32)cpu_to_le32(saa->bottom_dma));
>  	saa_writel(SAA7134_RS_PITCH(5), 128);
>  	saa_writel(SAA7134_RS_CONTROL(5), SAA7134_RS_CONTROL_BURST_MAX);
>  
> 

