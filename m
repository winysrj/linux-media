Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44200 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756275AbZFQKXr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 06:23:47 -0400
Date: Wed, 17 Jun 2009 12:23:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: S_FMT vs. S_CROP
In-Reply-To: <200906102323.43677.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.0906171219030.4218@axis700.grange>
References: <49CBB13F.7090609@hni.uni-paderborn.de> <49D46D2E.5090702@hni.uni-paderborn.de>
 <Pine.LNX.4.64.0906101738140.4817@axis700.grange> <200906102323.43677.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 10 Jun 2009, Hans Verkuil wrote:

> On Wednesday 10 June 2009 18:02:39 Guennadi Liakhovetski wrote:
> >
> > {G,S,TRY}_FMT configure output geometry in user pixels
> > [GS]_CROP, CROPCAP configure input window in sensor pixels
> 
> Agreed.

Now one more related question: if the driver (stack) can only scale down, 
and the user has requested either a crop smaller than current fmt, or fmt 
larger than current crop. What should the driver do? I can think of at 
least two reasonably logical behaviours:

1. adjust the last invalid request - either enlarge crop or reduce fmt
2. give fmt preference and adjust the source rectangle if needed

Which one is prererred?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
