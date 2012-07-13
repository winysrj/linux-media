Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:21302 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933050Ab2GMMpC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jul 2012 08:45:02 -0400
Message-ID: <5000185B.5030008@iki.fi>
Date: Fri, 13 Jul 2012 15:45:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	Jean-Philippe Francois <jp.francois@cynove.com>
Subject: Re: [PATCH v3 0/6] omap3isp: preview: Add support for non-GRBG Bayer
 patterns
References: <1342179458-1037-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1342179458-1037-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi everybody,
> 
> Here's the third version of the non-GRBG Bayer patterns support for the OMAP3
> ISP preview engine. Compared to v2, the OMAP3ISP_PREV_GAMMABYPASS has been
> removed and the CFA table is now stored in a multi-dimensional array.
> 
> Laurent Pinchart (6):
>   omap3isp: preview: Fix contrast and brightness handling
>   omap3isp: preview: Remove lens shading compensation support
>   omap3isp: preview: Pass a prev_params pointer to configuration
>     functions
>   omap3isp: preview: Reorder configuration functions
>   omap3isp: preview: Merge gamma correction and gamma bypass
>   omap3isp: preview: Add support for non-GRBG Bayer patterns
> 
>  drivers/media/video/omap3isp/cfa_coef_table.h |   16 +-
>  drivers/media/video/omap3isp/isppreview.c     |  707 ++++++++++++-------------
>  drivers/media/video/omap3isp/isppreview.h     |    1 +
>  include/linux/omap3isp.h                      |    5 +-
>  4 files changed, 355 insertions(+), 374 deletions(-)

For the whole set:

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
sakari.ailus@iki.fi


