Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55280 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216AbcBETKZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2016 14:10:25 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 3/8] [media] tvp5150: put endpoint node on error
Date: Fri,  5 Feb 2016 16:09:53 -0300
Message-Id: <1454699398-8581-4-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1454699398-8581-1-git-send-email-javier@osg.samsung.com>
References: <1454699398-8581-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the parallel mbus configuration is not correct, the endpoint
device node isn't currently put again in the error path. Fix it.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/i2c/tvp5150.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 19b52736b24e..c7eeb59a999b 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1268,8 +1268,10 @@ static int tvp5150_parse_dt(struct tvp5150 *decoder, struct device_node *np)
 	if (bus_cfg.bus_type == V4L2_MBUS_PARALLEL &&
 	    !(flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH &&
 	      flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH &&
-	      flags & V4L2_MBUS_FIELD_EVEN_LOW))
-		return -EINVAL;
+	      flags & V4L2_MBUS_FIELD_EVEN_LOW)) {
+		ret = -EINVAL;
+		goto err;
+	}
 
 	decoder->mbus_type = bus_cfg.bus_type;
 
-- 
2.5.0

