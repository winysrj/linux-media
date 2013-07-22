Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:54459 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab3GVSF1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jul 2013 14:05:27 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQC00C5HNL1WLS0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 23 Jul 2013 03:05:26 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, prabhakar.csengg@gmail.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 1/5] V4L2: Drop bus_type check in v4l2-async match functions
Date: Mon, 22 Jul 2013 20:04:43 +0200
Message-id: <1374516287-7638-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
References: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These match_* functions are internal callbacks and are always
invoked only after checking asd->bus_type. So drop redundant
checks in match_i2c() and match_platform() functions.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/v4l2-core/v4l2-async.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index aae2417..ff87c29 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -27,7 +27,6 @@ static bool match_i2c(struct device *dev, struct v4l2_async_subdev *asd)
 #if IS_ENABLED(CONFIG_I2C)
 	struct i2c_client *client = i2c_verify_client(dev);
 	return client &&
-		asd->bus_type == V4L2_ASYNC_BUS_I2C &&
 		asd->match.i2c.adapter_id == client->adapter->nr &&
 		asd->match.i2c.address == client->addr;
 #else
@@ -37,8 +36,7 @@ static bool match_i2c(struct device *dev, struct v4l2_async_subdev *asd)
 
 static bool match_platform(struct device *dev, struct v4l2_async_subdev *asd)
 {
-	return asd->bus_type == V4L2_ASYNC_BUS_PLATFORM &&
-		!strcmp(asd->match.platform.name, dev_name(dev));
+	return !strcmp(asd->match.platform.name, dev_name(dev));
 }
 
 static LIST_HEAD(subdev_list);
-- 
1.7.9.5

