Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:55516 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934046AbdADNsX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Jan 2017 08:48:23 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: linux-media@vger.kernel.org
Cc: Baruch Siach <baruch@tkos.co.il>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH] [media] v4l2-subdev.h: fix v4l2_subdev_pad_config documentation
Date: Wed,  4 Jan 2017 15:47:17 +0200
Message-Id: <f9ba2532c3b3e9c7b437b2306098243be91f4ce1.1483537637.git.baruch@tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The fields of v4l2_subdev_pad_config are not pointers.

Fixes: 21c29de1d09 ("[media] v4l2-subdev.h: Improve documentation")
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 include/media/v4l2-subdev.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index cf778c5dca18..0ab1c5df6fac 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -592,9 +592,9 @@ struct v4l2_subdev_ir_ops {
 /**
  * struct v4l2_subdev_pad_config - Used for storing subdev pad information.
  *
- * @try_fmt: pointer to &struct v4l2_mbus_framefmt
- * @try_crop: pointer to &struct v4l2_rect to be used for crop
- * @try_compose: pointer to &struct v4l2_rect to be used for compose
+ * @try_fmt: &struct v4l2_mbus_framefmt
+ * @try_crop: &struct v4l2_rect to be used for crop
+ * @try_compose: &struct v4l2_rect to be used for compose
  *
  * This structure only needs to be passed to the pad op if the 'which' field
  * of the main argument is set to %V4L2_SUBDEV_FORMAT_TRY. For
-- 
2.11.0

