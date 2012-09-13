Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36062 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755236Ab2IMAY0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 20:24:26 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 11/16] af9015: correct few error codes
Date: Thu, 13 Sep 2012 03:23:52 +0300
Message-Id: <1347495837-3244-11-git-send-email-crope@iki.fi>
In-Reply-To: <1347495837-3244-1-git-send-email-crope@iki.fi>
References: <1347495837-3244-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Plain '-1' is not very good error code. Use more suitable error
code definitions.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9015.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index a4be303..824f191 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -71,7 +71,7 @@ static int af9015_ctrl_msg(struct dvb_usb_device *d, struct req_t *req)
 	default:
 		dev_err(&d->udev->dev, "%s: unknown command=%d\n",
 				KBUILD_MODNAME, req->cmd);
-		ret = -1;
+		ret = -EIO;
 		goto error;
 	}
 
@@ -107,7 +107,7 @@ static int af9015_ctrl_msg(struct dvb_usb_device *d, struct req_t *req)
 	if (rlen && buf[1]) {
 		dev_err(&d->udev->dev, "%s: command failed=%d\n",
 				KBUILD_MODNAME, buf[1]);
-		ret = -1;
+		ret = -EIO;
 		goto error;
 	}
 
@@ -791,11 +791,11 @@ static int af9015_copy_firmware(struct dvb_usb_device *d)
 	if (val == 0x04) {
 		dev_err(&d->udev->dev, "%s: firmware did not run\n",
 				KBUILD_MODNAME);
-		ret = -1;
+		ret = -ETIMEDOUT;
 	} else if (val != 0x0c) {
 		dev_err(&d->udev->dev, "%s: firmware boot timeout\n",
 				KBUILD_MODNAME);
-		ret = -1;
+		ret = -ETIMEDOUT;
 	}
 
 error:
-- 
1.7.11.4

