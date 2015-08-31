Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:50383 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752374AbbHaLwu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 07:52:50 -0400
Message-ID: <55E43FDA.7030407@xs4all.nl>
Date: Mon, 31 Aug 2015 13:51:54 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v8 43/55] [media] media: report if a pad is sink or source
 at debug msg
References: <cover.1440902901.git.mchehab@osg.samsung.com> <e1e261997cc156eb6f6839944431fb6dba0c814a.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <e1e261997cc156eb6f6839944431fb6dba0c814a.1440902901.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2015 05:06 AM, Mauro Carvalho Chehab wrote:
> Sometimes, it is important to see if the created pad is
> sink or source. Add info to track that.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> index f638c67defbe..610d2bab1368 100644
> --- a/drivers/media/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb-core/dvbdev.c
> @@ -528,8 +528,8 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
>  	struct media_entity *entity, *tuner = NULL, *demod = NULL;
>  	struct media_entity *demux = NULL, *ca = NULL;
>  	struct media_interface *intf;
> -	unsigned demux_pad = 1;
> -	unsigned dvr_pad = 1;
> +	unsigned demux_pad = 0;
> +	unsigned dvr_pad = 0;
>  
>  	if (!mdev)
>  		return;
> @@ -561,15 +561,19 @@ void dvb_create_media_graph(struct dvb_adapter *adap)
>  
>  	/* Create demux links for each ringbuffer/pad */
>  	if (demux) {
> -		if (entity->type == MEDIA_ENT_T_DVB_TSOUT) {
> -			if (!strncmp(entity->name, DVR_TSOUT,
> -				     sizeof(DVR_TSOUT)))
> -				media_create_pad_link(demux, ++dvr_pad,
> -						      entity, 0, 0);
> -			if (!strncmp(entity->name, DEMUX_TSOUT,
> -				     sizeof(DEMUX_TSOUT)))
> -				media_create_pad_link(demux, ++demux_pad,
> -						      entity, 0, 0);
> +		media_device_for_each_entity(entity, mdev) {
> +			if (entity->type == MEDIA_ENT_T_DVB_TSOUT) {
> +				if (!strncmp(entity->name, DVR_TSOUT,
> +					strlen(DVR_TSOUT)))
> +					media_create_pad_link(demux,
> +							      ++dvr_pad,
> +							entity, 0, 0);
> +				if (!strncmp(entity->name, DEMUX_TSOUT,
> +					strlen(DEMUX_TSOUT)))
> +					media_create_pad_link(demux,
> +							      ++demux_pad,
> +							entity, 0, 0);
> +			}
>  		}
>  	}
>  

Does this chunk belong here? I'd expect this in the previous patch or in a
patch on its own.

> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 15bc92d3a648..d62a6ffbc929 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -121,8 +121,11 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
>  		struct media_pad *pad = gobj_to_pad(gobj);
>  
>  		dev_dbg(gobj->mdev->dev,
> -			"%s: id 0x%08x pad#%d: '%s':%d\n",
> -			event_name, gobj->id, media_localid(gobj),
> +			"%s: id 0x%08x %s%spad#%d: '%s':%d\n",
> +			event_name, gobj->id,
> +			pad->flags & MEDIA_PAD_FL_SINK   ? "  sink " : "",
> +			pad->flags & MEDIA_PAD_FL_SOURCE ? "source " : "",
> +			media_localid(gobj),
>  			pad->entity->name, pad->index);
>  		break;
>  	}
> 

Regards,

	Hans
