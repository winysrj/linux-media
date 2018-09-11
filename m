Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34130 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbeIKOeO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 10:34:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: dri-devel@lists.freedesktop.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] udmabuf: sort headers, drop uapi/ path prefix
Date: Tue, 11 Sep 2018 12:35:55 +0300
Message-ID: <2525961.SbzEzdfdcR@avalon>
In-Reply-To: <20180911065921.23818-2-kraxel@redhat.com>
References: <20180911065921.23818-1-kraxel@redhat.com> <20180911065921.23818-2-kraxel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gerd,

Thank you for the patch.

On Tuesday, 11 September 2018 09:59:12 EEST Gerd Hoffmann wrote:
> Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  drivers/dma-buf/udmabuf.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
> index 2e8502250a..e63d301bcb 100644
> --- a/drivers/dma-buf/udmabuf.c
> +++ b/drivers/dma-buf/udmabuf.c
> @@ -1,17 +1,16 @@
>  // SPDX-License-Identifier: GPL-2.0
> -#include <linux/init.h>
> -#include <linux/module.h>
> +#include <linux/cred.h>
>  #include <linux/device.h>
> -#include <linux/kernel.h>
> -#include <linux/slab.h>
> -#include <linux/miscdevice.h>
>  #include <linux/dma-buf.h>
>  #include <linux/highmem.h>
> -#include <linux/cred.h>
> -#include <linux/shmem_fs.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
>  #include <linux/memfd.h>
> -
> -#include <uapi/linux/udmabuf.h>
> +#include <linux/miscdevice.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/shmem_fs.h>

Nearly there, l comes after h :-)

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> +#include <linux/udmabuf.h>
> 
>  struct udmabuf {
>  	u32 pagecount;


-- 
Regards,

Laurent Pinchart
