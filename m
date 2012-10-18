Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55735 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab2JRNpK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Oct 2012 09:45:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: tony@atomide.com
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org, khilman@deeprootsystems.com
Subject: Re: [PATCH v5 0/3] OMAP 3 CSI-2 configuration
Date: Thu, 18 Oct 2012 15:45:59 +0200
Message-ID: <8138988.XlrgGsn68R@avalon>
In-Reply-To: <1651288.n5DBzW1A1K@avalon>
References: <20121014103122.GA21261@valkosipuli.retiisi.org.uk> <1651288.n5DBzW1A1K@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tony,

On Tuesday 16 October 2012 16:51:40 Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thanks for the patches.
> 
> For the whole series,
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Tony, do you want to take patch 1/3 in your tree, or can I push the whole
> series through mine ?

Ping ?

> On Sunday 14 October 2012 13:31:22 Sakari Ailus wrote:
> > Hi all,
> > 
> > This is an update to an old patchset for CSI-2 configuration for OMAP 3430
> > and 3630. The patches have been tested on the 3630 only so far, and I
> > don't
> > plan to test them on 3430 in the near future.
> > 
> > I've made changes according to Laurent's suggestions to the patches, with
> > the exception of alignment of a certain line. I think it's exactly as it
> > should be. :-)
> > 
> > I'm not quite certain about the comment regarding the control register
> > state dependency to the CORE power domain, and why exactly this isn't an
> > issue. We know the MPU must stay powered since the ISP can't wake up MPU,
> > but how is this related to CORE? In the end it seems to work.
> > 
> > If you think this should be changed and you also know how, please provide
> > me the text. :-)
> > 
> > 	/*
> > 	
> > 	 * The PHY configuration is lost in off mode, that's not an
> > 	 * issue since the MPU power domain is forced on whilst the
> > 	 * ISP is in use.
> > 	 */
> > 
> > Comments, questions and other kind of feedback is very welcome.
> > 
> > Kind regards,

-- 
Regards,

Laurent Pinchart

