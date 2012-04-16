Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52115 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab2DPN3p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Apr 2012 09:29:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH v3 0/9] OMAP3 ISP preview engine configuration improvement
Date: Mon, 16 Apr 2012 15:29:45 +0200
Message-Id: <1334582994-6967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here's the third version of the OMAP3 ISP preview engine configuration
improvement patches.

Patches 1 to 3 have already been acked and haven't changed since v1. Patches 4
to 8 are new small improvements and cleanups, patch 9 is a complete rework of
the shadow update issue fix previously submitted as 4/4 in v2.

Laurent Pinchart (9):
  omap3isp: preview: Skip brightness and contrast in configuration
    ioctl
  omap3isp: preview: Optimize parameters setup for the common case
  omap3isp: preview: Remove averager parameter update flag
  omap3isp: preview: Remove unused isptables_update structure
    definition
  omap3isp: preview: Merge configuration and feature bits
  omap3isp: preview: Remove update_attrs feature_bit field
  omap3isp: preview: Rename prev_params fields to match userspace API
  omap3isp: preview: Simplify configuration parameters access
  omap3isp: preview: Shorten shadow update delay

 drivers/media/video/omap3isp/isppreview.c |  511 +++++++++++++++++------------
 drivers/media/video/omap3isp/isppreview.h |   76 ++---
 2 files changed, 326 insertions(+), 261 deletions(-)

-- 
Regards,

Laurent Pinchart

