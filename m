Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:47291 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab3FMLZL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jun 2013 07:25:11 -0400
From: Inki Dae <inki.dae@samsung.com>
To: 'Inki Dae' <inki.dae@samsung.com>, maarten.lankhorst@canonical.com,
	daniel@ffwll.ch, robdclark@gmail.com
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	yj44.cho@samsung.com
References: <1371112088-15310-1-git-send-email-inki.dae@samsung.com>
In-reply-to: <1371112088-15310-1-git-send-email-inki.dae@samsung.com>
Subject: RE: [RFC PATCH] dmabuf-sync: Introduce buffer synchronization framework
Date: Thu, 13 Jun 2013 20:25:08 +0900
Message-id: <02c201ce6828$a97bda90$fc738fb0$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> +static void dmabuf_sync_timeout_worker(struct work_struct *work)
> +{
> +	struct dmabuf_sync *sync = container_of(work, struct dmabuf_sync,
> work);
> +	struct dmabuf_sync_object *sobj;
> +
> +	mutex_lock(&sync->lock);
> +
> +	list_for_each_entry(sobj, &sync->syncs, head) {
> +		if (WARN_ON(!sobj->robj))
> +			continue;
> +
> +		printk(KERN_WARNING "%s: timeout = 0x%x [type = %d, " \
> +					"refcnt = %d, locked = %d]\n",
> +					sync->name, (u32)sobj->dmabuf,
> +					sobj->access_type,
> +
atomic_read(&sobj->robj->shared_cnt),
> +					sobj->robj->locked);
> +
> +		/* unlock only valid sync object. */
> +		if (!sobj->robj->locked)
> +			continue;
> +
> +		if (sobj->robj->shared &&
> +				atomic_read(&sobj->robj->shared_cnt) > 1) {
> +			atomic_dec(&sobj->robj->shared_cnt);
> +			continue;
> +		}
> +
> +		ww_mutex_unlock(&sobj->robj->lock);
> +
> +		if (sobj->access_type & DMA_BUF_ACCESS_READ)
> +			printk(KERN_WARNING "%s: r-unlocked = 0x%x\n",
> +					sync->name, (u32)sobj->dmabuf);
> +		else
> +			printk(KERN_WARNING "%s: w-unlocked = 0x%x\n",
> +					sync->name, (u32)sobj->dmabuf);
> +
> +#if defined(CONFIG_DEBUG_FS)
> +		sync_debugfs_timeout_cnt++;
> +#endif

Oops, unnecessary codes. will remove them.

