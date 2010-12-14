Return-path: <mchehab@gaivota>
Received: from smtp5-g21.free.fr ([212.27.42.5]:48171 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759392Ab0LNTNf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 14:13:35 -0500
Date: Tue, 14 Dec 2010 20:15:37 +0100
From: =?UTF-8?B?SmVhbi1GcmFuw6dvaXM=?= Moine <moinejf@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 3/6] gspca - sonixj: Add a flag in the driver_info table
Message-ID: <20101214201537.41e1a9f8@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Signed-off-by: Jean-François Moine <moinejf@free.fr>

diff --git a/drivers/media/video/gspca/sonixj.c b/drivers/media/video/gspca/sonixj.c
index 5978676..ed7349b 100644
--- a/drivers/media/video/gspca/sonixj.c
+++ b/drivers/media/video/gspca/sonixj.c
@@ -64,6 +64,7 @@ struct sd {
 	u8 jpegqual;			/* webcam quality */
 
 	u8 reg18;
+	u8 flags;
 
 	s8 ag_cnt;
 #define AG_CNT_START 13
@@ -1763,7 +1764,8 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	struct cam *cam;
 
 	sd->bridge = id->driver_info >> 16;
-	sd->sensor = id->driver_info;
+	sd->sensor = id->driver_info >> 8;
+	sd->flags = id->driver_info;
 
 	cam = &gspca_dev->cam;
 	if (sd->sensor == SENSOR_ADCM1700) {
@@ -2947,7 +2949,11 @@ static const struct sd_desc sd_desc = {
 /* -- module initialisation -- */
 #define BS(bridge, sensor) \
 	.driver_info = (BRIDGE_ ## bridge << 16) \
-			| SENSOR_ ## sensor
+			| (SENSOR_ ## sensor << 8)
+#define BSF(bridge, sensor, flags) \
+	.driver_info = (BRIDGE_ ## bridge << 16) \
+			| (SENSOR_ ## sensor << 8) \
+			| (flags)
 static const __devinitdata struct usb_device_id device_table[] = {
 #if !defined CONFIG_USB_SN9C102 && !defined CONFIG_USB_SN9C102_MODULE
 	{USB_DEVICE(0x0458, 0x7025), BS(SN9C120, MI0360)},
-- 
1.7.2.3

