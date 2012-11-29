Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab2K2RFm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Nov 2012 12:05:42 -0500
Date: Thu, 29 Nov 2012 15:05:35 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Tony Lindgren <tony@atomide.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>, hvaibhav@ti.com,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	Archit Taneja <archit@ti.com>
Subject: Re: [PATCH 0/2] omap_vout: remove cpu_is_* uses
Message-ID: <20121129150535.17ea00e9@redhat.com>
In-Reply-To: <2148719.6v36XORg4e@avalon>
References: <1352727220-22540-1-git-send-email-tomi.valkeinen@ti.com>
	<4208124.v72gFsjH2D@avalon>
	<20121129162927.GF5312@atomide.com>
	<2148719.6v36XORg4e@avalon>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 29 Nov 2012 17:39:45 +0100
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Tony,
> 
> On Thursday 29 November 2012 08:29:27 Tony Lindgren wrote:
> > * Laurent Pinchart <laurent.pinchart@ideasonboard.com> [121129 01:37]:
> > > On Thursday 29 November 2012 11:30:28 Tomi Valkeinen wrote:
> > > > On 2012-11-28 17:13, Laurent Pinchart wrote:
> > > > > On Monday 12 November 2012 15:33:38 Tomi Valkeinen wrote:
> > > > >> Hi,
> > > > >> 
> > > > >> This patch removes use of cpu_is_* funcs from omap_vout, and uses
> > > > >> omapdss's version instead. The other patch removes an unneeded
> > > > >> plat/dma.h include.
> > > > >> 
> > > > >> These are based on current omapdss master branch, which has the
> > > > >> omapdss version code. The omapdss version code is queued for v3.8.
> > > > >> I'm not sure which is the best way to handle these patches due to the
> > > > >> dependency to omapdss. The easiest option is to merge these for 3.9.
> > > > >> 
> > > > >> There's still the OMAP DMA use in omap_vout_vrfb.c, which is the last
> > > > >> OMAP dependency in the omap_vout driver. I'm not going to touch that,
> > > > >> as it doesn't look as trivial as this cpu_is_* removal, and I don't
> > > > >> have much knowledge of the omap_vout driver.
> > > > >> 
> > > > >> Compiled, but not tested.
> > > > > 
> > > > > Tested on a Beagleboard-xM.
> > > > > 
> > > > > Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > > Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > > 
> > > > Thanks.
> > > > 
> > > > > The patches depend on unmerged OMAP DSS patches. Would you like to
> > > > > push this series through linuxtv or through your DSS tree ? The later
> > > > > might be easier, depending on when the required DSS patches will hit
> > > > > mainline.
> > > > 
> > > > The DSS patches will be merged for 3.8. I can take this via the omapdss
> > > > tree, as there probably won't be any conflicts with other v4l2 stuff.
> > > > 
> > > > Or, we can just delay these until 3.9. These patches remove omap
> > > > platform dependencies, helping the effort to get common ARM kernel.
> > > > However, as there's still the VRFB code in the omap_vout driver, the
> > > > dependency remains. Thus, in way, these patches alone don't help
> > > > anything, and we could delay these for 3.9 and hope that
> > > > omap_vout_vrfb.c gets converted also for that merge window.
> > > 
> > > OK, I'll queue them for v3.9 then.
> > 
> > Please rather queue the cpu_is_omap removal to v3.8 so I can
> > remove plat/cpu.h for omap2+.
> 
> In that case the patches should go through the DSS tree. Mauro, are you fine 
> with that ?

Sure.

For both patches:

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Regards,
Mauro
