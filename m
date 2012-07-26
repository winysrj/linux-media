Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53675 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752457Ab2GZU6k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 16:58:40 -0400
Date: Thu, 26 Jul 2012 23:58:37 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/4] Aptinate sensors patches
Message-ID: <20120726205836.GB26136@valkosipuli.retiisi.org.uk>
References: <1343068502-7431-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343068502-7431-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 23, 2012 at 08:34:58PM +0200, Laurent Pinchart wrote:
> Hi everybody,
> 
> Here are three fixes/patches for the MT9P031 and MT9V032 sensor drivers. The
> second patch (mt9v032 pixel rate control) requires a control framework
> modification (1/4) that has already been reviewed.
> 
> Sakari, I've rebased your patch on top of the latest media tree, could you
> please review it ?

For patches 1, 2 and 4:

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
