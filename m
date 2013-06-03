Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34786 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758906Ab3FCWzY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Jun 2013 18:55:24 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/4] af9035: minor log writing changes
Date: Tue,  4 Jun 2013 01:54:25 +0300
Message-Id: <1370300066-13964-4-git-send-email-crope@iki.fi>
In-Reply-To: <1370300066-13964-1-git-send-email-crope@iki.fi>
References: <1370300066-13964-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 7d3b3c2..e855ee6 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -55,7 +55,7 @@ static int af9035_ctrl_msg(struct dvb_usb_device *d, struct usb_req *req)
 	if (req->wlen > (BUF_LEN - REQ_HDR_LEN - CHECKSUM_LEN) ||
 			req->rlen > (BUF_LEN - ACK_HDR_LEN - CHECKSUM_LEN)) {
 		dev_err(&d->udev->dev, "%s: too much data wlen=%d rlen=%d\n",
-				__func__, req->wlen, req->rlen);
+				KBUILD_MODNAME, req->wlen, req->rlen);
 		ret = -EINVAL;
 		goto exit;
 	}
@@ -336,8 +336,8 @@ static int af9035_identify_state(struct dvb_usb_device *d, const char **name)
 
 	dev_info(&d->udev->dev,
 			"%s: prechip_version=%02x chip_version=%02x chip_type=%04x\n",
-			__func__, state->prechip_version, state->chip_version,
-			state->chip_type);
+			KBUILD_MODNAME, state->prechip_version,
+			state->chip_version, state->chip_type);
 
 	if (state->chip_type == 0x9135) {
 		if (state->chip_version == 0x02)
-- 
1.7.11.7

