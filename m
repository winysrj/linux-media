Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:46907 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933761AbdKQHDA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 02:03:00 -0500
Received: by mail-pg0-f65.google.com with SMTP id z184so1283626pgd.13
        for <linux-media@vger.kernel.org>; Thu, 16 Nov 2017 23:03:00 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [RFC v5 08/11] [media] vb2: add videobuf2 dma-buf fence helpers
Date: Fri, 17 Nov 2017 16:02:56 +0900
MIME-Version: 1.0
Message-ID: <a5b0e0e6-4912-4aec-ac6f-f7744a856d3d@chromium.org>
In-Reply-To: <20171115171057.17340-9-gustavo@padovan.org>
References: <20171115171057.17340-1-gustavo@padovan.org>
 <20171115171057.17340-9-gustavo@padovan.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, November 16, 2017 2:10:54 AM JST, Gustavo Padovan wrote:
> From: Javier Martinez Canillas <javier@osg.samsung.com>
>
> Add a videobuf2-fence.h header file that contains different helpers
> for DMA buffer sharing explicit fence support in videobuf2.
>
> v2:	- use fence context provided by the caller in vb2_fence_alloc()
>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  include/media/videobuf2-fence.h | 48 
> +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
>  create mode 100644 include/media/videobuf2-fence.h
>
> diff --git a/include/media/videobuf2-fence.h 
> b/include/media/videobuf2-fence.h
> new file mode 100644
> index 000000000000..b49cc1bf6bb4
> --- /dev/null
> +++ b/include/media/videobuf2-fence.h
> @@ -0,0 +1,48 @@
> +/*
> + * videobuf2-fence.h - DMA buffer sharing fence helpers for videobuf 2
> + *
> + * Copyright (C) 2016 Samsung Electronics
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation.
> + */
> +
> +#include <linux/dma-fence.h>
> +#include <linux/slab.h>
> +
> +static DEFINE_SPINLOCK(vb2_fence_lock);
> +
> +static inline const char *vb2_fence_get_driver_name(struct 
> dma_fence *fence)
> +{
> +	return "vb2_fence";
> +}
> +
> +static inline const char *vb2_fence_get_timeline_name(struct 
> dma_fence *fence)
> +{
> +	return "vb2_fence_timeline";
> +}
> +
> +static inline bool vb2_fence_enable_signaling(struct dma_fence *fence)
> +{
> +	return true;
> +}
> +
> +static const struct dma_fence_ops vb2_fence_ops = {
> +	.get_driver_name = vb2_fence_get_driver_name,
> +	.get_timeline_name = vb2_fence_get_timeline_name,
> +	.enable_signaling = vb2_fence_enable_signaling,
> +	.wait = dma_fence_default_wait,
> +};

It is probably not a good idea to define that struct here since it will be
deduplicated for every source file that includes it.

Maybe change it to a simple declaration, and move the definition to
videobuf2-core.c or a dedicated videobuf2-fence.c file?

> +
> +static inline struct dma_fence *vb2_fence_alloc(u64 context)
> +{
> +	struct dma_fence *vb2_fence = kzalloc(sizeof(*vb2_fence), GFP_KERNEL);
> +
> +	if (!vb2_fence)
> +		return NULL;
> +
> +	dma_fence_init(vb2_fence, &vb2_fence_ops, &vb2_fence_lock, context, 1);
> +
> +	return vb2_fence;
> +}

Not sure we gain a lot by having this function static inline, but your 
call.
