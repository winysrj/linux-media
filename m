Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52360 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab2I0Jva (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 05:51:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, paul@pwsan.com,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 2/2] omap3isp: Configure CSI-2 phy based on platform data
Date: Thu, 27 Sep 2012 11:52:09 +0200
Message-ID: <2652285.trTHQxlDeP@avalon>
In-Reply-To: <20120926220018.GJ4840@atomide.com>
References: <20120926215001.GA14107@valkosipuli.retiisi.org.uk> <1348696236-3470-2-git-send-email-sakari.ailus@iki.fi> <20120926220018.GJ4840@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tony,

On Wednesday 26 September 2012 15:00:19 Tony Lindgren wrote:
> Moi Sakari
> 
> * Sakari Ailus <sakari.ailus@iki.fi> [120926 14:51]:
> > Configure CSI-2 phy based on platform data in the ISP driver. For that,
> > the
> > new V4L2_CID_IMAGE_SOURCE_PIXEL_RATE control is used. Previously the same
> > was configured from the board code.
> > 
> > This patch is dependent on "omap3: Provide means for changing CSI2 PHY
> > configuration".
> 
> Can you please do one more patch to get rid of the last remaining
> cpu_is_omapxxxx check in drivers/media/platform/omap3isp/isp.c?

I'm working on that, I'll submit a patch.

> That data should come from platform_data (or device tree) as
> we going to make cpu_is_omap privat to mach-omap2.

-- 
Regards,

Laurent Pinchart

