Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35827 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbcFTMZJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 08:25:09 -0400
Received: by mail-lf0-f66.google.com with SMTP id w130so5295749lfd.2
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2016 05:24:00 -0700 (PDT)
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	hans.verkuil@cisco.com
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] v4l2-compliance: Check V4L2_BUF_FLAG_DONE
Date: Mon, 20 Jun 2016 14:23:56 +0200
Message-Id: <1466425436-18705-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to the doc, V4L2_BUF_FLAG_DONE is cleared after DQBUF and
QBUF:

V4L2_BUF_FLAG_DONE 0x00000004  ... After calling the VIDIOC_QBUF or
VIDIOC_DQBUF it is always cleared ..

This patch implements this check.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---

Hello Hans!

Maybe you do not want to add this check to every dqbuf/qbuf in the code.
Please let me know to make a v2 of this patch.

Thanks!

 utils/v4l2-compliance/v4l2-test-buffers.cpp | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/utils/v4l2-compliance/v4l2-test-buffers.cpp b/utils/v4l2-compliance/v4l2-test-buffers.cpp
index 6c5ed5579f12..4d25870942bd 100644
--- a/utils/v4l2-compliance/v4l2-test-buffers.cpp
+++ b/utils/v4l2-compliance/v4l2-test-buffers.cpp
@@ -719,7 +719,9 @@ static int captureBufs(struct node *node, const cv4l_queue &q,
 					fail_on_test(memcmp(&buf.g_timecode(), &orig_buf.timecode,
 								sizeof(orig_buf.timecode)));
 			}
+			fail_on_test(buf.g_flags() & V4L2_BUF_FLAG_DONE);
 			fail_on_test(buf.qbuf(node));
+			fail_on_test(buf.g_flags() & V4L2_BUF_FLAG_DONE);
 			if (--count == 0)
 				break;
 		}
@@ -746,7 +748,9 @@ static int captureBufs(struct node *node, const cv4l_queue &q,
 				fail_on_test(memcmp(&buf.g_timecode(), &orig_buf.timecode,
 							sizeof(orig_buf.timecode)));
 		}
+		fail_on_test(buf.g_flags() & V4L2_BUF_FLAG_DONE);
 		fail_on_test(buf.qbuf(node));
+		fail_on_test(buf.g_flags() & V4L2_BUF_FLAG_DONE);
 	}
 	if (use_poll)
 		fcntl(node->g_fd(), F_SETFL, fd_flags);
@@ -778,6 +782,7 @@ static int setupM2M(struct node *node, cv4l_queue &q)
 
 		fail_on_test(buf.querybuf(node, i));
 		fail_on_test(buf.qbuf(node));
+		fail_on_test(buf.g_flags() & V4L2_BUF_FLAG_DONE);
 	}
 	if (v4l_type_is_video(q.g_type())) {
 		cv4l_fmt fmt(q.g_type());
@@ -828,6 +833,7 @@ static int bufferOutputErrorTest(struct node *node, const buffer &orig_buf)
 		}
 	}
 	fail_on_test(buf.qbuf(node, false));
+	fail_on_test(buf.g_flags() & V4L2_BUF_FLAG_DONE);
 	for (unsigned p = 0; p < buf.g_num_planes(); p++) {
 		fail_on_test(buf.g_bytesused(p) != buf.g_length(p));
 		fail_on_test(buf.g_data_offset(p));
@@ -864,6 +870,7 @@ static int setupMmap(struct node *node, cv4l_queue &q)
 			}
 
 			fail_on_test(buf.qbuf(node));
+			fail_on_test(buf.g_flags() & V4L2_BUF_FLAG_DONE);
 			fail_on_test(!buf.qbuf(node));
 			fail_on_test(!buf.prepare_buf(node));
 			// Test with invalid buffer index
@@ -926,6 +933,7 @@ int testMmap(struct node *node, unsigned frame_count)
 
 			fail_on_test(buf.querybuf(node, i));
 			fail_on_test(buf.qbuf(node));
+			fail_on_test(buf.g_flags() & V4L2_BUF_FLAG_DONE);
 		}
 		// calling STREAMOFF...
 		fail_on_test(node->streamoff(q.g_type()));
@@ -936,6 +944,7 @@ int testMmap(struct node *node, unsigned frame_count)
 
 			fail_on_test(buf.querybuf(node, i));
 			fail_on_test(buf.qbuf(node));
+			fail_on_test(buf.g_flags() & V4L2_BUF_FLAG_DONE);
 		}
 		// Now request buffers again, freeing the old buffers.
 		// Good check for whether all the internal vb2 calls are in
@@ -1041,6 +1050,7 @@ static int setupUserPtr(struct node *node, cv4l_queue &q)
 		}
 
 		fail_on_test(buf.qbuf(node));
+		fail_on_test(buf.g_flags() & V4L2_BUF_FLAG_DONE);
 		fail_on_test(buf.querybuf(node, i));
 		fail_on_test(buf.check(q, Queued, i));
 	}
@@ -1142,6 +1152,7 @@ static int setupDmaBuf(struct node *expbuf_node, struct node *node,
 		}
 
 		fail_on_test(buf.qbuf(node));
+		fail_on_test(buf.g_flags() & V4L2_BUF_FLAG_DONE);
 		fail_on_test(buf.querybuf(node, i));
 		fail_on_test(buf.check(q, Queued, i));
 	}
@@ -1319,6 +1330,7 @@ static int testStreaming(struct node *node, unsigned frame_count)
 			if (alternate)
 				field ^= 1;
 			fail_on_test(node->qbuf(buf));
+			fail_on_test(buf.g_flags() & V4L2_BUF_FLAG_DONE);
 		}
 		fail_on_test(node->streamon());
 
@@ -1327,10 +1339,12 @@ static int testStreaming(struct node *node, unsigned frame_count)
 					buftype2s(q.g_type()).c_str(),
 					buf.g_sequence(), field2s(buf.g_field()).c_str());
 			fflush(stdout);
+			fail_on_test(buf.g_flags() & V4L2_BUF_FLAG_DONE);
 			buf.s_field(field);
 			if (alternate)
 				field ^= 1;
 			fail_on_test(node->qbuf(buf));
+			fail_on_test(buf.g_flags() & V4L2_BUF_FLAG_DONE);
 			if (frame_count-- == 0)
 				break;
 		}
-- 
2.8.1

