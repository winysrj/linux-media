Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate04.web.de ([217.72.192.242])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <okleinecke@web.de>) id 1KjGyZ-0002U3-Gq
	for linux-dvb@linuxtv.org; Fri, 26 Sep 2008 19:19:32 +0200
Received: from web.de
	by fmmailgate04.web.de (Postfix) with SMTP id 3E25B5EAE3DD
	for <linux-dvb@linuxtv.org>; Fri, 26 Sep 2008 19:18:58 +0200 (CEST)
Date: Fri, 26 Sep 2008 19:18:58 +0200
Message-Id: <1959297291@web.de>
MIME-Version: 1.0
From: Oliver Kleinecke <okleinecke@web.de>
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed;
 boundary="=-------------12224495382628023785"
Subject: [linux-dvb] Need help getting the remote of a Nova-T USB-Stick to
	work
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--=-------------12224495382628023785
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit

Hi all !

I just got my iBook G4 running on Debian Etch 4.0 (PPC Archtitecture!!)

Everything works fine, now im trying to get my Nova-T USB-Stick Remote to work.

I compiled the latest stable v4l-dvb-drivers, everything worked fine, and i`m able to watch tv with kaffeine and mythtv already.
Now i would like to get the remote to work .. the ir-receiver shows up during boot, giving the following ouput :

"kernel: input: IR-receiver inside an USB DVB receiver as /class/input/input7".

If i do a lsinput, the device shows up like this :

/dev/input/event7
   bustype : BUS_USB
   vendor  : 0x2040
   product : 0x7070
   version : 256
   name    : "IR-receiver inside an USB DVB re"
   phys    : "usb-0001:10:1b.2-1/ir0"
   bits ev : EV_SYN EV_KEY


so i`m pretty sure i am not toooo far away from the solution.

but if i press a button on the rc, it just gives me kernel messages like this :

"kernel: dib0700: Unknown remote controller key: 1D  2  0  0"


After a bit of googling, i found out, that there seems to be a solution, using a diff file, which i downloaded already, its attached to this mail.

Now i need a bit of support in using this diff-file correctly, and some infos on how to continue then..

Any help is very appreciated :)

Thx in advance, Oliver








_________________________________________________________________________
In 5 Schritten zur eigenen Homepage. Jetzt Domain sichern und gestalten! 
Nur 3,99 EUR/Monat! http://www.maildomain.web.de/?mc=021114


--=-------------12224495382628023785
Content-Type: text/x-diff;
 name="attachment.diff"
Content-Disposition: attachment;
 filename="attachment.diff"
Content-Transfer-Encoding: 7bit

--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	2008-06-15 17:12:38.000000000 +0200
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	2008-06-08 18:33:22.000000000 +0200
@@ -601,7 +601,42 @@
 	{ 0xeb, 0x54, KEY_PREVIOUS },
 	{ 0xeb, 0x58, KEY_RECORD },
 	{ 0xeb, 0x5c, KEY_NEXT },
-
+	/* Key codes for the Haupauge NOVA USB-Stick */
+	{ 0x1d, 0x1f, KEY_BACK },
+	{ 0x1d, 0x14, KEY_UP },
+	{ 0x1d, 0x1c, KEY_RADIO },
+	{ 0x1d, 0x3b, KEY_HOME },
+	{ 0x1d, 0x3D, KEY_POWER },
+	{ 0x1d, 0x16, KEY_LEFT },
+	{ 0x1d, 0x25, KEY_OK },
+	{ 0x1d, 0x17, KEY_RIGHT },
+	{ 0x1d, 0x24, KEY_PREVIOUS },
+	{ 0x1d, 0x1E, KEY_NEXT },
+	{ 0x1d, 0x37, KEY_RECORD },
+	{ 0x1d, 0x15, KEY_DOWN },
+	{ 0x1d, 0x36, KEY_STOP },
+	{ 0x1d, 0x30, KEY_PAUSE },
+	{ 0x1d, 0x35, KEY_PLAY },
+	{ 0x1d, 0x00, KEY_0 },
+	{ 0x1d, 0x01, KEY_1 },
+	{ 0x1d, 0x02, KEY_2 },
+	{ 0x1d, 0x03, KEY_3 },
+	{ 0x1d, 0x04, KEY_4 },
+	{ 0x1d, 0x05, KEY_5 },
+	{ 0x1d, 0x06, KEY_6 },
+	{ 0x1d, 0x07, KEY_7 },
+	{ 0x1d, 0x08, KEY_8 },
+	{ 0x1d, 0x09, KEY_9 },
+	{ 0x1d, 0x32, KEY_REWIND },
+	{ 0x1d, 0x34, KEY_FASTFORWARD },
+	{ 0x1d, 0x20, KEY_CHANNELUP },
+	{ 0x1d, 0x21, KEY_CHANNELDOWN },
+	{ 0x1d, 0x10, KEY_VOLUMEUP },
+	{ 0x1d, 0x11, KEY_VOLUMEDOWN },
+	{ 0x1d, 0x0A, KEY_TEXT },
+	{ 0x1d, 0x0D, KEY_MENU },
+	{ 0x1d, 0x12, KEY_CHANNEL },
+	{ 0x1d, 0x0F, KEY_MUTE },
 	/* Key codes for the Haupauge WinTV Nova-TD, copied from nova-t-usb2.c (Nova-T USB2) */
 	{ 0x1e, 0x00, KEY_0 },
 	{ 0x1e, 0x01, KEY_1 },

--=-------------12224495382628023785
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-------------12224495382628023785--
