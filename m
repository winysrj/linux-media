Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:49359 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbaCMUNB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 16:13:01 -0400
Message-ID: <a3c1810c827b9bc02af572caaa231c9a.squirrel@www.codeaurora.org>
Date: Thu, 13 Mar 2014 20:13:00 -0000
Subject: Query: Reqbufs returning without calling queue_setup.
From: vkalia@codeaurora.org
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

There is a check in __reqbufs in videobuf2-core.c in which if the count is
same then the function returns immediately. __reqbufs also calls
queue_setup callback into driver which updates the plane counts and sizes
of vb2 queue.  The count and size can be affected/changed by S_FMT and
G_FMT ioctl calls. This causes an issue with following call flow:

1. reqbufs.count = 8;
   ioctl(fd, VIDIOC_REQBUFS, &reqbufs);
2. ioctl(fd, VIDIOC_S_FMT, &format)  --> update format with differen
height/width etc which effect the sizeofimage
3. reqbufs.count = 8;
   ioctl(fd, VIDIOC_REQBUFS, &reqbufs); to update the vb2_queue num planes
and size of each plane. But this call never goes to the driver since
the count is same.

Shouldn't we query the driver for any change in plane count/size before
deciding to return from reqbufs? Following is the code. This is just a
temporary patch to point the issue.

diff --git a/drivers/media/v4l2-core/videobuf2-core.c
b/drivers/media/v4l2-core/videobuf2-core.c
index e42eb0d..57e18c2 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -590,13 +590,6 @@ static int __reqbufs(struct vb2_queue *q, struct
v4l2_requestbuffers *req)
                return -EBUSY;
        }

-       /*
-        * If the same number of buffers and memory access method is
requested
-        * then return immediately.
-        */
-       if (q->memory == req->memory && req->count == q->num_buffers)
-               return 0;
-
        if (req->count == 0 || q->num_buffers != 0 || q->memory !=
req->memory) {
                /*
                 * We already have buffers allocated, so first check if they

Thanks
Vinay

