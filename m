Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49116 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190AbaGWO5C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 10:57:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 0/3] OMAP3 ISP resizer live zoom fixes
Date: Wed, 23 Jul 2014 16:57:08 +0200
Message-Id: <1406127431-9503-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch set fixes two issues occuring when performing live zoom with the
OMAP3 ISP resizer.

The first issue has been observed when using the digital zoom of the live
application (http://git.ideasonboard.org/omap3-isp-live.git) on a beagleboard.
It leads to image corruption due to interrupt handling latency. Patch 2/3
fixes it.

The second issue is a race condition that I haven't observed in practice. It's
fixed by patch 3/3. As usual with race conditions and locking, careful review
will be appreciated.

Laurent Pinchart (3):
  omap3isp: resizer: Remove needless variable initializations
  omap3isp: resizer: Remove slow debugging message from interrupt
    handler
  omap3isp: resizer: Protect against races when updating crop

 drivers/media/platform/omap3isp/ispresizer.c | 70 ++++++++++++++++++----------
 drivers/media/platform/omap3isp/ispresizer.h |  3 ++
 2 files changed, 48 insertions(+), 25 deletions(-)

-- 
Regards,

Laurent Pinchart

