Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:46348 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964898Ab1JFNbu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2011 09:31:50 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LSN003K6C90N050@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 Oct 2011 14:31:48 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LSN009RJC8Z1P@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 Oct 2011 14:31:48 +0100 (BST)
Date: Thu, 06 Oct 2011 15:31:47 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 3/3] [media] tvp5150: Migrate to media-controller framework
 and add video format detection
In-reply-to: <201110061406.13117.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Javier Martinez Canillas <martinez.javier@gmail.com>,
	linux-media@vger.kernel.org, Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>
Message-id: <4E8DADC3.4050206@samsung.com>
References: <1317429231-11359-1-git-send-email-martinez.javier@gmail.com>
 <201110060923.14797.hverkuil@xs4all.nl> <4E8D9633.5040303@infradead.org>
 <201110061406.13117.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/06/2011 02:06 PM, Hans Verkuil wrote:
> On Thursday 06 October 2011 13:51:15 Mauro Carvalho Chehab wrote:
>> Em 06-10-2011 04:23, Hans Verkuil escreveu:
>>> On Thursday, October 06, 2011 09:09:26 Hans Verkuil wrote:
>>>> On Thursday, October 06, 2011 02:32:33 Mauro Carvalho Chehab wrote:
>>>>> Also, I couldn't see a consense about input selection on drivers that
>>>>> implement MC: they could either implement S_INPUT, create one V4L
>>>>> device node for each input, or create just one devnode and let
>>>>> userspace (somehow) to discover the valid inputs and set the pipelines
>>>>> via MC/pad.
>>>>
>>>> I don't follow. I haven't seen any MC driver yet that uses S_INPUT as
>>>> that generally doesn't make sense. But for a device like tvp5150 we
>>>> probably need it since the tvp5150 has multiple inputs. This is
>>>> actually an interesting challenge how to implement this as this is
>>>> platform-level knowledge. I suspect that the only way to do this that
>>>> is sufficiently generic is to model this with MC links.
>>
>> $ git grep s_input drivers/media/video/s5p-*
>> drivers/media/video/s5p-fimc/fimc-capture.c:      .vidioc_s_input          
>>       = fimc_cap_s_input,
>>
>> The current code does nothing, but take a look at what was there before
>> changeset 3e002182.

Hmm, now I believe it was a mistake to originally push a half-usable driver
to mainline. It seems like the rule push early/push often just didn't work
out here. Perhaps this driver should have been merged to staging at first
place.

>>
>>  From the discussions we had at the pull request that s_input code were
>> being changed/removed, It became clear to me that omap3 drivers took one
>> direction, and s5p drivers took another direction, in terms on how to
>> associate the V4L2 device nodes with the IP blocks.

Before the MC existed in mainline the s5p capture driver hard coded some
policies in the kernel and only a part of functionality was exposed to user
space. E.g. camera could only work with instance 0 of the IP and only
parallel interface was supported. That's why s_input could be usable there.
The OMAP3 ISP driver have taken the right approach from the beginning.

> 
> From what I remember the s5p drivers converged/are converging on the same
> approach as omap3. I don't believe there is any discussion anymore on what is 
> the correct method.

Yes, plus the s5p driver creates default data paths so it possible to just
open a video node and start streaming. 
The original interface is retained, except the s_input behaviour. Which I
believe is not any meaningful issue to the applications, since they can be
coded to support one video node with two inputs or two video nodes with one
input, with any kernel version. Everything can be detected, enumerated and set
using plain old V4L2 capture interface.

>>>> All these libraries are on Laurent's site. Can we please move it to
>>>> linuxtv?
>>
>> Yes, please.
>>
>>>> Mauro, wouldn't it be a good idea to create a media-utils.git and merge
>>>> v4l-utils, dvb-apps and these new media utils/libs in there?
>>
>> I like that idea. I remember that some dvb people argued against when we
>> first come to it, but I think that merging both is the right thing to do.
>>
>> In any case, libmediactl/libv4l2subdev should, IMHO, be part of the
>> v4l-utils.
>>
>> I suggest to open a separate thread for this subject.
>>
>> For stable distros, merging packages are painful, as their policies may
>> forbid package source removal. So, maybe it makes sense to have something
>> like: "./configure --disable-[feature]" in order to allow them to keep
>> maintaining separate sources for separate parts of a media-utils tree.
>> That also means that a "--disable-libv4l" would force libv4l-aware
>> applications to be built statically linked.
> 
> Seems very complicated to me. But I'll start a separate thread for this.
> 
> ...
> 
>>>> Whether or not you include a scaler in the default pipeline is optional
>>>> as far as I am concerned.
>>
>> I think that such default pipeline should include a scaler, especially if
>> the sensor(s)/demod(s) on such pipeline don't have it.
> 
> That would be the ideal situation, yes, but for now I'd be happy just to get a 
> picture out of an SoC :-)

I agree. 

> 
> Regards,
> 
> 	Hans


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
