Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m47Krhj2018151
	for <video4linux-list@redhat.com>; Wed, 7 May 2008 16:53:43 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m47KrVK7024760
	for <video4linux-list@redhat.com>; Wed, 7 May 2008 16:53:31 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Wed, 7 May 2008 22:53:22 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805072253.23219.tobias.lorenz@gmx.net>
Cc: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Subject: [PATCH 2/2] v4l2: hardware frequency seek ioctl interface
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
Hi Keith,

based on the radio hardware frequency seek patch from Keith, I propose the following patch.
Mainly it introduces a new ioctl VIDIOC_S_HW_FREQ_SEEK.
The following options can be set: seek_upward, wrap_around.
I removed the start_freq from the original proposal, as I see no use case for it.
Usually you want to start searching at the current frequency and if not VIDIOC_S_FREQUENCY can be used.

The first part of the patch contains the driver independent part of VIDIOC_S_HW_FREQ_SEEK.
The second part of the patch contains a modification to the radio-si470x driver to support the new ioctl.

Testing of the new interface was done by a modified version of fmseek from the fmtools package, that I can provide on request.
Hardware specific options to change the seek behaviour are implemented using private video controls.
For this it was necessary to introduce a new header file for the radio-si470x private video control definitions, but I also moved all hardware register definitions to it.

The current patch is against linux-2.6.25.
I can provide one against the current mercurial version on request.

Bye,
Toby



Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
--- linux-2.6.25/drivers/media/radio/radio-si470x.c	2008-04-17 04:49:44.000000000 +0200
+++ linux-2.6.25-si470x/drivers/media/radio/radio-si470x.c	2008-05-07 20:24:16.000000000 +0200
@@ -24,6 +24,19 @@
 
 
 /*
+ * User Notes:
+ * - USB Audio is provided by the alsa snd_usb_audio module.
+ *   For listing you have to redirect the sound, for example using:
+ *   arecord -D hw:1,0 -r96000 -c2 -f S16_LE | artsdsp aplay -B -
+ * - regarding module parameters in /sys/module/radio_si470x/parameters:
+ *   the contents of read-only files (0444) are not updated, even if
+ *   space, band and de are changed using private video controls
+ * - increase tune_timeout, if you often get -EIO errors
+ * - hw_freq_seek returns -EAGAIN, when timed out or band limit is reached
+ */
+
+
+/*
  * History:
  * 2008-01-12	Tobias Lorenz <tobias.lorenz@gmx.net>
  *		Version 1.0.0
@@ -85,9 +98,17 @@
  *		Oliver Neukum <oliver@neukum.org>
  *		Version 1.0.7
  *		- usb autosuspend support
+ *		- unplugging fixed
+ * 2008-05-07	Tobias Lorenz <tobias.lorenz@gmx.net>
+ *		Version 1.0.8
+ *		- hardware frequency seek support
+ *		- afc indication
+ *		- implementation of private video controls for
+ *		  seek options and band/space/de changes
+ *		- register definitions moved to separate header file
+ *		- more safety checks, let si470x_get_freq return errno
  *
  * ToDo:
- * - add seeking support
  * - add firmware download/update support
  * - RDS support: interrupt mode, instead of polling
  * - add LED status output (check if that's not already done in firmware)
@@ -97,10 +118,10 @@
 /* driver definitions */
 #define DRIVER_AUTHOR "Tobias Lorenz <tobias.lorenz@gmx.net>"
 #define DRIVER_NAME "radio-si470x"
-#define DRIVER_KERNEL_VERSION KERNEL_VERSION(1, 0, 6)
+#define DRIVER_KERNEL_VERSION KERNEL_VERSION(1, 0, 8)
 #define DRIVER_CARD "Silicon Labs Si470x FM Radio Receiver"
 #define DRIVER_DESC "USB radio driver for Si470x FM Radio Receivers"
-#define DRIVER_VERSION "1.0.6"
+#define DRIVER_VERSION "1.0.8"
 
 
 /* kernel includes */
@@ -116,6 +137,7 @@
 #include <linux/mutex.h>
 #include <media/v4l2-common.h>
 #include <media/rds.h>
+#include <media/radio-si470x.h>
 #include <asm/unaligned.h>
 
 
@@ -138,7 +160,7 @@ MODULE_DEVICE_TABLE(usb, si470x_usb_driv
 
 /* Radio Nr */
 static int radio_nr = -1;
-module_param(radio_nr, int, 0);
+module_param(radio_nr, int, 0444);
 MODULE_PARM_DESC(radio_nr, "Radio Nr");
 
 /* Spacing (kHz) */
@@ -146,7 +168,7 @@ MODULE_PARM_DESC(radio_nr, "Radio Nr");
 /* 1: 100 kHz (Europe, Japan) */
 /* 2:  50 kHz */
 static unsigned short space = 2;
-module_param(space, ushort, 0);
+module_param(space, ushort, 0444);
 MODULE_PARM_DESC(radio_nr, "Spacing: 0=200kHz 1=100kHz *2=50kHz*");
 
 /* Bottom of Band (MHz) */
@@ -154,29 +176,34 @@ MODULE_PARM_DESC(radio_nr, "Spacing: 0=2
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
 
+/* Seek timeout */
+static unsigned int seek_timeout = 5000;
+module_param(seek_timeout, uint, 0644);
+MODULE_PARM_DESC(seek_timeout, "Seek timeout: *5000*");
+
 /* RDS buffer blocks */
 static unsigned int rds_buf = 100;
-module_param(rds_buf, uint, 0);
+module_param(rds_buf, uint, 0444);
 MODULE_PARM_DESC(rds_buf, "RDS buffer entries: *100*");
 
 /* RDS maximum block errors */
@@ -185,7 +212,7 @@ static unsigned short max_rds_errors = 1
 /* 1 means 1-2  errors requiring correction (used by original USBRadio.exe) */
 /* 2 means 3-5  errors requiring correction */
 /* 3 means   6+ errors or errors in checkword, correction not possible */
-module_param(max_rds_errors, ushort, 0);
+module_param(max_rds_errors, ushort, 0644);
 MODULE_PARM_DESC(max_rds_errors, "RDS maximum block errors: *1*");
 
 /* RDS poll frequency */
@@ -194,222 +221,12 @@ static unsigned int rds_poll_time = 40;
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
 
@@ -424,6 +241,8 @@ struct si470x_device {
 
 	/* driver management */
 	unsigned int users;
+	unsigned char disconnected;
+	struct mutex disconnect_lock;
 
 	/* Silabs internal registers (0..15) */
 	unsigned short registers[RADIO_REGISTER_NUM];
@@ -468,11 +287,11 @@ static int si470x_get_report(struct si47
 		USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_IN,
 		report[0], 2,
 		buf, size, usb_timeout);
+
 	if (retval < 0)
 		printk(KERN_WARNING DRIVER_NAME
 			": si470x_get_report: usb_control_msg returned %d\n",
 			retval);
-
 	return retval;
 }
 
@@ -491,11 +310,11 @@ static int si470x_set_report(struct si47
 		USB_TYPE_CLASS | USB_RECIP_INTERFACE | USB_DIR_OUT,
 		report[0], 2,
 		buf, size, usb_timeout);
+
 	if (retval < 0)
 		printk(KERN_WARNING DRIVER_NAME
 			": si470x_set_report: usb_control_msg returned %d\n",
 			retval);
-
 	return retval;
 }
 
@@ -577,7 +396,7 @@ static int si470x_get_rds_registers(stru
 		usb_rcvintpipe(radio->usbdev, 1),
 		(void *) &buf, sizeof(buf), &size, usb_timeout);
 	if (size != sizeof(buf))
-		printk(KERN_WARNING DRIVER_NAME ": si470x_get_rds_register: "
+		printk(KERN_WARNING DRIVER_NAME ": si470x_get_rds_registers: "
 			"return size differs: %d != %zu\n", size, sizeof(buf));
 	if (retval < 0)
 		printk(KERN_WARNING DRIVER_NAME ": si470x_get_rds_registers: "
@@ -607,38 +426,44 @@ static int si470x_set_chan(struct si470x
 	radio->registers[CHANNEL] |= CHANNEL_TUNE | chan;
 	retval = si470x_set_register(radio, CHANNEL);
 	if (retval < 0)
-		return retval;
+		goto done;
 
-	/* wait till seek operation has completed */
+	/* wait till tune operation has completed */
 	timeout = jiffies + msecs_to_jiffies(tune_timeout);
 	do {
 		retval = si470x_get_register(radio, STATUSRSSI);
 		if (retval < 0)
-			return retval;
+			goto stop;
 		timed_out = time_after(jiffies, timeout);
 	} while (((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0) &&
 		(!timed_out));
+	if ((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0)
+		printk(KERN_WARNING DRIVER_NAME ": tune does not complete\n");
 	if (timed_out)
 		printk(KERN_WARNING DRIVER_NAME
-			": seek does not finish after %u ms\n", tune_timeout);
+			": tune timed out after %u ms\n", tune_timeout);
 
+stop:
 	/* stop tuning */
 	radio->registers[CHANNEL] &= ~CHANNEL_TUNE;
-	return si470x_set_register(radio, CHANNEL);
+	retval = si470x_set_register(radio, CHANNEL);
+
+done:
+	return retval;
 }
 
 
 /*
  * si470x_get_freq - get the frequency
  */
-static unsigned int si470x_get_freq(struct si470x_device *radio)
+static int si470x_get_freq(struct si470x_device *radio, unsigned int *freq)
 {
-	unsigned int spacing, band_bottom, freq;
+	unsigned int spacing, band_bottom;
 	unsigned short chan;
 	int retval;
 
 	/* Spacing (kHz) */
-	switch (space) {
+	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_SPACE) >> 4) {
 	/* 0: 200 kHz (USA, Australia) */
 	case 0 : spacing = 0.200 * FREQ_MUL; break;
 	/* 1: 100 kHz (Europe, Japan) */
@@ -648,7 +473,7 @@ static unsigned int si470x_get_freq(stru
 	};
 
 	/* Bottom of Band (MHz) */
-	switch (band) {
+	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_BAND) >> 6) {
 	/* 0: 87.5 - 108 MHz (USA, Europe) */
 	case 0 : band_bottom = 87.5 * FREQ_MUL; break;
 	/* 1: 76   - 108 MHz (Japan wide band) */
@@ -659,14 +484,12 @@ static unsigned int si470x_get_freq(stru
 
 	/* read channel */
 	retval = si470x_get_register(radio, READCHAN);
-	if (retval < 0)
-		return retval;
 	chan = radio->registers[READCHAN] & READCHAN_READCHAN;
 
 	/* Frequency (MHz) = Spacing (kHz) x Channel + Bottom of Band (MHz) */
-	freq = chan * spacing + band_bottom;
+	*freq = chan * spacing + band_bottom;
 
-	return freq;
+	return retval;
 }
 
 
@@ -679,7 +502,7 @@ static int si470x_set_freq(struct si470x
 	unsigned short chan;
 
 	/* Spacing (kHz) */
-	switch (space) {
+	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_SPACE) >> 4) {
 	/* 0: 200 kHz (USA, Australia) */
 	case 0 : spacing = 0.200 * FREQ_MUL; break;
 	/* 1: 100 kHz (Europe, Japan) */
@@ -689,7 +512,7 @@ static int si470x_set_freq(struct si470x
 	};
 
 	/* Bottom of Band (MHz) */
-	switch (band) {
+	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_BAND) >> 6) {
 	/* 0: 87.5 - 108 MHz (USA, Europe) */
 	case 0 : band_bottom = 87.5 * FREQ_MUL; break;
 	/* 1: 76   - 108 MHz (Japan wide band) */
@@ -706,6 +529,62 @@ static int si470x_set_freq(struct si470x
 
 
 /*
+ * si470x_set_seek - set seek
+ */
+static int si470x_set_seek(struct si470x_device *radio,
+		unsigned int wrap_around, unsigned int seek_upward)
+{
+	int retval = 0;
+	unsigned long timeout;
+	bool timed_out = 0;
+
+	/* start seeking */
+	radio->registers[POWERCFG] |= POWERCFG_SEEK;
+	if (wrap_around == 1)
+		radio->registers[POWERCFG] &= ~POWERCFG_SKMODE;
+	else
+		radio->registers[POWERCFG] |= POWERCFG_SKMODE;
+	if (seek_upward == 1)
+		radio->registers[POWERCFG] |= POWERCFG_SEEKUP;
+	else
+		radio->registers[POWERCFG] &= ~POWERCFG_SEEKUP;
+	retval = si470x_set_register(radio, POWERCFG);
+	if (retval < 0)
+		goto done;
+
+	/* wait till seek operation has completed */
+	timeout = jiffies + msecs_to_jiffies(seek_timeout);
+	do {
+		retval = si470x_get_register(radio, STATUSRSSI);
+		if (retval < 0)
+			goto stop;
+		timed_out = time_after(jiffies, timeout);
+	} while (((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0) &&
+		(!timed_out));
+	if ((radio->registers[STATUSRSSI] & STATUSRSSI_STC) == 0)
+		printk(KERN_WARNING DRIVER_NAME ": seek does not complete\n");
+	if (radio->registers[STATUSRSSI] & STATUSRSSI_SF)
+		printk(KERN_WARNING DRIVER_NAME
+			": seek failed / band limit reached\n");
+	if (timed_out)
+		printk(KERN_WARNING DRIVER_NAME
+			": seek timed out after %u ms\n", seek_timeout);
+
+stop:
+	/* stop seeking */
+	radio->registers[POWERCFG] &= ~POWERCFG_SEEK;
+	retval = si470x_set_register(radio, POWERCFG);
+
+done:
+	/* try again, if timed out */
+	if ((retval == 0) && timed_out)
+		retval = -EAGAIN;
+
+	return retval;
+}
+
+
+/*
  * si470x_start - switch on radio
  */
 static int si470x_start(struct si470x_device *radio)
@@ -717,27 +596,31 @@ static int si470x_start(struct si470x_de
 		POWERCFG_DMUTE | POWERCFG_ENABLE | POWERCFG_RDSM;
 	retval = si470x_set_register(radio, POWERCFG);
 	if (retval < 0)
-		return retval;
+		goto done;
 
 	/* sysconfig 1 */
-	radio->registers[SYSCONFIG1] = SYSCONFIG1_DE;
+	radio->registers[SYSCONFIG1] =
+		(de << 11) & SYSCONFIG1_DE;		/* DE */
 	retval = si470x_set_register(radio, SYSCONFIG1);
 	if (retval < 0)
-		return retval;
+		goto done;
 
 	/* sysconfig 2 */
 	radio->registers[SYSCONFIG2] =
-		(0x3f  << 8) |	/* SEEKTH */
-		(band  << 6) |	/* BAND */
-		(space << 4) |	/* SPACE */
-		15;		/* VOLUME (max) */
+		(0x3f  << 8) |				/* SEEKTH */
+		((band  << 6) & SYSCONFIG2_BAND)  |	/* BAND */
+		((space << 4) & SYSCONFIG2_SPACE) |	/* SPACE */
+		15;					/* VOLUME (max) */
 	retval = si470x_set_register(radio, SYSCONFIG2);
 	if (retval < 0)
-		return retval;
+		goto done;
 
 	/* reset last channel */
-	return si470x_set_chan(radio,
+	retval = si470x_set_chan(radio,
 		radio->registers[CHANNEL] & CHANNEL_CHAN);
+
+done:
+	return retval;
 }
 
 
@@ -752,13 +635,16 @@ static int si470x_stop(struct si470x_dev
 	radio->registers[SYSCONFIG1] &= ~SYSCONFIG1_RDS;
 	retval = si470x_set_register(radio, SYSCONFIG1);
 	if (retval < 0)
-		return retval;
+		goto done;
 
 	/* powercfg */
 	radio->registers[POWERCFG] &= ~POWERCFG_DMUTE;
 	/* POWERCFG_ENABLE has to automatically go low */
 	radio->registers[POWERCFG] |= POWERCFG_ENABLE |	POWERCFG_DISABLE;
-	return si470x_set_register(radio, POWERCFG);
+	retval = si470x_set_register(radio, POWERCFG);
+
+done:
+	return retval;
 }
 
 
@@ -875,6 +761,9 @@ static void si470x_work(struct work_stru
 	struct si470x_device *radio = container_of(work, struct si470x_device,
 		work.work);
 
+	/* safety checks */
+	if (radio->disconnected)
+		return;
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
 		return;
 
@@ -907,11 +796,15 @@ static ssize_t si470x_fops_read(struct f
 
 	/* block if no new data available */
 	while (radio->wr_index == radio->rd_index) {
-		if (file->f_flags & O_NONBLOCK)
-			return -EWOULDBLOCK;
+		if (file->f_flags & O_NONBLOCK) {
+			retval = -EWOULDBLOCK;
+			goto done;
+		}
 		if (wait_event_interruptible(radio->read_queue,
-			radio->wr_index != radio->rd_index) < 0)
-			return -EINTR;
+			radio->wr_index != radio->rd_index) < 0) {
+			retval = -EINTR;
+			goto done;
+		}
 	}
 
 	/* calculate block count from byte count */
@@ -940,6 +833,7 @@ static ssize_t si470x_fops_read(struct f
 	}
 	mutex_unlock(&radio->lock);
 
+done:
 	return retval;
 }
 
@@ -951,6 +845,7 @@ static unsigned int si470x_fops_poll(str
 		struct poll_table_struct *pts)
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
+	int retval = 0;
 
 	/* switch on rds reception */
 	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0) {
@@ -962,9 +857,9 @@ static unsigned int si470x_fops_poll(str
 	poll_wait(file, &radio->read_queue, pts);
 
 	if (radio->rd_index != radio->wr_index)
-		return POLLIN | POLLRDNORM;
+		retval = POLLIN | POLLRDNORM;
 
-	return 0;
+	return retval;
 }
 
 
@@ -981,17 +876,18 @@ static int si470x_fops_open(struct inode
 	retval = usb_autopm_get_interface(radio->intf);
 	if (retval < 0) {
 		radio->users--;
-		return -EIO;
+		retval = -EIO;
+		goto done;
 	}
 
 	if (radio->users == 1) {
 		retval = si470x_start(radio);
 		if (retval < 0)
 			usb_autopm_put_interface(radio->intf);
-		return retval;
 	}
 
-	return 0;
+done:
+	return retval;
 }
 
 
@@ -1001,13 +897,24 @@ static int si470x_fops_open(struct inode
 static int si470x_fops_release(struct inode *inode, struct file *file)
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
-	int retval;
+	int retval = 0;
 
-	if (!radio)
-		return -ENODEV;
+	/* safety check */
+	if (!radio) {
+		retval = -ENODEV;
+		goto done;
+	}
 
+	mutex_lock(&radio->disconnect_lock);
 	radio->users--;
 	if (radio->users == 0) {
+		if (radio->disconnected) {
+			video_unregister_device(radio->videodev);
+			kfree(radio->buffer);
+			kfree(radio);
+			goto unlock;
+		}
+
 		/* stop rds reception */
 		cancel_delayed_work_sync(&radio->work);
 
@@ -1016,10 +923,13 @@ static int si470x_fops_release(struct in
 
 		retval = si470x_stop(radio);
 		usb_autopm_put_interface(radio->intf);
-		return retval;
 	}
 
-	return 0;
+unlock:
+	mutex_unlock(&radio->disconnect_lock);
+
+done:
+	return retval;
 }
 
 
@@ -1082,6 +992,78 @@ static struct v4l2_queryctrl si470x_v4l2
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
 
 
@@ -1095,7 +1077,8 @@ static int si470x_vidioc_querycap(struct
 	strlcpy(capability->card, DRIVER_CARD, sizeof(capability->card));
 	sprintf(capability->bus_info, "USB");
 	capability->version = DRIVER_KERNEL_VERSION;
-	capability->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
+	capability->capabilities = V4L2_CAP_HW_FREQ_SEEK |
+		V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 
 	return 0;
 }
@@ -1104,7 +1087,7 @@ static int si470x_vidioc_querycap(struct
 /*
  * si470x_vidioc_g_input - get input
  */
-static int si470x_vidioc_g_input(struct file *filp, void *priv,
+static int si470x_vidioc_g_input(struct file *file, void *priv,
 		unsigned int *i)
 {
 	*i = 0;
@@ -1116,12 +1099,18 @@ static int si470x_vidioc_g_input(struct 
 /*
  * si470x_vidioc_s_input - set input
  */
-static int si470x_vidioc_s_input(struct file *filp, void *priv, unsigned int i)
+static int si470x_vidioc_s_input(struct file *file, void *priv, unsigned int i)
 {
+	int retval = 0;
+
+	/* safety checks */
 	if (i != 0)
-		return -EINVAL;
+		retval = -EINVAL;
 
-	return 0;
+	if (retval < 0)
+		printk(KERN_WARNING DRIVER_NAME
+			": set input failed with %d\n", retval);
+	return retval;
 }
 
 
@@ -1134,17 +1123,22 @@ static int si470x_vidioc_queryctrl(struc
 	unsigned char i;
 	int retval = -EINVAL;
 
+	/* safety checks */
+	if (!qc->id)
+		goto done;
+
 	for (i = 0; i < ARRAY_SIZE(si470x_v4l2_queryctrl); i++) {
-		if (qc->id && qc->id == si470x_v4l2_queryctrl[i].id) {
+		if (qc->id == si470x_v4l2_queryctrl[i].id) {
 			memcpy(qc, &(si470x_v4l2_queryctrl[i]), sizeof(*qc));
 			retval = 0;
 			break;
 		}
 	}
+
+done:
 	if (retval < 0)
 		printk(KERN_WARNING DRIVER_NAME
-			": query control failed with %d\n", retval);
-
+			": query controls failed with %d\n", retval);
 	return retval;
 }
 
@@ -1156,6 +1150,13 @@ static int si470x_vidioc_g_ctrl(struct f
 		struct v4l2_control *ctrl)
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
+	int retval = 0;
+
+	/* safety checks */
+	if (radio->disconnected) {
+		retval = -EIO;
+		goto done;
+	}
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_VOLUME:
@@ -1166,9 +1167,59 @@ static int si470x_vidioc_g_ctrl(struct f
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
+	default:
+		retval = -EINVAL;
 	}
 
-	return 0;
+done:
+	if (retval < 0)
+		printk(KERN_WARNING DRIVER_NAME
+			": get control failed with %d\n", retval);
+	return retval;
 }
 
 
@@ -1179,7 +1230,13 @@ static int si470x_vidioc_s_ctrl(struct f
 		struct v4l2_control *ctrl)
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
-	int retval;
+	int retval = 0;
+
+	/* safety checks */
+	if (radio->disconnected) {
+		retval = -EIO;
+		goto done;
+	}
 
 	switch (ctrl->id) {
 	case V4L2_CID_AUDIO_VOLUME:
@@ -1194,13 +1251,80 @@ static int si470x_vidioc_s_ctrl(struct f
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
+
+done:
 	if (retval < 0)
 		printk(KERN_WARNING DRIVER_NAME
 			": set control failed with %d\n", retval);
-
 	return retval;
 }
 
@@ -1211,13 +1335,22 @@ static int si470x_vidioc_s_ctrl(struct f
 static int si470x_vidioc_g_audio(struct file *file, void *priv,
 		struct v4l2_audio *audio)
 {
-	if (audio->index > 1)
-		return -EINVAL;
+	int retval = 0;
+
+	/* safety checks */
+	if (audio->index != 0) {
+		retval = -EINVAL;
+		goto done;
+	}
 
 	strcpy(audio->name, "Radio");
 	audio->capability = V4L2_AUDCAP_STEREO;
 
-	return 0;
+done:
+	if (retval < 0)
+		printk(KERN_WARNING DRIVER_NAME
+			": get audio failed with %d\n", retval);
+	return retval;
 }
 
 
@@ -1227,10 +1360,19 @@ static int si470x_vidioc_g_audio(struct 
 static int si470x_vidioc_s_audio(struct file *file, void *priv,
 		struct v4l2_audio *audio)
 {
-	if (audio->index != 0)
-		return -EINVAL;
+	int retval = 0;
 
-	return 0;
+	/* safety checks */
+	if (audio->index != 0) {
+		retval = -EINVAL;
+		goto done;
+	}
+
+done:
+	if (retval < 0)
+		printk(KERN_WARNING DRIVER_NAME
+			": set audio failed with %d\n", retval);
+	return retval;
 }
 
 
@@ -1241,19 +1383,24 @@ static int si470x_vidioc_g_tuner(struct 
 		struct v4l2_tuner *tuner)
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
-	int retval;
+	int retval = 0;
 
-	if (tuner->index > 0)
-		return -EINVAL;
+	/* safety checks */
+	if (radio->disconnected) {
+		retval = -EIO;
+		goto done;
+	}
+	if ((tuner->index != 0) && (tuner->type != V4L2_TUNER_RADIO)) {
+		retval = -EINVAL;
+		goto done;
+	}
 
-	/* read status rssi */
 	retval = si470x_get_register(radio, STATUSRSSI);
 	if (retval < 0)
-		return retval;
+		goto done;
 
 	strcpy(tuner->name, "FM");
-	tuner->type = V4L2_TUNER_RADIO;
-	switch (band) {
+	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_BAND) >> 6) {
 	/* 0: 87.5 - 108 MHz (USA, Europe, default) */
 	default:
 		tuner->rangelow  =  87.5 * FREQ_MUL;
@@ -1284,9 +1431,14 @@ static int si470x_vidioc_g_tuner(struct 
 				* 0x0101;
 
 	/* automatic frequency control: -1: freq to low, 1 freq to high */
-	tuner->afc = 0;
+	/* AFCRL does only indicate that freq. differs, not if too low/high */
+	tuner->afc = (radio->registers[STATUSRSSI] & STATUSRSSI_AFCRL) ? 1 : 0;
 
-	return 0;
+done:
+	if (retval < 0)
+		printk(KERN_WARNING DRIVER_NAME
+			": get tuner failed with %d\n", retval);
+	return retval;
 }
 
 
@@ -1297,10 +1449,17 @@ static int si470x_vidioc_s_tuner(struct 
 		struct v4l2_tuner *tuner)
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
-	int retval;
+	int retval = 0;
 
-	if (tuner->index > 0)
-		return -EINVAL;
+	/* safety checks */
+	if (radio->disconnected) {
+		retval = -EIO;
+		goto done;
+	}
+	if ((tuner->index != 0) && (tuner->type != V4L2_TUNER_RADIO)) {
+		retval = -EINVAL;
+		goto done;
+	}
 
 	if (tuner->audmode == V4L2_TUNER_MODE_MONO)
 		radio->registers[POWERCFG] |= POWERCFG_MONO;  /* force mono */
@@ -1308,10 +1467,11 @@ static int si470x_vidioc_s_tuner(struct 
 		radio->registers[POWERCFG] &= ~POWERCFG_MONO; /* try stereo */
 
 	retval = si470x_set_register(radio, POWERCFG);
+
+done:
 	if (retval < 0)
 		printk(KERN_WARNING DRIVER_NAME
 			": set tuner failed with %d\n", retval);
-
 	return retval;
 }
 
@@ -1323,11 +1483,25 @@ static int si470x_vidioc_g_frequency(str
 		struct v4l2_frequency *freq)
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
+	int retval = 0;
 
-	freq->type = V4L2_TUNER_RADIO;
-	freq->frequency = si470x_get_freq(radio);
+	/* safety checks */
+	if (radio->disconnected) {
+		retval = -EIO;
+		goto done;
+	}
+	if ((freq->tuner != 0) && (freq->type != V4L2_TUNER_RADIO)) {
+		retval = -EINVAL;
+		goto done;
+	}
 
-	return 0;
+	retval = si470x_get_freq(radio, &freq->frequency);
+
+done:
+	if (retval < 0)
+		printk(KERN_WARNING DRIVER_NAME
+			": get frequency failed with %d\n", retval);
+	return retval;
 }
 
 
@@ -1338,17 +1512,55 @@ static int si470x_vidioc_s_frequency(str
 		struct v4l2_frequency *freq)
 {
 	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
-	int retval;
+	int retval = 0;
 
-	if (freq->type != V4L2_TUNER_RADIO)
-		return -EINVAL;
+	/* safety checks */
+	if (radio->disconnected) {
+		retval = -EIO;
+		goto done;
+	}
+	if ((freq->tuner != 0) && (freq->type != V4L2_TUNER_RADIO)) {
+		retval = -EINVAL;
+		goto done;
+	}
 
 	retval = si470x_set_freq(radio, freq->frequency);
+
+done:
 	if (retval < 0)
 		printk(KERN_WARNING DRIVER_NAME
 			": set frequency failed with %d\n", retval);
+	return retval;
+}
 
-	return 0;
+
+/*
+ * si470x_vidioc_s_hw_freq_seek - set hardware frequency seek
+ */
+static int si470x_vidioc_s_hw_freq_seek(struct file *file, void *priv,
+		struct v4l2_hw_freq_seek *seek)
+{
+	struct si470x_device *radio = video_get_drvdata(video_devdata(file));
+	int retval = 0;
+
+	/* safety checks */
+	if (radio->disconnected) {
+		retval = -EIO;
+		goto done;
+	}
+	if ((seek->tuner != 0) && (seek->type != V4L2_TUNER_RADIO)) {
+		retval = -EINVAL;
+		goto done;
+	}
+
+	retval = si470x_set_seek(radio, seek->wrap_around, seek->seek_upward);
+
+done:
+	if (retval < 0)
+		printk(KERN_WARNING DRIVER_NAME
+			": set hardware frequency seek failed with %d\n",
+			retval);
+	return retval;
 }
 
 
@@ -1372,6 +1584,7 @@ static struct video_device si470x_viddev
 	.vidioc_s_tuner		= si470x_vidioc_s_tuner,
 	.vidioc_g_frequency	= si470x_vidioc_g_frequency,
 	.vidioc_s_frequency	= si470x_vidioc_s_frequency,
+	.vidioc_s_hw_freq_seek	= si470x_vidioc_s_hw_freq_seek,
 	.owner			= THIS_MODULE,
 };
 
@@ -1388,31 +1601,35 @@ static int si470x_usb_driver_probe(struc
 		const struct usb_device_id *id)
 {
 	struct si470x_device *radio;
-	int retval = -ENOMEM;
+	int retval = 0;
 
-	/* private data allocation */
+	/* private data allocation and initialization */
 	radio = kzalloc(sizeof(struct si470x_device), GFP_KERNEL);
-	if (!radio)
+	if (!radio) {
+		retval = -ENOMEM;
 		goto err_initial;
+	}
+	radio->users = 0;
+	radio->usbdev = interface_to_usbdev(intf);
+	radio->intf = intf;
+	mutex_init(&radio->disconnect_lock);
+	mutex_init(&radio->lock);
 
-	/* video device allocation */
+	/* video device allocation and initialization */
 	radio->videodev = video_device_alloc();
-	if (!radio->videodev)
+	if (!radio->videodev) {
+		retval = -ENOMEM;
 		goto err_radio;
-
-	/* initial configuration */
+	}
 	memcpy(radio->videodev, &si470x_viddev_template,
 			sizeof(si470x_viddev_template));
-	radio->users = 0;
-	radio->usbdev = interface_to_usbdev(intf);
-	radio->intf = intf;
-	mutex_init(&radio->lock);
 	video_set_drvdata(radio->videodev, radio);
 
 	/* show some infos about the specific device */
-	retval = -EIO;
-	if (si470x_get_all_registers(radio) < 0)
+	if (si470x_get_all_registers(radio) < 0) {
+		retval = -EIO;
 		goto err_all;
+	}
 	printk(KERN_INFO DRIVER_NAME ": DeviceID=0x%4.4hx ChipID=0x%4.4hx\n",
 			radio->registers[DEVICEID], radio->registers[CHIPID]);
 
@@ -1438,8 +1655,10 @@ static int si470x_usb_driver_probe(struc
 	/* rds buffer allocation */
 	radio->buf_size = rds_buf * 3;
 	radio->buffer = kmalloc(radio->buf_size, GFP_KERNEL);
-	if (!radio->buffer)
+	if (!radio->buffer) {
+		retval = -EIO;
 		goto err_all;
+	}
 
 	/* rds buffer configuration */
 	radio->wr_index = 0;
@@ -1451,6 +1670,7 @@ static int si470x_usb_driver_probe(struc
 
 	/* register video device */
 	if (video_register_device(radio->videodev, VFL_TYPE_RADIO, radio_nr)) {
+		retval = -EIO;
 		printk(KERN_WARNING DRIVER_NAME
 				": Could not register video device\n");
 		goto err_all;
@@ -1510,11 +1730,16 @@ static void si470x_usb_driver_disconnect
 {
 	struct si470x_device *radio = usb_get_intfdata(intf);
 
+	mutex_lock(&radio->disconnect_lock);
+	radio->disconnected = 1;
 	cancel_delayed_work_sync(&radio->work);
 	usb_set_intfdata(intf, NULL);
-	video_unregister_device(radio->videodev);
-	kfree(radio->buffer);
-	kfree(radio);
+	if (radio->users == 0) {
+		video_unregister_device(radio->videodev);
+		kfree(radio->buffer);
+		kfree(radio);
+	}
+	mutex_unlock(&radio->disconnect_lock);
 }
 
 
--- linux-2.6.25/include/media/radio-si470x.[h]	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.25-si470x/include/media/radio-si470x.h	2008-05-07 20:29:20.000000000 +0200
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
+#define V4L2_CID_PRIVATE_SI470X_DSMUTE	(V4L2_CID_PRIVATE_BASE + (POWERCFG  <<4) + 15)
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

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
