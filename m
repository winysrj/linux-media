Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40268 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751326AbdJDVuz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 17:50:55 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v15 03/32] v4l: async: fix unbind error in v4l2_async_notifier_unregister()
Date: Thu,  5 Oct 2017 00:50:22 +0300
Message-Id: <20171004215051.13385-4-sakari.ailus@linux.intel.com>
In-Reply-To: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

The call to v4l2_async_cleanup() will set sd->asd to NULL so passing it to
notifier->unbind() have no effect and leaves the notifier confused. Call
the unbind() callback prior to cleaning up the subdevice to avoid this.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 21c748bf3a7b..ca281438a0ae 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -206,11 +206,11 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 	list_del(&notifier->list);
 
 	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
-		v4l2_async_cleanup(sd);
-
 		if (notifier->unbind)
 			notifier->unbind(notifier, sd, sd->asd);
 
+		v4l2_async_cleanup(sd);
+
 		list_move(&sd->async_list, &subdev_list);
 	}
 
@@ -268,11 +268,11 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 
 	list_add(&sd->asd->list, &notifier->waiting);
 
-	v4l2_async_cleanup(sd);
-
 	if (notifier->unbind)
 		notifier->unbind(notifier, sd, sd->asd);
 
+	v4l2_async_cleanup(sd);
+
 	mutex_unlock(&list_lock);
 }
 EXPORT_SYMBOL(v4l2_async_unregister_subdev);
-- 
2.11.0
