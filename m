Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57486 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab2HUNJO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 09:09:14 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] gl861: reset_resume support
Date: Tue, 21 Aug 2012 16:08:51 +0300
Message-Id: <1345554531-31715-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It survives now on reset_resume.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/gl861.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/dvb-usb-v2/gl861.c b/drivers/media/usb/dvb-usb-v2/gl861.c
index cf29f43..df78811 100644
--- a/drivers/media/usb/dvb-usb-v2/gl861.c
+++ b/drivers/media/usb/dvb-usb-v2/gl861.c
@@ -163,6 +163,7 @@ static struct usb_driver gl861_usb_driver = {
 	.disconnect = dvb_usbv2_disconnect,
 	.suspend = dvb_usbv2_suspend,
 	.resume = dvb_usbv2_resume,
+	.reset_resume = dvb_usbv2_reset_resume,
 	.no_dynamic_id = 1,
 	.soft_unbind = 1,
 };
-- 
1.7.11.4

