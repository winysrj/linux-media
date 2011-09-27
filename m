Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4148 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab1I0NxA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 09:53:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 2/4] v4l: add documentation for selection API
Date: Tue, 27 Sep 2011 15:52:20 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi
References: <1314793703-32345-1-git-send-email-t.stanislaws@samsung.com> <201109271120.29606.hverkuil@xs4all.nl> <4E81D14F.2020304@samsung.com>
In-Reply-To: <4E81D14F.2020304@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109271552.20159.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, September 27, 2011 15:36:15 Tomasz Stanislawski wrote:
> Hi Hans,
> Thank you for a quick review :).
> 
> On 09/27/2011 11:20 AM, Hans Verkuil wrote:
> > On Wednesday, August 31, 2011 14:28:21 Tomasz Stanislawski wrote:
> >> This patch adds a documentation for VIDIOC_{G/S}_SELECTION ioctl. Moreover, the
> >> patch adds the description of modeling of composing, cropping and scaling
> >> features in V4L2. Finally, some examples are presented.
> >>
> >> Signed-off-by: Tomasz Stanislawski<t.stanislaws@samsung.com>
> >> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> >> ---
> >>   Documentation/DocBook/media/constraints.png.b64    |  134 +
> >>   Documentation/DocBook/media/selection.png.b64      | 2937 ++++++++++++++++++++
> >>   Documentation/DocBook/media/v4l/common.xml         |    4 +-
> >>   Documentation/DocBook/media/v4l/selection-api.xml  |  278 ++
> >>   Documentation/DocBook/media/v4l/v4l2.xml           |    1 +
> >>   .../DocBook/media/v4l/vidioc-g-selection.xml       |  281 ++
> >>   6 files changed, 3634 insertions(+), 1 deletions(-)
> >>   create mode 100644 Documentation/DocBook/media/constraints.png.b64
> >>   create mode 100644 Documentation/DocBook/media/selection.png.b64
> >>   create mode 100644 Documentation/DocBook/media/v4l/selection-api.xml
> >>   create mode 100644 Documentation/DocBook/media/v4l/vidioc-g-selection.xml
> >>
> >> diff --git a/Documentation/DocBook/media/constraints.png.b64 b/Documentation/DocBook/media/constraints.png.b64
> >> new file mode 100644
> >> index 0000000..1e5a136
> >> --- /dev/null
> >> +++ b/Documentation/DocBook/media/constraints.png.b64
> >
> > For future reference: please put binary files in a separate patch. That makes
> > it easier to review the non-binary parts.
> >
> ok.
> >> diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
> >> index a86f7a0..9c41c32 100644
> >> --- a/Documentation/DocBook/media/v4l/common.xml
> >> +++ b/Documentation/DocBook/media/v4l/common.xml
> >> @@ -856,8 +856,10 @@ conversion routine or library for integration into applications.</para>
> >>
> >>     &sub-planar-apis;
> >>
> >> +&sub-selection-api;
> >> +
> >>     <section id="crop">
> >> -<title>Image Cropping, Insertion and Scaling</title>
> >> +<title>Deprecated API for image cropping, insertion and scaling</title>
> >
> > I wouldn't call this deprecated. It's part of the API and we will just keep on
> > supporting this.
> >
> > I would instead refer to the new section on the selection API.
> >
> 
> I decided to mark the selection as an experimental API for now. I agree 
> that it was too hasty to deprecate old API.
> 
> >>
> >>       <para>Some video capture devices can sample a subsection of the
> >>   picture and shrink or enlarge it to an image of arbitrary size. We
> >> diff --git a/Documentation/DocBook/media/v4l/selection-api.xml b/Documentation/DocBook/media/v4l/selection-api.xml
> >> new file mode 100644
> >> index 0000000..d9fd57d8
> >> --- /dev/null
> >> +++ b/Documentation/DocBook/media/v4l/selection-api.xml
> >> @@ -0,0 +1,278 @@
> >> +<section id="selection-api">
> >> +
> >> +<title>Cropping, composing and scaling</title>
> >> +
> 
> [snip]
> 
> >> +<para>The range of coordinates of the top left corner, width and height of a
> >> +area which can be sampled is given by the<constant>  V4L2_SEL_CROP_BOUNDS
> >> +</constant>  target. To support a wide range of hardware this specification does
> >> +not define an origin or units.</para>
> >
> > I know this phrase is present in the crop API, but I've never liked it. It makes
> > life very hard for applications if the units aren't in pixels.
> 
> Why?

Basically it is a lot of calculations that you have to do. In my experience
you just want to crop to a specific area of the image. The combination of
arbitrary units and origin makes it difficult to calculate the right cropping
rectangle. Actually using sub-pixel cropping is something I have never seen
anyone do. Perhaps in 1% of the cases you might want something like that, but
then I think that is something that should be explicitly set up.

What's the use case for sub-pixel cropping/composing anyway? And how would you
use sub-pixel composing into a buffer?

> > The main reason
> > the crop API was written in that way was for analog video receivers: while analog
> > TV has discrete lines, in the horizontal direction there really isn't a clear
> > 'pixel' concept. However, I've always thought that was a bogus argument since
> > after sampling you end up with pixels anyway.
> 
> It looks that the problem is the scaling. The unit system should just 
> guarantee that no scaling is applied if the size of the crop rectangle 
> is equal to the size of the compose rectangle. Am I wrong?

That's certainly true. But not really my point. In the vast majority of all
use-cases you deal with pixels. So that's a natural and easy to use unit IMHO.

> What do you think about adding the mentioned requirement?
> 
> >
> > In my opinion the selection API should deal with pixels only. The main driver
> > where this might cause problems is bttv. I'm not sure how the selection vs crop
> > API translation would work there. It might be best to just keep the current crop
> > implementation in bttv and make a separate selection implementation. I'm pretty
> > sure the bttv driver actually does/can do sub-pixel cropping.
> 
> The crop simulation using the selection api is applied only if s_crop or 
> s_cropcap are not implemented. Therefore a driver can implement both 
> APIs separately.

Right.
 
> >
> > With respect to the origin: I think I would put the top-left corner of the
> > default crop rectangle at (0, 0). Strictly speaking it shouldn't matter where
> > the origin is, but it seems to me that that's a logical choice.
> 
> OK. It is logical to put the origin at (0,0) but why forcing it? Maybe 
> it should be only a recommendation for driver developers.

Making it a recommendation is fine by me.

> >
> >> +<para>The top left corner, width and height of the source rectangle, that is
> >> +the area actually sampled, is given by<constant>  V4L2_SEL_CROP_ACTIVE
> >> +</constant>  target. It uses the same coordinate system as<constant>
> >> +V4L2_SEL_CROP_BOUNDS</constant>. The active cropping area must lie completely
> >> +inside the capture boundaries. The driver may further adjust the requested size
> >> +and/or position according to hardware limitations.</para>
> 
> [snip]
> 
> >> +<para>The part of a video signal or graphics display where the image is
> >> +inserted by the hardware is controlled by<constant>  V4L2_SEL_COMPOSE_ACTIVE
> >> +</constant>  target.  The rectangle's coordinates are expressed driver dependant
> >> +units. The only exception are digital outputs where the units are pixels.
> >
> > Same as before: I would always use pixels as units.
> >
> 
> The units system should only guarantee that there is no scaling if the 
> sizes of the crop and the compose rectangles are equal. I prefer to 
> avoid forcing the usage of the pixel units in every context.
> 
> >> The
> >> +composing rectangle must lie completely inside bounds rectangle.  The driver
> >> +must adjust the area to fit to the bounding limits. Moreover, the driver can
> >> +perform other adjustments according to hardware limitations.</para>
> >> +
> >> +<para>The device has a default composing rectangle, given by the<constant>
> >> +V4L2_SEL_COMPOSE_DEFAULT</constant>  target. The center of this rectangle shall
> >> +align with the center of the active picture area of the video signal, and cover
> >> +what the driver writer considers the complete picture.
> >
> > I would remove the 'align with the center of the active picture area' part.
> > I think the second part of that sentence is sufficient.
> >
> 
> OK. The first sentence is redundant.
> 
> > In addition, just like with capture, I would suggest that the origin of the default
> > compose rectangle is set to (0, 0).
> 
> I think that (0,0) origin should be only a recommendation.
> 
> >
> >> Drivers shall reset the
> >> +composing rectangle to the default one when the driver is first loaded.</para>
> >> +
> 
> [snip]
> 
> >> +<title>struct<structname>v4l2_selection</structname></title>
> >> +<tgroup cols="3">
> >> +	&cs-str;
> >> +	<tbody valign="top">
> >> +	<row>
> >> +	<entry>__u32</entry>
> >> +	<entry><structfield>type</structfield></entry>
> >> +	<entry>Type of the buffer (from&v4l2-buf-type;)</entry>
> >> +	</row>
> >> +	<row>
> >> +	<entry>__u32</entry>
> >> +	<entry><structfield>target</structfield></entry>
> >> +<entry>used to select between cropping and composing rectangles</entry>
> >> +	</row>
> >> +	<row>
> >> +	<entry>__u32</entry>
> >> +	<entry><structfield>flags</structfield></entry>
> >> +<entry>control over coordinates adjustments, refer to<link linkend="v4l2-sel-flags">selection flags</link></entry>
> >> +	</row>
> >> +	<row>
> >> +	<entry>&v4l2-rect;</entry>
> >> +	<entry><structfield>r</structfield></entry>
> >> +	<entry>selection rectangle</entry>
> >> +	</row>
> >> +	<row>
> >> +	<entry>__u32</entry>
> >> +	<entry><structfield>reserved[9]</structfield></entry>
> >> +	<entry>Reserved fields for future use, adjust size to 64 bytes</entry>
> >
> > I would remove the 'adjust size' part. It's not relevant here.
> >
> 
> OK.
> [snip]
> 
> >
> > BTW, I think it might be a good idea to do one more post of this patch series.
> > There have been several reviews after your git pull request, so I think it's
> > just a bit too early to have this merged. One more round is probably enough.
> >
> 
> I am preparing the new version that covers issues pointed by you, 
> Laurent and Mauro.
> 
> Could you state your opinion about Mauro's comments?

I haven't read his comments yet :-)

Regards,

	Hans

> 
> Regards,
> Tomasz Stanislawski
> 
> 
> > Regards,
> >
> > 	Hans
> >
> 
