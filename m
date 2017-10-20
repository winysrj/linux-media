Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:45870 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753184AbdJTVuo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 17:50:44 -0400
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
Subject: [RFC v4 06/17] [media] vb2: add .send_out_fence() to notify userspace of out_fence_fd
Date: Fri, 20 Oct 2017 19:50:01 -0200
Message-Id: <20171020215012.20646-7-gustavo@padovan.org>
In-Reply-To: <20171020215012.20646-1-gustavo@padovan.org>
References: <20171020215012.20646-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

With the upcoming explicit synchronization support to V4L2 we need a
way to notify userspace of the out_fence_fd when buffers are queued to the
driver - buffers with in-fences attached to it can only be queued once the
fence signal, so the queueing to the driver might be deferred.

v2: rename to .send_out_fence()

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 include/media/videobuf2-core.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index ef9b64398c8c..96af4eb49e52 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -408,6 +408,7 @@ struct vb2_ops {
  *			will return an error.
  * @copy_timestamp:	copy the timestamp from a userspace structure to
  *			the vb2_buffer struct.
+ * @send_out_fence:	send an out_fence fd of the buffer queued to userspace.
  */
 struct vb2_buf_ops {
 	int (*verify_planes_array)(struct vb2_buffer *vb, const void *pb);
@@ -415,6 +416,7 @@ struct vb2_buf_ops {
 	int (*fill_vb2_buffer)(struct vb2_buffer *vb, const void *pb,
 				struct vb2_plane *planes);
 	void (*copy_timestamp)(struct vb2_buffer *vb, const void *pb);
+	void (*send_out_fence)(struct vb2_buffer *vb);
 };
 
 /**
-- 
2.13.6
