Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63504 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab1KORuH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 12:50:07 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/9] as3645a: mention lm3555 as a clone of that chip
Date: Tue, 15 Nov 2011 19:49:53 +0200
Message-Id: <826d9a185058081617ca8662e52f9a9977948ba0.1321379276.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
References: <1321374065-20063-3-git-send-email-laurent.pinchart@ideasonboard.com>
 <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
References: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/video/as3645a.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
index a9f857f..ef1226d 100644
--- a/drivers/media/video/as3645a.c
+++ b/drivers/media/video/as3645a.c
@@ -878,5 +878,5 @@ module_init(as3645a_init);
 module_exit(as3645a_exit);
 
 MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
-MODULE_DESCRIPTION("AS3645A Flash driver");
+MODULE_DESCRIPTION("LED Flash driver for AS3645a, LM3555 and their clones");
 MODULE_LICENSE("GPL");
-- 
1.7.7.1

