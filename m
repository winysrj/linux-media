Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39573 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254AbaGDRPz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jul 2014 13:15:55 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [[PATCH v2] 12/14] dib8000: Update the ADC gain table
Date: Fri,  4 Jul 2014 14:15:38 -0300
Message-Id: <1404494140-17777-13-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1404494140-17777-1-git-send-email-m.chehab@samsung.com>
References: <1404494140-17777-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This table doesn't match the new one.
Update it.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 779dc52d1dfe..be57e6831572 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -1980,18 +1980,9 @@ static u32 dib8000_ctrl_timf(struct dvb_frontend *fe, uint8_t op, uint32_t timf)
 }
 
 static const u16 adc_target_16dB[11] = {
-	(1 << 13) - 825 - 117,
-	(1 << 13) - 837 - 117,
-	(1 << 13) - 811 - 117,
-	(1 << 13) - 766 - 117,
-	(1 << 13) - 737 - 117,
-	(1 << 13) - 693 - 117,
-	(1 << 13) - 648 - 117,
-	(1 << 13) - 619 - 117,
-	(1 << 13) - 575 - 117,
-	(1 << 13) - 531 - 117,
-	(1 << 13) - 501 - 117
+	7250, 7238, 7264, 7309, 7338, 7382, 7427, 7456, 7500, 7544, 7574
 };
+
 static const u8 permu_seg[] = { 6, 5, 7, 4, 8, 3, 9, 2, 10, 1, 11, 0, 12 };
 
 static u16 dib8000_set_layer(struct dib8000_state *state, u8 layer_index, u16 max_constellation)
-- 
1.9.3

