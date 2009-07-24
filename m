Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.artecdesign.ee ([195.50.213.123]:48063 "EHLO
	postikukk.artecdesign.ee" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbZGXROK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2009 13:14:10 -0400
Received: from martr-gentoo.artec ([10.3.10.111])
	by postikukk.artecdesign.ee with esmtp (Exim 4.63)
	(envelope-from <mart.raudsepp@artecdesign.ee>)
	id 1MUNoZ-00053n-K3
	for linux-media@vger.kernel.org; Fri, 24 Jul 2009 19:40:12 +0300
Subject: [PATCH] V4L/DVB: af9015: add new USB ID for KWorld PlusTV Dual
 DVB-T Stick (DVB-T 399U)
From: Mart Raudsepp <mart.raudsepp@artecdesign.ee>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Fri, 24 Jul 2009 19:45:41 +0300
Message-Id: <1248453941.5546.18.camel@martr-gentoo.artec>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new USB ID (1b80:e400) for KWorld PlusTV Dual DVB-T Stick (DVB-T 399U).
The model number on the devices sticker label is "KW-DVB-T 399UR".

Signed-off-by: Mart Raudsepp <mart.raudsepp@artecdesign.ee>
---
 drivers/media/dvb/dvb-usb/af9015.c      |    4 +++-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af9015.c b/drivers/media/dvb/dvb-usb/af9015.c
index 4cb31e7..d902804 100644
--- a/drivers/media/dvb/dvb-usb/af9015.c
+++ b/drivers/media/dvb/dvb-usb/af9015.c
@@ -1266,6 +1266,7 @@ static struct usb_device_id af9015_usb_table[] = {
 	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_CONCEPTRONIC_CTVDIGRCU)},
 	{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_MC810)},
 	{USB_DEVICE(USB_VID_KYE,       USB_PID_GENIUS_TVGO_DVB_T03)},
+/* 25 */{USB_DEVICE(USB_VID_KWORLD_2,  USB_PID_KWORLD_399U_2)},
 	{0},
 };
 MODULE_DEVICE_TABLE(usb, af9015_usb_table);
@@ -1346,7 +1347,8 @@ static struct dvb_usb_device_properties af9015_properties[] = {
 			{
 				.name = "KWorld PlusTV Dual DVB-T Stick " \
 					"(DVB-T 399U)",
-				.cold_ids = {&af9015_usb_table[4], NULL},
+				.cold_ids = {&af9015_usb_table[4],
+					     &af9015_usb_table[25], NULL},
 				.warm_ids = {NULL},
 			},
 			{
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index 9593b72..5ace131 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -103,6 +103,7 @@
 #define USB_PID_GRANDTEC_DVBT_USB_WARM			0x0fa1
 #define USB_PID_INTEL_CE9500				0x9500
 #define USB_PID_KWORLD_399U				0xe399
+#define USB_PID_KWORLD_399U_2				0xe400
 #define USB_PID_KWORLD_395U				0xe396
 #define USB_PID_KWORLD_395U_2				0xe39b
 #define USB_PID_KWORLD_395U_3				0xe395
-- 
1.6.3.3

