Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:37291 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935905AbeE3GwK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 02:52:10 -0400
Subject: Re: [PATCH 5/8] xen/gntdev: Add initial support for dma-buf UAPI
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180525153331.31188-1-andr2000@gmail.com>
 <20180525153331.31188-6-andr2000@gmail.com>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <f9dbd6fb-b190-f7cb-244d-9768086accba@gmail.com>
Date: Wed, 30 May 2018 09:52:07 +0300
MIME-Version: 1.0
In-Reply-To: <20180525153331.31188-6-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/25/2018 06:33 PM, Oleksandr Andrushchenko wrote:
> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
> index 3431fe210624..eaf63a2c7ae6 100644
> --- a/drivers/xen/Kconfig
> +++ b/drivers/xen/Kconfig
> @@ -152,6 +152,16 @@ config XEN_GNTDEV
>   	help
>   	  Allows userspace processes to use grants.
>   
> +config XEN_GNTDEV_DMABUF
> +	bool "Add support for dma-buf grant access device driver extension"
> +	depends on XEN_GNTDEV && XEN_GRANT_DMA_ALLOC
This must be "depends on XEN_GNTDEV && XEN_GRANT_DMA_ALLOC && 
*DMA_SHARED_BUFFER*"
> +	help
> +	  Allows userspace processes and kernel modules to use Xen backed
> +	  dma-buf implementation. With this extension grant references to
> +	  the pages of an imported dma-buf can be exported for other domain
> +	  use and grant references coming from a foreign domain can be
> +	  converted into a local dma-buf for local export.
> +
>
