Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3578 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaH1QlW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Aug 2014 12:41:22 -0400
Message-ID: <53FF5B95.4030705@xs4all.nl>
Date: Thu, 28 Aug 2014 18:40:53 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC v2] [media] v4l2: add V4L2 pixel format array and helper
 functions
References: <1409043654-12252-1-git-send-email-p.zabel@pengutronix.de> <2323863.aLBeKZnVsL@avalon> <1409242175.2696.108.camel@paszta.hi.pengutronix.de> <2088388.O2EqQOIWv7@avalon>
In-Reply-To: <2088388.O2EqQOIWv7@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/28/2014 06:25 PM, Laurent Pinchart wrote:
> Hi Philipp,
> 
> On Thursday 28 August 2014 18:09:35 Philipp Zabel wrote:
>> Am Donnerstag, den 28.08.2014, 14:24 +0200 schrieb Laurent Pinchart:
>>>> A driver could then do the following:
>>>>
>>>> static struct v4l2_pixfmt_info driver_formats[] = {
>>>>
>>>> 	{ .pixelformat = V4L2_PIX_FMT_YUYV },
>>>> 	{ .pixelformat = V4L2_PIX_FMT_YUV420 },
>>>>
>>>> };
>>>>
>>>> int driver_probe(...)
>>>> {
>>>>
>>>> 	...
>>>> 	v4l2_init_pixfmt_array(driver_formats,
>>>> 	
>>>> 			ARRAY_SIZE(driver_formats));
>>>> 	
>>>> 	...
>>>>
>>>> }
>>>
>>> Good question. This option consumes more memory, and prevents the driver-
>>> specific format info arrays to be const, which bothers me a bit.
>>
>> Also, this wouldn't help drivers that don't want to take these
>> additional steps, which probably includes a lot of camera drivers with
>> only a few formats.
>>
>>> On the other hand it allows drivers to override some of the default
>>> values for odd cases.
>>
>> Hm, but those cases don't have to use the v4l2_pixfmt_info at all.
>>
>>> I won't nack this approach, but I'm wondering whether a better
>>> solution wouldn't be possible. Hans, Mauro, Guennadi, any opinion ?
>>
>> We could keep the global v4l2_pixfmt_info array sorted by fourcc value
>> and do a binary search (would have to be kept in mind when adding new
>> formats)
> 
> I like that option, provided we can ensure that the array is sorted. This can 
> get a bit tricky, and Hans might wear his "don't over-optimize" hat :-)

Well, for small sets of data (which this is) a binary search may well be
slower than a simple search. So yes, you should do some performance tests
before going with the more complex option.

By placing the commonly used pixel formats at the beginning of the list I
suspect a simple search is the fastest lookup method, and very easy to
implement as well.

Regards,

	Hans

> 
>> or build a hash table (more complicated code, consumes memory).
> 

