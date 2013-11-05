Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43308 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab3KENDv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 08:03:51 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v3 21/29] [media] v4l2-async: Don't use dynamic static allocation
Date: Tue,  5 Nov 2013 08:01:34 -0200
Message-Id: <1383645702-30636-22-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
References: <1383645702-30636-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
	drivers/media/v4l2-core/v4l2-async.c:238:1: warning: 'v4l2_async_notifier_unregister' uses dynamic stack allocation [enabled by default]

Instead, let's enforce a limit for the buffer.

In this specific case, there's a hard limit imposed by V4L2_MAX_SUBDEVS,
with is currently 128. That means that the buffer size can be up to
128x8 = 1024 bytes (on a 64bits kernel), with is too big for stack.

Worse than that, someone could increase it and cause real troubles.
So, let's use dynamically allocated data, instead.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index c85d69da35bd..b56c9f300ecb 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -189,23 +189,41 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 	struct v4l2_subdev *sd, *tmp;
 	unsigned int notif_n_subdev = notifier->num_subdevs;
 	unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
-	struct device *dev[n_subdev];
+	struct device **dev;
 	int i = 0;
 
 	if (!notifier->v4l2_dev)
 		return;
 
+	dev = kmalloc(n_subdev * sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		dev_err(notifier->v4l2_dev->dev,
+			"Failed to allocate device cache!\n");
+	}
+
 	mutex_lock(&list_lock);
 
 	list_del(&notifier->list);
 
 	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
-		dev[i] = get_device(sd->dev);
+		struct device *d;
+
+		d = get_device(sd->dev);
 
 		v4l2_async_cleanup(sd);
 
 		/* If we handled USB devices, we'd have to lock the parent too */
-		device_release_driver(dev[i++]);
+		device_release_driver(d);
+
+
+		/*
+		 * Store device at the device cache, in order to call
+		 * put_device() on the final step
+		 */
+		if (dev)
+			dev[i++] = d;
+		else
+			put_device(d);
 
 		if (notifier->unbind)
 			notifier->unbind(notifier, sd, sd->asd);
@@ -213,6 +231,12 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 
 	mutex_unlock(&list_lock);
 
+	/*
+	 * Call device_attach() to reprobe devices
+	 *
+	 * NOTE: If dev allocation fails, i is 0, and the hole loop won't be
+	 * executed.
+	 */
 	while (i--) {
 		struct device *d = dev[i];
 
@@ -228,6 +252,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 		}
 		put_device(d);
 	}
+	kfree(dev);
 
 	notifier->v4l2_dev = NULL;
 
-- 
1.8.3.1

