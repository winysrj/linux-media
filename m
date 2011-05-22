Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:48374 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab1EVMPA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 May 2011 08:15:00 -0400
Message-ID: <4DD8FEF4.9080505@maxwell.research.nokia.com>
Date: Sun, 22 May 2011 15:17:56 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size videobuffer
 management
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange> <Pine.LNX.4.64.1104011010530.9530@axis700.grange> <Pine.LNX.4.64.1105121835370.24486@axis700.grange> <4DD12784.2000100@maxwell.research.nokia.com> <Pine.LNX.4.64.1105162144200.29373@axis700.grange> <4DD20D1C.4020808@maxwell.research.nokia.com> <Pine.LNX.4.64.1105221209480.8519@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1105221209480.8519@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Guennadi Liakhovetski wrote:
> On Tue, 17 May 2011, Sakari Ailus wrote:
> 
>> Guennadi Liakhovetski wrote:
> 
> [snip]
> 
>>> I don't understand this. We do _not_ want to allow holes in indices. For 
>>> now we decide to not implement DESTROY at all. In this case indices just 
>>> increment contiguously.
>>>
>>> The next stage is to implement DESTROY, but only in strict reverse order - 
>>> without holes and in the same ranges, as buffers have been CREATEd before. 
>>> So, I really don't understand why we need arrays, sorry.
>>
>> Well, now that we're defining a second interface to make new buffer
>> objects, I just thought it should be made as future-proof as we can. But
>> even with single index, it's always possible to issue the ioctl more
>> than once and achieve the same result as if there was an array of indices.
>>
>> What would be the reason to disallow creating holes to index range? I
>> don't see much reason from application or implementation point of view,
>> as we're even being limited to such low numbers.
> 
> I think, there are a few locations in V4L2, that assume, that for N number 
> of buffers currently allocated, their indices are 0...N-1. Just look for 
> loops like
> 
> 	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
> 
> in videobuf2-core.c.

This code is in implementation of videobuf2, it's not the spec. We're
designing a new interface here and its behaviour musn't be restrained by
the current codebase. The videobuf2 must be changed to support the new
ioctls in any case; those functions must be fixed as the support for
CREATE_BUF and other new IOCTLs is added to videobuf2.

The above loop also likely assumes that the index of the first video
buffer to be allocated is zero; this would mean that no more than one
allocation of n buffers could be made, defeating the purpose of the new
interface.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
