Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38133 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932919Ab2CZQX4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 12:23:56 -0400
Date: Mon, 26 Mar 2012 19:23:54 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] omap3isp: preview: Skip brightness and contrast in
 configuration ioctl
Message-ID: <20120326162354.GF913@valkosipuli.localdomain>
References: <1332772951-19108-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1332772951-19108-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332772951-19108-2-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 26, 2012 at 04:42:29PM +0200, Laurent Pinchart wrote:
> Brightness and contrast are handled through V4L2 controls. Their
> configuration bit in the preview engine update attributes table is set
> to -1 to reflect that. However, the VIDIOC_OMAP3ISP_PRV_CFG ioctl
> handler doesn't handle -1 correctly as a configuration bit value, and
> erroneously considers that the parameter has been selected for update by
> the ioctl caller. Fix this.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
