Return-path: <linux-media-owner@vger.kernel.org>
Received: from o1.7nn.fshared.sendgrid.net ([167.89.55.65]:50577 "EHLO
        o1.7nn.fshared.sendgrid.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750869AbeAPOxA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 09:53:00 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: sakari.ailus@iki.fi, niklas.soderlund@ragnatech.se,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        hans.verkuil@cisco.com, mchehab@kernel.org
Subject: [PATCH] v4l: async: Protect against double notifier regstrations
Date: Tue, 16 Jan 2018 14:52:58 +0000 (UTC)
Message-Id: <1516114358-5292-1-git-send-email-kieran.bingham@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

It can be easy to attempt to register the same notifier twice
in mis-handled error cases such as working with -EPROBE_DEFER.

This results in odd kernel crashes where the notifier_list becomes
corrupted due to adding the same entry twice.

Protect against this so that a developer has some sense of the pending
failure.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 2b08d03b251d..e8476f0755ca 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -374,6 +374,7 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
 	struct device *dev =
 		notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL;
 	struct v4l2_async_subdev *asd;
+	struct v4l2_async_notifier *n;
 	int ret;
 	int i;
 
@@ -385,6 +386,19 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
 
 	mutex_lock(&list_lock);
 
+	/*
+	 * Registering the same notifier can occur if a driver incorrectly
+	 * handles a -EPROBE_DEFER for example, and will break in a
+	 * confusing fashion with linked-list corruption.
+	 */
+	list_for_each_entry(n, &notifier_list, list) {
+		if (n == notifier) {
+			dev_err(dev, "Notifier has already been registered\n");
+			ret = -EEXIST;
+			goto err_unlock;
+		}
+	}
+
 	for (i = 0; i < notifier->num_subdevs; i++) {
 		asd = notifier->subdevs[i];
 
-- 
2.7.4
