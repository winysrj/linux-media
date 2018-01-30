Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:20983 "EHLO
        aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751934AbeA3PSg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 10:18:36 -0500
Received: from [10.47.79.81] ([10.47.79.81])
        (authenticated bits=0)
        by aer-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id w0UFIWCl012106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
        for <linux-media@vger.kernel.org>; Tue, 30 Jan 2018 15:18:33 GMT
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH] v4l2-compat-ioctl32.c: make ctrl_is_pointer work for subdevs
Message-ID: <e72bf5c1-833e-ad7a-f92f-05527eabea14@cisco.com>
Date: Tue, 30 Jan 2018 16:18:32 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the device is of type VFL_TYPE_SUBDEV then vdev->ioctl_ops
is NULL so the 'if (!ops->vidioc_query_ext_ctrl)' check would fail.
Add a test for !ops to the condition.

All sub-devices that have controls will use the control framework,
so they do not have an equivalent to ops->vidioc_query_ext_ctrl.
Returning false if ops is NULL is the correct thing to do here.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index bdb5c226d01c..5198c9eeb348 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -770,7 +770,7 @@ static inline bool ctrl_is_pointer(struct file *file, u32 id)
 		return ctrl && ctrl->is_ptr;
 	}

-	if (!ops->vidioc_query_ext_ctrl)
+	if (!ops || !ops->vidioc_query_ext_ctrl)
 		return false;

 	return !ops->vidioc_query_ext_ctrl(file, fh, &qec) &&
-- 
2.14.1
