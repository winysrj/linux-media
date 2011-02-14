Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52644 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab1BNLhV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 06:37:21 -0500
Received: by iwn9 with SMTP id 9so4700614iwn.19
        for <linux-media@vger.kernel.org>; Mon, 14 Feb 2011 03:37:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTim1beU2KZKyHJpjE=93nAyt8jXv8pEw4Y-ivGwJ@mail.gmail.com>
References: <AANLkTim1beU2KZKyHJpjE=93nAyt8jXv8pEw4Y-ivGwJ@mail.gmail.com>
Date: Mon, 14 Feb 2011 12:37:20 +0100
Message-ID: <AANLkTikNpoBNDvUcEnHFyPGhRBjXLATVCKT3Y+2Y9rg7@mail.gmail.com>
Subject: Re: [PATCH] Technisat AirStar TeleStick 2
From: Lukas Max Fisch <lukas.fisch@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello list,
this is a revised patch since &dib0700_usb_id_table[] must be 74 instead of 69!
This patch works for me as you can see in the dmesg output:

[  104.667079] dvb-usb: found a 'TechniSat AirStar TeleStick 2' in
cold state, will try to load a firmware
[  104.671587] dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
[  104.872581] dib0700: firmware started successfully.
[  105.375794] dvb-usb: found a 'TechniSat AirStar TeleStick 2' in warm state.
[  105.375862] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[  105.375994] DVB: registering new adapter (TechniSat AirStar TeleStick 2)
[  105.592015] DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
[  105.813997] DiB0070: successfully identified
[  105.838542] Registered IR keymap rc-dib0700-rc5
[  105.838707] input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/rc/rc0/input14
[  105.838776] rc0: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/rc/rc0
[  105.839079] dvb-usb: schedule remote query interval to 50 msecs.
[  105.839084] dvb-usb: TechniSat AirStar TeleStick 2 successfully
initialized and connected.

Mauro, please add it to 2.6.39 if possible.
TODO: Add proper keymap for remote control.


Add initial support for Technisat AirStar TeleStick 2.
This patch is based on Veit Berwig's work.

Signed-off-by: Lukas Fisch <lukas.fisch@gmail.com>
---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |    7 ++++++-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h     |    1 +
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c
b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index c6022af..d3dd09a 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -2784,6 +2784,7 @@ struct usb_device_id dib0700_usb_id_table[] = {
       { USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_NIM9090MD) },
       { USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_NIM7090) },
       { USB_DEVICE(USB_VID_DIBCOM,    USB_PID_DIBCOM_TFE7090PVR) },
+       { USB_DEVICE(USB_VID_TECHNISAT,
USB_PID_TECHNISAT_AIRSTAR_TELESTICK_2) },
       { 0 }           /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -3393,7 +3394,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
                       },
               },

-               .num_device_descs = 2,
+               .num_device_descs = 3,
               .devices = {
                       {   "DiBcom STK7770P reference design",
                               { &dib0700_usb_id_table[59], NULL },
@@ -3405,6 +3406,10 @@ struct dvb_usb_device_properties dib0700_devices[] = {
                                       &dib0700_usb_id_table[60], NULL},
                               { NULL },
                       },
+                       {   "TechniSat AirStar TeleStick 2",
+                               { &dib0700_usb_id_table[74], NULL },
+                               { NULL },
+                       },
               },

               .rc.core = {
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index b71540d..3a8b744 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -317,5 +317,6 @@
 #define USB_PID_TERRATEC_DVBS2CI_V2                    0x10ac
 #define USB_PID_TECHNISAT_USB2_HDCI_V1                 0x0001
 #define USB_PID_TECHNISAT_USB2_HDCI_V2                 0x0002
+#define USB_PID_TECHNISAT_AIRSTAR_TELESTICK_2          0x0004
 #define USB_PID_TECHNISAT_USB2_DVB_S2                  0x0500
 #endif
--
1.7.2.3
