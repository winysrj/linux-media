Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56371 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab3KJRPe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Nov 2013 12:15:34 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 1/2] v4l2: add two pixel format for SDR
Date: Sun, 10 Nov 2013 19:15:15 +0200
Message-Id: <1384103716-4690-2-git-send-email-crope@iki.fi>
In-Reply-To: <1384103716-4690-1-git-send-email-crope@iki.fi>
References: <1384103716-4690-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These are used for converting / streaming I/Q data from SDR.
* float 32-bit
* unsigned 8-bit

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 include/uapi/linux/videodev2.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 437f1b0..14299a6 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -431,6 +431,10 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SE401      v4l2_fourcc('S', '4', '0', '1') /* se401 janggu compressed rgb */
 #define V4L2_PIX_FMT_S5C_UYVY_JPG v4l2_fourcc('S', '5', 'C', 'I') /* S5C73M3 interleaved UYVY/JPEG */
 
+/* SDR */
+#define V4L2_PIX_FMT_FLOAT    v4l2_fourcc('D', 'F', '3', '2') /* float 32-bit */
+#define V4L2_PIX_FMT_U8       v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
+
 /*
  *	F O R M A T   E N U M E R A T I O N
  */
-- 
1.8.4.2

