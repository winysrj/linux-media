Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:23913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab1ECWQx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2011 18:16:53 -0400
Message-ID: <4DC07ECE.8020803@redhat.com>
Date: Tue, 03 May 2011 19:16:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: tomekbu@op.pl
CC: linux-media@vger.kernel.org, dougsland@redhat.com
Subject: Re: [PATCH] DVB-USB: Remote Control for TwinhanDTV StarBox DVB-S
 USB and	clones
References: <16516113-42e1b2a09001189ca94b34ee8dae5151@pkn6.m5r2.onet>
In-Reply-To: <16516113-42e1b2a09001189ca94b34ee8dae5151@pkn6.m5r2.onet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 07-02-2011 21:27, tomekbu@op.pl escreveu:
> bug fix for Twinhan DTV StarBox USB2.0 DVB-S model no:7021 and clones
> remote control stuff will work now
> #kernel>=2.6.37 highly recommended
> Signed-off-by: Tomasz G. Burak tomekbu@op.pl


Tomasz, if you want your patches to be applied, don't use copy/paste, as this
will break your patch. If you really want to use a copy/paste approach, you
should use, instead xclip, like:

git show|xclip

This will do the right thing, if your emailer doesn't support inlined attachments.
I fixed the patch for you and changed a few issues on the keymap tables. Please
review.

Still, there are still a fe issues with the patch:

1) keymap tables should be created/moved into drivers/media/rc/keymaps;
2) it should not be using .rc.legacy support, but, instead, using .rc.core new
   way to support remote devices;
3) The keycode table and keycode routine is only getting 8 bits. RC5 keytables
   have 14 bits. Probably, your IR uses 0x00 for the device address. That's why
   you've mapped it with 8 bits. However, this way prevents the code usage for
   those that are using other remotes and are overriding the keycode tables via
   ir-keytables userspace app (found at v4l-utils.git tree, hosted on linuxtv.org).

Could you please fix them and re-send the patch?

Thank you!
Mauro.


-

Subject: DVB-USB: Remote Control for TwinhanDTV StarBox DVB-S USB and clones
Date: Mon, 07 Feb 2011 23:27:30 -0000
From: Tomasz G. Burak <tomekbu@op.pl>

Bug fix for Twinhan DTV StarBox USB2.0 DVB-S model no:7021 and clones
remote control stuff will work now

[mchehab@redhat.com: Fixed a few keystrokes and keep the correct rc_map_table
 struct name]
Signed-off-by: Tomasz G. Burak <tomekbu@op.pl>

---
 drivers/media/dvb/dvb-usb/vp702x.c |   73 ++++++++++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 16 deletions(-)

--- patchwork.orig/drivers/media/dvb/dvb-usb/vp702x.c
+++ patchwork/drivers/media/dvb/dvb-usb/vp702x.c
@@ -252,26 +252,66 @@ static int vp702x_streaming_ctrl(struct 
 
 /* keys for the enclosed remote control */
 static struct rc_map_table rc_map_vp702x_table[] = {
-	{ 0x0001, KEY_1 },
-	{ 0x0002, KEY_2 },
+	{ 0x004d, KEY_SCREEN },		/* Full screen */
+	{ 0x0016, KEY_POWER2 },		/* Power */
+	{ 0x0003, KEY_1 },		/* 1 */
+	{ 0x0001, KEY_2 },		/* 2 */
+	{ 0x0006, KEY_3 },		/* 3 */
+	{ 0x0009, KEY_4 },		/* 4 */
+	{ 0x001d, KEY_5 },		/* 5 */
+	{ 0x001f, KEY_6 },		/* 6 */
+	{ 0x000d, KEY_7 },		/* 7 */
+	{ 0x0019, KEY_8 },		/* 8 */
+	{ 0x001b, KEY_9 },		/* 9 */
+	{ 0x0011, KEY_RECORD },		/* REC */
+	{ 0x0015, KEY_0 },		/* 0 */
+	{ 0x0017, KEY_FAVORITES },	/* Heart symbol - Favorite */
+	{ 0x0040, KEY_REWIND },		/* Rewind */
+	{ 0x0005, KEY_CHANNELUP },	/* CH+ */
+	{ 0x0012, KEY_FASTFORWARD },	/* Forward */
+	{ 0x000a, KEY_VOLUMEDOWN },	/* VOL- */
+	{ 0x0014, KEY_PLAY },		/* Play */
+	{ 0x001e, KEY_VOLUMEUP },	/* VOL+ */
+	{ 0x000e, KEY_PREVIOUS },	/* Recall */
+	{ 0x0002, KEY_CHANNELDOWN },	/* CH- */
+	{ 0x001a, KEY_STOP },		/* Stop */
+	{ 0x004c, KEY_PAUSE },		/* Time Shift - Pause */
+	{ 0x0010, KEY_MUTE },		/* Mute */
+	{ 0x000c, KEY_CANCEL },		/* Cancel */
+	{ 0x0054, KEY_CAMERA },		/* Capture */
+	{ 0x0048, KEY_INFO },		/* Preview */
+	{ 0x001c, KEY_EPG },		/* EPG */
+	{ 0x0004, KEY_LIST },		/* RecordList */
+	{ 0x0000, KEY_TAB },		/* Tab */
+	{ 0x000f, KEY_TEXT },		/* Teletext */
+
+	{ 0x0041, KEY_PREVIOUSSONG },
+	{ 0x0042, KEY_NEXTSONG },
+	{ 0x004b, KEY_UP },
+	{ 0x0051, KEY_DOWN },
+	{ 0x004e, KEY_LEFT },
+	{ 0x0052, KEY_RIGHT },
+	{ 0x004f, KEY_ENTER },
+	{ 0x0054, KEY_AUDIO },		/* MTS - Switch to secondary audio. */
+	{ 0x0013, KEY_CANCEL },
+	{ 0x004a, KEY_CLEAR },
+	{ 0x0043, KEY_SUBTITLE },	/* Subtitle/CC */
+	{ 0x0008, KEY_VIDEO },		/* A/V */
+	{ 0x0007, KEY_SLEEP },		/* Hibernate */
+	{ 0x0045, KEY_ZOOM },		/* Zoom+ */
+	{ 0x0018, KEY_RED},
+	{ 0x0053, KEY_GREEN},
+	{ 0x005e, KEY_YELLOW},
+	{ 0x005f, KEY_BLUE}
 };
 
-/* remote control stuff (does not work with my box) */
 static int vp702x_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
 	u8 *key;
 	int i;
 
-/* remove the following return to enabled remote querying */
-	return 0;
-
-	key = kmalloc(10, GFP_KERNEL);
-	if (!key)
-		return -ENOMEM;
-
 	vp702x_usb_in_op(d,READ_REMOTE_REQ,0,0,key,10);
-
-	deb_rc("remote query key: %x %d\n",key[1],key[1]);
+	deb_rc("remote query key: %x %d\n",key[3],key[3]);
 
 	if (key[1] == 0x44) {
 		*state = REMOTE_NO_KEY_PRESSED;
@@ -279,13 +319,14 @@ static int vp702x_rc_query(struct dvb_us
 		return 0;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(rc_map_vp702x_table); i++)
-		if (rc5_custom(&rc_map_vp702x_table[i]) == key[1]) {
+	if (key[2] == key[3] + key[4]) {
+		for (i = 0; i < ARRAY_SIZE(ir_codes_vp702x_table); i++)
+		if (rc5_data(&ir_codes_vp702x_table[i]) == key[3]) {
 			*state = REMOTE_KEY_PRESSED;
-			*event = rc_map_vp702x_table[i].keycode;
+			*event = ir_codes_vp702x_table[i].keycode;
 			break;
 		}
-	kfree(key);
+	}
 	return 0;
 }
 
