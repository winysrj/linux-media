Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4VFLNTO002806
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 11:21:23 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m4VFL1T8018862
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 11:21:01 -0400
Content-Disposition: inline
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Sat, 31 May 2008 17:20:51 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200805311720.51821.tobias.lorenz@gmx.net>
Content-Transfer-Encoding: 8bit
Cc: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Subject: [PATCH 6/6] si470x: pri... vid.. controls
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Mauro,

I better resend this patch with a scrambled header...
"private video controls" is regarded as suspicious header by the spam filter of video4linux-list.

This patch brings the following changes:
- private video controls
  - to control seek behaviour
  - to module parameters
  - corrected access rights of module parameters
  - separate header file to let the user space know about it

Best regards,

Toby

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
diff --exclude='*.o' --exclude='*.ko' --exclude='.*' --exclude='*.mod.*' --exclude=modules.order --exclude=autoconf.h --exclude=compile.h --exclude=version.h --exclude=utsrelease.h -uprN 5_hw_seek/drivers/media/radio/radio-si470x.c 6_priv_vidioc/drivers/media/radio/radio-si470x.c
--- 5_hw_seek/drivers/media/radio/radio-si470x.c	2008-05-31 16:31:15.000000000 +0200
+++ 6_priv_vidioc/drivers/media/radio/radio-si470x.c	2008-05-31 16:32:34.000000000 +0200
@@ -103,6 +103,9 @@
  *		Version 1.0.8
  *		- hardware frequency seek support
  *		- afc indication
+ *		- implementation of private video controls for
+ *		  seek options and band/space/de changes
+ *		- register definitions moved to separate header file
  *		- more safety checks, let si470x_get_freq return errno
  *
  * ToDo:
@@ -137,6 +140,7 @@
 #endif
 #include <media/v4l2-common.h>
 #include <media/rds.h>
+#include <media/radio-si470x.h>
 #include <asm/unaligned.h>
 
 
@@ -159,7 +163,7 @@ MODULE_DEVICE_TABLE(usb, si470x_usb_driv
 
 /* Radio Nr */
 static int radio_nr = -1;
-module_param(radio_nr, int, 0);
+module_param(radio_nr, int, 0444);
 MODULE_PARM_DESC(radio_nr, "Radio Nr");
 
 /* Spacing (kHz) */
@@ -167,7 +171,7 @@ MODULE_PARM_DESC(radio_nr, "Radio Nr");
 /* 1: 100 kHz (Europe, Japan) */
 /* 2:  50 kHz */
 static unsigned short space = 2;
-module_param(space, ushort, 0);
+module_param(space, ushort, 0444);
 MODULE_PARM_DESC(radio_nr, "Spacing: 0=200kHz 1=100kHz *2=50kHz*");
 
 /* Bottom of Band (MHz) */
@@ -175,34 +179,34 @@ MODULE_PARM_DESC(radio_nr, "Spacing: 0=2
 /* 1: 76   - 108 MHz (Japan wide band) */
 /* 2: 76   -  90 MHz (Japan) */
 static unsigned short band = 1;
-module_param(band, ushort, 0);
+module_param(band, ushort, 0444);
 MODULE_PARM_DESC(radio_nr, "Band: 0=87.5..108MHz *1=76..108MHz* 2=76..90MHz");
 
 /* De-emphasis */
 /* 0: 75 us (USA) */
 /* 1: 50 us (Europe, Australia, Japan) */
 static unsigned short de = 1;
-module_param(de, ushort, 0);
+module_param(de, ushort, 0444);
 MODULE_PARM_DESC(radio_nr, "De-emphasis: 0=75us *1=50us*");
 
 /* USB timeout */
 static unsigned int usb_timeout = 500;
-module_param(usb_timeout, uint, 0);
+module_param(usb_timeout, uint, 0644);
 MODULE_PARM_DESC(usb_timeout, "USB timeout (ms): *500*");
 
 /* Tune timeout */
 static unsigned int tune_timeout = 3000;
-module_param(tune_timeout, uint, 0);
+module_param(tune_timeout, uint, 0644);
 MODULE_PARM_DESC(tune_timeout, "Tune timeout: *3000*");
 
 /* Seek timeout */
 static unsigned int seek_timeout = 5000;
-module_param(seek_timeout, uint, 0);
+module_param(seek_timeout, uint, 0644);
 MODULE_PARM_DESC(seek_timeout, "Seek timeout: *5000*");
 
 /* RDS buffer blocks */
 static unsigned int rds_buf = 100;
-module_param(rds_buf, uint, 0);
+module_param(rds_buf, uint, 0444);
 MODULE_PARM_DESC(rds_buf, "RDS buffer entries: *100*");
 
 /* RDS maximum block errors */
@@ -211,7 +215,7 @@ static unsigned short max_rds_errors = 1
 /* 1 means 1-2  errors requiring correction (used by original USBRadio.exe) */
 /* 2 means 3-5  errors requiring correction */
 /* 3 means   6+ errors or errors in checkword, correction not possible */
-module_param(max_rds_errors, ushort, 0);
+module_param(max_rds_errors, ushort, 0644);
 MODULE_PARM_DESC(max_rds_errors, "RDS maximum block errors: *1*");
 
 /* RDS poll frequency */
@@ -220,222 +224,12 @@ static unsigned int rds_poll_time = 40;
 /* 50 is used by radio-cadet */
 /* 75 should be okay */
 /* 80 is the usual RDS receive interval */
-module_param(rds_poll_time, uint, 0);
+module_param(rds_poll_time, uint, 0644);
 MODULE_PARM_DESC(rds_poll_time, "RDS poll time (ms): *40*");
 
 
 
 /**************************************************************************
- * Register Definitions
- **************************************************************************/
-#define RADIO_REGISTER_SIZE	2	/* 16 register bit width */
-#define RADIO_REGISTER_NUM	16	/* DEVICEID   ... RDSD */
-#define RDS_REGISTER_NUM	6	/* STATUSRSSI ... RDSD */
-
-#define DEVICEID		0	/* Device ID */
-#define DEVICEID_PN		0xf000	/* bits 15..12: Part Number */
-#define DEVICEID_MFGID		0x0fff	/* bits 11..00: Manufacturer ID */
-
-#define CHIPID			1	/* Chip ID */
-#define CHIPID_REV		0xfc00	/* bits 15..10: Chip Version */
-#define CHIPID_DEV		0x0200	/* bits 09..09: Device */
-#define CHIPID_FIRMWARE		0x01ff	/* bits 08..00: Firmware Version */
-
-#define POWERCFG		2	/* Power Configuration */
-#define POWERCFG_DSMUTE		0x8000	/* bits 15..15: Softmute Disable */
-#define POWERCFG_DMUTE		0x4000	/* bits 14..14: Mute Disable */
-#define POWERCFG_MONO		0x2000	/* bits 13..13: Mono Select */
-#define POWERCFG_RDSM		0x0800	/* bits 11..11: RDS Mode (Si4701 only) */
-#define POWERCFG_SKMODE		0x0400	/* bits 10..10: Seek Mode */
-#define POWERCFG_SEEKUP		0x0200	/* bits 09..09: Seek Direction */
-#define POWERCFG_SEEK		0x0100	/* bits 08..08: Seek */
-#define POWERCFG_DISABLE	0x0040	/* bits 06..06: Powerup Disable */
-#define POWERCFG_ENABLE		0x0001	/* bits 00..00: Powerup Enable */
-
-#define CHANNEL			3	/* Channel */
-#define CHANNEL_TUNE		0x8000	/* bits 15..15: Tune */
-#define CHANNEL_CHAN		0x03ff	/* bits 09..00: Channel Select */
-
-#define SYSCONFIG1		4	/* System Configuration 1 */
-#define SYSCONFIG1_RDSIEN	0x8000	/* bits 15..15: RDS Interrupt Enable (Si4701 only) */
-#define SYSCONFIG1_STCIEN	0x4000	/* bits 14..14: Seek/Tune Complete Interrupt Enable */
-#define SYSCONFIG1_RDS		0x1000	/* bits 12..12: RDS Enable (Si4701 only) */
-#define SYSCONFIG1_DE		0x0800	/* bits 11..11: De-emphasis (0=75us 1=50us) */
-#define SYSCONFIG1_AGCD		0x0400	/* bits 10..10: AGC Disable */
-#define SYSCONFIG1_BLNDADJ	0x00c0	/* bits 07..06: Stereo/Mono Blend Level Adjustment */
-#define SYSCONFIG1_GPIO3	0x0030	/* bits 05..04: General Purpose I/O 3 */
-#define SYSCONFIG1_GPIO2	0x000c	/* bits 03..02: General Purpose I/O 2 */
-#define SYSCONFIG1_GPIO1	0x0003	/* bits 01..00: General Purpose I/O 1 */
-
-#define SYSCONFIG2		5	/* System Configuration 2 */
-#define SYSCONFIG2_SEEKTH	0xff00	/* bits 15..08: RSSI Seek Threshold */
-#define SYSCONFIG2_BAND		0x0080	/* bits 07..06: Band Select */
-#define SYSCONFIG2_SPACE	0x0030	/* bits 05..04: Channel Spacing */
-#define SYSCONFIG2_VOLUME	0x000f	/* bits 03..00: Volume */
-
-#define SYSCONFIG3		6	/* System Configuration 3 */
-#define SYSCONFIG3_SMUTER	0xc000	/* bits 15..14: Softmute Attack/Recover Rate */
-#define SYSCONFIG3_SMUTEA	0x3000	/* bits 13..12: Softmute Attenuation */
-#define SYSCONFIG3_SKSNR	0x00f0	/* bits 07..04: Seek SNR Threshold */
-#define SYSCONFIG3_SKCNT	0x000f	/* bits 03..00: Seek FM Impulse Detection Threshold */
-
-#define TEST1			7	/* Test 1 */
-#define TEST1_AHIZEN		0x4000	/* bits 14..14: Audio High-Z Enable */
-
-#define TEST2			8	/* Test 2 */
-/* TEST2 only contains reserved bits */
-
-#define BOOTCONFIG		9	/* Boot Configuration */
-/* BOOTCONFIG only contains reserved bits */
-
-#define STATUSRSSI		10	/* Status RSSI */
-#define STATUSRSSI_RDSR		0x8000	/* bits 15..15: RDS Ready (Si4701 only) */
-#define STATUSRSSI_STC		0x4000	/* bits 14..14: Seek/Tune Complete */
-#define STATUSRSSI_SF		0x2000	/* bits 13..13: Seek Fail/Band Limit */
-#define STATUSRSSI_AFCRL	0x1000	/* bits 12..12: AFC Rail */
-#define STATUSRSSI_RDSS		0x0800	/* bits 11..11: RDS Synchronized (Si4701 only) */
-#define STATUSRSSI_BLERA	0x0600	/* bits 10..09: RDS Block A Errors (Si4701 only) */
-#define STATUSRSSI_ST		0x0100	/* bits 08..08: Stereo Indicator */
-#define STATUSRSSI_RSSI		0x00ff	/* bits 07..00: RSSI (Received Signal Strength Indicator) */
-
-#define READCHAN		11	/* Read Channel */
-#define READCHAN_BLERB		0xc000	/* bits 15..14: RDS Block D Errors (Si4701 only) */
-#define READCHAN_BLERC		0x3000	/* bits 13..12: RDS Block C Errors (Si4701 only) */
-#define READCHAN_BLERD		0x0c00	/* bits 11..10: RDS Block B Errors (Si4701 only) */
-#define READCHAN_READCHAN	0x03ff	/* bits 09..00: Read Channel */
-
-#define RDSA			12	/* RDSA */
-#define RDSA_RDSA		0xffff	/* bits 15..00: RDS Block A Data (Si4701 only) */
-
-#define RDSB			13	/* RDSB */
-#define RDSB_RDSB		0xffff	/* bits 15..00: RDS Block B Data (Si4701 only) */
-
-#define RDSC			14	/* RDSC */
-#define RDSC_RDSC		0xffff	/* bits 15..00: RDS Block C Data (Si4701 only) */
-
-#define RDSD			15	/* RDSD */
-#define RDSD_RDSD		0xffff	/* bits 15..00: RDS Block D Data (Si4701 only) */
-
-
-
-/**************************************************************************
- * USB HID Reports
- **************************************************************************/
-
-/* Reports 1-16 give direct read/write access to the 16 Si470x registers */
-/* with the (REPORT_ID - 1) corresponding to the register address across USB */
-/* endpoint 0 using GET_REPORT and SET_REPORT */
-#define REGISTER_REPORT_SIZE	(RADIO_REGISTER_SIZE + 1)
-#define REGISTER_REPORT(reg)	((reg) + 1)
-
-/* Report 17 gives direct read/write access to the entire Si470x register */
-/* map across endpoint 0 using GET_REPORT and SET_REPORT */
-#define ENTIRE_REPORT_SIZE	(RADIO_REGISTER_NUM * RADIO_REGISTER_SIZE + 1)
-#define ENTIRE_REPORT		17
-
-/* Report 18 is used to send the lowest 6 Si470x registers up the HID */
-/* interrupt endpoint 1 to Windows every 20 milliseconds for status */
-#define RDS_REPORT_SIZE		(RDS_REGISTER_NUM * RADIO_REGISTER_SIZE + 1)
-#define RDS_REPORT		18
-
-/* Report 19: LED state */
-#define LED_REPORT_SIZE		3
-#define LED_REPORT		19
-
-/* Report 19: stream */
-#define STREAM_REPORT_SIZE	3
-#define	STREAM_REPORT		19
-
-/* Report 20: scratch */
-#define SCRATCH_PAGE_SIZE	63
-#define SCRATCH_REPORT_SIZE	(SCRATCH_PAGE_SIZE + 1)
-#define SCRATCH_REPORT		20
-
-/* Reports 19-22: flash upgrade of the C8051F321 */
-#define WRITE_REPORT		19
-#define FLASH_REPORT		20
-#define CRC_REPORT		21
-#define RESPONSE_REPORT		22
-
-/* Report 23: currently unused, but can accept 60 byte reports on the HID */
-/* interrupt out endpoint 2 every 1 millisecond */
-#define UNUSED_REPORT		23
-
-
-
-/**************************************************************************
- * Software/Hardware Versions
- **************************************************************************/
-#define RADIO_SW_VERSION_NOT_BOOTLOADABLE	6
-#define RADIO_SW_VERSION			7
-#define RADIO_SW_VERSION_CURRENT		15
-#define RADIO_HW_VERSION			1
-
-#define SCRATCH_PAGE_SW_VERSION	1
-#define SCRATCH_PAGE_HW_VERSION	2
-
-
-
-/**************************************************************************
- * LED State Definitions
- **************************************************************************/
-#define LED_COMMAND		0x35
-
-#define NO_CHANGE_LED		0x00
-#define ALL_COLOR_LED		0x01	/* streaming state */
-#define BLINK_GREEN_LED		0x02	/* connect state */
-#define BLINK_RED_LED		0x04
-#define BLINK_ORANGE_LED	0x10	/* disconnect state */
-#define SOLID_GREEN_LED		0x20	/* tuning/seeking state */
-#define SOLID_RED_LED		0x40	/* bootload state */
-#define SOLID_ORANGE_LED	0x80
-
-
-
-/**************************************************************************
- * Stream State Definitions
- **************************************************************************/
-#define STREAM_COMMAND	0x36
-#define STREAM_VIDPID	0x00
-#define STREAM_AUDIO	0xff
-
-
-
-/**************************************************************************
- * Bootloader / Flash Commands
- **************************************************************************/
-
-/* unique id sent to bootloader and required to put into a bootload state */
-#define UNIQUE_BL_ID		0x34
-
-/* mask for the flash data */
-#define FLASH_DATA_MASK		0x55
-
-/* bootloader commands */
-#define GET_SW_VERSION_COMMAND	0x00
-#define	SET_PAGE_COMMAND	0x01
-#define ERASE_PAGE_COMMAND	0x02
-#define WRITE_PAGE_COMMAND	0x03
-#define CRC_ON_PAGE_COMMAND	0x04
-#define READ_FLASH_BYTE_COMMAND	0x05
-#define RESET_DEVICE_COMMAND	0x06
-#define GET_HW_VERSION_COMMAND	0x07
-#define BLANK			0xff
-
-/* bootloader command responses */
-#define COMMAND_OK		0x01
-#define COMMAND_FAILED		0x02
-#define COMMAND_PENDING		0x03
-
-/* buffer sizes */
-#define COMMAND_BUFFER_SIZE	4
-#define RESPONSE_BUFFER_SIZE	2
-#define FLASH_BUFFER_SIZE	64
-#define CRC_BUFFER_SIZE		3
-
-
-
-/**************************************************************************
  * General Driver Definitions
  **************************************************************************/
 
@@ -677,7 +471,7 @@ static int si470x_get_freq(struct si470x
 	int retval;
 
 	/* Spacing (kHz) */
-	switch (space) {
+	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_SPACE) >> 4) {
 	/* 0: 200 kHz (USA, Australia) */
 	case 0 : spacing = 0.200 * FREQ_MUL; break;
 	/* 1: 100 kHz (Europe, Japan) */
@@ -687,7 +481,7 @@ static int si470x_get_freq(struct si470x
 	};
 
 	/* Bottom of Band (MHz) */
-	switch (band) {
+	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_BAND) >> 6) {
 	/* 0: 87.5 - 108 MHz (USA, Europe) */
 	case 0 : band_bottom = 87.5 * FREQ_MUL; break;
 	/* 1: 76   - 108 MHz (Japan wide band) */
@@ -716,7 +510,7 @@ static int si470x_set_freq(struct si470x
 	unsigned short chan;
 
 	/* Spacing (kHz) */
-	switch (space) {
+	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_SPACE) >> 4) {
 	/* 0: 200 kHz (USA, Australia) */
 	case 0 : spacing = 0.200 * FREQ_MUL; break;
 	/* 1: 100 kHz (Europe, Japan) */
@@ -726,7 +520,7 @@ static int si470x_set_freq(struct si470x
 	};
 
 	/* Bottom of Band (MHz) */
-	switch (band) {
+	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_BAND) >> 6) {
 	/* 0: 87.5 - 108 MHz (USA, Europe) */
 	case 0 : band_bottom = 87.5 * FREQ_MUL; break;
 	/* 1: 76   - 108 MHz (Japan wide band) */
@@ -813,7 +607,8 @@ static int si470x_start(struct si470x_de
 		goto done;
 
 	/* sysconfig 1 */
-	radio->registers[SYSCONFIG1] = SYSCONFIG1_DE;
+	radio->registers[SYSCONFIG1] =
+		(de << 11) & SYSCONFIG1_DE;		/* DE */
 	retval = si470x_set_register(radio, SYSCONFIG1);
 	if (retval < 0)
 		goto done;
@@ -1207,6 +1002,78 @@ static struct v4l2_queryctrl si470x_v4l2
 		.id		= V4L2_CID_AUDIO_LOUDNESS,
 		.flags		= V4L2_CTRL_FLAG_DISABLED,
 	},
+	{
+		.id		= V4L2_CID_PRIVATE_SI470X_DSMUTE,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "Softmute Disable",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 0,
+	},
+	{
+		.id		= V4L2_CID_PRIVATE_SI470X_AGCD,
+		.type		= V4L2_CTRL_TYPE_BOOLEAN,
+		.name		= "AGC Disable",
+		.minimum	= 0,
+		.maximum	= 1,
+		.step		= 1,
+		.default_value	= 0,
+	},
+	{
+		.id		= V4L2_CID_PRIVATE_SI470X_BLNDADJ,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Stereo/Mono Blend Level Adj.",
+		.minimum	= 0,
+		.maximum	= 3,
+		.step		= 1,
+		.default_value	= 0,
+	},
+	{
+		.id		= V4L2_CID_PRIVATE_SI470X_SEEKTH,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "RSSI Seek Threshold",
+		.minimum	= 0,
+		.maximum	= 254,
+		.step		= 1,
+		.default_value	= 0,
+	},
+	{
+		.id		= V4L2_CID_PRIVATE_SI470X_SMUTER,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Softmute Attack/Recover Rate",
+		.minimum	= 0,
+		.maximum	= 3,
+		.step		= 1,
+		.default_value	= 0,
+	},
+	{
+		.id		= V4L2_CID_PRIVATE_SI470X_SMUTEA,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Softmute Attenuation",
+		.minimum	= 0,
+		.maximum	= 3,
+		.step		= 1,
+		.default_value	= 0,
+	},
+	{
+		.id		= V4L2_CID_PRIVATE_SI470X_SKSNR,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Seek SNR Threshold",
+		.minimum	= 0,
+		.maximum	= 15,
+		.step		= 1,
+		.default_value	= 0,
+	},
+	{
+		.id		= V4L2_CID_PRIVATE_SI470X_SKCNT,
+		.type		= V4L2_CTRL_TYPE_INTEGER,
+		.name		= "Seek FM Impulse Detection Th.",
+		.minimum	= 0,
+		.maximum	= 15,
+		.step		= 1,
+		.default_value	= 0,
+	},
 };
 
 
@@ -1310,6 +1177,50 @@ static int si470x_vidioc_g_ctrl(struct f
 		ctrl->value = ((radio->registers[POWERCFG] &
 				POWERCFG_DMUTE) == 0) ? 1 : 0;
 		break;
+	case V4L2_CID_PRIVATE_SI470X_DSMUTE:
+		ctrl->value = (radio->registers[POWERCFG]
+			& POWERCFG_DSMUTE) >> 15;
+		break;
+	case V4L2_CID_PRIVATE_SI470X_DE:
+		ctrl->value = (radio->registers[SYSCONFIG1]
+			& SYSCONFIG1_DE) >> 11;
+		break;
+	case V4L2_CID_PRIVATE_SI470X_AGCD:
+		ctrl->value = (radio->registers[SYSCONFIG1]
+			& SYSCONFIG1_AGCD) >> 10;
+		break;
+	case V4L2_CID_PRIVATE_SI470X_BLNDADJ:
+		ctrl->value = (radio->registers[SYSCONFIG1]
+			& SYSCONFIG1_BLNDADJ) >> 6;
+		break;
+	case V4L2_CID_PRIVATE_SI470X_SEEKTH:
+		ctrl->value = (radio->registers[SYSCONFIG2]
+			& SYSCONFIG2_SEEKTH) >> 8;
+		break;
+	case V4L2_CID_PRIVATE_SI470X_BAND:
+		ctrl->value = (radio->registers[SYSCONFIG2]
+			& SYSCONFIG2_BAND) >> 6;
+		break;
+	case V4L2_CID_PRIVATE_SI470X_SPACE:
+		ctrl->value = (radio->registers[SYSCONFIG2]
+			& SYSCONFIG2_SPACE) >> 4;
+		break;
+	case V4L2_CID_PRIVATE_SI470X_SMUTER:
+		ctrl->value = (radio->registers[SYSCONFIG3]
+			& SYSCONFIG3_SMUTER) >> 14;
+		break;
+	case V4L2_CID_PRIVATE_SI470X_SMUTEA:
+		ctrl->value = (radio->registers[SYSCONFIG3]
+			& SYSCONFIG3_SMUTEA) >> 12;
+		break;
+	case V4L2_CID_PRIVATE_SI470X_SKSNR:
+		ctrl->value = (radio->registers[SYSCONFIG3]
+			& SYSCONFIG3_SKSNR) >> 4;
+		break;
+	case V4L2_CID_PRIVATE_SI470X_SKCNT:
+		ctrl->value = (radio->registers[SYSCONFIG3]
+			& SYSCONFIG3_SKCNT) >> 0;
+		break;
 	default:
 		retval = -EINVAL;
 	}
@@ -1350,6 +1261,72 @@ static int si470x_vidioc_s_ctrl(struct f
 			radio->registers[POWERCFG] |= POWERCFG_DMUTE;
 		retval = si470x_set_register(radio, POWERCFG);
 		break;
+	case V4L2_CID_PRIVATE_SI470X_DSMUTE:
+		radio->registers[POWERCFG] &= ~POWERCFG_DSMUTE;
+		radio->registers[POWERCFG] |=
+			(ctrl->value << 15) & POWERCFG_DSMUTE;
+		retval = si470x_set_register(radio, POWERCFG);
+		break;
+	case V4L2_CID_PRIVATE_SI470X_DE:
+		radio->registers[SYSCONFIG1] &= ~SYSCONFIG1_DE;
+		radio->registers[SYSCONFIG1] |=
+			(ctrl->value << 11) & SYSCONFIG1_DE;
+		retval = si470x_set_register(radio, SYSCONFIG1);
+		break;
+	case V4L2_CID_PRIVATE_SI470X_AGCD:
+		radio->registers[SYSCONFIG1] &= ~SYSCONFIG1_AGCD;
+		radio->registers[SYSCONFIG1] |=
+			(ctrl->value << 10) & SYSCONFIG1_AGCD;
+		retval = si470x_set_register(radio, SYSCONFIG1);
+		break;
+	case V4L2_CID_PRIVATE_SI470X_BLNDADJ:
+		radio->registers[SYSCONFIG1] &= ~SYSCONFIG1_BLNDADJ;
+		radio->registers[SYSCONFIG1] |=
+			(ctrl->value << 6) & SYSCONFIG1_BLNDADJ;
+		retval = si470x_set_register(radio, SYSCONFIG1);
+		break;
+	case V4L2_CID_PRIVATE_SI470X_SEEKTH:
+		radio->registers[SYSCONFIG2] &= ~SYSCONFIG2_SEEKTH;
+		radio->registers[SYSCONFIG2] |=
+			(ctrl->value << 8) & SYSCONFIG2_SEEKTH;
+		retval = si470x_set_register(radio, SYSCONFIG2);
+		break;
+	case V4L2_CID_PRIVATE_SI470X_BAND:
+		radio->registers[SYSCONFIG2] &= ~SYSCONFIG2_BAND;
+		radio->registers[SYSCONFIG2] |=
+			(ctrl->value << 6) & SYSCONFIG2_BAND;
+		retval = si470x_set_register(radio, SYSCONFIG2);
+		break;
+	case V4L2_CID_PRIVATE_SI470X_SPACE:
+		radio->registers[SYSCONFIG2] &= ~SYSCONFIG2_SPACE;
+		radio->registers[SYSCONFIG2] |=
+			(ctrl->value << 4) & SYSCONFIG2_SPACE;
+		retval = si470x_set_register(radio, SYSCONFIG2);
+		break;
+	case V4L2_CID_PRIVATE_SI470X_SMUTER:
+		radio->registers[SYSCONFIG3] &= ~SYSCONFIG3_SMUTER;
+		radio->registers[SYSCONFIG3] |=
+			(ctrl->value << 14) & SYSCONFIG3_SMUTER;
+		retval = si470x_set_register(radio, SYSCONFIG3);
+		break;
+	case V4L2_CID_PRIVATE_SI470X_SMUTEA:
+		radio->registers[SYSCONFIG3] &= ~SYSCONFIG3_SMUTEA;
+		radio->registers[SYSCONFIG3] |=
+			(ctrl->value << 12) & SYSCONFIG3_SMUTEA;
+		retval = si470x_set_register(radio, SYSCONFIG3);
+		break;
+	case V4L2_CID_PRIVATE_SI470X_SKSNR:
+		radio->registers[SYSCONFIG3] &= ~SYSCONFIG3_SKSNR;
+		radio->registers[SYSCONFIG3] |=
+			(ctrl->value << 4) & SYSCONFIG3_SKSNR;
+		retval = si470x_set_register(radio, SYSCONFIG3);
+		break;
+	case V4L2_CID_PRIVATE_SI470X_SKCNT:
+		radio->registers[SYSCONFIG3] &= ~SYSCONFIG3_SKCNT;
+		radio->registers[SYSCONFIG3] |=
+			(ctrl->value << 0) & SYSCONFIG3_SKCNT;
+		retval = si470x_set_register(radio, SYSCONFIG3);
+		break;
 	default:
 		retval = -EINVAL;
 	}
@@ -1433,7 +1410,7 @@ static int si470x_vidioc_g_tuner(struct 
 		goto done;
 
 	strcpy(tuner->name, "FM");
-	switch (band) {
+	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_BAND) >> 6) {
 	/* 0: 87.5 - 108 MHz (USA, Europe, default) */
 	default:
 		tuner->rangelow  =  87.5 * FREQ_MUL;
diff --exclude='*.o' --exclude='*.ko' --exclude='.*' --exclude='*.mod.*' --exclude=modules.order --exclude=autoconf.h --exclude=compile.h --exclude=version.h --exclude=utsrelease.h -uprN 5_hw_seek/include/media/radio-si470x.h 6_priv_vidioc/include/media/radio-si470x.h
--- 5_hw_seek/include/media/radio-si470x.h	1970-01-01 01:00:00.000000000 +0100
+++ 6_priv_vidioc/include/media/radio-si470x.h	2008-05-26 21:43:44.000000000 +0200
@@ -0,0 +1,261 @@
+/*
+ *  include/media/radio-si470x.h
+ *
+ *  Driver for USB radios for the Silicon Labs Si470x FM Radio Receivers:
+ *   - Silicon Labs USB FM Radio Reference Design
+ *   - ADS/Tech FM Radio Receiver (formerly Instant FM Music) (RDX-155-EF)
+ *
+ *  Copyright (c) 2008 Tobias Lorenz <tobias.lorenz@gmx.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#ifndef _RADIO_SI470X_H
+#define _RADIO_SI470X_H
+
+
+/* kernel includes */
+#include <linux/videodev2.h>
+
+
+/**************************************************************************
+ * Register Definitions
+ **************************************************************************/
+#define RADIO_REGISTER_SIZE	2	/* 16 register bit width */
+#define RADIO_REGISTER_NUM	16	/* DEVICEID   ... RDSD */
+#define RDS_REGISTER_NUM	6	/* STATUSRSSI ... RDSD */
+
+#define DEVICEID		0	/* Device ID */
+#define DEVICEID_PN		0xf000	/* bits 15..12: Part Number */
+#define DEVICEID_MFGID		0x0fff	/* bits 11..00: Manufacturer ID */
+
+#define CHIPID			1	/* Chip ID */
+#define CHIPID_REV		0xfc00	/* bits 15..10: Chip Version */
+#define CHIPID_DEV		0x0200	/* bits 09..09: Device */
+#define CHIPID_FIRMWARE		0x01ff	/* bits 08..00: Firmware Version */
+
+#define POWERCFG		2	/* Power Configuration */
+#define POWERCFG_DSMUTE		0x8000	/* bits 15..15: Softmute Disable */
+#define POWERCFG_DMUTE		0x4000	/* bits 14..14: Mute Disable */
+#define POWERCFG_MONO		0x2000	/* bits 13..13: Mono Select */
+#define POWERCFG_RDSM		0x0800	/* bits 11..11: RDS Mode (Si4701 only) */
+#define POWERCFG_SKMODE		0x0400	/* bits 10..10: Seek Mode */
+#define POWERCFG_SEEKUP		0x0200	/* bits 09..09: Seek Direction */
+#define POWERCFG_SEEK		0x0100	/* bits 08..08: Seek */
+#define POWERCFG_DISABLE	0x0040	/* bits 06..06: Powerup Disable */
+#define POWERCFG_ENABLE		0x0001	/* bits 00..00: Powerup Enable */
+
+#define CHANNEL			3	/* Channel */
+#define CHANNEL_TUNE		0x8000	/* bits 15..15: Tune */
+#define CHANNEL_CHAN		0x03ff	/* bits 09..00: Channel Select */
+
+#define SYSCONFIG1		4	/* System Configuration 1 */
+#define SYSCONFIG1_RDSIEN	0x8000	/* bits 15..15: RDS Interrupt Enable (Si4701 only) */
+#define SYSCONFIG1_STCIEN	0x4000	/* bits 14..14: Seek/Tune Complete Interrupt Enable */
+#define SYSCONFIG1_RDS		0x1000	/* bits 12..12: RDS Enable (Si4701 only) */
+#define SYSCONFIG1_DE		0x0800	/* bits 11..11: De-emphasis (0=75us 1=50us) */
+#define SYSCONFIG1_AGCD		0x0400	/* bits 10..10: AGC Disable */
+#define SYSCONFIG1_BLNDADJ	0x00c0	/* bits 07..06: Stereo/Mono Blend Level Adjustment */
+#define SYSCONFIG1_GPIO3	0x0030	/* bits 05..04: General Purpose I/O 3 */
+#define SYSCONFIG1_GPIO2	0x000c	/* bits 03..02: General Purpose I/O 2 */
+#define SYSCONFIG1_GPIO1	0x0003	/* bits 01..00: General Purpose I/O 1 */
+
+#define SYSCONFIG2		5	/* System Configuration 2 */
+#define SYSCONFIG2_SEEKTH	0xff00	/* bits 15..08: RSSI Seek Threshold */
+#define SYSCONFIG2_BAND		0x0080	/* bits 07..06: Band Select */
+#define SYSCONFIG2_SPACE	0x0030	/* bits 05..04: Channel Spacing */
+#define SYSCONFIG2_VOLUME	0x000f	/* bits 03..00: Volume */
+
+#define SYSCONFIG3		6	/* System Configuration 3 */
+#define SYSCONFIG3_SMUTER	0xc000	/* bits 15..14: Softmute Attack/Recover Rate */
+#define SYSCONFIG3_SMUTEA	0x3000	/* bits 13..12: Softmute Attenuation */
+#define SYSCONFIG3_SKSNR	0x00f0	/* bits 07..04: Seek SNR Threshold */
+#define SYSCONFIG3_SKCNT	0x000f	/* bits 03..00: Seek FM Impulse Detection Threshold */
+
+#define TEST1			7	/* Test 1 */
+#define TEST1_AHIZEN		0x4000	/* bits 14..14: Audio High-Z Enable */
+
+#define TEST2			8	/* Test 2 */
+/* TEST2 only contains reserved bits */
+
+#define BOOTCONFIG		9	/* Boot Configuration */
+/* BOOTCONFIG only contains reserved bits */
+
+#define STATUSRSSI		10	/* Status RSSI */
+#define STATUSRSSI_RDSR		0x8000	/* bits 15..15: RDS Ready (Si4701 only) */
+#define STATUSRSSI_STC		0x4000	/* bits 14..14: Seek/Tune Complete */
+#define STATUSRSSI_SF		0x2000	/* bits 13..13: Seek Fail/Band Limit */
+#define STATUSRSSI_AFCRL	0x1000	/* bits 12..12: AFC Rail */
+#define STATUSRSSI_RDSS		0x0800	/* bits 11..11: RDS Synchronized (Si4701 only) */
+#define STATUSRSSI_BLERA	0x0600	/* bits 10..09: RDS Block A Errors (Si4701 only) */
+#define STATUSRSSI_ST		0x0100	/* bits 08..08: Stereo Indicator */
+#define STATUSRSSI_RSSI		0x00ff	/* bits 07..00: RSSI (Received Signal Strength Indicator) */
+
+#define READCHAN		11	/* Read Channel */
+#define READCHAN_BLERB		0xc000	/* bits 15..14: RDS Block D Errors (Si4701 only) */
+#define READCHAN_BLERC		0x3000	/* bits 13..12: RDS Block C Errors (Si4701 only) */
+#define READCHAN_BLERD		0x0c00	/* bits 11..10: RDS Block B Errors (Si4701 only) */
+#define READCHAN_READCHAN	0x03ff	/* bits 09..00: Read Channel */
+
+#define RDSA			12	/* RDSA */
+#define RDSA_RDSA		0xffff	/* bits 15..00: RDS Block A Data (Si4701 only) */
+
+#define RDSB			13	/* RDSB */
+#define RDSB_RDSB		0xffff	/* bits 15..00: RDS Block B Data (Si4701 only) */
+
+#define RDSC			14	/* RDSC */
+#define RDSC_RDSC		0xffff	/* bits 15..00: RDS Block C Data (Si4701 only) */
+
+#define RDSD			15	/* RDSD */
+#define RDSD_RDSD		0xffff	/* bits 15..00: RDS Block D Data (Si4701 only) */
+
+
+
+/**************************************************************************
+ * USB HID Reports
+ **************************************************************************/
+
+/* Reports 1-16 give direct read/write access to the 16 Si470x registers */
+/* with the (REPORT_ID - 1) corresponding to the register address across USB */
+/* endpoint 0 using GET_REPORT and SET_REPORT */
+#define REGISTER_REPORT_SIZE	(RADIO_REGISTER_SIZE + 1)
+#define REGISTER_REPORT(reg)	((reg) + 1)
+
+/* Report 17 gives direct read/write access to the entire Si470x register */
+/* map across endpoint 0 using GET_REPORT and SET_REPORT */
+#define ENTIRE_REPORT_SIZE	(RADIO_REGISTER_NUM * RADIO_REGISTER_SIZE + 1)
+#define ENTIRE_REPORT		17
+
+/* Report 18 is used to send the lowest 6 Si470x registers up the HID */
+/* interrupt endpoint 1 to Windows every 20 milliseconds for status */
+#define RDS_REPORT_SIZE		(RDS_REGISTER_NUM * RADIO_REGISTER_SIZE + 1)
+#define RDS_REPORT		18
+
+/* Report 19: LED state */
+#define LED_REPORT_SIZE		3
+#define LED_REPORT		19
+
+/* Report 19: stream */
+#define STREAM_REPORT_SIZE	3
+#define	STREAM_REPORT		19
+
+/* Report 20: scratch */
+#define SCRATCH_PAGE_SIZE	63
+#define SCRATCH_REPORT_SIZE	(SCRATCH_PAGE_SIZE + 1)
+#define SCRATCH_REPORT		20
+
+/* Reports 19-22: flash upgrade of the C8051F321 */
+#define WRITE_REPORT		19
+#define FLASH_REPORT		20
+#define CRC_REPORT		21
+#define RESPONSE_REPORT		22
+
+/* Report 23: currently unused, but can accept 60 byte reports on the HID */
+/* interrupt out endpoint 2 every 1 millisecond */
+#define UNUSED_REPORT		23
+
+
+
+/**************************************************************************
+ * Software/Hardware Versions
+ **************************************************************************/
+#define RADIO_SW_VERSION_NOT_BOOTLOADABLE	6
+#define RADIO_SW_VERSION			7
+#define RADIO_SW_VERSION_CURRENT		15
+#define RADIO_HW_VERSION			1
+
+#define SCRATCH_PAGE_SW_VERSION	1
+#define SCRATCH_PAGE_HW_VERSION	2
+
+
+
+/**************************************************************************
+ * LED State Definitions
+ **************************************************************************/
+#define LED_COMMAND		0x35
+
+#define NO_CHANGE_LED		0x00
+#define ALL_COLOR_LED		0x01	/* streaming state */
+#define BLINK_GREEN_LED		0x02	/* connect state */
+#define BLINK_RED_LED		0x04
+#define BLINK_ORANGE_LED	0x10	/* disconnect state */
+#define SOLID_GREEN_LED		0x20	/* tuning/seeking state */
+#define SOLID_RED_LED		0x40	/* bootload state */
+#define SOLID_ORANGE_LED	0x80
+
+
+
+/**************************************************************************
+ * Stream State Definitions
+ **************************************************************************/
+#define STREAM_COMMAND	0x36
+#define STREAM_VIDPID	0x00
+#define STREAM_AUDIO	0xff
+
+
+
+/**************************************************************************
+ * Bootloader / Flash Commands
+ **************************************************************************/
+
+/* unique id sent to bootloader and required to put into a bootload state */
+#define UNIQUE_BL_ID		0x34
+
+/* mask for the flash data */
+#define FLASH_DATA_MASK		0x55
+
+/* bootloader commands */
+#define GET_SW_VERSION_COMMAND	0x00
+#define	SET_PAGE_COMMAND	0x01
+#define ERASE_PAGE_COMMAND	0x02
+#define WRITE_PAGE_COMMAND	0x03
+#define CRC_ON_PAGE_COMMAND	0x04
+#define READ_FLASH_BYTE_COMMAND	0x05
+#define RESET_DEVICE_COMMAND	0x06
+#define GET_HW_VERSION_COMMAND	0x07
+#define BLANK			0xff
+
+/* bootloader command responses */
+#define COMMAND_OK		0x01
+#define COMMAND_FAILED		0x02
+#define COMMAND_PENDING		0x03
+
+/* buffer sizes */
+#define COMMAND_BUFFER_SIZE	4
+#define RESPONSE_BUFFER_SIZE	2
+#define FLASH_BUFFER_SIZE	64
+#define CRC_BUFFER_SIZE		3
+
+
+
+/**************************************************************************
+ * Private Video Controls
+ **************************************************************************/
+/* to ensure conflict free id assignment use */
+/* (V4L2_CID_PRIVATE_BASE + (<Register> << 4) + (<Bit Position> << 0)) */
+#define V4L2_CID_PRIVATE_SI470X_DSMUTE	(V4L2_CID_PRIVATE_BASE + (POWERCFG<<4)   + 15)
+#define V4L2_CID_PRIVATE_SI470X_DE	(V4L2_CID_PRIVATE_BASE + (SYSCONFIG1<<4) + 11)
+#define V4L2_CID_PRIVATE_SI470X_AGCD	(V4L2_CID_PRIVATE_BASE + (SYSCONFIG1<<4) + 10)
+#define V4L2_CID_PRIVATE_SI470X_BLNDADJ	(V4L2_CID_PRIVATE_BASE + (SYSCONFIG1<<4) +  6)
+#define V4L2_CID_PRIVATE_SI470X_SEEKTH	(V4L2_CID_PRIVATE_BASE + (SYSCONFIG2<<4) +  8)
+#define V4L2_CID_PRIVATE_SI470X_BAND	(V4L2_CID_PRIVATE_BASE + (SYSCONFIG2<<4) +  6)
+#define V4L2_CID_PRIVATE_SI470X_SPACE	(V4L2_CID_PRIVATE_BASE + (SYSCONFIG2<<4) +  4)
+#define V4L2_CID_PRIVATE_SI470X_SMUTER	(V4L2_CID_PRIVATE_BASE + (SYSCONFIG3<<4) + 14)
+#define V4L2_CID_PRIVATE_SI470X_SMUTEA	(V4L2_CID_PRIVATE_BASE + (SYSCONFIG3<<4) + 12)
+#define V4L2_CID_PRIVATE_SI470X_SKSNR	(V4L2_CID_PRIVATE_BASE + (SYSCONFIG3<<4) +  4)
+#define V4L2_CID_PRIVATE_SI470X_SKCNT	(V4L2_CID_PRIVATE_BASE + (SYSCONFIG3<<4) +  0)
+
+
+#endif

-------------------------------------------------------

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
