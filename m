Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34570 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab1KORuI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 12:50:08 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/9] as3645a: print vendor and revision of the chip
Date: Tue, 15 Nov 2011 19:49:54 +0200
Message-Id: <461cc7fb0ff5b466b2a53b823241c5792ba7900a.1321379276.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
References: <1321374065-20063-3-git-send-email-laurent.pinchart@ideasonboard.com>
 <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
References: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The as3645a_registered() is used to detect connected chip. It would be nice to
print the detected value every time we load the module. The "Vendor" is
probably better word to use there. For example, lm3555 (NSC) is slightly
different to as3645a.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/video/as3645a.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
index ef1226d..8882a14 100644
--- a/drivers/media/video/as3645a.c
+++ b/drivers/media/video/as3645a.c
@@ -602,8 +602,8 @@ static int as3645a_registered(struct v4l2_subdev *sd)
 		factory = "Unknown";
 	}
 
-	dev_dbg(&client->dev, "Factory: %s(%d) Version: %d\n", factory, man,
-		version);
+	dev_info(&client->dev, "Chip vendor: %s(%d) Version: %d\n", factory,
+			man, version);
 
 	rval = as3645a_write(flash, AS_PASSWORD_REG, AS_PASSWORD_UNLOCK_VALUE);
 	if (rval < 0)
-- 
1.7.7.1

