Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:34578 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934242AbcKWKYy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Nov 2016 05:24:54 -0500
From: Javi Merino <javi.merino@kernel.org>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Javi Merino <javi.merino@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH] v4l: async: make v4l2 coexists with devicetree nodes in a dt overlay
Date: Wed, 23 Nov 2016 10:09:57 +0000
Message-Id: <1479895797-7946-1-git-send-email-javi.merino@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In asd's configured with V4L2_ASYNC_MATCH_OF, if the v4l2 subdev is in
a devicetree overlay, its of_node pointer will be different each time
the overlay is applied.  We are not interested in matching the
pointer, what we want to match is that the path is the one we are
expecting.  Change to use of_node_cmp() so that we continue matching
after the overlay has been removed and reapplied.

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Javi Merino <javi.merino@kernel.org>
---
Hi,

I feel it is a bit of a hack, but I couldn't think of anything better.
I'm ccing devicetree@ and Pantelis because there may be a simpler
solution.

 drivers/media/v4l2-core/v4l2-async.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 5bada20..d33a17c 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -42,7 +42,8 @@ static bool match_devname(struct v4l2_subdev *sd,
 
 static bool match_of(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
-	return sd->of_node == asd->match.of.node;
+	return !of_node_cmp(of_node_full_name(sd->of_node),
+			    of_node_full_name(asd->match.of.node));
 }
 
 static bool match_custom(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
-- 
2.1.4

