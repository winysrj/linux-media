Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54969 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753825AbaAANO4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jan 2014 08:14:56 -0500
Date: Wed, 1 Jan 2014 15:14:20 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] OMAP3 ISP: Handle CCDC SBL idle failures gracefully
Message-ID: <20140101131419.GB7054@valkosipuli.retiisi.org.uk>
References: <1387888364-21631-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387888364-21631-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 24, 2013 at 01:32:41PM +0100, Laurent Pinchart wrote:
> Hello,
> 
> This patch set lets the driver recover from a CCDC SBL idle failure. When such
> a condition is detected all subsequent buffers will be marked as erroneous and
> the ISP will be reset the next time it gets released by userspace. Pipelines
> containing the CCDC will fail to start in the meantime.
> 
> SBL idle failures should not occur during normal operation but have been
> noticed with noisy sensor sync signals.
> 
> Laurent Pinchart (3):
>   omap3isp: Cancel streaming when a fatal error occurs
>   omap3isp: Refactor modules stop failure handling
>   omap3isp: ccdc: Don't hang when the SBL fails to become idle

For the series:

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
