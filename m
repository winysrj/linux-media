Return-path: <mchehab@gaivota>
Received: from smtp5-g21.free.fr ([212.27.42.5]:34759 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757498Ab0LMNB0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 08:01:26 -0500
Date: Mon, 13 Dec 2010 14:03:26 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 3/6] gspca - sonixj: Add a flag in the driver_info table
Message-ID: <20101213140326.569d150d@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


Signed-off-by: Jean-François Moine <moinejf@free.fr>

diff --git a/drivers/media/video/gspca/sonixj.c b/drivers/media/video/gspca/sonixj.c
index 5978676..bd5858e 100644
--- a/drivers/media/video/gspca/sonixj.c
+++ b/drivers/media/video/gspca/sonixj.c
@@ -64,6 +64,7 @@ struct sd {
 	u8 jpegqual;			/* webcam quality */
 
 	u8 reg18;
+	u8 flags;
 
 	s8 ag_cnt;
 #define AG_CNT_START 13
@@ -96,6 +97,9 @@ enum sensors {
 	SENSOR_SP80708,
 };
 
+/* device flags */
+#define PDN_INV	1		/* inverse pin S_PWR_DN / sn_xxx tables */
+
 /* V4L2 controls supported by the driver */
 static void setbrightness(struct gspca_dev *gspca_dev);
 static void setcontrast(struct gspca_dev *gspca_dev);
@@ -1763,7 +1767,8 @@ static int sd_config(struct gspca_dev *gspca_dev,
 	struct cam *cam;
 
 	sd->bridge = id->driver_info >> 16;
-	sd->sensor = id->driver_info;
+	sd->sensor = id->driver_info >> 8;
+	sd->flags = id->driver_info;
 
 	cam = &gspca_dev->cam;
 	if (sd->sensor == SENSOR_ADCM1700) {
@@ -2947,7 +2952,11 @@ static const struct sd_desc sd_desc = {
 /* -- module initialisation -- */
 #define BS(bridge, sensor) \
 	.driver_info = (BRIDGE_ ## bridge << 16) \
-			| SENSOR_ ## sensor
+			| (SENSOR_ ## sensor << 8)
+#define BSF(bridge, sensor, flags) \
+	.driver_info = (BRIDGE_ ## bridge << 16) \
+			| (SENSOR_ ## sensor << 8) \
+			| flags
 static const __devinitdata struct usb_device_id device_table[] = {
 #if !defined CONFIG_USB_SN9C102 && !defined CONFIG_USB_SN9C102_MODULE
 	{USB_DEVICE(0x0458, 0x7025), BS(SN9C120, MI0360)},
-- 
1.7.2.3

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
