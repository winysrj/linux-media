Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:63302 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab3FBS4t (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jun 2013 14:56:49 -0400
Received: by mail-we0-f170.google.com with SMTP id w57so1075712wes.15
        for <linux-media@vger.kernel.org>; Sun, 02 Jun 2013 11:56:48 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com, crope@iki.fi
Cc: mkrufky@linuxtv.org, Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] rtl28xxu: fix buffer overflow when probing Rafael Micro r820t tuner
Date: Sun,  2 Jun 2013 20:56:04 +0200
Message-Id: <1370199364-30060-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

req_r820t wants a buffer with a size of 5 bytes, but the buffer 'buf'
has a size of 2 bytes.

This patch fixes the kernel oops with the r820t driver on old kernels
during the probe stage.
Successfully tested on a 2.6.32 32 bit kernel (Ubuntu 10.04).
Hopefully it will also help with the random stability issues reported
by some user on the linux-media list.

This patch and https://patchwork.kernel.org/patch/2524651/
should go in the next 3.10-rc release, as they fix potential kernel crashes.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 22015fe..48f2e6f 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -360,7 +360,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
 {
 	struct rtl28xxu_priv *priv = d_to_priv(d);
 	int ret;
-	u8 buf[2];
+	u8 buf[5];
 	/* open RTL2832U/RTL2832 I2C gate */
 	struct rtl28xxu_req req_gate_open = {0x0120, 0x0011, 0x0001, "\x18"};
 	/* close RTL2832U/RTL2832 I2C gate */
-- 
1.8.3

