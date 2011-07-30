Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:62182 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab1G3RGk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jul 2011 13:06:40 -0400
Date: Sat, 30 Jul 2011 19:06:32 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Pawel Osciak <pawel@osciak.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v3] V4L: add two new ioctl()s for multi-size videobuffer
 management
In-Reply-To: <201107301550.53638.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1107301850130.12984@axis700.grange>
References: <Pine.LNX.4.64.1107201025120.12084@axis700.grange>
 <201107280856.55731.hverkuil@xs4all.nl> <CAMm-=zCU1B1zXNK7hp_B8hAW0YfcrN9V8M_uSDva8TbXL2AKbQ@mail.gmail.com>
 <201107301550.53638.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 30 Jul 2011, Hans Verkuil wrote:

> On Saturday, July 30, 2011 06:21:37 Pawel Osciak wrote:

[snip]

> > So when the driver sees a larger buffer being queued, it is
> > to change the current streaming format for the duration of filling
> > that buffer and switch back afterwards?
> 
> No. We do not have a mechanism (yet) to tie a pipeline configuration to
> a queued buffer (to be discussed in next week in Cambourne).
> 
> It is my understanding that you change the current streaming format, and
> then queue the large (prepared) buffer and switch back afterwards.

Yes, this is also how I see it - the driver just has a chance to verify, 
whether the queued buffer is not large enough for the current format and 
fail QBUF, although this behaviour is currently not documented in the QBUF 
specification...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
