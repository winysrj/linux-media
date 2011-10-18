Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:32907 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab1JRVOr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Oct 2011 17:14:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 0/3] OMAP3 ISP preview engine crop support
Date: Tue, 18 Oct 2011 23:14:54 +0200
Message-Id: <1318972497-8367-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Those two patches add cropping support at the preview engine input. The first
patch removes horizontal averager support (unused) to ease crop implementation.
Horizontal averager support will be added back later if needed.

Laurent Pinchart (3):
  omap3isp: preview: Remove horizontal averager support
  omap3isp: preview: Rename min/max input/output sizes defines
  omap3isp: preview: Add crop support on the sink pad

 drivers/media/video/omap3isp/isppreview.c |  311 ++++++++++++++++++++---------
 drivers/media/video/omap3isp/isppreview.h |    9 +-
 drivers/media/video/omap3isp/ispreg.h     |    3 -
 3 files changed, 216 insertions(+), 107 deletions(-)

-- 
Regards,

Laurent Pinchart

