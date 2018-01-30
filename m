Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:45212 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751804AbeA3K1J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 05:27:09 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, stable@vger.kernel.org
Subject: [PATCHv2 11/13] v4l2-compat-ioctl32.c: drop pr_info for unknown buffer type
Date: Tue, 30 Jan 2018 11:26:59 +0100
Message-Id: <20180130102701.13664-12-hverkuil@xs4all.nl>
In-Reply-To: <20180130102701.13664-1-hverkuil@xs4all.nl>
References: <20180130102701.13664-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

There is nothing wrong with using an unknown buffer type. So
stop spamming the kernel log whenever this happens. The kernel
will just return -EINVAL to signal this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: <stable@vger.kernel.org>      # for v4.15 and up
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 0df941ca4d90..7ee3777cbe9c 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -179,8 +179,6 @@ static int __get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
 		return copy_from_user(&kp->fmt.meta, &up->fmt.meta,
 				      sizeof(kp->fmt.meta)) ? -EFAULT : 0;
 	default:
-		pr_info("compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
-			kp->type);
 		return -EINVAL;
 	}
 }
@@ -233,8 +231,6 @@ static int __put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
 		return copy_to_user(&up->fmt.meta, &kp->fmt.meta,
 				    sizeof(kp->fmt.meta)) ? -EFAULT : 0;
 	default:
-		pr_info("compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
-			kp->type);
 		return -EINVAL;
 	}
 }
-- 
2.15.1
