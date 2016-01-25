Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54289 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180AbcAYOup (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 09:50:45 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Olli Salonen <olli.salonen@iki.fi>,
	Antti Palosaari <crope@iki.fi>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] [media] dw2102: use the new USB ID Terratec Cinergy S2 macros
Date: Mon, 25 Jan 2016 12:49:41 -0200
Message-Id: <a561d768c13287ef156863c4ff149306844101fa.1453733377.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that this was defined at usb-id.h, update the values for
USB_PID_TERRATEC_CINERGY_S2_R1 and USB_PID_TERRATEC_CINERGY_S2_R2.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/dvb-usb/dw2102.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 14ef25dc6cd3..bc19da5ad3b7 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -1702,13 +1702,13 @@ static struct usb_device_id dw2102_table[] = {
 	[TEVII_S660] = {USB_DEVICE(0x9022, USB_PID_TEVII_S660)},
 	[PROF_7500] = {USB_DEVICE(0x3034, 0x7500)},
 	[GENIATECH_SU3000] = {USB_DEVICE(0x1f4d, 0x3000)},
-	[TERRATEC_CINERGY_S2] = {USB_DEVICE(USB_VID_TERRATEC, 0x00a8)},
+	[TERRATEC_CINERGY_S2] = {USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_S2_R1)},
 	[TEVII_S480_1] = {USB_DEVICE(0x9022, USB_PID_TEVII_S480_1)},
 	[TEVII_S480_2] = {USB_DEVICE(0x9022, USB_PID_TEVII_S480_2)},
 	[X3M_SPC1400HD] = {USB_DEVICE(0x1f4d, 0x3100)},
 	[TEVII_S421] = {USB_DEVICE(0x9022, USB_PID_TEVII_S421)},
 	[TEVII_S632] = {USB_DEVICE(0x9022, USB_PID_TEVII_S632)},
-	[TERRATEC_CINERGY_S2_R2] = {USB_DEVICE(USB_VID_TERRATEC, 0x00b0)},
+	[TERRATEC_CINERGY_S2_R2] = {USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_CINERGY_S2_R2)},
 	[GOTVIEW_SAT_HD] = {USB_DEVICE(0x1FE1, USB_PID_GOTVIEW_SAT_HD)},
 	[GENIATECH_T220] = {USB_DEVICE(0x1f4d, 0xD220)},
 	[TECHNOTREND_S2_4600] = {USB_DEVICE(USB_VID_TECHNOTREND,
-- 
2.5.0

