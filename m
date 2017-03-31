Return-path: <linux-media-owner@vger.kernel.org>
Received: from pegasos-out.vodafone.de ([80.84.1.38]:60501 "EHLO
        pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932879AbdCaMPk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 08:15:40 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by pegasos-out.vodafone.de (Rohrpostix2  Daemon) with ESMTP id 3A3FD680476
        for <linux-media@vger.kernel.org>; Fri, 31 Mar 2017 14:07:01 +0200 (CEST)
Received: from pegasos-out.vodafone.de ([127.0.0.1])
        by localhost (rohrpostix2.prod.vfnet.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vqxY6GoVDRzg for <linux-media@vger.kernel.org>;
        Fri, 31 Mar 2017 14:06:59 +0200 (CEST)
Subject: Re: [PATCH] dma-buf: fence debugging
To: Russell King <rmk+kernel@arm.linux.org.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>
References: <E1cttMI-00068z-3X@rmk-PC.armlinux.org.uk>
Cc: linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <deathsimple@vodafone.de>
Message-ID: <5174f966-74d0-64c0-a206-10216e0aaba6@vodafone.de>
Date: Fri, 31 Mar 2017 14:06:57 +0200
MIME-Version: 1.0
In-Reply-To: <E1cttMI-00068z-3X@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 31.03.2017 um 12:00 schrieb Russell King:
> Add debugfs output to report shared and exclusive fences on a dma_buf
> object.  This produces output such as:
>
> Dma-buf Objects:
> size    flags   mode    count   exp_name
> 08294400        00000000        00000005        00000005        drm
>          Exclusive fence: etnaviv 134000.gpu signalled
>          Attached Devices:
>          gpu-subsystem
> Total 1 devices attached
>
>
> Total 1 objects, 8294400 bytes
>
>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

Reviewed-by: Christian König <christian.koenig@amd.com>

> ---
>   drivers/dma-buf/dma-buf.c | 34 +++++++++++++++++++++++++++++++++-
>   1 file changed, 33 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 0007b792827b..f72aaacbe023 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -1059,7 +1059,11 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
>   	int ret;
>   	struct dma_buf *buf_obj;
>   	struct dma_buf_attachment *attach_obj;
> -	int count = 0, attach_count;
> +	struct reservation_object *robj;
> +	struct reservation_object_list *fobj;
> +	struct dma_fence *fence;
> +	unsigned seq;
> +	int count = 0, attach_count, shared_count, i;
>   	size_t size = 0;
>   
>   	ret = mutex_lock_interruptible(&db_list.lock);
> @@ -1085,6 +1090,34 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
>   				file_count(buf_obj->file),
>   				buf_obj->exp_name);
>   
> +		robj = buf_obj->resv;
> +		while (true) {
> +			seq = read_seqcount_begin(&robj->seq);
> +			rcu_read_lock();
> +			fobj = rcu_dereference(robj->fence);
> +			shared_count = fobj ? fobj->shared_count : 0;
> +			fence = rcu_dereference(robj->fence_excl);
> +			if (!read_seqcount_retry(&robj->seq, seq))
> +				break;
> +			rcu_read_unlock();
> +		}
> +
> +		if (fence)
> +			seq_printf(s, "\tExclusive fence: %s %s %ssignalled\n",
> +				   fence->ops->get_driver_name(fence),
> +				   fence->ops->get_timeline_name(fence),
> +				   dma_fence_is_signaled(fence) ? "" : "un");
> +		for (i = 0; i < shared_count; i++) {
> +			fence = rcu_dereference(fobj->shared[i]);
> +			if (!dma_fence_get_rcu(fence))
> +				continue;
> +			seq_printf(s, "\tShared fence: %s %s %ssignalled\n",
> +				   fence->ops->get_driver_name(fence),
> +				   fence->ops->get_timeline_name(fence),
> +				   dma_fence_is_signaled(fence) ? "" : "un");
> +		}
> +		rcu_read_unlock();
> +
>   		seq_puts(s, "\tAttached Devices:\n");
>   		attach_count = 0;
>   
