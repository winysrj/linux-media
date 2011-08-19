Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59411 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1HSNNo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Aug 2011 09:13:44 -0400
Received: from spt2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LQ600MSEFEUA7@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 19 Aug 2011 14:13:42 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LQ600IE9FETA5@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 19 Aug 2011 14:13:41 +0100 (BST)
Date: Fri, 19 Aug 2011 15:13:38 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: RE: RFC: Negotiating frame buffer size between sensor subdevs and
 bridge devices
In-reply-to: <20110818203206.GG8872@valkosipuli.localdomain>
To: 'Sakari Ailus' <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Message-id: <002201cc5e71$cf2fe640$6d8fb2c0$%nawrocki@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: en-us
Content-transfer-encoding: 7BIT
References: <4E31968B.9080603@samsung.com>
 <20110816222512.GF7436@valkosipuli.localdomain> <4E4C2302.3060105@gmail.com>
 <20110818203206.GG8872@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 08/18/2011 10:32 PM, Sakari Ailus wrote:
>>>> In order to let the host drivers query or configure subdevs with 
>>>> required frame buffer size one of the following changes could be done
at V4L2 API:
>>>>
>>>> 1. Add a 'sizeimage' field in struct v4l2_mbus_framefmt and make subdev
>>>>    drivers optionally set/adjust it when setting or getting the format
with
>>>>    set_fmt/get_fmt pad level ops (and s/g_mbus_fmt ?)
>>>>    There could be two situations:
>>>>    - effective required frame buffer size is specified by the sensor
and the
>>>>      host driver relies on that value when allocating a buffer;
>>>>    - the host driver forces some arbitrary buffer size and the sensor
performs
>>>>      any required action to limit transmitted amount of data to that
amount
>>>>      of data;
>>>> Both cases could be covered similarly as it's done with VIDIOC_S_FMT.
>>>>
>>>> Introducing 'sizeimage' field is making the media bus format struct 
>>>> looking more similar to struct v4l2_pix_format and not quite in 
>>>> line with media bus format meaning, i.e. describing data on a physical
bus,
>>>> not in the memory.
>>>> The other option I can think of is to create separate subdev video ops.
>>>> 2. Add new s/g_sizeimage subdev video operations
>>>>
>>>> The best would be to make this an optional callback, not sure if it 
>>>> makes sense though. It has an advantage of not polluting the user 
>>>> space API. Although 'sizeimage' in user space might be useful for 
>>>> some purposes I rather tried to focus on "in-kernel" calls.
>>>
>>> I prefer this second approach over the first once since the maxiumu 
>>> size of the image in bytes really isn't a property of the bus.
>>
>> After thinking some more about it I came to similar conclusion. I 
>> intended to find some better name for s/g_sizeimage callbacks and 
>> post relevant patch for consideration.
>> Although I haven't yet found some time to carry on with this.
> 
> That sounds a possible solution to me as well. The upside would be 
> that v4l2_mbus_framefmt would be left to describe relatively low level 
> bus and format properties.
> 
> That said, I'm not anymore quite certain it should not be part of that 
> structure. Is the size always the same, or is this maximum?

The output size is not known in advance, due to the nature of compressed
formats, as you may know. So it's actually the maximum data size that
we need to fix up along the pipeline.

> 
>>> How about a regular V4L2 control? You would also have minimum and 
>>> maximum values, I'm not quite sure whather this is a plus, though. 
>>> :)
>>
>> My intention was to have these calls used only internally in the 
>> kernel and do not allow the userspace to mess with it. All in all, if 
>> anything had interfered and the host driver would have allocated too 
>> small buffer the system would crash miserably due to buffer overrun.
> 
> The user space wouldn't be allowed to do anything like that. E.g. the 
> control would become read-only during streaming and the bridge driver 
> would need to check its value against the sizes of the video buffers. 
> Although this might not be relevant at all if there are no direct ways 
> to affect the maximum size of the resulting image.

Ok, makes sense. AFAIK in most cases you will not be able to force an
exact size of the resulting image. The application may apply some high
threshold on the sensor (firmware), which it could then have considered
when applying other controls.
Nevertheless we need to have a consistent 'sizeimage' along the pipeline.

That said, if we used a control for that, it would be mostly GET on the
transmitter (sensor) and SET on the receiver AFAIU.

But I would like more to see it as a part of struct v4l2_mbus_framefmt.

> 
>> The final buffer size for a JFIF/EXIF file will depend on other 
>> factors, like main image resolution, JPEG compression ratio, the 
>> thumbnail inclusion and its format/resolution, etc. I imagine we 
>> should be rather creating controls for those parameters.
>>
>> Also the driver would most likely have to validate the buffer size 
>> during STREAMON call.
>>
>>>
>>> Btw. how does v4l2_mbus_framefmt suit for compressed formats in general?
>>>
>>
>> Well, there is really nothing particularly addressing the compressed 
>> formats in that struct. But we need to use it as the compressed data 
>> flows through the media bus in same way as the raw data.
>> It's rather hard to define the pixel codes using existing convention 
>> as there is no simple relationship between the pixel data and what is 
>> transferred on the bus.
>> Yet I haven't run into issues other than no means to specify the 
>> whole image size.
> 
> I've never dealt with compressed image formats in drivers in general 
> but I'd suppose it might require taking this into account in the CSI-2 
> or the parallel bus receivers.

I guess it matters when the MIPI-CSI receiver driver independently allocates
the buffers to store the received data there.
And in that case we have to pre-program the MIPI-CSI receiver subdev with
the maximum required size of the buffer. Thus it seems the 'sizeimage'
must be passed over in user space...
What do you think ?
Except the pixel resolution and format the buffer size might depend on
other controls, related to the compression process.
So it might not be known exactly at the time of set_fmt call.

> How does this work in your case?
> 
> Is the image size actually used in programming the CSI-2 receiver? 
> What about the width and the height?

With the hardware is used to work with - no. The pixel width and height
only matters for the raw formats. But the MIPI-CSI slave device in 
Samsung's SoCs is only a front-end to the capture engine, i.e. they're
hard wired with each other.

For the User Defined 1 format, which I have been using for JPEG capture,
once streaming is started any amount of data transmitted by the MIPI-CSI2
transmitter (the sensor) will be pushed into memory.
There is no means to pre-program an interrupt trigger after an arbitrary
Amount of data has been received.

The CSI2 standard does not define an exact frame structure for those
arbitrary byte-based formats. There is some more frame structure details
in the CSI-2 standard under the JPEG8 format, but I haven't seen any
hardware that supported this format yet.


Regards,
--
Sylwester Nawrocki
Samsung Poland R&D Center

