Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56560 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567AbaDEUYD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Apr 2014 16:24:03 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/4] msi3101: remove unused variable assignment
Date: Sat,  5 Apr 2014 23:23:42 +0300
Message-Id: <1396729424-17576-3-git-send-email-crope@iki.fi>
In-Reply-To: <1396729424-17576-1-git-send-email-crope@iki.fi>
References: <1396729424-17576-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Coverity CID 1196508: Unused pointer value (UNUSED_VALUE)
Pointer "bandwidth" returned by "v4l2_ctrl_find(&s->hdl, 10619148U)"
is overwritten.

Reported-by: <scan-admin@coverity.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 011db2c..c6adf5f 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -913,7 +913,6 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 
 	/* set tuner, subdev, filters according to sampling rate */
 	bandwidth_auto = v4l2_ctrl_find(&s->hdl, V4L2_CID_RF_TUNER_BANDWIDTH_AUTO);
-	bandwidth = v4l2_ctrl_find(&s->hdl, V4L2_CID_RF_TUNER_BANDWIDTH);
 	if (v4l2_ctrl_g_ctrl(bandwidth_auto)) {
 		bandwidth = v4l2_ctrl_find(&s->hdl, V4L2_CID_RF_TUNER_BANDWIDTH);
 		v4l2_ctrl_s_ctrl(bandwidth, s->f_adc);
-- 
1.9.0

