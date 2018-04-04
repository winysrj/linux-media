Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:59288 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751117AbeDDLVK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Apr 2018 07:21:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Tomasz Figa <tfiga@chromium.org>
Subject: [PATCH] media: v4l2-fwnode: simplify v4l2_fwnode_reference_parse_int_props()
Date: Wed,  4 Apr 2018 07:21:04 -0400
Message-Id: <c800e86d216ffe15256497f28b7b54b9696e82ee.1522840850.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic at v4l2_fwnode_reference_parse_int_props() is somewhat
complex and violates Linux coding style, as it does multiple
statements on a single line. That makes static analyzers to
be confused, as warned by smatch:

	drivers/media/v4l2-core/v4l2-fwnode.c:832 v4l2_fwnode_reference_parse_int_props() warn: passing zero to 'PTR_ERR'

Simplify the logic, in order to make clearer about what happens
when v4l2_fwnode_reference_get_int_prop() returns an error.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index d630640642ee..3f77aa318035 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -819,17 +819,25 @@ static int v4l2_fwnode_reference_parse_int_props(
 	unsigned int index;
 	int ret;
 
-	for (index = 0; !IS_ERR((fwnode = v4l2_fwnode_reference_get_int_prop(
-					 dev_fwnode(dev), prop, index, props,
-					 nprops))); index++)
+	index = 0;
+	do {
+		fwnode = v4l2_fwnode_reference_get_int_prop(dev_fwnode(dev),
+							    prop, index,
+							    props, nprops);
+		if (IS_ERR(fwnode)) {
+			/*
+			 * Note that right now both -ENODATA and -ENOENT may
+			 * signal out-of-bounds access. Return the error in
+			 * cases other than that.
+			 */
+			if (PTR_ERR(fwnode) != -ENOENT &&
+			    PTR_ERR(fwnode) != -ENODATA)
+				return PTR_ERR(fwnode);
+			break;
+		}
 		fwnode_handle_put(fwnode);
-
-	/*
-	 * Note that right now both -ENODATA and -ENOENT may signal
-	 * out-of-bounds access. Return the error in cases other than that.
-	 */
-	if (PTR_ERR(fwnode) != -ENOENT && PTR_ERR(fwnode) != -ENODATA)
-		return PTR_ERR(fwnode);
+		index++;
+	} while (1);
 
 	ret = v4l2_async_notifier_realloc(notifier,
 					  notifier->num_subdevs + index);
-- 
2.14.3
