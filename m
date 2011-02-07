Return-path: <mchehab@pedra>
Received: from smtpo17.poczta.onet.pl ([213.180.142.148]:44008 "EHLO
	smtpo17.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab1BGX1d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Feb 2011 18:27:33 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: tomekbu@op.pl
Cc: mchehab@redhat.com, dougsland@redhat.com
To: linux-media@vger.kernel.org
Date: Tue, 08 Feb 2011 00:27:30 +0100
Message-Id: <16516113-42e1b2a09001189ca94b34ee8dae5151@pkn6.m5r2.onet>
Subject: [PATCH] DVB-USB: Remote Control for TwinhanDTV StarBox DVB-S USB and
	clones
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

bug fix for Twinhan DTV StarBox USB2.0 DVB-S model no:7021 and clones
remote control stuff will work now
#kernel>=2.6.37 highly recommended
Signed-off-by: Tomasz G. Burak tomekbu@op.pl
---
--- drivers/media/dvb/dvb-usb/vp702x.c.orig 2011-01-05 01:50:19.000000000 +0100
+++ drivers/media/dvb/dvb-usb/vp702x.c 2011-02-05 17:50:44.000 000000 +0100
@@ -175,34 +175,81 @@ static int vp702x_streaming_ctrl(struct

/* keys for the enclosed remote control */
static struct ir_scancode ir_codes_vp702x_table[] = {
- { 0x0001, KEY_1 },
- { 0x0002, KEY_2 },
+ { 0x004d, KEY_SCREEN }, /* Full screen */
+ { 0x0016, KEY_POWER2 }, /* Power */
+ { 0x0003, KEY_1 }, /* 1 */
+ { 0x0001, KEY_2 }, /* 2 */
+ { 0x0006, KEY_3 }, /* 3 */
+ { 0x0009, KEY_4 }, /* 4 */
+ { 0x001d, KEY_5 }, /* 5 */
+ { 0x001f, KEY_6 }, /* 6 */
+ { 0x000d, KEY_7 }, /* 6 */
+ { 0x0019, KEY_8 }, /* 7 */
+ { 0x001b, KEY_9 }, /* 8 */
+ { 0x0011, KEY_RECORD }, /* REC */
+ { 0x0015, KEY_0 }, /* 9 */
+ { 0x0017, KEY_FAVORITES }, /* Heart symbol - Favorite */
+ { 0x0040, KEY_REWIND }, /* Rewind */
+ { 0x0005, KEY_CHANNELUP }, /* CH+ */
+ { 0x0012, KEY_FASTFORWARD }, /* Forward */
+ { 0x000a, KEY_VOLUMEDOWN }, /* VOL- */
+ { 0x0014, KEY_PLAY }, /* Play */
+ { 0x001e, KEY_VOLUMEUP }, /* VOL+ */
+ { 0x000e, KEY_PREVIOUS }, /* Recall */
+ { 0x0002, KEY_CHANNELDOWN }, /* CH- */
+ { 0x001a, KEY_STOP }, /* Stop */
+ { 0x004c, KEY_PAUSE }, /* Time Shift - Pause */
+ { 0x0010, KEY_MUTE }, /* Mute */
+ { 0x000c, KEY_CANCEL }, /* Cancel */
+ { 0x0054, KEY_PRINT }, /* Capture */
+ { 0x0048, KEY_INFO }, /* Preview */
+ { 0x001c, KEY_EPG }, /* EPG */
+ { 0x0004, KEY_LIST }, /* RecordList */
+ { 0x0000, KEY_TAB }, /* Tab */
+ { 0x000f, KEY_TEXT }, /* Teletext */
+
+ { 0x0041, KEY_PREVIOUSSONG },
+ { 0x0042, KEY_NEXTSONG },
+ { 0x004b, KEY_UP },
+ { 0x0051, KEY_DOWN },
+ { 0x004e, KEY_LEFT },
+ { 0x0052, KEY_RIGHT },
+ { 0x004f, KEY_ENTER },
+ { 0x0054, KEY_AUDIO }, /* MTS - Switch to secondary audio. */
+ { 0x0013, KEY_CANCEL },
+ { 0x004a, KEY_CLEAR },
+ { 0x0043, KEY_SUBTITLE }, /* Subtitle/CC */
+ { 0x0008, KEY_VIDEO }, /* A/V */
+ { 0x0007, KEY_SLEEP }, /* Hibernate */
+ { 0x0045, KEY_ZOOM }, /* Zoom+ */
+ { 0x0018, KEY_RED},
+ { 0x0053, KEY_GREEN},
+ { 0x005e, KEY_YELLOW},
+ { 0x005f, KEY_BLUE}
};

-/* remote control stuff (does not work with my box) */
static int vp702x_rc_query(struct dvb_usb_device *d, u32 *event, int
*state)
{
u8 key[10];
int i;

-/* remove the following return to enabled remote querying */
- return 0;
-
vp702x_usb_in_op(d,READ_REMOTE_REQ,0,0,key,10);

- deb_rc("remote query key: %x %d\n",key[1],key[1]);
+ deb_rc("remote query key: %x %d\n",key[3],key[3]);

if (key[1] == 0x44) {
*state = REMOTE_NO_KEY_PRESSED;
return 0;
}

- for (i = 0; i < ARRAY_SIZE(ir_codes_vp702x_table); i++)
- if (rc5_custom(&ir_codes_vp702x_table[i]) == key[1]) {
- *state = REMOTE_KEY_PRESSED;
- *event = ir_codes_vp702x_table[i].keycode;
- break;
- }
+ if (key[2] == key[3] + key[4]) {
+ for (i = 0; i < ARRAY_SIZE(ir_codes_vp702x_table); i++)
+ if (rc5_data(&ir_codes_vp702x_table[i]) == key[3]) {
+ *state = REMOTE_KEY_PRESSED;
+ *event = ir_codes_vp702x_table[i].keycode;
+ break;
+ }
+ }
return 0;
} 
