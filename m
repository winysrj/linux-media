Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45001 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbbKIRsW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 12:48:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Suman Anna <s-anna@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/2] ARM: OMAP2+: Remove legacy OMAP3 ISP instantiation
Date: Mon, 09 Nov 2015 19:48:33 +0200
Message-ID: <10133709.DpTcCTIhJE@avalon>
In-Reply-To: <20151012170558.GF23801@atomide.com>
References: <1437051319-9904-1-git-send-email-laurent.pinchart@ideasonboard.com> <20150914163353.GN4215@atomide.com> <20151012170558.GF23801@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tony,

On Monday 12 October 2015 10:05:59 Tony Lindgren wrote:
> * Tony Lindgren <tony@atomide.com> [150914 09:37]:
> > * Suman Anna <s-anna@ti.com> [150914 09:33]:
> >> On 09/03/2015 05:34 PM, Suman Anna wrote:
> >>> On 07/16/2015 07:58 AM, Tony Lindgren wrote:
> >>>> * Laurent Pinchart [150716 05:57]:
> >>>> The OMAP3 ISP is now fully supported in DT, remove its instantiation
> >>>>> from C code.
> >>>> 
> >>>> Please feel to queue this along with the second patch in this series,
> >>>> this should not cause any merge conflicts:
> >>>> 
> >>>> Acked-by: Tony Lindgren <tony@atomide.com>
> >>> 
> >>> Just wondering if you have already queued this, I see the v4l changes
> >>> in linux-next, but not this patch. Also, can you confirm if this
> >>> series is making it into 4.3?
> >> 
> >> This patch is not in 4.3-rc1, can you pick this up for the next merge
> >> window? I am gonna send out some additional cleanup patches (removing
> >> legacy mailbox and iommu pieces) on top on this patch. The second patch
> >> in this series did make it.
> > 
> > OK tagging this one for next, will apply once I'm done with fixes.
> 
> Applying into omap-for-v4.4/cleanup finally thanks.

Is see that the patch is in your master branch but not your for-next branch. 
Will it make it to v4.4-rc1 ?

-- 
Regards,

Laurent Pinchart

