Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37379 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab2JZCFA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 22:05:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/2] media: V4L2: add temporary clock helpers
Date: Fri, 26 Oct 2012 04:05:50 +0200
Message-ID: <4703902.UfQghhBIJp@avalon>
In-Reply-To: <50844465.40007@gmail.com>
References: <Pine.LNX.4.64.1210192358520.28993@axis700.grange> <Pine.LNX.4.64.1210200007310.28993@axis700.grange> <50844465.40007@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Sunday 21 October 2012 20:52:21 Sylwester Nawrocki wrote:
> On 10/20/2012 12:20 AM, Guennadi Liakhovetski wrote:
> > Typical video devices like camera sensors require an external clock
> > source. Many such devices cannot even access their hardware registers
> > without a running clock. These clock sources should be controlled by their
> > consumers. This should be performed, using the generic clock framework.
> > Unfortunately so far only very few systems have been ported to that
> > framework. This patch adds a set of temporary helpers, mimicking the
> > generic clock API, to V4L2. Platforms, adopting the clock API, should
> > switch to using it. Eventually this temporary API should be removed.
> 
> So I gave this patch a try this weekend. I would have a few comments/
> questions. Thank you for sharing this!

I've finally found time to give it a try, and I can report successful results.

My development target here is a Beagleboard-xM with an MT9P031 sensor. With 
this patch and Sylwester's additional patches [1], I've been able to remove 
the board code callback from the mt9p031 driver platform data, as well as the 
last omap3-isp platform callback.

The result is available in the devel/v4l2-clock branch of 
http://git.linuxtv.org/pinchartl/media.git. Sylwester, that branch includes a 
minor fix titled "v4l2-clk: Fix clock id matching" for your "v4l2-clk: Rework 
to accept more than one clock with null clock id" patch. Could you please have 
a look at it ?

On the downside, there's now a circular dependency between the mt9p031 and 
omap3-isp drivers, so neither of them can be removed. That will need to be 
fixed.

[1] http://git.linuxtv.org/snawrocki/media.git/shortlog/refs/heads/s3c-camif-
devel

-- 
Regards,

Laurent Pinchart

