Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44750 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab2D2QX2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Apr 2012 12:23:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 0/3] omap3isp: Implement selection API support
Date: Sun, 29 Apr 2012 18:23:42 +0200
Message-Id: <1335716625-2388-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

There 3 patches implement support for the selection API in the OMAP3 ISP
driver. Support for the legacy subdev crop API is removed from the driver,
but still available through the translation layer in the subdev core.

Laurent Pinchart (3):
  omap3isp: ccdc: Add selection support on output formatter source pad
  omap3isp: preview: Replace the crop API by the selection API
  omap3isp: resizer: Replace the crop API by the selection API

 drivers/media/video/omap3isp/ispccdc.c    |  180 ++++++++++++++++++++++++++--
 drivers/media/video/omap3isp/ispccdc.h    |    2 +
 drivers/media/video/omap3isp/isppreview.c |   74 +++++++++---
 drivers/media/video/omap3isp/ispresizer.c |  138 ++++++++++++++--------
 4 files changed, 311 insertions(+), 83 deletions(-)

-- 
Regards,

Laurent Pinchart

