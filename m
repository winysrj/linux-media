Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:35303 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab1HAOy5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Aug 2011 10:54:57 -0400
Message-ID: <4E36BE4F.7080704@iki.fi>
Date: Mon, 01 Aug 2011 17:55:11 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH v3] V4L: add two new ioctl()s for multi-size videobuffer
 management
References: <Pine.LNX.4.64.1107201025120.12084@axis700.grange> <201107261305.29863.hverkuil@xs4all.nl> <20110726114427.GC32507@valkosipuli.localdomain> <201107261357.31673.hverkuil@xs4all.nl> <Pine.LNX.4.64.1108011031150.30975@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1108011031150.30975@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski wrote:
> On Tue, 26 Jul 2011, Hans Verkuil wrote:
> 
>> On Tuesday, July 26, 2011 13:44:28 Sakari Ailus wrote:
>>> Hi Hans and Guennadi,
>>
>> <snip>
>>
>>>> I realized that it is not clear from the documentation whether it is possible to call
>>>> VIDIOC_REQBUFS and make additional calls to VIDIOC_CREATE_BUFS afterwards.
>>>
>>> That's actually a must if one wants to release buffers. Currently no other
>>> method than requesting 0 buffers using REQBUFS is provided (apart from
>>> closing the file handle).
>>
>> I was referring to the non-0 use-case :-)
>>
>>>> I can't remember whether the code allows it or not, but it should be clearly documented.
>>>
>>> I would guess no user application would have to call REQBUFS with other than
>>> zero buffers when using CREATE_BUFS. This must be an exception if mixing
>>> REQBUFS and CREATE_BUFS is not allowed in general. That said, I don't see a
>>> reason to prohibit either, but perhaps Guennadi has more informed opinion
>>> on this.
>>  
>> <snip>
>>
>>>>>>> Future functionality which would be nice:
>>>>>>>
>>>>>>> - Format counters. Every format set by S_FMT (or gotten by G_FMT) should
>>>>>>>   come with a counter value so that the user would know the format of
>>>>>>>   dequeued buffers when setting the format on-the-fly. Currently there are
>>>>>>>   only bytesperline and length, but the format can't be explicitly
>>>>>>>   determined from those.
>>>>
>>>> Actually, the index field will give you that information. When you create the
>>>> buffers you know that range [index, index + count - 1] is associated with that
>>>> specific format.
>>>
>>> Some hardware is able to change the format while streaming is ongoing (for
>>> example: OMAP 3). The problem is that the user should be able to know which
>>> frame has the new format.
> 
> How exactly does this work or should it work? You mean, you just configure 
> your hardware with new frame size parameters without stopping the current 
> streaming, and the ISP will change frame sizes, beginning with some future 
> frame? How does the driver then get to know, which frame already has the 

That's correct.

> new sizes? You actually want to know this in advance to already queue a 
> suitably sized buffer to the hardware?

The driver knows that since it has configured the hardware to produce
that frame size.

The assumption is that all the buffers have suitable size for all the
formats. This must be checked by the driver, something which also must
be taken into account.

-- 
Sakari Ailus
sakari.ailus@iki.fi
