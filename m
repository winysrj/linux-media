Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59908 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268Ab2HVWw2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 18:52:28 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] au6610: define reset_resume
Date: Thu, 23 Aug 2012 01:52:05 +0300
Message-Id: <1345675925-30009-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After qt1010 change that device seems to survive from reset resume.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/au6610.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/dvb-usb-v2/au6610.c b/drivers/media/usb/dvb-usb-v2/au6610.c
index 05f2a86..c126b70 100644
--- a/drivers/media/usb/dvb-usb-v2/au6610.c
+++ b/drivers/media/usb/dvb-usb-v2/au6610.c
@@ -194,6 +194,7 @@ static struct usb_driver au6610_driver = {
 	.disconnect = dvb_usbv2_disconnect,
 	.suspend = dvb_usbv2_suspend,
 	.resume = dvb_usbv2_resume,
+	.reset_resume = dvb_usbv2_reset_resume,
 	.no_dynamic_id = 1,
 	.soft_unbind = 1,
 };
-- 
1.7.11.4

