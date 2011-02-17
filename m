Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:61278 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab1BQT0q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 14:26:46 -0500
Date: Thu, 17 Feb 2011 20:26:11 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hansverk@cisco.com>, Qing Xu <qingx@marvell.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Neil Johnson <realdealneil@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Uwe Taeubert <u.taeubert@road.de>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Eino-Ville Talvala <talvala@stanford.edu>
Subject: Re: [RFD] frame-size switching: preview / single-shot use-case
In-Reply-To: <4D5D7141.4030101@infradead.org>
Message-ID: <Pine.LNX.4.64.1102172020410.30692@axis700.grange>
References: <Pine.LNX.4.64.1102151641490.16709@axis700.grange>
 <201102160949.04605.hansverk@cisco.com> <Pine.LNX.4.64.1102160954560.20711@axis700.grange>
 <201102161011.59830.laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1102161033440.20711@axis700.grange> <4D5D7141.4030101@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro

Thanks for your comments.

On Thu, 17 Feb 2011, Mauro Carvalho Chehab wrote:

> Em 16-02-2011 08:35, Guennadi Liakhovetski escreveu:

[snip]

> > (2) cleanly separate setting video data format (S_FMT) from specifying the 
> > allocated buffer size.
> 
> This would break existing applications. Too late for that, except if negotiated
> with a "SETCAP" like approach.

Sorry, don't see how my proposal from my last mail would change existing 
applications. As long as no explicit buffer-queue management is performed, 
no new queues are allocated, the driver will just implicitly allocate one 
queue and use it. I.e., no change in behaviour.

> There's an additional problem with that: assume that streaming is happening,
> and a S_FMT changing the resolution was sent. There's no way to warrant that
> the very next frame will have the new resolution. So, a meta-data with the
> frame resolution (and format) would be needed.

Sorry, we are not going to allow format changes during a running capture. 
You have to stop streaming, set new formats (possibly switch to another 
queue) and restart streaming.

What am I missing?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
