Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4302 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaH1RdS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Aug 2014 13:33:18 -0400
Message-ID: <53FF67A5.8000607@xs4all.nl>
Date: Thu, 28 Aug 2014 19:32:21 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	kernel@pengutronix.de,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC v2] [media] v4l2: add V4L2 pixel format array and helper
 functions
References: <1409043654-12252-1-git-send-email-p.zabel@pengutronix.de> <2323863.aLBeKZnVsL@avalon> <1409242175.2696.108.camel@paszta.hi.pengutronix.de> <2088388.O2EqQOIWv7@avalon> <53FF5B95.4030705@xs4all.nl> <20140828141851.54899cae.m.chehab@samsung.com>
In-Reply-To: <20140828141851.54899cae.m.chehab@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/28/2014 07:18 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 28 Aug 2014 18:40:53 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 08/28/2014 06:25 PM, Laurent Pinchart wrote:
>>> Hi Philipp,
>>>
>>> On Thursday 28 August 2014 18:09:35 Philipp Zabel wrote:
>>>> Am Donnerstag, den 28.08.2014, 14:24 +0200 schrieb Laurent Pinchart:
>>>>>> A driver could then do the following:
>>>>>>
>>>>>> static struct v4l2_pixfmt_info driver_formats[] = {
>>>>>>
>>>>>> 	{ .pixelformat = V4L2_PIX_FMT_YUYV },
>>>>>> 	{ .pixelformat = V4L2_PIX_FMT_YUV420 },
>>>>>>
>>>>>> };
>>>>>>
>>>>>> int driver_probe(...)
>>>>>> {
>>>>>>
>>>>>> 	...
>>>>>> 	v4l2_init_pixfmt_array(driver_formats,
>>>>>> 	
>>>>>> 			ARRAY_SIZE(driver_formats));
>>>>>> 	
>>>>>> 	...
>>>>>>
>>>>>> }
>>>>>
>>>>> Good question. This option consumes more memory, and prevents the driver-
>>>>> specific format info arrays to be const, which bothers me a bit.
>>>>
>>>> Also, this wouldn't help drivers that don't want to take these
>>>> additional steps, which probably includes a lot of camera drivers with
>>>> only a few formats.
>>>>
>>>>> On the other hand it allows drivers to override some of the default
>>>>> values for odd cases.
>>>>
>>>> Hm, but those cases don't have to use the v4l2_pixfmt_info at all.
>>>>
>>>>> I won't nack this approach, but I'm wondering whether a better
>>>>> solution wouldn't be possible. Hans, Mauro, Guennadi, any opinion ?
>>>>
>>>> We could keep the global v4l2_pixfmt_info array sorted by fourcc value
>>>> and do a binary search (would have to be kept in mind when adding new
>>>> formats)
>>>
>>> I like that option, provided we can ensure that the array is sorted. This can 
>>> get a bit tricky, and Hans might wear his "don't over-optimize" hat :-)
> 
> The big issue is that, afaikt, there's no way to make gcc to order it,
> so the order would need to be manually ensured. This is challenging, and
> makes the review process complex if done right.
> 
> I really don't see any gain on applying such patch. If the concern is
> just about properly naming the pixel formats, it is a way easier to use
> some defines for the names, and use the defines.

It's not just the names, also the bit depth etc. Most drivers need that information
and having it in a central place simplifies driver design. Yes, it slightly
increases the amount of memory, but that is insignificant compared to the huge
amount of memory necessary for video buffers. And reducing driver complexity is
always good since that has always been the main problem with drivers, not memory
or code performance.

> Btw, that's how we solved
> this issue at rc core:
> 	http://git.linuxtv.org/cgit.cgi/media_tree.git/tree/include/media/rc-map.h
> 
> Also, that means a less footprint for tiny Kernels.
> 
>> Well, for small sets of data (which this is) a binary search may well be
>> slower than a simple search. So yes, you should do some performance tests
>> before going with the more complex option.
> 
> with 128 pixformats, a binary search takes 8 ifs against 128.

Actually, that's 64 on average. Even less if you know that some formats will
be searched for a lot more frequently than others and you can order your data
accordingly.

> So, it
> should be faster.

Binary search has a lot more overhead than a simple array traversal. I did
experiments with this when I worked on the control framework, and it was
very surprising how slow binary search was compared to a simple linked list
traversal. I think I needed well over 100 elements before the binary search
became faster. You really need to test things like this if you know the data
set is relatively small.

> 
> Yet, even on a very slow machine, seeking for 128 formats is still
> likely fast enough to not affect performance of a media application.

I agree with that.
 
>> By placing the commonly used pixel formats at the beginning of the list I
>> suspect a simple search is the fastest lookup method, and very easy to
>> implement as well.
> 
> IMHO, we shouldn't apply this approach, as we're just growing the
> Kernel size without any real benefit.

Simplifying drivers is the real benefit.

Regards,

	Hans
