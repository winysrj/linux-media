Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:33068 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751687AbdIABvS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 21:51:18 -0400
Received: by mail-qt0-f195.google.com with SMTP id h15so840855qta.0
        for <linux-media@vger.kernel.org>; Thu, 31 Aug 2017 18:51:17 -0700 (PDT)
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v2 09/14] [media] vb2: add 'ordered' property to queues
Date: Thu, 31 Aug 2017 22:50:36 -0300
Message-Id: <20170901015041.7757-10-gustavo@padovan.org>
In-Reply-To: <20170901015041.7757-1-gustavo@padovan.org>
References: <20170901015041.7757-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

For explicit synchronization (and soon for HAL3/Request API) we need
the v4l2-driver to guarantee the ordering in which the buffers were queued
by userspace. This is already true for many drivers, but we never needed
to say it.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 include/media/videobuf2-core.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 46049dec7f61..ad419f7204a2 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -505,6 +505,9 @@ struct vb2_buf_ops {
  * @last_buffer_dequeued: used in poll() and DQBUF to immediately return if the
  *		last decoded buffer was already dequeued. Set for capture queues
  *		when a buffer with the V4L2_BUF_FLAG_LAST is dequeued.
+ * @ordered: if the driver can guarantee that the queue will be ordered or not.
+ *		The default is not ordered unless the driver sets this flag. It
+ *		is mandatory for using explicit fences.
  * @fileio:	file io emulator internal data, used only if emulator is active
  * @threadio:	thread io internal data, used only if thread is active
  */
@@ -557,6 +560,7 @@ struct vb2_queue {
 	unsigned int			is_output:1;
 	unsigned int			copy_timestamp:1;
 	unsigned int			last_buffer_dequeued:1;
+	unsigned int			ordered:1;
 
 	struct vb2_fileio_data		*fileio;
 	struct vb2_threadio_data	*threadio;
-- 
2.13.5
