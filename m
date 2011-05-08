Return-path: <mchehab@gaivota>
Received: from smtp.nokia.com ([147.243.1.48]:28684 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab1EHWIy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 May 2011 18:08:54 -0400
Message-ID: <4DC7151E.8070601@maxwell.research.nokia.com>
Date: Mon, 09 May 2011 01:11:42 +0300
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
References: <4DC2F131.6090407@maxwell.research.nokia.com> <201105071446.56843.hverkuil@xs4all.nl> <4DC5849A.9050806@gmail.com>
In-Reply-To: <4DC5849A.9050806@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Sylwester Nawrocki wrote:
> Hi Hans,

Hi Sylwester, Hans,

> On 05/07/2011 02:46 PM, Hans Verkuil wrote:
>> On Thursday, May 05, 2011 20:49:21 Sakari Ailus wrote:
>>> Hi,
>>>
>>> This is a fourth proposal for an interface for controlling flash devices
>>> on the V4L2/v4l2_subdev APIs.
>>>
>>> I want to thank everyone who have participated to the development of the
>>> flash interface.
>>>
>>> Comments and questions are very, very welcome as always.
>>>
>>>
>>> Changes since v3 [12]
>>> =====================
>>>
>>> - V4L2_CID_FLASH_STROBE changed to button control,
>>> V4L2_CID_FLASH_STROBE_STOP button control added,
>>> V4L2_CID_FLASH_STROBE_STATUS boolean control added.
>>>
>>> - No reason to say xenon flashes can't use V4L2_CID_FLASH_STROBE.
>>>
>>> - V4L2_CID_FLASH_STROBE_WHENCE changed to V4L2_CID_FLASH_STROBE_MODE.
>>>
>>> - V4L2_CID_TORCH_INTENSITY renamed to V4L2_CID_FLASH_TORCH_INTENSITY and
>>> V4L2_CID_INDICATOR_INTENSITY renamed to
>>> V4L2_CID_FLASH_INDICATOR_INTENSITY.
>>>
>>> - Moved V4L2_CID_FLASH_EXTERNAL_STROBE_MODE under "Possible future
>>> extensions".
>>>
> 
> [snip]
> 
>>>
>>> 3. Sensor metadata on frames
>>> ----------------------------
>>>
>>> It'd be useful to be able to read back sensor metadata. If the flash is
>>> strobed (on sensor hardware) while streaming, it's difficult to know
>>> otherwise which frame in the stream has been exposed with flash.
>>
>> I wonder if it would make sense to have a V4L2_BUF_FLAG_FLASH buffer
>> flag?
>> That way userspace can tell if that particular frame was taken with
>> flash.
> 
> This looks more as a workaround for the problem rather than a good long
> term solution. It might be tempting to use the buffer flags which seem
> to be be more or less intended for buffer control.
> I'd like much more to see a buffer flags to be used to indicate whether
> an additional plane of (meta)data is carried by the buffer.
> There seem to be many more parameters, than a single flag indicating
> whether the frame has been exposed with flash or not, needed to be
> carried over to user space.
> But then we might need some standard format of the meta data, perhaps
> control id/value pairs and possibly a per plane configurable memory
> type.

There are multiple possible approaches for this.

For sensors where metadata is register-value pairs, that is, essentially
V4L2 control values, I think this should be parsed by the sensor driver.
The ISP (camera bridge) driver does receive the data so it'd have to
"ask for help" from the sensor driver.

As discussed previously, using V4L2 control events shouldn't probably be
the way to go, but I think it's obvious that this is _somehow_ bound to
controls, at least control ids.

> Also as Sakari indicated some sensors adopt custom meta data formats
> so maybe we need to introduce standard fourcc like IDs for meta data
> formats? I am not sure whether it is possible to create common
> description of an image meta data that fits all H/W.

I'm not sure either since I know of only one example. That example, i.e.
register-value pairs, should be something that I'd assume _some_ other
hardware uses as well, but there could exist also hardware which
doesn't. This solution might not work on that hardware.

If there is metadata which does not associate to V4L2 controls (or
ioctls), either existing or not yet existing, then that probably should
be parsed by the driver. On the other hand, I can't think of metadata
that wouldn't fall under this right now. :-)

Do you know more examples of sensor produced metadata than SMIA++?

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
