Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:37058 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751896AbdJIKTf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:19:35 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH 02/24] media: v4l2-flash-led-class.h: add kernel-doc to two ancillary funcs
Date: Mon,  9 Oct 2017 07:19:08 -0300
Message-Id: <f7e55a81bf0e687d55ffead522f00096a3e001c5.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507544011.git.mchehab@s-opensource.com>
References: <cover.1507544011.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are two ancillary functions at v4l2-flash-led-class.h
that aren't documented.

Document them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/media/v4l2-flash-led-class.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/media/v4l2-flash-led-class.h b/include/media/v4l2-flash-led-class.h
index 5c1d50f78e12..39a5daa977aa 100644
--- a/include/media/v4l2-flash-led-class.h
+++ b/include/media/v4l2-flash-led-class.h
@@ -91,12 +91,24 @@ struct v4l2_flash {
 	struct v4l2_ctrl **ctrls;
 };
 
+/**
+ * v4l2_subdev_to_v4l2_flash - Returns a &v4l2_flash from the
+ * &struct v4l2_subdev embedded on it.
+ *
+ * @sd: pointer to &struct v4l2_subdev
+ */
 static inline struct v4l2_flash *v4l2_subdev_to_v4l2_flash(
 							struct v4l2_subdev *sd)
 {
 	return container_of(sd, struct v4l2_flash, sd);
 }
 
+/**
+ * v4l2_ctrl_to_v4l2_flash - Returns a &v4l2_flash from the
+ * &struct v4l2_ctrl embedded on it.
+ *
+ * @c: pointer to &struct v4l2_ctrl
+ */
 static inline struct v4l2_flash *v4l2_ctrl_to_v4l2_flash(struct v4l2_ctrl *c)
 {
 	return container_of(c->handler, struct v4l2_flash, hdl);
-- 
2.13.6
