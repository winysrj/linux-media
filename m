Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:45149 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934493AbdLRT1N (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 14:27:13 -0500
Date: Mon, 18 Dec 2017 17:27:04 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 15/24] media: v4l2-subdev: get rid of
 __V4L2_SUBDEV_MK_GET_TRY() macro
Message-ID: <20171218172704.57d250d0@vento.lan>
In-Reply-To: <20171009202355.ckhaf5xcba5z4tvh@valkosipuli.retiisi.org.uk>
References: <cover.1507544011.git.mchehab@s-opensource.com>
        <63937cedcefd1c56b211ec115b717510c470bd1a.1507544011.git.mchehab@s-opensource.com>
        <20171009202355.ckhaf5xcba5z4tvh@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 9 Oct 2017 23:23:56 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Mon, Oct 09, 2017 at 07:19:21AM -0300, Mauro Carvalho Chehab wrote:
> > The __V4L2_SUBDEV_MK_GET_TRY() macro is used to define
> > 3 functions that have the same arguments. The code of those
> > functions is simple enough to just declare them, de-obfuscating
> > the code.
> > 
> > While here, replace BUG_ON() by WARN_ON() as there's no reason
> > why to panic the Kernel if this fails.
> 
> BUG_ON() might actually be a better idea as this will lead to memory
> corruption. I presume it's not been hit often.

Well, let's then change the code to:

        if (WARN_ON(pad >= sd->entity.num_pads)) 
                return -EINVAL;

This way, it won't try to use an invalid value. As those are default
handlers for ioctls, userspace should be able to handle it.

> 
> That said, I, too, favour WARN_ON() in this case. In case pad exceeds the
> number of pads, then zero could be used, for instance. The only real
> problem comes if there were no pads to begin with. The callers of these
> functions also don't expect to receive NULL. Another option would be to
> define a static, dummy variable for the purpose that would be at least safe
> to access. Or we could just use the dummy entry whenever the pad isn't
> valid.
> 
> This will make the functions more complex and I might just keep the
> original macro. Even grep works on it nowadays.
> 
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  include/media/v4l2-subdev.h | 37 +++++++++++++++++++++++++------------
> >  1 file changed, 25 insertions(+), 12 deletions(-)
> > 
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index 1f34045f07ce..35c4476c56ee 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -897,19 +897,32 @@ struct v4l2_subdev_fh {
> >  	container_of(fh, struct v4l2_subdev_fh, vfh)
> >  
> >  #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
> > -#define __V4L2_SUBDEV_MK_GET_TRY(rtype, fun_name, field_name)		\
> > -	static inline struct rtype *					\
> > -	fun_name(struct v4l2_subdev *sd,				\
> > -		 struct v4l2_subdev_pad_config *cfg,			\
> > -		 unsigned int pad)					\
> > -	{								\
> > -		BUG_ON(pad >= sd->entity.num_pads);			\
> > -		return &cfg[pad].field_name;				\
> > -	}
> > +static inline struct v4l2_mbus_framefmt
> > +*v4l2_subdev_get_try_format(struct v4l2_subdev *sd,
> > +			    struct v4l2_subdev_pad_config *cfg,
> > +			    unsigned int pad)
> > +{
> > +	WARN_ON(pad >= sd->entity.num_pads);
> > +	return &cfg[pad].try_fmt;
> > +}
> >  
> > -__V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, v4l2_subdev_get_try_format, try_fmt)
> > -__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, v4l2_subdev_get_try_crop, try_crop)
> > -__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, v4l2_subdev_get_try_compose, try_compose)
> > +static inline struct v4l2_rect
> > +*v4l2_subdev_get_try_crop(struct v4l2_subdev *sd,
> > +			  struct v4l2_subdev_pad_config *cfg,
> > +			  unsigned int pad)
> > +{
> > +	WARN_ON(pad >= sd->entity.num_pads);
> > +	return &cfg[pad].try_crop;
> > +}
> > +
> > +static inline struct v4l2_rect
> > +*v4l2_subdev_get_try_compose(struct v4l2_subdev *sd,
> > +			     struct v4l2_subdev_pad_config *cfg,
> > +			     unsigned int pad)
> > +{
> > +	WARN_ON(pad >= sd->entity.num_pads);
> > +	return &cfg[pad].try_compose;
> > +}
> >  #endif
> >  
> >  extern const struct v4l2_file_operations v4l2_subdev_fops;
> 



Thanks,
Mauro
