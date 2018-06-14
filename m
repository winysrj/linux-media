Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr00045.outbound.protection.outlook.com ([40.107.0.45]:54912
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752781AbeFNHAa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 03:00:30 -0400
Subject: Re: [PATCH v3 5/9] xen/gntdev: Allow mappings for DMA buffers
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com
References: <20180612134200.17456-1-andr2000@gmail.com>
 <20180612134200.17456-6-andr2000@gmail.com>
From: Oleksandr Andrushchenko <Oleksandr_Andrushchenko@epam.com>
Message-ID: <58836503-87be-2693-4665-4b0a55a170d3@epam.com>
Date: Thu, 14 Jun 2018 10:00:22 +0300
MIME-Version: 1.0
In-Reply-To: <20180612134200.17456-6-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

@@ -548,6 +632,17 @@ static int gntdev_open(struct inode *inode, struct 
file *flip)
>   	}
>   
>   	flip->private_data = priv;
> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
> +	priv->dma_dev = gntdev_miscdev.this_device;
> +
> +	/*
> +	 * The device is not spawn from a device tree, so arch_setup_dma_ops
> +	 * is not called, thus leaving the device with dummy DMA ops.
> +	 * Fix this call of_dma_configure() with a NULL node to set
> +	 * default DMA ops.
> +	 */
> +	of_dma_configure(priv->dma_dev, NULL);
Please note, that the code above will need a change while
applying to the mainline kernel because of API changes [1].
Unfortunately, current Xen tip kernel tree is v4.17-rc5 based,
so I cannot make the change in this patch now.

The change is trivial and requires:
-of_dma_configure(priv->dma_dev, NULL);
+of_dma_configure(priv->dma_dev, NULL, true);
> +#endif
>   	pr_debug("priv %p\n", priv);
>   
>   	return 0;
>
[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3d6ce86ee79465e1b1b6e287f8ea26b553fc768e
