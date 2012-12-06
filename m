Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:59974 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964784Ab2LFHmY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2012 02:42:24 -0500
Date: Thu, 6 Dec 2012 08:41:41 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH v3] media: V4L2: add temporary clock helpers
In-Reply-To: <1885008.m7crYYR2Uy@avalon>
Message-ID: <Pine.LNX.4.64.1212060839540.15211@axis700.grange>
References: <Pine.LNX.4.64.1212041136250.26918@axis700.grange>
 <1885008.m7crYYR2Uy@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

On Thu, 6 Dec 2012, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> Thanks for the patch.
> 
> On Tuesday 04 December 2012 11:42:15 Guennadi Liakhovetski wrote:
> > Typical video devices like camera sensors require an external clock source.
> > Many such devices cannot even access their hardware registers without a
> > running clock. These clock sources should be controlled by their consumers.
> > This should be performed, using the generic clock framework. Unfortunately
> > so far only very few systems have been ported to that framework. This patch
> > adds a set of temporary helpers, mimicking the generic clock API, to V4L2.
> > Platforms, adopting the clock API, should switch to using it. Eventually
> > this temporary API should be removed.
> 
> As discussed on Jabber, I think we should make the clock helpers use the 
> common clock framework when available, to avoid pushing support for the two 
> APIs to all sensor drivers. Do you plan to include that in v4 ? :-)

AAMOF, no, I don't. Originally I planned to add this only when the first 
user appears. We can also add it earlier - a test case could be hacked up 
pretty quickly. But in either case I'd prefer to have it as a separate 
patch.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
