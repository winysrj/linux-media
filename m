Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:46020 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758621Ab3FCWzY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Jun 2013 18:55:24 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/4] af9035: make checkpatch.pl happy!
Date: Tue,  4 Jun 2013 01:54:24 +0300
Message-Id: <1370300066-13964-3-git-send-email-crope@iki.fi>
In-Reply-To: <1370300066-13964-1-git-send-email-crope@iki.fi>
References: <1370300066-13964-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index cfcf79b..7d3b3c2 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -91,9 +91,10 @@ static int af9035_ctrl_msg(struct dvb_usb_device *d, struct usb_req *req)
 	checksum = af9035_checksum(state->buf, rlen - 2);
 	tmp_checksum = (state->buf[rlen - 2] << 8) | state->buf[rlen - 1];
 	if (tmp_checksum != checksum) {
-		dev_err(&d->udev->dev, "%s: command=%02x checksum mismatch " \
-				"(%04x != %04x)\n", KBUILD_MODNAME, req->cmd,
-				tmp_checksum, checksum);
+		dev_err(&d->udev->dev,
+				"%s: command=%02x checksum mismatch (%04x != %04x)\n",
+				KBUILD_MODNAME, req->cmd, tmp_checksum,
+				checksum);
 		ret = -EIO;
 		goto exit;
 	}
@@ -400,9 +401,10 @@ static int af9035_download_firmware_old(struct dvb_usb_device *d,
 		hdr_checksum = fw->data[fw->size - i + 5] << 8;
 		hdr_checksum |= fw->data[fw->size - i + 6] << 0;
 
-		dev_dbg(&d->udev->dev, "%s: core=%d addr=%04x data_len=%d " \
-				"checksum=%04x\n", __func__, hdr_core, hdr_addr,
-				hdr_data_len, hdr_checksum);
+		dev_dbg(&d->udev->dev,
+				"%s: core=%d addr=%04x data_len=%d checksum=%04x\n",
+				__func__, hdr_core, hdr_addr, hdr_data_len,
+				hdr_checksum);
 
 		if (((hdr_core != 1) && (hdr_core != 2)) ||
 				(hdr_data_len > i)) {
@@ -507,7 +509,7 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
 	u8 rbuf[4];
 	u8 tmp;
 	struct usb_req req = { 0, 0, 0, NULL, 0, NULL };
-	struct usb_req req_fw_ver = { CMD_FW_QUERYINFO, 0, 1, wbuf, 4, rbuf } ;
+	struct usb_req req_fw_ver = { CMD_FW_QUERYINFO, 0, 1, wbuf, 4, rbuf };
 	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
 	/*
@@ -1218,9 +1220,9 @@ static int af9035_init(struct dvb_usb_device *d)
 		{ 0x80f9a4, 0x00, 0x01 },
 	};
 
-	dev_dbg(&d->udev->dev, "%s: USB speed=%d frame_size=%04x " \
-			"packet_size=%02x\n", __func__,
-			d->udev->speed, frame_size, packet_size);
+	dev_dbg(&d->udev->dev,
+			"%s: USB speed=%d frame_size=%04x packet_size=%02x\n",
+			__func__, d->udev->speed, frame_size, packet_size);
 
 	/* init endpoints */
 	for (i = 0; i < ARRAY_SIZE(tab); i++) {
@@ -1495,7 +1497,7 @@ static const struct usb_device_id af9035_id_table[] = {
 		&af9035_props, "AVerMedia Twinstar (A825)", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_ASUS, USB_PID_ASUS_U3100MINI_PLUS,
 		&af9035_props, "Asus U3100Mini Plus", NULL) },
-        { DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00aa,
+	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00aa,
 		&af9035_props, "TerraTec Cinergy T Stick (rev. 2)", NULL) },
 	/* IT9135 devices */
 #if 0
-- 
1.7.11.7

