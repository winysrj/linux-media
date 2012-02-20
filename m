Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17954 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab2BTJdq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 04:33:46 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LZO00EC4QK7SR50@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Feb 2012 09:33:43 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZO00GEGQK7I9@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Feb 2012 09:33:43 +0000 (GMT)
Date: Mon, 20 Feb 2012 10:33:34 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 3/3] noon010pc30: Make subdev name independent of the I2C slave
 address
In-reply-to: <1329730414-7757-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1329730414-7757-4-git-send-email-s.nawrocki@samsung.com>
References: <1329730414-7757-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialize the subdev name properly so it doesn't have an I2C
bus and slave address appended to it.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/noon010pc30.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/noon010pc30.c b/drivers/media/video/noon010pc30.c
index 50838bf..d0904c5 100644
--- a/drivers/media/video/noon010pc30.c
+++ b/drivers/media/video/noon010pc30.c
@@ -725,8 +725,8 @@ static int noon010_probe(struct i2c_client *client,
 
 	mutex_init(&info->lock);
 	sd = &info->sd;
-	strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
 	v4l2_i2c_subdev_init(sd, client, &noon010_ops);
+	strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
 
 	sd->internal_ops = &noon010_subdev_internal_ops;
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-- 
1.7.9

