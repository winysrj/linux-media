Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:35431 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758719Ab2BJK6K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Feb 2012 05:58:10 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LZ60059MBSWB8@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Feb 2012 10:58:08 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZ6000SSBSWHB@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Feb 2012 10:58:08 +0000 (GMT)
Date: Fri, 10 Feb 2012 11:58:07 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [Q] Interleaved formats on the media bus
In-reply-to: <Pine.LNX.4.64.1202101131280.5787@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
Message-id: <4F34F83F.4060703@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <4F27CF29.5090905@samsung.com> <4116034.kVC1fDZsLk@avalon>
 <4F32FBBB.7020007@gmail.com> <12779203.vQPWKN8eZf@avalon>
 <Pine.LNX.4.64.1202100934070.5787@axis700.grange>
 <4F34EF3E.2090004@samsung.com>
 <Pine.LNX.4.64.1202101131280.5787@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/10/2012 11:33 AM, Guennadi Liakhovetski wrote:
> On Fri, 10 Feb 2012, Sylwester Nawrocki wrote:
> 
>> On 02/10/2012 09:42 AM, Guennadi Liakhovetski wrote:
>>> ...thinking about this interleaved data, is there anything else left, that 
>>> the following scheme would be failing to describe:
>>>
>>> * The data is sent in repeated blocks (periods)
>>
>> The data is sent in irregular chunks of varying size (few hundred of bytes
>> for example).
> 
> Right, the data includes headers. How about sensors providing 
> header-parsing callbacks?

This implies processing of headers/footers in kernel space to some generic format.
It might work, but sometimes there might be an unwanted performance loss. However
I wouldn't expect it to be that significant, depends on how the format of an 
embedded data from the sensor looks like. Processing 4KiB of data could be 
acceptable.

I'm assuming here, we want to convert the frame embedded (meta) data for each 
sensor to some generic description format ? It would have to be then relatively 
simple, not to increase the frame header size unnecessarily.

--

Thanks
Sylwester
