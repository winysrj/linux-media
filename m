Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47339 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751272AbaEARhy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 1 May 2014 13:37:54 -0400
Date: Thu, 1 May 2014 20:37:49 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 00/26] OMAP3 ISP: Move to videobuf2
Message-ID: <20140501173749.GV8753@valkosipuli.retiisi.org.uk>
References: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398083352-8451-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Apr 21, 2014 at 02:28:46PM +0200, Laurent Pinchart wrote:
> This is the second version of the patch set that ports the OMAP3 ISP driver to
> the videobuf2 framework. I've tried to keep patches small and reviewable
> (24/25 is a bit too big for my taste, but splitting it further would be pretty
> difficult), so please look at them for details.
> 
> The patches are based on top of the latest OMAP IOMMU patches queued for
> v3.16, themselves based directly on top of v3.15-rc1. The result is currently
> broken due to changes to the ARM DMA mapping implementation in v3.15-rc1. A
> patch (http://www.spinics.net/lists/arm-kernel/msg324012.html) has been posted
> and should go in v3.15. Please apply the patch in the meantime if you want to
> test the driver.
> 
> I plan to send a pull request for v3.16 around the end of the week.

For the set:

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
