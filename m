Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:43276 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab0I1Mba (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Sep 2010 08:31:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH 7/9] v4l: v4l2_subdev userspace format API
Date: Tue, 28 Sep 2010 14:31:40 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, g.liakhovetski@gmx.de
References: <1285517612-20230-1-git-send-email-laurent.pinchart@ideasonboard.com> <201009281350.23233.laurent.pinchart@ideasonboard.com> <3c895d38527af5e6b5acdd783ff8dacb.squirrel@webmail.xs4all.nl>
In-Reply-To: <3c895d38527af5e6b5acdd783ff8dacb.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009281431.40904.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Tuesday 28 September 2010 14:11:28 Hans Verkuil wrote:
> > Hi Hans,
> > 
> > Thanks for the review.
> > 
> > On Sunday 26 September 2010 20:25:20 Hans Verkuil wrote:
> >> On Sunday, September 26, 2010 18:13:30 Laurent Pinchart wrote:
> <snip>
> 
> >> > diff --git a/Documentation/DocBook/v4l/vidioc-streamon.xml
> >> > b/Documentation/DocBook/v4l/vidioc-streamon.xml index e42bff1..75ed39b
> >> > 100644
> >> > --- a/Documentation/DocBook/v4l/vidioc-streamon.xml
> >> > +++ b/Documentation/DocBook/v4l/vidioc-streamon.xml
> >> > @@ -93,6 +93,15 @@ synchronize with other events.</para>
> >> > 
> >> >  been allocated (memory mapping) or enqueued (output) yet.</para>
> >> >  
> >> >  	</listitem>
> >> >  	
> >> >        </varlistentry>
> >> > 
> >> > +      <varlistentry>
> >> > +	<term><errorcode>EPIPE</errorcode></term>
> >> > +	<listitem>
> >> > +	  <para>The driver implements <link
> >> > +	  linkend="pad-level-formats">pad-level format configuration</link>
> >> 
> >> and
> >> 
> >> > +	  the pipeline configuration is invalid.
> >> 
> >> This raises a question with me: how do I know that pad-level format
> >> configuration is possible? Is there a capability or some test that I can
> >> perform to check this?
> > 
> > What about VIDIOC_SUBDEV_G_FMT on a pad ?
> 
> That will work. Probably a good idea to document this.

OK.

> > [snip]
> > 
> >> > diff --git a/include/linux/v4l2-subdev.h b/include/linux/v4l2-subdev.h
> >> > new file mode 100644
> >> > index 0000000..623d063
> >> > --- /dev/null
> >> > +++ b/include/linux/v4l2-subdev.h
> > 
> > [snip]
> > 
> >> > +/**
> >> > + * struct v4l2_subdev_frame_size_enum - Media bus format enumeration
> >> > + * @pad: pad number, as reported by the media API
> >> > + * @index: format index during enumeration
> >> > + * @code: format code (from enum v4l2_mbus_pixelcode)
> >> > + */
> >> > +struct v4l2_subdev_frame_size_enum {
> >> > +	__u32 index;
> >> > +	__u32 pad;
> >> > +	__u32 code;
> >> > +	__u32 min_width;
> >> > +	__u32 max_width;
> >> > +	__u32 min_height;
> >> > +	__u32 max_height;
> >> > +	__u32 reserved[9];
> >> > +};
> >> 
> >> Is there a reason why struct v4l2_frmsize_discrete and
> >> v4l2_frmsize_stepwise are not reused here? Given the absence of
> >> step_width/height fields in the struct can I assume a step of 1?
> 
> Didn't see a comment from you on this one...

Oops, sorry.

Having a discrete option was, I think, a mistake. That's why I've merged both 
options into a single structure. Discrete frame sizes are still supported, as 
explained in the documentation, by setting min and max to the same values.

Furthermore, step-wise enumeration isn't enough. The OMAP3 ISP resizer can 
scale images by a ratio expressed as 256 / [64 - 1024 integer value]. For a 
given input size the minimum and maximum output sizes are (more or less) 1/4x 
and 4x of the input, but not all values in that range can be achieved. We thus 
need to express a discontinuous range of values that are not separated by a 
constant step. As this can't be achieved in a generic way, I think it's better 
to let the driver return the minimum and maximum sizes, and then try a 
specific size in that range using the try/active mechanism.

> >> > +#define VIDIOC_SUBDEV_G_FMT	_IOWR('V',  4, struct v4l2_subdev_format)
> >> > +#define VIDIOC_SUBDEV_S_FMT	_IOWR('V',  5, struct v4l2_subdev_format)
> >> > +#define VIDIOC_SUBDEV_ENUM_MBUS_CODE \
> >> > +			_IOWR('V',  2, struct v4l2_subdev_mbus_code_enum)
> >> > +#define VIDIOC_SUBDEV_ENUM_FRAME_SIZE \
> >> > +			_IOWR('V', 74, struct v4l2_subdev_frame_size_enum)
> >> 
> >> The ioctl numbering is a bit scary. We want to be able to reuse V4L2
> >> ioctls
> >> with subdevs where appropriate. But then we need to enumerate the subdev
> >> ioctls using a different character to avoid potential conflicts. E.g.
> >> 'S'
> >> instead of 'V'.
> > 
> > There's little chance the ioctl values will conflict, as they encode the
> > structure size. However, it could still happen. That's why I've reused
> > the VIDIOC_G_FMT, VIDIOC_S_FMT, VIDIOC_ENUM_FMT and
> > VIDIOC_ENUM_FRAMESIZES ioctl
> > numbers for those new ioctls, as they replace the V4L2 ioctls for
> > sub-devices.
> > We can also use another prefix, but there's a limited supply of them.
> 
> Hmm, perhaps we can use 'v'. That's currently in use by V4L1, but that's
> on the way out. I'm not sure what is wisdom here. Mauro should take a look
> at this, I think.

That could be a good option. I'll let Mauro comment on it.

-- 
Regards,

Laurent Pinchart
