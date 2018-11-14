Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:37175 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbeKOArU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 19:47:20 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v4l-utils] v4l2-compliance: test orphaned buffer support
Date: Wed, 14 Nov 2018 15:38:33 +0100
Message-Id: <20181114143833.19267-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Test that V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS is reported equally for
both MMAP and DMABUF memory types. If supported, try to orphan buffers
by calling reqbufs(0) before unmapping or closing DMABUF fds.

Also close exported DMABUF fds and free buffers in testDmaBuf if
orphaned buffers are not supported.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 contrib/freebsd/include/linux/videodev2.h   |  1 +
 include/linux/videodev2.h                   |  1 +
 utils/common/v4l2-info.cpp                  |  1 +
 utils/v4l2-compliance/v4l2-compliance.h     |  1 +
 utils/v4l2-compliance/v4l2-test-buffers.cpp | 35 +++++++++++++++++----
 5 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/contrib/freebsd/include/linux/videodev2.h b/contrib/freebsd/include/linux/videodev2.h
index 9928c00e4b68..33153b53c175 100644
--- a/contrib/freebsd/include/linux/videodev2.h
+++ b/contrib/freebsd/include/linux/videodev2.h
@@ -907,6 +907,7 @@ struct v4l2_requestbuffers {
 #define V4L2_BUF_CAP_SUPPORTS_USERPTR	(1 << 1)
 #define V4L2_BUF_CAP_SUPPORTS_DMABUF	(1 << 2)
 #define V4L2_BUF_CAP_SUPPORTS_REQUESTS	(1 << 3)
+#define V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS (1 << 4)
 
 /**
  * struct v4l2_plane - plane info for multi-planar buffers
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 79418cd39480..a39300cacb6a 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -873,6 +873,7 @@ struct v4l2_requestbuffers {
 #define V4L2_BUF_CAP_SUPPORTS_USERPTR	(1 << 1)
 #define V4L2_BUF_CAP_SUPPORTS_DMABUF	(1 << 2)
 #define V4L2_BUF_CAP_SUPPORTS_REQUESTS	(1 << 3)
+#define V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS (1 << 4)
 
 /**
  * struct v4l2_plane - plane info for multi-planar buffers
diff --git a/utils/common/v4l2-info.cpp b/utils/common/v4l2-info.cpp
index 258e5446f030..3699c35cb9d6 100644
--- a/utils/common/v4l2-info.cpp
+++ b/utils/common/v4l2-info.cpp
@@ -200,6 +200,7 @@ static const flag_def bufcap_def[] = {
 	{ V4L2_BUF_CAP_SUPPORTS_USERPTR, "userptr" },
 	{ V4L2_BUF_CAP_SUPPORTS_DMABUF, "dmabuf" },
 	{ V4L2_BUF_CAP_SUPPORTS_REQUESTS, "requests" },
+	{ V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS, "orphaned-bufs" },
 	{ 0, NULL }
 };
 
diff --git a/utils/v4l2-compliance/v4l2-compliance.h b/utils/v4l2-compliance/v4l2-compliance.h
index def185f17261..88ec260a9bcc 100644
--- a/utils/v4l2-compliance/v4l2-compliance.h
+++ b/utils/v4l2-compliance/v4l2-compliance.h
@@ -119,6 +119,7 @@ struct base_node {
 	__u32 valid_buftypes;
 	__u32 valid_buftype;
 	__u32 valid_memorytype;
+	bool has_orphaned_bufs;
 };
 
 struct node : public base_node, public cv4l_fd {
diff --git a/utils/v4l2-compliance/v4l2-test-buffers.cpp b/utils/v4l2-compliance/v4l2-test-buffers.cpp
index c59a56d9ced7..6174015cb4e7 100644
--- a/utils/v4l2-compliance/v4l2-test-buffers.cpp
+++ b/utils/v4l2-compliance/v4l2-test-buffers.cpp
@@ -400,8 +400,11 @@ int testReqBufs(struct node *node)
 		mmap_valid = !ret;
 		if (mmap_valid)
 			caps = q.g_capabilities();
-		if (caps)
+		if (caps) {
 			fail_on_test(mmap_valid ^ !!(caps & V4L2_BUF_CAP_SUPPORTS_MMAP));
+			if (caps & V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS)
+				node->has_orphaned_bufs = true;
+		}
 
 		q.init(i, V4L2_MEMORY_USERPTR);
 		ret = q.reqbufs(node, 0);
@@ -418,8 +421,11 @@ int testReqBufs(struct node *node)
 		fail_on_test(!mmap_valid && dmabuf_valid);
 		// Note: dmabuf is only supported with vb2, so we can assume a
 		// non-0 caps value if dmabuf is supported.
-		if (caps || dmabuf_valid)
+		if (caps || dmabuf_valid) {
 			fail_on_test(dmabuf_valid ^ !!(caps & V4L2_BUF_CAP_SUPPORTS_DMABUF));
+			if (node->has_orphaned_bufs)
+				fail_on_test(userptr_valid ^ !!(caps & V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS));
+		}
 
 		fail_on_test((can_stream && !is_overlay) && !mmap_valid && !userptr_valid && !dmabuf_valid);
 		fail_on_test((!can_stream || is_overlay) && (mmap_valid || userptr_valid || dmabuf_valid));
@@ -967,12 +973,22 @@ int testMmap(struct node *node, unsigned frame_count)
 		fail_on_test(captureBufs(node, q, m2m_q, frame_count, true));
 		fail_on_test(node->streamoff(q.g_type()));
 		fail_on_test(node->streamoff(q.g_type()));
-		q.munmap_bufs(node);
-		fail_on_test(q.reqbufs(node, 0));
+		if (node->has_orphaned_bufs) {
+			fail_on_test(q.reqbufs(node, 0));
+			q.munmap_bufs(node);
+		} else {
+			q.munmap_bufs(node);
+			fail_on_test(q.reqbufs(node, 0));
+		}
 		if (node->is_m2m) {
 			fail_on_test(node->streamoff(m2m_q.g_type()));
-			m2m_q.munmap_bufs(node);
-			fail_on_test(m2m_q.reqbufs(node, 0));
+			if (node->has_orphaned_bufs) {
+				fail_on_test(m2m_q.reqbufs(node, 0));
+				m2m_q.munmap_bufs(node);
+			} else {
+				m2m_q.munmap_bufs(node);
+				fail_on_test(m2m_q.reqbufs(node, 0));
+			}
 		}
 	}
 	return 0;
@@ -1201,6 +1217,13 @@ int testDmaBuf(struct node *expbuf_node, struct node *node, unsigned frame_count
 		fail_on_test(captureBufs(node, q, m2m_q, frame_count, true));
 		fail_on_test(node->streamoff(q.g_type()));
 		fail_on_test(node->streamoff(q.g_type()));
+		if (node->has_orphaned_bufs) {
+			fail_on_test(q.reqbufs(node, 0));
+			exp_q.close_exported_fds();
+		} else {
+			exp_q.close_exported_fds();
+			fail_on_test(q.reqbufs(node, 0));
+		}
 	}
 	return 0;
 }
-- 
2.19.1
