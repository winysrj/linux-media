Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:58882 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753375AbaKEISD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Nov 2014 03:18:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 6/8] cxusb: fix sparse warnings
Date: Wed,  5 Nov 2014 09:17:50 +0100
Message-Id: <1415175472-24203-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1415175472-24203-1-git-send-email-hverkuil@xs4all.nl>
References: <1415175472-24203-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

cxusb.c:1443:32: warning: restricted __le16 degrades to integer
cxusb.c:1487:32: warning: restricted __le16 degrades to integer

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/dvb-usb/cxusb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 8925b3946..b46f84d 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -1440,7 +1440,7 @@ static int cxusb_tt_ct2_4400_attach(struct dvb_usb_adapter *adap)
 	si2168_config.ts_mode = SI2168_TS_PARALLEL;
 
 	/* CT2-4400v2 TS gets corrupted without this */
-	if (d->udev->descriptor.idProduct ==
+	if (le16_to_cpu(d->udev->descriptor.idProduct) ==
 		USB_PID_TECHNOTREND_TVSTICK_CT2_4400)
 		si2168_config.ts_mode |= 0x40;
 
@@ -1484,7 +1484,7 @@ static int cxusb_tt_ct2_4400_attach(struct dvb_usb_adapter *adap)
 	st->i2c_client_tuner = client_tuner;
 
 	/* initialize CI */
-	if (d->udev->descriptor.idProduct ==
+	if (le16_to_cpu(d->udev->descriptor.idProduct) ==
 		USB_PID_TECHNOTREND_CONNECT_CT2_4650_CI) {
 
 		memcpy(o, "\xc0\x01", 2);
-- 
2.1.1

