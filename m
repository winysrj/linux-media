Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4390 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3EZN1b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 May 2013 09:27:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 01/24] v4l2-ioctl: dbg_g/s_register: only match BRIDGE and SUBDEV types.
Date: Sun, 26 May 2013 15:26:56 +0200
Message-Id: <1369574839-6687-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369574839-6687-1-git-send-email-hverkuil@xs4all.nl>
References: <1369574839-6687-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Drop support for V4L2_CHIP_MATCH_I2C_DRIVER/ADDR and V4L2_CHIP_MATCH_AC97
types. The following patches will remove support for those in the drivers
as well.

This means that bridge drivers no longer have to check for the match.type
field in their g/s_register implementations. Only if they also implement
g_chip_info do they still have to check the match.addr field, otherwise the
core will check for that as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index f81bda1..60b8c25 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1807,7 +1807,8 @@ static int v4l_dbg_g_register(const struct v4l2_ioctl_ops *ops,
 				return v4l2_subdev_call(sd, core, g_register, p);
 		return -EINVAL;
 	}
-	if (ops->vidioc_g_register)
+	if (ops->vidioc_g_register && p->match.type == V4L2_CHIP_MATCH_BRIDGE &&
+	    (ops->vidioc_g_chip_info || p->match.addr == 0))
 		return ops->vidioc_g_register(file, fh, p);
 	return -EINVAL;
 #else
@@ -1834,7 +1835,8 @@ static int v4l_dbg_s_register(const struct v4l2_ioctl_ops *ops,
 				return v4l2_subdev_call(sd, core, s_register, p);
 		return -EINVAL;
 	}
-	if (ops->vidioc_s_register)
+	if (ops->vidioc_s_register && p->match.type == V4L2_CHIP_MATCH_BRIDGE &&
+	    (ops->vidioc_g_chip_info || p->match.addr == 0))
 		return ops->vidioc_s_register(file, fh, p);
 	return -EINVAL;
 #else
-- 
1.7.10.4

