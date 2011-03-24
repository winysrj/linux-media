Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:25146 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933179Ab1CXILg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 04:11:36 -0400
Message-ID: <4D8AFD20.4000705@maxwell.research.nokia.com>
Date: Thu, 24 Mar 2011 10:13:20 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Michael Jones <michael.jones@matrix-vision.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?Lo=EFc_Akue?= <akue.loic@gmail.com>,
	Yordan Kamenov <ykamenov@mm-sol.com>
Subject: Re: [PATCH] omap3isp: implement ENUM_FMT
References: <4D889C61.905@matrix-vision.de> <201103231316.46934.laurent.pinchart@ideasonboard.com> <4D8AF29F.9010409@matrix-vision.de> <201103240842.43024.hverkuil@xs4all.nl>
In-Reply-To: <201103240842.43024.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hans Verkuil wrote:
> On Thursday, March 24, 2011 08:28:31 Michael Jones wrote:
>> Hi Laurent,
>>
>> On 03/23/2011 01:16 PM, Laurent Pinchart wrote:
>>> Hi Michael,
>>>
>> [snip]
>>>>
>>>> Is there a policy decision that in the future, apps will be required to
>>>> use libv4l to get images from the ISP?  Are we not intending to support
>>>> using e.g. media-ctl + some v4l2 app, as I'm currently doing during
>>>> development?
>>>
>>> Apps should be able to use the V4L2 API directly. However, we can't implement 
>>> all that API, as most calls don't make sense for the OMA3 ISP driver. Which 
>>> calls need to be implemented is a grey area at the moment, as there's no 
>>> detailed semantics on how subdev-level configuration and video device 
>>> configuration should interact.
> 
> We definitely need to discuss this in the near future. It's indeed a grey
> area at the moment that needs to be clarified.

I fully agree.

>>> Your implementation of ENUM_FMT looks correct to me, but the question is 
>>> whether ENUM_FMT should be implemented. I don't think ENUM_FMT is a required 
>>> ioctl, so maybe v4l2src shouldn't depend on it. I'm interesting in getting 
>>> Hans' opinion on this.
>>>
>>
>> I only implemented it after I saw that ENUM_FMT _was_ required by V4L2.
>>  From http://v4l2spec.bytesex.org/spec/x1859.htm#AEN1894 :
>> "The VIDIOC_ENUM_FMT ioctl must be supported by all drivers exchanging
>> image data with applications."
> 
> If you can call S_FMT on a device node, then you also have to implement
> ENUM_FMT.

I think the issue here is that it's not possible (or feasible) to
implement ENUM_FMT in a way applications would obtain the information
they're interested in. Available pixel formats are dictated by the
formats on links (validation must be done first in a generic case!) and
in the case of OMAP 3 ISP there's always just one.

S_FMT and TRY_FMT behave more or less the way applications like. The
pixelformat or size may not change, though, and this information is also
used to prepare the buffers.

> I am assuming applications need to call S_FMT for omap3 video nodes, right?
> Because that defines the result of the DMA engine. Or is the result always
> fixed, based on the current pipeline configuration? In the latter case I
> would still expect to see an ENUM_FMT, but one that just returns the current
> format. And S/TRY_FMT would also return the current format.

There are some options in the format that is not defined by the
v4l2_mbus_pixelcode already. Padding is such and I don't think there
should be anything else than that since the v4l2_mbus_pixelcode
conversion and scaling takes places in the subdevs. Laurent? :-)

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
