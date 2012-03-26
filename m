Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45621 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933122Ab2CZRhs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 13:37:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Joshua Hintze <joshua.hintze@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Using MT9P031 digital sensor
Date: Mon, 26 Mar 2012 19:38:23 +0200
Message-ID: <2321523.YMAGzgKbQ4@avalon>
In-Reply-To: <CAGD8Z76ctw2F669D4PdJpYm4L1caYm=stE3WW_5JNxXpZZwx9g@mail.gmail.com>
References: <CAGD8Z75ELkV6wJOfuCFU3Z2dS=z5WbV-7izazaG7SVtfPMcn=A@mail.gmail.com> <16456215.DlCuaG1n70@avalon> <CAGD8Z76ctw2F669D4PdJpYm4L1caYm=stE3WW_5JNxXpZZwx9g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Joshua,

On Monday 26 March 2012 09:44:52 Joshua Hintze wrote:
> On Mon, Mar 26, 2012 at 2:25 AM, Laurent Pinchart wrote:
> > On Sunday 25 March 2012 23:13:02 Joshua Hintze wrote:

[snip]

> >> Now I'm working on fixing the white balance. In my office the
> >> incandescent light bulbs give off a yellowish tint late at night. I've
> >> been digging through the omap3isp code to figure out how to enable the
> >> automatic white balance. I was able to find the private IOCTLs for the
> >> previewer and I was able to use VIDIOC_OMAP3ISP_PRV_CFG. Using this IOCTL
> >> I adjusted the OMAP3ISP_PREV_WB, OMAP3ISP_PREV_BLKADJ, and
> >> OMAP3ISP_PREV_RGB2RGB.
> >> 
> >> Since I wasn't sure where to start on adjusting these values I just set
> >> them all to the TRM's default register values. However when I did so a
> >> strange thing occurred. What I saw was all the colors went to a decent
> >> color. I'm curious if anybody can shed some light on the best way to get
> >> a high quality image. Ideally if I could just set a bit for auto white
> >> balance and auto exposure that could be good too.
> > 
> > The ISP doesn't implement automatic white balance. It can apply white
> > balancing (as well as other related processing), but computing values for
> > those parameters needs to be performed in userspace. The ISP statistics
> > engine engine can help speeding up the process, but the AEWB algorithm
> > must be implemented in your application.
> 
> Dang, I'll have to look up some AEWB algorithms.

I will publish sample code soon (likely in a couple of weeks, could be a bit 
before).

> I'm curious why TI would have this register bit then (AEW_EN bit 15 in
> H3A_PCR)?

That bit enables the AEWB statistics collection, not an AEWB algorithm.

> Is this the same for auto focus and auto exposure? Meaning that I'll need to
> get information from the histogram/statistics to adjust focus and exposure
> times?

That's right.

-- 
Regards,

Laurent Pinchart

