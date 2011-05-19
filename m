Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:51247 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932460Ab1ESIJG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 04:09:06 -0400
Message-ID: <4DD4D0D2.7030609@maxwell.research.nokia.com>
Date: Thu, 19 May 2011 11:12:02 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Cohen <dacohen@gmail.com>,
	Kim HeungJun <riverful@gmail.com>, andrew.b.adams@gmail.com,
	Sung Hee Park <shpark7@stanford.edu>
Subject: Re: [RFC v4] V4L2 API for flash devices
References: <4DC2F131.6090407@maxwell.research.nokia.com> <201105071446.56843.hverkuil@xs4all.nl> <4DC5849A.9050806@gmail.com> <4DC7151E.8070601@maxwell.research.nokia.com> <4DC9A2D0.2060709@gmail.com> <4DD2DBDC.6060303@maxwell.research.nokia.com> <4DD4464C.30702@gmail.com>
In-Reply-To: <4DD4464C.30702@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Sylwester Nawrocki wrote:
> Hi Sakari,

Hi Sylwester,

> On 05/17/2011 10:34 PM, Sakari Ailus wrote:
>> Sylwester Nawrocki wrote:
>>> On 05/09/2011 12:11 AM, Sakari Ailus wrote:
>>>> Sylwester Nawrocki wrote:
>>>>> On 05/07/2011 02:46 PM, Hans Verkuil wrote:
>>>>>> On Thursday, May 05, 2011 20:49:21 Sakari Ailus wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> This is a fourth proposal for an interface for controlling flash devices
>>>>>>> on the V4L2/v4l2_subdev APIs.
> ...
>>>>>>> 3. Sensor metadata on frames
>>>>>>> ----------------------------
>>>>>>>
>>>>>>> It'd be useful to be able to read back sensor metadata. If the flash is
>>>>>>> strobed (on sensor hardware) while streaming, it's difficult to know
>>>>>>> otherwise which frame in the stream has been exposed with flash.
>>>>>>
>>>>>> I wonder if it would make sense to have a V4L2_BUF_FLAG_FLASH buffer
>>>>>> flag?
>>>>>> That way userspace can tell if that particular frame was taken with
>>>>>> flash.
>>>>>
>>>>> This looks more as a workaround for the problem rather than a good long
>>>>> term solution. It might be tempting to use the buffer flags which seem
>>>>> to be be more or less intended for buffer control.
>>>>> I'd like much more to see a buffer flags to be used to indicate whether
>>>>> an additional plane of (meta)data is carried by the buffer.
>>>>> There seem to be many more parameters, than a single flag indicating
>>>>> whether the frame has been exposed with flash or not, needed to be
>>>>> carried over to user space.
>>>>> But then we might need some standard format of the meta data, perhaps
>>>>> control id/value pairs and possibly a per plane configurable memory
>>>>> type.
>>>>
>>>> There are multiple possible approaches for this.
>>>>
>>>> For sensors where metadata is register-value pairs, that is, essentially
>>>> V4L2 control values, I think this should be parsed by the sensor driver.
>>>> The ISP (camera bridge) driver does receive the data so it'd have to
>>>> "ask for help" from the sensor driver.
>>>
>>> I am inclined to let the ISP drivers parse the data but on the other hand
>>> it might be difficult to access same DMA buffers in kernel _and_ user space.
>>
>> This is just about mapping the buffer to both kernel and user spaces. If
>> the ISP has an iommu the kernel mapping might already exist if it comes
>> from vmalloc().
> 
> Yes, I know. I was thinking of possibly required different mapping attributes
> for kernel and user space and the problems on ARM with that.

As I replied to Laurent, this is not an issue since the memory wouldn't
be mapped to user space. The user space would get the result which has
been interpreted by the sensor driver.

> Also as metadata is supposed to occupy only small part of a frame buffer perhaps
> only one page or so could be mapped in kernel space.
> I'm referring here mainly to SMIA++ method of storing metadata.

Yes, I agree.

> In case of sensors I used to work with it wouldn't be necessary to touch the
> main frame buffers as the metadata is transmitted out of band.

This depends on link a little, but on CSI-2 this is a separate channel.
In other cases the metadata is part of the frame --- but I don't know
anyone using metadata in such a case, so it _might_ be possible to just
ignore this use case.

Another alternative would be to pass binary blobs to user space and let
a library to interpret the data. This might be the way to go at least
with some more exotic cases.

>>
>>>> As discussed previously, using V4L2 control events shouldn't probably be
>>>> the way to go, but I think it's obvious that this is _somehow_ bound to
>>>> controls, at least control ids.
>>>>
>>>>> Also as Sakari indicated some sensors adopt custom meta data formats
>>>>> so maybe we need to introduce standard fourcc like IDs for meta data
>>>>> formats? I am not sure whether it is possible to create common
>>>>> description of an image meta data that fits all H/W.
>>>>
>>>> I'm not sure either since I know of only one example. That example, i.e.
>>>> register-value pairs, should be something that I'd assume _some_ other
>>>> hardware uses as well, but there could exist also hardware which
>>>> doesn't. This solution might not work on that hardware.
>>>
>>> Of course it's hard to find a silver bullet for a hardware we do not know ;)
>>>
>>>>
>>>> If there is metadata which does not associate to V4L2 controls (or
>>>> ioctls), either existing or not yet existing, then that probably should
>>>> be parsed by the driver. On the other hand, I can't think of metadata
>>>> that wouldn't fall under this right now. :-)
>>>
>>> Some metadata are arrays of length specific to a given attribute,
>>> I wonder how to support that with v4l2 controls ?
>>
>> Is the metadata something which really isn't associated to any V4L2
>> control? Are we now talking about a sensor which is more complex than a
>> regular raw bayer sensor?
> 
> I referred to tags defined in EXIF standard, as you may know every tag
> is basically an array of specific data type. For most tag types the array
> length is 1 though.
> Similar problem is solved by the V4L extended string controls API.
> 
> And yes this kind of tags are mostly produced by more powerful ISPs,
> with, for instance, 3A or distortion corrections implemented in their firmware.
> So this is a little bit different situation than a raw sensor with OMAP3 ISP.

True.

>>>> Do you know more examples of sensor produced metadata than SMIA++?
>>>
>>> The only metadata I've had a bit experience with was regular EXIF tags
>>> which could be retrieved from ISP through I2C bus.
>>
>> That obviously won't map to V4L2 controls.
>>
>> This should very likely be just passed to user space as-is as
>> different... plane?
> 
> Yes, but I am trying to assess whether it's possible to create some
> generic tag data structure so such plane contains an array of such 
> data structures and application would know how to handle that. 
> Independently of the underlying H/W.

There's one issue I see --- the kernel drivers do know how to interpret
the data, but then again the user space must be able to tell which part
of the data the user space is interested in. In many cases I'd assume
it's just one or two variables within a 8k (or so) metadata block.

I think it would be ideal if the sensor driver would be able to
interpret the data (or parts of it) and pass them to the user space. But
I don't know how generic this is, taken your example of rational numbers
used in metadata below.

>> In some cases it's time critical to pass data to user space that
>> otherwise could be associated with a video buffer. I wonder if this case
>> is time critical or not.
> 
> No, it's rather no time critical. The frame data is buffered inside ISP,
> even in case of multi-frame capture mode.
> But, of course, we also need to consider a time critical case.

I think in a time critical case, there must be an event to tell that the
data has arrived, or alternatively, if it's passed to user space as
such, a new video node for that. The set of buffers is different from
the image buffers, so a new video buffer queue is required.

>>> These were mostly fixed point arithmetic numbers in [32-bit numerator/
>>> 32-bit denominator] form carrying exposure time, shutter speed, aperture,
>>> brightness, flash, etc. information. The tags could be read from ISP after
>>> it buffered a frame in its memory and processed it.
>>> In case of a JPEG image format the tags can be embedded into the main
>>> image file. But the image processors not always supported that so we used
>>> to have an ioctl for the purpose of retrieving the metadata in user space.
>>> In some cases it is desired to read data directly from the driver rather
>>> than parsing a relatively large buffer.
>>> It would be good to have a uniform interface for passing such data to
>>> applications. I think in that particular use case a control id/value pair
>>> sequences would do.
>>
>> Do you think this is "control id" or non-control id, and whether the
>> value is the same data type than the V4L2 control would be? That would
>> match to what I'm aware of, too.
> 
> Whatever id ;) I started with controls because they have defined data types.
> A list of attributes in my case could be mapped to control ids.
> But data types are different, the values are represented by rational numbers.

What do they represent? They should be in the same units the sensor is
programmed with, but somehow I feel the sensor is trying to be smarter
than it should be.

> But perhaps we could define a generic list of attributes for metadata, together
> with a generic tag data structure ?

There are a few buts:

- The data can be something up to kilobytes in size. We don't want to
parse all of it per every frame unless it's really necessary. Most often
the user is interested in just a few items while it might like to get
all of it sometimes. This could be probably resolved relatively easily,
though.

- Which formats are your rational numbers in? A kernel interface can't
really have floating point numbers, so there would need to be a sane way
to pass these to user space.

- What kind of other types of metadata we could run into? Would it fit
to this interface?

> I'm not yet even sure if it would be acceptable to interpret a data plane in user
> space as an array of some type of data structure. 

If the data structure is known to user space, then it's definitely fine.

As an alternative, I'm thinking of a library which would be generic but
its interface would not be a kernel/user space interface which will
never change. My worry is that with two examples (or did you have
more?), can we design an interface generic enough for hopefully
everyone? My knowledge of sensor metadata is limited to just these
examples. The answer may well be yes, though.

Kind regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
