Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:57326 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932543AbdJaSXE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Oct 2017 14:23:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH] media: v4l2-fwnode: use the cached value instead of getting again
Date: Tue, 31 Oct 2017 14:22:59 -0400
Message-Id: <2e926f1070f783f603806068c282399cf832bf2b.1509474169.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a get/put operation in order to get firmware is_available
data there at the __v4l2_async_notifier_parse_fwnode_endpoints()
function. However, instead of using it, the code just reads again
without the lock. That's probably a mistake, as a similar code on
another function use the cached value.

This solves this smatch warning:

drivers/media/v4l2-core/v4l2-fwnode.c:453:8: warning: variable 'is_available' set but not used [-Wunused-but-set-variable]
   bool is_available;
        ^~~~~~~~~~~~

Fixes: 9ca465312132 ("media: v4l: fwnode: Support generic parsing of graph endpoints in a device")
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 3b9c6afb49a3..681b192420d9 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -455,8 +455,7 @@ static int __v4l2_async_notifier_parse_fwnode_endpoints(
 		dev_fwnode = fwnode_graph_get_port_parent(fwnode);
 		is_available = fwnode_device_is_available(dev_fwnode);
 		fwnode_handle_put(dev_fwnode);
-
-		if (!fwnode_device_is_available(dev_fwnode))
+		if (!is_available)
 			continue;
 
 		if (WARN_ON(notifier->num_subdevs >= notifier->max_subdevs)) {
-- 
2.13.6
