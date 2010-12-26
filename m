Return-path: <mchehab@gaivota>
Received: from adelie.canonical.com ([91.189.90.139]:58210 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab0LZJOq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Dec 2010 04:14:46 -0500
Message-ID: <4D170785.1070306@canonical.com>
Date: Sun, 26 Dec 2010 10:14:45 +0100
From: David Henningsson <david.henningsson@canonical.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: mchehab@infradead.org
Subject: [PATCH] DVB: TechnoTrend CT-3650 IR support
Content-Type: multipart/mixed;
 boundary="------------030803060803030709080709"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is a multi-part message in MIME format.
--------------030803060803030709080709
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Linux-media,

As a spare time project I bought myself a TT CT-3650, to see if I could 
get it working. Waling Dijkstra did write a IR & CI patch for this model 
half a year ago, so I was hopeful. (Reference: 
http://www.mail-archive.com/linux-media@vger.kernel.org/msg19860.html )

Having tested the patch, the IR is working (tested all keys via the 
"evtest" tool), however descrambling is NOT working.

Waling's patch was reviewed but never merged. So I have taken the IR 
part of the patch, cleaned it up a little, and hopefully this part is 
ready for merging now. Patch is against linux-2.6.git.

As for the descrambling/CI/CAM part, that'll be the next assignment. 
I'll be happy for some mentoring as I haven't done anything in this part 
of the kernel before - whether I can debug some of it here or if I'll 
have to install Windows and an USB sniffer to see what it does?


-- 
David Henningsson, Canonical Ltd.
http://launchpad.net/~diwic

--------------030803060803030709080709
Content-Type: text/x-patch;
 name="0001-DVB-TechnoTrend-CT-3650-IR-support.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-DVB-TechnoTrend-CT-3650-IR-support.patch"

>From 705adeab4da152cf24cede069b724765b8a07d55 Mon Sep 17 00:00:00 2001
From: David Henningsson <david.henningsson@canonical.com>
Date: Sun, 26 Dec 2010 07:55:57 +0100
Subject: [PATCH] DVB: TechnoTrend CT-3650 IR support

This patch enables IR support on the TechnoTrend CT-3650 device,
and is half of Waling Dijkstra's patch posted earlier this year,
cleaned up a little.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
---
 drivers/media/dvb/dvb-usb/ttusb2.c |   75 ++++++++++++++++++++++++++++++++++++
 drivers/media/dvb/dvb-usb/ttusb2.h |    3 +
 2 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/ttusb2.c b/drivers/media/dvb/dvb-usb/ttusb2.c
index a6de489..1bacfc8 100644
--- a/drivers/media/dvb/dvb-usb/ttusb2.c
+++ b/drivers/media/dvb/dvb-usb/ttusb2.c
@@ -128,6 +128,76 @@ static struct i2c_algorithm ttusb2_i2c_algo = {
 	.functionality = ttusb2_i2c_func,
 };
 
+/* IR */
+/* Remote Control Stuff for CT-3650 (copied from TT-S1500): */
+static struct dvb_usb_rc_key tt_connect_CT_3650_rc_key[] = {
+	{0x1501, KEY_POWER},
+	{0x1502, KEY_SHUFFLE}, /* ? double-arrow key */
+	{0x1503, KEY_1},
+	{0x1504, KEY_2},
+	{0x1505, KEY_3},
+	{0x1506, KEY_4},
+	{0x1507, KEY_5},
+	{0x1508, KEY_6},
+	{0x1509, KEY_7},
+	{0x150a, KEY_8},
+	{0x150b, KEY_9},
+	{0x150c, KEY_0},
+	{0x150d, KEY_UP},
+	{0x150e, KEY_LEFT},
+	{0x150f, KEY_OK},
+	{0x1510, KEY_RIGHT},
+	{0x1511, KEY_DOWN},
+	{0x1512, KEY_INFO},
+	{0x1513, KEY_EXIT},
+	{0x1514, KEY_RED},
+	{0x1515, KEY_GREEN},
+	{0x1516, KEY_YELLOW},
+	{0x1517, KEY_BLUE},
+	{0x1518, KEY_MUTE},
+	{0x1519, KEY_TEXT},
+	{0x151a, KEY_MODE},  /* ? TV/Radio */
+	{0x1521, KEY_OPTION},
+	{0x1522, KEY_EPG},
+	{0x1523, KEY_CHANNELUP},
+	{0x1524, KEY_CHANNELDOWN},
+	{0x1525, KEY_VOLUMEUP},
+	{0x1526, KEY_VOLUMEDOWN},
+	{0x1527, KEY_SETUP},
+	{0x153a, KEY_RECORD},/* these keys are only in the black remote */
+	{0x153b, KEY_PLAY},
+	{0x153c, KEY_STOP},
+	{0x153d, KEY_REWIND},
+	{0x153e, KEY_PAUSE},
+	{0x153f, KEY_FORWARD}
+};
+
+/* Copy-pasted from dvb-usb-remote.c */
+#define DVB_USB_RC_NEC_KEY_PRESSED     0x01
+
+static int tt3650_rc_query(struct dvb_usb_device *d, u32 *keyevent, int *keystate)
+{
+	u8 keybuf[5];
+	int ret;
+	u8 rx[9]; /* A CMD_GET_IR_CODE reply is 9 bytes long */
+	ret = ttusb2_msg(d, CMD_GET_IR_CODE, NULL, 0, rx, sizeof(rx));
+	if (ret != 0)
+		return ret;
+
+	if (rx[8] & 0x01) {
+		/* got a "press" event */
+		deb_info("%s: cmd=0x%02x sys=0x%02x\n", __func__, rx[2], rx[3]);
+		keybuf[0] = DVB_USB_RC_NEC_KEY_PRESSED;
+		keybuf[1] = rx[3];
+		keybuf[2] = ~keybuf[1]; /* fake checksum */
+		keybuf[3] = rx[2];
+		keybuf[4] = ~keybuf[3]; /* fake checksum */
+		dvb_usb_nec_rc_key_to_event(d, keybuf, keyevent, keystate);
+	}
+	return 0;
+}
+
+
 /* Callbacks for DVB USB */
 static int ttusb2_identify_state (struct usb_device *udev, struct
 		dvb_usb_device_properties *props, struct dvb_usb_device_description **desc,
@@ -345,6 +415,11 @@ static struct dvb_usb_device_properties ttusb2_properties_ct3650 = {
 
 	.size_of_priv = sizeof(struct ttusb2_state),
 
+	.rc_key_map = tt_connect_CT_3650_rc_key,
+	.rc_key_map_size = ARRAY_SIZE(tt_connect_CT_3650_rc_key),
+	.rc_query = tt3650_rc_query,
+	.rc_interval = 500,
+
 	.num_adapters = 1,
 	.adapter = {
 		{
diff --git a/drivers/media/dvb/dvb-usb/ttusb2.h b/drivers/media/dvb/dvb-usb/ttusb2.h
index 52a63af..1bd5d54 100644
--- a/drivers/media/dvb/dvb-usb/ttusb2.h
+++ b/drivers/media/dvb/dvb-usb/ttusb2.h
@@ -45,6 +45,9 @@
 #define CMD_DISEQC          0x18
 /* out data: <master=0xff/burst=??> <cmdlen> <cmdbytes>[cmdlen] */
 
+/* command to poll IR receiver (copied from pctv452e.c) */
+#define CMD_GET_IR_CODE     0x1b
+
 #define CMD_PID_ENABLE      0x22
 /* out data: <index> <type: ts=1/sec=2> <pid msb> <pid lsb> */
 
-- 
1.7.1


--------------030803060803030709080709--
