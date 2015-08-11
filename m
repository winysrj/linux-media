Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42415 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965150AbbHKPUM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 11:20:12 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Prabhakar Lad" <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 2/4] ov9650: remove an extra space
Date: Tue, 11 Aug 2015 12:18:31 -0300
Message-Id: <3b42fc32bc47814768f81eac8363c83da57a1a9c.1439306295.git.mchehab@osg.samsung.com>
In-Reply-To: <9d8c095a232ee176d14947bbe1330e1e3fbbde4c.1439306295.git.mchehab@osg.samsung.com>
References: <9d8c095a232ee176d14947bbe1330e1e3fbbde4c.1439306295.git.mchehab@osg.samsung.com>
In-Reply-To: <9d8c095a232ee176d14947bbe1330e1e3fbbde4c.1439306295.git.mchehab@osg.samsung.com>
References: <9d8c095a232ee176d14947bbe1330e1e3fbbde4c.1439306295.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/i2c/ov9650.c:1439 ov965x_detect_sensor() warn: inconsistent indenting

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index 2bc473385c91..e691bba1945b 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -1436,7 +1436,7 @@ static int ov965x_detect_sensor(struct v4l2_subdev *sd)
 	int ret;
 
 	mutex_lock(&ov965x->lock);
-	 __ov965x_set_power(ov965x, 1);
+	__ov965x_set_power(ov965x, 1);
 	usleep_range(25000, 26000);
 
 	/* Check sensor revision */
-- 
2.4.3

