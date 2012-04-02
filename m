Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60145 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab2DBV0j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Apr 2012 17:26:39 -0400
Received: by wibhj6 with SMTP id hj6so3023786wib.1
        for <linux-media@vger.kernel.org>; Mon, 02 Apr 2012 14:26:38 -0700 (PDT)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, crope@iki.fi
Cc: m@bues.ch, hfvogt@gmx.net, mchehab@redhat.com,
	Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH 1/5] af9035: add USB id for 07ca:a867
Date: Mon,  2 Apr 2012 23:25:13 +0200
Message-Id: <1333401917-27203-2-git-send-email-gennarone@gmail.com>
In-Reply-To: <1333401917-27203-1-git-send-email-gennarone@gmail.com>
References: <1333401917-27203-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

New USB id for the Avermedia A867 stick (Sky Digital Key with blue led).

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/dvb/dvb-usb/af9035.c      |    6 +++++-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9035.c b/drivers/media/dvb/dvb-usb/af9035.c
index 8060e78..6f73cdf 100644
--- a/drivers/media/dvb/dvb-usb/af9035.c
+++ b/drivers/media/dvb/dvb-usb/af9035.c
@@ -794,6 +794,7 @@ enum af9035_id_entry {
 	AF9035_15A4_9035,
 	AF9035_15A4_1001,
 	AF9035_07CA_1867,
+	AF9035_07CA_A867,
 };
 
 static struct usb_device_id af9035_id[] = {
@@ -805,6 +806,8 @@ static struct usb_device_id af9035_id[] = {
 		USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9035_2)},
 	[AF9035_07CA_1867] = {
 		USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_1867)},
+	[AF9035_07CA_A867] = {
+		USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A867)},
 	{},
 };
 
@@ -861,9 +864,10 @@ static struct dvb_usb_device_properties af9035_properties[] = {
 					&af9035_id[AF9035_15A4_1001],
 				},
 			}, {
-				.name = "AVerMedia HD Volar",
+				.name = "AVerMedia HD Volar (A867)",
 				.cold_ids = {
 					&af9035_id[AF9035_07CA_1867],
+					&af9035_id[AF9035_07CA_A867],
 				},
 			},
 		}
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index 8f77a6c..3cf002b 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -225,6 +225,7 @@
 #define USB_PID_AVERMEDIA_A805				0xa805
 #define USB_PID_AVERMEDIA_A815M				0x815a
 #define USB_PID_AVERMEDIA_1867				0x1867
+#define USB_PID_AVERMEDIA_A867				0xa867
 #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
 #define USB_PID_TECHNOTREND_CONNECT_CT3650		0x300d
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY	0x005a
-- 
1.7.5.4

