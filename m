Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2345 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935937Ab3DHOHl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 10:07:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Tzu-Jung Lee" <roylee17@gmail.com>
Subject: Re: Question regarding developing V4L2 device driver and Streaming IO in v4l2-ctl
Date: Mon, 8 Apr 2013 16:07:23 +0200
Cc: linux-media@vger.kernel.org, hans.verkuil@cisco.com,
	Kamil Debski <k.debski@samsung.com>
References: <CAEvN+1iN_fZ-Gu904LTLYf8CZs9ZfZm03bfuE4Ev3frEgOLShg@mail.gmail.com> <201304061518.50347.hverkuil@xs4all.nl> <CAEvN+1gLBvJNBb8RjkG_TDk6XXY7-ydwg4f3SAaZmr6ESPAsXA@mail.gmail.com>
In-Reply-To: <CAEvN+1gLBvJNBb8RjkG_TDk6XXY7-ydwg4f3SAaZmr6ESPAsXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304081607.23357.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat April 6 2013 18:23:46 Tzu-Jung Lee wrote:
> Hi Hans,
> 
> Thanks for the pointer to the EVENT and the ENC/DEC CMD :)
> I just noticed that v4l2-ctl has a command category for them as well.
> 
> If I configure the codec as a transcoder, and would like to transcode
> a input bitstream with v4l2-ctl,
> I should use the following command instance to test our driver and
> device, right?
> 
>   1) Feed input bitstream and start decoder, and stop the decoder as
> soon as the input reaches EOF.
> 
>            v4l2-ctl --decoder-cmd=start --stream-from=orig.h264 &&
> v4l2-ctl --decoder-cmd=stop &
> 
> 
>   2) Start encoder and save the transcoded bitstream
> 
>          v4l2-ctl --encoder-cmd=start --stream-to=xcoded.h264 &
> 
> 
>   3) Currently, the STREAM I/O of v4l2-ctl is counter based, so the 2)
> does not end until 2-second timeout.
>       In this case, for a non-timeout solution,  we'll need a event
> waiting and terminate the process.
> 
>          v4l2-ctl --wait-for-event=eos && kill "encoding instance of v4l2-ctl"

None of this will really work with the current v4l2-ctl.

But try the patch below for v4l2-ctl: if you combine streaming with --decoder-cmd
then instead of doing a STREAMOFF it will call the decoder command. And the
encoder now listens to the EOS event.

Note that --en/decoder-cmd=start isn't necessary: STREAMON should call that
implicitly as per the spec.

Let me know if this works!

Regards,

	Hans

diff --git a/utils/v4l2-ctl/v4l2-ctl-misc.cpp b/utils/v4l2-ctl/v4l2-ctl-misc.cpp
index da39dda..6857fff 100644
--- a/utils/v4l2-ctl/v4l2-ctl-misc.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-misc.cpp
@@ -21,10 +21,10 @@
 
 #include "v4l2-ctl.h"
 
+struct v4l2_decoder_cmd dec_cmd; /* (try_)decoder_cmd */
+static struct v4l2_encoder_cmd enc_cmd; /* (try_)encoder_cmd */
 static struct v4l2_jpegcompression jpegcomp; /* jpeg compression */
 static struct v4l2_streamparm parm;	/* get/set parm */
-static struct v4l2_encoder_cmd enc_cmd; /* (try_)encoder_cmd */
-static struct v4l2_decoder_cmd dec_cmd; /* (try_)decoder_cmd */
 static double fps = 0;			/* set framerate speed, in fps */
 static double output_fps = 0;		/* set framerate speed, in fps */
 
diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index a6ea8b3..408b2a7 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -530,6 +530,7 @@ void streaming_set(int fd)
 {
 	if (options[OptStreamMmap] || options[OptStreamUser]) {
 		struct v4l2_requestbuffers reqbufs;
+		struct v4l2_event_subscription sub;
 		int fd_flags = fcntl(fd, F_GETFL);
 		bool is_mplane = capabilities &
 			(V4L2_CAP_VIDEO_CAPTURE_MPLANE |
@@ -545,6 +546,9 @@ void streaming_set(int fd)
 		reqbufs.count = reqbufs_count;
 		reqbufs.type = type;
 		reqbufs.memory = is_mmap ? V4L2_MEMORY_MMAP : V4L2_MEMORY_USERPTR;
+		memset(&sub, 0, sizeof(sub));
+		sub.type = V4L2_EVENT_EOS;
+		ioctl(fd, VIDIOC_SUBSCRIBE_EVENT, &sub);
 
 		if (file) {
 			if (!strcmp(file, "-"))
@@ -623,26 +627,30 @@ void streaming_set(int fd)
 
 		unsigned count = 0, last = 0;
 		struct timeval tv_last;
+		bool eos = false;
 
-		for (;;) {
+		while (!eos) {
 			struct v4l2_plane planes[VIDEO_MAX_PLANES];
 			struct v4l2_buffer buf;
+			fd_set read_fds;
+			fd_set exception_fds;
 			char ch = '.';
 			int ret;
 
 			if (use_poll) {
-				fd_set fds;
 				struct timeval tv;
 				int r;
 
-				FD_ZERO(&fds);
-				FD_SET(fd, &fds);
+				FD_ZERO(&read_fds);
+				FD_SET(fd, &read_fds);
+				FD_ZERO(&exception_fds);
+				FD_SET(fd, &exception_fds);
 
 				/* Timeout. */
 				tv.tv_sec = 2;
 				tv.tv_usec = 0;
 
-				r = select(fd + 1, &fds, NULL, NULL, &tv);
+				r = select(fd + 1, &read_fds, NULL, &exception_fds, &tv);
 
 				if (r == -1) {
 					if (EINTR == errno)
@@ -658,6 +666,19 @@ void streaming_set(int fd)
 				}
 			}
 
+			if (FD_ISSET(fd, &exception_fds)) {
+				struct v4l2_event ev;
+
+				while (!ioctl(fd, VIDIOC_DQEVENT, &ev)) {
+					if (ev.type != V4L2_EVENT_EOS)
+						continue;
+					eos = true;
+					break;
+				}
+			}
+			if (!FD_ISSET(fd, &read_fds))
+				continue;
+
 			memset(&buf, 0, sizeof(buf));
 			memset(planes, 0, sizeof(planes));
 			buf.type = reqbufs.type;
@@ -953,7 +974,11 @@ void streaming_set(int fd)
 			if (--stream_count == 0)
 				break;
 		}
-		doioctl(fd, VIDIOC_STREAMOFF, &type);
+		if (options[OptDecoderCmd])
+			doioctl(fd, VIDIOC_DECODER_CMD, &dec_cmd);
+		else
+			doioctl(fd, VIDIOC_STREAMOFF, &type);
+		options[OptDecoderCmd] = false;
 		fcntl(fd, F_SETFL, fd_flags);
 		fprintf(stderr, "\n");
 
diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
index 6057cce..1601b10 100644
--- a/utils/v4l2-ctl/v4l2-ctl.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl.cpp
@@ -967,8 +967,8 @@ int main(int argc, char **argv)
 	overlay_set(fd);
 	vbi_set(fd);
 	selection_set(fd);
-	misc_set(fd);
 	streaming_set(fd);
+	misc_set(fd);
 
 	/* Get options */
 
diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
index 8d6d50d..146dbe7 100644
--- a/utils/v4l2-ctl/v4l2-ctl.h
+++ b/utils/v4l2-ctl/v4l2-ctl.h
@@ -264,6 +264,8 @@ void selection_set(int fd);
 void selection_get(int fd);
 
 // v4l2-ctl-misc.cpp
+// This one is also used by the streaming code.
+extern struct v4l2_decoder_cmd dec_cmd;
 void misc_usage(void);
 void misc_cmd(int ch, char *optarg);
 void misc_set(int fd);
