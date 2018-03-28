Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:61617 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753130AbeC1SNM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 14:13:12 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        stable@vger.kernel.org
Cc: Ricardo Ribalda <ricardo.ribalda@gmail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH for v3.18 16/18] media: media/v4l2-ctrls: volatiles should not generate CH_VALUE
Date: Wed, 28 Mar 2018 15:12:35 -0300
Message-Id: <1663cf48e2eb96405c5d6d874020aa9925ee217f.1522260310.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522260310.git.mchehab@s-opensource.com>
References: <cover.1522260310.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522260310.git.mchehab@s-opensource.com>
References: <cover.1522260310.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ricardo Ribalda <ricardo.ribalda@gmail.com>

Volatile controls should not generate CH_VALUE events.

Set has_changed to false to prevent this happening.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 3c4e22855652..2bdb2a3512a4 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1619,6 +1619,15 @@ static int cluster_changed(struct v4l2_ctrl *master)
 
 		if (ctrl == NULL)
 			continue;
+		/*
+		 * Set has_changed to false to avoid generating
+		 * the event V4L2_EVENT_CTRL_CH_VALUE
+		 */
+		if (ctrl->flags & V4L2_CTRL_FLAG_VOLATILE) {
+			ctrl->has_changed = false;
+			continue;
+		}
+
 		for (idx = 0; !ctrl_changed && idx < ctrl->elems; idx++)
 			ctrl_changed = !ctrl->type_ops->equal(ctrl, idx,
 				ctrl->p_cur, ctrl->p_new);
-- 
2.14.3
