Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:33107 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752048AbdBUSc0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 13:32:26 -0500
Date: Tue, 21 Feb 2017 18:32:23 +0000
From: Sean Young <sean@mess.org>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: ir-keytable: infinite loops, segfaults
Message-ID: <20170221183223.GA3646@gofer.mess.org>
References: <20161130090229.GB639@shambles.local>
 <CAEsFdVOb8tWN=6OfnpdJqb9BZ4s-DARF53zgbyhz-_a0zac0Gg@mail.gmail.com>
 <20170202233533.GA14357@gofer.mess.org>
 <CAEsFdVMhbxb3d=_ugYjfYSCRZsQMhtt=kmsqX81x-6UjTYc-bg@mail.gmail.com>
 <20170204191050.GA31779@gofer.mess.org>
 <CAEsFdVM14VngTM5X=qWTitgwox+4yD8heUqjULe8C=3z2P+h3Q@mail.gmail.com>
 <CAEsFdVMb+-iTGKnBXi1MkB+_ihb5AwG2LZnRfXzEf4Hru33T0g@mail.gmail.com>
 <CAEsFdVOfGFJ9HYav2h0gNkpdhYzbnVxnPbOaZW+HpO3KE1S9-w@mail.gmail.com>
 <20170220171309.GA26632@gofer.mess.org>
 <CAEsFdVNbmNZpYcst6wuDAVw4XS2eNBqwMwgx9LwfLZtY_jHhVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <CAEsFdVNbmNZpYcst6wuDAVw4XS2eNBqwMwgx9LwfLZtY_jHhVA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 22, 2017 at 12:07:07AM +1100, Vincent McIntyre wrote:
> On 2/21/17, Sean Young <sean@mess.org> wrote:
> >> $ sudo cat /sys/class/rc/rc1/protocols
> >> nec
> >> $ sudo sh
> >> # echo "+rc-5 +nec +rc-6 +jvc +sony +rc-5-sz +sanyo +sharp +xmp" >
> >> /sys/class/rc/rc1/protocols
> >> bash: echo: write error: Invalid argument
> >> # cat  /sys/class/rc/rc1/protocols
> >> nec
> >> In kern.log I got:
> >> kernel: [ 2293.491534] rc_core: Normal protocol change requested
> >> kernel: [ 2293.491538] rc_core: Protocol switching not supported
> >>
> >> # echo "+nec" > /sys/class/rc/rc1/protocols
> >> bash: echo: write error: Invalid argument
> >> kernel: [ 2390.832476] rc_core: Normal protocol change requested
> >> kernel: [ 2390.832481] rc_core: Protocol switching not supported
> >
> > That is expected. Does the the keymap actually work?
> >
> > ir-keytable -r -t
> 
> Kind of important information, yes. Answer: not sure. I can see it
> receiving something but none of the keys I pressed caused any reaction
> on the application (mythtv)
> 
> # ir-keytable
> Found /sys/class/rc/rc0/ (/dev/input/event5) with:
>         Driver imon, table rc-imon-mce
>         Supported protocols: rc-6
>         Enabled protocols: rc-6
>         Name: iMON Remote (15c2:ffdc)
>         bus: 3, vendor/product: 15c2:ffdc, version: 0x0000
>         Repeat delay = 500 ms, repeat period = 125 ms
> Found /sys/class/rc/rc1/ (/dev/input/event11) with:
>         Driver dvb_usb_cxusb, table rc-dvico-mce
>         Supported protocols: nec
>         Enabled protocols:
>         Name: IR-receiver inside an USB DVB re
>         bus: 3, vendor/product: 0fe9:db78, version: 0x827b
>         Repeat delay = 500 ms, repeat period = 125 ms
> Found /sys/class/rc/rc2/ (/dev/input/event16) with:
>         Driver dvb_usb_af9035, table rc-empty
>         Supported protocols: nec
>         Enabled protocols:
>         Name: Leadtek WinFast DTV Dongle Dual
>         bus: 3, vendor/product: 0413:6a05, version: 0x0200
>         Repeat delay = 500 ms, repeat period = 125 ms
> 
> # ir-keytable -r -t -d /dev/input/event11
> scancode 0xfe01 = KEY_R (0x13)
> scancode 0xfe02 = KEY_TV (0x179)
> scancode 0xfe03 = KEY_0 (0x0b)
> scancode 0xfe05 = KEY_VOLUMEDOWN (0x72)
> scancode 0xfe07 = KEY_4 (0x05)
> scancode 0xfe09 = KEY_CHANNELDOWN (0x193)
> scancode 0xfe0a = KEY_EPG (0x16d)
> scancode 0xfe0b = KEY_1 (0x02)
> scancode 0xfe0d = KEY_ESC (0x01)
> scancode 0xfe0e = KEY_MP3 (0x187)
> scancode 0xfe0f = KEY_PREVIOUSSONG (0xa5)
> scancode 0xfe11 = KEY_CHANNELUP (0x192)
> scancode 0xfe12 = KEY_NEXTSONG (0xa3)
> scancode 0xfe13 = KEY_ANGLE (0x173)
> scancode 0xfe15 = KEY_VOLUMEUP (0x73)
> scancode 0xfe16 = KEY_SETUP (0x8d)
> scancode 0xfe17 = KEY_2 (0x03)
> scancode 0xfe19 = KEY_OPEN (0x86)
> scancode 0xfe1a = KEY_DVD (0x185)
> scancode 0xfe1b = KEY_3 (0x04)
> scancode 0xfe1e = KEY_FAVORITES (0x16c)
> scancode 0xfe1f = KEY_ZOOM (0x174)
> scancode 0xfe42 = KEY_ENTER (0x1c)
> scancode 0xfe43 = KEY_REWIND (0xa8)
> scancode 0xfe46 = KEY_POWER2 (0x164)
> scancode 0xfe47 = KEY_P (0x19)
> scancode 0xfe48 = KEY_7 (0x08)
> scancode 0xfe49 = KEY_ESC (0x01)
> scancode 0xfe4c = KEY_8 (0x09)
> scancode 0xfe4d = KEY_M (0x32)
> scancode 0xfe4e = KEY_POWER (0x74)
> scancode 0xfe4f = KEY_FASTFORWARD (0xd0)
> scancode 0xfe50 = KEY_5 (0x06)
> scancode 0xfe51 = KEY_UP (0x67)
> scancode 0xfe52 = KEY_CAMERA (0xd4)
> scancode 0xfe53 = KEY_DOWN (0x6c)
> scancode 0xfe54 = KEY_6 (0x07)
> scancode 0xfe55 = KEY_TAB (0x0f)
> scancode 0xfe57 = KEY_MUTE (0x71)
> scancode 0xfe58 = KEY_9 (0x0a)
> scancode 0xfe59 = KEY_INFO (0x166)
> scancode 0xfe5a = KEY_TUNER (0x182)
> scancode 0xfe5b = KEY_LEFT (0x69)
> scancode 0xfe5e = KEY_ENTER (0x1c)
> scancode 0xfe5f = KEY_RIGHT (0x6a)

So it's still using the old keymap. I've attached a new one.

> Enabled protocols: other sony nec sanyo mce-kbd rc-6 sharp xmp
> Testing events. Please, press CTRL-C to abort.
>   # pressed '1' key
> 1487676458.742329: event type EV_MSC(0x04): scancode = 0xffff010b
> 1487676458.742329: event type EV_SYN(0x00).
>   # '2'
> 1487676481.742284: event type EV_MSC(0x04): scancode = 0xffff0117
> 1487676481.742284: event type EV_SYN(0x00).
>   # '8'
> 1487676504.842250: event type EV_MSC(0x04): scancode = 0xffff014c
> 1487676504.842250: event type EV_SYN(0x00).
>   # '9'
> 1487676506.542243: event type EV_MSC(0x04): scancode = 0xffff0158
> 1487676506.542243: event type EV_SYN(0x00).
>   # right-arrow
> 1487676551.942312: event type EV_MSC(0x04): scancode = 0xffff015f
> 1487676551.942312: event type EV_SYN(0x00).
>   # vol down
> 1487676637.746348: event type EV_MSC(0x04): scancode = 0xffff0105
> 1487676637.746348: event type EV_SYN(0x00).
>   # vol up
> 1487676642.746321: event type EV_MSC(0x04): scancode = 0xffff0115
> 1487676642.746321: event type EV_SYN(0x00).

Oops, that's a bug. 0xffff should be 0x0000. I've attached a new version of the
patch which should fix that.


Sean

From: Sean Young <sean@mess.org>
Subject: [PATCH] [media] cxusb: dvico remotes are nec

Adjust the keymap to use the correct nec scancodes, and adjust the
rc driver to output the correct nec scancodes.

Now the keymap can be used with any nec receiver, and the rc device
should work with any nec keymap.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/keymaps/rc-dvico-mce.c      | 92 ++++++++++++++--------------
 drivers/media/rc/keymaps/rc-dvico-portable.c | 74 +++++++++++-----------
 drivers/media/usb/dvb-usb/cxusb.c            | 24 ++++----
 3 files changed, 95 insertions(+), 95 deletions(-)

diff --git a/drivers/media/rc/keymaps/rc-dvico-mce.c b/drivers/media/rc/keymaps/rc-dvico-mce.c
index e5f098c..d1e861f 100644
--- a/drivers/media/rc/keymaps/rc-dvico-mce.c
+++ b/drivers/media/rc/keymaps/rc-dvico-mce.c
@@ -12,58 +12,58 @@
 #include <linux/module.h>
 
 static struct rc_map_table rc_map_dvico_mce_table[] = {
-	{ 0xfe02, KEY_TV },
-	{ 0xfe0e, KEY_MP3 },
-	{ 0xfe1a, KEY_DVD },
-	{ 0xfe1e, KEY_FAVORITES },
-	{ 0xfe16, KEY_SETUP },
-	{ 0xfe46, KEY_POWER2 },
-	{ 0xfe0a, KEY_EPG },
-	{ 0xfe49, KEY_BACK },
-	{ 0xfe4d, KEY_MENU },
-	{ 0xfe51, KEY_UP },
-	{ 0xfe5b, KEY_LEFT },
-	{ 0xfe5f, KEY_RIGHT },
-	{ 0xfe53, KEY_DOWN },
-	{ 0xfe5e, KEY_OK },
-	{ 0xfe59, KEY_INFO },
-	{ 0xfe55, KEY_TAB },
-	{ 0xfe0f, KEY_PREVIOUSSONG },/* Replay */
-	{ 0xfe12, KEY_NEXTSONG },	/* Skip */
-	{ 0xfe42, KEY_ENTER	 },	/* Windows/Start */
-	{ 0xfe15, KEY_VOLUMEUP },
-	{ 0xfe05, KEY_VOLUMEDOWN },
-	{ 0xfe11, KEY_CHANNELUP },
-	{ 0xfe09, KEY_CHANNELDOWN },
-	{ 0xfe52, KEY_CAMERA },
-	{ 0xfe5a, KEY_TUNER },	/* Live */
-	{ 0xfe19, KEY_OPEN },
-	{ 0xfe0b, KEY_1 },
-	{ 0xfe17, KEY_2 },
-	{ 0xfe1b, KEY_3 },
-	{ 0xfe07, KEY_4 },
-	{ 0xfe50, KEY_5 },
-	{ 0xfe54, KEY_6 },
-	{ 0xfe48, KEY_7 },
-	{ 0xfe4c, KEY_8 },
-	{ 0xfe58, KEY_9 },
-	{ 0xfe13, KEY_ANGLE },	/* Aspect */
-	{ 0xfe03, KEY_0 },
-	{ 0xfe1f, KEY_ZOOM },
-	{ 0xfe43, KEY_REWIND },
-	{ 0xfe47, KEY_PLAYPAUSE },
-	{ 0xfe4f, KEY_FASTFORWARD },
-	{ 0xfe57, KEY_MUTE },
-	{ 0xfe0d, KEY_STOP },
-	{ 0xfe01, KEY_RECORD },
-	{ 0xfe4e, KEY_POWER },
+	{ 0x0102, KEY_TV },
+	{ 0x010e, KEY_MP3 },
+	{ 0x011a, KEY_DVD },
+	{ 0x011e, KEY_FAVORITES },
+	{ 0x0116, KEY_SETUP },
+	{ 0x0146, KEY_POWER2 },
+	{ 0x010a, KEY_EPG },
+	{ 0x0149, KEY_BACK },
+	{ 0x014d, KEY_MENU },
+	{ 0x0151, KEY_UP },
+	{ 0x015b, KEY_LEFT },
+	{ 0x015f, KEY_RIGHT },
+	{ 0x0153, KEY_DOWN },
+	{ 0x015e, KEY_OK },
+	{ 0x0159, KEY_INFO },
+	{ 0x0155, KEY_TAB },
+	{ 0x010f, KEY_PREVIOUSSONG },/* Replay */
+	{ 0x0112, KEY_NEXTSONG },	/* Skip */
+	{ 0x0142, KEY_ENTER	 },	/* Windows/Start */
+	{ 0x0115, KEY_VOLUMEUP },
+	{ 0x0105, KEY_VOLUMEDOWN },
+	{ 0x0111, KEY_CHANNELUP },
+	{ 0x0109, KEY_CHANNELDOWN },
+	{ 0x0152, KEY_CAMERA },
+	{ 0x015a, KEY_TUNER },	/* Live */
+	{ 0x0119, KEY_OPEN },
+	{ 0x010b, KEY_1 },
+	{ 0x0117, KEY_2 },
+	{ 0x011b, KEY_3 },
+	{ 0x0107, KEY_4 },
+	{ 0x0150, KEY_5 },
+	{ 0x0154, KEY_6 },
+	{ 0x0148, KEY_7 },
+	{ 0x014c, KEY_8 },
+	{ 0x0158, KEY_9 },
+	{ 0x0113, KEY_ANGLE },	/* Aspect */
+	{ 0x0103, KEY_0 },
+	{ 0x011f, KEY_ZOOM },
+	{ 0x0143, KEY_REWIND },
+	{ 0x0147, KEY_PLAYPAUSE },
+	{ 0x014f, KEY_FASTFORWARD },
+	{ 0x0157, KEY_MUTE },
+	{ 0x010d, KEY_STOP },
+	{ 0x0101, KEY_RECORD },
+	{ 0x014e, KEY_POWER },
 };
 
 static struct rc_map_list dvico_mce_map = {
 	.map = {
 		.scan    = rc_map_dvico_mce_table,
 		.size    = ARRAY_SIZE(rc_map_dvico_mce_table),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_NEC,
 		.name    = RC_MAP_DVICO_MCE,
 	}
 };
diff --git a/drivers/media/rc/keymaps/rc-dvico-portable.c b/drivers/media/rc/keymaps/rc-dvico-portable.c
index 94ceeee..ac4cb51 100644
--- a/drivers/media/rc/keymaps/rc-dvico-portable.c
+++ b/drivers/media/rc/keymaps/rc-dvico-portable.c
@@ -12,49 +12,49 @@
 #include <linux/module.h>
 
 static struct rc_map_table rc_map_dvico_portable_table[] = {
-	{ 0xfc02, KEY_SETUP },       /* Profile */
-	{ 0xfc43, KEY_POWER2 },
-	{ 0xfc06, KEY_EPG },
-	{ 0xfc5a, KEY_BACK },
-	{ 0xfc05, KEY_MENU },
-	{ 0xfc47, KEY_INFO },
-	{ 0xfc01, KEY_TAB },
-	{ 0xfc42, KEY_PREVIOUSSONG },/* Replay */
-	{ 0xfc49, KEY_VOLUMEUP },
-	{ 0xfc09, KEY_VOLUMEDOWN },
-	{ 0xfc54, KEY_CHANNELUP },
-	{ 0xfc0b, KEY_CHANNELDOWN },
-	{ 0xfc16, KEY_CAMERA },
-	{ 0xfc40, KEY_TUNER },	/* ATV/DTV */
-	{ 0xfc45, KEY_OPEN },
-	{ 0xfc19, KEY_1 },
-	{ 0xfc18, KEY_2 },
-	{ 0xfc1b, KEY_3 },
-	{ 0xfc1a, KEY_4 },
-	{ 0xfc58, KEY_5 },
-	{ 0xfc59, KEY_6 },
-	{ 0xfc15, KEY_7 },
-	{ 0xfc14, KEY_8 },
-	{ 0xfc17, KEY_9 },
-	{ 0xfc44, KEY_ANGLE },	/* Aspect */
-	{ 0xfc55, KEY_0 },
-	{ 0xfc07, KEY_ZOOM },
-	{ 0xfc0a, KEY_REWIND },
-	{ 0xfc08, KEY_PLAYPAUSE },
-	{ 0xfc4b, KEY_FASTFORWARD },
-	{ 0xfc5b, KEY_MUTE },
-	{ 0xfc04, KEY_STOP },
-	{ 0xfc56, KEY_RECORD },
-	{ 0xfc57, KEY_POWER },
-	{ 0xfc41, KEY_UNKNOWN },    /* INPUT */
-	{ 0xfc00, KEY_UNKNOWN },    /* HD */
+	{ 0x0302, KEY_SETUP },       /* Profile */
+	{ 0x0343, KEY_POWER2 },
+	{ 0x0306, KEY_EPG },
+	{ 0x035a, KEY_BACK },
+	{ 0x0305, KEY_MENU },
+	{ 0x0347, KEY_INFO },
+	{ 0x0301, KEY_TAB },
+	{ 0x0342, KEY_PREVIOUSSONG },/* Replay */
+	{ 0x0349, KEY_VOLUMEUP },
+	{ 0x0309, KEY_VOLUMEDOWN },
+	{ 0x0354, KEY_CHANNELUP },
+	{ 0x030b, KEY_CHANNELDOWN },
+	{ 0x0316, KEY_CAMERA },
+	{ 0x0340, KEY_TUNER },	/* ATV/DTV */
+	{ 0x0345, KEY_OPEN },
+	{ 0x0319, KEY_1 },
+	{ 0x0318, KEY_2 },
+	{ 0x031b, KEY_3 },
+	{ 0x031a, KEY_4 },
+	{ 0x0358, KEY_5 },
+	{ 0x0359, KEY_6 },
+	{ 0x0315, KEY_7 },
+	{ 0x0314, KEY_8 },
+	{ 0x0317, KEY_9 },
+	{ 0x0344, KEY_ANGLE },	/* Aspect */
+	{ 0x0355, KEY_0 },
+	{ 0x0307, KEY_ZOOM },
+	{ 0x030a, KEY_REWIND },
+	{ 0x0308, KEY_PLAYPAUSE },
+	{ 0x034b, KEY_FASTFORWARD },
+	{ 0x035b, KEY_MUTE },
+	{ 0x0304, KEY_STOP },
+	{ 0x0356, KEY_RECORD },
+	{ 0x0357, KEY_POWER },
+	{ 0x0341, KEY_UNKNOWN },    /* INPUT */
+	{ 0x0300, KEY_UNKNOWN },    /* HD */
 };
 
 static struct rc_map_list dvico_portable_map = {
 	.map = {
 		.scan    = rc_map_dvico_portable_table,
 		.size    = ARRAY_SIZE(rc_map_dvico_portable_table),
-		.rc_type = RC_TYPE_UNKNOWN,	/* Legacy IR type */
+		.rc_type = RC_TYPE_NEC,
 		.name    = RC_MAP_DVICO_PORTABLE,
 	}
 };
diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 5d7b4ea..d4a80fc 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -457,8 +457,8 @@ static int cxusb_rc_query(struct dvb_usb_device *d)
 	cxusb_ctrl_msg(d, CMD_GET_IR_CODE, NULL, 0, ircode, 4);
 
 	if (ircode[2] || ircode[3])
-		rc_keydown(d->rc_dev, RC_TYPE_UNKNOWN,
-			   RC_SCANCODE_RC5(ircode[2], ircode[3]), 0);
+		rc_keydown(d->rc_dev, RC_TYPE_NEC,
+			   RC_SCANCODE_NEC(~ircode[2] & 0xff, ircode[3]), 0);
 	return 0;
 }
 
@@ -472,8 +472,8 @@ static int cxusb_bluebird2_rc_query(struct dvb_usb_device *d)
 		return 0;
 
 	if (ircode[1] || ircode[2])
-		rc_keydown(d->rc_dev, RC_TYPE_UNKNOWN,
-			   RC_SCANCODE_RC5(ircode[1], ircode[2]), 0);
+		rc_keydown(d->rc_dev, RC_TYPE_NEC,
+			   RC_SCANCODE_NEC(~ircode[1] & 0xff, ircode[2]), 0);
 	return 0;
 }
 
@@ -1562,7 +1562,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_lgh064f_properties = {
 		.rc_codes	= RC_MAP_DVICO_PORTABLE,
 		.module_name	= KBUILD_MODNAME,
 		.rc_query	= cxusb_rc_query,
-		.allowed_protos = RC_BIT_UNKNOWN,
+		.allowed_protos = RC_BIT_NEC,
 	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -1619,7 +1619,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_dee1601_properties = {
 		.rc_codes	= RC_MAP_DVICO_MCE,
 		.module_name	= KBUILD_MODNAME,
 		.rc_query	= cxusb_rc_query,
-		.allowed_protos = RC_BIT_UNKNOWN,
+		.allowed_protos = RC_BIT_NEC,
 	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -1684,7 +1684,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_lgz201_properties = {
 		.rc_codes	= RC_MAP_DVICO_PORTABLE,
 		.module_name	= KBUILD_MODNAME,
 		.rc_query	= cxusb_rc_query,
-		.allowed_protos = RC_BIT_UNKNOWN,
+		.allowed_protos = RC_BIT_NEC,
 	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -1740,7 +1740,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_dtt7579_properties = {
 		.rc_codes	= RC_MAP_DVICO_PORTABLE,
 		.module_name	= KBUILD_MODNAME,
 		.rc_query	= cxusb_rc_query,
-		.allowed_protos = RC_BIT_UNKNOWN,
+		.allowed_protos = RC_BIT_NEC,
 	},
 
 	.generic_bulk_ctrl_endpoint = 0x01,
@@ -1795,7 +1795,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_dualdig4_properties = {
 		.rc_codes	= RC_MAP_DVICO_MCE,
 		.module_name	= KBUILD_MODNAME,
 		.rc_query	= cxusb_bluebird2_rc_query,
-		.allowed_protos = RC_BIT_UNKNOWN,
+		.allowed_protos = RC_BIT_NEC,
 	},
 
 	.num_device_descs = 1,
@@ -1849,7 +1849,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_nano2_properties = {
 		.rc_codes	= RC_MAP_DVICO_PORTABLE,
 		.module_name	= KBUILD_MODNAME,
 		.rc_query       = cxusb_bluebird2_rc_query,
-		.allowed_protos = RC_BIT_UNKNOWN,
+		.allowed_protos = RC_BIT_NEC,
 	},
 
 	.num_device_descs = 1,
@@ -1905,7 +1905,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_nano2_needsfirmware_prope
 		.rc_codes	= RC_MAP_DVICO_PORTABLE,
 		.module_name	= KBUILD_MODNAME,
 		.rc_query	= cxusb_rc_query,
-		.allowed_protos = RC_BIT_UNKNOWN,
+		.allowed_protos = RC_BIT_NEC,
 	},
 
 	.num_device_descs = 1,
@@ -2004,7 +2004,7 @@ struct dvb_usb_device_properties cxusb_bluebird_dualdig4_rev2_properties = {
 		.rc_codes	= RC_MAP_DVICO_MCE,
 		.module_name	= KBUILD_MODNAME,
 		.rc_query	= cxusb_rc_query,
-		.allowed_protos = RC_BIT_UNKNOWN,
+		.allowed_protos = RC_BIT_NEC,
 	},
 
 	.num_device_descs = 1,
-- 
2.9.3


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dvico_mce

# table dvico_mce, type: NEC
0x0102 KEY_TV
0x010e KEY_MP3
0x011a KEY_DVD
0x011e KEY_FAVORITES
0x0116 KEY_SETUP
0x0146 KEY_POWER2
0x010a KEY_EPG
0x0149 KEY_BACK
0x014d KEY_MENU
0x0151 KEY_UP
0x015b KEY_LEFT
0x015f KEY_RIGHT
0x0153 KEY_DOWN
0x015e KEY_OK
0x0159 KEY_INFO
0x0155 KEY_TAB
0x010f KEY_PREVIOUSSONG
0x0112 KEY_NEXTSONG
0x0142 KEY_ENTER
0x0115 KEY_VOLUMEUP
0x0105 KEY_VOLUMEDOWN
0x0111 KEY_CHANNELUP
0x0109 KEY_CHANNELDOWN
0x0152 KEY_CAMERA
0x015a KEY_TUNER
0x0119 KEY_OPEN
0x010b KEY_1
0x0117 KEY_2
0x011b KEY_3
0x0107 KEY_4
0x0150 KEY_5
0x0154 KEY_6
0x0148 KEY_7
0x014c KEY_8
0x0158 KEY_9
0x0113 KEY_ANGLE
0x0103 KEY_0
0x011f KEY_ZOOM
0x0143 KEY_REWIND
0x0147 KEY_PLAYPAUSE
0x014f KEY_FASTFORWARD
0x0157 KEY_MUTE
0x010d KEY_STOP
0x0101 KEY_RECORD
0x014e KEY_POWER

--9amGYk9869ThD9tj--
