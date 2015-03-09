Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:50115 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976AbbCIVXg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 17:23:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 08/18] marvell-ccic: implement control events
Date: Mon,  9 Mar 2015 22:22:13 +0100
Message-Id: <1425936143-5658-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
References: <1425936143-5658-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Now that this driver uses v4l2_fh, it is trivial to add support for
control events. Again, this fixes a v4l2-compliance failure.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 8456017..4d50182 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -24,6 +24,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
 #include <media/ov7670.h>
 #include <media/videobuf2-vmalloc.h>
 #include <media/videobuf2-dma-contig.h>
@@ -1665,6 +1666,8 @@ static const struct v4l2_ioctl_ops mcam_v4l_ioctl_ops = {
 	.vidioc_s_parm		= mcam_vidioc_s_parm,
 	.vidioc_enum_framesizes = mcam_vidioc_enum_framesizes,
 	.vidioc_enum_frameintervals = mcam_vidioc_enum_frameintervals,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register	= mcam_vidioc_g_register,
 	.vidioc_s_register	= mcam_vidioc_s_register,
-- 
2.1.4

