Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:52207 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932830AbeCMXkP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 19:40:15 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 13/18] af9015: refactor firmware download
Date: Wed, 14 Mar 2018 01:39:39 +0200
Message-Id: <20180313233944.7234-13-crope@iki.fi>
In-Reply-To: <20180313233944.7234-1-crope@iki.fi>
References: <20180313233944.7234-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Small revise, no functional changes.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9015.c | 39 +++++++++++++++--------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index 8e2f704c6ca5..ffd4b225e439 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -350,52 +350,47 @@ static int af9015_identify_state(struct dvb_usb_device *d, const char **name)
 }
 
 static int af9015_download_firmware(struct dvb_usb_device *d,
-	const struct firmware *fw)
+				    const struct firmware *firmware)
 {
 	struct af9015_state *state = d_to_priv(d);
 	struct usb_interface *intf = d->intf;
-	int i, len, remaining, ret;
+	int ret, i, rem;
 	struct req_t req = {DOWNLOAD_FIRMWARE, 0, 0, 0, 0, 0, NULL};
-	u16 checksum = 0;
+	u16 checksum;
 
 	dev_dbg(&intf->dev, "\n");
 
-	/* calc checksum */
-	for (i = 0; i < fw->size; i++)
-		checksum += fw->data[i];
+	/* Calc checksum, we need it when copy firmware to slave demod */
+	for (i = 0, checksum = 0; i < firmware->size; i++)
+		checksum += firmware->data[i];
 
-	state->firmware_size = fw->size;
+	state->firmware_size = firmware->size;
 	state->firmware_checksum = checksum;
 
-	#define FW_ADDR 0x5100 /* firmware start address */
-	#define LEN_MAX 55 /* max packet size */
-	for (remaining = fw->size; remaining > 0; remaining -= LEN_MAX) {
-		len = remaining;
-		if (len > LEN_MAX)
-			len = LEN_MAX;
-
-		req.data_len = len;
-		req.data = (u8 *) &fw->data[fw->size - remaining];
-		req.addr = FW_ADDR + fw->size - remaining;
-
+	#define LEN_MAX (BUF_LEN - REQ_HDR_LEN) /* Max payload size */
+	for (rem = firmware->size; rem > 0; rem -= LEN_MAX) {
+		req.data_len = min(LEN_MAX, rem);
+		req.data = (u8 *) &firmware->data[firmware->size - rem];
+		req.addr = 0x5100 + firmware->size - rem;
 		ret = af9015_ctrl_msg(d, &req);
 		if (ret) {
 			dev_err(&intf->dev, "firmware download failed %d\n",
 				ret);
-			goto error;
+			goto err;
 		}
 	}
 
-	/* firmware loaded, request boot */
 	req.cmd = BOOT;
 	req.data_len = 0;
 	ret = af9015_ctrl_msg(d, &req);
 	if (ret) {
 		dev_err(&intf->dev, "firmware boot failed %d\n", ret);
-		goto error;
+		goto err;
 	}
 
-error:
+	return 0;
+err:
+	dev_dbg(&intf->dev, "failed %d\n", ret);
 	return ret;
 }
 
-- 
2.14.3
