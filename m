Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64232 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab2BWQkV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Feb 2012 11:40:21 -0500
Received: by eaah12 with SMTP id h12so661766eaa.19
        for <linux-media@vger.kernel.org>; Thu, 23 Feb 2012 08:40:20 -0800 (PST)
Message-ID: <4F466BEF.9050204@gmail.com>
Date: Thu, 23 Feb 2012 17:40:15 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] Support for AF9035/AF9033
References: <201202222320.56583.hfvogt@gmx.net>
In-Reply-To: <201202222320.56583.hfvogt@gmx.net>
Content-Type: multipart/mixed;
 boundary="------------090206030503010402080203"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090206030503010402080203
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Il 22/02/2012 23:20, Hans-Frieder Vogt ha scritto:
> I have written a driver for the AF9035 & AF9033 (called af903x), based on the 
> various drivers and information floating around for these chips.
> Currently, my driver only supports the devices that I am able to test. These 
> are
> - Terratec T5 Ver.2 (also known as T6)
> - Avermedia Volar HD Nano (A867)
> 
> The driver supports:
> - diversity and dual tuner (when the first frontend is used, it is in diversity 
> mode, when two frontends are used in dual tuner mode)
> - multiple devices
> - pid filtering
> - remote control in NEC and RC-6 mode (currently not switchable, but depending 
> on device)
> - support for kernel 3.1, 3.2 and 3.3 series
> 
> I have not tried to split the driver in a DVB-T receiver (af9035) and a 
> frontend (af9033), because I do not see the sense in doing that for a 
> demodulator, that seems to be always used in combination with the very same 
> receiver.
> 
> The patch is split in three parts:
> Patch 1: support for tuner fitipower FC0012
> Patch 2: basic driver
> Patch 3: firmware
> 
> Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net

Hi Hans,
thank you for the new af903x driver.
A few comments:

1) I think you should set up a git repository with your driver and then
send a PULL request to the list; as it is, the first patch is affected
by line-wrapping problems so it must be manually edited to be
applicable, and the second patch is compressed so it will be ignored by
patchwork.

2) There are a couple of small errors in the patches (see my attached
patches): in the dvb-usb Makefile,  DVB_USB_AF903X must be replaced by
CONFIG_DVB_USB_AF903X otherwise the driver will not compile; also, in
the dvb_frontend_ops struct, the field info.type should be removed for
kernels >= 3.3.0.

3) The USB VID/PID IDs should be moved into dvb-usb-ids.h (see patch 3);
I also added a few IDs from the Avermedia A867 driver*. As your driver
supports both AF9007 and mxl5007t tuners I think this is safe.

*http://www.avermedia.com/Support/DownloadCount.aspx?FDFId=4591

4) the driver also looks for a firmware file called "af35irtbl.bin" that
comes from the "official" ITEtech driver (if it's not present the driver
works anyway, but it prints an error message);

I tested the driver with an Avermedia A867 stick (it's an OEM stick also
known as the Sky Italia Digital Key with blue led: 07ca:a867) on a
Ubuntu 10.04 system with kernel 2.6.32-38-generic-pae and the latest
media_build tree installed.

The good news:
the driver loads properly, and, using Kaffeine, I could watch several
channels with a small portable antenna; I could also perform a full
frequency scan, finding several UHF and VHF stations. Signal strength
and SNR reports works really well, and they seems to give a "realistic"
figure of the signal quality (with both the portable and the rooftop
antenna).
When the stick is unplugged from the USB port, the driver unloads properly.

The bad news:
the driver seems to "lock" the application when it tries to tune a weak
channel: in this cases, Kaffeine becomes unresponsive and sometimes it
gives a stream error; for the same reason, the full scan fails to find
all stations and takes a long time to complete.
Also, when I tried to extract the stick from the USB port during one of
this "freezing" periods, the system crashed :-(
I reproduced this bug 3 times, and the last time I was able to see a
kernel dump for a moment: the function that crashed the kernel was
"af903x_streaming_ctrl".
Neither of those issues are present with the Avermedia A867 original
driver or Antti Palosaari's af9035 driver modified to support the A867
stick.

I hope this feedback will be useful to improve the driver.

Best regards,
Gianluca Gennari

--------------090206030503010402080203
Content-Type: text/x-patch;
 name="0001-af903x-fixed-Makefile.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-af903x-fixed-Makefile.patch"

[PATCH 1/3] af903x: fixed Makefile

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/dvb/dvb-usb/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/Makefile b/drivers/media/dvb/dvb-usb/Makefile
index 75780e2..49c5425 100644
--- a/drivers/media/dvb/dvb-usb/Makefile
+++ b/drivers/media/dvb/dvb-usb/Makefile
@@ -76,7 +76,7 @@ dvb-usb-af9015-objs = af9015.o
 obj-$(CONFIG_DVB_USB_AF9015) += dvb-usb-af9015.o
 
 dvb-usb-af903x-objs = af903x-core.o af903x-devices.o af903x-fe.o af903x-tuners.o
-obj-$(DVB_USB_AF903X) += dvb-usb-af903x.o
+obj-$(CONFIG_DVB_USB_AF903X) += dvb-usb-af903x.o
 
 dvb-usb-cinergyT2-objs = cinergyT2-core.o cinergyT2-fe.o
 obj-$(CONFIG_DVB_USB_CINERGY_T2) += dvb-usb-cinergyT2.o
-- 
1.7.0.4


--------------090206030503010402080203
Content-Type: text/x-patch;
 name="0002-af903x-removed-frontend-info.type-for-kernel-3.3.0.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-af903x-removed-frontend-info.type-for-kernel-3.3.0.patc";
 filename*1="h"

[PATCH 2/3] af903x: removed frontend info.type for kernels >= 3.3.0

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/dvb/dvb-usb/af903x-fe.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af903x-fe.c b/drivers/media/dvb/dvb-usb/af903x-fe.c
index a782c96..8d58efb 100644
--- a/drivers/media/dvb/dvb-usb/af903x-fe.c
+++ b/drivers/media/dvb/dvb-usb/af903x-fe.c
@@ -2110,7 +2110,9 @@ static struct dvb_frontend_ops af903x_ops = {
 #endif
 	.info = {
 		.name = "AF903X USB DVB-T",
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0)
 		.type = FE_OFDM,
+#endif
 		.frequency_min      = AF903X_FE_FREQ_MIN,
 		.frequency_max      = AF903X_FE_FREQ_MAX,
 		.frequency_stepsize = 62500,
-- 
1.7.0.4


--------------090206030503010402080203
Content-Type: text/x-patch;
 name="0003-af903x-add-new-USB-VID-PID-IDs.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0003-af903x-add-new-USB-VID-PID-IDs.patch"

[PATCH 3/3] af903x: add new USB VID/PID IDs and move definitions to dvb-usb-ids.h

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 drivers/media/dvb/dvb-usb/af903x-devices.c |   72 +++++++++++++++++++++++-----
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h    |   16 ++++++
 2 files changed, 76 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/af903x-devices.c b/drivers/media/dvb/dvb-usb/af903x-devices.c
index 21ece97..06e96f4 100644
--- a/drivers/media/dvb/dvb-usb/af903x-devices.c
+++ b/drivers/media/dvb/dvb-usb/af903x-devices.c
@@ -1216,18 +1216,50 @@ enum af903x_table_entry {
 	AFATECH_AF9035,
 	TERRATEC_T6,		/* Terratec T6 */
 	TERRATEC_T5_REV2,	/* Terratec T5 Rev.2 */
+	AVERMEDIA_TWINSTAR,	/* Avermedia TwinStar */
 	AVERMEDIA_A867,		/* Avermedia HD Volar / A867 */
+	AVERMEDIA_A333,		/* Avermedia A333 */
+	AVERMEDIA_B867,
+	AVERMEDIA_1867,
+	AVERMEDIA_0337,
+	AVERMEDIA_0867,
+	AVERMEDIA_F337,
+	AVERMEDIA_3867,
 };
 
 struct usb_device_id af903x_usb_table[] = {
-	[AFATECH_1000] = { USB_DEVICE(0x15A4,0x1000) },
-	[AFATECH_1001] = { USB_DEVICE(0x15A4,0x1001) },
-	[AFATECH_1002] = { USB_DEVICE(0x15A4,0x1002) },
-	[AFATECH_1003] = { USB_DEVICE(0x15A4,0x1003) },
-	[AFATECH_AF9035] = { USB_DEVICE(0x15A4,0x9035) },
-	[TERRATEC_T6] = { USB_DEVICE(0x0ccd,0x10b3) },
-	[TERRATEC_T5_REV2] = { USB_DEVICE(0x0ccd,0x10b7) },
-	[AVERMEDIA_A867] = { USB_DEVICE(0x07ca,0x1867) },
+	[AFATECH_1000] = {USB_DEVICE(USB_VID_AFATECH,
+				USB_PID_AFATECH_AF9035_1000)},
+	[AFATECH_1001] = {USB_DEVICE(USB_VID_AFATECH,
+				USB_PID_AFATECH_AF9035_1001)},
+	[AFATECH_1002] = {USB_DEVICE(USB_VID_AFATECH,
+				USB_PID_AFATECH_AF9035_1002)},
+	[AFATECH_1003] = {USB_DEVICE(USB_VID_AFATECH,
+				USB_PID_AFATECH_AF9035_1003)},
+	[AFATECH_AF9035] = {USB_DEVICE(USB_VID_AFATECH,
+				USB_PID_AFATECH_AF9035_9035)},
+	[TERRATEC_T6] = {USB_DEVICE(USB_VID_TERRATEC,
+				USB_PID_TERRATEC_T6)},
+	[TERRATEC_T5_REV2] = {USB_DEVICE(USB_VID_TERRATEC,
+				USB_PID_TERRATEC_T5_REV2)},
+	[AVERMEDIA_TWINSTAR] = {USB_DEVICE(USB_VID_AVERMEDIA,
+				USB_PID_AVERMEDIA_A825)},
+	[AVERMEDIA_A333] = {USB_DEVICE(USB_VID_AVERMEDIA,
+				USB_PID_AVERMEDIA_A333)},
+	[AVERMEDIA_B867] = {USB_DEVICE(USB_VID_AVERMEDIA,
+				USB_PID_AVERMEDIA_B867)},
+	[AVERMEDIA_1867] = {USB_DEVICE(USB_VID_AVERMEDIA,
+				USB_PID_AVERMEDIA_1867)},
+	[AVERMEDIA_0337] = {USB_DEVICE(USB_VID_AVERMEDIA,
+				USB_PID_AVERMEDIA_0337)},
+	[AVERMEDIA_A867] = {USB_DEVICE(USB_VID_AVERMEDIA,
+				USB_PID_AVERMEDIA_A867)},
+	[AVERMEDIA_0867] = {USB_DEVICE(USB_VID_AVERMEDIA,
+				USB_PID_AVERMEDIA_0867)},
+	[AVERMEDIA_F337] = {USB_DEVICE(USB_VID_AVERMEDIA,
+				USB_PID_AVERMEDIA_F337)},
+	[AVERMEDIA_3867] = {USB_DEVICE(USB_VID_AVERMEDIA,
+				USB_PID_AVERMEDIA_3867)},
 	{ 0},		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, af903x_usb_table);
@@ -1310,9 +1342,9 @@ struct dvb_usb_device_properties af903x_properties[] = {
 			.rc_codes	= NULL, /* will be set in
 						   af903x_identify_state */
 		},
-		.num_device_descs =4,
+		.num_device_descs = 6,
 		.devices =  {
-			{   	"ITEtech USB2.0 DVB-T Recevier",
+			{   	"ITEtech AF903x USB2.0 DVB-T Receiver",
 				{ &af903x_usb_table[AFATECH_1000],
 				  &af903x_usb_table[AFATECH_1001],
 				  &af903x_usb_table[AFATECH_1002], 
@@ -1329,8 +1361,24 @@ struct dvb_usb_device_properties af903x_properties[] = {
 				{ NULL },
 			},
 			{
-				"AVerMedia A867 DVB-T Recevier",
-				{ &af903x_usb_table[AVERMEDIA_A867], NULL},
+				"Avermedia TwinStar",
+				{ &af903x_usb_table[AVERMEDIA_TWINSTAR], NULL},
+				{ NULL },
+			},
+			{
+				"AVerMedia A333 DVB-T Receiver",
+				{ &af903x_usb_table[AVERMEDIA_A333],
+				  &af903x_usb_table[AVERMEDIA_B867], NULL},
+                            	{ NULL },
+			},
+			{
+				"AVerMedia A867 DVB-T Receiver",
+				{ &af903x_usb_table[AVERMEDIA_1867],
+				  &af903x_usb_table[AVERMEDIA_0337],
+				  &af903x_usb_table[AVERMEDIA_A867],
+				  &af903x_usb_table[AVERMEDIA_0867],
+				  &af903x_usb_table[AVERMEDIA_F337],
+				  &af903x_usb_table[AVERMEDIA_3867], NULL},
                             	{ NULL },
 			},
 			{NULL},
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index 9c3dae1..6ed83fd 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -75,6 +75,11 @@
 #define USB_PID_AFATECH_AF9005				0x9020
 #define USB_PID_AFATECH_AF9015_9015			0x9015
 #define USB_PID_AFATECH_AF9015_9016			0x9016
+#define USB_PID_AFATECH_AF9035_1000			0x1000
+#define USB_PID_AFATECH_AF9035_1001			0x1001
+#define USB_PID_AFATECH_AF9035_1002			0x1002
+#define USB_PID_AFATECH_AF9035_1003			0x1003
+#define USB_PID_AFATECH_AF9035_9035			0x9035
 #define USB_PID_TREKSTOR_DVBT				0x901b
 #define USB_VID_ALINK_DTU				0xf170
 #define USB_PID_ANSONIC_DVBT_USB			0x6000
@@ -218,6 +223,15 @@
 #define USB_PID_AVERMEDIA_A850T				0x850b
 #define USB_PID_AVERMEDIA_A805				0xa805
 #define USB_PID_AVERMEDIA_A815M				0x815a
+#define USB_PID_AVERMEDIA_A825				0x0825
+#define USB_PID_AVERMEDIA_A333				0xa333
+#define USB_PID_AVERMEDIA_B867				0xb867
+#define USB_PID_AVERMEDIA_1867				0x1867
+#define USB_PID_AVERMEDIA_0337				0x0337
+#define USB_PID_AVERMEDIA_A867				0xa867
+#define USB_PID_AVERMEDIA_0867				0x0867
+#define USB_PID_AVERMEDIA_F337				0xf337
+#define USB_PID_AVERMEDIA_3867				0x3867
 #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
 #define USB_PID_TECHNOTREND_CONNECT_CT3650		0x300d
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY	0x005a
@@ -231,6 +245,8 @@
 #define USB_PID_TERRATEC_H7_2				0x10a3
 #define USB_PID_TERRATEC_T3				0x10a0
 #define USB_PID_TERRATEC_T5				0x10a1
+#define USB_PID_TERRATEC_T5_REV2			0x10b7
+#define USB_PID_TERRATEC_T6				0x10b3
 #define USB_PID_PINNACLE_EXPRESSCARD_320CX		0x022e
 #define USB_PID_PINNACLE_PCTV2000E			0x022c
 #define USB_PID_PINNACLE_PCTV_DVB_T_FLASH		0x0228
-- 
1.7.0.4


--------------090206030503010402080203--
