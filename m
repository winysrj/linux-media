Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31931 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab1KORuL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 12:50:11 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 8/9] as3645a: use pr_err macro instead of printk KERN_ERR
Date: Tue, 15 Nov 2011 19:50:00 +0200
Message-Id: <876c8ef258930c5119862c47caf802ca32d66598.1321379276.git.andriy.shevchenko@linux.intel.com>
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
index 774f797..5f8fa68 100644
--- a/drivers/media/video/as3645a.c
+++ b/drivers/media/video/as3645a.c
@@ -864,7 +864,7 @@ static int __init as3645a_init(void)
 
 	rval = i2c_add_driver(&as3645a_i2c_driver);
 	if (rval)
-		printk(KERN_ERR "Failed registering driver" AS3645A_NAME"\n");
+		pr_err("%s: Failed to register the driver\n", AS3645A_NAME);
 
 	return rval;
 }
-- 
1.7.7.1

