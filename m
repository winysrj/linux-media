Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58632 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbcBSODs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2016 09:03:48 -0500
Date: Fri, 19 Feb 2016 12:03:41 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/5] media: Always keep a graph walk large enough
 around
Message-ID: <20160219120341.076478ef@recife.lan>
In-Reply-To: <1453906078-29087-3-git-send-email-sakari.ailus@iki.fi>
References: <1453906078-29087-1-git-send-email-sakari.ailus@iki.fi>
	<1453906078-29087-3-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Em Wed, 27 Jan 2016 16:47:55 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Re-create the graph walk object as needed in order to have one large enough
> available for all entities in the graph.
> 
> This enumeration is used for pipeline power management in the future.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/media-device.c | 21 +++++++++++++++++++++
>  include/media/media-device.h |  5 +++++
>  2 files changed, 26 insertions(+)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 4d1c13d..52d7809 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -577,6 +577,26 @@ int __must_check media_device_register_entity(struct media_device *mdev,
>  
>  	spin_unlock(&mdev->lock);
>  
> +	mutex_lock(&mdev->graph_mutex);
> +	if (mdev->entity_internal_idx_max
> +	    >= mdev->pm_count_walk.ent_enum.idx_max) {
> +		struct media_entity_graph new = { 0 };
> +
> +		/*
> +		 * Initialise the new graph walk before cleaning up
> +		 * the old one in order not to spoil the graph walk
> +		 * object of the media device if graph walk init fails.
> +		 */
> +		ret = media_entity_graph_walk_init(&new, mdev);
> +		if (ret) {
> +			mutex_unlock(&mdev->graph_mutex);
> +			return ret;
> +		}
> +		media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
> +		mdev->pm_count_walk = new;
> +	}
> +	mutex_unlock(&mdev->graph_mutex);
> +

I don't like the idea of creating a new graph init and destroying the
previous one every time. In principle, this needs to be done only
when trying to start the graph - or just before registering the
MC devnode, if the driver needs/wants to optimize it.

As kbuildtest also didn't like this patch, I'm not applying it
for now.

>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(media_device_register_entity);
> @@ -652,6 +672,7 @@ void media_device_cleanup(struct media_device *mdev)
>  {
>  	ida_destroy(&mdev->entity_internal_idx);
>  	mdev->entity_internal_idx_max = 0;
> +	media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
>  	mutex_destroy(&mdev->graph_mutex);
>  }
>  EXPORT_SYMBOL_GPL(media_device_cleanup);
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index d385589..dba3986 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -323,6 +323,11 @@ struct media_device {
>  	spinlock_t lock;
>  	/* Serializes graph operations. */
>  	struct mutex graph_mutex;
> +	/*
> +	 * Graph walk for power state walk. Access serialised using
> +	 * graph_mutex.
> +	 */
> +	struct media_entity_graph pm_count_walk;
>  
>  	int (*link_notify)(struct media_link *link, u32 flags,
>  			   unsigned int notification);


-- 
Thanks,
Mauro
