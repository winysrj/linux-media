Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41808 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab3ACVWG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 16:22:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-omap@vger.kernel.org,
	Tony Lindgren <tony@atomide.com>
Subject: [PATCH] omap3isp: Don't include <plat/cpu.h>
Date: Thu,  3 Jan 2013 22:23:24 +0100
Message-Id: <1357248204-9863-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The plat/*.h headers are not available to drivers in multiplatform
kernels. As the header isn't needed, just remove it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 50cea08..07eea5b 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -71,8 +71,6 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 
-#include <plat/cpu.h>
-
 #include "isp.h"
 #include "ispreg.h"
 #include "ispccdc.h"
-- 
Regards,

Laurent Pinchart

