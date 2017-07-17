Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:35440 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751314AbdGQRAZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 13:00:25 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v4 2/3] v4l: async: do not hold list_lock when reprobing devices
Date: Mon, 17 Jul 2017 18:59:16 +0200
Message-Id: <20170717165917.24851-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170717165917.24851-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170717165917.24851-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no good reason to hold the list_lock when reprobing the devices
and it prevents a clean implementation of subdevice notifiers. Move the
actual release of the devices outside of the loop which requires the
lock to be held.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/v4l2-core/v4l2-async.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 0acf288d7227ba97..8fc84f7962386ddd 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -206,7 +206,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 	unsigned int notif_n_subdev = notifier->num_subdevs;
 	unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
 	struct device **dev;
-	int i = 0;
+	int i, count = 0;
 
 	if (!notifier->v4l2_dev)
 		return;
@@ -222,37 +222,28 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 	list_del(&notifier->list);
 
 	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
-		struct device *d;
-
-		d = get_device(sd->dev);
+		if (dev)
+			dev[count] = get_device(sd->dev);
+		count++;
 
 		if (notifier->unbind)
 			notifier->unbind(notifier, sd, sd->asd);
 
 		v4l2_async_cleanup(sd);
+	}
 
-		/* If we handled USB devices, we'd have to lock the parent too */
-		device_release_driver(d);
+	mutex_unlock(&list_lock);
 
-		/*
-		 * Store device at the device cache, in order to call
-		 * put_device() on the final step
-		 */
+	for (i = 0; i < count; i++) {
+		/* If we handled USB devices, we'd have to lock the parent too */
 		if (dev)
-			dev[i++] = d;
-		else
-			put_device(d);
+			device_release_driver(dev[i]);
 	}
 
-	mutex_unlock(&list_lock);
-
 	/*
 	 * Call device_attach() to reprobe devices
-	 *
-	 * NOTE: If dev allocation fails, i is 0, and the whole loop won't be
-	 * executed.
 	 */
-	while (i--) {
+	for (i = 0; dev && i < count; i++) {
 		struct device *d = dev[i];
 
 		if (d && device_attach(d) < 0) {
-- 
2.13.1
