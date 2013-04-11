Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:47692 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab3DKTp2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 15:45:28 -0400
Received: by mail-pa0-f42.google.com with SMTP id kq13so1067238pab.29
        for <linux-media@vger.kernel.org>; Thu, 11 Apr 2013 12:45:27 -0700 (PDT)
From: Tzu-Jung Lee <roylee17@gmail.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, k.debski@samsung.com,
	Tzu-Jung Lee <tjlee@ambarella.com>
Subject: [PATCH v4 2/2] v4l2-ctl: handle the last chunk of input file
Date: Fri, 12 Apr 2013 03:46:55 +0800
Message-Id: <1365709615-17399-2-git-send-email-tjlee@ambarella.com>
In-Reply-To: <1365709615-17399-1-git-send-email-tjlee@ambarella.com>
References: <1365709615-17399-1-git-send-email-tjlee@ambarella.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For bitstream input file, it could be non-aligned
to the buffer size.  In this case, we still need
to QBUF it to the driver.

Signed-off-by: Tzu-Jung Lee <tjlee@ambarella.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 72 +++++++++++++++++++++++++++--------
 1 file changed, 57 insertions(+), 15 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 035c3c7..d9b9146 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -240,8 +240,37 @@ void streaming_cmd(int ch, char *optarg)
 }
 
 static bool fill_buffer_from_file(void *buffers[], unsigned buffer_lengths[],
-		unsigned buf_index, unsigned num_planes, FILE *fin)
+				  unsigned buffer_bytesused[], unsigned buf_index,
+				  unsigned num_planes, bool is_compressed, FILE *fin)
 {
+	if (num_planes == 1) {
+		unsigned i = buf_index;
+		unsigned sz = fread(buffers[i], 1,
+				    buffer_lengths[i], fin);
+
+		buffer_bytesused[i] = sz;
+		if (sz == 0 && stream_loop) {
+			fseek(fin, 0, SEEK_SET);
+			sz = fread(buffers[i], 1,
+				   buffer_lengths[i], fin);
+
+			buffer_bytesused[i] = sz;
+		}
+
+		if (!sz)
+			return false;
+
+		if (sz == buffer_lengths[i])
+			return true;
+
+		if (is_compressed)
+			return true;
+
+		fprintf(stderr, "%u != %u\n", sz, buffer_lengths[i]);
+
+		return false;
+	}
+
 	for (unsigned j = 0; j < num_planes; j++) {
 		unsigned p = buf_index * num_planes + j;
 		unsigned sz = fread(buffers[p], 1,
@@ -343,6 +372,8 @@ static void do_setup_out_buffers(int fd, struct v4l2_requestbuffers *reqbufs,
 		return;
 	}
 
+	unsigned buffer_bytesused[reqbufs->count * VIDEO_MAX_PLANES];
+
 	for (unsigned i = 0; i < reqbufs->count; i++) {
 		struct v4l2_plane planes[VIDEO_MAX_PLANES];
 		struct v4l2_buffer buf;
@@ -384,11 +415,11 @@ static void do_setup_out_buffers(int fd, struct v4l2_requestbuffers *reqbufs,
 			// TODO fill_buffer_mp(buffers[i], &fmt.fmt.pix_mp);
 			if (fin)
 				fill_buffer_from_file(buffers, buffer_lengths,
-						      buf.index, num_planes, fin);
+						      buffer_bytesused, buf.index,
+						      num_planes, is_compressed, fin);
 		}
 		else {
 			buffer_lengths[i] = buf.length;
-			buf.bytesused = buf.length;
 			if (is_mmap) {
 				buffers[i] = mmap(NULL, buf.length,
 						  PROT_READ | PROT_WRITE, MAP_SHARED, fd, buf.m.offset);
@@ -402,9 +433,16 @@ static void do_setup_out_buffers(int fd, struct v4l2_requestbuffers *reqbufs,
 				buffers[i] = calloc(1, buf.length);
 				buf.m.userptr = (unsigned long)buffers[i];
 			}
-			if (!fin || !fill_buffer_from_file(buffers, buffer_lengths,
-							   buf.index, num_planes, fin))
+
+			if (fin && fill_buffer_from_file(buffers, buffer_lengths,
+							 buffer_bytesused, buf.index,
+							 num_planes, is_compressed,
+							 fin)) {
+				buf.bytesused = buffer_bytesused[buf.index];
+			}
+			else {
 				fill_buffer(buffers[i], &fmt.fmt.pix);
+			}
 		}
 		if (doioctl(fd, VIDIOC_QBUF, &buf))
 			return;
@@ -532,12 +570,13 @@ static int do_handle_cap(int fd, struct v4l2_requestbuffers *reqbufs,
 }
 
 static int do_handle_out(int fd, struct v4l2_requestbuffers *reqbufs,
-			 bool is_mplane, unsigned num_planes,
+			 bool is_compressed, bool is_mplane, unsigned num_planes,
 			 void *buffers[], unsigned buffer_lengths[], FILE *fin,
 			 unsigned &count, unsigned &last, struct timeval &tv_last)
 {
 	struct v4l2_plane planes[VIDEO_MAX_PLANES];
 	struct v4l2_buffer buf;
+	unsigned buffer_bytesused[reqbufs->count * VIDEO_MAX_PLANES];
 	int ret;
 
 	memset(&buf, 0, sizeof(buf));
@@ -556,14 +595,17 @@ static int do_handle_out(int fd, struct v4l2_requestbuffers *reqbufs,
 		fprintf(stderr, "%s: failed: %s\n", "VIDIOC_DQBUF", strerror(errno));
 		return -1;
 	}
-	if (fin && !fill_buffer_from_file(buffers, buffer_lengths,
-					  buf.index, num_planes, fin))
+	if (fin &&!fill_buffer_from_file(buffers, buffer_lengths,
+					 buffer_bytesused, buf.index,
+					 num_planes, is_compressed,
+					 fin)) {
 		return -1;
+	}
 	if (is_mplane) {
 		for (unsigned j = 0; j < buf.length; j++)
 			buf.m.planes[j].bytesused = buf.m.planes[j].length;
 	} else {
-		buf.bytesused = buf.length;
+		buf.bytesused = buffer_bytesused[buf.index];
 	}
 	if (test_ioctl(fd, VIDIOC_QBUF, &buf))
 		return -1;
@@ -794,9 +836,9 @@ static void streaming_set_out(int fd)
 				return;
 			}
 		}
-		r = do_handle_out(fd, &reqbufs, is_mplane, num_planes,
-				   buffers, buffer_lengths, fin,
-				   count, last, tv_last);
+		r = do_handle_out(fd, &reqbufs, is_compressed, is_mplane,
+				  num_planes, buffers, buffer_lengths,
+				  fin, count, last, tv_last);
 		if (r == -1)
 			break;
 
@@ -965,9 +1007,9 @@ static void streaming_set_m2m(int fd)
 		}
 
 		if (wr_fds && FD_ISSET(fd, wr_fds)) {
-			r  = do_handle_out(fd, &reqbufs[OUT], is_mplane, num_planes[OUT],
-					   buffers_out, buffer_lengths_out, file[OUT],
-					   count[OUT], last[OUT], tv_last[OUT]);
+			r  = do_handle_out(fd, &reqbufs[OUT], is_compressed, is_mplane,
+					   num_planes[OUT], buffers_out, buffer_lengths_out,
+					   file[OUT], count[OUT], last[OUT], tv_last[OUT]);
 			if (r < 0)  {
 				wr_fds = NULL;
 
-- 
1.8.1.5

