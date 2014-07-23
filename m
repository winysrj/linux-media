Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60851 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758237AbaGWXv6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 19:51:58 -0400
Date: Thu, 24 Jul 2014 02:51:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] OMAP3 ISP resizer live zoom fixes
Message-ID: <20140723235123.GU16460@valkosipuli.retiisi.org.uk>
References: <1406127431-9503-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406127431-9503-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 23, 2014 at 04:57:08PM +0200, Laurent Pinchart wrote:
> Hello,
> 
> This patch set fixes two issues occuring when performing live zoom with the
> OMAP3 ISP resizer.
> 
> The first issue has been observed when using the digital zoom of the live
> application (http://git.ideasonboard.org/omap3-isp-live.git) on a beagleboard.
> It leads to image corruption due to interrupt handling latency. Patch 2/3
> fixes it.
> 
> The second issue is a race condition that I haven't observed in practice. It's
> fixed by patch 3/3. As usual with race conditions and locking, careful review
> will be appreciated.
> 
> Laurent Pinchart (3):
>   omap3isp: resizer: Remove needless variable initializations
>   omap3isp: resizer: Remove slow debugging message from interrupt
>     handler
>   omap3isp: resizer: Protect against races when updating crop

For the set:

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
