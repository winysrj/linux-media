Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53729 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754749Ab3ADXGf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jan 2013 18:06:35 -0500
Date: Sat, 5 Jan 2013 01:06:31 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] omap3isp: Don't include <plat/cpu.h>
Message-ID: <20130104230630.GB13641@valkosipuli.retiisi.org.uk>
References: <1357248204-9863-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357248204-9863-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 03, 2013 at 10:23:24PM +0100, Laurent Pinchart wrote:
> The plat/*.h headers are not available to drivers in multiplatform
> kernels. As the header isn't needed, just remove it.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
