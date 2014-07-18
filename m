Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46706 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754906AbaGRT3p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 15:29:45 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 1/2] v4l: videodev2: add buffer size to SDR format
Date: Fri, 18 Jul 2014 22:29:28 +0300
Message-Id: <1405711769-8463-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add buffer size field to struct v4l2_sdr_format. It is used for
negotiate streaming buffer size between application and driver.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 include/uapi/linux/videodev2.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 25ab057..0dd5ffb 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -1724,10 +1724,12 @@ struct v4l2_pix_format_mplane {
 /**
  * struct v4l2_sdr_format - SDR format definition
  * @pixelformat:	little endian four character code (fourcc)
+ * @buffersize:		maximum size in bytes required for data
  */
 struct v4l2_sdr_format {
 	__u32				pixelformat;
-	__u8				reserved[28];
+	__u32				buffersize;
+	__u8				reserved[24];
 } __attribute__ ((packed));
 
 /**
-- 
1.9.3

