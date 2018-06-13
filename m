Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:59380 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933693AbeFMBtr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 21:49:47 -0400
Subject: Re: [PATCH v3 7/9] xen/gntdev: Add initial support for dma-buf UAPI
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180612134200.17456-1-andr2000@gmail.com>
 <20180612134200.17456-8-andr2000@gmail.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <916e91c9-0710-0afb-2f49-4a7c7b4c02b5@oracle.com>
Date: Tue, 12 Jun 2018 21:49:34 -0400
MIME-Version: 1.0
In-Reply-To: <20180612134200.17456-8-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/12/2018 09:41 AM, Oleksandr Andrushchenko wrote:

> diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
> index a09db23e9663..e82660d81d7e 100644
> --- a/drivers/xen/gntdev.c
> +++ b/drivers/xen/gntdev.c
> @@ -48,6 +48,9 @@
>   #include <asm/xen/hypercall.h>
>   
>   #include "gntdev-common.h"
> +#ifdef CONFIG_XEN_GNTDEV_DMABUF
> +#include "gntdev-dmabuf.h"
> +#endif
>   
>   MODULE_LICENSE("GPL");
>   MODULE_AUTHOR("Derek G. Murray <Derek.Murray@cl.cam.ac.uk>, "
> @@ -566,6 +569,15 @@ static int gntdev_open(struct inode *inode, struct file *flip)
>   	INIT_LIST_HEAD(&priv->freeable_maps);
>   	mutex_init(&priv->lock);
>   
> +#ifdef CONFIG_XEN_GNTDEV_DMABUF
> +	priv->dmabuf_priv = gntdev_dmabuf_init();
> +	if (IS_ERR(priv->dmabuf_priv)) {
> +		ret = PTR_ERR(priv->dmabuf_priv);
> +		kfree(priv);
> +		return ret;
> +	}
> +#endif
> +
>   	if (use_ptemod) {
>   		priv->mm = get_task_mm(current);
>   		if (!priv->mm) {
> @@ -616,8 +628,13 @@ static int gntdev_release(struct inode *inode, struct file *flip)
>   	WARN_ON(!list_empty(&priv->freeable_maps));
>   	mutex_unlock(&priv->lock);
>   
> +#ifdef CONFIG_XEN_GNTDEV_DMABUF
> +	gntdev_dmabuf_fini(priv->dmabuf_priv);
> +#endif
> +
>   	if (use_ptemod)
>   		mmu_notifier_unregister(&priv->mn, priv->mm);
> +
>   	kfree(priv);
>   	return 0;
>   }
> @@ -987,6 +1004,107 @@ static long gntdev_ioctl_grant_copy(struct gntdev_priv *priv, void __user *u)
>   	return ret;
>   }
>   
> +#ifdef CONFIG_XEN_GNTDEV_DMABUF
> +static long
> +gntdev_ioctl_dmabuf_exp_from_refs(struct gntdev_priv *priv,
> +				  struct ioctl_gntdev_dmabuf_exp_from_refs __user *u)


Didn't we agree that this code moves to gntdev-dmabuf.c ?

-boris
