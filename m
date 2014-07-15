Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42992 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678AbaGOBJn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 21:09:43 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 05/18] v4l: uapi: add SDR format CS14
Date: Tue, 15 Jul 2014 04:09:08 +0300
Message-Id: <1405386561-30450-5-git-send-email-crope@iki.fi>
In-Reply-To: <1405386561-30450-1-git-send-email-crope@iki.fi>
References: <1405386561-30450-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2_SDR_FMT_CS14LE - Complex signed 14-bit IQ sample

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 include/uapi/linux/videodev2.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index e1ac240..25ab057 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -440,6 +440,7 @@ struct v4l2_pix_format {
 #define V4L2_SDR_FMT_CU8          v4l2_fourcc('C', 'U', '0', '8') /* IQ u8 */
 #define V4L2_SDR_FMT_CU16LE       v4l2_fourcc('C', 'U', '1', '6') /* IQ u16le */
 #define V4L2_SDR_FMT_CS8          v4l2_fourcc('C', 'S', '0', '8') /* complex s8 */
+#define V4L2_SDR_FMT_CS14LE       v4l2_fourcc('C', 'S', '1', '4') /* complex s14le */
 #define V4L2_SDR_FMT_RU12LE       v4l2_fourcc('R', 'U', '1', '2') /* real u12le */
 
 /*
-- 
1.9.3

