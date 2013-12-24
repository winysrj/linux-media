Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52680 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3LXMcV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Dec 2013 07:32:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 0/3] OMAP3 ISP: Handle CCDC SBL idle failures gracefully
Date: Tue, 24 Dec 2013 13:32:41 +0100
Message-Id: <1387888364-21631-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch set lets the driver recover from a CCDC SBL idle failure. When such
a condition is detected all subsequent buffers will be marked as erroneous and
the ISP will be reset the next time it gets released by userspace. Pipelines
containing the CCDC will fail to start in the meantime.

SBL idle failures should not occur during normal operation but have been
noticed with noisy sensor sync signals.

Laurent Pinchart (3):
  omap3isp: Cancel streaming when a fatal error occurs
  omap3isp: Refactor modules stop failure handling
  omap3isp: ccdc: Don't hang when the SBL fails to become idle

 drivers/media/platform/omap3isp/isp.c      | 53 ++++++++++++++++++++++--------
 drivers/media/platform/omap3isp/isp.h      |  3 ++
 drivers/media/platform/omap3isp/ispccdc.c  |  2 ++
 drivers/media/platform/omap3isp/ispvideo.c | 46 ++++++++++++++++++++++++++
 drivers/media/platform/omap3isp/ispvideo.h |  2 ++
 5 files changed, 92 insertions(+), 14 deletions(-)

-- 
Regards,

Laurent Pinchart

