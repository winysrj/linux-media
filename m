Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:54012 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751361AbdKDC0r (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Nov 2017 22:26:47 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] media: v4l: async: fix unregister for implicitly registered sub-device notifiers
Date: Sat,  4 Nov 2017 03:25:56 +0100
Message-Id: <20171104022556.23153-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The commit aef69d54755d45ed ("media: v4l: fwnode: Add a convenience
function for registering sensors") adds the function
v4l2_async_notifier_parse_fwnode_sensor_common() to parse and register a
subdevice and a subdev-notifier by parsing firmware information. This
new subdev-notifier is stored in the new field 'subdev_notifier' in
struct v4l2_subdev.

In v4l2_async_unregister_subdev() this field is used to unregister and
cleanup the subdev-notifier. A check for if the subdev-notifier is
initialized or not was forgotten leading to a NULL pointer dereference
in v4l2_async_notifier_cleanup() if a subdevice do not use the optional
convince function to initialize the field.

Fix this by checking in v4l2_async_notifier_cleanup() that it is
provided whit a notifier making it safe to call with a NULL parameter.

Fixes: aef69d54755d45ed ("media: v4l: fwnode: Add a convenience function for registering sensors")
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/v4l2-core/v4l2-async.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 49f7eccc76dbbc3b..8684e002e72f280d 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -502,7 +502,7 @@ void v4l2_async_notifier_cleanup(struct v4l2_async_notifier *notifier)
 {
 	unsigned int i;
 
-	if (!notifier->max_subdevs)
+	if (!notifier || !notifier->max_subdevs)
 		return;
 
 	for (i = 0; i < notifier->num_subdevs; i++) {
-- 
2.14.2
