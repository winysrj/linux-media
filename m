Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59042 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751581Ab2JYVpe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 17:45:34 -0400
Date: Fri, 26 Oct 2012 00:45:29 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] omap3isp: Prepare/unprepare clocks before/after
 enable/disable
Message-ID: <20121025214529.GD24073@valkosipuli.retiisi.org.uk>
References: <1351201183-21036-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351201183-21036-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, Oct 25, 2012 at 11:39:42PM +0200, Laurent Pinchart wrote:
> Clock enable (disable) is split in two operations, prepare and enable
> (disable and unprepare). Perform both when enabling/disabling the ISP
> clocks.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/platform/omap3isp/isp.c |   25 +++++++++++++------------
>  1 files changed, 13 insertions(+), 12 deletions(-)

Thanks for the patch!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
