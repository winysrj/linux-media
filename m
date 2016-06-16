Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38658 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbcFPQYC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jun 2016 12:24:02 -0400
Subject: Re: [PATCH 2/3] drivers/media/media-entity: clear media_gobj.mdev in
 _destroy()
To: Max Kellermann <max@duempel.org>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com
References: <146602170216.9818.6967531646383934202.stgit@woodpecker.blarg.de>
 <146602170722.9818.9277146367995018321.stgit@woodpecker.blarg.de>
Cc: linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <5762D2A0.605@osg.samsung.com>
Date: Thu, 16 Jun 2016 10:24:00 -0600
MIME-Version: 1.0
In-Reply-To: <146602170722.9818.9277146367995018321.stgit@woodpecker.blarg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/15/2016 02:15 PM, Max Kellermann wrote:
> media_gobj_destroy() may be called twice on one instance - once by
> media_device_unregister() and again by dvb_media_device_free().  The
> function media_remove_intf_links() establishes and documents the
> convention that mdev==NULL means that the object is not registered,
> but nobody ever NULLs this variable.  So this patch really implements
> this behavior, and adds another mdev==NULL check to
> media_gobj_destroy() to protect against double removal.

Are you seeing null pointer dereference on gobj->mdev? In any case,
we have to look at if there is a missing mutex hold that creates a
race between media_device_unregister() and dvb_media_device_free()

I don't this patch will solve the race condition.

thanks,
-- Shuah


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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

