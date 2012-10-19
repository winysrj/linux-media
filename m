Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56457 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755315Ab2JSVbS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Oct 2012 17:31:18 -0400
Date: Sat, 20 Oct 2012 00:31:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] smiapp-pll: Add missing trailing newlines to warning
 messages
Message-ID: <20121019213113.GN21261@valkosipuli.retiisi.org.uk>
References: <1350567104-6533-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350567104-6533-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 18, 2012 at 03:31:44PM +0200, Laurent Pinchart wrote:
> Two warning messages are missing a trailing newline. Fix it.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/i2c/smiapp-pll.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

Thanks, Laurent!

Applied to my tree.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
