Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58554 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaAIUsc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jan 2014 15:48:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: florian.vaussard@epfl.ch
Cc: Enrico <ebutera@users.berlios.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sebastian Reichel <sre@debian.org>
Subject: Re: omap3isp device tree support
Date: Thu, 09 Jan 2014 21:49:09 +0100
Message-ID: <4572159.CqBuj6p70x@avalon>
In-Reply-To: <52CF0612.2020303@epfl.ch>
References: <CA+2YH7ueF46YA2ZpOT80w3jTzmw0aFWhfshry2k_mrXAmW=MXA@mail.gmail.com> <5728278.SyrhtX3J9t@avalon> <52CF0612.2020303@epfl.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Florian,

On Thursday 09 January 2014 21:26:58 Florian Vaussard wrote:
> On 01/07/2014 05:59 PM, Laurent Pinchart wrote:
> > On Friday 03 January 2014 12:30:33 Enrico wrote:
> >> On Wed, Dec 18, 2013 at 11:09 AM, Enrico wrote:
> >>> On Tue, Dec 17, 2013 at 2:11 PM, Florian Vaussard wrote:
> >>>> So I converted the iommu to DT (patches just sent),
> > 
> > Florian, I've used your patches as a base for OMAP3 ISP DT work and they
> > seem pretty good (although patch 1/7 will need to be reworked, but that's
> > not a blocker). I've just had to fix a problem with the OMAP3 IOMMU,
> > please see
> > 
> > http://git.linuxtv.org/pinchartl/media.git/commit/d3abafde0277f168df0b2912
> > b5d84550590d80b2
>
> According to the comments on the IOMMU/DT patches [1], some work is still
> needed to merge these patches, mainly to support other IOMMUs (OMAP4,
> OMAP5).

Sure, the code need to be reworked, but I believe it's going in the right 
direction and shouldn't be too complex to fix.

> So the current base is probably ok. I will resume my work on this soon.

Great, thanks.

> What are your comments on patch 1?

I just agree with Suman that there can be multiple IOMMUs and that the 
bus_set_iommu() call should thus be kept in the init function. The current 
infrastructure allows multiple IOMMUs to coexist as long as they're of the 
same type (I'm pretty sure we'll have to fix that at some point). I believe 
the problem that patch 1/7 tries to fix is actually the right behaviour.

> I briefly looked at your fix, seems ok to me. I do not figure out how it
> worked for me.

I was puzzled by that as well :-)

> I will look at it closer next week.
> 
> > I'd appreciate your comments on that. I can post the patch already if you
> > think that would be helpful.
> 
> It is probably better to wait for the v2 of the iommu series. I can include
> your patch in it.

Please feel free to do so.

> > You can find my work-in-progress branch at
> > 
> > http://git.linuxtv.org/pinchartl/media.git/shortlog/refs/heads/omap3isp/dt
> > 
> > (the last three patches are definitely not complete yet).
> 
> Great news! A while ago, Sebastian Reichel (in CC) posted an RFC for the
> binding [2]. Are you working with him on this?

No, I've replied to Sebastian's patch but haven't received any answer. My main 
concern is that the proposal didn't use the V4L2 DT bindings to describe the 
pipeline.

> [1] https://lkml.org/lkml/2013/12/17/197
> [2] http://thread.gmane.org/gmane.linux.drivers.devicetree/50580
-- 
Regards,

Laurent Pinchart

