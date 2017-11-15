Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:39268 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932621AbdKOPob (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 10:44:31 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] v4l: async: use the v4l2_dev from the root notifier when matching sub-devices
Date: Wed, 15 Nov 2017 16:43:58 +0100
Message-Id: <20171115154358.32734-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When matching and registering a sub-device from a sub-notifier use the
v4l2_device from the root parent notifier. Using the v4l2_dev stored in
the sub-notifier itself is incorrect as it might not be set.

This can be demonstrated by unbinding and rebinding the adv748x driver
and observing that it fails to probe due to the check !v4l2_dev in
v4l2_device_register_subdev().

    # echo 4-0070 > /sys/bus/i2c/drivers/adv748x/unbind
    # echo 4-0070 > /sys/bus/i2c/drivers/adv748x/bind
    adv748x 4-0070: chip found @ 0xe0 revision 2143
    adv748x 4-0070: Failed to probe TXA
    adv748x: probe of 4-0070 failed with error -22

Looking at the commit which adds sub-notifiers to V4L2 it looks like
this is the intended behavior of the original commit. Whit this fix the
adv748x can be re-bound and still function properly.

Fixes: 2cab00bb076b9f0e ("media: v4l: async: Allow binding notifiers to sub-devices")
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/v4l2-core/v4l2-async.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index a7c3464976f24361..e5acfab470a5ee6b 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -558,8 +558,7 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 		if (!asd)
 			continue;
 
-		ret = v4l2_async_match_notify(notifier, notifier->v4l2_dev, sd,
-					      asd);
+		ret = v4l2_async_match_notify(notifier, v4l2_dev, sd, asd);
 		if (ret)
 			goto err_unbind;
 
-- 
2.15.0
