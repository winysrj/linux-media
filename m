Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33364 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756413AbeFOVCs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 17:02:48 -0400
Subject: Re: [PATCH v4 8/9] xen/gntdev: Implement dma-buf export functionality
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180615062753.9229-1-andr2000@gmail.com>
 <20180615062753.9229-9-andr2000@gmail.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <901a32b1-baae-7717-31f7-23bd31e23f05@oracle.com>
Date: Fri, 15 Jun 2018 17:02:23 -0400
MIME-Version: 1.0
In-Reply-To: <20180615062753.9229-9-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/15/2018 02:27 AM, Oleksandr Andrushchenko wrote:
> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>
> 1. Create a dma-buf from grant references provided by the foreign
>    domain. By default dma-buf is backed by system memory pages, but
>    by providing GNTDEV_DMA_FLAG_XXX flags it can also be created
>    as a DMA write-combine/coherent buffer, e.g. allocated with
>    corresponding dma_alloc_xxx API.
>    Export the resulting buffer as a new dma-buf.
>
> 2. Implement waiting for the dma-buf to be released: block until the
>    dma-buf with the file descriptor provided is released.
>    If within the time-out provided the buffer is not released then
>    -ETIMEDOUT error is returned. If the buffer with the file descriptor
>    does not exist or has already been released, then -ENOENT is
>    returned. For valid file descriptors this must not be treated as
>    error.
>
> 3. Make gntdev's common code and structures available to dma-buf.
>
> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>


Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
