Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:32972 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab1HRUcL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 16:32:11 -0400
Date: Thu, 18 Aug 2011 23:32:07 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: RFC: Negotiating frame buffer size between sensor subdevs and
 bridge devices
Message-ID: <20110818203206.GG8872@valkosipuli.localdomain>
References: <4E31968B.9080603@samsung.com>
 <20110816222512.GF7436@valkosipuli.localdomain>
 <4E4C2302.3060105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E4C2302.3060105@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 17, 2011 at 10:22:26PM +0200, Sylwester Nawrocki wrote:
> On 08/17/2011 12:25 AM, Sakari Ailus wrote:
> > On Thu, Jul 28, 2011 at 07:04:11PM +0200, Sylwester Nawrocki wrote:
> >> Hello,
> > 
> > Hi Sylwester,
> 
> Hi Sakari,
> 
> kiitos commentti ;)

Hi Sylwester!

Ole hyvä! :)

> > 
> >> Trying to capture images in JPEG format with regular "image sensor ->
> >> mipi-csi receiver ->  host interface" H/W configuration I've found there
> >> is no standard way to communicate between the sensor subdev and the host
> >> driver what is exactly a required maximum buffer size to capture a frame.
> >>
> >> For the raw formats there is no issue as the buffer size can be easily
> >> determined from the pixel format and resolution (or sizeimage set on
> >> a video node).
> >> However compressed data formats are a bit more complicated, the required
> >> memory buffer size depends on multiple factors, like compression ratio,
> >> exact file header structure etc.
> >>
> >> Often it is at the sensor driver where all information required to
> >> determine size of the allocated memory is present. Bridge/host devices
> >> just do plain DMA without caring much what is transferred. I know of
> >> hardware which, for some pixel formats, once data capture is started,
> >> writes to memory whatever amount of data the sensor is transmitting,
> >> without any means to interrupt on the host side. So it is critical
> >> to assure the buffer allocation is done right, according to the sensor
> >> requirements, to avoid buffer overrun.
> >>
> >>
> >> Here is a link to somehow related discussion I could find:
> >> [1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg27138.html
> >>
> >>
> >> In order to let the host drivers query or configure subdevs with required
> >> frame buffer size one of the following changes could be done at V4L2 API:
> >>
> >> 1. Add a 'sizeimage' field in struct v4l2_mbus_framefmt and make subdev
> >>   drivers optionally set/adjust it when setting or getting the format with
> >>   set_fmt/get_fmt pad level ops (and s/g_mbus_fmt ?)
> >>   There could be two situations:
> >>   - effective required frame buffer size is specified by the sensor and the
> >>     host driver relies on that value when allocating a buffer;
> >>   - the host driver forces some arbitrary buffer size and the sensor performs
> >>     any required action to limit transmitted amount of data to that amount
> >>     of data;
> >> Both cases could be covered similarly as it's done with VIDIOC_S_FMT.
> >>
> >> Introducing 'sizeimage' field is making the media bus format struct looking
> >> more similar to struct v4l2_pix_format and not quite in line with media bus
> >> format meaning, i.e. describing data on a physical bus, not in the memory.
> >> The other option I can think of is to create separate subdev video ops.
> >> 2. Add new s/g_sizeimage subdev video operations
> >>
> >> The best would be to make this an optional callback, not sure if it makes sense
> >> though. It has an advantage of not polluting the user space API. Although
> >> 'sizeimage' in user space might be useful for some purposes I rather tried to
> >> focus on "in-kernel" calls.
> > 
> > I prefer this second approach over the first once since the maxiumu size of
> > the image in bytes really isn't a property of the bus.
> 
> After thinking some more about it I came to similar conclusion. I intended to
> find some better name for s/g_sizeimage callbacks and post relevant patch
> for consideration.
> Although I haven't yet found some time to carry on with this.

That sounds a possible solution to me as well. The upside would be that
v4l2_mbus_framefmt would be left to describe relatively low level bus and
format properties.

That said, I'm not anymore quite certain it should not be part of that
structure. Is the size always the same, or is this maximum?

> > How about a regular V4L2 control? You would also have minimum and maximum
> > values, I'm not quite sure whather this is a plus, though. :)
> 
> My intention was to have these calls used only internally in the kernel and
> do not allow the userspace to mess with it. All in all, if anything had 
> interfered and the host driver would have allocated too small buffer the system
> would crash miserably due to buffer overrun.

The user space wouldn't be allowed to do anything like that. E.g. the control
would become read-only during streaming and the bridge driver would need to
check its value against the sizes of the video buffers. Although this might
not be relevant at all if there are no direct ways to affect the maximum size
of the resulting image.

> The final buffer size for a JFIF/EXIF file will depend on other factors, like
> main image resolution, JPEG compression ratio, the thumbnail inclusion and its
> format/resolution, etc. I imagine we should be rather creating controls
> for those parameters.   
> 
> Also the driver would most likely have to validate the buffer size during 
> STREAMON call.
> 
> > 
> > Btw. how does v4l2_mbus_framefmt suit for compressed formats in general?
> > 
> 
> Well, there is really nothing particularly addressing the compressed formats
> in that struct. But we need to use it as the compressed data flows through 
> the media bus in same way as the raw data.
> It's rather hard to define the pixel codes using existing convention as there
> is no simple relationship between the pixel data and what is transferred on
> the bus.
> Yet I haven't run into issues other than no means to specify the whole image
> size.

I've never dealt with compressed image formats in drivers in general but I'd
suppose it might require taking this into account in the CSI-2 or the
parallel bus receivers.

How does this work in your case?

Is the image size actually used in programming the CSI-2 receiver? What
about the width and the height?

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
