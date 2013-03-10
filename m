Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33088 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab3CJCEl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:41 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 24/41] af9035: select firmware loader according to firmware
Date: Sun, 10 Mar 2013 04:03:16 +0200
Message-Id: <1362881013-5271-24-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

AF9035 and IT9135 supports two different firmware format. Select
correct loader according to first byte of firmware file.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index a220a12..0399062 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -344,7 +344,7 @@ err:
 	return ret;
 }
 
-static int af9035_download_firmware_af9035(struct dvb_usb_device *d,
+static int af9035_download_firmware_old(struct dvb_usb_device *d,
 		const struct firmware *fw)
 {
 	int ret, i, j, len;
@@ -430,7 +430,7 @@ err:
 	return ret;
 }
 
-static int af9035_download_firmware_it9135(struct dvb_usb_device *d,
+static int af9035_download_firmware_new(struct dvb_usb_device *d,
 		const struct firmware *fw)
 {
 	int ret, i, i_prev;
@@ -540,10 +540,10 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
 		}
 	}
 
-	if (state->chip_type == 0x9135)
-		ret = af9035_download_firmware_it9135(d, fw);
+	if (fw->data[0] == 0x01)
+		ret = af9035_download_firmware_old(d, fw);
 	else
-		ret = af9035_download_firmware_af9035(d, fw);
+		ret = af9035_download_firmware_new(d, fw);
 	if (ret < 0)
 		goto err;
 
-- 
1.7.11.7

