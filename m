Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:37089 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab0I1LuL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Sep 2010 07:50:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH 7/9] v4l: v4l2_subdev userspace format API
Date: Tue, 28 Sep 2010 13:50:22 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, g.liakhovetski@gmx.de
References: <1285517612-20230-1-git-send-email-laurent.pinchart@ideasonboard.com> <1285517612-20230-8-git-send-email-laurent.pinchart@ideasonboard.com> <201009262025.20852.hverkuil@xs4all.nl>
In-Reply-To: <201009262025.20852.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009281350.23233.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Thanks for the review.

On Sunday 26 September 2010 20:25:20 Hans Verkuil wrote:
> On Sunday, September 26, 2010 18:13:30 Laurent Pinchart wrote:
> > Add a userspace API to get, set and enumerate the media format on a
> > subdev pad.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> > Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> 
> <snip>
> 
> > diff --git a/Documentation/DocBook/v4l/dev-subdev.xml
> > b/Documentation/DocBook/v4l/dev-subdev.xml new file mode 100644
> > index 0000000..9a691f7
> > --- /dev/null
> > +++ b/Documentation/DocBook/v4l/dev-subdev.xml

[snip]

> > +    on one (or several) V4L2 device nodes.</para>
> > +  </section>
> > +
> > +  <section id="pad-level-formats">
> > +    <title>Pad-level formats</title>
> > +
> > +    <note>For the purpose of this section, the term
> > +    <wordasword>format</wordasword> means the combination of media bus
> > data +    format, frame width and frame height.</note>
> > +
> > +    <para>Image formats are typically negotiated on video capture and
> > output +    devices using the <link linkend="crop">cropping and
> > scaling</link> ioctls. +    The driver is responsible for configuring
> > every block in the video pipeline +    according to the requested format
> > at the pipeline input and/or +    output.</para>
> > +
> > +    <para>For complex devices, such as often found in embedded systems,
> > +    identical image sizes at the output of a pipeline can be achieved
> > using +    different hardware configurations. One such exemple is shown
> > on +    <xref linkend="pipeline-scaling" xrefstyle="template: Figure %n"
> > />, where +    image scaling can be performed on both the video sensor
> > and the host image +    processing hardware.</para>
> 
> I think that it should be made very, very clear that this section is only
> applicable to very complex devices and that it is not meant for generic
> V4L2 applications.

OK, I'll document that.

[snip]

> > +    <para>Drivers that implement the <link
> > linkend="media-controller-intro">media +    API</link> can expose
> > pad-level image format configuration to applications. +    When they do,
> > applications can use the &VIDIOC-SUBDEV-G-FMT; and +   
> > &VIDIOC-SUBDEV-S-FMT; ioctls. to negotiate formats on a per-pad
> > basis.</para>
> 
> What has the Media API to do with this, other than that it is needed to
> discover the subdev device nodes?

Nothing else. Drivers need to implement it, otherwise userspace won't be able 
to get pad identifiers.

[snip]

> > diff --git a/Documentation/DocBook/v4l/subdev-formats.xml
> > b/Documentation/DocBook/v4l/subdev-formats.xml new file mode 100644
> > index 0000000..fb3c8b1
> > --- /dev/null
> > +++ b/Documentation/DocBook/v4l/subdev-formats.xml

[snip]

> I'd add an introductory paragraph explaining that these codes determine how
> the pixels flow over a physical bus and have nothing to do with how they
> are stored in memory. That is determined by the pixelformat in struct
> v4l2_pix_format.
> 
> It's an important but non-intuitive difference.

OK, I'll add that.

[snip]

> > diff --git a/Documentation/DocBook/v4l/vidioc-streamon.xml
> > b/Documentation/DocBook/v4l/vidioc-streamon.xml index e42bff1..75ed39b
> > 100644
> > --- a/Documentation/DocBook/v4l/vidioc-streamon.xml
> > +++ b/Documentation/DocBook/v4l/vidioc-streamon.xml
> > @@ -93,6 +93,15 @@ synchronize with other events.</para>
> > 
> >  been allocated (memory mapping) or enqueued (output) yet.</para>
> >  
> >  	</listitem>
> >  	
> >        </varlistentry>
> > 
> > +      <varlistentry>
> > +	<term><errorcode>EPIPE</errorcode></term>
> > +	<listitem>
> > +	  <para>The driver implements <link
> > +	  linkend="pad-level-formats">pad-level format configuration</link> and
> > +	  the pipeline configuration is invalid.
> 
> This raises a question with me: how do I know that pad-level format
> configuration is possible? Is there a capability or some test that I can
> perform to check this?

What about VIDIOC_SUBDEV_G_FMT on a pad ?

[snip]

> > diff --git a/include/linux/v4l2-subdev.h b/include/linux/v4l2-subdev.h
> > new file mode 100644
> > index 0000000..623d063
> > --- /dev/null
> > +++ b/include/linux/v4l2-subdev.h

[snip]

> > +/**
> > + * struct v4l2_subdev_frame_size_enum - Media bus format enumeration
> > + * @pad: pad number, as reported by the media API
> > + * @index: format index during enumeration
> > + * @code: format code (from enum v4l2_mbus_pixelcode)
> > + */
> > +struct v4l2_subdev_frame_size_enum {
> > +	__u32 index;
> > +	__u32 pad;
> > +	__u32 code;
> > +	__u32 min_width;
> > +	__u32 max_width;
> > +	__u32 min_height;
> > +	__u32 max_height;
> > +	__u32 reserved[9];
> > +};
> 
> Is there a reason why struct v4l2_frmsize_discrete and
> v4l2_frmsize_stepwise are not reused here? Given the absence of
> step_width/height fields in the struct can I assume a step of 1?

> > +
> > +#define VIDIOC_SUBDEV_G_FMT	_IOWR('V',  4, struct v4l2_subdev_format)
> > +#define VIDIOC_SUBDEV_S_FMT	_IOWR('V',  5, struct v4l2_subdev_format)
> > +#define VIDIOC_SUBDEV_ENUM_MBUS_CODE \
> > +			_IOWR('V',  2, struct v4l2_subdev_mbus_code_enum)
> > +#define VIDIOC_SUBDEV_ENUM_FRAME_SIZE \
> > +			_IOWR('V', 74, struct v4l2_subdev_frame_size_enum)
> 
> The ioctl numbering is a bit scary. We want to be able to reuse V4L2 ioctls
> with subdevs where appropriate. But then we need to enumerate the subdev
> ioctls using a different character to avoid potential conflicts. E.g. 'S'
> instead of 'V'.

There's little chance the ioctl values will conflict, as they encode the 
structure size. However, it could still happen. That's why I've reused the 
VIDIOC_G_FMT, VIDIOC_S_FMT, VIDIOC_ENUM_FMT and VIDIOC_ENUM_FRAMESIZES ioctl 
numbers for those new ioctls, as they replace the V4L2 ioctls for sub-devices. 
We can also use another prefix, but there's a limited supply of them.

> > +
> > +#endif
> > diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> > index 8a278c2..bbbe4bf 100644
> > --- a/include/media/v4l2-subdev.h
> > +++ b/include/media/v4l2-subdev.h
> > @@ -21,6 +21,7 @@
> > 
> >  #ifndef _V4L2_SUBDEV_H
> >  #define _V4L2_SUBDEV_H
> > 
> > +#include <linux/v4l2-subdev.h>
> > 
> >  #include <media/media-entity.h>
> >  #include <media/v4l2-common.h>
> >  #include <media/v4l2-dev.h>
> > 
> > @@ -419,12 +420,12 @@ struct v4l2_subdev_ir_ops {
> > 
> >  				struct v4l2_subdev_ir_parameters *params);
> >  
> >  };
> > 
> > -enum v4l2_subdev_format_whence {
> > -	V4L2_SUBDEV_FORMAT_PROBE = 0,
> > -	V4L2_SUBDEV_FORMAT_ACTIVE = 1,
> > -};
> > -
> > 
> >  struct v4l2_subdev_pad_ops {
> > 
> > +	int (*enum_mbus_code)(struct v4l2_subdev *sd, struct v4l2_subdev_fh
> > *fh, +			      struct v4l2_subdev_mbus_code_enum *code);
> > +	int (*enum_frame_size)(struct v4l2_subdev *sd,
> > +			       struct v4l2_subdev_fh *fh,
> > +			       struct v4l2_subdev_frame_size_enum *fse);
> > 
> >  	int (*get_fmt)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
> >  	
> >  		       unsigned int pad, struct v4l2_mbus_framefmt *fmt,
> 
> Aren't pads u16 or something like that?

Yes they are. I can replace the unsigned int by u16, or pass a 
v4l2_subdev_format pointer instead of the pad, fmt and which values. That 
might be better, as it would be consistent with the other ioctls.

-- 
Regards,

Laurent Pinchart
