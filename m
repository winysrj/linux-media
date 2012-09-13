Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39253 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756624Ab2IMAY1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 20:24:27 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 14/16] gl861: use Kernel dev_foo() logging
Date: Thu, 13 Sep 2012 03:23:55 +0300
Message-Id: <1347495837-3244-14-git-send-email-crope@iki.fi>
In-Reply-To: <1347495837-3244-1-git-send-email-crope@iki.fi>
References: <1347495837-3244-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/gl861.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/gl861.c b/drivers/media/usb/dvb-usb-v2/gl861.c
index df78811..b1b09c5 100644
--- a/drivers/media/usb/dvb-usb-v2/gl861.c
+++ b/drivers/media/usb/dvb-usb-v2/gl861.c
@@ -38,7 +38,8 @@ static int gl861_i2c_msg(struct dvb_usb_device *d, u8 addr,
 		value = value + wbuf[1];
 		break;
 	default:
-		pr_err("%s: wlen=%d, aborting\n", KBUILD_MODNAME, wlen);
+		dev_err(&d->udev->dev, "%s: wlen=%d, aborting\n",
+				KBUILD_MODNAME, wlen);
 		return -EINVAL;
 	}
 
-- 
1.7.11.4

