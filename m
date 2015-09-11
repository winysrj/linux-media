Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:43887 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752143AbbIKO7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 10:59:46 -0400
Message-ID: <55F2EC1A.10600@xs4all.nl>
Date: Fri, 11 Sep 2015 16:58:34 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 04/18] [media] media-device: supress backlinks at G_TOPOLOGY
 ioctl
References: <cover.1441559233.git.mchehab@osg.samsung.com> <7cc4f0ce2266e6300d349535e705941a190398e9.1441559233.git.mchehab@osg.samsung.com>
In-Reply-To: <7cc4f0ce2266e6300d349535e705941a190398e9.1441559233.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2015 07:30 PM, Mauro Carvalho Chehab wrote:
> Due to the graph traversal algorithm currently in usage, we
> need a copy of all data links. Those backlinks should not be
> send to userspace, as otherwise, all links there will be
> duplicated.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 0238885fcc74..97eb97d9b662 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -333,6 +333,9 @@ static long __media_device_get_topology(struct media_device *mdev,
>  	/* Get links and number of links */
>  	i = 0;
>  	media_device_for_each_link(link, mdev) {
> +		if (link->is_backlink)
> +			continue;
> +
>  		i++;
>  
>  		if (ret || !topo->links)
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index cd4d767644df..4868b8269204 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -648,6 +648,7 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
>  	backlink->source = &source->pads[source_pad];
>  	backlink->sink = &sink->pads[sink_pad];
>  	backlink->flags = flags;
> +	backlink->is_backlink = true;
>  
>  	/* Initialize graph object embedded at the new link */
>  	media_gobj_init(sink->graph_obj.mdev, MEDIA_GRAPH_LINK,
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index e1a89899deef..3d389f142a1d 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -96,6 +96,7 @@ struct media_pipeline {
>   * @reverse:	Pointer to the link for the reverse direction of a pad to pad
>   *		link.
>   * @flags:	Link flags, as defined at uapi/media.h (MEDIA_LNK_FL_*)
> + * @is_backlink: Indicate if the link is a backlink.
>   */
>  struct media_link {
>  	struct media_gobj graph_obj;
> @@ -112,6 +113,7 @@ struct media_link {
>  	};
>  	struct media_link *reverse;
>  	unsigned long flags;
> +	bool is_backlink;
>  };
>  
>  /**
> 

