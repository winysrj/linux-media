Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35058 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756716AbdCWVJk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Mar 2017 17:09:40 -0400
Received: by mail-lf0-f66.google.com with SMTP id v2so18176915lfi.2
        for <linux-media@vger.kernel.org>; Thu, 23 Mar 2017 14:09:39 -0700 (PDT)
From: Anton Leontiev <scileont@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] [media] vb2: Fix queue_setup() callback description
Date: Fri, 24 Mar 2017 00:09:35 +0300
Message-Id: <20170323210935.12742-1-scileont@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Correct meaning of the last sensence by swapping it with previous.
Fix two small typos.

Signed-off-by: Anton Leontiev <scileont@gmail.com>
---
 include/media/videobuf2-core.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index ac5898a55fd9..cb97c224be73 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -305,16 +305,16 @@ struct vb2_buffer {
  *			buffer in \*num_planes, the size of each plane should be
  *			set in the sizes\[\] array and optional per-plane
  *			allocator specific device in the alloc_devs\[\] array.
- *			When called from VIDIOC_REQBUFS,() \*num_planes == 0,
+ *			When called from VIDIOC_REQBUFS(), \*num_planes == 0,
  *			the driver has to use the currently configured format to
  *			determine the plane sizes and \*num_buffers is the total
  *			number of buffers that are being allocated. When called
- *			from VIDIOC_CREATE_BUFS,() \*num_planes != 0 and it
+ *			from VIDIOC_CREATE_BUFS(), \*num_planes != 0 and it
  *			describes the requested number of planes and sizes\[\]
- *			contains the requested plane sizes. If either
- *			\*num_planes or the requested sizes are invalid callback
- *			must return %-EINVAL. In this case \*num_buffers are
- *			being allocated additionally to q->num_buffers.
+ *			contains the requested plane sizes. In this case
+ *			\*num_buffers are being allocated additionally to
+ *			q->num_buffers. If either \*num_planes or the requested
+ *			sizes are invalid callback must return %-EINVAL.
  * @wait_prepare:	release any locks taken while calling vb2 functions;
  *			it is called before an ioctl needs to wait for a new
  *			buffer to arrive; required to avoid a deadlock in
-- 
2.12.0
