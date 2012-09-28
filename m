Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:26625 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751676Ab2I1AAJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 20:00:09 -0400
Date: Thu, 27 Sep 2012 17:00:04 -0700
From: Tony Lindgren <tony@atomide.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, paul@pwsan.com,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 2/2] omap3isp: Configure CSI-2 phy based on platform
 data
Message-ID: <20120928000001.GW4840@atomide.com>
References: <20120926215001.GA14107@valkosipuli.retiisi.org.uk>
 <1348696236-3470-2-git-send-email-sakari.ailus@iki.fi>
 <20120926220018.GJ4840@atomide.com>
 <2652285.trTHQxlDeP@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2652285.trTHQxlDeP@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Laurent Pinchart <laurent.pinchart@ideasonboard.com> [120927 02:52]:
> Hi Tony,
> 
> On Wednesday 26 September 2012 15:00:19 Tony Lindgren wrote:
> > Moi Sakari
> > 
> > * Sakari Ailus <sakari.ailus@iki.fi> [120926 14:51]:
> > > Configure CSI-2 phy based on platform data in the ISP driver. For that,
> > > the
> > > new V4L2_CID_IMAGE_SOURCE_PIXEL_RATE control is used. Previously the same
> > > was configured from the board code.
> > > 
> > > This patch is dependent on "omap3: Provide means for changing CSI2 PHY
> > > configuration".
> > 
> > Can you please do one more patch to get rid of the last remaining
> > cpu_is_omapxxxx check in drivers/media/platform/omap3isp/isp.c?
> 
> I'm working on that, I'll submit a patch.

Thanks acked it.

Regards,

Tony
