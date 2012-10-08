Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52311 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751108Ab2JHWWH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Oct 2012 18:22:07 -0400
Date: Tue, 9 Oct 2012 01:22:02 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v3 1/3] omap3isp: Add CSI configuration registers from
 control block to ISP resources
Message-ID: <20121008222202.GH14107@valkosipuli.retiisi.org.uk>
References: <20121007200730.GD14107@valkosipuli.retiisi.org.uk>
 <1349640472-1425-1-git-send-email-sakari.ailus@iki.fi>
 <20121008220645.GY13011@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121008220645.GY13011@atomide.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka,

On Mon, Oct 08, 2012 at 03:06:46PM -0700, Tony Lindgren wrote:
> * Sakari Ailus <sakari.ailus@iki.fi> [121007 13:09]:
> > Add the registers used to configure the CSI-2 receiver PHY on OMAP3430 and
> > 3630 and map them in the ISP driver. The register is part of the control
> > block but it only is needed by the ISP driver.
> 
> Just checking.. These do get reserved with request_mem_region()
> in isp_map_mem_resource() before they get ioremapped, right?

That's right. The code doing that can be found in
drivers/media/platform/omap3isp/isp.c in a function called
isp_map_mem_resource().

> And camera is the only user for these registers and they are
> not shared with anything else?

Correct. These registers only contain bits for configuring the CSI-2 PHY
routing and CCP2 clock/strobe mode.

> If so, then this is OK to merge via the media patches:
> 
> Acked-by: Tony Lindgren <tony@atomide.com>

Thanks! :-)

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
