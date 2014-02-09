Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47153 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbaBIGGY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 01:06:24 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/5] v4l2-ctl: implement list SDR buffers command
Date: Sun,  9 Feb 2014 08:05:54 +0200
Message-Id: <1391925954-25975-6-git-send-email-crope@iki.fi>
In-Reply-To: <1391925954-25975-1-git-send-email-crope@iki.fi>
References: <1391925954-25975-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 6 ++++++
 utils/v4l2-ctl/v4l2-ctl.cpp           | 1 +
 utils/v4l2-ctl/v4l2-ctl.h             | 1 +
 3 files changed, 8 insertions(+)

diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
index 13ee8ec..925d73d 100644
--- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
@@ -78,6 +78,8 @@ void streaming_usage(void)
 	       "                     list all sliced VBI buffers [VIDIOC_QUERYBUF]\n"
 	       "  --list-buffers-sliced-vbi-out\n"
 	       "                     list all sliced VBI output buffers [VIDIOC_QUERYBUF]\n"
+	       "  --list-buffers-sdr\n"
+	       "                     list all SDR RX buffers [VIDIOC_QUERYBUF]\n"
 	       );
 }
 
@@ -986,4 +988,8 @@ void streaming_list(int fd)
 	if (options[OptListBuffersSlicedVbiOut]) {
 		list_buffers(fd, V4L2_BUF_TYPE_SLICED_VBI_OUTPUT);
 	}
+
+	if (options[OptListBuffersSdr]) {
+		list_buffers(fd, V4L2_BUF_TYPE_SDR_CAPTURE);
+	}
 }
diff --git a/utils/v4l2-ctl/v4l2-ctl.cpp b/utils/v4l2-ctl/v4l2-ctl.cpp
index 855613c..a602366 100644
--- a/utils/v4l2-ctl/v4l2-ctl.cpp
+++ b/utils/v4l2-ctl/v4l2-ctl.cpp
@@ -198,6 +198,7 @@ static struct option long_options[] = {
 	{"list-buffers-sliced-vbi", no_argument, 0, OptListBuffersSlicedVbi},
 	{"list-buffers-vbi-out", no_argument, 0, OptListBuffersVbiOut},
 	{"list-buffers-sliced-vbi-out", no_argument, 0, OptListBuffersSlicedVbiOut},
+	{"list-buffers-sdr", no_argument, 0, OptListBuffersSdr},
 	{"stream-count", required_argument, 0, OptStreamCount},
 	{"stream-skip", required_argument, 0, OptStreamSkip},
 	{"stream-loop", no_argument, 0, OptStreamLoop},
diff --git a/utils/v4l2-ctl/v4l2-ctl.h b/utils/v4l2-ctl/v4l2-ctl.h
index 108198d..1caac34 100644
--- a/utils/v4l2-ctl/v4l2-ctl.h
+++ b/utils/v4l2-ctl/v4l2-ctl.h
@@ -139,6 +139,7 @@ enum Option {
 	OptListBuffersSlicedVbi,
 	OptListBuffersVbiOut,
 	OptListBuffersSlicedVbiOut,
+	OptListBuffersSdr,
 	OptStreamCount,
 	OptStreamSkip,
 	OptStreamLoop,
-- 
1.8.5.3

