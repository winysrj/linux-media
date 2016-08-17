Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:34671
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbcHQR0o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 13:26:44 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org
Subject: [PATCH v2] [media] vb2: Fix vb2_core_dqbuf() kernel-doc
Date: Wed, 17 Aug 2016 13:26:28 -0400
Message-Id: <1471454788-708-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The kernel-doc has the wrong function name and also the pindex
parameter is missing in the documentation.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

---

Changes in v2:
- Change pindex parameter kernel-doc. Suggested by Sakari Ailus.

 drivers/media/v4l2-core/videobuf2-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index ca8ffeb56d72..cd4f7f502a75 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1726,8 +1726,9 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
 }
 
 /**
- * vb2_dqbuf() - Dequeue a buffer to the userspace
+ * vb2_core_dqbuf() - Dequeue a buffer to the userspace
  * @q:		videobuf2 queue
+ * @pindex:	pointer to the buffer index. May be NULL
  * @pb:		buffer structure passed from userspace to vidioc_dqbuf handler
  *		in driver
  * @nonblocking: if true, this call will not sleep waiting for a buffer if no
-- 
2.5.5

