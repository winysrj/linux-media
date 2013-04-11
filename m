Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:58388 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935982Ab3DKSFX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 14:05:23 -0400
Received: by mail-pd0-f181.google.com with SMTP id y10so982569pdj.12
        for <linux-media@vger.kernel.org>; Thu, 11 Apr 2013 11:05:22 -0700 (PDT)
From: Tzu-Jung Lee <roylee17@gmail.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, k.debski@samsung.com,
	Tzu-Jung Lee <tjlee@ambarella.com>
Subject: [PATCH] v4l2-ctl: add is_compressed_format() helper
Date: Fri, 12 Apr 2013 02:07:01 +0800
Message-Id: <1365703621-7783-1-git-send-email-tjlee@ambarella.com>
In-Reply-To: <1365699247-32351-1-git-send-email-tjlee@ambarella.com>
References: <1365699247-32351-1-git-send-email-tjlee@ambarella.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is used to:

  bypass precalculate_bars() for OUTPUT device
  that takes encoded bitstreams.

  handle the last chunk of input file that has
  non-buffer-aligned size.

Signed-off-by: Tzu-Jung Lee <tjlee@ambarella.com>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 132 ++++++++++++++++++++++++++++------
 1 file changed, 112 insertions(+), 20 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 9e361af..44643e8 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -115,6 +115,29 @@ static const flag_def tc_flags_def[] = {
 	{ 0, NULL }
 };
 
+static bool is_compressed_format(__u32 pixfmt)
+{
+	switch (pixfmt) {
+	case V4L2_PIX_FMT_MJPEG:
+	case V4L2_PIX_FMT_JPEG:
+	case V4L2_PIX_FMT_DV:
+	case V4L2_PIX_FMT_MPEG:
+	case V4L2_PIX_FMT_H264:
+	case V4L2_PIX_FMT_H264_NO_SC:
+	case V4L2_PIX_FMT_H263:
+	case V4L2_PIX_FMT_MPEG1:
+	case V4L2_PIX_FMT_MPEG2:
+	case V4L2_PIX_FMT_MPEG4:
+	case V4L2_PIX_FMT_XVID:
+	case V4L2_PIX_FMT_VC1_ANNEX_G:
+		return true;
+	default:
+		return false;
+	}
+
+	return false;
+}
+
 static void print_buffer(FILE *f, struct v4l2_buffer &buf)
 {
 	fprintf(f, "\tIndex    : %d\n", buf.index);
@@ -223,25 +246,60 @@ void streaming_cmd(int ch, char *optarg)
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
-				buffer_lengths[p], fin);
+				    buffer_lengths[p], fin);
 
+		buffer_bytesused[j] = sz;
 		if (j == 0 && sz == 0 && stream_loop) {
 			fseek(fin, 0, SEEK_SET);
 			sz = fread(buffers[p], 1,
-					buffer_lengths[p], fin);
+				   buffer_lengths[p], fin);
+
+			buffer_bytesused[j] = sz;
 		}
 		if (sz == buffer_lengths[p])
 			continue;
+
+		// Bail out if we get weird buffer sizes.
 		if (sz)
 			fprintf(stderr, "%u != %u\n", sz, buffer_lengths[p]);
-		// Bail out if we get weird buffer sizes.
+
 		return false;
 	}
+
 	return true;
 }
 
@@ -312,16 +370,22 @@ static void do_setup_out_buffers(int fd, struct v4l2_requestbuffers *reqbufs,
 				 bool is_mplane, unsigned &num_planes, bool is_mmap,
 				 void *buffers[], unsigned buffer_lengths[], FILE *fin)
 {
+	bool is_compressed;
+
 	struct v4l2_format fmt;
 	memset(&fmt, 0, sizeof(fmt));
 	fmt.type = reqbufs->type;
 	doioctl(fd, VIDIOC_G_FMT, &fmt);
 
-	if (!precalculate_bars(fmt.fmt.pix.pixelformat, stream_pat)) {
+	is_compressed = is_compressed_format(fmt.fmt.pix.pixelformat);
+	if (!is_compressed &&
+	    !precalculate_bars(fmt.fmt.pix.pixelformat, stream_pat)) {
 		fprintf(stderr, "unsupported pixelformat\n");
 		return;
 	}
 
+	unsigned buffer_bytesused[reqbufs->count * VIDEO_MAX_PLANES];
+
 	for (unsigned i = 0; i < reqbufs->count; i++) {
 		struct v4l2_plane planes[VIDEO_MAX_PLANES];
 		struct v4l2_buffer buf;
@@ -363,11 +427,11 @@ static void do_setup_out_buffers(int fd, struct v4l2_requestbuffers *reqbufs,
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
@@ -381,9 +445,16 @@ static void do_setup_out_buffers(int fd, struct v4l2_requestbuffers *reqbufs,
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
@@ -511,12 +582,13 @@ static int do_handle_cap(int fd, struct v4l2_requestbuffers *reqbufs,
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
@@ -535,14 +607,17 @@ static int do_handle_out(int fd, struct v4l2_requestbuffers *reqbufs,
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
-			buf.m.planes[j].bytesused = buf.m.planes[j].length;
+			buf.m.planes[j].bytesused = buffer_bytesused[j];
 	} else {
-		buf.bytesused = buf.length;
+		buf.bytesused = buffer_bytesused[buf.index];
 	}
 	if (test_ioctl(fd, VIDIOC_QBUF, &buf))
 		return -1;
@@ -688,7 +763,9 @@ static void streaming_set_cap(int fd)
 static void streaming_set_out(int fd)
 {
 	struct v4l2_requestbuffers reqbufs;
+	struct v4l2_format fmt;
 	int fd_flags = fcntl(fd, F_GETFL);
+	bool is_compressed;
 	bool is_mplane = capabilities &
 			(V4L2_CAP_VIDEO_OUTPUT_MPLANE |
 				 V4L2_CAP_VIDEO_M2M_MPLANE);
@@ -710,6 +787,12 @@ static void streaming_set_out(int fd)
 	reqbufs.type = type;
 	reqbufs.memory = is_mmap ? V4L2_MEMORY_MMAP : V4L2_MEMORY_USERPTR;
 
+	memset(&fmt, 0, sizeof(fmt));
+	fmt.type = reqbufs.type;
+	doioctl(fd, VIDIOC_G_FMT, &fmt);
+
+	is_compressed = is_compressed_format(fmt.fmt.pix.pixelformat);
+
 	if (file_out) {
 		if (!strcmp(file_out, "-"))
 			fin = stdin;
@@ -765,9 +848,9 @@ static void streaming_set_out(int fd)
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
 
@@ -795,6 +878,9 @@ enum stream_type {
 
 static void streaming_set_m2m(int fd)
 {
+	struct v4l2_format fmt;
+	bool is_compressed;
+
 	int fd_flags = fcntl(fd, F_GETFL);
 	bool use_poll = options[OptStreamPoll];
 
@@ -864,6 +950,12 @@ static void streaming_set_m2m(int fd)
 			     is_mmap, buffers_out, buffer_lengths_out,
 			     file[OUT]);
 
+	memset(&fmt, 0, sizeof(fmt));
+	fmt.type = reqbufs[OUT].type;
+	doioctl(fd, VIDIOC_G_FMT, &fmt);
+
+	is_compressed = is_compressed_format(fmt.fmt.pix.pixelformat);
+
 	if (doioctl(fd, VIDIOC_STREAMON, &type[CAP]) ||
 	    doioctl(fd, VIDIOC_STREAMON, &type[OUT]))
 		return;
@@ -927,9 +1019,9 @@ static void streaming_set_m2m(int fd)
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

