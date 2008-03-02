Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.236])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <filippo.argiolas@gmail.com>) id 1JVu7d-0003h5-3r
	for linux-dvb@linuxtv.org; Sun, 02 Mar 2008 20:45:21 +0100
Received: by wx-out-0506.google.com with SMTP id s11so5720494wxc.17
	for <linux-dvb@linuxtv.org>; Sun, 02 Mar 2008 11:45:16 -0800 (PST)
From: Filippo Argiolas <filippo.argiolas@gmail.com>
To: Filippo Argiolas <filippo.argiolas@gmail.com>
In-Reply-To: <1203499665.7026.66.camel@tux>
References: <1203434275.6870.25.camel@tux>
	<Pine.LNX.4.64.0802192208010.13027@pub6.ifh.de>
	<1203499665.7026.66.camel@tux>
Content-Type: multipart/mixed; boundary="=-Q4qA4ihKhGSsTeJOhxNy"
Date: Sun, 02 Mar 2008 20:45:25 +0100
Message-Id: <1204487125.6799.16.camel@tux>
Mime-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [patch] support for key repeat with dib0700
	ir	receiver
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


--=-Q4qA4ihKhGSsTeJOhxNy
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


Il giorno mer, 20/02/2008 alle 10.29 +0100, Filippo Argiolas ha scritto:

> I don't know yet how this could be done and maybe it involves some work
> rewriting the ir stuff. So I think in the meanwhile my patch could be
> merged (if you think it's good) waiting for this work to be done.

Hi all,
it's been a while since I've posted this patch. Looking at the whole
thread the overall impression is that it works properly. No one
complained about it causing any trouble. Many users tested it and
reported it works good. I've been using it during this time and it seems
fine to me. It also fixed the annoying bug that flooded syslog with
unknown key messages.
So what does it need to be merged? Is a post in this list the proper way
to ask for inclusion? I'm not familiar to mercurial so I've created the
patch as I would do with a svn with "hg diff", it something wrong with
it? Is there a better way to produce a patch for submission?
I've attached a new patch where I've removed the keymaps I've used for
testing since these are not complete and I doubt anyone could find them
useful.
Please let me know what you think about it, thanks!
Best regards,

Filippo


--=-Q4qA4ihKhGSsTeJOhxNy
Content-Disposition: attachment; filename=remote-repeat.diff
Content-Type: text/x-patch; name=remote-repeat.diff; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r 127f67dea087 linux/drivers/media/dvb/dvb-usb/dib0700.h
--- a/linux/drivers/media/dvb/dvb-usb/dib0700.h	Tue Feb 26 20:43:56 2008 +0000
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700.h	Sun Mar 02 20:30:41 2008 +0100
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
diff -r 127f67dea087 linux/drivers/media/dvb/dvb-usb/dib0700_core.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_core.c	Tue Feb 26 20:43:56 2008 +0000
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_core.c	Sun Mar 02 20:30:41 2008 +0100
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
diff -r 127f67dea087 linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Tue Feb 26 20:43:56 2008 +0000
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Sun Mar 02 20:30:41 2008 +0100
@@ -301,6 +301,9 @@ static int stk7700d_tuner_attach(struct 
 
 static u8 rc_request[] = { REQUEST_POLL_RC, 0 };
 
+/* Number of keypresses to ignore before start repeating */
+#define RC_REPEAT_DELAY 2
+
 static int dib0700_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
 	u8 key[4];
@@ -314,18 +317,67 @@ static int dib0700_rc_query(struct dvb_u
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
 

--=-Q4qA4ihKhGSsTeJOhxNy
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--=-Q4qA4ihKhGSsTeJOhxNy--
