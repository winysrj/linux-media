Return-path: <linux-media-owner@vger.kernel.org>
Received: from nebuchadnezzar.smejdil.cz ([195.122.194.203]:59024 "EHLO
	nebuchadnezzar.smejdil.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbZD1Fzs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2009 01:55:48 -0400
From: CIJOML <cijoml@volny.cz>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com
Subject: PATCH recognize Leadtek WinFast DTV Dongle H
Date: Tue, 28 Apr 2009 07:42:02 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904280742.03012.cijoml@volny.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

please have a look at following patch which adds support for Leadtek WinFast 
DTV Dongle H (hybrid - currently only DVB-T reception works, analog is not 
supported). 
This patch shoud go directly to stable release - no external functionality is 
added.
Patch is against latest v4l merculial from linuxtv.org

diff -urN 
v4l-dvb-b40d628f830d/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c 
v4l-dvb-b40d628f830d.edited/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- v4l-dvb-b40d628f830d/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c      
2009-04-24 06:46:41.000000000 +0200
+++ 
v4l-dvb-b40d628f830d.edited/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c       
2009-04-28 07:19:43.000000000 +0200
@@ -1498,6 +1498,7 @@
        { USB_DEVICE(USB_VID_YUAN,      USB_PID_YUAN_MC770) },
        { USB_DEVICE(USB_VID_ELGATO,    USB_PID_ELGATO_EYETV_DTT) },
 /* 50 */{ USB_DEVICE(USB_VID_ELGATO,   USB_PID_ELGATO_EYETV_DTT_Dlx) },
+       { USB_DEVICE(USB_VID_LEADTEK,   
USB_PID_WINFAST_DTV_DONGLE_STK7700PH) },
        { 0 }           /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -1821,7 +1822,7 @@
                        },mchehab@redhat.com
                },

-               .num_device_descs = 7,
+               .num_device_descs = 8,
                .devices = {
                        {   "Terratec Cinergy HT USB XE",
                                { &dib0700_usb_id_table[27], NULL },
@@ -1851,6 +1852,10 @@
                                { &dib0700_usb_id_table[48], NULL },
                                { NULL },
                        },
+                       {   "LEADTEK WinFast DTV Dongle H",
+                               { &dib0700_usb_id_table[51], NULL },
+                               { NULL },
+                       },
                },
                .rc_interval      = DEFAULT_RC_INTERVAL,
                .rc_key_map       = dib0700_rc_keys,
diff -urN v4l-dvb-b40d628f830d/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h 
v4l-dvb-b40d628f830d.edited/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
--- v4l-dvb-b40d628f830d/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h  
2009-04-24 06:46:41.000000000 +0200
+++ v4l-dvb-b40d628f830d.edited/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h   
2009-04-28 07:17:00.000000000 +0200
@@ -225,6 +225,7 @@
 #define USB_PID_WINFAST_DTV_DONGLE_WARM                        0x6026
 #define USB_PID_WINFAST_DTV_DONGLE_STK7700P            0x6f00
 #define USB_PID_WINFAST_DTV_DONGLE_STK7700P_2          0x6f01
+#define USB_PID_WINFAST_DTV_DONGLE_STK7700PH           0x60f6
 #define USB_PID_WINFAST_DTV_DONGLE_GOLD                        0x6029
 #define USB_PID_GENPIX_8PSK_REV_1_COLD                 0x0200
 #define USB_PID_GENPIX_8PSK_REV_1_WARM                 0x0201


After patch you can see this:

usb 3-1: new high speed USB device using ehci_hcd and address 3
usb 3-1: configuration #1 chosen from 1 choice
dib0700: loaded with support for 9 different device-types
dvb-usb: found a 'LEADTEK WinFast DTV Dongle H' in cold state, will try to 
load                                                                                                       
a firmware
usb 3-1: firmware: requesting dvb-usb-dib0700-1.20.fw
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
dib0700: firmware started successfully.
dvb-usb: found a 'LEADTEK WinFast DTV Dongle H' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software 
demuxer.
DVB: registering new adapter (LEADTEK WinFast DTV Dongle H)
DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
xc2028 6-0061: creating new instance
xc2028 6-0061: type set to XCeive xc2028/xc3028 tuner
input: IR-receiver inside an USB DVB receiver as /class/input/input8
dvb-usb: schedule remote query interval to 50 msecs.
dvb-usb: LEADTEK WinFast DTV Dongle H successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_dib0700
i2c-adapter i2c-6: firmware: requesting xc3028-v27.fw
xc2028 6-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 
firmw                                                                                                      
are, ver 2.7
xc2028 6-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
xc2028 6-0061: Loading firmware for type=D2620 DTV8 (208), id 
0000000000000000.
xc2028 6-0061: Loading SCODE for type=DTV7 DTV78 DTV8 DIBCOM52 CHINA SCODE 
HAS_I                                                                                                      
F_5400 (65000380), id 0000000000000000.

Best regards

Michal
