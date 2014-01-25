Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35473 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbaAYRLF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 12:11:05 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 24/52] v4l: 1 Hz resolution flag for tuners
Date: Sat, 25 Jan 2014 19:10:18 +0200
Message-Id: <1390669846-8131-25-git-send-email-crope@iki.fi>
In-Reply-To: <1390669846-8131-1-git-send-email-crope@iki.fi>
References: <1390669846-8131-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2_TUNER_CAP_1HZ for 1 Hz resolution.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 9dc79d1..1cf2076 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1341,6 +1341,7 @@ struct v4l2_modulator {
 #define V4L2_TUNER_CAP_RDS_CONTROLS	0x0200
 #define V4L2_TUNER_CAP_FREQ_BANDS	0x0400
 #define V4L2_TUNER_CAP_HWSEEK_PROG_LIM	0x0800
+#define V4L2_TUNER_CAP_1HZ		0x1000
 
 /*  Flags for the 'rxsubchans' field */
 #define V4L2_TUNER_SUB_MONO		0x0001
-- 
1.8.5.3

