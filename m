Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36298 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2CIM6W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2012 07:58:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Cc: jean-philippe francois <jp.francois@cynove.com>,
	Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: Re: Lockup on second streamon with omap3-isp
Date: Fri, 09 Mar 2012 13:58:43 +0100
Message-ID: <2038085.aDq2jrhkOM@avalon>
In-Reply-To: <4F59FD87.4030506@matrix-vision.de>
References: <CAGGh5h0dVOsT-PCoCBtjj=+rLzViwnM2e9hG+sbWQk5iS-ThEQ@mail.gmail.com> <2243690.V1TtfkZKP0@avalon> <4F59FD87.4030506@matrix-vision.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Michael,

On Friday 09 March 2012 13:54:31 Michael Jones wrote:
> On 03/09/2012 11:42 AM, Laurent Pinchart wrote:
> > Hi Jean-Philippe,
> 
> [snip]
> 
> >  From my experience, the ISP doesn't handle free-running sensors very
> >  well.
> > 
> > There are other things it doesn't handle well, such as sensors stopping in
> > the middle of the frame. I would consider this as limitations.
> 
> Considering choking on sensors which stop in the middle of the frame- is
> this just a limitation of the driver, or is it really a limitation of
> the ISP hardware itself?

It's a limitation of the hardware. Various OMAP3 ISP blocks can't be stopped 
before they have processed a complete frame once they have been started. The 
work around is to reset the whole ISP, which we will do in v3.4, but that 
won't solve the problem completely if one application uses the resizer in 
memory-to-memory mode and another application uses the rest of the ISP. In 
that case the driver won't be able to reset the ISP as long as the first 
application uses it.

> It is at least a limitation of the driver because we rely on the VD1 and VD0
> interrupts, so we'll of course have problems if we never get to the last
> line.  But isn't it conceivable to use HS_VS to do our end-of-frame stuff
> instead of VD0?  Maybe then the ISP would be OK with frames that ended
> early, as long as they had reached VD1.  Then of course, you could move VD1
> to an even earlier line, even to the first line.
> 
> Do you think that's possible?

Unfortunately not. HS_VS could be used as a fallback to detect the end of a 
frame in case something bad occurs, but that hardware will still be stuck 
waiting for the end of the frame. The real problem here is a lack of feature 
on the hardware side, the ISP modules should either support being stopped in 
the middle of a frame, or support per-module reset.

-- 
Regards,

Laurent Pinchart

