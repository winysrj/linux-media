Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:44414 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054Ab1ESOHs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 10:07:48 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LLG009RT4KXZW80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 19 May 2011 15:07:45 +0100 (BST)
Received: from [106.116.48.223] by spt1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LLG00F4C4KSYX@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 19 May 2011 15:07:44 +0100 (BST)
Date: Thu, 19 May 2011 16:06:12 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 0/2] V4L: Extended crop/compose API
In-reply-to: <201105191547.50175.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hansverk@cisco.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	sakari.ailus@maxwell.research.nokia.com
Message-id: <4DD523D4.8060807@samsung.com>
References: <1304588396-7557-1-git-send-email-t.stanislaws@samsung.com>
 <201105181431.59580.hansverk@cisco.com> <4DD3C391.3060407@samsung.com>
 <201105191547.50175.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Laurent Pinchart wrote:
> On Wednesday 18 May 2011 15:03:13 Sylwester Nawrocki wrote:
>> On 05/18/2011 02:31 PM, Hans Verkuil wrote:
>>> On Wednesday, May 18, 2011 14:06:21 Sylwester Nawrocki wrote:
>>>> On 05/16/2011 09:21 AM, Laurent Pinchart wrote:
>>>>> On Saturday 14 May 2011 12:50:32 Hans Verkuil wrote:
>>>>>> On Friday, May 13, 2011 14:43:08 Laurent Pinchart wrote:
>>>>>>> Thinking some more about it, does it make sense to set both crop and
>>>>>>> compose on a single video device node (not talking about mem-to-mem,
>>>>>>> where you use the type to multiplex input/output devices on the same
>>>>>>> node) ? If so, what would the use cases be ?
>>>> I can't think of any, one either use crop or compose.
>>> I can: you crop in the video receiver and compose it into a larger
>>> buffer.
>>>
>>> Actually quite a desirable feature.
>> Yes, right. Don't know why I imagined something different.
>> And we need it in Samsung capture capture interfaces as well. The H/W
>> is capable of cropping and composing with camera interface as a data source
>> similarly as it is done with memory buffers.
> 
> The same result could be achieved by adding an offset to the buffer address 
> and setting the bytesperline field accordingly, but that would only work with 
> userptr buffers. As we're working on an API to share buffers between 
> subsystems, I agree that composing into a larger buffer is desirable and 
> shouldn't be implemented using offset/stride.
> 
Hi,
Simulation of cropping on a data source using offset/bytesperline is not 
possible for compressed formats like JPEG. I could not find any good 
definition of bytesperline for macroblock and planar formats.
These problems were the reason of proposing extcrop (aka selection) API.

Bye
TS
