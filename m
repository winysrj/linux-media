Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:42698 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752888AbbIKOA6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 10:00:58 -0400
Message-ID: <55F2DE52.6020906@xs4all.nl>
Date: Fri, 11 Sep 2015 15:59:46 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v8 48/55] [media] media_device: add a topology version
 field
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com> <d7db0184f4c44eb84f54417c560f3e15bfa40b1c.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <d7db0184f4c44eb84f54417c560f3e15bfa40b1c.1441540862.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2015 02:03 PM, Mauro Carvalho Chehab wrote:
> Every time a graph object is added or removed, the version
> of the topology changes. That's a requirement for the new
> MEDIA_IOC_G_TOPOLOGY, in order to allow userspace to know
> that the topology has changed after a previous call to it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 568553d41f5d..064515f2ba9b 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -185,6 +185,9 @@ void media_gobj_init(struct media_device *mdev,
>  		list_add_tail(&gobj->list, &mdev->interfaces);
>  		break;
>  	}
> +
> +	mdev->topology_version++;
> +
>  	dev_dbg_obj(__func__, gobj);
>  }
>  
> @@ -199,6 +202,8 @@ void media_gobj_remove(struct media_gobj *gobj)
>  {
>  	dev_dbg_obj(__func__, gobj);
>  
> +	gobj->mdev->topology_version++;
> +
>  	/* Remove the object from mdev list */
>  	list_del(&gobj->list);
>  }
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index 0d1b9c687454..1b12774a9ab4 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -41,6 +41,8 @@ struct device;
>   * @bus_info:	Unique and stable device location identifier
>   * @hw_revision: Hardware device revision
>   * @driver_version: Device driver version
> + * @topology_version: Monotonic counter for storing the version of the graph
> + *		topology. Should be incremented each time the topology changes.
>   * @entity_id:	Unique ID used on the last entity registered
>   * @pad_id:	Unique ID used on the last pad registered
>   * @link_id:	Unique ID used on the last link registered
> @@ -74,6 +76,8 @@ struct media_device {
>  	u32 hw_revision;
>  	u32 driver_version;
>  
> +	u32 topology_version;
> +
>  	u32 entity_id;
>  	u32 pad_id;
>  	u32 link_id;
> 

