Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:52113 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab1ERTzX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 15:55:23 -0400
Message-ID: <4DD424DD.2070508@maxwell.research.nokia.com>
Date: Wed, 18 May 2011 22:58:21 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size videobuffer
 management
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange> <Pine.LNX.4.64.1105162144200.29373@axis700.grange> <4DD20D1C.4020808@maxwell.research.nokia.com> <201105181601.23093.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1105181642510.16324@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1105181642510.16324@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi and Laurent,

Guennadi Liakhovetski wrote:
> On Wed, 18 May 2011, Laurent Pinchart wrote:
> 
>> On Tuesday 17 May 2011 07:52:28 Sakari Ailus wrote:
>>> Guennadi Liakhovetski wrote:
> 
> [snip]
> 
>>>>> What about making it possible to pass an array of buffer indices to the
>>>>> user, just like VIDIOC_S_EXT_CTRLS does? I'm not sure if this would be
>>>>> perfect, but it would avoid the problem of requiring continuous ranges
>>>>> of buffer ids.
>>>>>
>>>>> struct v4l2_create_buffers {
>>>>>
>>>>> 	__u32			*index;
>>>>> 	__u32			count;
>>>>> 	__u32			flags;
>>>>> 	enum v4l2_memory        memory;
>>>>> 	__u32			size;
>>>>> 	struct v4l2_format	format;
>>>>>
>>>>> };
>>>>>
>>>>> Index would be a pointer to an array of buffer indices and its length
>>>>> would be count.
>>>>
>>>> I don't understand this. We do _not_ want to allow holes in indices. For
>>>> now we decide to not implement DESTROY at all. In this case indices just
>>>> increment contiguously.
>>>>
>>>> The next stage is to implement DESTROY, but only in strict reverse order
>>>> - without holes and in the same ranges, as buffers have been CREATEd
>>>> before. So, I really don't understand why we need arrays, sorry.
>>>
>>> Well, now that we're defining a second interface to make new buffer
>>> objects, I just thought it should be made as future-proof as we can.
>>
>> I second that. I don't like rushing new APIs to find out we need something 
>> else after 6 months.
> 
> Ok, so, we pass an array from user-space with CREATE of size count. The 
> kernel fills it with as many buffers entries as it has allocated. But 
> currently drivers are also allowed to allocate more buffers, than the 
> user-space has requested. What do we do in such a case?

That's a good point.

But even if there was no array, shouldn't the user be allowed to create
the buffers using a number of separate CREATE_BUF calls? The result
would be still the same n buffers as with a single call allocating the n
buffers at once.

Also, consider the (hopefully!) forthcoming DMA buffer management API
patches. It looks like that those buffers will be referred to by file
handles. To associate several DMA buffer objects to V4L2 buffers at
once, there would have to be an array of those objects.

<URL:http://www.spinics.net/lists/linux-media/msg32448.html>

(See the links, too!)

Thus, I would think that CREATE_BUF can be used to create buffers but
not to enforce how many of them are required by a device on a single
CREATE_BUF call.

I don't have a good answer for the stated problem, but these ones
crossed my mind:

- Have a new ioctl to tell the minimum number of buffers to make
streaming possible.

- Add a field for the minimum number of buffers to CREATE_BUF.

- Use the old REQBUFS to tell the number. It didn't do much other work
in the past either, right?

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
