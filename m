Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38474 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbbGPMy6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 08:54:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Tony Lindgren <tony@atomide.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 0/2] omap3isp: Remove legacy platform data support
Date: Thu, 16 Jul 2015 15:55:17 +0300
Message-Id: <1437051319-9904-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Now that all users of the OMAP3 ISP have switched to DT, this patch series
removes support for legacy platform data support in the omap3isp driver. It
also drops the OMAP3 ISP device instantiation board code that is now unused.

Patch 2/2 depends on 1/2. From a conflict resolution point of view it would be
easier to merge the whole series through the linux-media tree. Tony, would
that be fine with you ? If so could you please ack patch 1/2 ?

Laurent Pinchart (2):
  ARM: OMAP2+: Remove legacy OMAP3 ISP instantiation
  v4l: omap3isp: Drop platform data support

 arch/arm/mach-omap2/devices.c               |  53 ----------
 arch/arm/mach-omap2/devices.h               |  19 ----
 drivers/media/platform/Kconfig              |   2 +-
 drivers/media/platform/omap3isp/isp.c       | 133 ++++-------------------
 drivers/media/platform/omap3isp/isp.h       |   7 +-
 drivers/media/platform/omap3isp/ispcsiphy.h |   2 +-
 drivers/media/platform/omap3isp/ispvideo.c  |   9 +-
 drivers/media/platform/omap3isp/omap3isp.h  | 132 +++++++++++++++++++++++
 include/media/omap3isp.h                    | 158 ----------------------------
 9 files changed, 158 insertions(+), 357 deletions(-)
 delete mode 100644 arch/arm/mach-omap2/devices.h
 create mode 100644 drivers/media/platform/omap3isp/omap3isp.h
 delete mode 100644 include/media/omap3isp.h

-- 
Regards,

Laurent Pinchart

