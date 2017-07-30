Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:54275 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751674AbdG3WcV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Jul 2017 18:32:21 -0400
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
Subject: [PATCH 2/4] v4l: async: abort if memory allocation fails when unregistering notifiers
Date: Mon, 31 Jul 2017 00:31:56 +0200
Message-Id: <20170730223158.14405-3-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170730223158.14405-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170730223158.14405-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of trying to cope with the failed memory allocation and still
leaving the kernel in a semi-broken state (the subdevices will be
released but never re-probed) simply abort. The kernel have already
printed a warning about allocation failure but keep the error printout
to ease pinpointing the problem if it happens.

By doing this we can increase the readability of this complex function
which puts it in a better state to separate the v4l2 housekeeping tasks
from the re-probing of devices. It also serves to prepare for adding
subnotifers.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/v4l2-core/v4l2-async.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 0acf288d7227ba97..67852f0f2d3000c9 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -215,6 +215,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 	if (!dev) {
 		dev_err(notifier->v4l2_dev->dev,
 			"Failed to allocate device cache!\n");
+		return;
 	}
 
 	mutex_lock(&list_lock);
@@ -234,23 +235,13 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 		/* If we handled USB devices, we'd have to lock the parent too */
 		device_release_driver(d);
 
-		/*
-		 * Store device at the device cache, in order to call
-		 * put_device() on the final step
-		 */
-		if (dev)
-			dev[i++] = d;
-		else
-			put_device(d);
+		dev[i++] = d;
 	}
 
 	mutex_unlock(&list_lock);
 
 	/*
 	 * Call device_attach() to reprobe devices
-	 *
-	 * NOTE: If dev allocation fails, i is 0, and the whole loop won't be
-	 * executed.
 	 */
 	while (i--) {
 		struct device *d = dev[i];
-- 
2.13.3
