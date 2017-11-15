Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:48640 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757227AbdKOLz3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 06:55:29 -0500
Received: by mail-pg0-f65.google.com with SMTP id s11so12392570pgc.5
        for <linux-media@vger.kernel.org>; Wed, 15 Nov 2017 03:55:29 -0800 (PST)
From: Tomasz Figa <tfiga@chromium.org>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sebastian Reichel <sre@kernel.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Tomasz Figa <tfiga@chromium.org>
Subject: [PATCH] media: v4l2-fwnode: Check subdev count after checking port
Date: Wed, 15 Nov 2017 20:55:22 +0900
Message-Id: <20171115115522.30211-1-tfiga@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Current implementation of __v4l2_async_notifier_parse_fwnode_endpoints()
checks first whether subdev_count >= subdev_max and only then whether
the port being parsed matches the given port index. This triggers an
error in otherwise valid cases of skipping ports that do not match.

Fix this by moving the check below the port index check.

Fixes: 9ca465312132 ("media: v4l: fwnode: Support generic parsing of graph endpoints in a device")
Signed-off-by: Tomasz Figa <tfiga@chromium.org>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 681b192420d9..fb72c7ac04d4 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -458,11 +458,6 @@ static int __v4l2_async_notifier_parse_fwnode_endpoints(
 		if (!is_available)
 			continue;
 
-		if (WARN_ON(notifier->num_subdevs >= notifier->max_subdevs)) {
-			ret = -EINVAL;
-			break;
-		}
-
 		if (has_port) {
 			struct fwnode_endpoint ep;
 
@@ -474,6 +469,11 @@ static int __v4l2_async_notifier_parse_fwnode_endpoints(
 				continue;
 		}
 
+		if (WARN_ON(notifier->num_subdevs >= notifier->max_subdevs)) {
+			ret = -EINVAL;
+			break;
+		}
+
 		ret = v4l2_async_notifier_fwnode_parse_endpoint(
 			dev, notifier, fwnode, asd_struct_size, parse_endpoint);
 		if (ret < 0)
-- 
2.15.0.448.gf294e3d99a-goog
