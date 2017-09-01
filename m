Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:38118 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751537AbdIABvK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 21:51:10 -0400
Received: by mail-qk0-f196.google.com with SMTP id o63so971122qkb.5
        for <linux-media@vger.kernel.org>; Thu, 31 Aug 2017 18:51:10 -0700 (PDT)
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v2 07/14] [media] vb2: add .buffer_queued() to notify queueing in the driver
Date: Thu, 31 Aug 2017 22:50:34 -0300
Message-Id: <20170901015041.7757-8-gustavo@padovan.org>
In-Reply-To: <20170901015041.7757-1-gustavo@padovan.org>
References: <20170901015041.7757-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

With the upcoming explicit synchronization support to V4L2 we need a
way to notify userspace when buffers are queued to the driver - buffers
with fences attached to it can only be queued once the fence signal, so
the queueing to the driver might be deferred.

Yet, userspace still wants to be notified, so the buffer_queued() callback
was added to vb2_buf_ops for that purpose.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 include/media/videobuf2-core.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index cad45e49a46d..46049dec7f61 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -412,6 +412,8 @@ struct vb2_ops {
  *			will return an error.
  * @copy_timestamp:	copy the timestamp from a userspace structure to
  *			the vb2_buffer struct.
+ * @buffer_queued:	VB2 uses this to notify the VB2-client that the buffer
+ *			was queued to the driver.
  */
 struct vb2_buf_ops {
 	int (*verify_planes_array)(struct vb2_buffer *vb, const void *pb);
@@ -419,6 +421,7 @@ struct vb2_buf_ops {
 	int (*fill_vb2_buffer)(struct vb2_buffer *vb, const void *pb,
 				struct vb2_plane *planes);
 	void (*copy_timestamp)(struct vb2_buffer *vb, const void *pb);
+	void (*buffer_queued)(struct vb2_buffer *vb);
 };
 
 /**
-- 
2.13.5
