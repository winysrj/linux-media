Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47746 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab1ERHKi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 03:10:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC v4] V4L2 API for flash devices
Date: Wed, 18 May 2011 09:10:32 +0200
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	David Cohen <dacohen@gmail.com>,
	Kim HeungJun <riverful@gmail.com>, andrew.b.adams@gmail.com,
	Sung Hee Park <shpark7@stanford.edu>
References: <4DC2F131.6090407@maxwell.research.nokia.com> <4DC9A2D0.2060709@gmail.com> <4DD2DBDC.6060303@maxwell.research.nokia.com>
In-Reply-To: <4DD2DBDC.6060303@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105180910.32988.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari,

On Tuesday 17 May 2011 22:34:36 Sakari Ailus wrote:
> Sylwester Nawrocki wrote:
> > On 05/09/2011 12:11 AM, Sakari Ailus wrote:
> >> Sylwester Nawrocki wrote:
> >>> On 05/07/2011 02:46 PM, Hans Verkuil wrote:
> >>>> On Thursday, May 05, 2011 20:49:21 Sakari Ailus wrote:
> >>>>> Hi,
> >>>>> 
> >>>>> This is a fourth proposal for an interface for controlling flash
> >>>>> devices on the V4L2/v4l2_subdev APIs.
> >>>>> 
> >>>>> I want to thank everyone who have participated to the development of
> >>>>> the flash interface.
> >>>>> 
> >>>>> Comments and questions are very, very welcome as always.
> >>>>> 
> >>>>> 
> >>>>> Changes since v3 [12]
> >>>>> =====================
> >>>>> 
> >>>>> - V4L2_CID_FLASH_STROBE changed to button control,
> >>>>> V4L2_CID_FLASH_STROBE_STOP button control added,
> >>>>> V4L2_CID_FLASH_STROBE_STATUS boolean control added.
> >>>>> 
> >>>>> - No reason to say xenon flashes can't use V4L2_CID_FLASH_STROBE.
> >>>>> 
> >>>>> - V4L2_CID_FLASH_STROBE_WHENCE changed to V4L2_CID_FLASH_STROBE_MODE.
> >>>>> 
> >>>>> - V4L2_CID_TORCH_INTENSITY renamed to V4L2_CID_FLASH_TORCH_INTENSITY
> >>>>> and V4L2_CID_INDICATOR_INTENSITY renamed to
> >>>>> V4L2_CID_FLASH_INDICATOR_INTENSITY.
> >>>>> 
> >>>>> - Moved V4L2_CID_FLASH_EXTERNAL_STROBE_MODE under "Possible future
> >>>>> extensions".
> >>> 
> >>> [snip]
> >>> 
> >>>>> 3. Sensor metadata on frames
> >>>>> ----------------------------
> >>>>> 
> >>>>> It'd be useful to be able to read back sensor metadata. If the flash
> >>>>> is strobed (on sensor hardware) while streaming, it's difficult to
> >>>>> know otherwise which frame in the stream has been exposed with
> >>>>> flash.
> >>>> 
> >>>> I wonder if it would make sense to have a V4L2_BUF_FLAG_FLASH buffer
> >>>> flag?
> >>>> That way userspace can tell if that particular frame was taken with
> >>>> flash.
> >>> 
> >>> This looks more as a workaround for the problem rather than a good long
> >>> term solution. It might be tempting to use the buffer flags which seem
> >>> to be be more or less intended for buffer control.
> >>> I'd like much more to see a buffer flags to be used to indicate whether
> >>> an additional plane of (meta)data is carried by the buffer.
> >>> There seem to be many more parameters, than a single flag indicating
> >>> whether the frame has been exposed with flash or not, needed to be
> >>> carried over to user space.
> >>> But then we might need some standard format of the meta data, perhaps
> >>> control id/value pairs and possibly a per plane configurable memory
> >>> type.
> >> 
> >> There are multiple possible approaches for this.
> >> 
> >> For sensors where metadata is register-value pairs, that is, essentially
> >> V4L2 control values, I think this should be parsed by the sensor driver.
> >> The ISP (camera bridge) driver does receive the data so it'd have to
> >> "ask for help" from the sensor driver.
> > 
> > I am inclined to let the ISP drivers parse the data but on the other hand
> > it might be difficult to access same DMA buffers in kernel _and_ user
> > space.
> 
> This is just about mapping the buffer to both kernel and user spaces. If
> the ISP has an iommu the kernel mapping might already exist if it comes
> from vmalloc().

And we're also trying to get rid of that mapping to facilitate cache 
management. Any API we create for metadata parsing will need to take potential 
cache-related performances issues into account at the design stage.

> >> As discussed previously, using V4L2 control events shouldn't probably be
> >> the way to go, but I think it's obvious that this is _somehow_ bound to
> >> controls, at least control ids.
> >> 
> >>> Also as Sakari indicated some sensors adopt custom meta data formats
> >>> so maybe we need to introduce standard fourcc like IDs for meta data
> >>> formats? I am not sure whether it is possible to create common
> >>> description of an image meta data that fits all H/W.
> >> 
> >> I'm not sure either since I know of only one example. That example, i.e.
> >> register-value pairs, should be something that I'd assume _some_ other
> >> hardware uses as well, but there could exist also hardware which
> >> doesn't. This solution might not work on that hardware.
> > 
> > Of course it's hard to find a silver bullet for a hardware we do not know
> > ;)
> > 
> >> If there is metadata which does not associate to V4L2 controls (or
> >> ioctls), either existing or not yet existing, then that probably should
> >> be parsed by the driver. On the other hand, I can't think of metadata
> >> that wouldn't fall under this right now. :-)
> > 
> > Some metadata are arrays of length specific to a given attribute,
> > I wonder how to support that with v4l2 controls ?
> 
> Is the metadata something which really isn't associated to any V4L2
> control? Are we now talking about a sensor which is more complex than a
> regular raw bayer sensor?
> 
> >> Do you know more examples of sensor produced metadata than SMIA++?
> > 
> > The only metadata I've had a bit experience with was regular EXIF tags
> > which could be retrieved from ISP through I2C bus.
> 
> That obviously won't map to V4L2 controls.
> 
> This should very likely be just passed to user space as-is as
> different... plane?
> 
> In some cases it's time critical to pass data to user space that
> otherwise could be associated with a video buffer. I wonder if this case
> is time critical or not.
> 
> > These were mostly fixed point arithmetic numbers in [32-bit numerator/
> > 32-bit denominator] form carrying exposure time, shutter speed, aperture,
> > brightness, flash, etc. information. The tags could be read from ISP
> > after it buffered a frame in its memory and processed it.
> > In case of a JPEG image format the tags can be embedded into the main
> > image file. But the image processors not always supported that so we used
> > to have an ioctl for the purpose of retrieving the metadata in user
> > space. In some cases it is desired to read data directly from the driver
> > rather than parsing a relatively large buffer.
> > It would be good to have a uniform interface for passing such data to
> > applications. I think in that particular use case a control id/value pair
> > sequences would do.
> 
> Do you think this is "control id" or non-control id, and whether the
> value is the same data type than the V4L2 control would be? That would
> match to what I'm aware of, too.

-- 
Regards,

Laurent Pinchart
