Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:56126 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756984Ab1KORuL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 12:50:11 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 3/9] as3645a: remove unused code
Date: Tue, 15 Nov 2011 19:49:55 +0200
Message-Id: <80dfc8ccdb86c0d363500956d8ecb9445d3e3f18.1321379276.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
References: <1321374065-20063-3-git-send-email-laurent.pinchart@ideasonboard.com>
 <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
References: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/video/as3645a.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
index 8882a14..5c7e42f 100644
--- a/drivers/media/video/as3645a.c
+++ b/drivers/media/video/as3645a.c
@@ -90,9 +90,6 @@
 #define AS_PASSWORD_REG				0x0f
 #define AS_PASSWORD_UNLOCK_VALUE		0x55
 
-/* AS_CONTROL_EXT_TORCH_ON - on, 0 - off */
-#define TORCH_IN_STANDBY			0
-
 enum as_mode {
 	AS_MODE_EXT_TORCH = 0 << AS_CONTROL_MODE_SETTING_SHIFT,
 	AS_MODE_INDICATOR = 1 << AS_CONTROL_MODE_SETTING_SHIFT,
@@ -228,7 +225,6 @@ as3645a_set_control(struct as3645a *flash, enum as_mode mode, bool on)
 
 	/* Configure output parameters and operation mode. */
 	reg = (flash->pdata->peak << AS_CONTROL_COIL_PEAK_SHIFT)
-	    | TORCH_IN_STANDBY
 	    | (on ? AS_CONTROL_OUT_ON : 0)
 	    | mode;
 
-- 
1.7.7.1

