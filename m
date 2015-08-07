Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47004 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1946357AbbHGXO4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Aug 2015 19:14:56 -0400
Date: Sat, 8 Aug 2015 02:14:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH RFC v2 01/16] media: Add some fields to store graph
 objects
Message-ID: <20150807231445.GA19840@valkosipuli.retiisi.org.uk>
References: <cover.1438954897.git.mchehab@osg.samsung.com>
 <a3c1d738a55bf2b3b34222125ab0b27de28cbcfb.1438954897.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3c1d738a55bf2b3b34222125ab0b27de28cbcfb.1438954897.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, Aug 07, 2015 at 11:19:59AM -0300, Mauro Carvalho Chehab wrote:
> We'll need unique IDs for graph objects and a way to associate
> them with the media interface.
> 
> So, add an atomic var to be used to create unique IDs and
> a list to store such objects.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 7b39440192d6..e627b0b905ad 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -396,6 +396,10 @@ int __must_check __media_device_register(struct media_device *mdev,
>  		return ret;
>  	}
>  
> +	/* Initialize media graph object list and ID */
> +	atomic_set(&mdev->last_obj_id, 0);
> +	INIT_LIST_HEAD(&mdev->object_list);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(__media_device_register);
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index 6e6db78f1ee2..a9d546716e49 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -78,6 +78,10 @@ struct media_device {
>  
>  	int (*link_notify)(struct media_link *link, u32 flags,
>  			   unsigned int notification);
> +
> +	/* Used by media_graph stuff */
> +	atomic_t last_obj_id;
> +	struct list_head object_list;
>  };
>  
>  /* Supported link_notify @notification values. */

Instead of starting with rework of the MC internals, what would you think of
separating interfaces from entities first, and see how that would be used by
a driver (e.g. DVB)? I think a simple linked list would do per entity, no
links would be needed at this point in the internal representation.

I'll review this better during the next week.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
