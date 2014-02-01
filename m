Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43925 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932893AbaBAOYr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Feb 2014 09:24:47 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 09/17] msi3101: sleep USB ADC and tuner when streaming is stopped
Date: Sat,  1 Feb 2014 16:24:26 +0200
Message-Id: <1391264674-4395-10-git-send-email-crope@iki.fi>
In-Reply-To: <1391264674-4395-1-git-send-email-crope@iki.fi>
References: <1391264674-4395-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Put USB IF / ADC and RF tuner to sleep when device is not streaming.
It uses around 115 mA power from USB when active, which drops to
32 mA on idle after that patch.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 061c705..0606941 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -977,8 +977,8 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 	 * Synthesizer config is just a educated guess...
 	 *
 	 * [7:0]   0x03, register address
-	 * [8]     1, always
-	 * [9]     ?
+	 * [8]     1, power control
+	 * [9]     ?, power control
 	 * [12:10] output divider
 	 * [13]    0 ?
 	 * [14]    0 ?
@@ -1321,6 +1321,12 @@ static int msi3101_stop_streaming(struct vb2_queue *vq)
 	msleep(20);
 	msi3101_ctrl_msg(s, CMD_STOP_STREAMING, 0);
 
+	/* sleep USB IF / ADC */
+	msi3101_ctrl_msg(s, CMD_WREG, 0x01000003);
+
+	/* sleep tuner */
+	msi3101_tuner_write(s, 0x000000);
+
 	mutex_unlock(&s->v4l2_lock);
 
 	return 0;
-- 
1.8.5.3

