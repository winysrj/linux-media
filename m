Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:54296 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751688AbdG3WcW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Jul 2017 18:32:22 -0400
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
Subject: [PATCH 4/4] v4l: async: add comment about re-probing to v4l2_async_notifier_unregister()
Date: Mon, 31 Jul 2017 00:31:58 +0200
Message-Id: <20170730223158.14405-5-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170730223158.14405-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170730223158.14405-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The re-probing of subdevices when unregistering a notifier is tricky to
understand, and implemented somewhat as a hack. Add a comment trying to
explain why the re-probing is needed in the first place and why existing
helper functions can't be used in this situation.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/v4l2-core/v4l2-async.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index d91ff0a33fd3eaff..a3c5a1f6d4d2ab03 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -234,6 +234,23 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 
 	mutex_unlock(&list_lock);
 
+	/*
+	 * Try to re-probe the subdevices which where part of the notifier.
+	 * This is done so subdevices which where part of the notifier will
+	 * be re-probed to a pristine state and put back on the global
+	 * list of subdevices so they can once more be found and associated
+	 * with a new notifier.
+	 *
+	 * One might be tempted to use device_reprobe() to handle the re-
+	 * probing. Unfortunately this is not possible since some video
+	 * device drivers call v4l2_async_notifier_unregister() from
+	 * there remove function leading to a dead lock situation on
+	 * device_lock(dev->parent). This lock is held when video device
+	 * drivers remove function is called and device_reprobe() also
+	 * tries to take the same lock, so using it here could lead to a
+	 * dead lock situation.
+	 */
+
 	for (i = 0; i < count; i++) {
 		/* If we handled USB devices, we'd have to lock the parent too */
 		device_release_driver(dev[i]);
-- 
2.13.3
