Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57061 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750913Ab2JVMQq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 08:16:46 -0400
Date: Mon, 22 Oct 2012 15:16:42 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] omap3isp: Replace printk with dev_*
Message-ID: <20121022121641.GT21261@valkosipuli.retiisi.org.uk>
References: <1350906290-456-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350906290-456-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 22, 2012 at 01:44:50PM +0200, Laurent Pinchart wrote:
> Use the dev_* message logging API instead of raw printk.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/platform/omap3isp/isp.c       |   12 ++++++------
>  drivers/media/platform/omap3isp/ispcsi2.c   |    6 +++---
>  drivers/media/platform/omap3isp/ispcsiphy.c |    2 +-
>  drivers/media/platform/omap3isp/ispvideo.c  |    3 ++-
>  4 files changed, 12 insertions(+), 11 deletions(-)

Exactly what I was about to say.

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
