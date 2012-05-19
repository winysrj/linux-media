Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:36642 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751298Ab2ESRSr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 May 2012 13:18:47 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] radio-sf16fmi: add support for SF16-FMD
Date: Sat, 19 May 2012 19:18:26 +0200
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201205191918.29217.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for SF16-FMD card to radio-sf16fmi driver.
Only new PnP ID is added and texts changed.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/drivers/media/radio/Kconfig
+++ b/drivers/media/radio/Kconfig
@@ -320,7 +320,7 @@ config RADIO_MIROPCM20
 	  module will be called radio-miropcm20.
 
 config RADIO_SF16FMI
-	tristate "SF16-FMI/SF16-FMP Radio"
+	tristate "SF16-FMI/SF16-FMP/SF16-FMD Radio"
 	depends on ISA && VIDEO_V4L2
 	---help---
 	  Choose Y here if you have one of these FM radio cards.
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -1,4 +1,4 @@
-/* SF16-FMI and SF16-FMP radio driver for Linux radio support
+/* SF16-FMI, SF16-FMP and SF16-FMD radio driver for Linux radio support
  * heavily based on rtrack driver...
  * (c) 1997 M. Kirkwood
  * (c) 1998 Petr Vandrovec, vandrove@vc.cvut.cz
@@ -11,7 +11,7 @@
  *
  *  Frequency control is done digitally -- ie out(port,encodefreq(95.8));
  *  No volume control - only mute/unmute - you have to use line volume
- *  control on SB-part of SF16-FMI/SF16-FMP
+ *  control on SB-part of SF16-FMI/SF16-FMP/SF16-FMD
  *
  * Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@infradead.org>
  */
@@ -29,7 +29,7 @@
 #include <media/v4l2-ioctl.h>
 
 MODULE_AUTHOR("Petr Vandrovec, vandrove@vc.cvut.cz and M. Kirkwood");
-MODULE_DESCRIPTION("A driver for the SF16-FMI and SF16-FMP radio.");
+MODULE_DESCRIPTION("A driver for the SF16-FMI, SF16-FMP and SF16-FMD radio.");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.0.3");
 
@@ -37,7 +37,7 @@ static int io = -1;
 static int radio_nr = -1;
 
 module_param(io, int, 0);
-MODULE_PARM_DESC(io, "I/O address of the SF16-FMI or SF16-FMP card (0x284 or 0x384)");
+MODULE_PARM_DESC(io, "I/O address of the SF16-FMI/SF16-FMP/SF16-FMD card (0x284 or 0x384)");
 module_param(radio_nr, int, 0);
 
 struct fmi
@@ -130,7 +130,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *v)
 {
 	strlcpy(v->driver, "radio-sf16fmi", sizeof(v->driver));
-	strlcpy(v->card, "SF16-FMx radio", sizeof(v->card));
+	strlcpy(v->card, "SF16-FMI/FMP/FMD radio", sizeof(v->card));
 	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
 	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	return 0;
@@ -277,8 +277,12 @@ static const struct v4l2_ioctl_ops fmi_ioctl_ops = {
 
 /* ladis: this is my card. does any other types exist? */
 static struct isapnp_device_id id_table[] __devinitdata = {
+		/* SF16-FMI */
 	{	ISAPNP_ANY_ID, ISAPNP_ANY_ID,
 		ISAPNP_VENDOR('M','F','R'), ISAPNP_FUNCTION(0xad10), 0},
+		/* SF16-FMD */
+	{	ISAPNP_ANY_ID, ISAPNP_ANY_ID,
+		ISAPNP_VENDOR('M','F','R'), ISAPNP_FUNCTION(0xad12), 0},
 	{	ISAPNP_CARD_END, },
 };
 

-- 
Ondrej Zary
