Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36248 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab2LaMZI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Dec 2012 07:25:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH FOR v3.8] omap3isp: Don't include deleted OMAP plat/ header files
Date: Mon, 31 Dec 2012 13:26:33 +0100
Message-Id: <1356956793-7984-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The plat/iommu.h, plat/iovmm.h and plat/omap-pm.h have been deleted.
Don't include them.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispvideo.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index e0d73a6..8dac175 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -35,9 +35,6 @@
 #include <linux/vmalloc.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-ioctl.h>
-#include <plat/iommu.h>
-#include <plat/iovmm.h>
-#include <plat/omap-pm.h>
 
 #include "ispvideo.h"
 #include "isp.h"
-- 
Regards,

Laurent Pinchart

