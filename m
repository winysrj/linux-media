Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16821 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933132Ab1ERNDR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 09:03:17 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-15
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LLE00MVC6XECV10@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 May 2011 14:03:16 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LLE00D676XD0H@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 May 2011 14:03:14 +0100 (BST)
Date: Wed, 18 May 2011 15:03:13 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 0/2] V4L: Extended crop/compose API
In-reply-to: <201105181431.59580.hansverk@cisco.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sakari.ailus@maxwell.research.nokia.com
Message-id: <4DD3C391.3060407@samsung.com>
References: <1304588396-7557-1-git-send-email-t.stanislaws@samsung.com>
 <201105160921.29283.laurent.pinchart@ideasonboard.com>
 <4DD3B63D.1060105@samsung.com> <201105181431.59580.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05/18/2011 02:31 PM, Hans Verkuil wrote:
> On Wednesday, May 18, 2011 14:06:21 Sylwester Nawrocki wrote:
>> On 05/16/2011 09:21 AM, Laurent Pinchart wrote:
>> > On Saturday 14 May 2011 12:50:32 Hans Verkuil wrote:
>> >> On Friday, May 13, 2011 14:43:08 Laurent Pinchart wrote:
>> >>> On Saturday 07 May 2011 13:52:25 Hans Verkuil wrote:
>> >>>> On Thursday, May 05, 2011 11:39:54 Tomasz Stanislawski wrote:
>> >
> 
>> > [snip]
>> ...
> 
>> >>>>> * resolution of an image combined with support for
> 
>> >>>>> VIDIOC_S_MULTISELECTION
> 
>> >>>>>
> 
>> >>>>> allows to pass a triple format/crop/compose sizes in a single
> 
>> >>>>> ioctl
> 
>> >>>>
> 
>> >>>> I don't believe S_MULTISELECTION will solve anything. Specific
> 
>> >>>> use-cases perhaps, but not the general problem of setting up a
> 
>> >>>> pipeline. I feel another brainstorm session coming to solve that. We
> 
>> >>>> never came to a solution for it in Warsaw.
> 
>> >>>
> 
>> >>> Pipelines are configured on subdev nodes, not on video nodes, so I'm also
> 
>> >>> unsure whether multiselection support would really be useful.
> 
>> >>>
> 
>> >>> If we decide to implement multiselection support, we might as well use
> 
>> >>> that only. We would need a multiselection target bitmask, so selection
> 
>> >>> targets should all be < 32.
> 
>> >>>
> 
>> >>> Thinking some more about it, does it make sense to set both crop and
> 
>> >>> compose on a single video device node (not talking about mem-to-mem,
> 
>> >>> where you use the type to multiplex input/output devices on the same
> 
>> >>> node) ? If so, what would the use cases be ?
> 
>>
> 
>> I can't think of any, one either use crop or compose.
> 
> 
> I can: you crop in the video receiver and compose it into a larger buffer.
> 
> Actually quite a desirable feature.

Yes, right. Don't know why I imagined something different.
And we need it in Samsung capture capture interfaces as well. The H/W
is capable of cropping and composing with camera interface as a data source
similarly as it is done with memory buffers.


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
