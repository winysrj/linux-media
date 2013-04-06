Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2870 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932835Ab3DFL0F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Apr 2013 07:26:05 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 3/7] v4l2-ioctl: fill in name before calling vidioc_g_chip_name
Date: Sat,  6 Apr 2013 13:25:48 +0200
Message-Id: <1365247552-26795-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365247552-26795-1-git-send-email-hverkuil@xs4all.nl>
References: <1365247552-26795-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

That way drivers do not need to fill in the name themselves for bridge address 0.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 7a96162..c48d0ac 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1869,16 +1869,16 @@ static int v4l_dbg_g_chip_name(const struct v4l2_ioctl_ops *ops,
 			p->flags |= V4L2_CHIP_FL_WRITABLE;
 		if (ops->vidioc_g_register)
 			p->flags |= V4L2_CHIP_FL_READABLE;
-		if (ops->vidioc_g_chip_name)
-			return ops->vidioc_g_chip_name(file, fh, arg);
-		if (p->match.addr)
-			return -EINVAL;
 		if (vfd->v4l2_dev)
 			strlcpy(p->name, vfd->v4l2_dev->name, sizeof(p->name));
 		else if (vfd->parent)
 			strlcpy(p->name, vfd->parent->driver->name, sizeof(p->name));
 		else
 			strlcpy(p->name, "bridge", sizeof(p->name));
+		if (ops->vidioc_g_chip_name)
+			return ops->vidioc_g_chip_name(file, fh, arg);
+		if (p->match.addr)
+			return -EINVAL;
 		return 0;
 
 	case V4L2_CHIP_MATCH_SUBDEV:
-- 
1.7.10.4

