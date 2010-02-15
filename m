Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:40256 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab0BOWXS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 17:23:18 -0500
Message-ID: <4B79CB0E.1060403@gmail.com>
Date: Mon, 15 Feb 2010 23:30:38 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] dvb-usb/opera1: misplaced parenthesis
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The parenthesis was misplaced, tmp is set to 0 or break occurs,
while debugging opera1_usb_i2c_msgxfer() retval was not shown.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/dvb/dvb-usb/opera1.c b/drivers/media/dvb/dvb-usb/opera1.c
index d4e2309..8305576 100644
--- a/drivers/media/dvb/dvb-usb/opera1.c
+++ b/drivers/media/dvb/dvb-usb/opera1.c
@@ -138,7 +138,7 @@ static int opera1_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 					(msg[i].addr<<1)|(msg[i].flags&I2C_M_RD?0x01:0),
 					msg[i].buf,
 					msg[i].len
-					)!= msg[i].len)) {
+					)) != msg[i].len) {
 			break;
 		}
 		if (dvb_usb_opera1_debug & 0x10)
