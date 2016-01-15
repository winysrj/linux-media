Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:46621 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751213AbcAOD2o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2016 22:28:44 -0500
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>,
	Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [RESEND PATCH v2] media: v4l2-compat-ioctl32: fix missing length copy in put_v4l2_buffer32
Date: Fri, 15 Jan 2016 11:28:37 +0800
Message-ID: <1452828517-57392-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In v4l2-compliance utility, test QUERYBUF required correct length
value to go through each planar to check planar's length in
multi-planar buffer type

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
Remove "Change-Id: I98faddc5711c24f17beda52e6d18c657add251ac"
---

 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 327e83a..6c01920 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -516,6 +516,9 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
 		put_user(kp->reserved, &up->reserved))
 			return -EFAULT;
 
+	if (put_user(kp->length, &up->length))
+		return -EFAULT;
+
 	if (V4L2_TYPE_IS_MULTIPLANAR(kp->type)) {
 		num_planes = kp->length;
 		if (num_planes == 0)
-- 
1.7.9.5

