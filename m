Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:10771 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750895Ab2IZWAY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 18:00:24 -0400
Date: Wed, 26 Sep 2012 15:00:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: paul@pwsan.com, laurent.pinchart@ideasonboard.com,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2 2/2] omap3isp: Configure CSI-2 phy based on platform
 data
Message-ID: <20120926220018.GJ4840@atomide.com>
References: <20120926215001.GA14107@valkosipuli.retiisi.org.uk>
 <1348696236-3470-2-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348696236-3470-2-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moi Sakari

* Sakari Ailus <sakari.ailus@iki.fi> [120926 14:51]:
> Configure CSI-2 phy based on platform data in the ISP driver. For that, the
> new V4L2_CID_IMAGE_SOURCE_PIXEL_RATE control is used. Previously the same
> was configured from the board code.
> 
> This patch is dependent on "omap3: Provide means for changing CSI2 PHY
> configuration".

Can you please do one more patch to get rid of the last remaining
cpu_is_omapxxxx check in drivers/media/platform/omap3isp/isp.c?

That data should come from platform_data (or device tree) as
we going to make cpu_is_omap privat to mach-omap2.

Regards,

Tony
