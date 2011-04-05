Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:57007 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab1DEOyM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Apr 2011 10:54:12 -0400
Message-ID: <4D9B2D05.2070707@maxwell.research.nokia.com>
Date: Tue, 05 Apr 2011 17:53:57 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size videobuffer
 management
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange> <201104051359.18879.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1104051425030.14419@axis700.grange> <201104051456.29434.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201104051456.29434.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Laurent Pinchart wrote:
> Hi Guennadi,

Hi all,

> On Tuesday 05 April 2011 14:39:19 Guennadi Liakhovetski wrote:
>> On Tue, 5 Apr 2011, Laurent Pinchart wrote:
>>> On Friday 01 April 2011 10:13:02 Guennadi Liakhovetski wrote:
>>>> A possibility to preallocate and initialise buffers of different sizes
>>>> in V4L2 is required for an efficient implementation of asnapshot mode.
>>>> This patch adds three new ioctl()s: VIDIOC_CREATE_BUFS,
>>>> VIDIOC_DESTROY_BUFS, and VIDIOC_SUBMIT_BUF and defines respective data
>>>> structures.
> 
> [snip]
> 
>>>> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
>>>> index aa6c393..b6ef46e 100644
>>>> --- a/include/linux/videodev2.h
>>>> +++ b/include/linux/videodev2.h
>>>> @@ -1847,6 +1847,26 @@ struct v4l2_dbg_chip_ident {
> 
> [snip]
> 
>>>> +/* struct v4l2_createbuffers::flags */
>>>> +#define V4L2_BUFFER_FLAG_NO_CACHE_INVALIDATE	(1 << 0)
>>>
>>> Shouldn't cache management be handled at submit/qbuf time instead of
>>> being a buffer property ?
>>
>> hmm, I'd prefer fixing it at create. Or do you want to be able to create
>> buffers and then submit / queue them with different flags?...
> 
> That's the idea, yes. I'm not sure yet how useful that would be though.

I agree that it'd be nice to support this. It depends on where the data
is being used.

For example, you could have an algorithm on the host side which does
process the image data but only uses every second frame, with no other
processing done on the host CPU. In this case the cache would be flushed
needlessly for the frames that are not touched by the CPU.

I admit that this is fine optimisation but I don't think that should be
ruled out either.

The default cache behaviour would still be to flush not to break
existing applications, so I don't think this would be a significant
burden for applications.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
