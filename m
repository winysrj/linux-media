Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41785 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965418Ab2B1LmV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Feb 2012 06:42:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 09/33] v4l: Add subdev selections documentation
Date: Tue, 28 Feb 2012 12:42:26 +0100
Message-ID: <1714254.ToCjbJ901j@avalon>
In-Reply-To: <4F4AA73B.1050206@iki.fi>
References: <20120220015605.GI7784@valkosipuli.localdomain> <1423212.0qmDccT8PT@avalon> <4F4AA73B.1050206@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sunday 26 February 2012 23:42:19 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > On Monday 20 February 2012 03:56:48 Sakari Ailus wrote:
> >> Add documentation for V4L2 subdev selection API. This changes also
> >> experimental V4L2 subdev API so that scaling now works through selection
> >> API only.
> >> 
> >> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> >> 
> >> 
> >> diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml
> >> b/Documentation/DocBook/media/v4l/dev-subdev.xml index 0916a73..9d5e7da
> >> 100644
> >> --- a/Documentation/DocBook/media/v4l/dev-subdev.xml
> >> +++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
> > 
> > [snip]
> > 
> >> +      <para>Scaling operation changes the size of the image by scaling
> >> +      it to new dimensions. Some sub-devices support it. The scaled
> >> +      size (width and height) is represented by &v4l2-rect;. In the
> >> +      case of scaling, top and left will always be zero. Scaling is
> >> +      configured using &sub-subdev-g-selection; and
> >> +      <constant>V4L2_SUBDEV_SEL_COMPOSE_ACTIVE</constant> selection
> >> +      target on the sink pad of the subdev. The scaling is performed
> >> +      related to the width and height of the crop rectangle on the
> >> +      subdev's sink pad.</para>
> > 
> > I'm not sure if that would be very clear for readers who are not yet
> > familiar with the API. What about the following text instead ?
> > 
> > "The scaling operation changes the size of the image by scaling it to new
> > dimensions. The scaling ratio isn't specified explicitly, but is implied
> > from the original and scaled image sizes. Both sizes are represented by
> > &v4l2- rect;.
> > 
> > Scaling support is optional. When supported by a subdev, the crop
> > rectangle on the subdev's sink pad is scaled to the size configured using
> > &VIDIOC-SUBDEV-G- SELECTION; and
> > <constant>V4L2_SUBDEV_SEL_COMPOSE_ACTIVE</constant> selection target on
> > the same pad. If the subdev supports scaling but no composing, the top
> > and left values are not used and must always be set to zero."
> > 
> > (note that &sub-subdev-g-selection; has been replaced with
> > &VIDIOC-SUBDEV-G- SELECTION;)
> > 
> > I would also move this text after the sink pad crop description to follow
> > the order in which operations are applied by subdevs.
> 
> I'm fine with that change, so I did it. However, I won't replace
> &sub-subdev-g-selection; with &VIDIOC-SUBDEV-G-SELECTION; simply because
> it won't work:
> 
> dev-subdev.xml:310: parser error : Entity 'VIDIOC-SUBDEV-G-SELECTION'
> not defined
>       size configured using &VIDIOC-SUBDEV-G-SELECTION; and
> 
> It's beyond me why not; similar references are being used elsewhere with
> otherwise equivalent definitions. Perhaps the name is just too long?
> That's the only difference I could think of: xmlto typically segfaults
> on errors so I wouldn't be surprised of something so simple.

Don't give up so fast :-)

diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
index 729f840..77ead85 100644
--- a/Documentation/DocBook/media/Makefile
+++ b/Documentation/DocBook/media/Makefile
@@ -65,6 +65,8 @@ IOCTLS = \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/dvb/video.h) \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/media.h) \
 	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/v4l2-subdev.h) \
+	VIDIOC_SUBDEV_G_SELECTION \
+	VIDIOC_SUBDEV_S_SELECTION \
 	VIDIOC_SUBDEV_G_FRAME_INTERVAL \
 	VIDIOC_SUBDEV_S_FRAME_INTERVAL \
 	VIDIOC_SUBDEV_ENUM_MBUS_CODE \

and rm Documentation/DocBook/media-entities.tmpl before you compile the
documentation.

> >> +      <para>As for pad formats, drivers store try and active
> >> +      rectangles for the selection targets of ACTIVE type <xref
> >> +      linkend="v4l2-subdev-selection-targets">.</xref></para>
> >> +
> >> +      <para>On sink pads, cropping is applied relatively to the
> >> +      current pad format. The pad format represents the image size as
> >> +      received by the sub-device from the previous block in the
> >> +      pipeline, and the crop rectangle represents the sub-image that
> >> +      will be transmitted further inside the sub-device for
> >> +      processing.</para>
> >> +
> >> +      <para>On source pads, cropping is similar to sink pads, with the
> >> +      exception that the source size from which the cropping is
> >> +      performed, is the COMPOSE rectangle on the sink pad. In both
> >> +      sink and source pads, the crop rectangle must be entirely
> >> +      containted inside the source image size for the crop
> >> +      operation.</para>
> >> +
> >> +      <para>The drivers should always use the closest possible
> >> +      rectangle the user requests on all selection targets, unless
> >> +      specificly told otherwise<xref
> >> +      linkend="v4l2-subdev-selection-flags">.</xref></para>
> >> +    </section>
> >> +
> >> +    <section>
> >> +      <title>Types of selection targets</title>
> >> +
> >> +      <section>
> >> +	<title>ACTIVE targets</title>
> >> +
> >> +	<para>ACTIVE targets reflect the actual hardware configuration
> >> +	at any point of time.</para>
> >> +      </section>
> >> +
> >> +      <section>
> >> +	<title>BOUNDS targets</title>
> >> +
> >> +	<para>BOUNDS targets is the smallest rectangle within which
> >> +	contains all valid ACTIVE rectangles.
> > 
> > s/within which/that/ ?
> 
> Ack.
> 
> >> It may not be possible
> >> +	to set the ACTIVE rectangle as large as the BOUNDS rectangle,
> >> +	however.</para>
> > 
> > What about
> > 
> > "The BOUNDS rectangle might not itself be a valid ACTIVE rectangle when
> > all possible ACTIVE pixels do not form a rectangular shape (e.g.
> > cross-shaped or round sensors)."
> 
> There are cases where the active size is limited, even if it's
> rectangular. I can add the above case there, sure, if you think such
> devices exist --- I've never heard of nor seen them. Some sensors are
> documented to be cross-shaped but the only thing separating these from
> the rest is that the manufacturer doesn't guarantee the quality of the
> pixels in the corners. At least on those I've seen. You can still
> capture the full pixel matrix.

Those are just examples. I think it's useful to add them, otherwise the reader
won't know why and under what kind of circumstances the ACTIVE rectangle can't
be as large at the BOUNDS rectangle.

> >> +      </section>
> >> 
> >> -      <para>Cropping behaviour on output pads is not defined.</para>
> >> +    </section>
> >> +
> >> +    <section>
> >> +      <title>Order of configuration and format propagation</title>
> >> +
> >> +      <para>Inside subdevs, the order of image processing steps will
> >> +      always be from the sink pad towards the source pad. This is also
> >> +      reflected in the order in which the configuration must be
> >> +      performed by the user: the changes made will be propagated to
> >> +      any subsequent stages. If this behaviour is not desired, the
> >> +      user must set
> >> +      <constant>V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG</constant> flag.
> > 
> > Could you explain what happens when V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG is
> > set ? Just stating that it doesn't follow the propagation behaviour
> > previously described could be understood in many different ways.
> 
> Good point. How about this:
> 
> "This flag causes that no propagation of the changes are allowed in any
> circumstances. This may also lead the accessed rectangle not being
> changed at all,

"The accessed rectangle will likely be adjusted by the driver,"

> depending on the properties of the underlying hardware.
> Some drivers may not support this flag."

What should happen then ? Should the flag be ignored, or should the driver
return an error ?

> >> The
> >> +      coordinates to a step always refer to the active size of the
> >> +      previous step. The exception to this rule is the source compose
> >> +      rectangle, which refers to the sink compose bounds rectangle ---
> >> +      if it is supported by the hardware.</para>
> >> +
> >> +      <orderedlist>
> >> +	<listitem>Sink pad format. The user configures the sink pad
> >> +	format. This format defines the parameters of the image the
> >> +	entity receives through the pad for further processing.</listitem>
> >> +
> >> +	<listitem>Sink pad active crop selection. The sink pad crop
> >> +	defines the performed to the sink pad format.</listitem>
> > 
> > s/defines the/defines the cropping/ ?
> 
> Fixed.
> 
> >> +
> >> +	<listitem>Sink pad active compose selection. The size of the
> >> +	sink pad compose rectangle defines the scaling ratio compared
> >> +	to the size of the sink pad crop rectangle. The location of
> >> +	the compose rectangle specifies the location of the active
> >> +	sink compose rectangle in the sink compose bounds
> >> +	rectangle.</listitem>
> >> +
> >> +	<listitem>Source pad active crop selection. Crop on the source
> >> +	pad defines crop performed to the image in the sink compose
> >> +	bounds rectangle.</listitem>
> >> +
> >> +	<listitem>Source pad format. The source pad format defines the
> >> +	output pixel format of the subdev, as well as the other
> >> +	parameters with the exception of the image width and height.
> >> +	Width and height are defined by the size of the source pad
> >> +	active crop selection.</listitem>
> >> +      </orderedlist>
> >> +
> >> +      <para>Accessing any of the above rectangles not supported by the
> >> +      subdev will return <constant>EINVAL</constant>.
> > 
> > Do drivers have to support BOUNDS rectangles for every ACTIVE rectangle
> > they support (and the other way around) ? If so, I think it should be
> > specified.
> I think the answer to that should be "yes", albeit this hasn't been
> discussed previously. I see no reason not to support equivalent BOUNDS
> rectangles.
> 
> I'll change the documentation to state that.
> 
> > Is EINVAL returned for any other error case in the selection API ? If so,
> > it might make enumeration of the supported rectangles difficult.
> 
> Good point. There are two other reasons to return EINVAL and those are
> invalid parameters in either pad or which fields. I think that should be
> fine. I'd keep it EINVAL.
> 
> Alternatively we could use e.g. ENOENT.
> 
> What do you think?

I'm OK with EINVAL then, as applications shouldn't pass an invalid pad or
which value in the first place.

> >> Any rectangle
> >> +      referring to a previous unsupported rectangle coordinates will
> >> +      instead refer to the previous supported rectangle. For example,
> >> +      if sink crop is not supported, the compose selection will refer
> >> +      to the sink pad format dimensions instead.</para>
> > 
> > Should we add a list of the rectangles a subdev must/should/can support
> > for the different possible use cases ?
> 
> I think this should be rather obvious with the examples and the
> statement on BOUNDS rectangles. Such a list, if we make it very
> detailed, will be unnecessarily redundant and will soon become
> out-of-date. In principle I don't like redundancy whether it's code or
> documentation. It easily leads to contradictions.
> 
> If it turns out it'll be needed we can easily add it later on.

OK.

[snip]

> >> diff --git
> >> a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
> >> b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml new file
> >> mode 100644
> >> index 0000000..033077a
> >> --- /dev/null
> >> +++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml

[snip]

> >> +    <table pgwide="1" frame="none" id="v4l2-subdev-selection-flags">
> >> +      <title>V4L2 subdev selection flags</title>
> >> +      <tgroup cols="3">
> >> +        &cs-def;
> >> +	<tbody valign="top">
> >> +	  <row>
> >> +	    <entry><constant>V4L2_SUBDEV_SEL_FLAG_SIZE_GE</constant></entry>
> >> +	    <entry>(1 &lt;&lt; 0)</entry>
> >> +	    <entry>Suggest the driver it should choose greater or
> >> +	    equal rectangle (in size) than was requested.</entry>
> >> +	  </row>
> >> +	  <row>
> >> +	    <entry><constant>V4L2_SUBDEV_SEL_FLAG_SIZE_LE</constant></entry>
> >> +	    <entry>(1 &lt;&lt; 1)</entry>
> >> +	    <entry>Suggest the driver it should choose lesser or
> >> +	    equal rectangle (in size) than was requested.</entry>
> >> +	  </row>
> > 
> > Those two flags are only briefly described here, could you add a more
> > detailed description either here or in
> > Documentation/DocBook/media/v4l/dev-subdev.xml ?
> Added:
> 
>             " Albeit the driver may choose a lesser size,
> 	    it will only do so due to hardware limitations. Without
> 	    this flag (and
> 	    <constant>V4L2_SUBDEV_SEL_FLAG_SIZE_LE</constant>) the
> 	    behaviour is to choose the closest possible
> 	    rectangle."
> 
> Does that cover your understanding of a more detailed description? :-)

I was thinking about something in media/v4l/dev-subdev.xml that would explain
what the flags are used for. media/v4l/vidioc-subdev-g-selection.xml is more
like reference documentation.

-- 
Regards,

Laurent Pinchart
