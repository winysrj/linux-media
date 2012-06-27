Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:39310 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab2F0Kmj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 06:42:39 -0400
Message-ID: <4FEAE396.3060400@iki.fi>
Date: Wed, 27 Jun 2012 13:42:30 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/2] Miscellaneous OMAP3 ISP fixes
References: <1340674496-31953-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1340674496-31953-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi everybody,
> 
> Not much to be said here. The first patch is needed by the second, which is
> described in its commit message. I'd like to get this into v3.6.
> 
> Laurent Pinchart (2):
>   omap3isp: Don't access ISP_CTRL directly in the statistics modules
>   omap3isp: Configure HS/VS interrupt source before enabling interrupts
> 
>  drivers/media/video/omap3isp/isp.c         |   47 +++++++++++++++++----------
>  drivers/media/video/omap3isp/isp.h         |    9 +++--
>  drivers/media/video/omap3isp/isph3a_aewb.c |   10 +-----
>  drivers/media/video/omap3isp/isph3a_af.c   |   10 +-----
>  drivers/media/video/omap3isp/isphist.c     |    6 +--
>  5 files changed, 40 insertions(+), 42 deletions(-)

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
sakari.ailus@iki.fi


