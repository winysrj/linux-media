Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33954 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbaBIIt4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 03:49:56 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 12/86] rtl2832_sdr: pixel format for SDR
Date: Sun,  9 Feb 2014 10:48:17 +0200
Message-Id: <1391935771-18670-13-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These are used for converting / streaming I/Q data from SDR.
* unsigned 8-bit

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index 2c84654..d3db859 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -49,6 +49,8 @@
 #define RTL2832_SDR_CID_TUNER_IF            ((V4L2_CID_USER_BASE | 0xf000) + 12)
 #define RTL2832_SDR_CID_TUNER_GAIN          ((V4L2_CID_USER_BASE | 0xf000) + 13)
 
+#define V4L2_PIX_FMT_SDR_U8     v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
+
 #define MAX_BULK_BUFS            (8)
 #define BULK_BUFFER_SIZE         (8 * 512)
 
-- 
1.8.5.3

