Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38781 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbbKWQZF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2015 11:25:05 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] [media] media-device: use unsigned ints on some places
Date: Mon, 23 Nov 2015 18:25:13 +0200
Message-ID: <1956249.nRu8zYf6B5@avalon>
In-Reply-To: <b1205852042ddb1aff6a53077e7e28d75fcb02c0.1441798267.git.mchehab@osg.samsung.com>
References: <cover.1441798267.git.mchehab@osg.samsung.com> <b1205852042ddb1aff6a53077e7e28d75fcb02c0.1441798267.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Wednesday 09 September 2015 08:32:03 Mauro Carvalho Chehab wrote:
> The entity->num_pads are defined as u16. So, better to use an
> unsigned int, as this prevents additional warnings when W=2
> (or W=1 on some architectures).
> 
> The "i" counter at __media_device_get_topology() is also a
> monotonic counter that should never be below zero. So,
> make it unsigned too.
> 
> Suggested-by: Sakari Ailus <sakari.ailus@iki.fi>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 13987710e5bc..1312e93ebd6e 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -243,7 +243,8 @@ static long __media_device_get_topology(struct
> media_device *mdev, struct media_v2_interface uintf;
>  	struct media_v2_pad upad;
>  	struct media_v2_link ulink;
> -	int ret = 0, i;
> +	int ret = 0;
> +	unsigned int i;

Very small nitpicking, I'd put the unsigned int i line before the int ret line 
to match the coding style of the rest of the file (with shorter variable 
declaration lines at the bottom).

> 
>  	topo->topology_version = mdev->topology_version;
> 
> @@ -613,7 +614,7 @@ EXPORT_SYMBOL_GPL(media_device_unregister);
>  int __must_check media_device_register_entity(struct media_device *mdev,
>  					      struct media_entity *entity)
>  {
> -	int i;
> +	unsigned int i;
> 
>  	if (entity->function == MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN ||
>  	    entity->function == MEDIA_ENT_F_UNKNOWN)
> @@ -650,9 +651,9 @@ EXPORT_SYMBOL_GPL(media_device_register_entity);
>   */
>  void media_device_unregister_entity(struct media_entity *entity)
>  {
> -	int i;
>  	struct media_device *mdev = entity->graph_obj.mdev;
>  	struct media_link *link, *tmp;
> +	unsigned int i;

Like you've done here, that's very good :-)

> 
>  	if (mdev == NULL)
>  		return;

With that fixed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

