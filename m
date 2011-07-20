Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:24762 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631Ab1GTNXr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2011 09:23:47 -0400
Message-ID: <4E26D6D7.1090403@maxwell.research.nokia.com>
Date: Wed, 20 Jul 2011 16:23:35 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 0/3] OMAP3 ISP patches for v3.1
References: <1310754250-28788-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1310754250-28788-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi everybody,
> 
> Here are the OMAP3 ISP patches in my queue for v3.1. I'll send a pull request
> in a couple of days if there's no objection.
> 
> Kalle Jokiniemi (2):
>   OMAP3: ISP: Add regulator control for omap34xx
>   OMAP3: RX-51: define vdds_csib regulator supply
> 
> Laurent Pinchart (1):
>   omap3isp: Support configurable HS/VS polarities
> 
>  arch/arm/mach-omap2/board-rx51-peripherals.c |    5 ++++
>  drivers/media/video/omap3isp/isp.h           |    6 +++++
>  drivers/media/video/omap3isp/ispccdc.c       |    4 +-
>  drivers/media/video/omap3isp/ispccp2.c       |   27 ++++++++++++++++++++++++-
>  drivers/media/video/omap3isp/ispccp2.h       |    1 +
>  5 files changed, 39 insertions(+), 4 deletions(-)

Hi Laurent,

Thanks for the patchset!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
