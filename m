Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38136 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932919Ab2CZQYV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 12:24:21 -0400
Date: Mon, 26 Mar 2012 19:24:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] omap3isp: preview: Optimize parameters setup for
 the common case
Message-ID: <20120326162419.GG913@valkosipuli.localdomain>
References: <1332772951-19108-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1332772951-19108-3-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332772951-19108-3-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks!

On Mon, Mar 26, 2012 at 04:42:30PM +0200, Laurent Pinchart wrote:
> If no parameter needs to be modified, make preview_config() and
> preview_setup_hw() return immediately. This speeds up interrupt handling
> in the common case.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
