Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:34089 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751188AbdHCDnH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Aug 2017 23:43:07 -0400
Received: by mail-pf0-f175.google.com with SMTP id o86so1182455pfj.1
        for <linux-media@vger.kernel.org>; Wed, 02 Aug 2017 20:43:07 -0700 (PDT)
From: Daniel Mentz <danielmentz@google.com>
To: linux-media@vger.kernel.org
Cc: Daniel Mentz <danielmentz@google.com>, stable@vger.kernel.org,
        "H . Peter Anvin" <hpa@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH] [media] v4l2-compat-ioctl32: Fix timespec conversion
Date: Wed,  2 Aug 2017 20:42:17 -0700
Message-Id: <20170803034217.23048-1-danielmentz@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Certain syscalls like recvmmsg support 64 bit timespec values for the
X32 ABI. The helper function compat_put_timespec converts a timespec
value to a 32 bit or 64 bit value depending on what ABI is used. The
v4l2 compat layer, however, is not designed to support 64 bit timespec
values and always uses 32 bit values. Hence, compat_put_timespec must
not be used.

Without this patch, user space will be provided with bad timestamp
values from the VIDIOC_DQEVENT ioctl. Also, fields of the struct
v4l2_event32 that come immediately after timestamp get overwritten,
namely the field named id.

Fixes: 81993e81a994 ("compat: Get rid of (get|put)_compat_time(val|spec)")
Cc: stable@vger.kernel.org
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Tiffany Lin <tiffany.lin@mediatek.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Daniel Mentz <danielmentz@google.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 6f52970f8b54..0c14e995667c 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -796,7 +796,8 @@ static int put_v4l2_event32(struct v4l2_event *kp, struct v4l2_event32 __user *u
 		copy_to_user(&up->u, &kp->u, sizeof(kp->u)) ||
 		put_user(kp->pending, &up->pending) ||
 		put_user(kp->sequence, &up->sequence) ||
-		compat_put_timespec(&kp->timestamp, &up->timestamp) ||
+		put_user(kp->timestamp.tv_sec, &up->timestamp.tv_sec) ||
+		put_user(kp->timestamp.tv_nsec, &up->timestamp.tv_nsec) ||
 		put_user(kp->id, &up->id) ||
 		copy_to_user(up->reserved, kp->reserved, 8 * sizeof(__u32)))
 			return -EFAULT;
-- 
2.14.0.rc1.383.gd1ce394fe2-goog
