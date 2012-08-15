Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36550 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968Ab2HOCV7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 22:21:59 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 6/6] dvb_usb_v2: ce6230, rtl28xxu use .reset_resume
Date: Wed, 15 Aug 2012 05:21:09 +0300
Message-Id: <1344997269-20338-7-git-send-email-crope@iki.fi>
In-Reply-To: <1344997269-20338-1-git-send-email-crope@iki.fi>
References: <1344997269-20338-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All these seems to survive .reset_resume.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/ce6230.c   | 1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/ce6230.c b/drivers/media/usb/dvb-usb-v2/ce6230.c
index 84ff4a9..819db9c 100644
--- a/drivers/media/usb/dvb-usb-v2/ce6230.c
+++ b/drivers/media/usb/dvb-usb-v2/ce6230.c
@@ -276,6 +276,7 @@ static struct usb_driver ce6230_usb_driver = {
 	.disconnect = dvb_usbv2_disconnect,
 	.suspend = dvb_usbv2_suspend,
 	.resume = dvb_usbv2_resume,
+	.reset_resume = dvb_usbv2_reset_resume,
 	.no_dynamic_id = 1,
 	.soft_unbind = 1,
 };
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index a2d1e5b..d2b1505 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1247,6 +1247,7 @@ static struct usb_driver rtl28xxu_usb_driver = {
 	.disconnect = dvb_usbv2_disconnect,
 	.suspend = dvb_usbv2_suspend,
 	.resume = dvb_usbv2_resume,
+	.reset_resume = dvb_usbv2_reset_resume,
 	.no_dynamic_id = 1,
 	.soft_unbind = 1,
 };
-- 
1.7.11.2

