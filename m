Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37587 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2AGIFu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jan 2012 03:05:50 -0500
Received: by iaeh11 with SMTP id h11so3850782iae.19
        for <linux-media@vger.kernel.org>; Sat, 07 Jan 2012 00:05:50 -0800 (PST)
Date: Sat, 7 Jan 2012 02:05:45 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Patrick Boettcher <pboettcher@kernellabs.com>,
	Johannes Stezenbach <js@sig21.net>, linux-media@vger.kernel.org
Subject: [PATCH 1/2] [media] a800: use symbolic names for a800_table indices
Message-ID: <20120107080545.GB10247@elie.hsd1.il.comcast.net>
References: <20111222215356.GA4499@rotes76.wohnheim.uni-kl.de>
 <20111222234446.GB10497@elie.Belkin>
 <201112231820.03693.pboettcher@kernellabs.com>
 <20111223230045.GE21769@elie.Belkin>
 <4F06F512.9090704@redhat.com>
 <20120107080136.GA10247@elie.hsd1.il.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120107080136.GA10247@elie.hsd1.il.comcast.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The USB id table opens with a comment:

	/* do not change the order of the ID table */

because the dvb_usb_device_properties::devices field makes use of USB
ids using hardcoded indices, as in "&a800_table[1]".  Inserting new
USB ids before the end of the table can cause these indices to go
stale and the code to misbehave.

In the spirit of "dw2102: use symbolic names for dw2102_table
indices", use symbolic names for the indices and C99-style
initializers to ensure they continue to refer to the entries they are
supposed to.  Now you can reorder entries in the id table without
fear.

Encouraged-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/media/dvb/dvb-usb/a800.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/a800.c b/drivers/media/dvb/dvb-usb/a800.c
index 2aef3c89e9fa..3f7ab144218b 100644
--- a/drivers/media/dvb/dvb-usb/a800.c
+++ b/drivers/media/dvb/dvb-usb/a800.c
@@ -110,11 +110,17 @@ static int a800_probe(struct usb_interface *intf,
 				   THIS_MODULE, NULL, adapter_nr);
 }
 
-/* do not change the order of the ID table */
+enum a800_table_entry {
+	AVERMEDIA_A800_COLD,
+	AVERMEDIA_A800_WARM
+};
+
 static struct usb_device_id a800_table [] = {
-/* 00 */	{ USB_DEVICE(USB_VID_AVERMEDIA,     USB_PID_AVERMEDIA_DVBT_USB2_COLD) },
-/* 01 */	{ USB_DEVICE(USB_VID_AVERMEDIA,     USB_PID_AVERMEDIA_DVBT_USB2_WARM) },
-			{ }		/* Terminating entry */
+	[AVERMEDIA_A800_COLD] = {USB_DEVICE(USB_VID_AVERMEDIA,
+					USB_PID_AVERMEDIA_DVBT_USB2_COLD)},
+	[AVERMEDIA_A800_WARM] = {USB_DEVICE(USB_VID_AVERMEDIA,
+					USB_PID_AVERMEDIA_DVBT_USB2_WARM)},
+	{ }
 };
 MODULE_DEVICE_TABLE (usb, a800_table);
 
@@ -169,9 +175,10 @@ static struct dvb_usb_device_properties a800_properties = {
 	.generic_bulk_ctrl_endpoint = 0x01,
 	.num_device_descs = 1,
 	.devices = {
-		{   "AVerMedia AverTV DVB-T USB 2.0 (A800)",
-			{ &a800_table[0], NULL },
-			{ &a800_table[1], NULL },
+		{
+			.name = "AVerMedia AverTV DVB-T USB 2.0 (A800)",
+			.cold_ids = {&a800_table[AVERMEDIA_A800_COLD], NULL},
+			.warm_ids = {&a800_table[AVERMEDIA_A800_WARM], NULL},
 		},
 	}
 };
-- 
1.7.8.3

