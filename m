Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48730 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932970Ab3HGSxS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Aug 2013 14:53:18 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 12/16] msi3101: init bits 23:20 on PLL register
Date: Wed,  7 Aug 2013 21:51:43 +0300
Message-Id: <1375901507-26661-13-git-send-email-crope@iki.fi>
In-Reply-To: <1375901507-26661-1-git-send-email-crope@iki.fi>
References: <1375901507-26661-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index a937d00..93168db 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -1129,9 +1129,19 @@ static int msi3101_set_usb_adc(struct msi3101_state *s)
 	 *
 	 * VCO 202000000 - 720000000++
 	 */
-	reg3 = 0x01c00303;
+	reg3 = 0x01000303;
 	reg4 = 0x00000004;
 
+	/* XXX: Filters? AGC? */
+	if (f_sr < 6000000)
+		reg3 |= 0x1 << 20;
+	else if (f_sr < 7000000)
+		reg3 |= 0x5 << 20;
+	else if (f_sr < 8500000)
+		reg3 |= 0x9 << 20;
+	else
+		reg3 |= 0xd << 20;
+
 	for (div_r_out = 4; div_r_out < 16; div_r_out += 2) {
 		f_vco = f_sr * div_r_out * 12;
 		dev_dbg(&s->udev->dev, "%s: div_r_out=%d f_vco=%d\n",
-- 
1.7.11.7

