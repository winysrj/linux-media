Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53774 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbbKLQPr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2015 11:15:47 -0500
Subject: Re: [PATCH] media: fix kernel hang in media_device_unregister()
 during device removal
To: mchehab@osg.samsung.com
References: <1447339307-2838-1-git-send-email-shuahkh@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <5644BB31.4010205@osg.samsung.com>
Date: Thu, 12 Nov 2015 09:15:45 -0700
MIME-Version: 1.0
In-Reply-To: <1447339307-2838-1-git-send-email-shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/2015 07:41 AM, Shuah Khan wrote:
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

This is MC Next Gen patch mc_next_gen.v8.4 branch
Sorry I forgot to tag it

-- Shuah

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
> 


-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
