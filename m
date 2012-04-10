Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:56551 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab2DJUsU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 16:48:20 -0400
Received: by wejx9 with SMTP id x9so137518wej.19
        for <linux-media@vger.kernel.org>; Tue, 10 Apr 2012 13:48:19 -0700 (PDT)
Message-ID: <4F849C91.6090504@gmail.com>
Date: Tue, 10 Apr 2012 22:48:17 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com,
	mchehab@redhat.com
Subject: Re: [PATCH 1/3] dma-buf: add vmap interface
References: <1334052691-5145-1-git-send-email-t.stanislaws@samsung.com> <1334052691-5145-2-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1334052691-5145-2-git-send-email-t.stanislaws@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/10/2012 12:11 PM, Tomasz Stanislawski wrote:
> From: Dave Airlie<airlied@redhat.com>
>
> Add vmap to dmabuf interface.
>
> Signed-off-by: Dave Airlie<airlied@redhat.com>
> ---
>   drivers/base/dma-buf.c  |   29 +++++++++++++++++++++++++++++
>   include/linux/dma-buf.h |   16 ++++++++++++++++
>   2 files changed, 45 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
> index 07cbbc6..3068258 100644
> --- a/drivers/base/dma-buf.c
> +++ b/drivers/base/dma-buf.c
> @@ -406,3 +406,32 @@ void dma_buf_kunmap(struct dma_buf *dmabuf, unsigned long page_num,
>   		dmabuf->ops->kunmap(dmabuf, page_num, vaddr);
>   }
>   EXPORT_SYMBOL_GPL(dma_buf_kunmap);
> +
> +/**
> + * dma_buf_vmap - Create virtual mapping for the buffer object into kernel address space. The same restrictions as for vmap and friends apply.
> + * @dma_buf:	[in]	buffer to vmap
> + *
> + * This call may fail due to lack of virtual mapping address space.
> + */
> +void *dma_buf_vmap(struct dma_buf *dmabuf)
> +{
> +	WARN_ON(!dmabuf);

How about replacing this with:

	if (WARN_ON(!dmabuf))
		return NULL;

to avoid null pointer dereference right below ?

> +	if (dmabuf->ops->vmap)
> +		return dmabuf->ops->vmap(dmabuf);
> +	return NULL;
> +}
> +EXPORT_SYMBOL(dma_buf_vmap);
> +
> +/**
> + * dma_buf_vunmap - Unmap a page obtained by dma_buf_vmap.
> + * @dma_buf:	[in]	buffer to vmap
> + */
> +void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
> +{
> +	WARN_ON(!dmabuf);

and here
	if (WARN_ON(!dmabuf))
		return;
?
> +	if (dmabuf->ops->vunmap)
> +		dmabuf->ops->vunmap(dmabuf, vaddr);
> +}
> +EXPORT_SYMBOL(dma_buf_vunmap);

--

Regards,
Sylwester
