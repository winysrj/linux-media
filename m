Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:44430 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754202AbeFMDO5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 23:14:57 -0400
Subject: Re: [PATCH v3 9/9] xen/gntdev: Implement dma-buf import functionality
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180612134200.17456-1-andr2000@gmail.com>
 <20180612134200.17456-10-andr2000@gmail.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <b08fdccf-2f1b-a902-f00b-a4cecf44a1b1@oracle.com>
Date: Tue, 12 Jun 2018 23:14:42 -0400
MIME-Version: 1.0
In-Reply-To: <20180612134200.17456-10-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/12/2018 09:42 AM, Oleksandr Andrushchenko wrote:

>   int gntdev_dmabuf_imp_release(struct gntdev_dmabuf_priv *priv, u32 fd)
>   {
> -	return -EINVAL;
> +	struct gntdev_dmabuf *gntdev_dmabuf;
> +	struct dma_buf_attachment *attach;
> +	struct dma_buf *dma_buf;
> +
> +	gntdev_dmabuf = dmabuf_imp_find_unlink(priv, fd);
> +	if (IS_ERR(gntdev_dmabuf))
> +		return PTR_ERR(gntdev_dmabuf);
> +
> +	pr_debug("Releasing DMA buffer with fd %d\n", fd);
> +
> +	attach = gntdev_dmabuf->u.imp.attach;
> +
> +	if (gntdev_dmabuf->u.imp.sgt)
> +		dma_buf_unmap_attachment(attach, gntdev_dmabuf->u.imp.sgt,
> +					 DMA_BIDIRECTIONAL);
> +	dma_buf = attach->dmabuf;
> +	dma_buf_detach(attach->dmabuf, attach);
> +	dma_buf_put(dma_buf);
> +
> +	dmabuf_imp_end_foreign_access(gntdev_dmabuf->u.imp.refs,
> +				      gntdev_dmabuf->nr_pages);



Should you first end foreign access, before doing anything?

-boris


> +	dmabuf_imp_free_storage(gntdev_dmabuf);
> +	return 0;
>   }
>   
