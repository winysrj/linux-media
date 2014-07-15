Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:45842 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933304AbaGOTe7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jul 2014 15:34:59 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: crope@iki.fi, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 1/3] cxusb: Prepare for si2157 driver getting more parameters
Date: Tue, 15 Jul 2014 21:34:34 +0200
Message-Id: <1405452876-8543-1-git-send-email-zzam@gentoo.org>
In-Reply-To: <53C58067.8000601@gentoo.org>
References: <53C58067.8000601@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modify all users of si2157_config to correctly initialize all not
listed values to 0.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/dvb-usb/cxusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index ad20c39..285213c 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -1371,6 +1371,7 @@ static int cxusb_tt_ct2_4400_attach(struct dvb_usb_adapter *adap)
 	st->i2c_client_demod = client_demod;
 
 	/* attach tuner */
+	memset(&si2157_config, 0, sizeof(si2157_config));
 	si2157_config.fe = adap->fe_adap[0].fe;
 	memset(&info, 0, sizeof(struct i2c_board_info));
 	strlcpy(info.type, "si2157", I2C_NAME_SIZE);
-- 
2.0.0

