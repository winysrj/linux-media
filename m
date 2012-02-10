Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:49381 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab2BJLwP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Feb 2012 06:52:15 -0500
Date: Fri, 10 Feb 2012 12:51:59 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [Q] Interleaved formats on the media bus
In-Reply-To: <4F35011C.8030701@samsung.com>
Message-ID: <Pine.LNX.4.64.1202101242270.5787@axis700.grange>
References: <4F27CF29.5090905@samsung.com> <4116034.kVC1fDZsLk@avalon>
 <4F32FBBB.7020007@gmail.com> <12779203.vQPWKN8eZf@avalon>
 <Pine.LNX.4.64.1202100934070.5787@axis700.grange> <4F34EF3E.2090004@samsung.com>
 <Pine.LNX.4.64.1202101131280.5787@axis700.grange> <4F34F83F.4060703@samsung.com>
 <Pine.LNX.4.64.1202101202090.5787@axis700.grange> <4F35011C.8030701@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 10 Feb 2012, Sylwester Nawrocki wrote:

> On 02/10/2012 12:15 PM, Guennadi Liakhovetski wrote:
> >>>> On 02/10/2012 09:42 AM, Guennadi Liakhovetski wrote:
> >>>>> ...thinking about this interleaved data, is there anything else left, that 
> >>>>> the following scheme would be failing to describe:
> >>>>>
> >>>>> * The data is sent in repeated blocks (periods)
> >>>>
> >>>> The data is sent in irregular chunks of varying size (few hundred of bytes
> >>>> for example).
> >>>
> >>> Right, the data includes headers. How about sensors providing 
> >>> header-parsing callbacks?
> >>
> >> This implies processing of headers/footers in kernel space to some generic 
> >> format. It might work, but sometimes there might be an unwanted performance 
> >> loss. However I wouldn't expect it to be that significant, depends on how 
> >> the format of an embedded data from the sensor looks like. Processing 4KiB
> >> of data could be acceptable.
> > 
> > In principle I agree - (ideally) no processing in the kernel _at all_. 
> > Just pass the complete frame data as is to the user-space. But if we need 
> > any internal knowledge at all about the data, maybe callbacks would be a 
> > better option, than trying to develop a generic descriptor. Perhaps, 
> > something like "get me the location of n'th block of data of format X."
> 
> Hmm, I thought about only processing frame embedded data to some generic
> format. I find the callbacks for extracting the data in the kernel 
> impractical, with full HD video stream you may want to use some sort of
> hardware accelerated processing, like using NEON for example. We can 
> allow this only by leaving the deinterleave process to the user space.

Sorry for confusion:-) I'm not proposing to implement this now nor do I 
have a specific use-case for this. This was just an abstract idea about 
how we could do this _if_ we ever need any internal information about the 
data anywhere outside of the sensor driver. So, so far this doesn't have 
any practical implications.

OTOH - how we parse the data in the user-space. The obvious way would be 
the one, that seems to be currently favoured here too - just use a 
vendor-specific fourcc. OTOH, maybe it would be better to do something 
like the above - define new (subdev) IOCTLs to parse headers and extract 
necessary data blocks. Yes, it adds overhead, but if the user-space anyway 
has to "manually" process the data, maybe this could be tolerated.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
