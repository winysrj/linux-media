Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:36317 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752006AbdLCPDQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Dec 2017 10:03:16 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] adv7604.c: add missing return
Message-ID: <305e2caf-fc15-20f1-3464-9454e641de95@xs4all.nl>
Date: Sun, 3 Dec 2017 16:03:11 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A 'return' was missing when detecting Arbitration Lost and
calling transmit_done. With the return transmit_done could be
called a second time, confusing the CEC framework. Luckily
the Arbitration Lost condition is very rare.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7604.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index c786cd125417..1544920ec52d 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1982,6 +1982,7 @@ static void adv76xx_cec_tx_raw_status(struct v4l2_subdev *sd, u8 tx_raw_status)
 			 __func__);
 		cec_transmit_done(state->cec_adap, CEC_TX_STATUS_ARB_LOST,
 				  1, 0, 0, 0);
+		return;
 	}
 	if (tx_raw_status & 0x04) {
 		u8 status;
-- 
2.14.1
