Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:29548 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754627AbcJEIeB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Oct 2016 04:34:01 -0400
Received: from nauris.fi.intel.com (nauris.localdomain [192.168.240.2])
        by paasikivi.fi.intel.com (Postfix) with ESMTP id E603E2021E
        for <linux-media@vger.kernel.org>; Wed,  5 Oct 2016 11:33:29 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [RFC 6/6] v4l2: async: Provide interoperability between OF and fwnode matching
Date: Wed,  5 Oct 2016 11:32:11 +0300
Message-Id: <1475656331-22497-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1475652109-22164-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1475652109-22164-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Of and fwnode support are separated in V4L2 and individual drivers may
implement one of them. Sub-devices do not match with a notifier
expecting sub-devices with fwnodes, nor the other way around.

Fix this by checking for sub-device's of_node field in fwnode match and
fwnode field in OF match.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 0dd5e85..984e6fa 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -42,12 +42,16 @@ static bool match_devname(struct v4l2_subdev *sd,
 
 static bool match_of(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
-	return sd->of_node == asd->match.of.node;
+	return sd->of_node == asd->match.of.node ||
+		(sd->fwnode && is_of_node(sd->fwnode) &&
+		 sd->fwnode == of_fwnode_handle(asd->match.of.node));
 }
 
 static bool match_fwnode(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
-	return sd->fwnode == asd->match.fwnode.fwn;
+	return sd->fwnode == asd->match.fwnode.fwn ||
+		(sd->of_node &&
+		 of_fwnode_handle(sd->of_node) == asd->match.fwnode.fwn);
 }
 
 static bool match_custom(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
-- 
2.7.4

