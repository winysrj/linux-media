Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:63748 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaJZH4a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Oct 2014 03:56:30 -0400
Received: by mail-la0-f42.google.com with SMTP id gf13so4964292lab.15
        for <linux-media@vger.kernel.org>; Sun, 26 Oct 2014 00:56:28 -0700 (PDT)
From: Olli Salonen <olli.salonen@iki.fi>
To: linux-media@vger.kernel.org
Cc: Olli Salonen <olli.salonen@iki.fi>
Subject: [PATCH] cxusb: TS mode setting for TT CT2-4400
Date: Sun, 26 Oct 2014 09:56:12 +0200
Message-Id: <1414310172-25876-1-git-send-email-olli.salonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is a new version of the TechnoTrend CT2-4400 USB tuner. The difference is the demodulator that is used (Si2168-B40 instead of -A30).

For TT CT2-4400v2 a TS stream related parameter needs to be set, otherwise the stream becomes corrupted. The Windows driver for both CT2-4400 and CT2-4400v2 sets this as well. After this patch the driver works for both versions.

Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
---
 drivers/media/usb/dvb-usb/cxusb.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 356abb3..8925b3946 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -1438,6 +1438,12 @@ static int cxusb_tt_ct2_4400_attach(struct dvb_usb_adapter *adap)
 	si2168_config.i2c_adapter = &adapter;
 	si2168_config.fe = &adap->fe_adap[0].fe;
 	si2168_config.ts_mode = SI2168_TS_PARALLEL;
+
+	/* CT2-4400v2 TS gets corrupted without this */
+	if (d->udev->descriptor.idProduct ==
+		USB_PID_TECHNOTREND_TVSTICK_CT2_4400)
+		si2168_config.ts_mode |= 0x40;
+
 	memset(&info, 0, sizeof(struct i2c_board_info));
 	strlcpy(info.type, "si2168", I2C_NAME_SIZE);
 	info.addr = 0x64;
-- 
1.9.1

