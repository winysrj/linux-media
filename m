Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57758 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2JTVDW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Oct 2012 17:03:22 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so560505eek.19
        for <linux-media@vger.kernel.org>; Sat, 20 Oct 2012 14:03:21 -0700 (PDT)
Message-ID: <1350766995.3089.2.camel@Route3278>
Subject: [PATCH] it913x [BUG] Enable endpoint 3 on devices with HID
 interface.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sat, 20 Oct 2012 22:03:15 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On some USB controllers when endpoint 3 (used by HID) is not enabled
this causes a USB reset.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/it913x.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/it913x.c b/drivers/media/usb/dvb-usb-v2/it913x.c
index 695f910..4498f60 100644
--- a/drivers/media/usb/dvb-usb-v2/it913x.c
+++ b/drivers/media/usb/dvb-usb-v2/it913x.c
@@ -659,13 +659,19 @@ static int it913x_frontend_attach(struct dvb_usb_adapter *adap)
 		it913x_wr_reg(d, DEV_0_DMOD, MP2IF2_SW_RST, 0x1);
 		it913x_wr_reg(d, DEV_0, EP0_TX_EN, 0x0f);
 		it913x_wr_reg(d, DEV_0, EP0_TX_NAK, 0x1b);
-		it913x_wr_reg(d, DEV_0, EP0_TX_EN, 0x2f);
+		if (st->proprietary_ir == false) /* Enable endpoint 3 */
+			it913x_wr_reg(d, DEV_0, EP0_TX_EN, 0x3f);
+		else
+			it913x_wr_reg(d, DEV_0, EP0_TX_EN, 0x2f);
 		it913x_wr_reg(d, DEV_0, EP4_TX_LEN_LSB,
 					ep_size & 0xff);
 		it913x_wr_reg(d, DEV_0, EP4_TX_LEN_MSB, ep_size >> 8);
 		ret = it913x_wr_reg(d, DEV_0, EP4_MAX_PKT, pkt_size);
 	} else if (adap->id == 1 && adap->fe[0]) {
-		it913x_wr_reg(d, DEV_0, EP0_TX_EN, 0x6f);
+		if (st->proprietary_ir == false)
+			it913x_wr_reg(d, DEV_0, EP0_TX_EN, 0x7f);
+		else
+			it913x_wr_reg(d, DEV_0, EP0_TX_EN, 0x6f);
 		it913x_wr_reg(d, DEV_0, EP5_TX_LEN_LSB,
 					ep_size & 0xff);
 		it913x_wr_reg(d, DEV_0, EP5_TX_LEN_MSB, ep_size >> 8);
-- 
1.7.10.4


