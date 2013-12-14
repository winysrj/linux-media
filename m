Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51410 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810Ab3LNQQY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Dec 2013 11:16:24 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC v2 4/7] v4l: 1 Hz resolution flag for tuners
Date: Sat, 14 Dec 2013 18:15:26 +0200
Message-Id: <1387037729-1977-5-git-send-email-crope@iki.fi>
In-Reply-To: <1387037729-1977-1-git-send-email-crope@iki.fi>
References: <1387037729-1977-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2_TUNER_CAP_1HZ for 1 Hz resolution.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 include/uapi/linux/videodev2.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index c3e7780..619f83f 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1349,6 +1349,7 @@ struct v4l2_modulator {
 #define V4L2_TUNER_CAP_RDS_CONTROLS	0x0200
 #define V4L2_TUNER_CAP_FREQ_BANDS	0x0400
 #define V4L2_TUNER_CAP_HWSEEK_PROG_LIM	0x0800
+#define V4L2_TUNER_CAP_1HZ		0x1000
 
 /*  Flags for the 'rxsubchans' field */
 #define V4L2_TUNER_SUB_MONO		0x0001
-- 
1.8.4.2

