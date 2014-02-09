Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57165 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbaBIIt4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 03:49:56 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 14/86] msi3101: add signed 8-bit pixel format for SDR
Date: Sun,  9 Feb 2014 10:48:19 +0200
Message-Id: <1391935771-18670-15-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is 8-bit unsigned data, byte after byte. Used for streaming SDR
I/Q data from ADC.

V4L2_PIX_FMT_SDR_S8, v4l fourcc "DS08".

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 4c3bf77..e208b57 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -385,6 +385,8 @@ static const struct msi3101_gain msi3101_gain_lut_1000[] = {
 #define MSI3101_CID_TUNER_IF              ((V4L2_CID_USER_BASE | 0xf000) + 12)
 #define MSI3101_CID_TUNER_GAIN            ((V4L2_CID_USER_BASE | 0xf000) + 13)
 
+#define V4L2_PIX_FMT_SDR_S8     v4l2_fourcc('D', 'S', '0', '8') /* signed 8-bit */
+
 /* intermediate buffers with raw data from the USB device */
 struct msi3101_frame_buf {
 	struct vb2_buffer vb;   /* common v4l buffer stuff -- must be first */
-- 
1.8.5.3

