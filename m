Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:63824 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751292AbcLZUn5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Dec 2016 15:43:57 -0500
Subject: [PATCH 1/8] [media] v4l2-async: Use kmalloc_array() in
 v4l2_async_notifier_unregister()
To: linux-media@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jan Kara <jack@suse.cz>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <9268b60d-08ba-c64e-1848-f84679d64f80@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <442a32b4-6952-3b2a-44a3-46254c5976f2@users.sourceforge.net>
Date: Mon, 26 Dec 2016 21:43:23 +0100
MIME-Version: 1.0
In-Reply-To: <9268b60d-08ba-c64e-1848-f84679d64f80@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Mon, 26 Dec 2016 18:14:33 +0100

A multiplication for the size determination of a memory allocation
indicated that an array data structure should be processed.
Thus use the corresponding function "kmalloc_array".

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/v4l2-core/v4l2-async.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 5bada202b2d3..277183f2d514 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -202,7 +202,7 @@ void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
 	if (!notifier->v4l2_dev)
 		return;
 
-	dev = kmalloc(n_subdev * sizeof(*dev), GFP_KERNEL);
+	dev = kmalloc_array(n_subdev, sizeof(*dev), GFP_KERNEL);
 	if (!dev) {
 		dev_err(notifier->v4l2_dev->dev,
 			"Failed to allocate device cache!\n");
-- 
2.11.0

