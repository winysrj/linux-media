Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40254 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751182AbdJDVuy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 17:50:54 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v15 02/32] v4l: async: Don't set sd->dev NULL in v4l2_async_cleanup
Date: Thu,  5 Oct 2017 00:50:21 +0300
Message-Id: <20171004215051.13385-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v4l2_async_cleanup() is called when the async sub-device is unbound from
the media device. As the pointer is set by the driver registering the
async sub-device, leave the pointer as set by the driver.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 60a1a50b9537..21c748bf3a7b 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -134,7 +134,6 @@ static void v4l2_async_cleanup(struct v4l2_subdev *sd)
 	/* Subdevice driver will reprobe and put the subdev back onto the list */
 	list_del_init(&sd->async_list);
 	sd->asd = NULL;
-	sd->dev = NULL;
 }
 
 int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
-- 
2.11.0
