Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48049 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751589AbbGPQPp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 12:15:45 -0400
Message-ID: <55A7D862.3070700@iki.fi>
Date: Thu, 16 Jul 2015 19:14:26 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 0/2] omap3isp: Remove legacy platform data support
References: <1437051319-9904-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1437051319-9904-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hello,
> 
> Now that all users of the OMAP3 ISP have switched to DT, this patch series
> removes support for legacy platform data support in the omap3isp driver. It
> also drops the OMAP3 ISP device instantiation board code that is now unused.
> 
> Patch 2/2 depends on 1/2. From a conflict resolution point of view it would be
> easier to merge the whole series through the linux-media tree. Tony, would
> that be fine with you ? If so could you please ack patch 1/2 ?
> 
> Laurent Pinchart (2):
>   ARM: OMAP2+: Remove legacy OMAP3 ISP instantiation
>   v4l: omap3isp: Drop platform data support
> 
>  arch/arm/mach-omap2/devices.c               |  53 ----------
>  arch/arm/mach-omap2/devices.h               |  19 ----
>  drivers/media/platform/Kconfig              |   2 +-
>  drivers/media/platform/omap3isp/isp.c       | 133 ++++-------------------
>  drivers/media/platform/omap3isp/isp.h       |   7 +-
>  drivers/media/platform/omap3isp/ispcsiphy.h |   2 +-
>  drivers/media/platform/omap3isp/ispvideo.c  |   9 +-
>  drivers/media/platform/omap3isp/omap3isp.h  | 132 +++++++++++++++++++++++
>  include/media/omap3isp.h                    | 158 ----------------------------
>  9 files changed, 158 insertions(+), 357 deletions(-)
>  delete mode 100644 arch/arm/mach-omap2/devices.h
>  create mode 100644 drivers/media/platform/omap3isp/omap3isp.h
>  delete mode 100644 include/media/omap3isp.h

For the set:

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
sakari.ailus@iki.fi
