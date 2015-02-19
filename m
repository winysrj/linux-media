Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:44498 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbbBSJNl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 04:13:41 -0500
Received: by lbiz12 with SMTP id z12so6235510lbi.11
        for <linux-media@vger.kernel.org>; Thu, 19 Feb 2015 01:13:40 -0800 (PST)
From: =?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Antti=20Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>
Subject: [RFC PATCH] mn88472: reduce firmware download chunk size
Date: Thu, 19 Feb 2015 11:13:20 +0200
Message-Id: <1424337200-6446-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It seems that currently the firmware download on the mn88472 is
somehow wrong for my Astrometa HD-901T2.

Reducing the download chunk size (mn88472_config.i2c_wr_max) to 2 
makes the firmware download consistently succeed.

Any larger value causes the download to always fail:

[    7.671482] mn88472 7-0018: downloading firmware from file 'dvb-demod-mn88472-02.fw'
[    8.206960] mn88472 7-0018: firmware download failed=-32
[    8.208610] rtl2832 7-0010: i2c reg write failed -32
[    8.208620] r820t 8-003a: r820t_write: i2c wr failed=-32 reg=05 len=1: 83
[    8.210459] rtl2832 7-0010: i2c reg write failed -32
[    8.212038] rtl2832 7-0010: i2c reg write failed -32

I'm obviously not too happy about this patch as it slows down the
firmware download but I have not found a way to keep larger chunks in
place and have a working firmware download at the same time.

Signed-off-by: Antti Seppälä <a.seppala@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index d88f799..3c5c6f9 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -865,7 +865,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 			struct mn88472_config mn88472_config = {};
 
 			mn88472_config.fe = &adap->fe[1];
-			mn88472_config.i2c_wr_max = 22,
+			mn88472_config.i2c_wr_max = 2,
 			strlcpy(info.type, "mn88472", I2C_NAME_SIZE);
 			mn88472_config.xtal = 20500000;
 			info.addr = 0x18;
-- 
2.0.5

