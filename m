Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52223 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbbEDKvN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 06:51:13 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	kernel@pengutronix.de, Peter Seiderer <ps.report@gmx.net>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v6 2/5] [media] videodev2: Add V4L2_BUF_FLAG_LAST
Date: Mon,  4 May 2015 12:51:05 +0200
Message-Id: <1430736668-28582-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1430736668-28582-1-git-send-email-p.zabel@pengutronix.de>
References: <1430736668-28582-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Seiderer <ps.report@gmx.net>

This v4l2_buffer flag can be used by drivers to mark a capture buffer
as the last generated buffer, for example after a V4L2_DEC_CMD_STOP
command was issued.

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/trace/events/v4l2.h    | 3 ++-
 include/uapi/linux/videodev2.h | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/v4l2.h b/include/trace/events/v4l2.h
index 2011217..89d0497 100644
--- a/include/trace/events/v4l2.h
+++ b/include/trace/events/v4l2.h
@@ -83,7 +83,8 @@ SHOW_FIELD
 		{ V4L2_BUF_FLAG_TIMESTAMP_MASK,	     "TIMESTAMP_MASK" },      \
 		{ V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN,   "TIMESTAMP_UNKNOWN" },   \
 		{ V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC, "TIMESTAMP_MONOTONIC" }, \
-		{ V4L2_BUF_FLAG_TIMESTAMP_COPY,	     "TIMESTAMP_COPY" })
+		{ V4L2_BUF_FLAG_TIMESTAMP_COPY,	     "TIMESTAMP_COPY" },      \
+		{ V4L2_BUF_FLAG_LAST,                "LAST" })
 
 #define show_timecode_flags(flags)					  \
 	__print_flags(flags, "|",					  \
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index fa376f7..0f5a467 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -810,6 +810,8 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_TSTAMP_SRC_MASK		0x00070000
 #define V4L2_BUF_FLAG_TSTAMP_SRC_EOF		0x00000000
 #define V4L2_BUF_FLAG_TSTAMP_SRC_SOE		0x00010000
+/* mem2mem encoder/decoder */
+#define V4L2_BUF_FLAG_LAST			0x00100000
 
 /**
  * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
-- 
2.1.4

