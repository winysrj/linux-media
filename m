Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:25278 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755139Ab1HRIxb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 04:53:31 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH] adp1653: make ->power() method optional
Date: Thu, 18 Aug 2011 11:53:03 +0300
Message-Id: <aa45d92c4ec78b36b28eb721ef58f3a5512900a3.1313657559.git.andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ->power() could be absent or not used on some platforms. This patch makes
its presence optional.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/adp1653.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
index 0fd9579..65f6f3f 100644
--- a/drivers/media/video/adp1653.c
+++ b/drivers/media/video/adp1653.c
@@ -309,6 +309,9 @@ __adp1653_set_power(struct adp1653_flash *flash, int on)
 {
 	int ret;
 
+	if (flash->platform_data->power == NULL)
+		return 0;
+
 	ret = flash->platform_data->power(&flash->subdev, on);
 	if (ret < 0)
 		return ret;
-- 
1.7.5.4

