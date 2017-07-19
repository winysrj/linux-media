Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54580 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932078AbdGSWdb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 18:33:31 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [RFC 1/1] v4l2-subdev: Add a function to set sub-device notifier callbacks
Date: Thu, 20 Jul 2017 01:33:29 +0300
Message-Id: <20170719223329.10112-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20170718211922.GI28538@bigcity.dyn.berto.se>
References: <20170718211922.GI28538@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sub-device's sub-notifier is hidded in the sub-device and not meant to
be accessed directly by drivers. Still the driver may wish to set callbacks
to the notifier. Add a function to do that:
v4l2_subdev_notifier_set_callbacks().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Well, this appears to be quite straightforward. The code is entirely untested
but trivial at the same time. 

 drivers/media/v4l2-core/v4l2-subdev.c | 20 ++++++++++++++++++++
 include/media/v4l2-subdev.h           |  6 ++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index a6976d4a52ac..8629224bfdba 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -666,3 +666,23 @@ int v4l2_subdev_fwnode_reference_parse_sensor_common(struct v4l2_subdev *sd)
 	return v4l2_fwnode_reference_parse_sensor_common(sd->dev, subnotifier);
 }
 EXPORT_SYMBOL_GPL(v4l2_subdev_fwnode_reference_parse_sensor_common);
+
+int v4l2_subdev_notifier_set_callbacks(
+	struct v4l2_subdev *sd,
+	int (*bound)(struct v4l2_async_notifier *notifier,
+		     struct v4l2_subdev *subdev,
+		     struct v4l2_async_subdev *asd),
+	int (*complete)(struct v4l2_async_notifier *notifier))
+{
+	struct v4l2_async_notifier *subnotifier =
+		v4l2_subdev_get_subnotifier(sd);
+
+	if (!subnotifier)
+		return -ENOMEM;
+
+	subnotifier->bound = bound;
+	subnotifier->complete = complete;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_subdev_notifier_set_callbacks);
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index e309a2e2030b..ee85b64ad4f4 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -1012,4 +1012,10 @@ int v4l2_subdev_fwnode_endpoints_parse(
 
 int v4l2_subdev_fwnode_reference_parse_sensor_common(struct v4l2_subdev *sd);
 
+int v4l2_subdev_notifier_set_callbacks(
+	struct v4l2_subdev *sd,
+	int (*bound)(struct v4l2_async_notifier *notifier,
+		     struct v4l2_subdev *subdev,
+		     struct v4l2_async_subdev *asd),
+	int (*complete)(struct v4l2_async_notifier *notifier));
 #endif
-- 
2.11.0
