Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55333 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422686Ab2LFKMA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Dec 2012 05:12:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH v3] media: V4L2: add temporary clock helpers
Date: Thu, 06 Dec 2012 11:13:07 +0100
Message-ID: <1924195.0epdSmquU0@avalon>
In-Reply-To: <Pine.LNX.4.64.1212060839540.15211@axis700.grange>
References: <Pine.LNX.4.64.1212041136250.26918@axis700.grange> <1885008.m7crYYR2Uy@avalon> <Pine.LNX.4.64.1212060839540.15211@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Thursday 06 December 2012 08:41:41 Guennadi Liakhovetski wrote:
> On Thu, 6 Dec 2012, Laurent Pinchart wrote:
> > On Tuesday 04 December 2012 11:42:15 Guennadi Liakhovetski wrote:
> > > Typical video devices like camera sensors require an external clock
> > > source. Many such devices cannot even access their hardware registers
> > > without a running clock. These clock sources should be controlled by
> > > their consumers. This should be performed, using the generic clock
> > > framework. Unfortunately so far only very few systems have been ported
> > > to that framework. This patch adds a set of temporary helpers, mimicking
> > > the generic clock API, to V4L2. Platforms, adopting the clock API,
> > > should switch to using it. Eventually this temporary API should be
> > > removed.
> > 
> > As discussed on Jabber, I think we should make the clock helpers use the
> > common clock framework when available, to avoid pushing support for the
> > two APIs to all sensor drivers. Do you plan to include that in v4 ? :-)
> 
> AAMOF, no, I don't. Originally I planned to add this only when the first
> user appears. We can also add it earlier - a test case could be hacked up
> pretty quickly. But in either case I'd prefer to have it as a separate
> patch.

OK, I'm fine with that.

-- 
Regards,

Laurent Pinchart

