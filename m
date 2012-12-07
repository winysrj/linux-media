Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46623 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030228Ab2LGNAo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Dec 2012 08:00:44 -0500
Date: Fri, 7 Dec 2012 15:00:40 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] omap3isp: preview: Lower the crop margins
Message-ID: <20121207130040.GB2887@valkosipuli.retiisi.org.uk>
References: <1354877797-28333-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1354880624-15528-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354880624-15528-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 07, 2012 at 12:43:44PM +0100, Laurent Pinchart wrote:
> The preview engine includes filters that consume columns and lines as
> part of their operation, thus resulting in a cropped image. To allow
> turning those filters on/off during streaming without affecting the
> output image size, the driver adds additional cropping to make the total
> number of cropped columns and lines constant regardless of which filters
> are enabled.
> 
> This process needlessly includes the CFA filter, as whether the filter
> is enabled only depends on the sink pad format, which can't change
> during streaming.
> 
> Exclude the CFA filter from the preview engine margins.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/platform/omap3isp/isppreview.c |   40 +++++++++++++------------
>  1 files changed, 21 insertions(+), 19 deletions(-)

Thanks!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
