Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43355 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750807Ab2IOGcZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 02:32:25 -0400
Date: Sat, 15 Sep 2012 09:32:20 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Antoine Reversat <a.reversat@gmail.com>
Subject: Re: [PATCH v2] omap3isp: Use monotonic timestamps for statistics
 buffers
Message-ID: <20120915063220.GN6834@valkosipuli.retiisi.org.uk>
References: <1347659868-17398-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347659868-17398-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks, Laurent!

On Fri, Sep 14, 2012 at 11:57:48PM +0200, Laurent Pinchart wrote:
> V4L2 buffers use the monotonic clock, while statistics buffers use wall
> time. This makes it difficult to correlate video frames and statistics.
> 
> Switch statistics buffers to the monotonic clock to fix this, and
> replace struct timeval with struct timespec.
> 
> Reported-by: Antoine Reversat <a.reversat@gmail.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/platform/omap3isp/ispstat.c |    2 +-
>  drivers/media/platform/omap3isp/ispstat.h |    2 +-
>  include/linux/omap3isp.h                  |    7 ++++++-
>  3 files changed, 8 insertions(+), 3 deletions(-)

Acked-by: Sakari Ailus <sakari.ailu@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
