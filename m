Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1-g19.free.fr ([212.27.42.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thierry.merle@free.fr>) id 1KA4MP-0007xe-Nj
	for linux-dvb@linuxtv.org; Sat, 21 Jun 2008 16:46:40 +0200
Message-ID: <485D146C.7090606@free.fr>
Date: Sat, 21 Jun 2008 16:47:08 +0200
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Tomi Orava <tomimo@ncircle.nullnet.fi>
References: <472A0CC2.8040509@free.fr>
	<480F9062.6000700@free.fr>	<16781.192.100.124.220.1209712634.squirrel@ncircle.nullnet.fi>	<481B4A78.8090305@free.fr>	<30354.192.100.124.220.1209969477.squirrel@ncircle.nullnet.fi>	<481F66B0.4090302@free.fr>
	<4821F9A9.6030304@ncircle.nullnet.fi>	<48236E1F.5080300@free.fr>	<60450.192.168.9.10.1210618180.squirrel@ncircle.nullnet.fi>	<Pine.LNX.4.64.0805122100590.7907@pub3.ifh.de>
	<20080616152430.GA9995@dose.home.local> <485C0886.5070606@free.fr>
	<485C1E73.7030509@ncircle.nullnet.fi>
	<485C2C48.7090809@free.fr> <485C34B9.40407@ncircle.nullnet.fi>
In-Reply-To: <485C34B9.40407@ncircle.nullnet.fi>
Cc: Tino Keitel <tino.keitel@tikei.de>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Testers wanted for alternative version of	Terratec
 Cinergy T2 driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Tomi Orava a ecrit :
> Hi,
> 
>>>> - possible lirc issue
>>>>     http://article.gmane.org/gmane.linux.drivers.dvb/37865
>>>>    But I am not sure this is a problem, just a lack in lirc conf.
>>> Since that time the "internal" remote control code has been removed
>>> and the driver now uses the common dvb-usb-rc code.
>>> This should not be a problem anymore, but needs to be verified.
>>>
>> In fact irrecord expects key repeat functionality that is disabled in
>> this driver (key repeat is too rapid)
>> Nevertheless I succeeded in making lircd work thanks to:
>> http://linux.bytesex.org/v4l2/faq.html#lircd (see the last item)
> 
> So, does it work for you for good if you change the rc_interval from 50ms
> into 150ms (ie. DEFAULT_RC_INTERVAL) on line 183 of cinergyT2-core.c ?
> 
> Regards,
> Tomi Orava
> 
In fact key repeat feature needed to be implemented.
I did it with a configurable RC_REPEAT_DELAY defined as 3 queries period so 3*DEFAULT_RC_INTERVAL.
Putting DEFAULT_RC_INTERVAL to 150 causes the driver to miss some remote commands.

The patch is here: http://linuxtv.org/hg/~tmerle/cinergyT2
and inlined in this email.

Regards,
Thierry
--
cinergyT2: add remote key repeat feature

From: Thierry MERLE <thierry.merle@free.fr>

Implement key repeat feature for the cinergyT2 remote controller.

Signed-off-by: Thierry MERLE <thierry.merle@free.fr>

diff -r afe409705dd5 -r 65bedec7f7ab linux/drivers/media/dvb/dvb-usb/cinergyT2-core.c
--- a/linux/drivers/media/dvb/dvb-usb/cinergyT2-core.c	Fri Jun 20 21:26:40 2008 +0200
+++ b/linux/drivers/media/dvb/dvb-usb/cinergyT2-core.c	Sat Jun 21 16:38:01 2008 +0200
@@ -40,6 +40,9 @@
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
+struct cinergyt2_state {
+	u8 rc_counter;
+};
 
 /* We are missing a release hook with usb_device data */
 struct dvb_usb_device *cinergyt2_usb_device;
@@ -122,22 +125,57 @@
 	{ 0x04,	0x5c,	KEY_NEXT }
 };
 
+/* Number of keypresses to ignore before detect repeating */
+#define RC_REPEAT_DELAY 3
+
+static int repeatable_keys[] = {
+	KEY_UP,
+	KEY_DOWN,
+	KEY_LEFT,
+	KEY_RIGHT,
+	KEY_VOLUMEUP,
+	KEY_VOLUMEDOWN,
+	KEY_CHANNELUP,
+	KEY_CHANNELDOWN
+};
+
 static int cinergyt2_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
+	struct cinergyt2_state *st = d->priv;
 	u8 key[5] = {0, 0, 0, 0, 0}, cmd = CINERGYT2_EP1_GET_RC_EVENTS;
+	int i;
+
 	*state = REMOTE_NO_KEY_PRESSED;
 
 	dvb_usb_generic_rw(d, &cmd, 1, key, sizeof(key), 0);
-	if (key[4] == 0xff)
+	if (key[4] == 0xff) {
+		/* key repeat */
+		st->rc_counter++;
+		if (st->rc_counter > RC_REPEAT_DELAY) {
+			for (i = 0; i < ARRAY_SIZE(repeatable_keys); i++) {
+				if (d->last_event == repeatable_keys[i]) {
+					*state = REMOTE_KEY_REPEAT;
+					*event = d->last_event;
+					deb_rc("repeat key, event %x\n",
+						   *event);
+					return 0;
+				}
+			}
+			deb_rc("repeated key (non repeatable)\n");
+		}
 		return 0;
+	}
 
-	/* hack to pass checksum on the custom field (is set to 0xeb) */
-	key[2] = ~0x04;
+	/* hack to pass checksum on the custom field */
+	key[2] = ~key[1];
 	dvb_usb_nec_rc_key_to_event(d, key, event, state);
-	if (key[0] != 0)
-		deb_info("key: %x %x %x %x %x\n",
-			 key[0], key[1], key[2], key[3], key[4]);
+	if (key[0] != 0) {
+		if (*event != d->last_event)
+			st->rc_counter = 0;
 
+		deb_rc("key: %x %x %x %x %x\n",
+		       key[0], key[1], key[2], key[3], key[4]);
+	}
 	return 0;
 }
 
@@ -157,7 +195,7 @@
 MODULE_DEVICE_TABLE(usb, cinergyt2_usb_table);
 
 static struct dvb_usb_device_properties cinergyt2_properties = {
-
+	.size_of_priv = sizeof(struct cinergyt2_state),
 	.num_adapters = 1,
 	.adapter = {
 		{

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
