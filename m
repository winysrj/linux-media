Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40292 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751327AbdJDVu4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 17:50:56 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v15 05/32] v4l: async: Correctly serialise async sub-device unregistration
Date: Thu,  5 Oct 2017 00:50:24 +0300
Message-Id: <20171004215051.13385-6-sakari.ailus@linux.intel.com>
In-Reply-To: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The check whether an async sub-device is bound to a notifier was performed
without list_lock held, making it possible for another process to
unbind the async sub-device before the sub-device unregistration function
proceeds to take the lock.

Fix this by first acquiring the lock and then proceeding with the check.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 4924481451ca..cde2cf2ab4b0 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -298,20 +298,16 @@ EXPORT_SYMBOL(v4l2_async_register_subdev);
 
 void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 {
-	struct v4l2_async_notifier *notifier = sd->notifier;
-
-	if (!sd->asd) {
-		if (!list_empty(&sd->async_list))
-			v4l2_async_cleanup(sd);
-		return;
-	}
-
 	mutex_lock(&list_lock);
 
-	list_add(&sd->asd->list, &notifier->waiting);
+	if (sd->asd) {
+		struct v4l2_async_notifier *notifier = sd->notifier;
 
-	if (notifier->unbind)
-		notifier->unbind(notifier, sd, sd->asd);
+		list_add(&sd->asd->list, &notifier->waiting);
+
+		if (notifier->unbind)
+			notifier->unbind(notifier, sd, sd->asd);
+	}
 
 	v4l2_async_cleanup(sd);
 
-- 
2.11.0
