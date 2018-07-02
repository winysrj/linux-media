Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34876 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753092AbeGBHER (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 03:04:17 -0400
Subject: Re: [PATCH v4 8/9] xen/gntdev: Implement dma-buf export functionality
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180615062753.9229-1-andr2000@gmail.com>
 <20180615062753.9229-9-andr2000@gmail.com>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <31fdf7cc-6c57-6216-06b6-54471d873178@gmail.com>
Date: Mon, 2 Jul 2018 10:04:13 +0300
MIME-Version: 1.0
In-Reply-To: <20180615062753.9229-9-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

+
> +static const struct dma_buf_ops dmabuf_exp_ops =  {
> +	.attach = dmabuf_exp_ops_attach,
> +	.detach = dmabuf_exp_ops_detach,
> +	.map_dma_buf = dmabuf_exp_ops_map_dma_buf,
> +	.unmap_dma_buf = dmabuf_exp_ops_unmap_dma_buf,
> +	.release = dmabuf_exp_ops_release,
> +	.map = dmabuf_exp_ops_kmap,
> +	.map_atomic = dmabuf_exp_ops_kmap_atomic,
> +	.unmap = dmabuf_exp_ops_kunmap,
> +	.unmap_atomic = dmabuf_exp_ops_kunmap_atomic,
> +	.mmap = dmabuf_exp_ops_mmap,
> +};
> +
>
Due to upcoming API change [1] the atomic ops need to be removed before
merging into the mainline

[1] 
https://cgit.freedesktop.org/drm/drm-misc/commit/include/linux/dma-buf.h?id=f664a52695429b68afb4e130a0f69cd5fd1fec86
