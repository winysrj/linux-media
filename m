Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:38969 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab2CBMYr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 07:24:47 -0500
Date: Fri, 2 Mar 2012 14:24:40 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 09/33] v4l: Add subdev selections documentation
Message-ID: <20120302122439.GC14920@valkosipuli.localdomain>
References: <20120220015605.GI7784@valkosipuli.localdomain>
 <1423212.0qmDccT8PT@avalon>
 <4F4AA73B.1050206@iki.fi>
 <1714254.ToCjbJ901j@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1714254.ToCjbJ901j@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Feb 28, 2012 at 12:42:26PM +0100, Laurent Pinchart wrote:
> On Sunday 26 February 2012 23:42:19 Sakari Ailus wrote:
> > Laurent Pinchart wrote:
> > > On Monday 20 February 2012 03:56:48 Sakari Ailus wrote:
> > >> Add documentation for V4L2 subdev selection API. This changes also
> > >> experimental V4L2 subdev API so that scaling now works through selection
> > >> API only.
> > >> 
> > >> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > >> 
> > >> 
> > >> diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml
> > >> b/Documentation/DocBook/media/v4l/dev-subdev.xml index 0916a73..9d5e7da
> > >> 100644
> > >> --- a/Documentation/DocBook/media/v4l/dev-subdev.xml
> > >> +++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
> > > 
> > > [snip]
> > > 
> > >> +      <para>Scaling operation changes the size of the image by scaling
> > >> +      it to new dimensions. Some sub-devices support it. The scaled
> > >> +      size (width and height) is represented by &v4l2-rect;. In the
> > >> +      case of scaling, top and left will always be zero. Scaling is
> > >> +      configured using &sub-subdev-g-selection; and
> > >> +      <constant>V4L2_SUBDEV_SEL_COMPOSE_ACTIVE</constant> selection
> > >> +      target on the sink pad of the subdev. The scaling is performed
> > >> +      related to the width and height of the crop rectangle on the
> > >> +      subdev's sink pad.</para>
> > > 
> > > I'm not sure if that would be very clear for readers who are not yet
> > > familiar with the API. What about the following text instead ?
> > > 
> > > "The scaling operation changes the size of the image by scaling it to new
> > > dimensions. The scaling ratio isn't specified explicitly, but is implied
> > > from the original and scaled image sizes. Both sizes are represented by
> > > &v4l2- rect;.
> > > 
> > > Scaling support is optional. When supported by a subdev, the crop
> > > rectangle on the subdev's sink pad is scaled to the size configured using
> > > &VIDIOC-SUBDEV-G- SELECTION; and
> > > <constant>V4L2_SUBDEV_SEL_COMPOSE_ACTIVE</constant> selection target on
> > > the same pad. If the subdev supports scaling but no composing, the top
> > > and left values are not used and must always be set to zero."
> > > 
> > > (note that &sub-subdev-g-selection; has been replaced with
> > > &VIDIOC-SUBDEV-G- SELECTION;)
> > > 
> > > I would also move this text after the sink pad crop description to follow
> > > the order in which operations are applied by subdevs.
> > 
> > I'm fine with that change, so I did it. However, I won't replace
> > &sub-subdev-g-selection; with &VIDIOC-SUBDEV-G-SELECTION; simply because
> > it won't work:
> > 
> > dev-subdev.xml:310: parser error : Entity 'VIDIOC-SUBDEV-G-SELECTION'
> > not defined
> >       size configured using &VIDIOC-SUBDEV-G-SELECTION; and
> > 
> > It's beyond me why not; similar references are being used elsewhere with
> > otherwise equivalent definitions. Perhaps the name is just too long?
> > That's the only difference I could think of: xmlto typically segfaults
> > on errors so I wouldn't be surprised of something so simple.
> 
> Don't give up so fast :-)
> 
> diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
> index 729f840..77ead85 100644
> --- a/Documentation/DocBook/media/Makefile
> +++ b/Documentation/DocBook/media/Makefile
> @@ -65,6 +65,8 @@ IOCTLS = \
>  	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/dvb/video.h) \
>  	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/media.h) \
>  	$(shell perl -ne 'print "$$1 " if /\#define\s+([^\s]+)\s+_IO/' $(srctree)/include/linux/v4l2-subdev.h) \
> +	VIDIOC_SUBDEV_G_SELECTION \
> +	VIDIOC_SUBDEV_S_SELECTION \
>  	VIDIOC_SUBDEV_G_FRAME_INTERVAL \
>  	VIDIOC_SUBDEV_S_FRAME_INTERVAL \
>  	VIDIOC_SUBDEV_ENUM_MBUS_CODE \
> 
> and rm Documentation/DocBook/media-entities.tmpl before you compile the
> documentation.

Uh, well, at least it wasn't magic... but not far from that: the names are
in unexpected place and different from what are referred to in the xml
files.

> 
> > >> +      <para>As for pad formats, drivers store try and active
> > >> +      rectangles for the selection targets of ACTIVE type <xref
> > >> +      linkend="v4l2-subdev-selection-targets">.</xref></para>
> > >> +
> > >> +      <para>On sink pads, cropping is applied relatively to the
> > >> +      current pad format. The pad format represents the image size as
> > >> +      received by the sub-device from the previous block in the
> > >> +      pipeline, and the crop rectangle represents the sub-image that
> > >> +      will be transmitted further inside the sub-device for
> > >> +      processing.</para>
> > >> +
> > >> +      <para>On source pads, cropping is similar to sink pads, with the
> > >> +      exception that the source size from which the cropping is
> > >> +      performed, is the COMPOSE rectangle on the sink pad. In both
> > >> +      sink and source pads, the crop rectangle must be entirely
> > >> +      containted inside the source image size for the crop
> > >> +      operation.</para>
> > >> +
> > >> +      <para>The drivers should always use the closest possible
> > >> +      rectangle the user requests on all selection targets, unless
> > >> +      specificly told otherwise<xref
> > >> +      linkend="v4l2-subdev-selection-flags">.</xref></para>
> > >> +    </section>
> > >> +
> > >> +    <section>
> > >> +      <title>Types of selection targets</title>
> > >> +
> > >> +      <section>
> > >> +	<title>ACTIVE targets</title>
> > >> +
> > >> +	<para>ACTIVE targets reflect the actual hardware configuration
> > >> +	at any point of time.</para>
> > >> +      </section>
> > >> +
> > >> +      <section>
> > >> +	<title>BOUNDS targets</title>
> > >> +
> > >> +	<para>BOUNDS targets is the smallest rectangle within which
> > >> +	contains all valid ACTIVE rectangles.
> > > 
> > > s/within which/that/ ?
> > 
> > Ack.
> > 
> > >> It may not be possible
> > >> +	to set the ACTIVE rectangle as large as the BOUNDS rectangle,
> > >> +	however.</para>
> > > 
> > > What about
> > > 
> > > "The BOUNDS rectangle might not itself be a valid ACTIVE rectangle when
> > > all possible ACTIVE pixels do not form a rectangular shape (e.g.
> > > cross-shaped or round sensors)."
> > 
> > There are cases where the active size is limited, even if it's
> > rectangular. I can add the above case there, sure, if you think such
> > devices exist --- I've never heard of nor seen them. Some sensors are
> > documented to be cross-shaped but the only thing separating these from
> > the rest is that the manufacturer doesn't guarantee the quality of the
> > pixels in the corners. At least on those I've seen. You can still
> > capture the full pixel matrix.
> 
> Those are just examples. I think it's useful to add them, otherwise the reader
> won't know why and under what kind of circumstances the ACTIVE rectangle can't
> be as large at the BOUNDS rectangle.

Ok. Added that, plus a note that the maximum size may also be smaller than
the bounds rectangle.

> > >> +      </section>
> > >> 
> > >> -      <para>Cropping behaviour on output pads is not defined.</para>
> > >> +    </section>
> > >> +
> > >> +    <section>
> > >> +      <title>Order of configuration and format propagation</title>
> > >> +
> > >> +      <para>Inside subdevs, the order of image processing steps will
> > >> +      always be from the sink pad towards the source pad. This is also
> > >> +      reflected in the order in which the configuration must be
> > >> +      performed by the user: the changes made will be propagated to
> > >> +      any subsequent stages. If this behaviour is not desired, the
> > >> +      user must set
> > >> +      <constant>V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG</constant> flag.
> > > 
> > > Could you explain what happens when V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG is
> > > set ? Just stating that it doesn't follow the propagation behaviour
> > > previously described could be understood in many different ways.
> > 
> > Good point. How about this:
> > 
> > "This flag causes that no propagation of the changes are allowed in any
> > circumstances. This may also lead the accessed rectangle not being
> > changed at all,
> 
> "The accessed rectangle will likely be adjusted by the driver,"

Why "likely"? I think it should say "may" instead, but this of course
depends on what the user asks.

> > depending on the properties of the underlying hardware.
> > Some drivers may not support this flag."
> 
> What should happen then ? Should the flag be ignored, or should the driver
> return an error ?

Only the SMIA++ driver supports this flag so far (as goes for the subdev
selection interface).

I think it should be ignored. Consider a situation that we add a new flag
which most of the drivers are unaware of.

As we're adding the flag right at the time the interface is introduced, we
could also require that all drivers must support it. How about that? In that
case I'd remove the last sentence of that paragraph.

...

> [snip]
> 
> > >> +    <table pgwide="1" frame="none" id="v4l2-subdev-selection-flags">
> > >> +      <title>V4L2 subdev selection flags</title>
> > >> +      <tgroup cols="3">
> > >> +        &cs-def;
> > >> +	<tbody valign="top">
> > >> +	  <row>
> > >> +	    <entry><constant>V4L2_SUBDEV_SEL_FLAG_SIZE_GE</constant></entry>
> > >> +	    <entry>(1 &lt;&lt; 0)</entry>
> > >> +	    <entry>Suggest the driver it should choose greater or
> > >> +	    equal rectangle (in size) than was requested.</entry>
> > >> +	  </row>
> > >> +	  <row>
> > >> +	    <entry><constant>V4L2_SUBDEV_SEL_FLAG_SIZE_LE</constant></entry>
> > >> +	    <entry>(1 &lt;&lt; 1)</entry>
> > >> +	    <entry>Suggest the driver it should choose lesser or
> > >> +	    equal rectangle (in size) than was requested.</entry>
> > >> +	  </row>
> > > 
> > > Those two flags are only briefly described here, could you add a more
> > > detailed description either here or in
> > > Documentation/DocBook/media/v4l/dev-subdev.xml ?
> > Added:
> > 
> >             " Albeit the driver may choose a lesser size,
> > 	    it will only do so due to hardware limitations. Without
> > 	    this flag (and
> > 	    <constant>V4L2_SUBDEV_SEL_FLAG_SIZE_LE</constant>) the
> > 	    behaviour is to choose the closest possible
> > 	    rectangle."
> > 
> > Does that cover your understanding of a more detailed description? :-)
> 
> I was thinking about something in media/v4l/dev-subdev.xml that would explain
> what the flags are used for. media/v4l/vidioc-subdev-g-selection.xml is more
> like reference documentation.

Ok. I'll add a note there.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
