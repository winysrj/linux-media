Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hs-out-0708.google.com ([64.233.178.247])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <filippo.argiolas@gmail.com>) id 1JRUqP-0006ps-Gz
	for linux-dvb@linuxtv.org; Tue, 19 Feb 2008 16:57:21 +0100
Received: by hs-out-0708.google.com with SMTP id 54so1785402hsz.1
	for <linux-dvb@linuxtv.org>; Tue, 19 Feb 2008 07:57:16 -0800 (PST)
From: Filippo Argiolas <filippo.argiolas@gmail.com>
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="=-rl0btrJc+vM1SLwacwr5"
Date: Tue, 19 Feb 2008 16:17:55 +0100
Message-Id: <1203434275.6870.25.camel@tux>
Mime-Version: 1.0
Subject: [linux-dvb] [patch] support for key repeat with dib0700 ir receiver
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


--=-rl0btrJc+vM1SLwacwr5
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi, my last messages have been almost ignored.. so I'm opening a new
thread. Please refer to the other thread [wintv nova-t stick, dib0700
and remote controllers] for more info. 

Here is a brief summary of the problem as far as I can understand:
- when a keypress event is received the device stores its data somewhere
- every 150ms dib0700_rc_query reads this data 
- since there is nothing that resets device memory if no key is being
pressed anymore device still stores the data from the last keypress
event
- to prevent having false keypresses the driver reads rc5 toggle bit
that changes from 0 to 1 and viceversa when a new key is pressed or when
the same key is released and pressed again. So it ignores everything
until the toggle bit changes. The right behavior should be "repeat last
key until toggle bit changes", but cannot be done since last data still
stored would be considered as a repeat even if nothing is pressed.
- this way it ignores even repeated key events (when a key is holded
down)
- this approach is wrong because it works just for rc5 (losing repeat
feature..) but doesn't work for example with nec remotes that don't set
the toggle bit and use a different system. 

The patch solves it calling dib0700_rc_setup after each poll resetting
last key data from the device. I've also implemented repeated key
feature (with repeat delay to avoid unwanted double hits) for rc-5 and
nec protocols. It also contains some keymap for the remotes I've used
for testing (a philipps compatible rc5 remote and a teac nec remote).
They are far from being complete since I've used them just for testing.

Thanks for reading this,
Let me know what do you think about it,
Greets,

Filippo

--=-rl0btrJc+vM1SLwacwr5
Content-Disposition: attachment; filename=remote-repeat.diff
Content-Type: text/x-patch; name=remote-repeat.diff; charset=utf-8
Content-Transfer-Encoding: 7bit

diff -r f89d5927677a linux/drivers/media/dvb/dvb-usb/dib0700.h
--- a/linux/drivers/media/dvb/dvb-usb/dib0700.h	Mon Feb 18 13:03:16 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700.h	Tue Feb 19 16:17:05 2008 +0100
@@ -37,6 +37,7 @@ struct dib0700_state {
 	u8 channel_state;
 	u16 mt2060_if1[2];
 	u8 rc_toggle;
+	u8 rc_counter;
 	u8 is_dib7000pc;
 };
 
@@ -44,12 +45,15 @@ extern int dib0700_ctrl_clock(struct dvb
 extern int dib0700_ctrl_clock(struct dvb_usb_device *d, u32 clk_MHz, u8 clock_out_gp3);
 extern int dib0700_ctrl_rd(struct dvb_usb_device *d, u8 *tx, u8 txlen, u8 *rx, u8 rxlen);
 extern int dib0700_download_firmware(struct usb_device *udev, const struct firmware *fw);
+extern int dib0700_rc_setup(struct dvb_usb_device *d);
 extern int dib0700_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff);
 extern struct i2c_algorithm dib0700_i2c_algo;
 extern int dib0700_identify_state(struct usb_device *udev, struct dvb_usb_device_properties *props,
 			struct dvb_usb_device_description **desc, int *cold);
 
 extern int dib0700_device_count;
+extern int dvb_usb_dib0700_ir_proto;
 extern struct dvb_usb_device_properties dib0700_devices[];
 extern struct usb_device_id dib0700_usb_id_table[];
+
 #endif
diff -r f89d5927677a linux/drivers/media/dvb/dvb-usb/dib0700_core.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_core.c	Mon Feb 18 13:03:16 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_core.c	Tue Feb 19 16:17:05 2008 +0100
@@ -13,7 +13,7 @@ module_param_named(debug,dvb_usb_dib0700
 module_param_named(debug,dvb_usb_dib0700_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level (1=info,2=fw,4=fwdata,8=data (or-able))." DVB_USB_DEBUG_STATUS);
 
-static int dvb_usb_dib0700_ir_proto = 1;
+int dvb_usb_dib0700_ir_proto = 1;
 module_param(dvb_usb_dib0700_ir_proto, int, 0644);
 MODULE_PARM_DESC(dvb_usb_dib0700_ir_proto, "set ir protocol (0=NEC, 1=RC5 (default), 2=RC6).");
 
@@ -261,7 +261,7 @@ int dib0700_streaming_ctrl(struct dvb_us
 	return dib0700_ctrl_wr(adap->dev, b, 4);
 }
 
-static int dib0700_rc_setup(struct dvb_usb_device *d)
+int dib0700_rc_setup(struct dvb_usb_device *d)
 {
 	u8 rc_setup[3] = {REQUEST_SET_RC, dvb_usb_dib0700_ir_proto, 0};
 	int i = dib0700_ctrl_wr(d, rc_setup, 3);
diff -r f89d5927677a linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Mon Feb 18 13:03:16 2008 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Tue Feb 19 16:17:05 2008 +0100
@@ -301,6 +301,9 @@ static int stk7700d_tuner_attach(struct 
 
 static u8 rc_request[] = { REQUEST_POLL_RC, 0 };
 
+/* Number of keypresses to ignore before start repeating */
+#define RC_REPEAT_DELAY 2
+
 static int dib0700_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
 	u8 key[4];
@@ -314,22 +317,116 @@ static int dib0700_rc_query(struct dvb_u
 		err("RC Query Failed");
 		return -1;
 	}
+
+	/* losing half of KEY_0 events from Philipps rc5 remotes.. */
 	if (key[0]==0 && key[1]==0 && key[2]==0 && key[3]==0) return 0;
-	if (key[3-1]!=st->rc_toggle) {
+	
+	/* info("%d: %2X %2X %2X %2X",dvb_usb_dib0700_ir_proto,(int)key[3-2],(int)key[3-3],(int)key[3-1],(int)key[3]);  */
+
+	dib0700_rc_setup(d); /* reset ir sensor data to prevent false events */
+	
+	switch (dvb_usb_dib0700_ir_proto) {
+	case 0: {
+		/* NEC protocol sends repeat code as 0 0 0 FF */
+		if ((key[3-2] == 0x00) && (key[3-3] == 0x00) &&
+		    (key[3] == 0xFF)) {
+			st->rc_counter++; 
+			if(st->rc_counter > RC_REPEAT_DELAY) {
+				*event = d->last_event;
+				*state = REMOTE_KEY_PRESSED;
+				st->rc_counter = RC_REPEAT_DELAY;
+			} 
+			return 0;
+		}
 		for (i=0;i<d->props.rc_key_map_size; i++) {
 			if (keymap[i].custom == key[3-2] && keymap[i].data == key[3-3]) {
+				st->rc_counter = 0;
 				*event = keymap[i].event;
 				*state = REMOTE_KEY_PRESSED;
-				st->rc_toggle=key[3-1];
+				d->last_event = keymap[i].event;
 				return 0;
 			}
 		}
-		err("Unknown remote controller key : %2X %2X",(int)key[3-2],(int)key[3-3]);
-	}
+		break;
+	}
+	default: {
+		/* RC-5 protocol changes toggle bit on new keypress */
+		for (i=0;i<d->props.rc_key_map_size; i++) {
+			if (keymap[i].custom == key[3-2] && keymap[i].data == key[3-3]) {
+				if((d->last_event == keymap[i].event) &&
+				   (key[3-1] == st->rc_toggle)) {
+					st->rc_counter++;
+					/* prevents unwanted double hits */
+					if(st->rc_counter > RC_REPEAT_DELAY) { 
+						*event = d->last_event;
+						*state = REMOTE_KEY_PRESSED;
+						st->rc_counter = RC_REPEAT_DELAY;
+					}
+					
+					return 0;
+				}
+				st->rc_counter = 0;
+				*event = keymap[i].event;
+				*state = REMOTE_KEY_PRESSED;
+				st->rc_toggle = key[3-1];
+				d->last_event = keymap[i].event;
+				return 0;
+			}
+		}
+		break;
+	}
+	} 
+	err("Unknown remote controller key: %2X %2X %2X %2X",(int)key[3-2],(int)key[3-3], (int)key[3-1],(int)key[3]);
+	d->last_event = 0;
 	return 0;
 }
 
 static struct dvb_usb_rc_key dib0700_rc_keys[] = {
+	/* CME/Philipps RC-5 Universal */
+	/* Most are not philipps standard codes because I have a
+	 * remote with a replaceable paper sheet with key symbols so
+	 * I've created one with the keys I needed */
+	{ 0x0, 0x00, KEY_0 },
+	{ 0x0, 0x01, KEY_1 },
+	{ 0x0, 0x11, KEY_VOLUMEDOWN },
+	{ 0x0, 0x10, KEY_VOLUMEUP },
+	{ 0x0, 0x0D, KEY_MUTE },
+	{ 0x0, 0x20, KEY_CHANNELUP },
+	{ 0x0, 0x21, KEY_CHANNELDOWN },
+	{ 0x0, 0x0C, KEY_POWER },
+	{ 0x0, 0x57, KEY_OK },
+	{ 0x0, 0x55, KEY_LEFT },
+	{ 0x0, 0x56, KEY_RIGHT },
+	{ 0x0, 0x51, KEY_DOWN },
+	{ 0x0, 0x50, KEY_UP },
+	{ 0x0, 0x52, KEY_MENU },
+	{ 0x03, 0x0A, KEY_HOME },
+	{ 0x0, 0x3C, KEY_EPG },
+	{ 0x03, 0x4A, KEY_PLAYPAUSE },
+	{ 0x0, 0x23, KEY_STOP },
+	{ 0x0, 0x26, KEY_FORWARD },
+	{ 0x0, 0x2D, KEY_REWIND },
+
+	/* TEAC RC-882 NEC PROTOCOL (not complete, just for test purpose) */
+	
+	{ 0x72, 0x54, KEY_VOLUMEDOWN },
+	{ 0x72, 0x17, KEY_VOLUMEUP },
+	{ 0x72, 0x55, KEY_MUTE },
+	{ 0x72, 0x10, KEY_STOP },
+	{ 0x72, 0x11, KEY_PLAYPAUSE },
+	{ 0x72, 0x53, KEY_OK },
+	{ 0x72, 0x15, KEY_DOWN },
+	{ 0x72, 0x52, KEY_UP },
+	{ 0x72, 0x51, KEY_LEFT },
+	{ 0x72, 0x13, KEY_RIGHT },
+	{ 0x72, 0x12, KEY_MENU },
+	{ 0x72, 0x41, KEY_POWER },
+	{ 0x72, 0x42, KEY_1 },
+	{ 0x72, 0x03, KEY_2 },
+	{ 0x72, 0x02, KEY_3 },
+	{ 0x72, 0x01, KEY_4 },
+	{ 0x72, 0x40, KEY_5 },
+     
 	/* Key codes for the tiny Pinnacle remote*/
 	{ 0x07, 0x00, KEY_MUTE },
 	{ 0x07, 0x01, KEY_MENU }, // Pinnacle logo

--=-rl0btrJc+vM1SLwacwr5
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-rl0btrJc+vM1SLwacwr5--
