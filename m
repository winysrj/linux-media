Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:41289 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967541AbeBNLsc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 06:48:32 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: stable@vger.kernel.org
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH for v4.9 11/13] media: v4l2-compat-ioctl32.c: drop pr_info for unknown buffer type
Date: Wed, 14 Feb 2018 12:48:28 +0100
Message-Id: <20180214114830.27171-12-hverkuil@xs4all.nl>
In-Reply-To: <20180214114830.27171-1-hverkuil@xs4all.nl>
References: <20180214114830.27171-1-hverkuil@xs4all.nl>
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
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 3b5f3c8956f2..75653d756dd9 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -175,8 +175,6 @@ static int __get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
 		return copy_from_user(&kp->fmt.sdr, &up->fmt.sdr,
 				      sizeof(kp->fmt.sdr)) ? -EFAULT : 0;
 	default:
-		pr_info("compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
-			kp->type);
 		return -EINVAL;
 	}
 }
@@ -226,8 +224,6 @@ static int __put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
 		return copy_to_user(&up->fmt.sdr, &kp->fmt.sdr,
 				    sizeof(kp->fmt.sdr)) ? -EFAULT : 0;
 	default:
-		pr_info("compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
-			kp->type);
 		return -EINVAL;
 	}
 }
-- 
2.15.1
