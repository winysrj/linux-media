Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34059 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab3CJBnq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 20:43:46 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 3/5] cypress_firmware: make checkpatch.pl happy
Date: Sun, 10 Mar 2013 03:42:33 +0200
Message-Id: <1362879755-4839-3-git-send-email-crope@iki.fi>
In-Reply-To: <1362879755-4839-1-git-send-email-crope@iki.fi>
References: <1362879755-4839-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

New checkpatch version likes to see strings not to split multiple
lines even those are exceeding 80 line length.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/cypress_firmware.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/cypress_firmware.c b/drivers/media/usb/dvb-usb-v2/cypress_firmware.c
index 211df54..cfb1733 100644
--- a/drivers/media/usb/dvb-usb-v2/cypress_firmware.c
+++ b/drivers/media/usb/dvb-usb-v2/cypress_firmware.c
@@ -71,9 +71,8 @@ int usbv2_cypress_load_firmware(struct usb_device *udev,
 		if (ret < 0) {
 			goto err_kfree;
 		} else if (ret != hx->len) {
-			dev_err(&udev->dev, "%s: error while transferring " \
-					"firmware (transferred size=%d, " \
-					"block size=%d)\n",
+			dev_err(&udev->dev,
+					"%s: error while transferring firmware (transferred size=%d, block size=%d)\n",
 					KBUILD_MODNAME, ret, hx->len);
 			ret = -EIO;
 			goto err_kfree;
-- 
1.7.11.7

