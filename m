Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:53650 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab2AQUVn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 15:21:43 -0500
Date: Tue, 17 Jan 2012 22:21:39 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH 17/23] v4l: Implement v4l2_subdev_link_validate()
Message-ID: <20120117202139.GF13236@valkosipuli.localdomain>
References: <4F0DFE92.80102@iki.fi>
 <1326317220-15339-17-git-send-email-sakari.ailus@iki.fi>
 <201201161544.08756.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201161544.08756.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review!

On Mon, Jan 16, 2012 at 03:44:08PM +0100, Laurent Pinchart wrote:
> On Wednesday 11 January 2012 22:26:54 Sakari Ailus wrote:
> > v4l2_subdev_link_validate() is the default op for validating a link. In
> > V4L2 subdev context, it is used to call a pad op which performs the proper
> > link check without much extra work.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  drivers/media/video/v4l2-subdev.c |   62
> > +++++++++++++++++++++++++++++++++++++ include/media/v4l2-subdev.h       | 
> >  10 ++++++
> >  2 files changed, 72 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/v4l2-subdev.c
> > b/drivers/media/video/v4l2-subdev.c index 836270d..4b329a0 100644
> > --- a/drivers/media/video/v4l2-subdev.c
> > +++ b/drivers/media/video/v4l2-subdev.c
> > @@ -367,6 +367,68 @@ const struct v4l2_file_operations v4l2_subdev_fops = {
> >  	.poll = subdev_poll,
> >  };
> > 
> > +#ifdef CONFIG_MEDIA_CONTROLLER
> > +int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
> > +				      struct media_link *link,
> > +				      struct v4l2_subdev_format *source_fmt,
> > +				      struct v4l2_subdev_format *sink_fmt)
> > +{
> > +	if (source_fmt->format.width != sink_fmt->format.width
> > +	    || source_fmt->format.height != sink_fmt->format.height
> > +	    || source_fmt->format.code != sink_fmt->format.code)
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(v4l2_subdev_link_validate_default);
> 
> What about calling this function directly from v4l2_subdev_link_validate() if 
> the pad::link_validate operation is NULL ? That wouldn't require changing all 
> subdev drivers to explicitly use the default implementation.

I can do that. I still want to keep the function available for those that
want to call it explicitly to perform the above check.

> > +
> > +static struct v4l2_subdev_format
> > +*v4l2_subdev_link_validate_get_format(struct media_pad *pad,
> > +				      struct v4l2_subdev_format *fmt)
> > +{
> > +	int rval;
> > +
> > +	switch (media_entity_type(pad->entity)) {
> > +	case MEDIA_ENT_T_V4L2_SUBDEV:
> > +		fmt->which = V4L2_SUBDEV_FORMAT_ACTIVE;
> > +		fmt->pad = pad->index;
> > +		rval = v4l2_subdev_call(media_entity_to_v4l2_subdev(
> > +						pad->entity),
> > +					pad, get_fmt, NULL, fmt);
> > +		if (rval < 0)
> > +			return NULL;
> > +		return fmt;
> > +	case MEDIA_ENT_T_DEVNODE_V4L:
> > +		return NULL;
> > +	default:
> > +		BUG();
> 
> Maybe WARN() and return NULL ?

It's a clear driver BUG() if this happens. If you think the correct response
to that is WARN() and return NULL, I can do that.

> > +	}
> > +}
> > +
> > +int v4l2_subdev_link_validate(struct media_link *link)
> > +{
> > +	struct v4l2_subdev *sink = NULL, *source = NULL;
> > +	struct v4l2_subdev_format _sink_fmt, _source_fmt;
> > +	struct v4l2_subdev_format *sink_fmt, *source_fmt;
> > +
> > +	source_fmt = v4l2_subdev_link_validate_get_format(
> > +		link->source, &_source_fmt);
> > +	sink_fmt = v4l2_subdev_link_validate_get_format(
> > +		link->sink, &_sink_fmt);
> > +
> > +	if (source_fmt)
> > +		source = media_entity_to_v4l2_subdev(link->source->entity);
> > +	if (sink_fmt)
> > +		sink = media_entity_to_v4l2_subdev(link->sink->entity);
> > +
> > +	if (source_fmt && sink_fmt)
> > +		return v4l2_subdev_call(sink, pad, link_validate, link,
> > +					source_fmt, sink_fmt);
> 
> This looks overly complex. Why don't you return 0 if one of the two entities 
> is of a type different than MEDIA_ENT_T_V4L2_SUBDEV, then retrieve the formats 
> for the two entities and return 0 if one of the two operation fails, and 
> finally call pad::link_validate ?

Now that you mention that, I agree. :-) I'll fix it.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
