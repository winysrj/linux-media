Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45572 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751529AbdIOOSO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 10:18:14 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v13 12/25] v4l: async: Register sub-devices before calling bound callback
Date: Fri, 15 Sep 2017 17:17:11 +0300
Message-Id: <20170915141724.23124-13-sakari.ailus@linux.intel.com>
In-Reply-To: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Register the sub-device before calling the notifier's bound callback.
Doing this the other way around is problematic as the struct v4l2_device
has not assigned for the sub-device yet and may be required by the bound
callback.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index c35d04b9122f..9895b610e2a0 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -130,13 +130,13 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
 {
 	int ret;
 
-	ret = v4l2_async_notifier_call_bound(notifier, sd, asd);
+	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
 	if (ret < 0)
 		return ret;
 
-	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
+	ret = v4l2_async_notifier_call_bound(notifier, sd, asd);
 	if (ret < 0) {
-		v4l2_async_notifier_call_unbind(notifier, sd, asd);
+		v4l2_device_unregister_subdev(sd);
 		return ret;
 	}
 
-- 
2.11.0
