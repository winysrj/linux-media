Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1449 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab0BNNUl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Feb 2010 08:20:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: videobuf and streaming I/O questions
Date: Sun, 14 Feb 2010 14:22:48 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002141422.48362.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I've been investigating some problems with my qv4l2 utility and I encountered
some inconsistencies in the streaming I/O documentation and the videobuf
implementation.

I would like to know which is correct.

1) The VIDIOC_QBUF documentation should specify that the application has
to fill in the v4l2_buffer 'flags' field. The fact that this is not explicitly
stated tripped me up in qv4l2.

2) The VIDIOC_REQBUFS documentation states that it should be possible to use
a count of 0, in which case it should do an implicit STREAMOFF. This is
currently not implemented. I have included a patch for this below and if there
are no issues with it, then I'll make a pull request for this.

3) The VIDIOC_REQBUFS documentation states that the count field is only used
by MEMORY_MMAP, not by MEMORY_USERPTR. This seems to be a false statement.
videobuf certainly uses the count field.

4) The same is true for QBUF and DQBUF and the index field of struct v4l2_buffer:
the documentation states that it is only used for MMAP, but as far as I can tell
that is not true and it should be used for USERPTR as well.

5) Section 3.2 states that one should use VIDIOC_REQBUFS to determine if the
memory mapping flavor is supported by the driver. At least in the case of the
saa7146/mxb driver (which uses videobuf) this does not work. Even though it only
supports mmap, videobuf happily accepts userptr mode as well. Who is supposed
to test this? The driver before it calls videobuf_reqbufs?

6) V4L2_MEMORY_OVERLAY seems to be supported in videobuf, yet there is no driver
that supports it as far as I can tell and the documentation does not explain
what it is supposed to do. What is the status of this?

When I know the correct answers to this I will fix these issues. The qv4l2 tool
is written based on the documentation instead of copy-and-paste, so this was a
good test case to discover these inconsistencies.

Regards,

	Hans

-----------------------------------
[PATCH] V4L-DVB: Add support for count == 0 to videobuf's VIDIOC_REQBUFS implementation.

The spec says that VIDIOC_REQBUFS should support a count of 0, in which
case it should act like an implicit VIDIOC_STREAMOFF. The core videobuf
implementation did not support this, so we add this.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/videobuf-core.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index bb0a1c8..10cb0ec 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -40,6 +40,8 @@ MODULE_LICENSE("GPL");
 	if (debug >= level) 					\
 	printk(KERN_DEBUG "vbuf: " fmt , ## arg); } while (0)
 
+static int __videobuf_streamoff(struct videobuf_queue *q);
+
 /* --------------------------------------------------------------------- */
 
 #define CALL(q, f, arg...)						\
@@ -395,11 +397,6 @@ int videobuf_reqbufs(struct videobuf_queue *q,
 	unsigned int size, count;
 	int retval;
 
-	if (req->count < 1) {
-		dprintk(1, "reqbufs: count invalid (%d)\n", req->count);
-		return -EINVAL;
-	}
-
 	if (req->memory != V4L2_MEMORY_MMAP     &&
 	    req->memory != V4L2_MEMORY_USERPTR  &&
 	    req->memory != V4L2_MEMORY_OVERLAY) {
@@ -414,6 +411,12 @@ int videobuf_reqbufs(struct videobuf_queue *q,
 		goto done;
 	}
 
+	if (req->count == 0) {
+		__videobuf_streamoff(q);
+		retval = 0;
+		goto done;
+	}
+
 	if (q->streaming) {
 		dprintk(1, "reqbufs: streaming already exists\n");
 		retval = -EBUSY;
-- 
1.6.4.2



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
