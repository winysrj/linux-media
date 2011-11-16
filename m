Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:55060 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab1KPUNr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 15:13:47 -0500
Message-ID: <4EC41978.1020309@iki.fi>
Date: Wed, 16 Nov 2011 22:13:44 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/4] Miscellaneous omap3-isp patches
References: <1321474006-24589-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1321474006-24589-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi everybody,
>
> The subject says it all. Two of the patches fix crashes, while the other two
> are minor modifications with no impact on the compiled code. I'll push them
> for v3.3.
>
> Laurent Pinchart (4):
>    omap3isp: preview: Rename max output sizes defines
>    omap3isp: ccdc: Fix crash in HS/VS interrupt handler
>    omap3isp: Fix crash caused by subdevs now having a pointer to
>      devnodes
>    omap3isp: Clarify the clk_pol field in platform data
>
>   drivers/media/video/omap3isp/ispccdc.c    |    5 ++---
>   drivers/media/video/omap3isp/isppreview.c |   16 ++++++++--------
>   drivers/media/video/omap3isp/ispstat.c    |    2 +-
>   include/media/omap3isp.h                  |    2 +-
>   4 files changed, 12 insertions(+), 13 deletions(-)

Thanks, Laurent!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
sakari.ailus@iki.fi
