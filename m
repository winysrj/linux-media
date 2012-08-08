Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57791 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753226Ab2HHPiY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Aug 2012 11:38:24 -0400
Date: Wed, 8 Aug 2012 18:38:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] omap3isp: Mark the resizer output video node as the
 default video node
Message-ID: <20120808153819.GG29636@valkosipuli.retiisi.org.uk>
References: <1344439857-7858-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344439857-7858-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 08, 2012 at 05:30:57PM +0200, Laurent Pinchart wrote:
> The resizer can output YUYV and UYVY in a wide range of sizes, making it
> the best video node for regular V4L2 applications.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
