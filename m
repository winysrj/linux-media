Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58268 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbbAVL2n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2015 06:28:43 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Peter Seiderer <ps.report@gmx.net>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC PATCH 1/2] [media] videodev2: Add V4L2_BUF_FLAG_LAST
Date: Thu, 22 Jan 2015 12:28:37 +0100
Message-Id: <1421926118-29535-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1421926118-29535-1-git-send-email-p.zabel@pengutronix.de>
References: <1421926118-29535-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Peter Seiderer <ps.report@gmx.net>

This v4l2_buffer flag can be used by drivers to mark a capture buffer
as the last generated buffer, for example after a V4L2_DEC_CMD_STOP
command was issued.

Signed-off-by: Peter Seiderer <ps.report@gmx.net>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 include/uapi/linux/videodev2.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index fbdc360..c642c10 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -809,6 +809,8 @@ struct v4l2_buffer {
 #define V4L2_BUF_FLAG_TSTAMP_SRC_MASK		0x00070000
 #define V4L2_BUF_FLAG_TSTAMP_SRC_EOF		0x00000000
 #define V4L2_BUF_FLAG_TSTAMP_SRC_SOE		0x00010000
+/* mem2mem encoder/decoder */
+#define V4L2_BUF_FLAG_LAST			0x00100000
 
 /**
  * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
-- 
2.1.4

