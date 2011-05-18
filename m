Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:58656 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab1ERH1Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 03:27:24 -0400
Message-ID: <4DD3758B.7030006@maxwell.research.nokia.com>
Date: Wed, 18 May 2011 10:30:19 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sylwester Nawrocki <snjw23@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	David Cohen <dacohen@gmail.com>,
	Kim HeungJun <riverful@gmail.com>, andrew.b.adams@gmail.com,
	Sung Hee Park <shpark7@stanford.edu>
Subject: Re: [RFC v4] V4L2 API for flash devices
References: <4DC2F131.6090407@maxwell.research.nokia.com> <4DC9A2D0.2060709@gmail.com> <4DD2DBDC.6060303@maxwell.research.nokia.com> <201105180910.32988.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105180910.32988.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Laurent Pinchart wrote:
> Hi Sakari,

Hi Laurent,

> On Tuesday 17 May 2011 22:34:36 Sakari Ailus wrote:
>> Sylwester Nawrocki wrote:
>>> On 05/09/2011 12:11 AM, Sakari Ailus wrote:
>>>> Sylwester Nawrocki wrote:
>>>>> On 05/07/2011 02:46 PM, Hans Verkuil wrote:
>>>>>> On Thursday, May 05, 2011 20:49:21 Sakari Ailus wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> This is a fourth proposal for an interface for controlling flash
>>>>>>> devices on the V4L2/v4l2_subdev APIs.
>>>>>>>
>>>>>>> I want to thank everyone who have participated to the development of
>>>>>>> the flash interface.
>>>>>>>
>>>>>>> Comments and questions are very, very welcome as always.
>>>>>>>
>>>>>>>
>>>>>>> Changes since v3 [12]
>>>>>>> =====================
>>>>>>>
>>>>>>> - V4L2_CID_FLASH_STROBE changed to button control,
>>>>>>> V4L2_CID_FLASH_STROBE_STOP button control added,
>>>>>>> V4L2_CID_FLASH_STROBE_STATUS boolean control added.
>>>>>>>
>>>>>>> - No reason to say xenon flashes can't use V4L2_CID_FLASH_STROBE.
>>>>>>>
>>>>>>> - V4L2_CID_FLASH_STROBE_WHENCE changed to V4L2_CID_FLASH_STROBE_MODE.
>>>>>>>
>>>>>>> - V4L2_CID_TORCH_INTENSITY renamed to V4L2_CID_FLASH_TORCH_INTENSITY
>>>>>>> and V4L2_CID_INDICATOR_INTENSITY renamed to
>>>>>>> V4L2_CID_FLASH_INDICATOR_INTENSITY.
>>>>>>>
>>>>>>> - Moved V4L2_CID_FLASH_EXTERNAL_STROBE_MODE under "Possible future
>>>>>>> extensions".
>>>>>
>>>>> [snip]
>>>>>
>>>>>>> 3. Sensor metadata on frames
>>>>>>> ----------------------------
>>>>>>>
>>>>>>> It'd be useful to be able to read back sensor metadata. If the flash
>>>>>>> is strobed (on sensor hardware) while streaming, it's difficult to
>>>>>>> know otherwise which frame in the stream has been exposed with
>>>>>>> flash.
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
>>> it might be difficult to access same DMA buffers in kernel _and_ user
>>> space.
>>
>> This is just about mapping the buffer to both kernel and user spaces. If
>> the ISP has an iommu the kernel mapping might already exist if it comes
>> from vmalloc().
> 
> And we're also trying to get rid of that mapping to facilitate cache 
> management. Any API we create for metadata parsing will need to take potential 
> cache-related performances issues into account at the design stage.

In this case, it's not necessary to map this memory to user space at all
so the kernel mapping would be the only one.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
