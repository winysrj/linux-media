Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60483 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932259AbbBPLTQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 06:19:16 -0500
Date: Mon, 16 Feb 2015 09:19:10 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: Re: [PATCHv4 24/25] [media] cx231xx: enable tuner->decoder link at
 videobuf start
Message-ID: <20150216091910.26f01813@recife.lan>
In-Reply-To: <54E1B7F3.60504@xs4all.nl>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
	<f27ba253fe46ff3e8bd592e77657191a33f1a39d.1423867976.git.mchehab@osg.samsung.com>
	<54E1B7F3.60504@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 16 Feb 2015 10:27:15 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 02/13/2015 11:58 PM, Mauro Carvalho Chehab wrote:
> > The tuner->decoder needs to be enabled when we're about to
> > start streaming.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
> > index f3d1a488dfa7..634763535d60 100644
> > --- a/drivers/media/usb/cx231xx/cx231xx-video.c
> > +++ b/drivers/media/usb/cx231xx/cx231xx-video.c
> > @@ -703,6 +703,74 @@ static void free_buffer(struct videobuf_queue *vq, struct cx231xx_buffer *buf)
> >  	buf->vb.state = VIDEOBUF_NEEDS_INIT;
> >  }
> >  
> > +static int cx231xx_enable_analog_tuner(struct cx231xx *dev)
> > +{
> > +#ifdef CONFIG_MEDIA_CONTROLLER
> > +	struct media_device *mdev = dev->media_dev;
> > +	struct media_entity  *entity, *decoder = NULL, *source;
> > +	struct media_link *link, *found_link = NULL;
> > +	int i, ret, active_links = 0;
> > +
> > +	if (!mdev)
> > +		return 0;
> > +
> > +/*
> > + * This will find the tuner that it is connected into the decoder.
> > + * Technically, this is not 100% correct, as the device may be using an
> > + * analog input instead of the tuner. However, we can't use the DVB for dvb
> 
> 'we can't use the DVB for dvb'?? You probably mean 'can't use the DVB API'.

What I meant to say is that we can't use the device for DVB while it is
doing an analog stream.

I'll fix this on a separate patch.

> > + * while the DMA engine is being used for V4L2.
> > + */
> 
> Weird indentation, should be one to the right.

Ah, true. I'll fix this too.

> > +	media_device_for_each_entity(entity, mdev) {
> > +		if (entity->type == MEDIA_ENT_T_V4L2_SUBDEV_DECODER) {
> > +			decoder = entity;
> > +			break;
> > +		}
> > +	}
> > +	if (!decoder)
> > +		return 0;
> > +
> > +	for (i = 0; i < decoder->num_links; i++) {
> > +		link = &decoder->links[i];
> > +		if (link->sink->entity == decoder) {
> > +			found_link = link;
> > +			if (link->flags & MEDIA_LNK_FL_ENABLED)
> > +				active_links++;
> > +			break;
> > +		}
> > +	}
> > +
> > +	if (active_links == 1 || !found_link)
> > +		return 0;
> > +
> > +	source = found_link->source->entity;
> > +	for (i = 0; i < source->num_links; i++) {
> > +		struct media_entity *sink;
> > +		int flags = 0;
> > +
> > +		link = &source->links[i];
> > +		sink = link->sink->entity;
> > +
> > +		if (sink == entity)
> > +			flags = MEDIA_LNK_FL_ENABLED;
> > +
> > +		ret = media_entity_setup_link(link, flags);
> > +		if (ret) {
> > +			dev_err(dev->dev,
> > +				"Couldn't change link %s->%s to %s. Error %d\n",
> > +				source->name, sink->name,
> > +				flags ? "enabled" : "disabled",
> > +				ret);
> > +			return ret;
> > +		} else
> > +			dev_dbg(dev->dev,
> > +				"link %s->%s was %s\n",
> > +				source->name, sink->name,
> > +				flags ? "ENABLED" : "disabled");
> > +	}
> > +#endif
> > +	return 0;
> > +}
> > +
> >  static int
> >  buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
> >  	       enum v4l2_field field)
> > @@ -756,6 +824,9 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
> >  	}
> >  
> >  	buf->vb.state = VIDEOBUF_PREPARED;
> > +
> > +	cx231xx_enable_analog_tuner(dev);
> 
> Is this the right place? Isn't this now called for every QBUF? I would expect this
> to happen when you start streaming.
> 
> In vb2 it would be in start_streaming(), of course.

True. I think that the vb1 dialog would be, instead, ops->buf_setup.
I'll fix this on a separate patch.

Regards,
Mauro
