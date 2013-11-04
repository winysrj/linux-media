Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45144 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753531Ab3KDOOU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Nov 2013 09:14:20 -0500
Date: Mon, 4 Nov 2013 16:14:17 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] v4l: omap3isp: Don't check for missing get_fmt op on
 remote subdev
Message-ID: <20131104141416.GC23061@valkosipuli.retiisi.org.uk>
References: <1383573782-3599-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383573782-3599-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 04, 2013 at 03:03:02PM +0100, Laurent Pinchart wrote:
> The remote subdev of any video node in the OMAP3 ISP is an internal
> subdev that is guaranteed to implement get_fmt. Don't check the return
> value for -ENOIOCTLCMD, as this can't happen.
> 
> While at it, move non-critical code out of the mutex-protected section.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
