Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.andi.de1.cc ([85.214.239.24]:47808 "EHLO
        h2641619.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932848AbdCIRpX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 12:45:23 -0500
From: Andreas Kemnade <andreas@kemnade.info>
To: linux-media@vger.kernel.org, mchehab@kernel.org
Cc: Andreas Kemnade <andreas@kemnade.info>
Subject: [PATCH RFC] dvb: af9035.c: Logilink vg0022a to device id table
Date: Thu,  9 Mar 2017 17:51:14 +0100
Message-Id: <1489078274-24227-1-git-send-email-andreas@kemnade.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ths adds the logilink VG00022a dvb-t dongle to the device table.
The dongle contains (checked by removing the case)
IT9303
SI2168
  214730

The result is in cold state:

 usb 1-6: new high-speed USB device number 15 using xhci_hcd
 usb 1-6: New USB device found, idVendor=1d19, idProduct=0100
 usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
 usb 1-6: Product: TS Aggregator
 usb 1-6: Manufacturer: ITE Tech., Inc.
 usb 1-6: SerialNumber: XXXXXXXXXXXX
 dvb_usb_af9035 1-6:1.0: prechip_version=83 chip_version=01 chip_type=9306
 dvb_usb_af9035 1-6:1.0: ts mode=5 not supported, defaulting to single tuner mode!
 usb 1-6: dvb_usb_v2: found a 'Logilink VG0022A' in cold state
 usb 1-6: dvb_usb_v2: downloading firmware from file 'dvb-usb-it9303-01.fw'
 dvb_usb_af9035 1-6:1.0: firmware version=1.4.0.0
 usb 1-6: dvb_usb_v2: found a 'Logilink VG0022A' in warm state
 usb 1-6: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
 dvbdev: DVB: registering new adapter (Logilink VG0022A)
 si2168: probe of 6-0067 failed with error -5

when warmed up by connecing it via  a powered usb hub to win7 and
then attaching the same usb hub to a linux machine:

 usb 1-6.2: New USB device found, idVendor=1d19, idProduct=0100
 usb 1-6.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
 usb 1-6.2: Product: TS Aggregator
 usb 1-6.2: Manufacturer: ITE Tech., Inc.
 usb 1-6.2: SerialNumber: XXXXXXXXXXXX
 dvb_usb_af9035 1-6.2:1.0: prechip_version=83 chip_version=01 chip_type=9306
 dvb_usb_af9035 1-6.2:1.0: ts mode=5 not supported, defaulting to single tuner mode!
 usb 1-6.2: dvb_usb_v2: found a 'Logilink VG0022A' in warm state
 usb 1-6.2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
 dvbdev: DVB: registering new adapter (Logilink VG0022A)
 i2c i2c-6: Added multiplexed i2c bus 7
 si2168 6-0067: Silicon Labs Si2168-B40 successfully identified
 si2168 6-0067: firmware version: B 4.0.2
 usb 1-6.2: DVB: registering adapter 0 frontend 0 (Silicon Labs Si2168)...
 si2157 7-0063: Silicon Labs Si2147/2148/2157/2158 successfully attached
 usb 1-6.2: dvb_usb_v2: 'Logilink VG0022A' successfully initialized and connected
 si2168 6-0067: Direct firmware load for dvb-demod-si2168-b40-01.fw failed with error -2
 si2168 6-0067: Direct firmware load for dvb-demod-si2168-02.fw failed with error -2
 si2168 6-0067: firmware file 'dvb-demod-si2168-02.fw' not found
 si2157 7-0063: found a 'Silicon Labs Si2147-A30'
 si2157 7-0063: firmware version: 3.0.5

same with the firmware for the si2168 available:
 usb 1-6.2: new high-speed USB device number 12 using xhci_hcd
 usb 1-6.2: New USB device found, idVendor=1d19, idProduct=0100
 usb 1-6.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
 usb 1-6.2: Product: TS Aggregator
 usb 1-6.2: Manufacturer: ITE Tech., Inc.
 usb 1-6.2: SerialNumber: XXXXXXXXXXXX
 dvb_usb_af9035 1-6.2:1.0: prechip_version=83 chip_version=01 chip_type=9306
 dvb_usb_af9035 1-6.2:1.0: ts mode=5 not supported, defaulting to single tuner mode!
 usb 1-6.2: dvb_usb_v2: found a 'Logilink VG0022A' in warm state
 usb 1-6.2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
 dvbdev: DVB: registering new adapter (Logilink VG0022A)
 i2c i2c-6: Added multiplexed i2c bus 7
 si2168 6-0067: Silicon Labs Si2168-B40 successfully identified
 si2168 6-0067: firmware version: B 4.0.2
 usb 1-6.2: DVB: registering adapter 0 frontend 0 (Silicon Labs Si2168)...
 si2157 7-0063: Silicon Labs Si2147/2148/2157/2158 successfully attached
 usb 1-6.2: dvb_usb_v2: 'Logilink VG0022A' successfully initialized and connected
 si2168 6-0067: downloading firmware from file 'dvb-demod-si2168-b40-01.fw'
 si2168 6-0067: firmware version: B 4.0.11
 si2157 7-0063: unknown chip version Si21255-\xffffffff\xffffffff\xffffffff
 si2157 7-0063: unknown chip version Si21255-\xffffffff\xffffffff\xffffffff

so firmware uploading to the si2168 somehow messes things up

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index c673726..ed674b8 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -2141,6 +2141,8 @@ static const struct usb_device_id af9035_id_table[] = {
 	/* IT930x devices */
 	{ DVB_USB_DEVICE(USB_VID_ITETECH, USB_PID_ITETECH_IT9303,
 		&it930x_props, "ITE 9303 Generic", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_DEXATEK, 0x0100,
+		&it930x_props, "Logilink VG0022A", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, af9035_id_table);
-- 
2.1.4
