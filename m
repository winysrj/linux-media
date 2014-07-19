Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35199 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183AbaGSAz0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 20:55:26 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] videodev2.h add buffer size field to SDR format
Date: Sat, 19 Jul 2014 03:55:15 +0300
Message-Id: <1405731316-12337-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 include/linux/videodev2.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index ac700c9..17c890d 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -1777,7 +1777,8 @@ struct v4l2_pix_format_mplane {
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

