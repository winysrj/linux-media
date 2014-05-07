Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:45832 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaEGVJv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 May 2014 17:09:51 -0400
Received: by mail-ee0-f54.google.com with SMTP id b57so1104329eek.41
        for <linux-media@vger.kernel.org>; Wed, 07 May 2014 14:09:50 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 7 May 2014 23:09:50 +0200
Message-ID: <CAOy13NfH0ut52xgjzL7um9YMg36BiY23zB4bpTNxSnw=7FfdvQ@mail.gmail.com>
Subject: [PATCH] TerraTec Cinergy Hybrid T USB XS with demodulator MT352 is
 not detect by em28xx
From: Giovanni Nervi <giovanni.nervi@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have Terratec Cinergy Hybrid T USB XS 00cd:0042, I'm trying to make
it work with kernel 3.14.3 but I have a problem.
With old kernel 2.6 this device was working, but now I thought there
is a little misconfiguration in driver em28xx.

I looking information on this link
http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_Hybrid_T_USB_XS
and my device can have ZL10353 or MT352 demulator, my device has MT352
and has a Em2880 usb bridge.

Here the dmesg with original kernel 3.14.3

[  670.727877] usb 3-1: new high-speed USB device number 5 using xhci_hcd
[  670.865134] usb 3-1: New USB device found, idVendor=0ccd, idProduct=0042
[  670.865147] usb 3-1: New USB device strings: Mfr=2, Product=1, SerialNumber=0
[  670.865154] usb 3-1: Product: Cinergy Hybrid T USB XS
[  670.865160] usb 3-1: Manufacturer: TerraTec Electronic GmbH
[  670.900385] em28xx: New device TerraTec Electronic GmbH Cinergy
Hybrid T USB XS @ 480 Mbps (0ccd:0042, interface 0, class 0)
[  670.900391] em28xx: Video interface 0 found: isoc
[  670.900393] em28xx: DVB interface 0 found: isoc
[  670.900431] em28xx: chip ID is em2882/3
[  671.070669] em2882/3 #0: EEPROM ID = 1a eb 67 95, EEPROM hash = 0x303d5d95
[  671.070677] em2882/3 #0: EEPROM info:
[  671.070681] em2882/3 #0:     AC97 audio (5 sample rates)
[  671.070684] em2882/3 #0:     500mA max power
[  671.070689] em2882/3 #0:     Table at offset 0x06, strings=0x329e,
0x346a, 0x0000
[  671.070696] em2882/3 #0: Identified as Terratec Cinnergy Hybrid T
USB XS (em2882) (card=55)
[  671.070701] em2882/3 #0: analog set to isoc mode.
[  671.070704] em2882/3 #0: dvb set to isoc mode.
[  671.070823] usbcore: registered new interface driver em28xx
[  671.082716] em2882/3 #0: Binding DVB extension
[  671.140861] em2882/3 #0: /2: dvb frontend not attached. Can't attach xc3028
[  671.140875] em28xx: Registered (Em28xx dvb Extension) extension
[  671.144670] em2882/3 #0: Registering input extension
[  671.145161] Registered IR keymap rc-terratec-cinergy-xs
[  671.145394] input: em28xx IR (em2882/3 #0) as
/devices/pci0000:00/0000:00:14.0/usb3/3-1/rc/rc0/input22
[  671.145823] rc0: em28xx IR (em2882/3 #0) as
/devices/pci0000:00/0000:00:14.0/usb3/3-1/rc/rc0
[  671.145927] em2882/3 #0: Input extension successfully initalized
[  671.145933] em28xx: Registered (Em28xx Input Extension) extension

I have firmware 2.7 in /lib/firmware, but the problem is not the firmware.

in the source file drivers/media/usb/em28xx/em28xx-cards.c
my device is configured as

        { USB_DEVICE(0x0ccd, 0x0042),
                        .driver_info = EM2882_BOARD_TERRATEC_HYBRID_XS },

but for this configuration in drivers/media/usb/em28xx/em28xx-dvb.c only zl10353
is tried to attach for dvb adapter, in my case there is an issue.

        case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900:
        case EM2882_BOARD_TERRATEC_HYBRID_XS:
        case EM2880_BOARD_EMPIRE_DUAL_TV:
                dvb->fe[0] = dvb_attach(zl10353_attach,
                                           &em28xx_zl10353_xc3028_no_i2c_gate,
                                           &dev->i2c_adap[dev->def_i2c_bus]);
                if (em28xx_attach_xc3028(0x61, dev) < 0) {
                        result = -EINVAL;
                        goto out_free;
                }
                break;

I tried this patch

--- /usr/src/linux-3.14.3/drivers/media/usb/em28xx/em28xx-cards.c.orig
  2014-05-06 16:59:58.000000000 +0200
+++ /usr/src/linux-3.14.3/drivers/media/usb/em28xx/em28xx-cards.c
2014-05-07 15:18:31.719524453 +0200
@@ -2233,7 +2233,7 @@
        { USB_DEVICE(0x0ccd, 0x005e),
                        .driver_info = EM2882_BOARD_TERRATEC_HYBRID_XS },
        { USB_DEVICE(0x0ccd, 0x0042),
-                       .driver_info = EM2882_BOARD_TERRATEC_HYBRID_XS },
+                       .driver_info = EM2880_BOARD_TERRATEC_HYBRID_XS },
        { USB_DEVICE(0x0ccd, 0x0043),
                        .driver_info = EM2870_BOARD_TERRATEC_XS },
        { USB_DEVICE(0x0ccd, 0x008e),   /* Cinergy HTC USB XS Rev. 1 */


so my device became a EM2880_BOARD_TERRATEC_HYBRID_XS and in
em28xx-dvb.c also MT352 is tried to attach

        case EM2880_BOARD_TERRATEC_HYBRID_XS:
        case EM2880_BOARD_TERRATEC_HYBRID_XS_FR:
        case EM2881_BOARD_PINNACLE_HYBRID_PRO:
        case EM2882_BOARD_DIKOM_DK300:
        case EM2882_BOARD_KWORLD_VS_DVBT:
                dvb->fe[0] = dvb_attach(zl10353_attach,
                                           &em28xx_zl10353_xc3028_no_i2c_gate,
                                           &dev->i2c_adap[dev->def_i2c_bus]);
                if (dvb->fe[0] == NULL) {
                        /* This board could have either a zl10353 or a mt352.
                           If the chip id isn't for zl10353, try mt352 */
                        dvb->fe[0] = dvb_attach(mt352_attach,
                                                   &terratec_xs_mt352_cfg,

&dev->i2c_adap[dev->def_i2c_bus]);
                }

                if (em28xx_attach_xc3028(0x61, dev) < 0) {
                        result = -EINVAL;
                        goto out_free;
                }
                break;

and I have this output in dmesg

[   78.668320] usb 3-1: new high-speed USB device number 3 using xhci_hcd
[   78.805565] usb 3-1: New USB device found, idVendor=0ccd, idProduct=0042
[   78.805578] usb 3-1: New USB device strings: Mfr=2, Product=1, SerialNumber=0
[   78.805585] usb 3-1: Product: Cinergy Hybrid T USB XS
[   78.805591] usb 3-1: Manufacturer: TerraTec Electronic GmbH
[   78.806257] em28xx: New device TerraTec Electronic GmbH Cinergy
Hybrid T USB XS @ 480 Mbps (0ccd:0042, interface 0, class 0)
[   78.806266] em28xx: Video interface 0 found: isoc
[   78.806269] em28xx: DVB interface 0 found: isoc
[   78.806314] em28xx: chip ID is em2882/3
[   78.959082] em2882/3 #0: EEPROM ID = 1a eb 67 95, EEPROM hash = 0x303d5d95
[   78.959091] em2882/3 #0: EEPROM info:
[   78.959094] em2882/3 #0:     AC97 audio (5 sample rates)
[   78.959097] em2882/3 #0:     500mA max power
[   78.959102] em2882/3 #0:     Table at offset 0x06, strings=0x329e,
0x346a, 0x0000
[   78.959108] em2882/3 #0: Identified as Terratec Hybrid XS (card=11)
[   78.959113] em2882/3 #0: analog set to isoc mode.
[   78.959116] em2882/3 #0: dvb set to isoc mode.
[   78.959444] em28xx audio device (0ccd:0042): interface 1, class 1
[   78.959513] em2882/3 #0: Binding DVB extension
[   78.997430] xc2028 7-0061: creating new instance
[   78.997435] xc2028 7-0061: type set to XCeive xc2028/xc3028 tuner
[   78.997440] em2882/3 #0: em2882/3 #0/2: xc3028 attached
[   78.997442] DVB: registering new adapter (em2882/3 #0)
[   78.997449] usb 3-1: DVB: registering adapter 0 frontend 0 (Zarlink
MT352 DVB-T)...
[   78.997536] xc2028 7-0061: Loading 80 firmware images from
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[   78.997891] em2882/3 #0: DVB extension successfully initialized
[   78.997894] em2882/3 #0: Registering input extension
[   78.997966] Registered IR keymap rc-terratec-cinergy-xs
[   78.998072] input: em28xx IR (em2882/3 #0) as
/devices/pci0000:00/0000:00:14.0/usb3/3-1/rc/rc0/input21
[   78.998143] rc0: em28xx IR (em2882/3 #0) as
/devices/pci0000:00/0000:00:14.0/usb3/3-1/rc/rc0
[   78.998212] em2882/3 #0: Input extension successfully initalized

and dvb adapter is working without problems.

Could you submit my patch?

Thank you and Regards
Giovanni
