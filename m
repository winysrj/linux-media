Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:20195 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbaE2NOz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 09:14:55 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N6C002ZA7GS3P10@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 29 May 2014 14:14:52 +0100 (BST)
Message-id: <538732D2.8020205@samsung.com>
Date: Thu, 29 May 2014 15:14:58 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
	Pawel Osciak <pawel@osciak.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] videobuf2-dma-contig: allow to vmap contiguous dma
 buffers
References: <1401113852-27318-1-git-send-email-p.zabel@pengutronix.de>
In-reply-to: <1401113852-27318-1-git-send-email-p.zabel@pengutronix.de>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2014-05-26 16:17, Philipp Zabel wrote:
> This allows drivers to vmap contiguous dma buffers so they can inspect the
> buffer contents with the CPU. This will be needed for the CODA driver's JPEG
> handling. On CODA960, the header parsing has to be done on the CPU. The
> hardware modules can only process the entropy coded segment after all
> registers and tables are set up.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-dma-contig.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index 880be07..6b254b8 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -98,6 +98,9 @@ static void *vb2_dc_vaddr(void *buf_priv)
>   {
>   	struct vb2_dc_buf *buf = buf_priv;
>   
> +	if (!buf->vaddr && buf->db_attach)
> +		buf->vaddr = dma_buf_vmap(buf->db_attach->dmabuf);
> +
>   	return buf->vaddr;
>   }
>   
> @@ -735,6 +738,7 @@ static int vb2_dc_map_dmabuf(void *mem_priv)
>   
>   	buf->dma_addr = sg_dma_address(sgt->sgl);
>   	buf->dma_sgt = sgt;
> +	buf->vaddr = NULL;
>   
>   	return 0;
>   }
> @@ -754,6 +758,10 @@ static void vb2_dc_unmap_dmabuf(void *mem_priv)
>   		return;
>   	}
>   
> +	if (buf->vaddr) {
> +		dma_buf_vunmap(buf->db_attach->dmabuf, buf->vaddr);
> +		buf->vaddr = NULL;
> +	}
>   	dma_buf_unmap_attachment(buf->db_attach, sgt, buf->dma_dir);
>   
>   	buf->dma_addr = 0;

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

