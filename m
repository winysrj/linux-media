Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16545 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891Ab2BJLf7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Feb 2012 06:35:59 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LZ6003PHDJXZ140@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Feb 2012 11:35:57 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZ600CWSDJXQ8@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Feb 2012 11:35:57 +0000 (GMT)
Date: Fri, 10 Feb 2012 12:35:56 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [Q] Interleaved formats on the media bus
In-reply-to: <Pine.LNX.4.64.1202101202090.5787@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
Message-id: <4F35011C.8030701@samsung.com>
References: <4F27CF29.5090905@samsung.com> <4116034.kVC1fDZsLk@avalon>
 <4F32FBBB.7020007@gmail.com> <12779203.vQPWKN8eZf@avalon>
 <Pine.LNX.4.64.1202100934070.5787@axis700.grange>
 <4F34EF3E.2090004@samsung.com>
 <Pine.LNX.4.64.1202101131280.5787@axis700.grange>
 <4F34F83F.4060703@samsung.com>
 <Pine.LNX.4.64.1202101202090.5787@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/10/2012 12:15 PM, Guennadi Liakhovetski wrote:
>>>> On 02/10/2012 09:42 AM, Guennadi Liakhovetski wrote:
>>>>> ...thinking about this interleaved data, is there anything else left, that 
>>>>> the following scheme would be failing to describe:
>>>>>
>>>>> * The data is sent in repeated blocks (periods)
>>>>
>>>> The data is sent in irregular chunks of varying size (few hundred of bytes
>>>> for example).
>>>
>>> Right, the data includes headers. How about sensors providing 
>>> header-parsing callbacks?
>>
>> This implies processing of headers/footers in kernel space to some generic 
>> format. It might work, but sometimes there might be an unwanted performance 
>> loss. However I wouldn't expect it to be that significant, depends on how 
>> the format of an embedded data from the sensor looks like. Processing 4KiB
>> of data could be acceptable.
> 
> In principle I agree - (ideally) no processing in the kernel _at all_. 
> Just pass the complete frame data as is to the user-space. But if we need 
> any internal knowledge at all about the data, maybe callbacks would be a 
> better option, than trying to develop a generic descriptor. Perhaps, 
> something like "get me the location of n'th block of data of format X."

Hmm, I thought about only processing frame embedded data to some generic
format. I find the callbacks for extracting the data in the kernel 
impractical, with full HD video stream you may want to use some sort of
hardware accelerated processing, like using NEON for example. We can 
allow this only by leaving the deinterleave process to the user space.

> Notice, this does not (necessarily) have anything to do with the previous 
> discussion, concerning the way, how the CSI receiver should be getting its 
> configuration.

--

Regards,
Sylwester
