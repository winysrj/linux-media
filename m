Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54340 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225AbaAWVJN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jan 2014 16:09:13 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [REVIEW PATCH 07/13] v4l: add device capability flag for SDR receiver
Date: Thu, 23 Jan 2014 23:08:47 +0200
Message-Id: <1390511333-25837-8-git-send-email-crope@iki.fi>
In-Reply-To: <1390511333-25837-1-git-send-email-crope@iki.fi>
References: <1390511333-25837-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDIOC_QUERYCAP IOCTL is used to query device capabilities. Add new
capability flag to inform given device supports SDR capture.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 include/uapi/linux/videodev2.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 27bed7c..27fedfe 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -267,6 +267,8 @@ struct v4l2_capability {
 #define V4L2_CAP_RADIO			0x00040000  /* is a radio device */
 #define V4L2_CAP_MODULATOR		0x00080000  /* has a modulator */
 
+#define V4L2_CAP_SDR_CAPTURE		0x00100000  /* Is a SDR capture device */
+
 #define V4L2_CAP_READWRITE              0x01000000  /* read/write systemcalls */
 #define V4L2_CAP_ASYNCIO                0x02000000  /* async I/O */
 #define V4L2_CAP_STREAMING              0x04000000  /* streaming I/O ioctls */
-- 
1.8.5.3

