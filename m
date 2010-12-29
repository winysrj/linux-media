Return-path: <mchehab@gaivota>
Received: from wp123.webpack.hosteurope.de ([80.237.132.130]:42020 "EHLO
	wp123.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753258Ab0L2PI1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 10:08:27 -0500
Message-ID: <4D1B4A7E.20503@stefankriwanek.de>
Date: Wed, 29 Dec 2010 15:49:34 +0100
From: Stefan Kriwanek <mail@stefankriwanek.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: support for IR remote TerraTec Cinergy T USB XXS
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig95D18367286B0613C5C3D7B8"
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig95D18367286B0613C5C3D7B8
Content-Type: multipart/mixed;
 boundary="------------070200030009020701080100"

This is a multi-part message in MIME format.
--------------070200030009020701080100
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Dear linux-media developers,

I think I found a bug in the support of the  TerraTec Cinergy T USB XXS
remote control, or maybe just a new hardware revision appeared.

When I recently bought such a USB-stick I found the remote not working,
instead 'dib0700: Unknown remote controller key' lines appearing in
syslog on each keypress. The dvb_usb_dib0700 kernel module got
autoloaded by my Ubuntu 10.10. I am using current hg revision of v4l-dvb
and load the kernel module using the 'dvb_usb_dib0700_ir_proto=3D0'
option. Simply adding the keycodes to the driver file
(linux/drivers/media/dvb/dvb-usb/dib0700_devices.c,
patch appended) made things work.

However, by incident I found those very keycodes are already defined in
the linux/drivers/media/IR/keymaps/rc-nec-terratec-cinergy-xs.c file, so
maybe the issue is just about loading it?

'lsusb' lists my device as
Bus 001 Device 006: ID 0ccd:00ab TerraTec Electronic GmbH
despite I do not own the 'HD' version of the device, your wiki
http://linuxtv.org/wiki/index.php/TerraTec_Cinergy_T_USB_XXS
says that ID corresponds to. The output of 'lsusb -v' is appended to
this mail.

'cat /proc/bus/input/devices' lists the input device as
I: Bus=3D0003 Vendor=3D0ccd Product=3D00ab Version=3D0100
N: Name=3D"IR-receiver inside an USB DVB receiver"
P: Phys=3Dusb-0000:00:12.2-2/ir0
S: Sysfs=3D/devices/pci0000:00/0000:00:12.2/usb1/1-2/input/input13
U: Uniq=3D
H: Handlers=3Dkbd event8
B: EV=3D3
B: KEY=3D14afc336 2b4285f00000000 0 480158000 219040000801 9e96c000000000=

90024010004ffc

I hope you could add support for my stick; I'd be happy to provide
further information if necessary.

Best regards
Stefan


--------------070200030009020701080100
Content-Type: text/x-patch;
 name="terratec_cinergy_t_usb_xxs.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="terratec_cinergy_t_usb_xxs.patch"

diff -r abd3aac6644e linux/drivers/media/dvb/dvb-usb/dib0700_devices.c
--- a/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Fri Jul 02 00:38:=
54 2010 -0300
+++ b/linux/drivers/media/dvb/dvb-usb/dib0700_devices.c	Wed Dec 29 13:17:=
41 2010 +0100
@@ -831,6 +831,57 @@
 	{ 0x4540, KEY_RECORD }, /* Font 'Size' for Teletext */
 	{ 0x4541, KEY_SCREEN }, /*  Full screen toggle, 'Hold' for Teletext */
 	{ 0x4542, KEY_SELECT }, /* Select video input, 'Select' for Teletext */=

+
+	/* Key codes for the Terratec Cinergy T USB XXS remote, copied from rc-=
nec-terratec-cinergy-xs.c
+	   set dvb_usb_dib0700_ir_proto=3D0 */
+	{ 0x1401, KEY_POWER2 },
+	{ 0x1402, KEY_1 },
+	{ 0x1403, KEY_2 },
+	{ 0x1404, KEY_3 },
+	{ 0x1405, KEY_4 },
+	{ 0x1406, KEY_5 },
+	{ 0x1407, KEY_6 },
+	{ 0x1408, KEY_7 },
+	{ 0x1409, KEY_8 },
+	{ 0x140a, KEY_9 },
+	{ 0x140b, KEY_TUNER },  /* AV */
+	{ 0x140c, KEY_0 },
+	{ 0x140d, KEY_MODE }, /* A.B, alternatively match to KEY_AB? */
+	{ 0x140f, KEY_EPG }, /* EPG / GUIDE */
+	{ 0x1410, KEY_UP },
+	{ 0x1411, KEY_LEFT },
+	{ 0x1412, KEY_OK },
+	{ 0x1413, KEY_RIGHT },
+	{ 0x1414, KEY_DOWN },
+	{ 0x1416, KEY_INFO },
+	{ 0x1417, KEY_RED },
+	{ 0x1418, KEY_GREEN },
+	{ 0x1419, KEY_YELLOW },
+	{ 0x141a, KEY_BLUE },
+	{ 0x141b, KEY_CHANNELUP },
+	{ 0x141c, KEY_VOLUMEUP },
+	{ 0x141d, KEY_MUTE },
+	{ 0x141e, KEY_VOLUMEDOWN },
+	{ 0x141f, KEY_CHANNELDOWN },
+	{ 0x1440, KEY_PAUSE },
+	{ 0x1441, KEY_HOME },
+	{ 0x1442, KEY_MENU },
+	{ 0x1443, KEY_SUBTITLE },
+	{ 0x1444, KEY_TEXT },
+	{ 0x1445, KEY_DELETE },
+	{ 0x1446, KEY_TV },
+	{ 0x1447, KEY_DVD },
+	{ 0x1448, KEY_STOP },
+	{ 0x1449, KEY_VIDEO },
+	{ 0x144a, KEY_RADIO }, /* Music */
+	{ 0x144b, KEY_CAMERA }, /* Pic */
+	{ 0x144c, KEY_PLAY },
+	{ 0x144d, KEY_BACKSPACE },
+	{ 0x144e, KEY_REWIND },
+	{ 0x144f, KEY_FASTFORWARD },
+	{ 0x1454, KEY_LAST },
+	{ 0x1458, KEY_RECORD },
+	{ 0x145c, KEY_NEXT },
 };
=20
 /* STK7700P: Hauppauge Nova-T Stick, AVerMedia Volar */


--------------070200030009020701080100
Content-Type: text/plain;
 name="lsusb-v"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="lsusb-v"

Bus 001 Device 006: ID 0ccd:00ab TerraTec Electronic GmbH=20
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0=20
  bDeviceProtocol         0=20
  bMaxPacketSize0        64
  idVendor           0x0ccd TerraTec Electronic GmbH
  idProduct          0x00ab=20
  bcdDevice            1.00
  iManufacturer           1 TerraTec GmbH
  iProduct                2 Cinergy T XXS
  iSerial                 3 0000000001
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0=20
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0=20
      bInterfaceProtocol      0=20
      iInterface              0=20
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0=20
  bDeviceProtocol         0=20
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)




--------------070200030009020701080100--

--------------enig95D18367286B0613C5C3D7B8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk0bSoMACgkQ4qZRfYFVouBBJgCfc+enShtuK54RACIiP0CXadYE
GIcAn0h1a6Ll0Svi3cjMUN16ZMj9R/IM
=Yhq5
-----END PGP SIGNATURE-----

--------------enig95D18367286B0613C5C3D7B8--
