Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56756 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab3KQUWZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Nov 2013 15:22:25 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 3/7] v4l2: add signed 8-bit pixel format for SDR
Date: Sun, 17 Nov 2013 22:22:07 +0200
Message-Id: <1384719731-21887-3-git-send-email-crope@iki.fi>
In-Reply-To: <1384719731-21887-1-git-send-email-crope@iki.fi>
References: <1384719731-21887-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is 8-bit unsigned data, byte after byte. Used for streaming SDR
I/Q data from ADC.

V4L2_PIX_FMT_SDR_S8, v4l fourcc "DS08".

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 include/uapi/linux/videodev2.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index ba2a173..35b5731 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -434,6 +434,7 @@ struct v4l2_pix_format {
 /* SDR */
 #define V4L2_PIX_FMT_SDR_FLOAT  v4l2_fourcc('D', 'F', '3', '2') /* float 32-bit */
 #define V4L2_PIX_FMT_SDR_U8     v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
+#define V4L2_PIX_FMT_SDR_S8     v4l2_fourcc('D', 'S', '0', '8') /* signed 8-bit */
 
 /*
  *	F O R M A T   E N U M E R A T I O N
-- 
1.8.4.2

