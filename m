Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46144 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab2DQA5A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 20:57:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH v4 11/14] v4l: vb2-dma-contig: add support for dma_buf importing
Date: Tue, 17 Apr 2012 02:57:10 +0200
Message-ID: <1933889.sK9pAxfEdI@avalon>
In-Reply-To: <1334332076-28489-12-git-send-email-t.stanislaws@samsung.com>
References: <1334332076-28489-1-git-send-email-t.stanislaws@samsung.com> <1334332076-28489-12-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Friday 13 April 2012 17:47:53 Tomasz Stanislawski wrote:
> From: Sumit Semwal <sumit.semwal@ti.com>
> 
> This patch makes changes for adding dma-contig as a dma_buf user. It
> provides function implementations for the {attach, detach, map,
> unmap}_dmabuf() mem_ops of DMABUF memory type.
> 
> Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
> 	[author of the original patch]
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> 	[integration with refactored dma-contig allocator]

Pending the comment below,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +static void vb2_dc_detach_dmabuf(void *mem_priv)
> +{
> +	struct vb2_dc_buf *buf = mem_priv;
> +
> +	if (WARN_ON(buf->dma_addr))
> +		vb2_dc_unmap_dmabuf(buf);

This should never happen, and would be a videobuf2 bug otherwise, right ?

> +
> +	/* detach this attachment */
> +	dma_buf_detach(buf->db_attach->dmabuf, buf->db_attach);
> +	kfree(buf);
> +}

-- 
Regards,

Laurent Pinchart

