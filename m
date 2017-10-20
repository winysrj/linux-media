Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:45203 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753296AbdJTVux (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 17:50:53 -0400
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
Subject: [RFC v4 09/17] [media] vb2: add 'ordered_in_vb2' property to queues
Date: Fri, 20 Oct 2017 19:50:04 -0200
Message-Id: <20171020215012.20646-10-gustavo@padovan.org>
In-Reply-To: <20171020215012.20646-1-gustavo@padovan.org>
References: <20171020215012.20646-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

By setting this member on vb2_queue the driver tell vb2 core that
it requires the buffers queued in QBUF to be queued with same order to the
driver.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 include/media/videobuf2-core.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 6dd3f0181107..fc333e10e7d8 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -505,6 +505,9 @@ struct vb2_buf_ops {
  *		the same order they are dequeued from the driver. The default
  *		is not ordered unless the driver sets this flag. As of now it
  *		is mandatory for using explicit fences.
+ * @ordered_in_vb2: set by the driver to tell vb2 te guarantee the order
+ *		of buffer queue from userspace with QBUF() until they are
+ *		queued to the driver.
  * @fileio:	file io emulator internal data, used only if emulator is active
  * @threadio:	thread io internal data, used only if thread is active
  */
@@ -558,6 +561,7 @@ struct vb2_queue {
 	unsigned int			copy_timestamp:1;
 	unsigned int			last_buffer_dequeued:1;
 	unsigned int			ordered_in_driver:1;
+	unsigned int			ordered_in_vb2:1;
 
 	struct vb2_fileio_data		*fileio;
 	struct vb2_threadio_data	*threadio;
-- 
2.13.6
