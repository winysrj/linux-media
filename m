Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-da0-f43.google.com ([209.85.210.43]:41515 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab3DJFeC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 01:34:02 -0400
Received: by mail-da0-f43.google.com with SMTP id u36so53129dak.30
        for <linux-media@vger.kernel.org>; Tue, 09 Apr 2013 22:34:01 -0700 (PDT)
From: Tzu-Jung Lee <roylee17@gmail.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, k.debski@samsung.com,
	Tzu-Jung Lee <tjlee@ambarella.com>
Subject: [PATCH 1/2] v4l2-ctl: break down the streaming_set()
Date: Wed, 10 Apr 2013 13:35:34 +0800
Message-Id: <1365572135-2311-1-git-send-email-tjlee@ambarella.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch breaks down the streaming_set() into smaller
ones, which can be resued for supporting m2m devices.

Further cleanup or consolidation can be applied with
separate patches, since this one tries not to modify
logics.
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 888 ++++++++++++++++++----------------
 1 file changed, 480 insertions(+), 408 deletions(-)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index c29565f..f8e782d 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -27,7 +27,8 @@ static unsigned stream_skip;
 static unsigned stream_pat;
 static bool stream_loop;
 static unsigned reqbufs_count = 3;
-static char *file;
+static char *file_cap;
+static char *file_out;
 
 #define NUM_PATTERNS (4)
 
@@ -198,12 +199,12 @@ void streaming_cmd(int ch, char *optarg)
 		stream_pat %= NUM_PATTERNS;
 		break;
 	case OptStreamTo:
-		file = optarg;
-		if (!strcmp(file, "-"))
+		file_cap = optarg;
+		if (!strcmp(file_cap, "-"))
 			options[OptSilent] = true;
 		break;
 	case OptStreamFrom:
-		file = optarg;
+		file_out = optarg;
 		break;
 	case OptStreamMmap:
 	case OptStreamUser:
@@ -526,475 +527,546 @@ static bool fill_buffer_from_file(void *buffers[], unsigned buffer_lengths[],
 	return true;
 }
 
-void streaming_set(int fd)
+static void do_setup_cap_buffers(int fd, struct v4l2_requestbuffers *reqbufs,
+				 bool is_mplane, unsigned num_planes, bool is_mmap,
+				 void *buffers[], unsigned buffer_lengths[])
 {
-	if (options[OptStreamMmap] || options[OptStreamUser]) {
-		struct v4l2_requestbuffers reqbufs;
-		struct v4l2_event_subscription sub;
-		int fd_flags = fcntl(fd, F_GETFL);
-		bool is_mplane = capabilities &
-			(V4L2_CAP_VIDEO_CAPTURE_MPLANE |
-			 V4L2_CAP_VIDEO_M2M_MPLANE);
-		bool is_mmap = options[OptStreamMmap];
-		bool use_poll = options[OptStreamPoll];
-		__u32 type = is_mplane ?
-			V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE : V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		FILE *fout = NULL;
-		unsigned num_planes = 1;
-
-		memset(&reqbufs, 0, sizeof(reqbufs));
-		reqbufs.count = reqbufs_count;
-		reqbufs.type = type;
-		reqbufs.memory = is_mmap ? V4L2_MEMORY_MMAP : V4L2_MEMORY_USERPTR;
-		memset(&sub, 0, sizeof(sub));
-		sub.type = V4L2_EVENT_EOS;
-		ioctl(fd, VIDIOC_SUBSCRIBE_EVENT, &sub);
-
-		if (file) {
-			if (!strcmp(file, "-"))
-				fout = stdout;
-			else
-				fout = fopen(file, "w+");
-		}
+	for (unsigned i = 0; i < reqbufs->count; i++) {
+		struct v4l2_plane planes[VIDEO_MAX_PLANES];
+		struct v4l2_buffer buf;
 
-		if (doioctl(fd, VIDIOC_REQBUFS, &reqbufs))
+		memset(&buf, 0, sizeof(buf));
+		memset(planes, 0, sizeof(planes));
+		buf.type = reqbufs->type;
+		buf.memory = reqbufs->memory;
+		buf.index = i;
+		if (is_mplane) {
+			buf.m.planes = planes;
+			buf.length = VIDEO_MAX_PLANES;
+		}
+		if (doioctl(fd, VIDIOC_QUERYBUF, &buf))
 			return;
 
-		void *buffers[reqbufs.count * VIDEO_MAX_PLANES];
-		unsigned buffer_lengths[reqbufs.count * VIDEO_MAX_PLANES];
-		
-		for (unsigned i = 0; i < reqbufs.count; i++) {
-			struct v4l2_plane planes[VIDEO_MAX_PLANES];
-			struct v4l2_buffer buf;
-
-			memset(&buf, 0, sizeof(buf));
-			memset(planes, 0, sizeof(planes));
-			buf.type = reqbufs.type;
-			buf.memory = reqbufs.memory;
-			buf.index = i;
-			if (is_mplane) {
-				buf.m.planes = planes;
-				buf.length = VIDEO_MAX_PLANES;
-			}
-			if (doioctl(fd, VIDIOC_QUERYBUF, &buf))
-				return;
+		if (is_mplane) {
+			num_planes = buf.length;
+			for (unsigned j = 0; j < num_planes; j++) {
+				unsigned p = i * num_planes + j;
 
-			if (is_mplane) {
-				num_planes = buf.length;
-				for (unsigned j = 0; j < num_planes; j++) {
-					unsigned p = i * num_planes + j;
-
-					buffer_lengths[p] = planes[j].length;
-					if (is_mmap) {
-						buffers[p] = mmap(NULL, planes[j].length,
-								PROT_READ | PROT_WRITE, MAP_SHARED,
-								fd, planes[j].m.mem_offset);
-
-						if (buffers[p] == MAP_FAILED) {
-							fprintf(stderr, "mmap failed\n");
-							return;
-						}
-					} else {
-						buffers[p] = calloc(1, planes[j].length);
-						planes[j].m.userptr = (unsigned long)buffers[p];
-					}
-				}
-			} else {
-				buffer_lengths[i] = buf.length;
+				buffer_lengths[p] = planes[j].length;
 				if (is_mmap) {
-					buffers[i] = mmap(NULL, buf.length,
-							PROT_READ | PROT_WRITE, MAP_SHARED, fd, buf.m.offset);
+					buffers[p] = mmap(NULL, planes[j].length,
+							  PROT_READ | PROT_WRITE, MAP_SHARED,
+							  fd, planes[j].m.mem_offset);
 
-					if (buffers[i] == MAP_FAILED) {
+					if (buffers[p] == MAP_FAILED) {
 						fprintf(stderr, "mmap failed\n");
 						return;
 					}
-				} else {
-					buffers[i] = calloc(1, buf.length);
-					buf.m.userptr = (unsigned long)buffers[i];
+				}
+				else {
+					buffers[p] = calloc(1, planes[j].length);
+					planes[j].m.userptr = (unsigned long)buffers[p];
 				}
 			}
-			if (doioctl(fd, VIDIOC_QBUF, &buf))
-				return;
 		}
-
-		type = reqbufs.type;
-		if (doioctl(fd, VIDIOC_STREAMON, &type))
-			return;
-
-		if (use_poll)
-			fcntl(fd, F_SETFL, fd_flags | O_NONBLOCK);
-
-		unsigned count = 0, last = 0;
-		struct timeval tv_last;
-		bool eos = false;
-
-		while (!eos) {
-			struct v4l2_plane planes[VIDEO_MAX_PLANES];
-			struct v4l2_buffer buf;
-			fd_set read_fds;
-			fd_set exception_fds;
-			char ch = '.';
-			int ret;
-
-			if (use_poll) {
-				struct timeval tv;
-				int r;
-
-				FD_ZERO(&read_fds);
-				FD_SET(fd, &read_fds);
-				FD_ZERO(&exception_fds);
-				FD_SET(fd, &exception_fds);
-
-				/* Timeout. */
-				tv.tv_sec = 2;
-				tv.tv_usec = 0;
-
-				r = select(fd + 1, &read_fds, NULL, &exception_fds, &tv);
-
-				if (r == -1) {
-					if (EINTR == errno)
-						continue;
-					fprintf(stderr, "select error: %s\n",
-							strerror(errno));
-					return;
-				}
-
-				if (r == 0) {
-					fprintf(stderr, "select timeout\n");
+		else {
+			buffer_lengths[i] = buf.length;
+			if (is_mmap) {
+				buffers[i] = mmap(NULL, buf.length,
+						  PROT_READ | PROT_WRITE, MAP_SHARED, fd, buf.m.offset);
+
+				if (buffers[i] == MAP_FAILED) {
+					fprintf(stderr, "mmap failed\n");
 					return;
 				}
 			}
+			else {
+				buffers[i] = calloc(1, buf.length);
+				buf.m.userptr = (unsigned long)buffers[i];
+			}
+		}
+		if (doioctl(fd, VIDIOC_QBUF, &buf))
+			return;
+	}
+}
 
-			if (FD_ISSET(fd, &exception_fds)) {
-				struct v4l2_event ev;
+static void do_setup_out_buffers(int fd, struct v4l2_requestbuffers *reqbufs,
+				 bool is_mplane, unsigned num_planes, bool is_mmap,
+				 void *buffers[], unsigned buffer_lengths[], FILE *fin)
+{
+	struct v4l2_format fmt;
+	memset(&fmt, 0, sizeof(fmt));
+	fmt.type = reqbufs->type;
+	doioctl(fd, VIDIOC_G_FMT, &fmt);
+
+	if (!precalculate_bars(fmt.fmt.pix.pixelformat, stream_pat % NUM_PATTERNS)) {
+		fprintf(stderr, "unsupported pixelformat\n");
+		return;
+	}
 
-				while (!ioctl(fd, VIDIOC_DQEVENT, &ev)) {
-					if (ev.type != V4L2_EVENT_EOS)
-						continue;
-					eos = true;
-					break;
-				}
-			}
-			if (!FD_ISSET(fd, &read_fds))
-				continue;
+	for (unsigned i = 0; i < reqbufs->count; i++) {
+		struct v4l2_plane planes[VIDEO_MAX_PLANES];
+		struct v4l2_buffer buf;
 
-			memset(&buf, 0, sizeof(buf));
-			memset(planes, 0, sizeof(planes));
-			buf.type = reqbufs.type;
-			buf.memory = reqbufs.memory;
-			if (is_mplane) {
-				buf.m.planes = planes;
-				buf.length = VIDEO_MAX_PLANES;
-			}
+		memset(&buf, 0, sizeof(buf));
+		memset(planes, 0, sizeof(planes));
+		buf.type = reqbufs->type;
+		buf.memory = reqbufs->memory;
+		buf.index = i;
+		if (is_mplane) {
+			buf.m.planes = planes;
+			buf.length = VIDEO_MAX_PLANES;
+		}
+		if (doioctl(fd, VIDIOC_QUERYBUF, &buf))
+			return;
 
-			ret = test_ioctl(fd, VIDIOC_DQBUF, &buf);
-			if (ret < 0 && errno == EAGAIN)
-				continue;
-			if (ret < 0) {
-				fprintf(stderr, "%s: failed: %s\n", "VIDIOC_DQBUF", strerror(errno));
-				return;
-			}
-			if (fout && !stream_skip) {
-				for (unsigned j = 0; j < num_planes; j++) {
-					unsigned p = buf.index * num_planes + j;
-					unsigned used = is_mplane ? planes[j].bytesused : buf.bytesused;
-					unsigned offset = is_mplane ? planes[j].data_offset : 0;
-					unsigned sz;
-					
-					if (offset > used) {
-						// Should never happen
-						fprintf(stderr, "offset %d > used %d!\n",
-								offset, used);
-						offset = 0;
-					}
-					used -= offset;
-					sz = fwrite((char *)buffers[p] + offset, 1, used, fout);
+		if (is_mplane) {
+			num_planes = buf.length;
+			for (unsigned j = 0; j < num_planes; j++) {
+				unsigned p = i * num_planes + j;
 
-					if (sz != used)
-						fprintf(stderr, "%u != %u\n", sz, used);
-				}
-			}
-			if (buf.flags & V4L2_BUF_FLAG_KEYFRAME)
-				ch = 'K';
-			else if (buf.flags & V4L2_BUF_FLAG_PFRAME)
-				ch = 'P';
-			else if (buf.flags & V4L2_BUF_FLAG_BFRAME)
-				ch = 'B';
-			if (verbose)
-				print_buffer(stderr, buf);
-			if (test_ioctl(fd, VIDIOC_QBUF, &buf))
-				return;
+				buffer_lengths[p] = planes[j].length;
+				buf.m.planes[j].bytesused = planes[j].length;
+				if (is_mmap) {
+					buffers[p] = mmap(NULL, planes[j].length,
+							  PROT_READ | PROT_WRITE, MAP_SHARED,
+							  fd, planes[j].m.mem_offset);
 
-			if (!verbose) {
-				fprintf(stderr, "%c", ch);
-				fflush(stderr);
+					if (buffers[p] == MAP_FAILED) {
+						fprintf(stderr, "mmap failed\n");
+						return;
+					}
+				}
+				else {
+					buffers[p] = calloc(1, planes[j].length);
+					planes[j].m.userptr = (unsigned long)buffers[p];
+				}
 			}
-
-			if (count == 0) {
-				gettimeofday(&tv_last, NULL);
-			} else {
-				struct timeval tv_cur, res;
-
-				gettimeofday(&tv_cur, NULL);
-				timersub(&tv_cur, &tv_last, &res);
-				if (res.tv_sec) {
-					unsigned fps = (100 * (count - last)) /
-						(res.tv_sec * 100 + res.tv_usec / 10000);
-					last = count;
-					tv_last = tv_cur;
-					fprintf(stderr, " %d fps\n", fps);
+			// TODO fill_buffer_mp(buffers[i], &fmt.fmt.pix_mp);
+			if (fin)
+				fill_buffer_from_file(buffers, buffer_lengths,
+						      buf.index, num_planes, fin);
+		}
+		else {
+			buffer_lengths[i] = buf.length;
+			buf.bytesused = buf.length;
+			if (is_mmap) {
+				buffers[i] = mmap(NULL, buf.length,
+						  PROT_READ | PROT_WRITE, MAP_SHARED, fd, buf.m.offset);
+
+				if (buffers[i] == MAP_FAILED) {
+					fprintf(stderr, "mmap failed\n");
+					return;
 				}
 			}
-			count++;
-			if (stream_skip) {
-				stream_skip--;
-				continue;
+			else {
+				buffers[i] = calloc(1, buf.length);
+				buf.m.userptr = (unsigned long)buffers[i];
 			}
-			if (stream_count == 0)
-				continue;
-			if (--stream_count == 0)
-				break;
+			if (!fin || !fill_buffer_from_file(buffers, buffer_lengths,
+							   buf.index, num_planes, fin))
+				fill_buffer(buffers[i], &fmt.fmt.pix);
 		}
-		doioctl(fd, VIDIOC_STREAMOFF, &type);
-		fcntl(fd, F_SETFL, fd_flags);
-		fprintf(stderr, "\n");
+		if (doioctl(fd, VIDIOC_QBUF, &buf))
+			return;
+	}
+}
 
-		for (unsigned i = 0; i < reqbufs.count; i++) {
-			for (unsigned j = 0; j < num_planes; j++) {
-				unsigned p = i * num_planes + j;
+static void do_release_buffers(struct v4l2_requestbuffers *reqbufs,
+			       unsigned num_planes, bool is_mmap,
+			       void *buffers[], unsigned buffer_lengths[])
+{
+	for (unsigned i = 0; i < reqbufs->count; i++) {
+		for (unsigned j = 0; j < num_planes; j++) {
+			unsigned p = i * num_planes + j;
 
-				if (is_mmap)
-					munmap(buffers[p], buffer_lengths[p]);
-				else
-					free(buffers[p]);
-			}
+			if (is_mmap)
+				munmap(buffers[p], buffer_lengths[p]);
+			else
+				free(buffers[p]);
 		}
-		if (fout && fout != stdout)
-			fclose(fout);
 	}
-	
-	if (options[OptStreamOutMmap] || options[OptStreamOutUser]) {
-		struct v4l2_format fmt;
-		struct v4l2_requestbuffers reqbufs;
-		int fd_flags = fcntl(fd, F_GETFL);
-		bool is_mplane = capabilities &
-			(V4L2_CAP_VIDEO_OUTPUT_MPLANE |
-			 V4L2_CAP_VIDEO_M2M_MPLANE);
-		bool is_mmap = options[OptStreamOutMmap];
-		bool use_poll = options[OptStreamPoll];
-		__u32 type = is_mplane ?
-			V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE : V4L2_BUF_TYPE_VIDEO_OUTPUT;
-		FILE *fin = NULL;
-		unsigned num_planes = 1;
-
-		memset(&fmt, 0, sizeof(fmt));
-		fmt.type = type;
-		doioctl(fd, VIDIOC_G_FMT, &fmt);
-
-		if (!precalculate_bars(fmt.fmt.pix.pixelformat, stream_pat % NUM_PATTERNS)) {
-			fprintf(stderr, "unsupported pixelformat\n");
-			return;
-		}
+}
 
-		memset(&reqbufs, 0, sizeof(reqbufs));
-		reqbufs.count = reqbufs_count;
-		reqbufs.type = type;
-		reqbufs.memory = is_mmap ? V4L2_MEMORY_MMAP : V4L2_MEMORY_USERPTR;
+static int do_handle_cap(int fd, struct v4l2_requestbuffers *reqbufs,
+			 bool is_mplane, unsigned num_planes,
+			 void *buffers[], unsigned buffer_lengths[], FILE *fout,
+			 unsigned *count, unsigned *last, struct timeval *tv_last)
+{
+	char ch = '+';
+	int ret;
+
+	struct v4l2_plane planes[VIDEO_MAX_PLANES];
+	struct v4l2_buffer buf;
+	memset(&buf, 0, sizeof(buf));
+	memset(planes, 0, sizeof(planes));
+
+	buf.type = reqbufs->type;
+	buf.memory = reqbufs->memory;
+	if (is_mplane) {
+		buf.m.planes = planes;
+		buf.length = VIDEO_MAX_PLANES;
+	}
 
-		if (file) {
-			if (!strcmp(file, "-"))
-				fin = stdin;
-			else
-				fin = fopen(file, "r");
+	ret = test_ioctl(fd, VIDIOC_DQBUF, &buf);
+	if (ret < 0 && errno == EAGAIN)
+		return 0;
+	if (ret < 0) {
+		fprintf(stderr, "%s: failed: %s\n", "VIDIOC_DQBUF", strerror(errno));
+		return -1;
+	}
+	if (fout && !stream_skip) {
+		for (unsigned j = 0; j < num_planes; j++) {
+			unsigned p = buf.index * num_planes + j;
+			unsigned used = is_mplane ? planes[j].bytesused : buf.bytesused;
+			unsigned offset = is_mplane ? planes[j].data_offset : 0;
+			unsigned sz;
+
+			if (offset > used) {
+				// Should never happen
+				fprintf(stderr, "offset %d > used %d!\n",
+					offset, used);
+				offset = 0;
+			}
+			used -= offset;
+			sz = fwrite((char *)buffers[p] + offset, 1, used, fout);
+
+			if (sz != used)
+				fprintf(stderr, "%u != %u\n", sz, used);
 		}
+	}
+	if (buf.flags & V4L2_BUF_FLAG_KEYFRAME)
+		ch = 'K';
+	else if (buf.flags & V4L2_BUF_FLAG_PFRAME)
+		ch = 'P';
+	else if (buf.flags & V4L2_BUF_FLAG_BFRAME)
+		ch = 'B';
+	if (verbose)
+		print_buffer(stderr, buf);
+	if (test_ioctl(fd, VIDIOC_QBUF, &buf))
+		return -1;
+
+	if (!verbose) {
+		fprintf(stderr, "%c", ch);
+		fflush(stderr);
+	}
 
-		if (doioctl(fd, VIDIOC_REQBUFS, &reqbufs))
-			return;
+	if (*count == 0) {
+		gettimeofday(tv_last, NULL);
+	}
+	else {
+		struct timeval tv_cur, res;
+
+		gettimeofday(&tv_cur, NULL);
+		timersub(&tv_cur, tv_last, &res);
+		if (res.tv_sec) {
+			unsigned fps = (100 * (*count - *last)) /
+				(res.tv_sec * 100 + res.tv_usec / 10000);
+			*last = *count;
+			*tv_last = tv_cur;
+			fprintf(stderr, " %d fps\n", fps);
+		}
+	}
+	*count += 1;
+	if (stream_skip) {
+		stream_skip--;
+		return 0;
+	}
+	if (stream_count == 0)
+		return 0;
+	if (--stream_count == 0)
+		return -1;
 
-		void *buffers[reqbufs.count * VIDEO_MAX_PLANES];
-		unsigned buffer_lengths[reqbufs.count * VIDEO_MAX_PLANES];
-		
-		for (unsigned i = 0; i < reqbufs.count; i++) {
-			struct v4l2_plane planes[VIDEO_MAX_PLANES];
-			struct v4l2_buffer buf;
+	return 0;
+}
 
-			memset(&buf, 0, sizeof(buf));
-			memset(planes, 0, sizeof(planes));
-			buf.type = reqbufs.type;
-			buf.memory = reqbufs.memory;
-			buf.index = i;
-			if (is_mplane) {
-				buf.m.planes = planes;
-				buf.length = VIDEO_MAX_PLANES;
-			}
-			if (doioctl(fd, VIDIOC_QUERYBUF, &buf))
-				return;
+static int do_handle_out(int fd, struct v4l2_requestbuffers *reqbufs,
+			 bool is_mplane, unsigned num_planes,
+			 void *buffers[], unsigned buffer_lengths[], FILE *fin,
+			 unsigned *count, unsigned *last, struct timeval *tv_last)
+{
+	int ret;
+
+	struct v4l2_plane planes[VIDEO_MAX_PLANES];
+	struct v4l2_buffer buf;
+
+	memset(&buf, 0, sizeof(buf));
+	memset(planes, 0, sizeof(planes));
+	buf.type = reqbufs->type;
+	buf.memory = reqbufs->memory;
+	if (is_mplane) {
+		buf.m.planes = planes;
+		buf.length = VIDEO_MAX_PLANES;
+	}
 
-			if (is_mplane) {
-				num_planes = buf.length;
-				for (unsigned j = 0; j < num_planes; j++) {
-					unsigned p = i * num_planes + j;
-
-					buffer_lengths[p] = planes[j].length;
-					buf.m.planes[j].bytesused = planes[j].length;
-					if (is_mmap) {
-						buffers[p] = mmap(NULL, planes[j].length,
-								PROT_READ | PROT_WRITE, MAP_SHARED,
-								fd, planes[j].m.mem_offset);
-
-						if (buffers[p] == MAP_FAILED) {
-							fprintf(stderr, "mmap failed\n");
-							return;
-						}
-					} else {
-						buffers[p] = calloc(1, planes[j].length);
-						planes[j].m.userptr = (unsigned long)buffers[p];
-					}
-				}
-				// TODO fill_buffer_mp(buffers[i], &fmt.fmt.pix_mp);
-				if (fin)
-					fill_buffer_from_file(buffers, buffer_lengths,
-						buf.index, num_planes, fin);
-			} else {
-				buffer_lengths[i] = buf.length;
-				buf.bytesused = buf.length;
-				if (is_mmap) {
-					buffers[i] = mmap(NULL, buf.length,
-							PROT_READ | PROT_WRITE, MAP_SHARED, fd, buf.m.offset);
+	ret = test_ioctl(fd, VIDIOC_DQBUF, &buf);
+	if (ret < 0 && errno == EAGAIN)
+		return 0;
+	if (ret < 0) {
+		fprintf(stderr, "%s: failed: %s\n", "VIDIOC_DQBUF", strerror(errno));
+		return -1;
+	}
+	if (fin && !fill_buffer_from_file(buffers, buffer_lengths,
+					  buf.index, num_planes, fin))
+		return -1;
+	if (is_mplane) {
+		for (unsigned j = 0; j < buf.length; j++) buf.m.planes[j].bytesused = buf.m.planes[j].length;
+	}
+	else {
+		buf.bytesused = buf.length;
+	}
+	if (test_ioctl(fd, VIDIOC_QBUF, &buf))
+		return -1;
 
-					if (buffers[i] == MAP_FAILED) {
-						fprintf(stderr, "mmap failed\n");
-						return;
-					}
-				} else {
-					buffers[i] = calloc(1, buf.length);
-					buf.m.userptr = (unsigned long)buffers[i];
-				}
-				if (!fin || !fill_buffer_from_file(buffers, buffer_lengths,
-						buf.index, num_planes, fin))
-					fill_buffer(buffers[i], &fmt.fmt.pix);
-			}
-			if (doioctl(fd, VIDIOC_QBUF, &buf))
-				return;
+	fprintf(stderr, "-");
+	fflush(stderr);
+
+	if (*count == 0) {
+		gettimeofday(tv_last, NULL);
+	}
+	else {
+		struct timeval tv_cur, res;
+
+		gettimeofday(&tv_cur, NULL);
+		timersub(&tv_cur, tv_last, &res);
+		if (res.tv_sec) {
+			unsigned fps = (100 * (*count - *last)) /
+				(res.tv_sec * 100 + res.tv_usec / 10000);
+			*last = *count;
+			*tv_last = tv_cur;
+			fprintf(stderr, " %d fps\n", fps);
 		}
+	}
+	*count += 1;
+	if (stream_count == 0)
+		return 0;
+	if (--stream_count == 0)
+		return -1;
 
-		type = reqbufs.type;
-		if (doioctl(fd, VIDIOC_STREAMON, &type))
-			return;
+	return 0;
+}
+
+void streaming_set_cap(int fd)
+{
+	struct v4l2_requestbuffers reqbufs;
+	struct v4l2_event_subscription sub;
+	int fd_flags = fcntl(fd, F_GETFL);
+	bool is_mplane = capabilities &
+			(V4L2_CAP_VIDEO_CAPTURE_MPLANE |
+				 V4L2_CAP_VIDEO_M2M_MPLANE);
+	bool is_mmap = options[OptStreamMmap];
+	bool use_poll = options[OptStreamPoll];
+	__u32 type = is_mplane ?
+		V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE : V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	FILE *fout = NULL;
+	unsigned num_planes = 1;
+
+	memset(&reqbufs, 0, sizeof(reqbufs));
+	reqbufs.count = reqbufs_count;
+	reqbufs.type = type;
+	reqbufs.memory = is_mmap ? V4L2_MEMORY_MMAP : V4L2_MEMORY_USERPTR;
+	memset(&sub, 0, sizeof(sub));
+	sub.type = V4L2_EVENT_EOS;
+	ioctl(fd, VIDIOC_SUBSCRIBE_EVENT, &sub);
+
+	if (file_cap) {
+		if (!strcmp(file_cap, "-"))
+			fout = stdout;
+		else
+			fout = fopen(file_cap, "w+");
+	}
 
-		if (use_poll)
-			fcntl(fd, F_SETFL, fd_flags | O_NONBLOCK);
+	if (doioctl(fd, VIDIOC_REQBUFS, &reqbufs))
+		return;
 
-		unsigned count = 0, last = 0;
-		struct timeval tv_last;
+	void *buffers[reqbufs.count * VIDEO_MAX_PLANES];
+	unsigned buffer_lengths[reqbufs.count * VIDEO_MAX_PLANES];
 
-		for (;;) {
-			struct v4l2_plane planes[VIDEO_MAX_PLANES];
-			struct v4l2_buffer buf;
-			int ret;
+	do_setup_cap_buffers(fd, &reqbufs, is_mplane, num_planes,
+			     is_mmap, buffers, buffer_lengths);
 
-			if (use_poll) {
-				fd_set fds;
-				struct timeval tv;
-				int r;
+	type = reqbufs.type;
+	if (doioctl(fd, VIDIOC_STREAMON, &type))
+		return;
 
-				FD_ZERO(&fds);
-				FD_SET(fd, &fds);
+	if (use_poll)
+		fcntl(fd, F_SETFL, fd_flags | O_NONBLOCK);
 
-				/* Timeout. */
-				tv.tv_sec = 2;
-				tv.tv_usec = 0;
+	unsigned count = 0, last = 0;
+	struct timeval tv_last;
+	bool eos = false;
 
-				r = select(fd + 1, NULL, &fds, NULL, &tv);
+	while (!eos) {
+		fd_set read_fds;
+		fd_set exception_fds;
+		int r;
 
-				if (r == -1) {
-					if (EINTR == errno)
-						continue;
-					fprintf(stderr, "select error: %s\n",
-							strerror(errno));
-					return;
-				}
+		if (use_poll) {
+			struct timeval tv;
 
-				if (r == 0) {
-					fprintf(stderr, "select timeout\n");
-					return;
-				}
-			}
+			FD_ZERO(&read_fds);
+			FD_SET(fd, &read_fds);
+			FD_ZERO(&exception_fds);
+			FD_SET(fd, &exception_fds);
 
-			memset(&buf, 0, sizeof(buf));
-			memset(planes, 0, sizeof(planes));
-			buf.type = reqbufs.type;
-			buf.memory = reqbufs.memory;
-			if (is_mplane) {
-				buf.m.planes = planes;
-				buf.length = VIDEO_MAX_PLANES;
+			/* Timeout. */
+			tv.tv_sec = 2;
+			tv.tv_usec = 0;
+
+			r = select(fd + 1, &read_fds, NULL, &exception_fds, &tv);
+
+			if (r == -1) {
+				if (EINTR == errno)
+					continue;
+				fprintf(stderr, "select error: %s\n",
+					strerror(errno));
+				return;
 			}
 
-			ret = test_ioctl(fd, VIDIOC_DQBUF, &buf);
-			if (ret < 0 && errno == EAGAIN)
-				continue;
-			if (ret < 0) {
-				fprintf(stderr, "%s: failed: %s\n", "VIDIOC_DQBUF", strerror(errno));
+			if (r == 0) {
+				fprintf(stderr, "select timeout\n");
 				return;
 			}
-			if (fin && !fill_buffer_from_file(buffers, buffer_lengths,
-					buf.index, num_planes, fin))
+		}
+
+		if (FD_ISSET(fd, &exception_fds)) {
+			struct v4l2_event ev;
+
+			while (!ioctl(fd, VIDIOC_DQEVENT, &ev)) {
+				if (ev.type != V4L2_EVENT_EOS)
+					continue;
+				eos = true;
 				break;
-			if (is_mplane) {
-				for (unsigned j = 0; j < buf.length; j++)
-					buf.m.planes[j].bytesused = buf.m.planes[j].length;
-			} else {
-				buf.bytesused = buf.length;
 			}
-			if (test_ioctl(fd, VIDIOC_QBUF, &buf))
-				return;
+		}
 
-			fprintf(stderr, ".");
-			fflush(stderr);
-
-			if (count == 0) {
-				gettimeofday(&tv_last, NULL);
-			} else {
-				struct timeval tv_cur, res;
-
-				gettimeofday(&tv_cur, NULL);
-				timersub(&tv_cur, &tv_last, &res);
-				if (res.tv_sec) {
-					unsigned fps = (100 * (count - last)) /
-						(res.tv_sec * 100 + res.tv_usec / 10000);
-					last = count;
-					tv_last = tv_cur;
-					fprintf(stderr, " %d fps\n", fps);
-				}
-			}
-			count++;
-			if (stream_count == 0)
-				continue;
-			if (--stream_count == 0)
+		if (FD_ISSET(fd, &read_fds)) {
+			r  = do_handle_cap(fd, &reqbufs, is_mplane, num_planes,
+					   buffers, buffer_lengths, fout,
+					   &count, &last, &tv_last);
+			if (r == -1)
 				break;
 		}
-		if (options[OptDecoderCmd]) {
-			doioctl(fd, VIDIOC_DECODER_CMD, &dec_cmd);
-			options[OptDecoderCmd] = false;
-		}
-		doioctl(fd, VIDIOC_STREAMOFF, &type);
-		fcntl(fd, F_SETFL, fd_flags);
-		fprintf(stderr, "\n");
 
-		for (unsigned i = 0; i < reqbufs.count; i++) {
-			for (unsigned j = 0; j < num_planes; j++) {
-				unsigned p = i * num_planes + j;
+	}
+	doioctl(fd, VIDIOC_STREAMOFF, &type);
+	fcntl(fd, F_SETFL, fd_flags);
+	fprintf(stderr, "\n");
+
+	do_release_buffers(&reqbufs, num_planes, is_mmap, buffers,
+			   buffer_lengths);
+
+	if (fout && fout != stdout)
+		fclose(fout);
+}
+
+void streaming_set_out(int fd)
+{
+	struct v4l2_requestbuffers reqbufs;
+	int fd_flags = fcntl(fd, F_GETFL);
+	bool is_mplane = capabilities &
+			(V4L2_CAP_VIDEO_OUTPUT_MPLANE |
+				 V4L2_CAP_VIDEO_M2M_MPLANE);
+	bool is_mmap = options[OptStreamOutMmap];
+	bool use_poll = options[OptStreamPoll];
+	__u32 type = is_mplane ?
+		V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE : V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	FILE *fin = NULL;
+	unsigned num_planes = 1;
+
+
+	memset(&reqbufs, 0, sizeof(reqbufs));
+	reqbufs.count = reqbufs_count;
+	reqbufs.type = type;
+	reqbufs.memory = is_mmap ? V4L2_MEMORY_MMAP : V4L2_MEMORY_USERPTR;
+
+	if (file_out) {
+		if (!strcmp(file_out, "-"))
+			fin = stdin;
+		else
+			fin = fopen(file_out, "r");
+	}
+
+	if (doioctl(fd, VIDIOC_REQBUFS, &reqbufs))
+		return;
+
+	void *buffers[reqbufs.count * VIDEO_MAX_PLANES];
+	unsigned buffer_lengths[reqbufs.count * VIDEO_MAX_PLANES];
+
+	do_setup_out_buffers(fd, &reqbufs, is_mplane, num_planes,
+			     is_mmap, buffers, buffer_lengths, fin);
+
+	type = reqbufs.type;
+	if (doioctl(fd, VIDIOC_STREAMON, &type))
+		return;
+
+	if (use_poll)
+		fcntl(fd, F_SETFL, fd_flags | O_NONBLOCK);
 
-				if (is_mmap)
-					munmap(buffers[p], buffer_lengths[p]);
-				else
-					free(buffers[p]);
+	unsigned count = 0, last = 0;
+	struct timeval tv_last;
+
+	for (;;) {
+		int r;
+
+		if (use_poll) {
+			fd_set fds;
+			struct timeval tv;
+
+			FD_ZERO(&fds);
+			FD_SET(fd, &fds);
+
+			/* Timeout. */
+			tv.tv_sec = 2;
+			tv.tv_usec = 0;
+
+			r = select(fd + 1, NULL, &fds, NULL, &tv);
+
+			if (r == -1) {
+				if (EINTR == errno)
+					continue;
+				fprintf(stderr, "select error: %s\n",
+					strerror(errno));
+				return;
+			}
+
+			if (r == 0) {
+				fprintf(stderr, "select timeout\n");
+				return;
 			}
 		}
-		if (fin && fin != stdin)
-			fclose(fin);
+		r  = do_handle_out(fd, &reqbufs, is_mplane, num_planes,
+				   buffers, buffer_lengths, fin,
+				   &count, &last, &tv_last);
+		if (r == -1)
+			break;
+
+	}
+
+	if (options[OptDecoderCmd]) {
+		doioctl(fd, VIDIOC_DECODER_CMD, &dec_cmd);
+		options[OptDecoderCmd] = false;
 	}
+	doioctl(fd, VIDIOC_STREAMOFF, &type);
+	fcntl(fd, F_SETFL, fd_flags);
+	fprintf(stderr, "\n");
+
+	do_release_buffers(&reqbufs, num_planes, is_mmap, buffers,
+			   buffer_lengths);
+
+	if (fin && fin != stdin)
+		fclose(fin);
+}
+
+void streaming_set(int fd)
+{
+	bool do_cap = options[OptStreamMmap] || options[OptStreamUser];
+	bool do_out = options[OptStreamOutMmap] || options[OptStreamOutUser];
+
+	if (do_cap)
+		streaming_set_cap(fd);
+	else if (do_out)
+		streaming_set_out(fd);
 }
 
 void streaming_list(int fd)
-- 
1.8.1.5

