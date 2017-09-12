Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33506 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751505AbdILImq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 04:42:46 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v11 13/24] v4l: async: Allow async notifier register call succeed with no subdevs
Date: Tue, 12 Sep 2017 11:42:25 +0300
Message-Id: <20170912084236.1154-14-sakari.ailus@linux.intel.com>
In-Reply-To: <20170912084236.1154-1-sakari.ailus@linux.intel.com>
References: <20170912084236.1154-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The information on how many async sub-devices would be bindable to a
notifier is typically dependent on information from platform firmware and
it's not driver's business to be aware of that.

Many V4L2 main drivers are perfectly usable (and useful) without async
sub-devices and so if there aren't any around, just proceed call the
notifier's complete callback immediately without registering the notifier
itself.

If a driver needs to check whether there are async sub-devices available,
it can be done by inspecting the notifier's num_subdevs field which tells
the number of async sub-devices.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 7b396ff4302b..4525b03d59c1 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -170,14 +170,16 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 	struct v4l2_async_subdev *asd;
 	int i;
 
-	if (!v4l2_dev || !notifier->num_subdevs ||
-	    notifier->num_subdevs > V4L2_MAX_SUBDEVS)
+	if (!v4l2_dev || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
 		return -EINVAL;
 
 	notifier->v4l2_dev = v4l2_dev;
 	INIT_LIST_HEAD(&notifier->waiting);
 	INIT_LIST_HEAD(&notifier->done);
 
+	if (!notifier->num_subdevs)
+		return v4l2_async_notifier_call_complete(notifier);
+
 	for (i = 0; i < notifier->num_subdevs; i++) {
 		asd = notifier->subdevs[i];
 
-- 
2.11.0
