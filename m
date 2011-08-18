Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17066 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194Ab1HRLW4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 07:22:56 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCHv2] adp1653: make ->power() method optional
Date: Thu, 18 Aug 2011 14:22:27 +0300
Message-Id: <98c77ce2a17d7a098dedfc858f4055edc5556c54.1313666504.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <20110818092158.GA8872@valkosipuli.localdomain>
References: <20110818092158.GA8872@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ->power() could be absent or not used on some platforms. This patch makes
its presence optional.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/video/adp1653.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
index 0fd9579..f830313 100644
--- a/drivers/media/video/adp1653.c
+++ b/drivers/media/video/adp1653.c
@@ -329,6 +329,11 @@ adp1653_set_power(struct v4l2_subdev *subdev, int on)
 	struct adp1653_flash *flash = to_adp1653_flash(subdev);
 	int ret = 0;
 
+	/* There is no need to switch power in case of absence ->power()
+	 * method. */
+	if (flash->platform_data->power == NULL)
+		return 0;
+
 	mutex_lock(&flash->power_lock);
 
 	/* If the power count is modified from 0 to != 0 or from != 0 to 0,
-- 
1.7.5.4

