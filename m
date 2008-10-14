Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <harald.becherer@gmx.de>) id 1KpYy6-0000qd-CO
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 03:45:05 +0200
Date: Tue, 14 Oct 2008 03:44:28 +0200
From: "Harald Becherer" <harald.becherer@gmx.de>
Message-ID: <20081014014428.103770@gmx.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] TechnoTrend TT-3650 CI
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

Following things that I did on a gentoo machine to try to make my "TechnoTrend S2-3650 CI DVB-S2" work:

#uname -r
2.6.25-gento-r7

#lspci
00:00.0 Host bridge: Intel Corporation 82P965/G965 Memory Controller Hub (rev 02)
00:01.0 PCI bridge: Intel Corporation 82P965/G965 PCI Express Root Port (rev 02)
00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Contoller #4 (rev 02)
00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 02)
00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 02)
00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 02)
00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 5 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev f2)
00:1f.0 ISA bridge: Intel Corporation 82801HB/HR (ICH8/R) LPC Interface Controller (rev 02)
00:1f.2 SATA controller: Intel Corporation 82801HR/HO/HH (ICH8R/DO/DH) 6 port SATA AHCI Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 02)
01:00.0 VGA compatible controller: nVidia Corporation G71 [GeForce 7950 GT] (rev a1)
02:00.0 SATA controller: JMicron Technologies, Inc. JMicron 20360/20363 AHCI Controller (rev 02)
02:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 AHCI Controller (rev 02)
04:02.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10)
04:03.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host Controller (rev 80)

#lsusb
Bus 002 Device 004: ID 10d5:200d Uni Class Technology Co., Ltd
Bus 002 Device 003: ID 04cc:1520 Philips Semiconductors
Bus 002 Device 001: ID 1d6b:0002
Bus 006 Device 002: ID 04a9:220d Canon, Inc. CanoScan N670U/N676U/LiDE 20
Bus 006 Device 001: ID 1d6b:0001
Bus 007 Device 001: ID 1d6b:0001
Bus 005 Device 001: ID 1d6b:0001
Bus 001 Device 004: ID 0b48:300a TechnoTrend AG
Bus 001 Device 001: ID 1d6b:0002
Bus 004 Device 001: ID 1d6b:0001
Bus 003 Device 001: ID 1d6b:0001



I tried 3 ways:
1a) and 1b) with the multiproto branch
2)  from the Igor Liplianin branch




1) Downloaded http://jusst.de/hg/multiproto/archive/tip.tar.bz2 (multiproto-855d0c878944.tar.bz2)


1a) I applied following patches by hand because a normal patching throwed to many errors
=== Begin ======================================================================
diff -r b25ed8c6c0e8 linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- a/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Sun Apr 20 22:23:21 2008 +0200
+++ b/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h	Sun Apr 20 22:28:21 2008 +0200
@@ -144,6 +144,7 @@
 #define USB_PID_PCTV_450E				0x0222
 #define USB_PID_PCTV_452E				0x021f
 #define USB_PID_TECHNOTREND_CONNECT_S2_3600             0x3007
+#define USB_PID_TECHNOTREND_CONNECT_S2_3650_CI          0x300a
 #define USB_PID_NEBULA_DIGITV				0x0201
 #define USB_PID_DVICO_BLUEBIRD_LGDT			0xd820
 #define USB_PID_DVICO_BLUEBIRD_LG064F_COLD		0xd500
diff -r b25ed8c6c0e8 linux/drivers/media/dvb/dvb-usb/pctv452e.c
--- a/linux/drivers/media/dvb/dvb-usb/pctv452e.c	Sun Apr 20 22:23:21 2008 +0200
+++ b/linux/drivers/media/dvb/dvb-usb/pctv452e.c	Sun Apr 20 22:28:21 2008 +0200
@@ -967,6 +967,7 @@ static struct usb_device_id pctv452e_usb
 static struct usb_device_id pctv452e_usb_table[] = {
 	{USB_DEVICE(USB_VID_PINNACLE, USB_PID_PCTV_452E)},
 	{USB_DEVICE(USB_VID_TECHNOTREND, USB_PID_TECHNOTREND_CONNECT_S2_3600)},
+	{USB_DEVICE(USB_VID_TECHNOTREND, USB_PID_TECHNOTREND_CONNECT_S2_3650_CI)},
 	{}
 };
 MODULE_DEVICE_TABLE(usb, pctv452e_usb_table);
@@ -1077,6 +1078,10 @@ static struct dvb_usb_device_properties 
 		  .cold_ids = { NULL, NULL }, // this is a warm only device
 		  .warm_ids = { &pctv452e_usb_table[1], NULL }
 		},
+		{ .name = "Technotrend TT Connect S2-3650-CI",
+		  .cold_ids = { NULL, NULL }, // this is a warm only device
+		  .warm_ids = { &pctv452e_usb_table[2], NULL }
+		},
 		{ 0 },
 	}
 };
=== End ========================================================================


=== Begin ======================================================================
diff -r 6ebc788b30f2 linux/drivers/media/dvb/dvb-usb/pctv452e.c
--- a/linux/drivers/media/dvb/dvb-usb/pctv452e.c	Sun Apr 20 22:28:55 2008 +0200
+++ b/linux/drivers/media/dvb/dvb-usb/pctv452e.c	Sun Apr 20 22:29:13 2008 +0200
@@ -1038,7 +1038,7 @@ static struct dvb_usb_device_properties 
 	.power_ctrl       = pctv452e_power_ctrl,
 
 	.rc_key_map       = tt_connect_s2_3600_rc_key,
-	.rc_key_map_size  = ARRAY_SIZE(pctv452e_rc_keys),
+	.rc_key_map_size  = ARRAY_SIZE(tt_connect_s2_3600_rc_key),
 	.rc_query         = pctv452e_rc_query,
 	.rc_interval      = 100,
 
=== End ========================================================================


=== Begin ======================================================================
inserted in pctv452e.c

+/* Remote Control Stuff fo S2-3600 (copied from TT-S1500): */
+static struct dvb_usb_rc_key tt_connect_s2_3600_rc_key[] = {
+        {0x15, 0x01, KEY_POWER},
+        {0x15, 0x02, KEY_SHUFFLE}, /* ? double-arrow key */
+        {0x15, 0x03, KEY_1},
+        {0x15, 0x04, KEY_2},
+        {0x15, 0x05, KEY_3},
+        {0x15, 0x06, KEY_4},
+        {0x15, 0x07, KEY_5},
+        {0x15, 0x08, KEY_6},
+        {0x15, 0x09, KEY_7},
+        {0x15, 0x0a, KEY_8},
+        {0x15, 0x0b, KEY_9},
+        {0x15, 0x0c, KEY_0},
+        {0x15, 0x0d, KEY_UP},
+        {0x15, 0x0e, KEY_LEFT},
+        {0x15, 0x0f, KEY_OK},
+        {0x15, 0x10, KEY_RIGHT},
+        {0x15, 0x11, KEY_DOWN},
+        {0x15, 0x12, KEY_INFO},
+        {0x15, 0x13, KEY_EXIT},
+        {0x15, 0x14, KEY_RED},
+        {0x15, 0x15, KEY_GREEN},
+        {0x15, 0x16, KEY_YELLOW},
+        {0x15, 0x17, KEY_BLUE},
+        {0x15, 0x18, KEY_MUTE},
+        {0x15, 0x19, KEY_TEXT},
+        {0x15, 0x1a, KEY_MODE},  /* ? TV/Radio */
+        {0x15, 0x21, KEY_OPTION},
+        {0x15, 0x22, KEY_EPG},
+        {0x15, 0x23, KEY_CHANNELUP},
+        {0x15, 0x24, KEY_CHANNELDOWN},
+        {0x15, 0x25, KEY_VOLUMEUP},
+        {0x15, 0x26, KEY_VOLUMEDOWN},
+        {0x15, 0x27, KEY_SETUP},
+        {0x15, 0x3a, KEY_RECORD},/* these keys are only in the black remote */
+        {0x15, 0x3b, KEY_PLAY},
+        {0x15, 0x3c, KEY_STOP},
+        {0x15, 0x3d, KEY_REWIND},
+        {0x15, 0x3e, KEY_PAUSE},
+        {0x15, 0x3f, KEY_FORWARD}
+};
=== End ========================================================================


Result:
-After installing the drivers no scanning with kaffeine was possible
-dmesg showed me only:
usbcore: registered new interface driver pctv452e
usbcore: registered new interface driver dvb-usb-tt-connect-s2-3600-01.fw





1b) In the next try I only made one change to the original source tree in the file:
linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h

#define USB_PID_TECHNOTREND_CONNECT_S2_3600             0x3007
to
#define USB_PID_TECHNOTREND_CONNECT_S2_3600             0x300a


Result:
-Kaffeine can scan channels and watch TV
 Channel hopping is still a little slow
 and no HD programs in the scan result.
-In VDR, channel hopping is pretty fast, faster than in the windows application TT Media Center
-dmesg shows me:
dvb-usb: found a 'Technotrend TT Connect S2-3600' in warm state.
pctv452e_power_ctrl: 1
i2c-adapter i2c-4: SMBus Quick command not supported, can't probe for chips
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Technotrend TT Connect S2-3600)
pctv452e_frontend_attach Enter
stb0899_attach: Attaching STB0899
lnbp22_set_voltage: 2 (18V=1 13V=0)
lnbp22_set_voltage: 0x60)
pctv452e_frontend_attach Leave Ok
DVB: registering frontend 0 (STB0899 Multistandard)...
pctv452e_tuner_attach Enter
stb6100_attach: Attaching STB6100
pctv452e_tuner_attach Leave
input: IR-receiver inside an USB DVB receiver as /class/input/input9
dvb-usb: schedule remote query interval to 100 msecs.
pctv452e_power_ctrl: 0
dvb-usb: Technotrend TT Connect S2-3600 successfully initialized and connected.
usbcore: registered new interface driver pctv452e
usbcore: registered new interface driver dvb-usb-tt-connect-s2-3600-01.fw




2) The third attempt i download the branch of Igor Liplianin:
http://mercurial.intuxication.org/hg/s2-liplianin/archive/tip.tar.bz2 (s2-liplianin-030c9bc8792e.tar.bz2)

same result as 1a)


I cannot go through all the repositories on http://www.linuxtv.org/hg
Does one exist with (alpha, beta,...) TechnoTrend TT-3650 CI support?

Cheers,

Harald

-- 
GMX startet ShortView.de. Hier findest Du Leute mit Deinen Interessen!
Jetzt dabei sein: http://www.shortview.de/wasistshortview.php?mc=sv_ext_mf@gmx

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
