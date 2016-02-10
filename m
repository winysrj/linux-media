Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:10798 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbcBJKJO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2016 05:09:14 -0500
Received: from [10.47.79.81] ([10.47.79.81])
	(authenticated bits=0)
	by aer-core-4.cisco.com (8.14.5/8.14.5) with ESMTP id u1AA9AnC018690
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 10 Feb 2016 10:09:11 GMT
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH for v4.5] adv7604: fix tx 5v detect regression
Message-ID: <56BB0C46.4020200@cisco.com>
Date: Wed, 10 Feb 2016 11:09:10 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 5 volt detect functionality broke in 3.14: the code reads IO register 0x70
again after it has already been cleared. Instead it should use the cached
irq_reg_0x70 value and the io_write to 0x71 to clear 0x70 can be dropped since
this has already been done.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: <stable@vger.kernel.org>      # for v3.14 and up
---
 drivers/media/i2c/adv7604.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 45a3e12..9355553 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2199,10 +2199,9 @@ static int adv76xx_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
 	adv76xx_cec_isr(sd, handled);

 	/* tx 5v detect */
-	tx_5v = io_read(sd, 0x70) & info->cable_det_mask;
+	tx_5v = irq_reg_0x70 & info->cable_det_mask;
 	if (tx_5v) {
 		v4l2_dbg(1, debug, sd, "%s: tx_5v: 0x%x\n", __func__, tx_5v);
-		io_write(sd, 0x71, tx_5v);
 		adv76xx_s_detect_tx_5v_ctrl(sd);
 		if (handled)
 			*handled = true;
-- 
2.6.1

