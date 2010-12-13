Return-path: <mchehab@gaivota>
Received: from smtp5-g21.free.fr ([212.27.42.5]:35482 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757498Ab0LMNBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 08:01:45 -0500
Date: Mon, 13 Dec 2010 14:03:45 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 4/6] gspca - sonixj: Set the flag for some devices
Message-ID: <20101213140345.55f40fb9@tele>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


The flag PDN_INV indicates that the sensor pin S_PWR_DN has not the same
value as other webcams with the same sensor. For now, only two webcams
have been detected so: the Microsoft's VX1000 and VX3000.

Signed-off-by: Jean-François Moine <moinejf@free.fr>

diff --git a/drivers/media/video/gspca/sonixj.c b/drivers/media/video/gspca/sonixj.c
index bd5858e..9b7e28a 100644
--- a/drivers/media/video/gspca/sonixj.c
+++ b/drivers/media/video/gspca/sonixj.c
@@ -2962,8 +2962,8 @@ static const __devinitdata struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x0458, 0x7025), BS(SN9C120, MI0360)},
 	{USB_DEVICE(0x0458, 0x702e), BS(SN9C120, OV7660)},
 #endif
-	{USB_DEVICE(0x045e, 0x00f5), BS(SN9C105, OV7660)},
-	{USB_DEVICE(0x045e, 0x00f7), BS(SN9C105, OV7660)},
+	{USB_DEVICE(0x045e, 0x00f5), BSF(SN9C105, OV7660, PDN_INV)},
+	{USB_DEVICE(0x045e, 0x00f7), BSF(SN9C105, OV7660, PDN_INV)},
 	{USB_DEVICE(0x0471, 0x0327), BS(SN9C105, MI0360)},
 	{USB_DEVICE(0x0471, 0x0328), BS(SN9C105, MI0360)},
 	{USB_DEVICE(0x0471, 0x0330), BS(SN9C105, MI0360)},
-- 
1.7.2.3

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
