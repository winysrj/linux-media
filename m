Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34503 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471Ab2HOCV6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 22:21:58 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 5/6] dvb_usb_v2: af9015, af9035, anysee use .reset_resume
Date: Wed, 15 Aug 2012 05:21:08 +0300
Message-Id: <1344997269-20338-6-git-send-email-crope@iki.fi>
In-Reply-To: <1344997269-20338-1-git-send-email-crope@iki.fi>
References: <1344997269-20338-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All these seems to survive .reset_resume.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9015.c | 1 +
 drivers/media/usb/dvb-usb-v2/af9035.c | 1 +
 drivers/media/usb/dvb-usb-v2/anysee.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index e77429b..9afceed 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -1423,6 +1423,7 @@ static struct usb_driver af9015_usb_driver = {
 	.disconnect = dvb_usbv2_disconnect,
 	.suspend = dvb_usbv2_suspend,
 	.resume = dvb_usbv2_resume,
+	.reset_resume = dvb_usbv2_reset_resume,
 	.no_dynamic_id = 1,
 	.soft_unbind = 1,
 };
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index bb90b87..b700444 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1075,6 +1075,7 @@ static struct usb_driver af9035_usb_driver = {
 	.disconnect = dvb_usbv2_disconnect,
 	.suspend = dvb_usbv2_suspend,
 	.resume = dvb_usbv2_resume,
+	.reset_resume = dvb_usbv2_reset_resume,
 	.no_dynamic_id = 1,
 	.soft_unbind = 1,
 };
diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
index fb3829a..2a16059 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -1313,6 +1313,7 @@ static struct usb_driver anysee_usb_driver = {
 	.disconnect = dvb_usbv2_disconnect,
 	.suspend = dvb_usbv2_suspend,
 	.resume = dvb_usbv2_resume,
+	.reset_resume = dvb_usbv2_reset_resume,
 	.no_dynamic_id = 1,
 	.soft_unbind = 1,
 };
-- 
1.7.11.2

