Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37540 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbbLKRRF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 12:17:05 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 04/10] [media] omap3isp: consistently use v4l2_dev var in complete notifier
Date: Fri, 11 Dec 2015 14:16:30 -0300
Message-Id: <1449854196-13296-5-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1449854196-13296-1-git-send-email-javier@osg.samsung.com>
References: <1449854196-13296-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The isp_subdev_notifier_complete() complete callback defines a struct
v4l2_device *v4l2_dev to avoid needing two level of indirections to
access the V4L2 subdevs but the var is not always used when possible
as when calling v4l2_device_register_subdev_nodes().

So change that to consistently use the defined v4l2_dev pointer var.

Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>


This patch addresses an issue pointed out by Sakari in patch [0]:

- Don't mix struct v4l2_device *v4l2_dev and &isp->v4l2_dev usage.

[0]: http://linuxtv.org/pipermail/media-workshop/2015-October/000928.html
END

---

 drivers/media/platform/omap3isp/isp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index fb17746e4209..8226eca83327 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2365,7 +2365,7 @@ static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
 		}
 	}
 
-	return v4l2_device_register_subdev_nodes(&isp->v4l2_dev);
+	return v4l2_device_register_subdev_nodes(v4l2_dev);
 }
 
 /*
-- 
2.4.3

