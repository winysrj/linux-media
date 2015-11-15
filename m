Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33334 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751687AbbKOXDb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Nov 2015 18:03:31 -0500
Date: Mon, 16 Nov 2015 01:02:56 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: fix kernel hang in media_device_unregister()
 during device removal
Message-ID: <20151115230255.GZ17128@valkosipuli.retiisi.org.uk>
References: <1447339307-2838-1-git-send-email-shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1447339307-2838-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On Thu, Nov 12, 2015 at 07:41:47AM -0700, Shuah Khan wrote:
> Media core drivers (dvb, v4l2, bridge driver) unregister
> their entities calling media_device_unregister_entity()
> during device removal from their unregister paths. In
> addition media_device_unregister() tries to unregister
> entity calling media_device_unregister_entity() for each
> one of them. This adds lot of contention on mdev->lock in
> device removal sequence. Fix to not unregister entities
> from media_device_unregister(), and let drivers take care
> of it. Drivers need to unregister to cover the case of
> module removal. This patch fixes the problem by deleting
> the entity list walk to call media_device_unregister_entity()
> for each entity. With this fix there is no kernel hang after
> a sequence of device insertions followed by removal.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/media-device.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 1312e93..c7ab7c9 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -577,8 +577,6 @@ EXPORT_SYMBOL_GPL(__media_device_register);
>   */
>  void media_device_unregister(struct media_device *mdev)
>  {
> -	struct media_entity *entity;
> -	struct media_entity *next;
>  	struct media_link *link, *tmp_link;
>  	struct media_interface *intf, *tmp_intf;
>  
> @@ -596,9 +594,6 @@ void media_device_unregister(struct media_device *mdev)
>  		kfree(intf);
>  	}
>  
> -	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
> -		media_device_unregister_entity(entity);
> -
>  	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
>  	media_devnode_unregister(&mdev->devnode);
>  

media_device_unregister() is expected to clean up all the entities still
registered with it (as it does to links and interfaces). Could you share
details of the problems you saw in case you haven't found the actual
underlying issue causing them?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
