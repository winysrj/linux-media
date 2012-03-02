Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:51461 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074Ab2CBR7C (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 12:59:02 -0500
Date: Fri, 2 Mar 2012 19:58:59 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Kruno Mrak <kruno.mrak@matrix-vision.de>
Subject: Re: [PATCH] omap3isp: Fix frame number propagation
Message-ID: <20120302175858.GE15695@valkosipuli.localdomain>
References: <1330685342-15139-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330685342-15139-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Mar 02, 2012 at 11:49:02AM +0100, Laurent Pinchart wrote:
> When propagating the frame number through the pipeline, the frame number
> must be incremented at frame start by the appropriate IRQ handler. This
> was properly handled for the CSI2 and CCP2 receivers, but not when the
> CCDC parallel interface is used.
> 
> ADD frame number incrementation to the HS/VS interrupt handler. As the
> HS/VS interrupt is also generated for frames received by the CSI2 and
> CCP2 receivers, remove explicit propagation handling from the serial
> receivers.
> 
> Reported-by: Kruno Mrak <kruno.mrak@matrix-vision.de>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/omap3isp/isp.c     |    8 --------
>  drivers/media/video/omap3isp/ispccdc.c |    3 +++
>  drivers/media/video/omap3isp/ispccp2.c |   23 -----------------------
>  drivers/media/video/omap3isp/ispcsi2.c |   20 +++-----------------
>  drivers/media/video/omap3isp/ispcsi2.h |    1 -
>  5 files changed, 6 insertions(+), 49 deletions(-)

Thanks for the patch, Laurent!

Also, this patch simplifies frame numbering a lot.

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
Tested-by: Sakari Ailus <sakari.ailus@iki.fi>

Using CSI-2 receiver writing straight to memory, that is.

There's a slight dependency to my patches; are you going to submit this
first or how shall we proceed? No conflicts but there's some fuzz
nonetheless.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
