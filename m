Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <stefan.gehrer@gmx.de>) id 1KvIsu-0007IU-V9
	for linux-dvb@linuxtv.org; Wed, 29 Oct 2008 22:47:26 +0100
Message-ID: <4908D9CA.2040201@gmx.de>
Date: Wed, 29 Oct 2008 22:46:50 +0100
From: Stefan Gehrer <stefan.gehrer@gmx.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <4908ADFD.6040502@gmx.de>
In-Reply-To: <4908ADFD.6040502@gmx.de>
Content-Type: multipart/mixed; boundary="------------030805090109080004060801"
Subject: Re: [linux-dvb] [PATCH] Key map for new remote control that came
 with Terratec Cinergy T USB XXS
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
--------------030805090109080004060801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

I tried coming up with a patch, and the best way seemed to be to
seperate the Cinergy T USB XXS into a new device description
with its own RC keymap.
Any comments on this?

Best regards
Stefan Gehrer

Stefan Gehrer wrote:
> Hi all,
> 
> I recently bought a Terratec Cinergy T USB XXS device
> and found that the remote control doesn't work correctly
> with kernel 2.7.27, so I had to make the below key table
> to get it to work.
> In function dib0700_rc_query() in file dib0700_devices.c,
> I then activate this keymap with
> 
>      if(dvb_usb_dib0700_ir_proto == 1)
>          keymap = xxs_new_rc_keys;
> 
> Something like this is necessary as otherwise key codes
> overlap with the key table already in the driver.
> But if other remotes also have dvb_usb_dib0700_ir_proto
> equal to one this is obviously a problem.
> Please advise me if you need any further information
> for getting support for that remote into the driver.
> 
> And one small problem my approach currently has:
> I see neither key repeats nor a key release, so there
> is no way to register long presses. So maybe some more
> changes are required for proper support.
> 
> Best regards
> Stefan Gehrer

--------------030805090109080004060801
Content-Type: text/plain;
 name="xxs_remote.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xxs_remote.diff"

--- dib0700_devices.c~	2008-10-29 22:35:20.000000000 +0100
+++ dib0700_devices.c	2008-10-29 22:42:33.000000000 +0100
@@ -720,6 +720,56 @@
 	{ 0x1d, 0x3d, KEY_POWER },
 };
 
+/* Key codes for Cinergy T USB XXS remote control */
+static struct dvb_usb_rc_key cinergy_xxs_rc_keys[] = {
+	{ 0x0f, 0x7e, KEY_POWER },
+	{ 0x07, 0x7c, KEY_1 },
+	{ 0x08, 0x40, KEY_2 },
+	{ 0x03, 0x7d, KEY_3 },
+	{ 0x0c, 0x41, KEY_4 },
+	{ 0x04, 0x43, KEY_5 },
+	{ 0x0b, 0x7f, KEY_6 },
+	{ 0x01, 0x7d, KEY_7 },
+	{ 0x0e, 0x41, KEY_8 },
+	{ 0x06, 0x43, KEY_9 },
+	{ 0x02, 0x42, KEY_0 },
+	{ 0x0f, 0x71, KEY_HOME },
+	{ 0x07, 0x73, KEY_MENU }, /* DVD Menu */
+	{ 0x08, 0x4f, KEY_SUBTITLE },
+	{ 0x03, 0x72, KEY_TEXT }, /* Teletext */
+	{ 0x0c, 0x4e, KEY_DELETE },
+	{ 0x04, 0x4c, KEY_TV },
+	{ 0x0b, 0x70, KEY_DVD },
+	{ 0x0e, 0x4e, KEY_VIDEO },
+	{ 0x06, 0x4c, KEY_AUDIO }, /* Music */
+	{ 0x09, 0x700, KEY_SCREEN }, /* Pic */
+	{ 0x00, 0x7d, KEY_UP },
+	{ 0x0f, 0x41, KEY_LEFT },
+	{ 0x07, 0x43, KEY_OK },
+	{ 0x08, 0x7f, KEY_RIGHT },
+	{ 0x03, 0x42, KEY_DOWN },
+	{ 0x0a, 0x40, KEY_EPG },
+	{ 0x04, 0x7c, KEY_INFO },
+	{ 0x0d, 0x71, KEY_BACK },
+	{ 0x02, 0x7d, KEY_VOLUMEUP },
+	{ 0x05, 0x43, KEY_VOLUMEDOWN },
+	{ 0x02, 0x4d, KEY_PLAY },
+	{ 0x0d, 0x41, KEY_MUTE },
+	{ 0x09, 0x40, KEY_CHANNELUP },
+	{ 0x0a, 0x7f, KEY_CHANNELDOWN },
+	{ 0x0b, 0x40, KEY_RED },
+	{ 0x01, 0x42, KEY_GREEN },
+	{ 0x0e, 0x7e, KEY_YELLOW },
+	{ 0x06, 0x7c, KEY_BLUE },
+	{ 0x01, 0x4d, KEY_RECORD },
+	{ 0x01, 0x72, KEY_STOP },
+	{ 0x00, 0x4d, KEY_PAUSE },
+	{ 0x03, 0x4d, KEY_LAST },
+	{ 0x05, 0x73, KEY_REWIND },
+	{ 0x0a, 0x4f, KEY_FASTFORWARD },
+	{ 0x02, 0x72, KEY_NEXT }
+};
+
 /* STK7700P: Hauppauge Nova-T Stick, AVerMedia Volar */
 static struct dibx000_agc_config stk7700p_7000m_mt2060_agc_config = {
 	BAND_UHF | BAND_VHF,       // band_caps
@@ -1450,7 +1500,7 @@
 			},
 		},
 
-		.num_device_descs = 9,
+		.num_device_descs = 8,
 		.devices = {
 			{   "DiBcom STK7070P reference design",
 				{ &dib0700_usb_id_table[15], NULL },
@@ -1484,6 +1534,29 @@
 				{ &dib0700_usb_id_table[30], NULL },
 				{ NULL },
 			},
+		},
+
+		.rc_interval      = DEFAULT_RC_INTERVAL,
+		.rc_key_map       = dib0700_rc_keys,
+		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
+		.rc_query         = dib0700_rc_query
+
+	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
+
+		.num_adapters = 1,
+		.adapter = {
+			{
+				.frontend_attach  = stk7070p_frontend_attach,
+				.tuner_attach     = dib7070p_tuner_attach,
+
+				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
+
+				.size_of_priv     = sizeof(struct dib0700_adapter_state),
+			},
+		},
+
+		.num_device_descs = 1,
+		.devices = {
 			{   "Terratec Cinergy T USB XXS",
 				{ &dib0700_usb_id_table[33], NULL },
 				{ NULL },
@@ -1491,8 +1564,8 @@
 		},
 
 		.rc_interval      = DEFAULT_RC_INTERVAL,
-		.rc_key_map       = dib0700_rc_keys,
-		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
+		.rc_key_map       = cinergy_xxs_rc_keys,
+		.rc_key_map_size  = ARRAY_SIZE(cinergy_xxs_rc_keys),
 		.rc_query         = dib0700_rc_query
 
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,

--------------030805090109080004060801
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------030805090109080004060801--
