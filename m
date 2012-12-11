Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47679 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753045Ab2LKPkv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Dec 2012 10:40:51 -0500
Date: Tue, 11 Dec 2012 17:40:46 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] omap3isp: csiphy: Fix an uninitialized variable
 compiler warning
Message-ID: <20121211154046.GA3747@valkosipuli.retiisi.org.uk>
References: <1355231512-5158-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1355231512-5158-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 11, 2012 at 02:11:52PM +0100, Laurent Pinchart wrote:
> drivers/media/platform/omap3isp/ispcsiphy.c: In function
> ‘csiphy_routing_cfg’:
> drivers/media/platform/omap3isp/ispcsiphy.c:71:57: warning: ‘shift’
> may be used uninitialized in this function [-Wuninitialized]
> drivers/media/platform/omap3isp/ispcsiphy.c:40:6: note: ‘shift’ was
> declared here
> 
> The warning is a false positive but the compiler is right in
> complaining. Fix it by using the correct enum data type for the iface
> argument and adding a default case in the switch statement.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
