Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38674 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbbEXVWB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2015 17:22:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: subdev: Add pad config allocator and init
Date: Mon, 25 May 2015 00:22:18 +0300
Message-ID: <8330698.ZC88AbQjHT@avalon>
In-Reply-To: <5561852C.1020608@xs4all.nl>
References: <12906805.RcB5KU0kGN@avalon> <5561852C.1020608@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sunday 24 May 2015 10:00:44 Hans Verkuil wrote:
> Hi Laurent,
> 
> Looks good, but I have one question. See below.
> 
> On 05/23/2015 08:24 PM, Laurent Pinchart wrote:
> > Add a new subdev operation to initialize a subdev pad config array, and
> > a helper function to allocate and initialize the array. This can be used
> > by bridge drivers to implement try format based on subdev pad
> > operations.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@linaro.org>
> > Acked-by: Vaibhav Hiremath <vaibhav.hiremath@linaro.org>
> > ---
> > 
> >  drivers/media/v4l2-core/v4l2-subdev.c | 19 ++++++++++++++++++-
> >  include/media/v4l2-subdev.h           |  3 +++
> >  2 files changed, 21 insertions(+), 1 deletion(-)

[snip]

> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index 8f5da73dacff..7860d67574f5 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -483,6 +483,8 @@ struct v4l2_subdev_pad_config {
> >   *                  may be adjusted by the subdev driver to device
> >   capabilities. */
> >  
> >  struct v4l2_subdev_pad_ops {
> > +	void (*init_cfg)(struct v4l2_subdev *sd,
> > +			 struct v4l2_subdev_pad_config *cfg);
> >  	int (*enum_mbus_code)(struct v4l2_subdev *sd,
> >  			      struct v4l2_subdev_pad_config *cfg,
> >  			      struct v4l2_subdev_mbus_code_enum *code);
> > @@ -675,6 +677,7 @@ int v4l2_subdev_link_validate_default(struct
> > v4l2_subdev *sd,
> >  				      struct v4l2_subdev_format *source_fmt,
> >  				      struct v4l2_subdev_format *sink_fmt);
> >  int v4l2_subdev_link_validate(struct media_link *link);
> > +struct v4l2_subdev_pad_config *v4l2_subdev_alloc_pad_config(struct
> > v4l2_subdev *sd);
>
> Would it make sense to add a simple static inline
> v4l2_subdev_free_pad_config here? All it does is a kfree, but still it
> makes it symmetrical and if we ever need to do more than a kfree, then we
> are able to do so.

Yes it makes sense. I've sent a v2.

> At the very least this header needs a comment if we don't add a
> free_pad_config that the caller needs to kfree the pointer.
> 
> >  #endif /* CONFIG_MEDIA_CONTROLLER */
> >  void v4l2_subdev_init(struct v4l2_subdev *sd,
> >  		      const struct v4l2_subdev_ops *ops);

-- 
Regards,

Laurent Pinchart

