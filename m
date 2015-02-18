Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:38794 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751568AbbBRPnL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 10:43:11 -0500
Message-ID: <54E4B2F8.5090104@xs4all.nl>
Date: Wed, 18 Feb 2015 16:42:48 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 7/7] [media] cx231xx: enable the analog tuner at buffer
 setup
References: <110dcdca23da9714db1a2d95800abc4c9d33b512.1424273378.git.mchehab@osg.samsung.com> <8a2bc3b2e5bd4978d1c5252a88c950fa6029047f.1424273378.git.mchehab@osg.samsung.com>
In-Reply-To: <8a2bc3b2e5bd4978d1c5252a88c950fa6029047f.1424273378.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/18/2015 04:30 PM, Mauro Carvalho Chehab wrote:
> buf_prepare callback is called for every queued buffer. This is
> an overkill. Call it at buf_setup, as this should be enough.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
> index 87c9e27505f4..f9e885fa153f 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-video.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-video.c
> @@ -100,6 +100,75 @@ static struct cx231xx_fmt format[] = {
>  };
>  
>  
> +static int cx231xx_enable_analog_tuner(struct cx231xx *dev)
> +{
> +#ifdef CONFIG_MEDIA_CONTROLLER
> +	struct media_device *mdev = dev->media_dev;
> +	struct media_entity  *entity, *decoder = NULL, *source;
> +	struct media_link *link, *found_link = NULL;
> +	int i, ret, active_links = 0;
> +
> +	if (!mdev)
> +		return 0;
> +
> +	/*
> +	 * This will find the tuner that it is connected into the decoder.

s/that it is/that is/

> +	 * Technically, this is not 100% correct, as the device may be
> +	 * using an analog input instead of the tuner. However, as we can't
> +	 * do DVB streaming  while the DMA engine is being used for V4L2,

s/streaming  while/streaming while/

With those changes:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> +	 * this should be enough for the actual needs.
> +	 */
> +	media_device_for_each_entity(entity, mdev) {
> +		if (entity->type == MEDIA_ENT_T_V4L2_SUBDEV_DECODER) {
> +			decoder = entity;
> +			break;
> +		}
> +	}
> +	if (!decoder)
> +		return 0;
> +
> +	for (i = 0; i < decoder->num_links; i++) {
> +		link = &decoder->links[i];
> +		if (link->sink->entity == decoder) {
> +			found_link = link;
> +			if (link->flags & MEDIA_LNK_FL_ENABLED)
> +				active_links++;
> +			break;
> +		}
> +	}
> +
> +	if (active_links == 1 || !found_link)
> +		return 0;
> +
> +	source = found_link->source->entity;
> +	for (i = 0; i < source->num_links; i++) {
> +		struct media_entity *sink;
> +		int flags = 0;
> +
> +		link = &source->links[i];
> +		sink = link->sink->entity;
> +
> +		if (sink == entity)
> +			flags = MEDIA_LNK_FL_ENABLED;
> +
> +		ret = media_entity_setup_link(link, flags);
> +		if (ret) {
> +			dev_err(dev->dev,
> +				"Couldn't change link %s->%s to %s. Error %d\n",
> +				source->name, sink->name,
> +				flags ? "enabled" : "disabled",
> +				ret);
> +			return ret;
> +		} else
> +			dev_dbg(dev->dev,
> +				"link %s->%s was %s\n",
> +				source->name, sink->name,
> +				flags ? "ENABLED" : "disabled");
> +	}
> +#endif
> +	return 0;
> +}
> +
>  /* ------------------------------------------------------------------
>  	Video buffer and parser functions
>     ------------------------------------------------------------------*/
> @@ -667,6 +736,9 @@ buffer_setup(struct videobuf_queue *vq, unsigned int *count, unsigned int *size)
>  	if (*count < CX231XX_MIN_BUF)
>  		*count = CX231XX_MIN_BUF;
>  
> +
> +	cx231xx_enable_analog_tuner(dev);
> +
>  	return 0;
>  }
>  
> @@ -703,75 +775,6 @@ static void free_buffer(struct videobuf_queue *vq, struct cx231xx_buffer *buf)
>  	buf->vb.state = VIDEOBUF_NEEDS_INIT;
>  }
>  
> -static int cx231xx_enable_analog_tuner(struct cx231xx *dev)
> -{
> -#ifdef CONFIG_MEDIA_CONTROLLER
> -	struct media_device *mdev = dev->media_dev;
> -	struct media_entity  *entity, *decoder = NULL, *source;
> -	struct media_link *link, *found_link = NULL;
> -	int i, ret, active_links = 0;
> -
> -	if (!mdev)
> -		return 0;
> -
> -	/*
> -	 * This will find the tuner that it is connected into the decoder.
> -	 * Technically, this is not 100% correct, as the device may be
> -	 * using an analog input instead of the tuner. However, as we can't
> -	 * do DVB streaming  while the DMA engine is being used for V4L2,
> -	 * this should be enough for the actual needs.
> -	 */
> -	media_device_for_each_entity(entity, mdev) {
> -		if (entity->type == MEDIA_ENT_T_V4L2_SUBDEV_DECODER) {
> -			decoder = entity;
> -			break;
> -		}
> -	}
> -	if (!decoder)
> -		return 0;
> -
> -	for (i = 0; i < decoder->num_links; i++) {
> -		link = &decoder->links[i];
> -		if (link->sink->entity == decoder) {
> -			found_link = link;
> -			if (link->flags & MEDIA_LNK_FL_ENABLED)
> -				active_links++;
> -			break;
> -		}
> -	}
> -
> -	if (active_links == 1 || !found_link)
> -		return 0;
> -
> -	source = found_link->source->entity;
> -	for (i = 0; i < source->num_links; i++) {
> -		struct media_entity *sink;
> -		int flags = 0;
> -
> -		link = &source->links[i];
> -		sink = link->sink->entity;
> -
> -		if (sink == entity)
> -			flags = MEDIA_LNK_FL_ENABLED;
> -
> -		ret = media_entity_setup_link(link, flags);
> -		if (ret) {
> -			dev_err(dev->dev,
> -				"Couldn't change link %s->%s to %s. Error %d\n",
> -				source->name, sink->name,
> -				flags ? "enabled" : "disabled",
> -				ret);
> -			return ret;
> -		} else
> -			dev_dbg(dev->dev,
> -				"link %s->%s was %s\n",
> -				source->name, sink->name,
> -				flags ? "ENABLED" : "disabled");
> -	}
> -#endif
> -	return 0;
> -}
> -
>  static int
>  buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
>  	       enum v4l2_field field)
> @@ -826,8 +829,6 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
>  
>  	buf->vb.state = VIDEOBUF_PREPARED;
>  
> -	cx231xx_enable_analog_tuner(dev);
> -
>  	return 0;
>  
>  fail:
> 

