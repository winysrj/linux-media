Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58226 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932629AbcFQMxv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 08:53:51 -0400
Date: Fri, 17 Jun 2016 15:53:17 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Max Kellermann <max@duempel.org>
Cc: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] drivers/media/media-entity: clear media_gobj.mdev in
 _destroy()
Message-ID: <20160617125317.GF24980@valkosipuli.retiisi.org.uk>
References: <146602170216.9818.6967531646383934202.stgit@woodpecker.blarg.de>
 <146602170722.9818.9277146367995018321.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <146602170722.9818.9277146367995018321.stgit@woodpecker.blarg.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Max,

On Wed, Jun 15, 2016 at 10:15:07PM +0200, Max Kellermann wrote:
> media_gobj_destroy() may be called twice on one instance - once by
> media_device_unregister() and again by dvb_media_device_free().  The

Is that something that should really happen, and why? The same object should
not be unregistered more than once --- in many call paths gobj
unregistration is followed by kfree() on the gobj.

> function media_remove_intf_links() establishes and documents the
> convention that mdev==NULL means that the object is not registered,
> but nobody ever NULLs this variable.  So this patch really implements
> this behavior, and adds another mdev==NULL check to
> media_gobj_destroy() to protect against double removal.
> 
> Signed-off-by: Max Kellermann <max@duempel.org>
> ---
>  drivers/media/media-entity.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index d8a2299..9526338 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -203,10 +203,16 @@ void media_gobj_destroy(struct media_gobj *gobj)
>  {
>  	dev_dbg_obj(__func__, gobj);
>  
> +	/* Do nothing if the object is not linked. */
> +	if (gobj->mdev == NULL)
> +		return;
> +
>  	gobj->mdev->topology_version++;
>  
>  	/* Remove the object from mdev list */
>  	list_del(&gobj->list);
> +
> +	gobj->mdev = NULL;
>  }
>  
>  int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
> 

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
