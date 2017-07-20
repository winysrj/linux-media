Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:34547 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964800AbdGTWG0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 18:06:26 -0400
Received: by mail-yw0-f193.google.com with SMTP id a12so1591825ywh.1
        for <linux-media@vger.kernel.org>; Thu, 20 Jul 2017 15:06:26 -0700 (PDT)
From: Rob Herring <robh@kernel.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Javi Merino <javi.merino@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Frank Rowand <frowand.list@gmail.com>
Subject: [PATCH] Revert "[media] v4l: async: make v4l2 coexist with devicetree nodes in a dt overlay"
Date: Thu, 20 Jul 2017 17:06:22 -0500
Message-Id: <20170720220622.21470-1-robh@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit d2180e0cf77dc7a7049671d5d57dfa0a228f83c1.

The commit was flawed in that if the device_node pointers are different,
then in fact a different device is present and the device node could be
different in ways other than full_name.

As Frank Rowand explained:

"When an overlay (1) is removed, all uses and references to the nodes and
properties in that overlay are no longer valid.  Any driver that uses any
information from the overlay _must_ stop using any data from the overlay.
Any driver that is bound to a new node in the overlay _must_ unbind.  Any
driver that became bound to a pre-existing node that was modified by the
overlay (became bound after the overlay was applied) _must_ adjust itself
to account for any changes to that node when the overlay is removed.  One
way to do this is to unbind when notified that the overlay is about to
be removed, then to re-bind after the overlay is completely removed.

If an overlay (2) is subsequently applied, a node with the same
full_name as from overlay (1) may exist.  There is no guarantee
that overlay (1) and overlay (2) are the same overlay, even if
that node has the same full_name in both cases."

Also, there's not sufficient overlay support in mainline to actually
remove and re-apply an overlay to hit this condition as overlays can
only be applied from in kernel APIs.

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Javi Merino <javi.merino@kernel.org>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Frank Rowand <frowand.list@gmail.com>
Signed-off-by: Rob Herring <robh@kernel.org>
---
Mauro, please apply this for 4.13. It could be marked for stable, too, 
but it's not going to apply cleanly with the fwnode changes.

Rob

 drivers/media/v4l2-core/v4l2-async.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 851f128eba22..d741a8e0fdac 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -44,12 +44,7 @@ static bool match_devname(struct v4l2_subdev *sd,
 
 static bool match_fwnode(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
-	if (!is_of_node(sd->fwnode) || !is_of_node(asd->match.fwnode.fwnode))
-		return sd->fwnode == asd->match.fwnode.fwnode;
-
-	return !of_node_cmp(of_node_full_name(to_of_node(sd->fwnode)),
-			    of_node_full_name(
-				    to_of_node(asd->match.fwnode.fwnode)));
+	return sd->fwnode == asd->match.fwnode.fwnode;
 }
 
 static bool match_custom(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
-- 
2.11.0
