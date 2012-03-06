Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:53380 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965262Ab2CFUjp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Mar 2012 15:39:45 -0500
Message-ID: <4F567604.4030902@iki.fi>
Date: Tue, 06 Mar 2012 22:39:32 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org,
	Martin Hostettler <martin@neutronstar.dyndns.org>
Subject: Re: [PATCH v3 4/5] mt9p031: Use generic PLL setup code
References: <1331051559-13841-1-git-send-email-laurent.pinchart@ideasonboard.com> <1331051559-13841-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1331051559-13841-5-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the patch, Laurent!

Laurent Pinchart wrote:
> Compute the PLL parameters at runtime using the generic Aptina PLL
> helper.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/Kconfig   |    1 +
>  drivers/media/video/mt9p031.c |   62 ++++++++++++++++++-----------------------
>  2 files changed, 28 insertions(+), 35 deletions(-)

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
sakari.ailus@iki.fi
