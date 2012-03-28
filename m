Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46352 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab2C1MAO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Mar 2012 08:00:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH v2 0/4] OMAP3 ISP preview engine configuration improvement
Date: Wed, 28 Mar 2012 13:59:57 +0200
Message-Id: <1332936001-32603-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here's the second version of the OMAP3 ISP preview engine configuration
improvement patches.

Patches 1/4 and 2/4 have already been acked and haven't changed since v1. Patch
3/4 is a new bug fix, and patch 4/4 is a complete rework of the shadow update
issue fix previously submitted as 3/3 in v1.

Laurent Pinchart (4):
  omap3isp: preview: Skip brightness and contrast in configuration
    ioctl
  omap3isp: preview: Optimize parameters setup for the common case
  omap3isp: preview: Remove averager parameter update flag
  omap3isp: preview: Shorten shadow update delay

 drivers/media/video/omap3isp/isppreview.c |  144 +++++++++++++++++++++--------
 drivers/media/video/omap3isp/isppreview.h |   24 +++--
 2 files changed, 119 insertions(+), 49 deletions(-)

-- 
Regards,

Laurent Pinchart

