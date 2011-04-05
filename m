Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:63370 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab1DEMkS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 08:40:18 -0400
Date: Tue, 5 Apr 2011 14:40:09 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH/RFC 1/4] V4L: add three new ioctl()s for multi-size
 videobuffer management
In-Reply-To: <201104051402.17836.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1104051439330.14419@axis700.grange>
References: <Pine.LNX.4.64.1104010959470.9530@axis700.grange>
 <Pine.LNX.4.64.1104040915590.4668@axis700.grange>
 <56f5dd2ffa0a55d09a5f391f0fa2e9d0.squirrel@webmail.xs4all.nl>
 <201104051402.17836.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 5 Apr 2011, Laurent Pinchart wrote:

> On Monday 04 April 2011 10:06:47 Hans Verkuil wrote:
> > > On Mon, 4 Apr 2011, Hans Verkuil wrote:
> > >> On Friday, April 01, 2011 10:13:02 Guennadi Liakhovetski wrote:
> 
> [snip]
> 
> > BTW, REQBUFS and CREATE/DESTROY_BUFS should definitely co-exist. REQBUFS
> > is compulsory, while CREATE/DESTROY are optional.
> 
> Drivers must support REQBUFS and should support CREATE/DESTROY, but I think 
> applications should not be allowed to mix calls.

So, you want to track it down in the kernel which mode is being used?... 
Hans?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
