Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:56126 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757022Ab1KORuM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 12:50:12 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 9/9] as3645a: use the same timeout for hw and sw strobes
Date: Tue, 15 Nov 2011 19:50:01 +0200
Message-Id: <47ec50e2b3637effbfae5a9dade70b7b2745e377.1321379276.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
References: <1321374065-20063-3-git-send-email-laurent.pinchart@ideasonboard.com>
 <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
References: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It seems the timeout value couldn't be different for either external or
software strobe (accordingly to as3645a datasheet, table 6).

This patch doesn't prevent to use software watchdog, because it will use
another mechanism to stop strobing (i.e. low "out" pin).

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/video/as3645a.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
index 5f8fa68..5462209 100644
--- a/drivers/media/video/as3645a.c
+++ b/drivers/media/video/as3645a.c
@@ -187,18 +187,8 @@ static int as3645a_set_config(struct as3645a *flash)
 	if (ret < 0)
 		return ret;
 
-	if (flash->strobe_source == V4L2_FLASH_STROBE_SOURCE_EXTERNAL) {
-		/* Use timeout to protect the flash in case the external
-		 * strobe gets stuck. Minimum value 100 ms, maximum 850 ms.
-		 */
-		u32 timeout = DIV_ROUND_UP(flash->timeout, 1000);
-		timeout = max_t(u32, DIV_ROUND_UP(timeout, 50) * 50, 100);
-		val = AS_TIMER_MS_TO_CODE(timeout)
+	val = AS_TIMER_MS_TO_CODE(flash->timeout / 1000)
 		    << AS_INDICATOR_AND_TIMER_TIMEOUT_SHIFT;
-	} else {
-		val = AS_TIMER_MS_TO_CODE(flash->timeout / 1000)
-		    << AS_INDICATOR_AND_TIMER_TIMEOUT_SHIFT;
-	}
 
 	val |= (flash->pdata->vref << AS_INDICATOR_AND_TIMER_VREF_SHIFT)
 	    |  ((flash->indicator_current ? flash->indicator_current - 1 : 0)
-- 
1.7.7.1

