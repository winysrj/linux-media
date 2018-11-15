Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:37269 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388019AbeKPCCQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 21:02:16 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v2] v4l2-compliance: test orphaned buffer support
Date: Thu, 15 Nov 2018 16:53:47 +0100
Message-Id: <20181115155347.22065-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Test that V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS is reported equally for
both MMAP and DMABUF memory types. If supported, try to orphan buffers
by calling reqbufs(0) before unmapping or closing DMABUF fds.

Also close exported DMABUF fds and free buffers in testDmaBuf if
orphaned buffers are not supported.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - Rename has_orphaned_bufs to supports_orphaned_bufs
 - Check that capabilities are independent of memory type
 - Check that orphaned buffer support is independent of queue for M2M
 - Check that reqbufs(0) returns -EBUSY without orphaned buffer support
---
 contrib/freebsd/include/linux/videodev2.h   |  1 +
 include/linux/videodev2.h                   |  1 +
 utils/common/v4l2-info.cpp                  |  1 +
 utils/v4l2-compliance/v4l2-compliance.h     |  1 +
 utils/v4l2-compliance/v4l2-test-buffers.cpp | 51 ++++++++++++++++++++++++++---
 5 files changed, 50 insertions(+), 5 deletions(-)

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
index def185f17261..02d616f0b47c 100644
--- a/utils/v4l2-compliance/v4l2-compliance.h
+++ b/utils/v4l2-compliance/v4l2-compliance.h
@@ -119,6 +119,7 @@ struct base_node {
 	__u32 valid_buftypes;
 	__u32 valid_buftype;
 	__u32 valid_memorytype;
+	bool supports_orphaned_bufs;
 };
 
 struct node : public base_node, public cv4l_fd {
diff --git a/utils/v4l2-compliance/v4l2-test-buffers.cpp b/utils/v4l2-compliance/v4l2-test-buffers.cpp
index a84be0ab799a..42e743fef43b 100644
--- a/utils/v4l2-compliance/v4l2-test-buffers.cpp
+++ b/utils/v4l2-compliance/v4l2-test-buffers.cpp
@@ -400,14 +400,18 @@ int testReqBufs(struct node *node)
 		mmap_valid = !ret;
 		if (mmap_valid)
 			caps = q.g_capabilities();
-		if (caps)
+		if (caps) {
 			fail_on_test(mmap_valid ^ !!(caps & V4L2_BUF_CAP_SUPPORTS_MMAP));
+			if (caps & V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS)
+				node->supports_orphaned_bufs = true;
+		}
 
 		q.init(i, V4L2_MEMORY_USERPTR);
 		ret = q.reqbufs(node, 0);
 		fail_on_test(ret && ret != EINVAL);
 		userptr_valid = !ret;
 		fail_on_test(!mmap_valid && userptr_valid);
+		fail_on_test(userptr_valid && (caps != q.g_capabilities()));
 		if (caps)
 			fail_on_test(userptr_valid ^ !!(caps & V4L2_BUF_CAP_SUPPORTS_USERPTR));
 
@@ -416,6 +420,7 @@ int testReqBufs(struct node *node)
 		fail_on_test(ret && ret != EINVAL);
 		dmabuf_valid = !ret;
 		fail_on_test(!mmap_valid && dmabuf_valid);
+		fail_on_test(dmabuf_valid && (caps != q.g_capabilities()));
 		if (caps)
 			fail_on_test(dmabuf_valid ^ !!(caps & V4L2_BUF_CAP_SUPPORTS_DMABUF));
 
@@ -754,9 +759,13 @@ static int captureBufs(struct node *node, const cv4l_queue &q,
 
 static int setupM2M(struct node *node, cv4l_queue &q)
 {
+	__u32 caps;
+
 	last_m2m_seq.init();
 
 	fail_on_test(q.reqbufs(node, 2));
+	caps = q.g_capabilities();
+	fail_on_test(node->supports_orphaned_bufs ^ !!(caps & V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS));
 	for (unsigned i = 0; i < q.g_buffers(); i++) {
 		buffer buf(q);
 
@@ -965,12 +974,32 @@ int testMmap(struct node *node, unsigned frame_count)
 		fail_on_test(captureBufs(node, q, m2m_q, frame_count, true));
 		fail_on_test(node->streamoff(q.g_type()));
 		fail_on_test(node->streamoff(q.g_type()));
-		q.munmap_bufs(node);
-		fail_on_test(q.reqbufs(node, 0));
+		if (node->supports_orphaned_bufs) {
+			fail_on_test(q.reqbufs(node, 0));
+			q.munmap_bufs(node);
+		} else if (q.reqbufs(node, 0) != EBUSY) {
+			// It's either a bug or this driver should set
+			// V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS
+			warn("Can free buffers even if still mmap()ed\n");
+			q.munmap_bufs(node);
+		} else {
+			q.munmap_bufs(node);
+			fail_on_test(q.reqbufs(node, 0));
+		}
 		if (node->is_m2m) {
 			fail_on_test(node->streamoff(m2m_q.g_type()));
-			m2m_q.munmap_bufs(node);
-			fail_on_test(m2m_q.reqbufs(node, 0));
+			if (node->supports_orphaned_bufs) {
+				fail_on_test(m2m_q.reqbufs(node, 0));
+				m2m_q.munmap_bufs(node);
+			} else if (m2m_q.reqbufs(node, 0) != EBUSY) {
+				// It's either a bug or this driver should set
+				// V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS
+				warn("Can free buffers even if still mmap()ed\n");
+				q.munmap_bufs(node);
+			} else {
+				m2m_q.munmap_bufs(node);
+				fail_on_test(m2m_q.reqbufs(node, 0));
+			}
 		}
 	}
 	return 0;
@@ -1199,6 +1228,18 @@ int testDmaBuf(struct node *expbuf_node, struct node *node, unsigned frame_count
 		fail_on_test(captureBufs(node, q, m2m_q, frame_count, true));
 		fail_on_test(node->streamoff(q.g_type()));
 		fail_on_test(node->streamoff(q.g_type()));
+		if (node->supports_orphaned_bufs) {
+			fail_on_test(q.reqbufs(node, 0));
+			exp_q.close_exported_fds();
+		} else if (q.reqbufs(node, 0) != EBUSY) {
+			// It's either a bug or this driver should set
+			// V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS
+			warn("Can free buffers even if exported DMABUF fds still open\n");
+			q.munmap_bufs(node);
+		} else {
+			exp_q.close_exported_fds();
+			fail_on_test(q.reqbufs(node, 0));
+		}
 	}
 	return 0;
 }
-- 
2.11.0
