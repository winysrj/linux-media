Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9749 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094Ab1HKLfc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2011 07:35:32 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] adp1653: set media entity type
Date: Thu, 11 Aug 2011 14:35:04 +0300
Message-Id: <bdfa2fa007fe799206043c874017fb3b412f7f32.1313062441.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <20110811071900.GC5926@valkosipuli.localdomain>
References: <20110811071900.GC5926@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The type of a media entity is default for this driver. This patch makes it
explicitly defined as MEDIA_ENT_T_V4L2_SUBDEV_FLASH.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/video/adp1653.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
index 7f2e710..0fd9579 100644
--- a/drivers/media/video/adp1653.c
+++ b/drivers/media/video/adp1653.c
@@ -438,6 +438,8 @@ static int adp1653_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto free_and_quit;
 
+	flash->subdev.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
+
 	return 0;
 
 free_and_quit:
-- 
1.7.5.4

