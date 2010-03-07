Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout5.poczta.onet.pl ([213.180.147.165]:46298 "EHLO
	smtpout5.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab0CGNq1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Mar 2010 08:46:27 -0500
Received: from dynamic-78-8-130-150.ssp.dialog.net.pl ([78.8.130.150]:40943
	"EHLO [78.8.130.150]" rhost-flags-OK-OK-OK-FAIL) by ps1.m5r2.onet
	with ESMTPA id S134224436Ab0CGNqZLsQ-i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Mar 2010 14:46:25 +0100
Subject: PATCH driver for TwinhanDTV StarBox DVB-S model no:7021
From: Tomek <tomekbu@op.pl>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sun, 07 Mar 2010 14:46:27 +0100
Message-Id: <1267969587.11136.7.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

bug fix for Twinhan DTV StarBox USB2.0 DVB-S model no:7021
enabled remote control
#kernel>=2.6.32.8 highly recommended
Signed-off-by: Tomasz G. Burak <tomekbu@op.pl>
---
linux-2.6.32.8/drivers/media/dvb/dvb-usb/vp702x.c.orig      2010-02-09
13:57:19.000000000 +0100
+++ linux-2.6.32.8/drivers/media/dvb/dvb-usb/vp702x.c   2010-02-19
01:14:10.000000000 +0100
@@ -173,40 +173,86 @@ static int vp702x_streaming_ctrl(struct 
        return 0;
 }
 
-/* keys for the enclosed remote control */
+/* keys for the enclosed remote control (define your events) (code,
event) */
 static struct dvb_usb_rc_key vp702x_rc_keys[] = {
-       { 0x0001, KEY_1 },
-       { 0x0002, KEY_2 },
+       { 0x004d, KEY_SCREEN }, /* Full screen */
+       { 0x0016, KEY_POWER }, /* Power */
+       { 0x0003, KEY_1 }, /* 1 */
+       { 0x0001, KEY_2 }, /* 2 */
+       { 0x0006, KEY_3 }, /* 3 */
+       { 0x0009, KEY_4 }, /* 4 */
+       { 0x001d, KEY_5 }, /* 5 */
+       { 0x001f, KEY_6 }, /* 6 */
+       { 0x000d, KEY_7 }, /* 6 */
+       { 0x0019, KEY_8 }, /* 7 */
+       { 0x001b, KEY_9 }, /* 8 */
+       { 0x0011, KEY_RECORD }, /* REC */
+       { 0x0015, KEY_0 }, /* 9 */
+       { 0x0017, KEY_FAVORITES }, /* Heart symbol - Favorite */
+       { 0x0040, KEY_REWIND }, /* Rewind */
+       { 0x0005, KEY_CHANNELUP }, /* CH+ */
+       { 0x0012, KEY_FASTFORWARD }, /* Forward */
+       { 0x000a, KEY_VOLUMEDOWN }, /* VOL- */
+       { 0x0014, KEY_PLAY }, /* Play */
+       { 0x001e, KEY_VOLUMEUP }, /* VOL+ */
+       { 0x000e, KEY_PREVIOUS }, /* Recall */
+       { 0x0002, KEY_CHANNELDOWN }, /* CH- */
+       { 0x001a, KEY_STOP }, /* Stop */
+       { 0x004c, KEY_PAUSE }, /* Time Shift - Pause */
+       { 0x0010, KEY_MUTE }, /* Mute */
+       { 0x000c, KEY_CANCEL }, /* Cancel */
+       { 0x0054, KEY_PRINT }, /* Capture */
+       { 0x0048, KEY_INFO }, /* Preview */
+       { 0x001c, KEY_EPG }, /* EPG */
+       { 0x0004, KEY_LIST }, /* RecordList */
+       { 0x0000, KEY_TAB }, /* Tab */
+       { 0x000f, KEY_TEXT }, /* Teletext */
+       { 0x0041, KEY_PREVIOUSSONG },
+       { 0x0042, KEY_NEXTSONG },
+       { 0x004b, KEY_UP },
+       { 0x0051, KEY_DOWN },
+       { 0x004e, KEY_LEFT },
+       { 0x0052, KEY_RIGHT },
+       { 0x004f, KEY_ENTER },
+       { 0x0054, KEY_AUDIO }, /* MTS - Switch to secondary audio. */
+       { 0x0013, KEY_CANCEL },
+       { 0x004a, KEY_CLEAR },
+       { 0x0043, KEY_SUBTITLE }, /* Subtitle/CC */
+       { 0x0008, KEY_VIDEO }, /* A/V */
+       { 0x0007, KEY_SLEEP }, /* Hibernate */
+       { 0x0045, KEY_ZOOM }, /* Zoom+ */
+       { 0x0018, KEY_RED},
+       { 0x0053, KEY_GREEN},
+       { 0x005e, KEY_YELLOW},
+       { 0x005f, KEY_BLUE}
 };
 
-/* remote control stuff (does not work with my box) */
+/* remote control stuff */
 static int vp702x_rc_query(struct dvb_usb_device *d, u32 *event, int
*state)
 {
        u8 key[10];
        int i;
 
-/* remove the following return to enabled remote querying */
-       return 0;
-
        vp702x_usb_in_op(d,READ_REMOTE_REQ,0,0,key,10);
 
-       deb_rc("remote query key: %x %d\n",key[1],key[1]);
+       deb_rc("remote query key: %x %d\n", key[3], key[3]);
 
        if (key[1] == 0x44) {
                *state = REMOTE_NO_KEY_PRESSED;
                return 0;
        }
 
-       for (i = 0; i < ARRAY_SIZE(vp702x_rc_keys); i++)
-               if (rc5_custom(&vp702x_rc_keys[i]) == key[1]) {
-                       *state = REMOTE_KEY_PRESSED;
-                       *event = vp702x_rc_keys[i].event;
-                       break;
+       if (key[2] == key[3] + key[4]) {
+               for (i = 0; i < ARRAY_SIZE(vp702x_rc_keys); i++)
+                       if (rc5_data(&vp702x_rc_keys[i]) == key[3]) {
+                               *state = REMOTE_KEY_PRESSED;
+                               *event = vp702x_rc_keys[i].event;
+                               break;
+                       }
                }
        return 0;
 }
 
-
 static int vp702x_read_mac_addr(struct dvb_usb_device *d,u8 mac[6])
 {
        u8 i;

