Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38089 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754037Ab2DXXTt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Apr 2012 19:19:49 -0400
Date: Wed, 25 Apr 2012 02:19:45 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/4] omap3isp: preview: Add support for greyscale input
Message-ID: <20120424231945.GE7913@valkosipuli.localdomain>
References: <1335180595-27931-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1335180595-27931-3-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335180595-27931-3-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch!

On Mon, Apr 23, 2012 at 01:29:53PM +0200, Laurent Pinchart wrote:
> Configure CFA interpolation automatically based on the input format.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/omap3isp/isppreview.c |   52 ++++++++++++++++------------
>  1 files changed, 30 insertions(+), 22 deletions(-)

Acked-by: <sakari.ailus@iki.fi>

(Same for 1/4, too!)

It looks like the OMAP 3 ISP will be functionally complete soon! 8-)

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
