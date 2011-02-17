Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:38757 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962Ab1BQUsE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 15:48:04 -0500
Message-ID: <4D5D893B.5090101@infradead.org>
Date: Thu, 17 Feb 2011 18:46:51 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hansverk@cisco.com>, Qing Xu <qingx@marvell.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Neil Johnson <realdealneil@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Uwe Taeubert <u.taeubert@road.de>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Eino-Ville Talvala <talvala@stanford.edu>
Subject: Re: [RFD] frame-size switching: preview / single-shot use-case
References: <Pine.LNX.4.64.1102151641490.16709@axis700.grange> <201102160949.04605.hansverk@cisco.com> <Pine.LNX.4.64.1102160954560.20711@axis700.grange> <201102161011.59830.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1102161033440.20711@axis700.grange> <4D5D7141.4030101@infradead.org> <Pine.LNX.4.64.1102172020410.30692@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102172020410.30692@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 17-02-2011 17:26, Guennadi Liakhovetski escreveu:
> Hi Mauro
> 
> Thanks for your comments.
> 
> On Thu, 17 Feb 2011, Mauro Carvalho Chehab wrote:
> 
>> Em 16-02-2011 08:35, Guennadi Liakhovetski escreveu:
> 
> [snip]
> 
>>> (2) cleanly separate setting video data format (S_FMT) from specifying the 
>>> allocated buffer size.
>>
>> This would break existing applications. Too late for that, except if negotiated
>> with a "SETCAP" like approach.
> 
> Sorry, don't see how my proposal from my last mail would change existing 
> applications. As long as no explicit buffer-queue management is performed, 
> no new queues are allocated, the driver will just implicitly allocate one 
> queue and use it. I.e., no change in behaviour.

Using the same ioctl to explicitly or to implicitly allocating memory depending
on the context would make the API more complicated than it should be.

>> There's an additional problem with that: assume that streaming is happening,
>> and a S_FMT changing the resolution was sent. There's no way to warrant that
>> the very next frame will have the new resolution. So, a meta-data with the
>> frame resolution (and format) would be needed.
> 
> Sorry, we are not going to allow format changes during a running capture. 
> You have to stop streaming, set new formats (possibly switch to another 
> queue) and restart streaming.

> What am I missing?

If you're stopping the stream, the current API will work as-is.

If all of your concerns is about reserving a bigger buffer queue, I think that one
of the reasons for the CMA allocator it for such usage.

Am I missing something?

Cheers,
Mauro
