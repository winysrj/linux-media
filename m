Return-path: <linux-media-owner@vger.kernel.org>
Received: from o1682455182.outbound-mail.sendgrid.net ([168.245.5.182]:50253
        "EHLO o1682455182.outbound-mail.sendgrid.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750750AbeAPXr5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 18:47:57 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: linux-media@vger.kernel.org, sakari.ailus@iki.fi
Cc: niklas.soderlund@ragnatech.se,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        hans.verkuil@cisco.com, mchehab@kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2] v4l: async: Protect against double notifier registrations
Date: Tue, 16 Jan 2018 23:47:56 +0000 (UTC)
Message-Id: <1516146473-18234-1-git-send-email-kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

It can be easy to attempt to register the same notifier twice
in mis-handled error cases such as working with -EPROBE_DEFER.

This results in odd kernel crashes where the notifier_list becomes
corrupted due to adding the same entry twice.

Protect against this so that a developer has some sense of the pending
failure, and use a WARN_ON to identify the fault.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

---
v2:
 - Reduce verbosity
 - use WARN_ON()
 - Move notifier list initialisation after registration check

 drivers/media/v4l2-core/v4l2-async.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 2b08d03b251d..17a779440ae3 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -374,17 +374,26 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
 	struct device *dev =
 		notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL;
 	struct v4l2_async_subdev *asd;
+	struct v4l2_async_notifier *n;
 	int ret;
 	int i;
 
 	if (notifier->num_subdevs > V4L2_MAX_SUBDEVS)
 		return -EINVAL;
 
+	mutex_lock(&list_lock);
+
+	/* Avoid re-registering a notifier. */
+	list_for_each_entry(n, &notifier_list, list) {
+		if (WARN_ON(n == notifier)) {
+			ret = -EEXIST;
+			goto err_unlock;
+		}
+	}
+
 	INIT_LIST_HEAD(&notifier->waiting);
 	INIT_LIST_HEAD(&notifier->done);
 
-	mutex_lock(&list_lock);
-
 	for (i = 0; i < notifier->num_subdevs; i++) {
 		asd = notifier->subdevs[i];
 
-- 
2.7.4
