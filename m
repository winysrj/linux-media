Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50842 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab2IMAY1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 20:24:27 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 12/16] af9035: use Kernel dev_foo() logging
Date: Thu, 13 Sep 2012 03:23:53 +0300
Message-Id: <1347495837-3244-12-git-send-email-crope@iki.fi>
In-Reply-To: <1347495837-3244-1-git-send-email-crope@iki.fi>
References: <1347495837-3244-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 90 +++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 41 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 3c6d82e..89cc901 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -53,9 +53,9 @@ static int af9035_ctrl_msg(struct dvb_usb_device *d, struct usb_req *req)
 
 	/* buffer overflow check */
 	if (req->wlen > (BUF_LEN - REQ_HDR_LEN - CHECKSUM_LEN) ||
-		req->rlen > (BUF_LEN - ACK_HDR_LEN - CHECKSUM_LEN)) {
-		pr_debug("%s: too much data wlen=%d rlen=%d\n", __func__,
-				req->wlen, req->rlen);
+			req->rlen > (BUF_LEN - ACK_HDR_LEN - CHECKSUM_LEN)) {
+		dev_err(&d->udev->dev, "%s: too much data wlen=%d rlen=%d\n",
+				__func__, req->wlen, req->rlen);
 		return -EINVAL;
 	}
 
@@ -89,17 +89,17 @@ static int af9035_ctrl_msg(struct dvb_usb_device *d, struct usb_req *req)
 	checksum = af9035_checksum(buf, rlen - 2);
 	tmp_checksum = (buf[rlen - 2] << 8) | buf[rlen - 1];
 	if (tmp_checksum != checksum) {
-		pr_err("%s: command=%02x checksum mismatch (%04x != %04x)\n",
-				KBUILD_MODNAME, req->cmd, tmp_checksum,
-				checksum);
+		dev_err(&d->udev->dev, "%s: command=%02x checksum mismatch " \
+				"(%04x != %04x)\n", KBUILD_MODNAME, req->cmd,
+				tmp_checksum, checksum);
 		ret = -EIO;
 		goto err;
 	}
 
 	/* check status */
 	if (buf[2]) {
-		pr_debug("%s: command=%02x failed fw error=%d\n", __func__,
-				req->cmd, buf[2]);
+		dev_dbg(&d->udev->dev, "%s: command=%02x failed fw error=%d\n",
+				__func__, req->cmd, buf[2]);
 		ret = -EIO;
 		goto err;
 	}
@@ -112,7 +112,7 @@ exit:
 	return 0;
 
 err:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -290,7 +290,7 @@ static int af9035_identify_state(struct dvb_usb_device *d, const char **name)
 	if (ret < 0)
 		goto err;
 
-	pr_debug("%s: reply=%*ph\n", __func__, 4, rbuf);
+	dev_dbg(&d->udev->dev, "%s: reply=%*ph\n", __func__, 4, rbuf);
 	if (rbuf[0] || rbuf[1] || rbuf[2] || rbuf[3])
 		ret = WARM;
 	else
@@ -299,7 +299,7 @@ static int af9035_identify_state(struct dvb_usb_device *d, const char **name)
 	return ret;
 
 err:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -339,13 +339,13 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
 		hdr_checksum = fw->data[fw->size - i + 5] << 8;
 		hdr_checksum |= fw->data[fw->size - i + 6] << 0;
 
-		pr_debug("%s: core=%d addr=%04x data_len=%d checksum=%04x\n",
-				__func__, hdr_core, hdr_addr, hdr_data_len,
-				hdr_checksum);
+		dev_dbg(&d->udev->dev, "%s: core=%d addr=%04x data_len=%d " \
+				"checksum=%04x\n", __func__, hdr_core, hdr_addr,
+				hdr_data_len, hdr_checksum);
 
 		if (((hdr_core != 1) && (hdr_core != 2)) ||
 				(hdr_data_len > i)) {
-			pr_debug("%s: bad firmware\n", __func__);
+			dev_dbg(&d->udev->dev, "%s: bad firmware\n", __func__);
 			break;
 		}
 
@@ -376,7 +376,8 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
 
 		i -= hdr_data_len + HDR_SIZE;
 
-		pr_debug("%s: data uploaded=%zu\n", __func__, fw->size - i);
+		dev_dbg(&d->udev->dev, "%s: data uploaded=%zu\n",
+				__func__, fw->size - i);
 	}
 
 	/* firmware loaded, request boot */
@@ -392,18 +393,19 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
 		goto err;
 
 	if (!(rbuf[0] || rbuf[1] || rbuf[2] || rbuf[3])) {
-		pr_err("%s: firmware did not run\n", KBUILD_MODNAME);
+		dev_err(&d->udev->dev, "%s: firmware did not run\n",
+				KBUILD_MODNAME);
 		ret = -ENODEV;
 		goto err;
 	}
 
-	pr_info("%s: firmware version=%d.%d.%d.%d", KBUILD_MODNAME,
-			rbuf[0], rbuf[1], rbuf[2], rbuf[3]);
+	dev_info(&d->udev->dev, "%s: firmware version=%d.%d.%d.%d",
+			KBUILD_MODNAME, rbuf[0], rbuf[1], rbuf[2], rbuf[3]);
 
 	return 0;
 
 err:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -445,7 +447,8 @@ static int af9035_download_firmware_it9135(struct dvb_usb_device *d,
 			if (ret < 0)
 				goto err;
 
-			pr_debug("%s: data uploaded=%d\n", __func__, i);
+			dev_dbg(&d->udev->dev, "%s: data uploaded=%d\n",
+					__func__, i);
 		}
 	}
 
@@ -462,18 +465,19 @@ static int af9035_download_firmware_it9135(struct dvb_usb_device *d,
 		goto err;
 
 	if (!(rbuf[0] || rbuf[1] || rbuf[2] || rbuf[3])) {
-		pr_err("%s: firmware did not run\n", KBUILD_MODNAME);
+		dev_err(&d->udev->dev, "%s: firmware did not run\n",
+				KBUILD_MODNAME);
 		ret = -ENODEV;
 		goto err;
 	}
 
-	pr_info("%s: firmware version=%d.%d.%d.%d", KBUILD_MODNAME,
-			rbuf[0], rbuf[1], rbuf[2], rbuf[3]);
+	dev_info(&d->udev->dev, "%s: firmware version=%d.%d.%d.%d",
+			KBUILD_MODNAME, rbuf[0], rbuf[1], rbuf[2], rbuf[3]);
 
 	return 0;
 
 err:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -491,7 +495,8 @@ static int af9035_read_config(struct dvb_usb_device *d)
 		goto err;
 
 	state->dual_mode = tmp;
-	pr_debug("%s: dual mode=%d\n", __func__, state->dual_mode);
+	dev_dbg(&d->udev->dev, "%s: dual mode=%d\n",
+			__func__, state->dual_mode);
 
 	for (i = 0; i < state->dual_mode + 1; i++) {
 		/* tuner */
@@ -500,7 +505,8 @@ static int af9035_read_config(struct dvb_usb_device *d)
 			goto err;
 
 		state->af9033_config[i].tuner = tmp;
-		pr_debug("%s: [%d]tuner=%02x\n", __func__, i, tmp);
+		dev_dbg(&d->udev->dev, "%s: [%d]tuner=%02x\n",
+				__func__, i, tmp);
 
 		switch (tmp) {
 		case AF9033_TUNER_TUA9001:
@@ -510,8 +516,9 @@ static int af9035_read_config(struct dvb_usb_device *d)
 			state->af9033_config[i].spec_inv = 1;
 			break;
 		default:
-			pr_info("%s: tuner ID=%02x not supported, please " \
-					"report!", KBUILD_MODNAME, tmp);
+			dev_warn(&d->udev->dev, "%s: tuner id=%02x not " \
+					"supported, please report!",
+					KBUILD_MODNAME, tmp);
 		};
 
 		/* tuner IF frequency */
@@ -527,7 +534,7 @@ static int af9035_read_config(struct dvb_usb_device *d)
 
 		tmp16 |= tmp << 8;
 
-		pr_debug("%s: [%d]IF=%d\n", __func__, i, tmp16);
+		dev_dbg(&d->udev->dev, "%s: [%d]IF=%d\n", __func__, i, tmp16);
 
 		eeprom_shift = 0x10; /* shift for the 2nd tuner params */
 	}
@@ -545,7 +552,7 @@ static int af9035_read_config(struct dvb_usb_device *d)
 	return 0;
 
 err:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -571,7 +578,7 @@ static int af9035_read_config_it9135(struct dvb_usb_device *d)
 	return 0;
 
 err:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -636,7 +643,7 @@ static int af9035_fc0011_tuner_callback(struct dvb_usb_device *d,
 	return 0;
 
 err:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -716,7 +723,7 @@ static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
 	return 0;
 
 err:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -856,7 +863,7 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 	return 0;
 
 err:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -888,8 +895,9 @@ static int af9035_init(struct dvb_usb_device *d)
 		{ 0x80f9a4, 0x00, 0x01 },
 	};
 
-	pr_debug("%s: USB speed=%d frame_size=%04x packet_size=%02x\n",
-		__func__, d->udev->speed, frame_size, packet_size);
+	dev_dbg(&d->udev->dev, "%s: USB speed=%d frame_size=%04x " \
+			"packet_size=%02x\n", __func__,
+			d->udev->speed, frame_size, packet_size);
 
 	/* init endpoints */
 	for (i = 0; i < ARRAY_SIZE(tab); i++) {
@@ -902,7 +910,7 @@ static int af9035_init(struct dvb_usb_device *d)
 	return 0;
 
 err:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
@@ -946,7 +954,7 @@ static int af9035_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 	if (ret < 0)
 		goto err;
 
-	pr_debug("%s: ir_mode=%02x\n", __func__, tmp);
+	dev_dbg(&d->udev->dev, "%s: ir_mode=%02x\n", __func__, tmp);
 
 	/* don't activate rc if in HID mode or if not available */
 	if (tmp == 5) {
@@ -954,7 +962,7 @@ static int af9035_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 		if (ret < 0)
 			goto err;
 
-		pr_debug("%s: ir_type=%02x\n", __func__, tmp);
+		dev_dbg(&d->udev->dev, "%s: ir_type=%02x\n", __func__, tmp);
 
 		switch (tmp) {
 		case 0: /* NEC */
@@ -977,7 +985,7 @@ static int af9035_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 	return 0;
 
 err:
-	pr_debug("%s: failed=%d\n", __func__, ret);
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
 
 	return ret;
 }
-- 
1.7.11.4

