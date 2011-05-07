Return-path: <mchehab@gaivota>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64530 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab1EGRm4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 May 2011 13:42:56 -0400
Received: by eyx24 with SMTP id 24so1232789eyx.19
        for <linux-media@vger.kernel.org>; Sat, 07 May 2011 10:42:55 -0700 (PDT)
Message-ID: <4DC5849A.9050806@gmail.com>
Date: Sat, 07 May 2011 19:42:50 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Cohen <dacohen@gmail.com>,
	Kim HeungJun <riverful@gmail.com>, andrew.b.adams@gmail.com,
	Sung Hee Park <shpark7@stanford.edu>
Subject: Re: [RFC v4] V4L2 API for flash devices
References: <4DC2F131.6090407@maxwell.research.nokia.com> <201105071446.56843.hverkuil@xs4all.nl>
In-Reply-To: <201105071446.56843.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Hans,

On 05/07/2011 02:46 PM, Hans Verkuil wrote:
> On Thursday, May 05, 2011 20:49:21 Sakari Ailus wrote:
>> Hi,
>>
>> This is a fourth proposal for an interface for controlling flash devices
>> on the V4L2/v4l2_subdev APIs.
>>
>> I want to thank everyone who have participated to the development of the
>> flash interface.
>>
>> Comments and questions are very, very welcome as always.
>>
>>
>> Changes since v3 [12]
>> =====================
>>
>> - V4L2_CID_FLASH_STROBE changed to button control,
>> V4L2_CID_FLASH_STROBE_STOP button control added,
>> V4L2_CID_FLASH_STROBE_STATUS boolean control added.
>>
>> - No reason to say xenon flashes can't use V4L2_CID_FLASH_STROBE.
>>
>> - V4L2_CID_FLASH_STROBE_WHENCE changed to V4L2_CID_FLASH_STROBE_MODE.
>>
>> - V4L2_CID_TORCH_INTENSITY renamed to V4L2_CID_FLASH_TORCH_INTENSITY and
>> V4L2_CID_INDICATOR_INTENSITY renamed to V4L2_CID_FLASH_INDICATOR_INTENSITY.
>>
>> - Moved V4L2_CID_FLASH_EXTERNAL_STROBE_MODE under "Possible future
>> extensions".
>>

[snip]

>>
>> 3. Sensor metadata on frames
>> ----------------------------
>>
>> It'd be useful to be able to read back sensor metadata. If the flash is
>> strobed (on sensor hardware) while streaming, it's difficult to know
>> otherwise which frame in the stream has been exposed with flash.
>
> I wonder if it would make sense to have a V4L2_BUF_FLAG_FLASH buffer flag?
> That way userspace can tell if that particular frame was taken with flash.

This looks more as a workaround for the problem rather than a good long 
term solution. It might be tempting to use the buffer flags which seem
to be be more or less intended for buffer control.
I'd like much more to see a buffer flags to be used to indicate whether
an additional plane of (meta)data is carried by the buffer.
There seem to be many more parameters, than a single flag indicating 
whether the frame has been exposed with flash or not, needed to be 
carried over to user space.
But then we might need some standard format of the meta data, perhaps
control id/value pairs and possibly a per plane configurable memory
type.

Also as Sakari indicated some sensors adopt custom meta data formats
so maybe we need to introduce standard fourcc like IDs for meta data
formats? I am not sure whether it is possible to create common 
description of an image meta data that fits all H/W.

--
Regards,
Sylwester
