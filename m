Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38556 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752481AbbCNOMN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2015 10:12:13 -0400
Date: Sat, 14 Mar 2015 16:12:09 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	pali.rohar@gmail.com
Subject: Re: [RFC 15/18] omap3isp: Add support for the Device Tree
Message-ID: <20150314141209.GV11954@valkosipuli.retiisi.org.uk>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
 <1425764475-27691-16-git-send-email-sakari.ailus@iki.fi>
 <1977501.nIrQKlrSI0@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1977501.nIrQKlrSI0@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, Mar 12, 2015 at 01:48:02AM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Saturday 07 March 2015 23:41:12 Sakari Ailus wrote:
> > Add the ISP device to omap3 DT include file and add support to the driver to
> > use it.
> > 
> > Also obtain information on the external entities and the ISP configuration
> > related to them through the Device Tree in addition to the platform data.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  drivers/media/platform/omap3isp/isp.c       |  206 ++++++++++++++++++++++--
> >  drivers/media/platform/omap3isp/isp.h       |   11 ++
> >  drivers/media/platform/omap3isp/ispcsiphy.c |    7 +
> >  3 files changed, 213 insertions(+), 11 deletions(-)
> 
> [snip]
> 
> > @@ -2358,14 +2541,6 @@ static int isp_probe(struct platform_device *pdev)
> >  	isp->mmio_hist_base_phys =
> >  		mem->start + isp_res_maps[m].offset[OMAP3_ISP_IOMEM_HIST];
> > 
> > -	isp->syscon = syscon_regmap_lookup_by_pdevname("syscon.0");
> > -	isp->syscon_offset = isp_res_maps[m].syscon_offset;
> 
> You're removing syscon_offset initialization here but not adding it anywhere 
> else. This patch doesn't match the commit in your rm696-053-upstream branch, 
> could you send the right version ? I'll then review it.

Yeah, there have been quite a few changes since I posted this RFC set, this
including. I'll post a new version once I've been able to take into account
all the comments I've got so far.

It'd be nice if someone could test the pdata support; I haven't had a chance
to do that in a few years now. :-)

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
