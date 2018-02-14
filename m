Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:42500 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754716AbeBNMDY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 07:03:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: stable@vger.kernel.org
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH for v3.2 10/12] media: v4l2-compat-ioctl32.c: drop pr_info for unknown buffer type
Date: Wed, 14 Feb 2018 13:03:21 +0100
Message-Id: <20180214120323.28778-11-hverkuil@xs4all.nl>
In-Reply-To: <20180214120323.28778-1-hverkuil@xs4all.nl>
References: <20180214120323.28778-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

commit 169f24ca68bf0f247d111aef07af00dd3a02ae88 upstream.

There is nothing wrong with using an unknown buffer type. So
stop spamming the kernel log whenever this happens. The kernel
will just return -EINVAL to signal this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/video/v4l2-compat-ioctl32.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 6c3e15f7703e..44e8a8d15558 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -175,8 +175,6 @@ static int __get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
 			return -EFAULT;
 		return 0;
 	default:
-		printk(KERN_INFO "compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
-		       kp->type);
 		return -EINVAL;
 	}
 }
@@ -223,8 +221,6 @@ static int __put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
 			return -EFAULT;
 		return 0;
 	default:
-		printk(KERN_INFO "compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
-		       kp->type);
 		return -EINVAL;
 	}
 }
-- 
2.15.1
