Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:55114 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab0I1Mmg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Sep 2010 08:42:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC/PATCH 8/9] v4l: v4l2_subdev userspace frame interval API
Date: Tue, 28 Sep 2010 14:42:51 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, g.liakhovetski@gmx.de
References: <1285517612-20230-1-git-send-email-laurent.pinchart@ideasonboard.com> <1285517612-20230-9-git-send-email-laurent.pinchart@ideasonboard.com> <201009262031.58744.hverkuil@xs4all.nl>
In-Reply-To: <201009262031.58744.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009281442.51670.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Sunday 26 September 2010 20:31:58 Hans Verkuil wrote:
> On Sunday, September 26, 2010 18:13:31 Laurent Pinchart wrote:
> > The three new ioctl VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL,
> > VIDIOC_SUBDEV_G_FRAME_INTERVAL and VIDIOC_SUBDEV_S_FRAME_INTERVAL can be
> > used to enumerate and configure a subdev's frame rate from userspace.
> > 
> > Two new video::g/s_frame_interval subdev operations are introduced to
> > support those ioctls. The existing video::g/s_parm operations are
> > deprecated and shouldn't be used anymore.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

[snip]

> > diff --git
> > a/Documentation/DocBook/v4l/vidioc-subdev-enum-frame-interval.xml
> > b/Documentation/DocBook/v4l/vidioc-subdev-enum-frame-interval.xml new
> > file mode 100644
> > index 0000000..be73500
> > --- /dev/null
> > +++ b/Documentation/DocBook/v4l/vidioc-subdev-enum-frame-interval.xml

[snip]

> > +    <para>This ioctl lets applications enumerate available frame
> > intervals on a +    given sub-device pad. Frame intervals only makes
> > sense for sub-devices that +    can control the frame period on their
> > own. This includes, for instance, +    image sensors and TV tuners.
> > Sub-devices that don't support frame intervals +    must not implement
> > this ioctl.</para>
> 
> How do I know as application that frame intervals are not supported?
> Frankly, this applies to the normal V4L2 ioctl as well :-)

Right. It could be said of every ioctl. I'll remove that sentence.

[snip]

> > +    <table pgwide="1" frame="none" id="v4l2-subdev-frame-interval-enum">
> > +      <title>struct
> > <structname>v4l2_subdev_frame_interval_enum</structname></title> +     
> > <tgroup cols="3">
> > +	&cs-str;
> > +	<tbody valign="top">
> > +	  <row>
> > +	    <entry>__u32</entry>
> > +	    <entry><structfield>index</structfield></entry>
> > +	    <entry>Number of the format in the enumeration, set by the
> > +	    application.</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry>__u32</entry>
> > +	    <entry><structfield>pad</structfield></entry>
> > +	    <entry>Pad number as reported by the media controller API.</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry>__u32</entry>
> > +	    <entry><structfield>code</structfield></entry>
> > +	    <entry>The media bus format code, as defined in
> > +	    <xref linkend="v4l2-mbus-format" />.</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry>__u32</entry>
> > +	    <entry><structfield>width</structfield></entry>
> > +	    <entry>Frame width, in pixels.</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry>__u32</entry>
> > +	    <entry><structfield>height</structfield></entry>
> > +	    <entry>Frame height, in pixels.</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry>&v4l2-fract;</entry>
> > +	    <entry><structfield>interval</structfield></entry>
> > +	    <entry>Period, in seconds, between consecutive video
> > frames.</entry> +	  </row>
> 
> struct v4l2_frmivalenum is not needed for this?

v4l2_frmivalenum uses V4L2 pixel formats instead of media bus pixel codes.

[snip]

> > diff --git a/Documentation/DocBook/v4l/vidioc-subdev-g-frame-interval.xml
> > b/Documentation/DocBook/v4l/vidioc-subdev-g-frame-interval.xml new file
> > mode 100644
> > index 0000000..1d0e0e1
> > --- /dev/null
> > +++ b/Documentation/DocBook/v4l/vidioc-subdev-g-frame-interval.xml

[snip]

> > +    <para>Drivers must not return an error solely because the requested
> > interval +    doesn't match the device capabilities. They must instead
> > modify the interval +    to match what the hardware can provide. The
> > modified interval should be as +    close as possible to the original
> > request.</para>
> 
> Perhaps this should be driver dependent? What is the rationale for
> requiring this behavior?

Same as for the formats and sizes. If a driver supports a large range of 
intervals, but not every exact values, applications will ask for the frame 
interval they want and will receive the closest match. It will then be up to 
the application to accept it or fail.

[snip]

-- 
Regards,

Laurent Pinchart
