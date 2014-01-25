Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33151 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbaAYRLE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 12:11:04 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 20/52] rtl2832_sdr: increase USB buffers
Date: Sat, 25 Jan 2014 19:10:14 +0200
Message-Id: <1390669846-8131-21-git-send-email-crope@iki.fi>
In-Reply-To: <1390669846-8131-1-git-send-email-crope@iki.fi>
References: <1390669846-8131-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Increase USB xfer buffers heavily in order handle wider data stream.
Stream is quite heavy, over 50Mbit/sec, when sampling rates are
increased up to 3.2Msps. With remote controller interrupts disabled
and huge USB buffers it seems to perform even 3.2Msps rather well.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index 348df05..4b8c016 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -51,8 +51,8 @@
 
 #define V4L2_PIX_FMT_SDR_U8     v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
 
-#define MAX_BULK_BUFS            (8)
-#define BULK_BUFFER_SIZE         (8 * 512)
+#define MAX_BULK_BUFS            (10)
+#define BULK_BUFFER_SIZE         (128 * 512)
 
 /* intermediate buffers with raw data from the USB device */
 struct rtl2832_sdr_frame_buf {
-- 
1.8.5.3

