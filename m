Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.126.171])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0=1YFw=ZY=nikocity.de=mueller_michael@srs.kundenserver.de>)
	id 1Kemry-00032R-B5
	for linux-dvb@linuxtv.org; Sun, 14 Sep 2008 10:22:12 +0200
Date: Sun, 14 Sep 2008 10:21:32 +0200
From: Michael =?iso-8859-1?Q?M=FCller?= <mueller_michael@nikocity.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080914082131.GA12258@mueller_michael.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
Cc: pboettcher@dibcom.fr
Subject: [linux-dvb] Elgato EyeTV Diversity patch
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


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

this week I bought a Elgato EyeTV Diversity USB stick for my iBook
that I also wanted to use with my Linux system. I thought it is a good
choice because the Supported Hardware list states for the Hauppauge
Nova-T stick that it's 'Identical to the USB Stick Elgato is
selling'. But mine has a different vendor and product id.

Simply adding a new entry beside the Hauppauge Nova-T stick using the
new ids didn't work. Using trail and error I was able to find the
right combination. I also was able to activate the remote
control. Since the other devices that use stk7070pd_frontend_attach0
and stk7070pd_frontend_attach1 as frontends doesn't activate the RC I
needed to start a section for my stick. If it doesn't hurt the other
devices to have a RC defined perhaps you should combine them.

The patches are based on the v4l-dvb code I got on Saturday using hg
clone http://linuxtv.org/hg/v4l-dvb. I have a 2.6.25 kernel. Would it
help to check if these patches works against the vanilla 2.6.25 too?

Here are some results/comments/questions:

This is what I get now:

Sep 14 08:52:07 grizzly kernel: usb 6-2: new high speed USB device using ehci_hcd and address 3
Sep 14 08:52:07 grizzly kernel: usb 6-2: configuration #1 chosen from 1 choice
Sep 14 08:52:07 grizzly kernel: usb 6-2: New USB device found, idVendor=0fd9, idProduct=0011
Sep 14 08:52:07 grizzly kernel: usb 6-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Sep 14 08:52:07 grizzly kernel: usb 6-2: Product: EyeTV Diversity
Sep 14 08:52:07 grizzly kernel: usb 6-2: Manufacturer: Elgato
Sep 14 08:52:07 grizzly kernel: usb 6-2: SerialNumber: 080604003698
Sep 14 08:52:07 grizzly kernel: dib0700: loaded with support for 8 different device-types
Sep 14 08:52:07 grizzly kernel: dvb-usb: found a 'Elgato EyeTV Diversity' in cold state, will try to load a firmware
Sep 14 08:52:07 grizzly kernel: dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
Sep 14 08:52:07 grizzly kernel: dib0700: firmware started successfully.
Sep 14 08:52:08 grizzly kernel: dvb-usb: found a 'Elgato EyeTV Diversity' in warm state.
Sep 14 08:52:08 grizzly kernel: i2c-adapter i2c-2: SMBus Quick command not supported, can't probe for chips
Sep 14 08:52:08 grizzly kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Sep 14 08:52:08 grizzly kernel: DVB: registering new adapter (Elgato EyeTV Diversity)
Sep 14 08:52:08 grizzly kernel: i2c-adapter i2c-3: SMBus Quick command not supported, can't probe for chips
Sep 14 08:52:08 grizzly kernel: DVB: registering frontend 0 (DiBcom 7000PC)...
Sep 14 08:52:08 grizzly kernel: DiB0070: successfully identified
Sep 14 08:52:08 grizzly kernel: dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
Sep 14 08:52:08 grizzly kernel: DVB: registering new adapter (Elgato EyeTV Diversity)
Sep 14 08:52:08 grizzly kernel: i2c-adapter i2c-4: SMBus Quick command not supported, can't probe for chips
Sep 14 08:52:08 grizzly kernel: DVB: registering frontend 1 (DiBcom 7000PC)...
Sep 14 08:52:08 grizzly kernel: DiB0070: successfully identified
Sep 14 08:52:08 grizzly kernel: input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1a.7/usb6/6-2/input/input5
Sep 14 08:52:08 grizzly kernel: dvb-usb: schedule remote query interval to 150 msecs.
Sep 14 08:52:08 grizzly kernel: dvb-usb: Elgato EyeTV Diversity successfully initialized and connected.
Sep 14 08:52:08 grizzly kernel: usbcore: registered new interface driver dvb_usb_dib0700

The following modules are loaded:

dvb_usb_dib0700        31240  0 
dib7000p               15240  3 dvb_usb_dib0700
dib7000m               13252  1 dvb_usb_dib0700
dvb_usb                17996  1 dvb_usb_dib0700
dvb_core               71232  1 dvb_usb
dib3000mc              11464  1 dvb_usb_dib0700
dibx000_common          3012  3 dib7000p,dib7000m,dib3000mc
dib0070                 7236  3 dvb_usb_dib0700

What about these i2c errors? Should I worry about them? Although if
not do you have an idea how I can get rid of them?  'i2c-adapter
i2c-2: SMBus Quick command not supported, can't probe for chips'

To use the remote control you have to set the module parameter
dvb_usb_dib0700_ir_proto=0 (NEC). Is there a possibility to hard-code
this in the driver? The standard protocol RC5 worked somehow, i.e. I
got reproducable numbers, but from time to time I got wrong numbers
and there was no system in the created numbers. With NEC protocol the
first number is always 0x45 and the second number is more or less a
simply serially numbered value starting with 1. So I would assume that
they really use NEC protocol which should be a parameter of the device
description in the code so that the driver uses the right setting by
default.

It works with both firmware versions: dvb-usb-dib0700-1.10.fw and
dvb-usb-dib0700-1.20.fw. I use a link for the 1.20 so that I don't
need to need to change the code.

Although it is stated that the diversity mode is currentl not
supported it seems to be necessary that both antenna plugs are
connected. I have an active antenna and I thought that without
diversity it would be the best to connect the antenna directly to the
adapter that I want to use. But in this combination 'scan' only
creates 'WARNING: >>> tuning failed!!!' messages. If I use the Y-cable
to connect the antenna to both adapters scan is able to find the TV
channels. Do you have an explanation for this behaviour?

Are there plans to add support for the diversity mode?

It maked my work to get the device running smooth that I was able to
work in a private v4l-dvb directory without the need to patch the
kernel sources and simply call 'make && make install' for the changed
modules in this private directory.

Regards

Michael
--82I3+IH0IqGh5yIs
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="dib0700_devices.c.patch"

--- dib0700_devices.c.orig	2008-09-13 12:03:46.000000000 +0200
+++ dib0700_devices.c	2008-09-14 09:01:38.000000000 +0200
@@ -677,6 +677,42 @@
 	{ 0x01, 0x7d, KEY_VOLUMEDOWN },
 	{ 0x02, 0x42, KEY_CHANNELUP },
 	{ 0x00, 0x7d, KEY_CHANNELDOWN },
+
+	/* Key codes for the Elgato EyeTV Diversity, set dvb_usb_dib0700_ir_proto=0 */
+  	{ 0x45, 0x01, KEY_POWER },
+  	{ 0x45, 0x02, KEY_MUTE },
+	{ 0x45, 0x0d, KEY_0 },
+	{ 0x45, 0x03, KEY_1 },
+	{ 0x45, 0x04, KEY_2 },
+	{ 0x45, 0x05, KEY_3 },
+	{ 0x45, 0x06, KEY_4 },
+	{ 0x45, 0x07, KEY_5 },
+	{ 0x45, 0x08, KEY_6 },
+	{ 0x45, 0x09, KEY_7 },
+	{ 0x45, 0x0a, KEY_8 },
+	{ 0x45, 0x0b, KEY_9 },
+	{ 0x45, 0x0c, KEY_LAST },
+	{ 0x45, 0x0e, KEY_ENTER },
+  	{ 0x45, 0x0f, KEY_RED },
+	{ 0x45, 0x11, KEY_GREEN },
+	{ 0x45, 0x15, KEY_YELLOW },
+	{ 0x45, 0x17, KEY_BLUE },
+	{ 0x45, 0x14, KEY_VOLUMEUP },
+	{ 0x45, 0x12, KEY_VOLUMEDOWN },
+	{ 0x45, 0x10, KEY_CHANNELUP },
+	{ 0x45, 0x16, KEY_CHANNELDOWN },
+	{ 0x45, 0x13, KEY_OK },
+	//	{ 0x45, 0x18, KEY_ARROW2 }, // Below KEY_YELLOW
+  	{ 0x45, 0x19, KEY_PLAYPAUSE },
+	//	{ 0x45, 0x1a, KEY_ARROW3 }, // Below KEY_BLUE
+  	{ 0x45, 0x1b, KEY_REWIND },
+	{ 0x45, 0x1c, KEY_L }, /* Live */
+  	{ 0x45, 0x1d, KEY_FASTFORWARD },
+	{ 0x45, 0x1e, KEY_STOP },
+	{ 0x45, 0x1f, KEY_TEXT },
+	{ 0x45, 0x40, KEY_RECORD },
+	//	{ 0x45, 0x41, KEY_HOLD }, // Below KEY_STOP
+	{ 0x45, 0x42, KEY_SELECT },
 };
 
 /* STK7700P: Hauppauge Nova-T Stick, AVerMedia Volar */
@@ -1119,6 +1155,7 @@
 	{ USB_DEVICE(USB_VID_LEADTEK,   USB_PID_WINFAST_DTV_DONGLE_STK7700P_2) },
 /* 35 */{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_TD_STICK_52009) },
 	{ USB_DEVICE(USB_VID_HAUPPAUGE, USB_PID_HAUPPAUGE_NOVA_T_500_3) },
+	{ USB_DEVICE(USB_VID_ELGATO,    USB_PID_ELGATO_EYETV_DIVERSITY) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -1395,6 +1432,39 @@
 		}
 	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
 
+		.num_adapters = 2,
+		.adapter = {
+			{
+				.frontend_attach  = stk7070pd_frontend_attach0,
+				.tuner_attach     = dib7070p_tuner_attach,
+
+				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
+
+				.size_of_priv     = sizeof(struct dib0700_adapter_state),
+			}, {
+				.frontend_attach  = stk7070pd_frontend_attach1,
+				.tuner_attach     = dib7070p_tuner_attach,
+
+				DIB0700_DEFAULT_STREAMING_CONFIG(0x03),
+
+				.size_of_priv     = sizeof(struct dib0700_adapter_state),
+			}
+		},
+
+	     	.num_device_descs = 1,
+		.devices = {
+			{   "Elgato EyeTV Diversity",
+				{ &dib0700_usb_id_table[37], NULL },
+				{ NULL }
+			}
+		},
+		.rc_interval      = DEFAULT_RC_INTERVAL,
+		.rc_key_map       = dib0700_rc_keys,
+		.rc_key_map_size  = ARRAY_SIZE(dib0700_rc_keys),
+		.rc_query         = dib0700_rc_query
+
+	}, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
+
 		.num_adapters = 1,
 		.adapter = {
 			{

--82I3+IH0IqGh5yIs
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="dvb-usb-ids.h.patch"

--- dvb-usb-ids.h.orig	2008-09-13 12:03:46.000000000 +0200
+++ dvb-usb-ids.h	2008-09-14 08:21:03.000000000 +0200
@@ -27,6 +27,7 @@
 #define USB_VID_DIBCOM				0x10b8
 #define USB_VID_DPOSH				0x1498
 #define USB_VID_DVICO				0x0fe9
+#define USB_VID_ELGATO				0x0fd9
 #define USB_VID_EMPIA				0xeb1a
 #define USB_VID_GENPIX				0x09c0
 #define USB_VID_GRANDTEC			0x5032
@@ -209,5 +210,6 @@
 #define USB_PID_ASUS_U3100				0x173f
 #define USB_PID_YUAN_EC372S				0x1edc
 #define USB_PID_DW2102					0x2102
+#define USB_PID_ELGATO_EYETV_DIVERSITY			0x0011
 
 #endif

--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--82I3+IH0IqGh5yIs--
