Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4955 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab1CEOCp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Mar 2011 09:02:45 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: David Cohen <dacohen@gmail.com>
Subject: Re: [GIT PULL FOR 2.6.39] Media controller and OMAP3 ISP driver
Date: Sat, 5 Mar 2011 15:02:11 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	alsa-devel@alsa-project.org,
	Sakari Ailus <sakari.ailus@retiisi.org.uk>,
	Pawel Osciak <pawel@osciak.com>
References: <201102171606.58540.laurent.pinchart@ideasonboard.com> <201103051252.12342.hverkuil@xs4all.nl> <AANLkTi=SS3CBkKUdovU33SQi=s9gNprZszKaMrkRGqGy@mail.gmail.com>
In-Reply-To: <AANLkTi=SS3CBkKUdovU33SQi=s9gNprZszKaMrkRGqGy@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103051502.11472.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, March 05, 2011 14:04:21 David Cohen wrote:
> Hi Hans,
> 
> On Sat, Mar 5, 2011 at 1:52 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Friday, March 04, 2011 21:10:05 Mauro Carvalho Chehab wrote:
> >> Em 03-03-2011 07:25, Laurent Pinchart escreveu:
> >> > Hi Mauro,
> >> >
> >> > The following changes since commit 88a763df226facb74fdb254563e30e9efb64275c:
> >> >
> >> >   [media] dw2102: prof 1100 corrected (2011-03-02 16:56:54 -0300)
> >> >
> >> > are available in the git repository at:
> >> >   git://linuxtv.org/pinchartl/media.git media-2.6.39-0005-omap3isp
> >> >
> >> > The branch has been rebased on top of the latest for_v2.6.39 branch, with the
> >> > v4l2-ioctl.c conflict resolved.
> >> >
> >> > Antti Koskipaa (1):
> >> >       v4l: v4l2_subdev userspace crop API
> >> >
> >> > David Cohen (1):
> >> >       omap3isp: Statistics
> >> >
> >> > Laurent Pinchart (36):
> >> >       v4l: Share code between video_usercopy and video_ioctl2
> >> >       v4l: subdev: Don't require core operations
> >> >       v4l: subdev: Add device node support
> >> >       v4l: subdev: Uninline the v4l2_subdev_init function
> >> >       v4l: subdev: Control ioctls support
> >> >       media: Media device node support
> >> >       media: Media device
> >> >       media: Entities, pads and links
> >> >       media: Entity use count
> >> >       media: Media device information query
> >> >       media: Entities, pads and links enumeration
> >> >       media: Links setup
> >> >       media: Pipelines and media streams
> >> >       v4l: Add a media_device pointer to the v4l2_device structure
> >> >       v4l: Make video_device inherit from media_entity
> >> >       v4l: Make v4l2_subdev inherit from media_entity
> >> >       v4l: Move the media/v4l2-mediabus.h header to include/linux
> >> >       v4l: Replace enums with fixed-sized fields in public structure
> >> >       v4l: Rename V4L2_MBUS_FMT_GREY8_1X8 to V4L2_MBUS_FMT_Y8_1X8
> >> >       v4l: Group media bus pixel codes by types and sort them alphabetically
> >>
> >> The presence of those mediabus names against the traditional fourcc codes
> >> at the API adds some mess to the media controller. Not sure how to solve,
> >> but maybe the best way is to add a table at the V4L2 API associating each
> >> media bus format to the corresponding V4L2 fourcc codes.
> >
> > You can't do that in general. Only for specific hardware platforms. If you
> > could do it, then we would have never bothered creating these mediabus fourccs.
> >
> > How a mediabus fourcc translates to a pixelcode (== memory format) depends
> > entirely on the hardware capabilities (mostly that of the DMA engine).
> 
> May I ask you one question here? (not entirely related to this patch set).
> Why pixelcode != mediabus fourcc?
> e.g. OMAP2 camera driver talks to sensor through subdev interface and
> sets its own output pixelformat depending on sensor's mediabus fourcc.

The media bus deals with how pixels are transferred over a physical bus.
For example 10-bit RGB samples. But how those samples end up in memory
is quite a different story: depending on the (DMA) hardware this might
end up as a 24-bit RGB format (8 bits per sample), or a multi-planar format
where one plane has the top 8 bits and another plane the lower 2 bits, or
it might go through a built-in colorspace convertor, and let's not forget
the endianness issues you get once you DMA into memory.

So mediabus formats are quite different from memory formats. In certain
simple cases the mapping may be straightforward, but not in the general case.

In a nutshell: mediabus deals with how two devices stream media over a bus
between one another, whereas pixelformats deal with how the media is encoded
in memory.

Hope this helps.

Regards,

	Hans

> So it needs a translation table mbus_pixelcode -> pixelformat. Why
> can't it be pixelformat -> pixelformat ?
> 
> Regards,
> 
> David
> 
> >
> > A generic V4L2 application will never use mediabus fourcc codes. It's only used
> > by drivers and applications written specifically for that hardware and using
> > /dev/v4l-subdevX devices.
> >
> > Regards,
> >
> >        Hans
> >
> > --
> > Hans Verkuil - video4linux developer - sponsored by Cisco
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
