Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:40460 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab2AGJJE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jan 2012 04:09:04 -0500
Message-ID: <4F080BAF.1010800@maxwell.research.nokia.com>
Date: Sat, 07 Jan 2012 11:09:03 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
Subject: Re: [RFC 04/17] v4l: VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION
 IOCTLs
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <201201051712.00970.laurent.pinchart@ideasonboard.com> <4F06DA87.1050209@maxwell.research.nokia.com> <201201061300.40486.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201061300.40486.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Friday 06 January 2012 12:27:03 Sakari Ailus wrote:
>> Laurent Pinchart wrote:
>>> On Tuesday 20 December 2011 21:27:56 Sakari Ailus wrote:
>>>> From: Sakari Ailus <sakari.ailus@iki.fi>
>>>>
>>>> Add support for VIDIOC_SUBDEV_S_SELECTION and VIDIOC_SUBDEV_G_SELECTION
>>>> IOCTLs. They replace functionality provided by VIDIOC_SUBDEV_S_CROP and
>>>> VIDIOC_SUBDEV_G_CROP IOCTLs and also add new functionality (composing).
>>>>
>>>> VIDIOC_SUBDEV_G_CROP and VIDIOC_SUBDEV_S_CROP continue to be supported.
>>>
>>> As those ioctls are experimental, should we deprecate them ?
>>
>> I'm also in favour of doing that. But I'll make it a separate patch.
>>
>>>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>>>> ---
>>>>
>>>>  drivers/media/video/v4l2-subdev.c |   26 ++++++++++++++++++++-
>>>>  include/linux/v4l2-subdev.h       |   45
>>>>  ++++++++++++++++++++++++++++++++++ include/media/v4l2-subdev.h       |
>>>>     5 ++++
>>>>  3 files changed, 75 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/drivers/media/video/v4l2-subdev.c
>>>> b/drivers/media/video/v4l2-subdev.c index 65ade5f..e8ae098 100644
>>>> --- a/drivers/media/video/v4l2-subdev.c
>>>> +++ b/drivers/media/video/v4l2-subdev.c
>>>> @@ -36,13 +36,17 @@ static int subdev_fh_init(struct v4l2_subdev_fh *fh,
>>>> struct v4l2_subdev *sd) {
>>>>
>>>>  #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
>>>>  
>>>>  	/* Allocate try format and crop in the same memory block */
>>>>
>>>> -	fh->try_fmt = kzalloc((sizeof(*fh->try_fmt) + sizeof(*fh->try_crop))
>>>> +	fh->try_fmt = kzalloc((sizeof(*fh->try_fmt) + sizeof(*fh->try_crop)
>>>> +			       + sizeof(*fh->try_compose))
>>>>
>>>>  			      * sd->entity.num_pads, GFP_KERNEL);
>>>
>>> Could you check how the 3 structures are aligned on 64-bit platforms ?
>>> I'm a bit worried about the compiler expecting a 64-bit alignment for
>>> one of them, and getting only a 32-bit alignment in the end.
>>>
>>> What about using kcalloc ?
>>
>> kcalloc won't make a difference --- see the implementation. Do you think
>> this is really an issue in practice?
> 
> It won't make a difference for the alignment, it's just that we allocate an 
> array, so kcalloc seemed right.
> 
>> If we want to ensure alignment I'd just allocate them separately. Or
>> create a struct out of them locally, and get the pointers from that
>> struct --- then the alignment would be the same as if those were part of
>> a single struct. That achieves the desired result and also keeps error
>> handling trivial.
>>
>> I wouldn't want to start relying on the alignment based on the sizes of
>> these structures.
> 
> Sounds good to me. Allocating them as part of a bigger structure internally 
> could be more efficient than separate allocations, but I'm fine with both.

On second thought, I think I'll combine them into a new anonymous struct
the field name of which I call "pad", unless that requires too intrusive
changes in other drivers. How about that?

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
