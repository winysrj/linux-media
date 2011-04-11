Return-path: <mchehab@gaivota>
Received: from smtp.nokia.com ([147.243.128.26]:38430 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab1DKL1e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 07:27:34 -0400
Message-ID: <4DA2E59B.3050108@maxwell.research.nokia.com>
Date: Mon, 11 Apr 2011 14:27:23 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hansverk@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size  videobuffer
 management
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange>    <Pine.LNX.4.64.1104070914540.24325@axis700.grange>    <058f16a20d747a5ef6b300e119fa69b4.squirrel@webmail.xs4all.nl>    <201104071117.59995.laurent.pinchart@ideasonboard.com> <67d14bc84cde1153c035ddff7efdcb8f.squirrel@webmail.xs4all.nl>
In-Reply-To: <67d14bc84cde1153c035ddff7efdcb8f.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Hans,

Hans Verkuil wrote:
>> Hi Hans,
>>
>> On Thursday 07 April 2011 09:50:13 Hans Verkuil wrote:
>>>> On Thu, 7 Apr 2011, Hans Verkuil wrote:
>>
>> [snip]
>>
>>>>> Regarding DESTROY_BUFS: perhaps we should just skip this for now and
>>> wait
>>>>> for the first use-case. That way we don't need to care about holes. I
>>>>> don't like artificial restrictions like 'no holes'. If someone has a
>>> good
>>>>> use-case for selectively destroying buffers, then we need to look at
>>> this
>>>>> again.
>>>>
>>>> Sorry, skip what? skip the ioctl completely and rely on REQBUFS(0) /
>>>> close()?
>>>
>>> Yes.
>>
>> I don't really like that as it would mix CREATE and REQBUFS calls.
>> Applications should either use the old API (REQBUFS) or the new one, but
>> not
>> mix both.
> 
> That's a completely unnecessary limitation. And from the point of view of
> vb2 it shouldn't even matter.

If calls to {CREATE,DESTROY}_BUF and REQBUFS are allowed to be mixed, it
would be nice to define the API so that one could implement REQBUFS
using CREATE_BUFS and DESTROY_BUFS. Then, drivers would not need to
implement REQBUFS separately which would still be used by majority of
applications. And Videobuf2 wouldn't need to implement REQBUFS at all.

Would this require more than to require buffer indices starting from
zero and be contiguous when there are no existing allocations?

The spec says under VIDIOC_QBUF that "Valid index numbers range from
zero to the number of buffers allocated with VIDIOC_REQBUFS (struct
v4l2_requestbuffers count) minus one."

>> The fact that freeing arbitrary spans of buffers gives us uneasy feelings
>> might be a sign that the CREATE/DESTROY API is not mature enough. I'd
>> rather
>> try to solve the issue now instead of postponing it for later and discover
>> that our CREATE API should have been different.
> 
> What gives me an uneasy feeling is prohibiting freeing arbitrary spans of
> buffers. I rather choose not to implement the DESTROY ioctl instead of
> implementing a limited version of it, also because we do not have proper
> use cases yet. But I have no problems with the CREATE/DESTROY API as such.

What would you think about using an array of index numbers rather than a
range for both? One must manage index number allocation even when using
a range and it might not be easier than to allocate all buffers from a
relatively small range (e.g. index numbers from 0 to 63), whose
implementation could be a bit field.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
