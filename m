Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46010 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750752AbZDQHPL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Apr 2009 03:15:11 -0400
Date: Fri, 17 Apr 2009 09:15:12 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Dongsoo, Nathaniel Kim" <dongsoo.kim@gmail.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	kernel@pengutronix.de,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	=?EUC-KR?B?sejH/MHY?= <riverful.kim@samsung.com>,
	"jongse.won@samsung.com" <jongse.won@samsung.com>,
	dongsoo45.kim@samsung.com, Hans Verkuil <hverkuil@xs4all.nl>,
	"Ailus Sakari (Nokia-D/Helsinki)" <Sakari.Ailus@nokia.com>
Subject: Re: [RFC] Making Samsung S3C64XX camera interface driver in SoC
 camera subsystem
In-Reply-To: <5e9665e10904170008q51283185g17f203e2bc969f30@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0904170912550.5119@axis700.grange>
References: <5e9665e10904151712o5fa3076dr85ad12fc7f04914d@mail.gmail.com>
 <Pine.LNX.4.64.0904162147370.4947@axis700.grange>
 <5e9665e10904162346g37a29778ub0fd4c9f5c11f1df@mail.gmail.com>
 <Pine.LNX.4.64.0904170852450.5119@axis700.grange>
 <5e9665e10904170008q51283185g17f203e2bc969f30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 17 Apr 2009, Dongsoo, Nathaniel Kim wrote:

> Hi Guennadi,
> 
> On Fri, Apr 17, 2009 at 4:00 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > On Fri, 17 Apr 2009, Dongsoo, Nathaniel Kim wrote:
> >
> >> 1. make preview device a video output
> >> => it makes sense. but codec path also has dedicated DMA to frame buffer.
> >> What should we do with that? I have no idea by now.
> >
> > Add a V4L2_CAP_VIDEO_OVERLAY capability and if the user requests
> > V4L2_BUF_TYPE_VIDEO_OVERLAY - configure direct output to framebuffer?
> >
> 
> OK that's an idea. Then we can use preview as video output device and
> codec device as a capture device with overlay capability.

Actually, if I interpret the "Camera interface overview" figure (20-1) 
correctly, both capture and output channels have the overlay capability, 
so, you can enable it for both of them and configure the respective one 
accordingly.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
