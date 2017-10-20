Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:43951 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753184AbdJTVuv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 17:50:51 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC v4 08/17] [media] vb2: add 'ordered_in_driver' property to queues
Date: Fri, 20 Oct 2017 19:50:03 -0200
Message-Id: <20171020215012.20646-9-gustavo@padovan.org>
In-Reply-To: <20171020215012.20646-1-gustavo@padovan.org>
References: <20171020215012.20646-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

For explicit synchronization (and soon for HAL3/Request API) we need
the v4l2-driver to guarantee the ordering in which the buffers were queued
by userspace. This is already true for many drivers, but we never needed
to say it.

v2: rename property to 'ordered_in_driver' to avoid confusion

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 include/media/videobuf2-core.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 96af4eb49e52..6dd3f0181107 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -500,6 +500,11 @@ struct vb2_buf_ops {
  * @last_buffer_dequeued: used in poll() and DQBUF to immediately return if the
  *		last decoded buffer was already dequeued. Set for capture queues
  *		when a buffer with the V4L2_BUF_FLAG_LAST is dequeued.
+ * @ordered_in_driver: if the driver can guarantee that the queue will be
+ *		ordered or not, i.e., the buffers are queued to the driver in
+ *		the same order they are dequeued from the driver. The default
+ *		is not ordered unless the driver sets this flag. As of now it
+ *		is mandatory for using explicit fences.
  * @fileio:	file io emulator internal data, used only if emulator is active
  * @threadio:	thread io internal data, used only if thread is active
  */
@@ -552,6 +557,7 @@ struct vb2_queue {
 	unsigned int			is_output:1;
 	unsigned int			copy_timestamp:1;
 	unsigned int			last_buffer_dequeued:1;
+	unsigned int			ordered_in_driver:1;
 
 	struct vb2_fileio_data		*fileio;
 	struct vb2_threadio_data	*threadio;
-- 
2.13.6
