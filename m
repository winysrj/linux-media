Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from omta04ps.mx.bigpond.com ([144.140.83.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ptay1685@Bigpond.net.au>) id 1JfMED-00046v-R7
	for linux-dvb@linuxtv.org; Fri, 28 Mar 2008 22:35:17 +0100
Received: from oaamta04ps.mx.bigpond.com ([58.172.153.185])
	by omta04ps.mx.bigpond.com with ESMTP id
	<20080328213429.WUEL25793.omta04ps.mx.bigpond.com@oaamta04ps.mx.bigpond.com>
	for <linux-dvb@linuxtv.org>; Fri, 28 Mar 2008 21:34:29 +0000
Message-ID: <000001c8906a$ff079800$6e00a8c0@barny1e59e583e>
From: "ptay1685" <ptay1685@Bigpond.net.au>
To: <linux-dvb@linuxtv.org>
References: <007201c88ce2$5909c850$6e00a8c0@barny1e59e583e>	<47E6DD2D.9040204@iki.fi>
	<001501c88ee1$f0466470$6e00a8c0@barny1e59e583e>
	<47E9AEFF.7030504@gmail.com>
	<002301c88ee9$fd998500$6e00a8c0@barny1e59e583e>
	<47E9B972.3050809@gmail.com>
Date: Fri, 28 Mar 2008 01:05:56 +1100
MIME-Version: 1.0
Subject: Re: [linux-dvb] leadtek dtv dongle lsusb
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0483406653=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0483406653==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0030_01C8906F.E06D53D0"

This is a multi-part message in MIME format.

------=_NextPart_000_0030_01C8906F.E06D53D0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Here is the output from lsusb -v:
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++++++++
Bus 005 Device 001: ID 0000:0000=20

Device Descriptor:

bLength 18

bDescriptorType 1

bcdUSB 1.10

bDeviceClass 9 Hub

bDeviceSubClass 0 Unused

bDeviceProtocol 0 Full speed (or root) hub

bMaxPacketSize0 64

idVendor 0x0000=20

idProduct 0x0000=20

bcdDevice 2.06

iManufacturer 3=20

iProduct 2=20

iSerial 1=20

bNumConfigurations 1

Configuration Descriptor:

bLength 9

bDescriptorType 2

wTotalLength 25

bNumInterfaces 1

bConfigurationValue 1

iConfiguration 0=20

bmAttributes 0xe0

Self Powered

Remote Wakeup

MaxPower 0mA

Interface Descriptor:

bLength 9

bDescriptorType 4

bInterfaceNumber 0

bAlternateSetting 0

bNumEndpoints 1

bInterfaceClass 9 Hub

bInterfaceSubClass 0 Unused

bInterfaceProtocol 0 Full speed (or root) hub

iInterface 0=20

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x81 EP 1 IN

bmAttributes 3

Transfer Type Interrupt

Synch Type None

Usage Type Data

wMaxPacketSize 0x0002 1x 2 bytes

bInterval 255

Bus 002 Device 003: ID 0413:6f01 Leadtek Research, Inc.=20

Device Descriptor:

bLength 18

bDescriptorType 1

bcdUSB 2.00

bDeviceClass 0 (Defined at Interface level)

bDeviceSubClass 0=20

bDeviceProtocol 0=20

bMaxPacketSize0 64

idVendor 0x0413 Leadtek Research, Inc.

idProduct 0x6f01=20

bcdDevice 0.02

iManufacturer 1=20

iProduct 2=20

iSerial 3=20

bNumConfigurations 1

Configuration Descriptor:

bLength 9

bDescriptorType 2

wTotalLength 46

bNumInterfaces 1

bConfigurationValue 1

iConfiguration 0=20

bmAttributes 0xa0

Remote Wakeup

MaxPower 500mA

Interface Descriptor:

bLength 9

bDescriptorType 4

bInterfaceNumber 0

bAlternateSetting 0

bNumEndpoints 4

bInterfaceClass 255 Vendor Specific Class

bInterfaceSubClass 0=20

bInterfaceProtocol 0=20

iInterface 0=20

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x01 EP 1 OUT

bmAttributes 2

Transfer Type Bulk

Synch Type None

Usage Type Data

wMaxPacketSize 0x0200 1x 512 bytes

bInterval 1

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x81 EP 1 IN

bmAttributes 3

Transfer Type Interrupt

Synch Type None

Usage Type Data

wMaxPacketSize 0x0040 1x 64 bytes

bInterval 10

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x82 EP 2 IN

bmAttributes 2

Transfer Type Bulk

Synch Type None

Usage Type Data

wMaxPacketSize 0x0200 1x 512 bytes

bInterval 1

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x83 EP 3 IN

bmAttributes 2

Transfer Type Bulk

Synch Type None

Usage Type Data

wMaxPacketSize 0x0200 1x 512 bytes

bInterval 1

Bus 002 Device 002: ID 0413:6f01 Leadtek Research, Inc.=20

Device Descriptor:

bLength 18

bDescriptorType 1

bcdUSB 2.00

bDeviceClass 0 (Defined at Interface level)

bDeviceSubClass 0=20

bDeviceProtocol 0=20

bMaxPacketSize0 64

idVendor 0x0413 Leadtek Research, Inc.

idProduct 0x6f01=20

bcdDevice 0.02

iManufacturer 1=20

iProduct 2=20

iSerial 3=20

bNumConfigurations 1

Configuration Descriptor:

bLength 9

bDescriptorType 2

wTotalLength 46

bNumInterfaces 1

bConfigurationValue 1

iConfiguration 0=20

bmAttributes 0xa0

Remote Wakeup

MaxPower 500mA

Interface Descriptor:

bLength 9

bDescriptorType 4

bInterfaceNumber 0

bAlternateSetting 0

bNumEndpoints 4

bInterfaceClass 255 Vendor Specific Class

bInterfaceSubClass 0=20

bInterfaceProtocol 0=20

iInterface 0=20

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x01 EP 1 OUT

bmAttributes 2

Transfer Type Bulk

Synch Type None

Usage Type Data

wMaxPacketSize 0x0200 1x 512 bytes

bInterval 1

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x81 EP 1 IN

bmAttributes 3

Transfer Type Interrupt

Synch Type None

Usage Type Data

wMaxPacketSize 0x0040 1x 64 bytes

bInterval 10

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x82 EP 2 IN

bmAttributes 2

Transfer Type Bulk

Synch Type None

Usage Type Data

wMaxPacketSize 0x0200 1x 512 bytes

bInterval 1

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x83 EP 3 IN

bmAttributes 2

Transfer Type Bulk

Synch Type None

Usage Type Data

wMaxPacketSize 0x0200 1x 512 bytes

bInterval 1

Bus 002 Device 001: ID 0000:0000=20

Device Descriptor:

bLength 18

bDescriptorType 1

bcdUSB 2.00

bDeviceClass 9 Hub

bDeviceSubClass 0 Unused

bDeviceProtocol 1 Single TT

bMaxPacketSize0 64

idVendor 0x0000=20

idProduct 0x0000=20

bcdDevice 2.06

iManufacturer 3=20

iProduct 2=20

iSerial 1=20

bNumConfigurations 1

Configuration Descriptor:

bLength 9

bDescriptorType 2

wTotalLength 25

bNumInterfaces 1

bConfigurationValue 1

iConfiguration 0=20

bmAttributes 0xe0

Self Powered

Remote Wakeup

MaxPower 0mA

Interface Descriptor:

bLength 9

bDescriptorType 4

bInterfaceNumber 0

bAlternateSetting 0

bNumEndpoints 1

bInterfaceClass 9 Hub

bInterfaceSubClass 0 Unused

bInterfaceProtocol 0 Full speed (or root) hub

iInterface 0=20

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x81 EP 1 IN

bmAttributes 3

Transfer Type Interrupt

Synch Type None

Usage Type Data

wMaxPacketSize 0x0004 1x 4 bytes

bInterval 12

Bus 004 Device 001: ID 0000:0000=20

Device Descriptor:

bLength 18

bDescriptorType 1

bcdUSB 1.10

bDeviceClass 9 Hub

bDeviceSubClass 0 Unused

bDeviceProtocol 0 Full speed (or root) hub

bMaxPacketSize0 64

idVendor 0x0000=20

idProduct 0x0000=20

bcdDevice 2.06

iManufacturer 3=20

iProduct 2=20

iSerial 1=20

bNumConfigurations 1

Configuration Descriptor:

bLength 9

bDescriptorType 2

wTotalLength 25

bNumInterfaces 1

bConfigurationValue 1

iConfiguration 0=20

bmAttributes 0xe0

Self Powered

Remote Wakeup

MaxPower 0mA

Interface Descriptor:

bLength 9

bDescriptorType 4

bInterfaceNumber 0

bAlternateSetting 0

bNumEndpoints 1

bInterfaceClass 9 Hub

bInterfaceSubClass 0 Unused

bInterfaceProtocol 0 Full speed (or root) hub

iInterface 0=20

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x81 EP 1 IN

bmAttributes 3

Transfer Type Interrupt

Synch Type None

Usage Type Data

wMaxPacketSize 0x0002 1x 2 bytes

bInterval 255

Bus 001 Device 001: ID 0000:0000=20

Device Descriptor:

bLength 18

bDescriptorType 1

bcdUSB 2.00

bDeviceClass 9 Hub

bDeviceSubClass 0 Unused

bDeviceProtocol 1 Single TT

bMaxPacketSize0 64

idVendor 0x0000=20

idProduct 0x0000=20

bcdDevice 2.06

iManufacturer 3=20

iProduct 2=20

iSerial 1=20

bNumConfigurations 1

Configuration Descriptor:

bLength 9

bDescriptorType 2

wTotalLength 25

bNumInterfaces 1

bConfigurationValue 1

iConfiguration 0=20

bmAttributes 0xe0

Self Powered

Remote Wakeup

MaxPower 0mA

Interface Descriptor:

bLength 9

bDescriptorType 4

bInterfaceNumber 0

bAlternateSetting 0

bNumEndpoints 1

bInterfaceClass 9 Hub

bInterfaceSubClass 0 Unused

bInterfaceProtocol 0 Full speed (or root) hub

iInterface 0=20

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x81 EP 1 IN

bmAttributes 3

Transfer Type Interrupt

Synch Type None

Usage Type Data

wMaxPacketSize 0x0004 1x 4 bytes

bInterval 12

Bus 003 Device 002: ID 045e:0053 Microsoft Corp. Optical Mouse

Device Descriptor:

bLength 18

bDescriptorType 1

bcdUSB 1.10

bDeviceClass 0 (Defined at Interface level)

bDeviceSubClass 0=20

bDeviceProtocol 0=20

bMaxPacketSize0 8

idVendor 0x045e Microsoft Corp.

idProduct 0x0053 Optical Mouse

bcdDevice 3.00

iManufacturer 1=20

iProduct 3=20

iSerial 0=20

bNumConfigurations 1

Configuration Descriptor:

bLength 9

bDescriptorType 2

wTotalLength 34

bNumInterfaces 1

bConfigurationValue 1

iConfiguration 0=20

bmAttributes 0xa0

Remote Wakeup

MaxPower 100mA

Interface Descriptor:

bLength 9

bDescriptorType 4

bInterfaceNumber 0

bAlternateSetting 0

bNumEndpoints 1

bInterfaceClass 3 Human Interface Device

bInterfaceSubClass 1 Boot Interface Subclass

bInterfaceProtocol 2 Mouse

iInterface 0=20

HID Device Descriptor:

bLength 9

bDescriptorType 33

bcdHID 1.10

bCountryCode 0 Not supported

bNumDescriptors 1

bDescriptorType 34 Report

wDescriptorLength 72

Report Descriptors:=20

** UNAVAILABLE **

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x81 EP 1 IN

bmAttributes 3

Transfer Type Interrupt

Synch Type None

Usage Type Data

wMaxPacketSize 0x0004 1x 4 bytes

bInterval 10

Bus 003 Device 004: ID 045e:002b Microsoft Corp. Internet Keyboard Pro

Device Descriptor:

bLength 18

bDescriptorType 1

bcdUSB 1.10

bDeviceClass 0 (Defined at Interface level)

bDeviceSubClass 0=20

bDeviceProtocol 0=20

bMaxPacketSize0 8

idVendor 0x045e Microsoft Corp.

idProduct 0x002b Internet Keyboard Pro

bcdDevice 1.14

iManufacturer 0=20

iProduct 1=20

iSerial 0=20

bNumConfigurations 1

Configuration Descriptor:

bLength 9

bDescriptorType 2

wTotalLength 59

bNumInterfaces 2

bConfigurationValue 1

iConfiguration 1=20

bmAttributes 0xa0

Remote Wakeup

MaxPower 100mA

Interface Descriptor:

bLength 9

bDescriptorType 4

bInterfaceNumber 0

bAlternateSetting 0

bNumEndpoints 1

bInterfaceClass 3 Human Interface Device

bInterfaceSubClass 1 Boot Interface Subclass

bInterfaceProtocol 1 Keyboard

iInterface 1=20

HID Device Descriptor:

bLength 9

bDescriptorType 33

bcdHID 1.10

bCountryCode 0 Not supported

bNumDescriptors 1

bDescriptorType 34 Report

wDescriptorLength 54

Report Descriptors:=20

** UNAVAILABLE **

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x81 EP 1 IN

bmAttributes 3

Transfer Type Interrupt

Synch Type None

Usage Type Data

wMaxPacketSize 0x0008 1x 8 bytes

bInterval 10

Interface Descriptor:

bLength 9

bDescriptorType 4

bInterfaceNumber 1

bAlternateSetting 0

bNumEndpoints 1

bInterfaceClass 3 Human Interface Device

bInterfaceSubClass 0 No Subclass

bInterfaceProtocol 0 None

iInterface 1=20

HID Device Descriptor:

bLength 9

bDescriptorType 33

bcdHID 1.10

bCountryCode 0 Not supported

bNumDescriptors 1

bDescriptorType 34 Report

wDescriptorLength 50

Report Descriptors:=20

** UNAVAILABLE **

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x82 EP 2 IN

bmAttributes 3

Transfer Type Interrupt

Synch Type None

Usage Type Data

wMaxPacketSize 0x0003 1x 3 bytes

bInterval 10

Bus 003 Device 003: ID 0451:1446 Texas Instruments, Inc. TUSB2040/2070 =
Hub

Device Descriptor:

bLength 18

bDescriptorType 1

bcdUSB 1.10

bDeviceClass 9 Hub

bDeviceSubClass 0 Unused

bDeviceProtocol 0 Full speed (or root) hub

bMaxPacketSize0 8

idVendor 0x0451 Texas Instruments, Inc.

idProduct 0x1446 TUSB2040/2070 Hub

bcdDevice 1.10

iManufacturer 0=20

iProduct 0=20

iSerial 0=20

bNumConfigurations 1

Configuration Descriptor:

bLength 9

bDescriptorType 2

wTotalLength 34

bNumInterfaces 1

bConfigurationValue 1

iConfiguration 0=20

bmAttributes 0xe0

Self Powered

Remote Wakeup

MaxPower 100mA

Interface Descriptor:

bLength 9

bDescriptorType 4

bInterfaceNumber 0

bAlternateSetting 0

bNumEndpoints 1

bInterfaceClass 9 Hub

bInterfaceSubClass 0 Unused

bInterfaceProtocol 0 Full speed (or root) hub

iInterface 0=20

UNRECOGNIZED: 09 29 04 09 00 32 64 00 1e

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x81 EP 1 IN

bmAttributes 3

Transfer Type Interrupt

Synch Type None

Usage Type Data

wMaxPacketSize 0x0001 1x 1 bytes

bInterval 255

Bus 003 Device 001: ID 0000:0000=20

Device Descriptor:

bLength 18

bDescriptorType 1

bcdUSB 1.10

bDeviceClass 9 Hub

bDeviceSubClass 0 Unused

bDeviceProtocol 0 Full speed (or root) hub

bMaxPacketSize0 64

idVendor 0x0000=20

idProduct 0x0000=20

bcdDevice 2.06

iManufacturer 3=20

iProduct 2=20

iSerial 1=20

bNumConfigurations 1

Configuration Descriptor:

bLength 9

bDescriptorType 2

wTotalLength 25

bNumInterfaces 1

bConfigurationValue 1

iConfiguration 0=20

bmAttributes 0xe0

Self Powered

Remote Wakeup

MaxPower 0mA

Interface Descriptor:

bLength 9

bDescriptorType 4

bInterfaceNumber 0

bAlternateSetting 0

bNumEndpoints 1

bInterfaceClass 9 Hub

bInterfaceSubClass 0 Unused

bInterfaceProtocol 0 Full speed (or root) hub

iInterface 0=20

Endpoint Descriptor:

bLength 7

bDescriptorType 5

bEndpointAddress 0x81 EP 1 IN

bmAttributes 3

Transfer Type Interrupt

Synch Type None

Usage Type Data

wMaxPacketSize 0x0002 1x 2 bytes

bInterval 255


  ----- Original Message -----=20
  From: John=20
  To: ptay1685=20
  Cc: linux-dvb@linuxtv.org=20
  Sent: Wednesday, March 26, 2008 1:48 PM
  Subject: Re: [linux-dvb] leadtek dtv dongle


  please respond to the list -

  ptay1685 wrote:=20
    Thanks.

    Just my luck. First off I get a Nebula usb DigiTV which never worked =
owing to an problem with ny nforce2 usb controller (i found out when it =
was too late), and which came with suspect WIndows software. So before I =
bought my two Leadtek dongles I checked the DVB wikipedia to make sure I =
got a fully Linux supported device. Now I have two new usb dongles =
neither of which work with Linux. You can't bloody win can you? At least =
they come with great WIndows software, which is more than you can say =
for the Nebula.

    I can now use the Nebula with Linux but the leadtek software under =
WIndows is so good, that now I simply boot Windows to do my DVB stuff, =
and sometimes use Linux to author the DVD's (DeVeDe).

    I guess this situation will persist until hardware vendors decide to =
support Linux. Unfortunately I will probably be six feet under by then.

    I would certainly be interested in a fix for this situation but its =
hardly worth anyone putting in a lot of effort for just one person or at =
most a handful of people. But if you are able / willing to do something =
to remedy this problem I will certainly be very grateful.

    Or perhaps one day I will work up the motivation to patch the code =
as you did - but i dare not hold my breath waiting for that to happen!


  1) the fix is simple and someone on the list will be able to push =
through a simple patch, if all that is involved is added another =
identifier to recognise your device.=20
  2) we still need your lsusb -v to confirm this.=20

  if you can do even a few minutes of effort to determine the required =
information, you might be surprised to find others in your situation =
and/or those capable of helping.=20






      firstly: lsusb is located in the usbutils package so you may need =
to install it, or you need to prefix the command with its location=20
      i.e. /sbin/lsusb. Please try this first and post the result back =
to the list. (with the -v option please)

      secondly in reference to my patch below.
      I never heard anything more from the list about it and I have no =
reason to believe it was ever incorporated as a patch. I suspect this =
dongle is a variant sold only in Australia (where you and I are from =
obviously) and so the demand is relatively small - thus no one else was =
interested. I posted more for people like yourself for whom my fix may =
help.=20

      The only thing this patch did is add an extra identifier so that =
the dongle was recognized. Now that said, I suspect there is an even =
more recent variant released in the last 2/3 months (right after I =
bought mine :( ) which may have a different identifier again. So the =
result of lsusb is even more important.

      Unfortunately I got distracted after I got my dongle recognized =
and haven't made it fully work yet (with MythTv) - but if you are =
interested I might have another go at it.=20

      I also note the large number of dibcom related posts in recent =
months which will have a direct bearing on this dongle. So recent =
versions of the dvb code are essential.=20

      Cheers,
      J

      ptay1685 wrote:=20
How do I tell the usb-id? Tried to do a lsusb -v but the command is=20
unrecognised.

Note that the Leadtek device is not actually recognised by the kernel =
(shown=20
via dmesg).

The following is from a previous conversation on this mailing list and =
might=20
give you the info you need:
_________________________________________________________________________=
______

Hi,

How do I get a patch incorporated into the dvb kernel section ?

After recently purchasing a LeadTek WinFast DTV Dongle I rapidly
discovered it was the variant that was not recognized in the kernel

i.e. as previously reported at:
http://www.linuxtv.org/pipermail/linux-dvb/2007-December/022373.html
http://www.linuxtv.org/pipermail/linux-dvb/2008-January/023175.html

its device ids are: (lsusb)
ID 0413:6f01 Leadtek Research, Inc.

Rather than make the changes suggested by previous posters I set about
making a script and associated kernel patches to automatically do this.
My motivation was simple: I use a laptop with an ATI graphics card and
fedora 8. I find the best drivers for this card are currently from Livna
and are updated monthly (and changes are significant at the moment i.e.
see the phoronix forum). So I would need to do this repeatedly.

In my patch I add an identifier (USB_PID_WINFAST_DTV_DONGLE_STK7700P_B)
and modify the table appropriately

When I plug it in I now see in my messages log
kernel: usb 1-4: new high speed USB device using ehci_hcd and address 9
kernel: usb 1-4: configuration #1 chosen from 1 choice
kernel: dib0700: loaded with support for 2 different device-types
kernel: dvb-usb: found a 'Leadtek Winfast DTV Dongle B (STK7700P based)'
in cold state, will try to load a firmware
kernel: dvb-usb: downloading firmware from file 'dvb-usb-dib0700-01.fw'
kernel: dib0700: firmware started successfully.
kernel: dvb-usb: found a 'Leadtek Winfast DTV Dongle B (STK7700P based)'
in warm state.
kernel: dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
kernel: DVB: registering new adapter (Leadtek Winfast DTV Dongle B
(STK7700P based))
kernel: DVB: registering frontend 0 (DiBcom 7000PC)...
kernel: MT2060: successfully identified (IF1 =3D 1220)
kernel: dvb-usb: Leadtek Winfast DTV Dongle B (STK7700P based)
successfully initialized and connected.
kernel: usbcore: registered new interface driver dvb_usb_dib0700


My kernel patch ( other scripts to patch the Fedora 8 src rpm's
available on request)
----------------
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c       2008-02-13
10:05:13.000000000 +1100
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c       2008-02-13
10:22:16.000000000 +1100
@@ -280,6 +280,7 @@ struct usb_device_id dib0700_usb_id_tabl
                { USB_DEVICE(USB_VID_LEADTEK,
USB_PID_WINFAST_DTV_DONGLE_STK7700P) },
                { USB_DEVICE(USB_VID_HAUPPAUGE,
USB_PID_HAUPPAUGE_NOVA_T_STICK_2) },
                { USB_DEVICE(USB_VID_AVERMEDIA,
USB_PID_AVERMEDIA_VOLAR_2) },
+               { USB_DEVICE(USB_VID_LEADTEK,
USB_PID_WINFAST_DTV_DONGLE_STK7700P_B) },
                { }             /* Terminating entry */
};
MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -321,7 +322,7 @@ struct dvb_usb_device_properties dib0700
                        },
                },

-               .num_device_descs =3D 6,
+               .num_device_descs =3D 7,
                .devices =3D {
                        {   "DiBcom STK7700P reference design",
                                { &dib0700_usb_id_table[0],
&dib0700_usb_id_table[1] },
@@ -346,6 +347,10 @@ struct dvb_usb_device_properties dib0700
                        {   "Leadtek Winfast DTV Dongle (STK7700P
based)",
                                { &dib0700_usb_id_table[8], NULL },
                                { NULL },
+                       },
+                       {   "Leadtek Winfast DTV Dongle B (STK7700P
based)",
+                               { &dib0700_usb_id_table[11], NULL },
+                               { NULL },
                        }
                }
        }, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h   2008-02-13
10:05:13.000000000 +1100
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h   2008-02-13
10:18:00.000000000 +1100
@@ -148,6 +148,7 @@
#define USB_PID_WINFAST_DTV_DONGLE_COLD                        0x6025
#define USB_PID_WINFAST_DTV_DONGLE_WARM                        0x6026
#define USB_PID_WINFAST_DTV_DONGLE_STK7700P            0x6f00
+#define USB_PID_WINFAST_DTV_DONGLE_STK7700P_B          0x6f01
#define USB_PID_GENPIX_8PSK_COLD                       0x0200
#define USB_PID_GENPIX_8PSK_WARM                       0x0201
#define USB_PID_SIGMATEK_DVB_110                       0x6610



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

----- Original Message -----=20
From: "Antti Palosaari" <crope@iki.fi>
To: "ptay1685" <ptay1685@Bigpond.net.au>
Cc: <linux-dvb@linuxtv.org>
Sent: Monday, March 24, 2008 9:43 AM
Subject: Re: [linux-dvb] leadtek dtv dongle


  ptay1685 wrote:
    Any news about the new version of the dtv dongle? Still does not =
work
with the latest v4l sources. Anyone know whats happening?

Many thanks,

Phil T.
      Can you say what is usb-id of your device? Also lsusb -v could be =
nice
to see.

regards
Antti
--=20
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb=20
   =20

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
 =20



------=_NextPart_000_0030_01C8906F.E06D53D0
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE></TITLE>
<META http-equiv=3DContent-Type =
content=3Dtext/html;charset=3DISO-8859-1>
<META content=3D"MSHTML 6.00.6000.16608" name=3DGENERATOR></HEAD>
<BODY text=3D#000000 bgColor=3D#ffffff>
<DIV><FONT face=3DArial size=3D2>Here is the output from lsusb =
-v:</FONT></DIV>
<DIV><FONT face=3DArial=20
size=3D2>++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++</FONT></DIV>
<DIV><FONT face=3DArial size=3D2><FONT size=3D2>
<P>Bus 005 Device 001: ID 0000:0000 </P>
<P>Device Descriptor:</P>
<P>bLength 18</P>
<P>bDescriptorType 1</P>
<P>bcdUSB 1.10</P>
<P>bDeviceClass 9 Hub</P>
<P>bDeviceSubClass 0 Unused</P>
<P>bDeviceProtocol 0 Full speed (or root) hub</P>
<P>bMaxPacketSize0 64</P>
<P>idVendor 0x0000 </P>
<P>idProduct 0x0000 </P>
<P>bcdDevice 2.06</P>
<P>iManufacturer 3 </P>
<P>iProduct 2 </P>
<P>iSerial 1 </P>
<P>bNumConfigurations 1</P>
<P>Configuration Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 2</P>
<P>wTotalLength 25</P>
<P>bNumInterfaces 1</P>
<P>bConfigurationValue 1</P>
<P>iConfiguration 0 </P>
<P>bmAttributes 0xe0</P>
<P>Self Powered</P>
<P>Remote Wakeup</P>
<P>MaxPower 0mA</P>
<P>Interface Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 4</P>
<P>bInterfaceNumber 0</P>
<P>bAlternateSetting 0</P>
<P>bNumEndpoints 1</P>
<P>bInterfaceClass 9 Hub</P>
<P>bInterfaceSubClass 0 Unused</P>
<P>bInterfaceProtocol 0 Full speed (or root) hub</P>
<P>iInterface 0 </P>
<P>Endpoint Descriptor:</P>
<P>bLength 7</P>
<P>bDescriptorType 5</P>
<P>bEndpointAddress 0x81 EP 1 IN</P>
<P>bmAttributes 3</P>
<P>Transfer Type Interrupt</P>
<P>Synch Type None</P>
<P>Usage Type Data</P>
<P>wMaxPacketSize 0x0002 1x 2 bytes</P>
<P>bInterval 255</P>
<P>Bus 002 Device 003: ID 0413:6f01 Leadtek Research, Inc. </P>
<P>Device Descriptor:</P>
<P>bLength 18</P>
<P>bDescriptorType 1</P>
<P>bcdUSB 2.00</P>
<P>bDeviceClass 0 (Defined at Interface level)</P>
<P>bDeviceSubClass 0 </P>
<P>bDeviceProtocol 0 </P>
<P>bMaxPacketSize0 64</P>
<P>idVendor 0x0413 Leadtek Research, Inc.</P>
<P>idProduct 0x6f01 </P>
<P>bcdDevice 0.02</P>
<P>iManufacturer 1 </P>
<P>iProduct 2 </P>
<P>iSerial 3 </P>
<P>bNumConfigurations 1</P>
<P>Configuration Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 2</P>
<P>wTotalLength 46</P>
<P>bNumInterfaces 1</P>
<P>bConfigurationValue 1</P>
<P>iConfiguration 0 </P>
<P>bmAttributes 0xa0</P>
<P>Remote Wakeup</P>
<P>MaxPower 500mA</P>
<P>Interface Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 4</P>
<P>bInterfaceNumber 0</P>
<P>bAlternateSetting 0</P>
<P>bNumEndpoints 4</P>
<P>bInterfaceClass 255 Vendor Specific Class</P>
<P>bInterfaceSubClass 0 </P>
<P>bInterfaceProtocol 0 </P>
<P>iInterface 0 </P>
<P>Endpoint Descriptor:</P>
<P>bLength 7</P>
<P>bDescriptorType 5</P>
<P>bEndpointAddress 0x01 EP 1 OUT</P>
<P>bmAttributes 2</P>
<P>Transfer Type Bulk</P>
<P>Synch Type None</P>
<P>Usage Type Data</P>
<P>wMaxPacketSize 0x0200 1x 512 bytes</P>
<P>bInterval 1</P>
<P>Endpoint Descriptor:</P>
<P>bLength 7</P>
<P>bDescriptorType 5</P>
<P>bEndpointAddress 0x81 EP 1 IN</P>
<P>bmAttributes 3</P>
<P>Transfer Type Interrupt</P>
<P>Synch Type None</P>
<P>Usage Type Data</P>
<P>wMaxPacketSize 0x0040 1x 64 bytes</P>
<P>bInterval 10</P>
<P>Endpoint Descriptor:</P>
<P>bLength 7</P>
<P>bDescriptorType 5</P>
<P>bEndpointAddress 0x82 EP 2 IN</P>
<P>bmAttributes 2</P>
<P>Transfer Type Bulk</P>
<P>Synch Type None</P>
<P>Usage Type Data</P>
<P>wMaxPacketSize 0x0200 1x 512 bytes</P>
<P>bInterval 1</P>
<P>Endpoint Descriptor:</P>
<P>bLength 7</P>
<P>bDescriptorType 5</P>
<P>bEndpointAddress 0x83 EP 3 IN</P>
<P>bmAttributes 2</P>
<P>Transfer Type Bulk</P>
<P>Synch Type None</P>
<P>Usage Type Data</P>
<P>wMaxPacketSize 0x0200 1x 512 bytes</P>
<P>bInterval 1</P>
<P>Bus 002 Device 002: ID 0413:6f01 Leadtek Research, Inc. </P>
<P>Device Descriptor:</P>
<P>bLength 18</P>
<P>bDescriptorType 1</P>
<P>bcdUSB 2.00</P>
<P>bDeviceClass 0 (Defined at Interface level)</P>
<P>bDeviceSubClass 0 </P>
<P>bDeviceProtocol 0 </P>
<P>bMaxPacketSize0 64</P>
<P>idVendor 0x0413 Leadtek Research, Inc.</P>
<P>idProduct 0x6f01 </P>
<P>bcdDevice 0.02</P>
<P>iManufacturer 1 </P>
<P>iProduct 2 </P>
<P>iSerial 3 </P>
<P>bNumConfigurations 1</P>
<P>Configuration Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 2</P>
<P>wTotalLength 46</P>
<P>bNumInterfaces 1</P>
<P>bConfigurationValue 1</P>
<P>iConfiguration 0 </P>
<P>bmAttributes 0xa0</P>
<P>Remote Wakeup</P>
<P>MaxPower 500mA</P>
<P>Interface Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 4</P>
<P>bInterfaceNumber 0</P>
<P>bAlternateSetting 0</P>
<P>bNumEndpoints 4</P>
<P>bInterfaceClass 255 Vendor Specific Class</P>
<P>bInterfaceSubClass 0 </P>
<P>bInterfaceProtocol 0 </P>
<P>iInterface 0 </P>
<P>Endpoint Descriptor:</P>
<P>bLength 7</P>
<P>bDescriptorType 5</P>
<P>bEndpointAddress 0x01 EP 1 OUT</P>
<P>bmAttributes 2</P>
<P>Transfer Type Bulk</P>
<P>Synch Type None</P>
<P>Usage Type Data</P>
<P>wMaxPacketSize 0x0200 1x 512 bytes</P>
<P>bInterval 1</P>
<P>Endpoint Descriptor:</P>
<P>bLength 7</P>
<P>bDescriptorType 5</P>
<P>bEndpointAddress 0x81 EP 1 IN</P>
<P>bmAttributes 3</P>
<P>Transfer Type Interrupt</P>
<P>Synch Type None</P>
<P>Usage Type Data</P>
<P>wMaxPacketSize 0x0040 1x 64 bytes</P>
<P>bInterval 10</P>
<P>Endpoint Descriptor:</P>
<P>bLength 7</P>
<P>bDescriptorType 5</P>
<P>bEndpointAddress 0x82 EP 2 IN</P>
<P>bmAttributes 2</P>
<P>Transfer Type Bulk</P>
<P>Synch Type None</P>
<P>Usage Type Data</P>
<P>wMaxPacketSize 0x0200 1x 512 bytes</P>
<P>bInterval 1</P>
<P>Endpoint Descriptor:</P>
<P>bLength 7</P>
<P>bDescriptorType 5</P>
<P>bEndpointAddress 0x83 EP 3 IN</P>
<P>bmAttributes 2</P>
<P>Transfer Type Bulk</P>
<P>Synch Type None</P>
<P>Usage Type Data</P>
<P>wMaxPacketSize 0x0200 1x 512 bytes</P>
<P>bInterval 1</P>
<P>Bus 002 Device 001: ID 0000:0000 </P>
<P>Device Descriptor:</P>
<P>bLength 18</P>
<P>bDescriptorType 1</P>
<P>bcdUSB 2.00</P>
<P>bDeviceClass 9 Hub</P>
<P>bDeviceSubClass 0 Unused</P>
<P>bDeviceProtocol 1 Single TT</P>
<P>bMaxPacketSize0 64</P>
<P>idVendor 0x0000 </P>
<P>idProduct 0x0000 </P>
<P>bcdDevice 2.06</P>
<P>iManufacturer 3 </P>
<P>iProduct 2 </P>
<P>iSerial 1 </P>
<P>bNumConfigurations 1</P>
<P>Configuration Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 2</P>
<P>wTotalLength 25</P>
<P>bNumInterfaces 1</P>
<P>bConfigurationValue 1</P>
<P>iConfiguration 0 </P>
<P>bmAttributes 0xe0</P>
<P>Self Powered</P>
<P>Remote Wakeup</P>
<P>MaxPower 0mA</P>
<P>Interface Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 4</P>
<P>bInterfaceNumber 0</P>
<P>bAlternateSetting 0</P>
<P>bNumEndpoints 1</P>
<P>bInterfaceClass 9 Hub</P>
<P>bInterfaceSubClass 0 Unused</P>
<P>bInterfaceProtocol 0 Full speed (or root) hub</P>
<P>iInterface 0 </P>
<P>Endpoint Descriptor:</P>
<P>bLength 7</P>
<P>bDescriptorType 5</P>
<P>bEndpointAddress 0x81 EP 1 IN</P>
<P>bmAttributes 3</P>
<P>Transfer Type Interrupt</P>
<P>Synch Type None</P>
<P>Usage Type Data</P>
<P>wMaxPacketSize 0x0004 1x 4 bytes</P>
<P>bInterval 12</P>
<P>Bus 004 Device 001: ID 0000:0000 </P>
<P>Device Descriptor:</P>
<P>bLength 18</P>
<P>bDescriptorType 1</P>
<P>bcdUSB 1.10</P>
<P>bDeviceClass 9 Hub</P>
<P>bDeviceSubClass 0 Unused</P>
<P>bDeviceProtocol 0 Full speed (or root) hub</P>
<P>bMaxPacketSize0 64</P>
<P>idVendor 0x0000 </P>
<P>idProduct 0x0000 </P>
<P>bcdDevice 2.06</P>
<P>iManufacturer 3 </P>
<P>iProduct 2 </P>
<P>iSerial 1 </P>
<P>bNumConfigurations 1</P>
<P>Configuration Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 2</P>
<P>wTotalLength 25</P>
<P>bNumInterfaces 1</P>
<P>bConfigurationValue 1</P>
<P>iConfiguration 0 </P>
<P>bmAttributes 0xe0</P>
<P>Self Powered</P>
<P>Remote Wakeup</P>
<P>MaxPower 0mA</P>
<P>Interface Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 4</P>
<P>bInterfaceNumber 0</P>
<P>bAlternateSetting 0</P>
<P>bNumEndpoints 1</P>
<P>bInterfaceClass 9 Hub</P>
<P>bInterfaceSubClass 0 Unused</P>
<P>bInterfaceProtocol 0 Full speed (or root) hub</P>
<P>iInterface 0 </P>
<P>Endpoint Descriptor:</P>
<P>bLength 7</P>
<P>bDescriptorType 5</P>
<P>bEndpointAddress 0x81 EP 1 IN</P>
<P>bmAttributes 3</P>
<P>Transfer Type Interrupt</P>
<P>Synch Type None</P>
<P>Usage Type Data</P>
<P>wMaxPacketSize 0x0002 1x 2 bytes</P>
<P>bInterval 255</P>
<P>Bus 001 Device 001: ID 0000:0000 </P>
<P>Device Descriptor:</P>
<P>bLength 18</P>
<P>bDescriptorType 1</P>
<P>bcdUSB 2.00</P>
<P>bDeviceClass 9 Hub</P>
<P>bDeviceSubClass 0 Unused</P>
<P>bDeviceProtocol 1 Single TT</P>
<P>bMaxPacketSize0 64</P>
<P>idVendor 0x0000 </P>
<P>idProduct 0x0000 </P>
<P>bcdDevice 2.06</P>
<P>iManufacturer 3 </P>
<P>iProduct 2 </P>
<P>iSerial 1 </P>
<P>bNumConfigurations 1</P>
<P>Configuration Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 2</P>
<P>wTotalLength 25</P>
<P>bNumInterfaces 1</P>
<P>bConfigurationValue 1</P>
<P>iConfiguration 0 </P>
<P>bmAttributes 0xe0</P>
<P>Self Powered</P>
<P>Remote Wakeup</P>
<P>MaxPower 0mA</P>
<P>Interface Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 4</P>
<P>bInterfaceNumber 0</P>
<P>bAlternateSetting 0</P>
<P>bNumEndpoints 1</P>
<P>bInterfaceClass 9 Hub</P>
<P>bInterfaceSubClass 0 Unused</P>
<P>bInterfaceProtocol 0 Full speed (or root) hub</P>
<P>iInterface 0 </P>
<P>Endpoint Descriptor:</P>
<P>bLength 7</P>
<P>bDescriptorType 5</P>
<P>bEndpointAddress 0x81 EP 1 IN</P>
<P>bmAttributes 3</P>
<P>Transfer Type Interrupt</P>
<P>Synch Type None</P>
<P>Usage Type Data</P>
<P>wMaxPacketSize 0x0004 1x 4 bytes</P>
<P>bInterval 12</P>
<P>Bus 003 Device 002: ID 045e:0053 Microsoft Corp. Optical Mouse</P>
<P>Device Descriptor:</P>
<P>bLength 18</P>
<P>bDescriptorType 1</P>
<P>bcdUSB 1.10</P>
<P>bDeviceClass 0 (Defined at Interface level)</P>
<P>bDeviceSubClass 0 </P>
<P>bDeviceProtocol 0 </P>
<P>bMaxPacketSize0 8</P>
<P>idVendor 0x045e Microsoft Corp.</P>
<P>idProduct 0x0053 Optical Mouse</P>
<P>bcdDevice 3.00</P>
<P>iManufacturer 1 </P>
<P>iProduct 3 </P>
<P>iSerial 0 </P>
<P>bNumConfigurations 1</P>
<P>Configuration Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 2</P>
<P>wTotalLength 34</P>
<P>bNumInterfaces 1</P>
<P>bConfigurationValue 1</P>
<P>iConfiguration 0 </P>
<P>bmAttributes 0xa0</P>
<P>Remote Wakeup</P>
<P>MaxPower 100mA</P>
<P>Interface Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 4</P>
<P>bInterfaceNumber 0</P>
<P>bAlternateSetting 0</P>
<P>bNumEndpoints 1</P>
<P>bInterfaceClass 3 Human Interface Device</P>
<P>bInterfaceSubClass 1 Boot Interface Subclass</P>
<P>bInterfaceProtocol 2 Mouse</P>
<P>iInterface 0 </P>
<P>HID Device Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 33</P>
<P>bcdHID 1.10</P>
<P>bCountryCode 0 Not supported</P>
<P>bNumDescriptors 1</P>
<P>bDescriptorType 34 Report</P>
<P>wDescriptorLength 72</P>
<P>Report Descriptors: </P>
<P>** UNAVAILABLE **</P>
<P>Endpoint Descriptor:</P>
<P>bLength 7</P>
<P>bDescriptorType 5</P>
<P>bEndpointAddress 0x81 EP 1 IN</P>
<P>bmAttributes 3</P>
<P>Transfer Type Interrupt</P>
<P>Synch Type None</P>
<P>Usage Type Data</P>
<P>wMaxPacketSize 0x0004 1x 4 bytes</P>
<P>bInterval 10</P>
<P>Bus 003 Device 004: ID 045e:002b Microsoft Corp. Internet Keyboard =
Pro</P>
<P>Device Descriptor:</P>
<P>bLength 18</P>
<P>bDescriptorType 1</P>
<P>bcdUSB 1.10</P>
<P>bDeviceClass 0 (Defined at Interface level)</P>
<P>bDeviceSubClass 0 </P>
<P>bDeviceProtocol 0 </P>
<P>bMaxPacketSize0 8</P>
<P>idVendor 0x045e Microsoft Corp.</P>
<P>idProduct 0x002b Internet Keyboard Pro</P>
<P>bcdDevice 1.14</P>
<P>iManufacturer 0 </P>
<P>iProduct 1 </P>
<P>iSerial 0 </P>
<P>bNumConfigurations 1</P>
<P>Configuration Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 2</P>
<P>wTotalLength 59</P>
<P>bNumInterfaces 2</P>
<P>bConfigurationValue 1</P>
<P>iConfiguration 1 </P>
<P>bmAttributes 0xa0</P>
<P>Remote Wakeup</P>
<P>MaxPower 100mA</P>
<P>Interface Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 4</P>
<P>bInterfaceNumber 0</P>
<P>bAlternateSetting 0</P>
<P>bNumEndpoints 1</P>
<P>bInterfaceClass 3 Human Interface Device</P>
<P>bInterfaceSubClass 1 Boot Interface Subclass</P>
<P>bInterfaceProtocol 1 Keyboard</P>
<P>iInterface 1 </P>
<P>HID Device Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 33</P>
<P>bcdHID 1.10</P>
<P>bCountryCode 0 Not supported</P>
<P>bNumDescriptors 1</P>
<P>bDescriptorType 34 Report</P>
<P>wDescriptorLength 54</P>
<P>Report Descriptors: </P>
<P>** UNAVAILABLE **</P>
<P>Endpoint Descriptor:</P>
<P>bLength 7</P>
<P>bDescriptorType 5</P>
<P>bEndpointAddress 0x81 EP 1 IN</P>
<P>bmAttributes 3</P>
<P>Transfer Type Interrupt</P>
<P>Synch Type None</P>
<P>Usage Type Data</P>
<P>wMaxPacketSize 0x0008 1x 8 bytes</P>
<P>bInterval 10</P>
<P>Interface Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 4</P>
<P>bInterfaceNumber 1</P>
<P>bAlternateSetting 0</P>
<P>bNumEndpoints 1</P>
<P>bInterfaceClass 3 Human Interface Device</P>
<P>bInterfaceSubClass 0 No Subclass</P>
<P>bInterfaceProtocol 0 None</P>
<P>iInterface 1 </P>
<P>HID Device Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 33</P>
<P>bcdHID 1.10</P>
<P>bCountryCode 0 Not supported</P>
<P>bNumDescriptors 1</P>
<P>bDescriptorType 34 Report</P>
<P>wDescriptorLength 50</P>
<P>Report Descriptors: </P>
<P>** UNAVAILABLE **</P>
<P>Endpoint Descriptor:</P>
<P>bLength 7</P>
<P>bDescriptorType 5</P>
<P>bEndpointAddress 0x82 EP 2 IN</P>
<P>bmAttributes 3</P>
<P>Transfer Type Interrupt</P>
<P>Synch Type None</P>
<P>Usage Type Data</P>
<P>wMaxPacketSize 0x0003 1x 3 bytes</P>
<P>bInterval 10</P>
<P>Bus 003 Device 003: ID 0451:1446 Texas Instruments, Inc. =
TUSB2040/2070=20
Hub</P>
<P>Device Descriptor:</P>
<P>bLength 18</P>
<P>bDescriptorType 1</P>
<P>bcdUSB 1.10</P>
<P>bDeviceClass 9 Hub</P>
<P>bDeviceSubClass 0 Unused</P>
<P>bDeviceProtocol 0 Full speed (or root) hub</P>
<P>bMaxPacketSize0 8</P>
<P>idVendor 0x0451 Texas Instruments, Inc.</P>
<P>idProduct 0x1446 TUSB2040/2070 Hub</P>
<P>bcdDevice 1.10</P>
<P>iManufacturer 0 </P>
<P>iProduct 0 </P>
<P>iSerial 0 </P>
<P>bNumConfigurations 1</P>
<P>Configuration Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 2</P>
<P>wTotalLength 34</P>
<P>bNumInterfaces 1</P>
<P>bConfigurationValue 1</P>
<P>iConfiguration 0 </P>
<P>bmAttributes 0xe0</P>
<P>Self Powered</P>
<P>Remote Wakeup</P>
<P>MaxPower 100mA</P>
<P>Interface Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 4</P>
<P>bInterfaceNumber 0</P>
<P>bAlternateSetting 0</P>
<P>bNumEndpoints 1</P>
<P>bInterfaceClass 9 Hub</P>
<P>bInterfaceSubClass 0 Unused</P>
<P>bInterfaceProtocol 0 Full speed (or root) hub</P>
<P>iInterface 0 </P>
<P>UNRECOGNIZED: 09 29 04 09 00 32 64 00 1e</P>
<P>Endpoint Descriptor:</P>
<P>bLength 7</P>
<P>bDescriptorType 5</P>
<P>bEndpointAddress 0x81 EP 1 IN</P>
<P>bmAttributes 3</P>
<P>Transfer Type Interrupt</P>
<P>Synch Type None</P>
<P>Usage Type Data</P>
<P>wMaxPacketSize 0x0001 1x 1 bytes</P>
<P>bInterval 255</P>
<P>Bus 003 Device 001: ID 0000:0000 </P>
<P>Device Descriptor:</P>
<P>bLength 18</P>
<P>bDescriptorType 1</P>
<P>bcdUSB 1.10</P>
<P>bDeviceClass 9 Hub</P>
<P>bDeviceSubClass 0 Unused</P>
<P>bDeviceProtocol 0 Full speed (or root) hub</P>
<P>bMaxPacketSize0 64</P>
<P>idVendor 0x0000 </P>
<P>idProduct 0x0000 </P>
<P>bcdDevice 2.06</P>
<P>iManufacturer 3 </P>
<P>iProduct 2 </P>
<P>iSerial 1 </P>
<P>bNumConfigurations 1</P>
<P>Configuration Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 2</P>
<P>wTotalLength 25</P>
<P>bNumInterfaces 1</P>
<P>bConfigurationValue 1</P>
<P>iConfiguration 0 </P>
<P>bmAttributes 0xe0</P>
<P>Self Powered</P>
<P>Remote Wakeup</P>
<P>MaxPower 0mA</P>
<P>Interface Descriptor:</P>
<P>bLength 9</P>
<P>bDescriptorType 4</P>
<P>bInterfaceNumber 0</P>
<P>bAlternateSetting 0</P>
<P>bNumEndpoints 1</P>
<P>bInterfaceClass 9 Hub</P>
<P>bInterfaceSubClass 0 Unused</P>
<P>bInterfaceProtocol 0 Full speed (or root) hub</P>
<P>iInterface 0 </P>
<P>Endpoint Descriptor:</P>
<P>bLength 7</P>
<P>bDescriptorType 5</P>
<P>bEndpointAddress 0x81 EP 1 IN</P>
<P>bmAttributes 3</P>
<P>Transfer Type Interrupt</P>
<P>Synch Type None</P>
<P>Usage Type Data</P>
<P>wMaxPacketSize 0x0002 1x 2 bytes</P>
<P>bInterval 255</P></FONT></FONT></DIV>
<DIV><FONT face=3DArial size=3D2></FONT>&nbsp;</DIV>
<BLOCKQUOTE=20
style=3D"PADDING-RIGHT: 0px; PADDING-LEFT: 5px; MARGIN-LEFT: 5px; =
BORDER-LEFT: #000000 2px solid; MARGIN-RIGHT: 0px">
  <DIV style=3D"FONT: 10pt arial">----- Original Message ----- </DIV>
  <DIV=20
  style=3D"BACKGROUND: #e4e4e4; FONT: 10pt arial; font-color: =
black"><B>From:</B>=20
  <A title=3Dbitumen.surfer@gmail.com=20
  href=3D"mailto:bitumen.surfer@gmail.com">John</A> </DIV>
  <DIV style=3D"FONT: 10pt arial"><B>To:</B> <A =
title=3Dptay1685@Bigpond.net.au=20
  href=3D"mailto:ptay1685@Bigpond.net.au">ptay1685</A> </DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Cc:</B> <A =
title=3Dlinux-dvb@linuxtv.org=20
  href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</A> </DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Sent:</B> Wednesday, March 26, 2008 =
1:48=20
  PM</DIV>
  <DIV style=3D"FONT: 10pt arial"><B>Subject:</B> Re: [linux-dvb] =
leadtek dtv=20
  dongle</DIV>
  <DIV><BR></DIV>please respond to the list -<BR><BR>ptay1685 wrote:=20
  <BLOCKQUOTE cite=3Dmid:002301c88ee9$fd998500$6e00a8c0@barny1e59e583e=20
type=3D"cite">
    <META content=3D"MSHTML 6.00.6000.16608" name=3DGENERATOR>
    <STYLE></STYLE>

    <DIV><FONT face=3DArial size=3D2>Thanks.</FONT></DIV>
    <DIV>&nbsp;</DIV>
    <DIV><FONT face=3DArial size=3D2>Just my luck. First off I get a =
Nebula usb=20
    DigiTV which never worked owing to an problem with ny nforce2 usb =
controller=20
    (i found out when it was too late), and which came with suspect =
WIndows=20
    software. So before I bought my two Leadtek dongles I checked the =
DVB=20
    wikipedia to make sure I got a fully Linux supported device. Now I =
have two=20
    new usb dongles neither of which work with Linux. You can't bloody =
win can=20
    you? At least they come with great WIndows software, which is more =
than you=20
    can say for the Nebula.</FONT></DIV>
    <DIV>&nbsp;</DIV>
    <DIV><FONT face=3DArial size=3D2>I can now use the Nebula with Linux =
but the=20
    leadtek software under WIndows is so good, that now I simply boot =
Windows to=20
    do my DVB stuff, and sometimes use Linux to author the DVD's=20
    (DeVeDe).</FONT></DIV>
    <DIV>&nbsp;</DIV>
    <DIV><FONT face=3DArial size=3D2>I guess this situation will persist =
until=20
    hardware vendors decide to support Linux. Unfortunately I will =
probably be=20
    six feet under by then.</FONT></DIV>
    <DIV>&nbsp;</DIV>
    <DIV><FONT face=3DArial size=3D2>I would certainly be interested in =
a fix for=20
    this situation but its hardly worth anyone putting in a lot of =
effort for=20
    just one person or at most a handful of people. But if you are =
able&nbsp;/=20
    willing to do something to remedy this problem I will certainly be =
very=20
    grateful.</FONT></DIV>
    <DIV>&nbsp;</DIV>
    <DIV><FONT face=3DArial size=3D2>Or perhaps one day I will work up =
the=20
    motivation to patch the code as you did - but i dare not hold my =
breath=20
    waiting for that to happen!</FONT></DIV>
    <DIV>&nbsp;</DIV></BLOCKQUOTE><BR>1) the fix is simple and someone =
on the list=20
  will be able to push through a simple patch, if all that is involved =
is added=20
  another identifier to recognise your device. <BR>2) we still need your =
lsusb=20
  -v to confirm this. <BR><BR>if you can do even a few minutes of effort =
to=20
  determine the required information, you might be surprised to find =
others in=20
  your situation and/or those capable of helping. <BR><BR><BR><BR>
  <BLOCKQUOTE cite=3Dmid:002301c88ee9$fd998500$6e00a8c0@barny1e59e583e=20
type=3D"cite">
    <BLOCKQUOTE=20
    style=3D"PADDING-RIGHT: 0px; PADDING-LEFT: 5px; MARGIN-LEFT: 5px; =
BORDER-LEFT: rgb(0,0,0) 2px solid; MARGIN-RIGHT: 0px"><BR><BR>firstly:=20
      lsusb is located in the usbutils package so you may need to =
install it, or=20
      you need to prefix the command with its location <BR>i.e. =
/sbin/lsusb.=20
      Please try this first and post the result back to the list. (with =
the -v=20
      option please)<BR><BR>secondly in reference to my patch =
below.<BR>I never=20
      heard anything more from the list about it and I have no reason to =
believe=20
      it was ever incorporated as a patch. I suspect this dongle is a =
variant=20
      sold only in Australia (where you and I are from obviously) and so =
the=20
      demand is relatively small - thus no one else was interested. I =
posted=20
      more for people like yourself for whom my fix may help. =
<BR><BR>The only=20
      thing this patch did is add an extra identifier so that the dongle =
was=20
      recognized. Now that said, I suspect there is an even more recent =
variant=20
      released in the last 2/3 months (right after I bought mine :( ) =
which may=20
      have a different identifier again. So the result of lsusb is even =
more=20
      important.<BR><BR>Unfortunately I got distracted after I got my =
dongle=20
      recognized and haven't made it fully work yet (with MythTv) - but =
if you=20
      are interested I might have another go at it. <BR><BR>I also note =
the=20
      large number of dibcom related posts in recent months which will =
have a=20
      direct bearing on this dongle. So recent versions of the dvb code =
are=20
      essential. <BR><BR>Cheers,<BR>J<BR><BR>ptay1685 wrote:=20
      <BLOCKQUOTE =
cite=3Dmid:001501c88ee1$f0466470$6e00a8c0@barny1e59e583e=20
      type=3D"cite"><PRE wrap=3D"">How do I tell the usb-id? Tried to do =
a lsusb -v but the command is=20
unrecognised.

Note that the Leadtek device is not actually recognised by the kernel =
(shown=20
via dmesg).

The following is from a previous conversation on this mailing list and =
might=20
give you the info you need:
_________________________________________________________________________=
______

Hi,

How do I get a patch incorporated into the dvb kernel section ?

After recently purchasing a LeadTek WinFast DTV Dongle I rapidly
discovered it was the variant that was not recognized in the kernel

i.e. as previously reported at:
<A class=3Dmoz-txt-link-freetext =
href=3D"http://www.linuxtv.org/pipermail/linux-dvb/2007-December/022373.h=
tml" =
moz-do-not-send=3D"true">http://www.linuxtv.org/pipermail/linux-dvb/2007-=
December/022373.html</A>
<A class=3Dmoz-txt-link-freetext =
href=3D"http://www.linuxtv.org/pipermail/linux-dvb/2008-January/023175.ht=
ml" =
moz-do-not-send=3D"true">http://www.linuxtv.org/pipermail/linux-dvb/2008-=
January/023175.html</A>

its device ids are: (lsusb)
ID 0413:6f01 Leadtek Research, Inc.

Rather than make the changes suggested by previous posters I set about
making a script and associated kernel patches to automatically do this.
My motivation was simple: I use a laptop with an ATI graphics card and
fedora 8. I find the best drivers for this card are currently from Livna
and are updated monthly (and changes are significant at the moment i.e.
see the phoronix forum). So I would need to do this repeatedly.

In my patch I add an identifier (USB_PID_WINFAST_DTV_DONGLE_STK7700P_B)
and modify the table appropriately

When I plug it in I now see in my messages log
kernel: usb 1-4: new high speed USB device using ehci_hcd and address 9
kernel: usb 1-4: configuration #1 chosen from 1 choice
kernel: dib0700: loaded with support for 2 different device-types
kernel: dvb-usb: found a 'Leadtek Winfast DTV Dongle B (STK7700P based)'
in cold state, will try to load a firmware
kernel: dvb-usb: downloading firmware from file 'dvb-usb-dib0700-01.fw'
kernel: dib0700: firmware started successfully.
kernel: dvb-usb: found a 'Leadtek Winfast DTV Dongle B (STK7700P based)'
in warm state.
kernel: dvb-usb: will pass the complete MPEG2 transport stream to the
software demuxer.
kernel: DVB: registering new adapter (Leadtek Winfast DTV Dongle B
(STK7700P based))
kernel: DVB: registering frontend 0 (DiBcom 7000PC)...
kernel: MT2060: successfully identified (IF1 =3D 1220)
kernel: dvb-usb: Leadtek Winfast DTV Dongle B (STK7700P based)
successfully initialized and connected.
kernel: usbcore: registered new interface driver dvb_usb_dib0700


My kernel patch ( other scripts to patch the Fedora 8 src rpm's
available on request)
----------------
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c       2008-02-13
10:05:13.000000000 +1100
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c       2008-02-13
10:22:16.000000000 +1100
@@ -280,6 +280,7 @@ struct usb_device_id dib0700_usb_id_tabl
                { USB_DEVICE(USB_VID_LEADTEK,
USB_PID_WINFAST_DTV_DONGLE_STK7700P) },
                { USB_DEVICE(USB_VID_HAUPPAUGE,
USB_PID_HAUPPAUGE_NOVA_T_STICK_2) },
                { USB_DEVICE(USB_VID_AVERMEDIA,
USB_PID_AVERMEDIA_VOLAR_2) },
+               { USB_DEVICE(USB_VID_LEADTEK,
USB_PID_WINFAST_DTV_DONGLE_STK7700P_B) },
                { }             /* Terminating entry */
};
MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -321,7 +322,7 @@ struct dvb_usb_device_properties dib0700
                        },
                },

-               .num_device_descs =3D 6,
+               .num_device_descs =3D 7,
                .devices =3D {
                        {   "DiBcom STK7700P reference design",
                                { &amp;dib0700_usb_id_table[0],
&amp;dib0700_usb_id_table[1] },
@@ -346,6 +347,10 @@ struct dvb_usb_device_properties dib0700
                        {   "Leadtek Winfast DTV Dongle (STK7700P
based)",
                                { &amp;dib0700_usb_id_table[8], NULL },
                                { NULL },
+                       },
+                       {   "Leadtek Winfast DTV Dongle B (STK7700P
based)",
+                               { &amp;dib0700_usb_id_table[11], NULL },
+                               { NULL },
                        }
                }
        }, { DIB0700_DEFAULT_DEVICE_PROPERTIES,
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h   2008-02-13
10:05:13.000000000 +1100
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h   2008-02-13
10:18:00.000000000 +1100
@@ -148,6 +148,7 @@
#define USB_PID_WINFAST_DTV_DONGLE_COLD                        0x6025
#define USB_PID_WINFAST_DTV_DONGLE_WARM                        0x6026
#define USB_PID_WINFAST_DTV_DONGLE_STK7700P            0x6f00
+#define USB_PID_WINFAST_DTV_DONGLE_STK7700P_B          0x6f01
#define USB_PID_GENPIX_8PSK_COLD                       0x0200
#define USB_PID_GENPIX_8PSK_WARM                       0x0201
#define USB_PID_SIGMATEK_DVB_110                       0x6610



_______________________________________________
linux-dvb mailing list
<A class=3Dmoz-txt-link-abbreviated =
href=3D"mailto:linux-dvb@linuxtv.org" =
moz-do-not-send=3D"true">linux-dvb@linuxtv.org</A>
<A class=3Dmoz-txt-link-freetext =
href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" =
moz-do-not-send=3D"true">http://www.linuxtv.org/cgi-bin/mailman/listinfo/=
linux-dvb</A>

----- Original Message -----=20
From: "Antti Palosaari" <A class=3Dmoz-txt-link-rfc2396E =
href=3D"mailto:crope@iki.fi" =
moz-do-not-send=3D"true">&lt;crope@iki.fi&gt;</A>
To: "ptay1685" <A class=3Dmoz-txt-link-rfc2396E =
href=3D"mailto:ptay1685@Bigpond.net.au" =
moz-do-not-send=3D"true">&lt;ptay1685@Bigpond.net.au&gt;</A>
Cc: <A class=3Dmoz-txt-link-rfc2396E =
href=3D"mailto:linux-dvb@linuxtv.org" =
moz-do-not-send=3D"true">&lt;linux-dvb@linuxtv.org&gt;</A>
Sent: Monday, March 24, 2008 9:43 AM
Subject: Re: [linux-dvb] leadtek dtv dongle


  </PRE>
        <BLOCKQUOTE type=3D"cite"><PRE wrap=3D"">ptay1685 wrote:
    </PRE>
          <BLOCKQUOTE type=3D"cite"><PRE wrap=3D"">Any news about the =
new version of the dtv dongle? Still does not work
with the latest v4l sources. Anyone know whats happening?

Many thanks,

Phil T.
      </PRE></BLOCKQUOTE><PRE wrap=3D"">Can you say what is usb-id of =
your device? Also lsusb -v could be nice
to see.

regards
Antti
--=20
<A class=3Dmoz-txt-link-freetext href=3D"http://palosaari.fi/" =
moz-do-not-send=3D"true">http://palosaari.fi/</A>

_______________________________________________
linux-dvb mailing list
<A class=3Dmoz-txt-link-abbreviated =
href=3D"mailto:linux-dvb@linuxtv.org" =
moz-do-not-send=3D"true">linux-dvb@linuxtv.org</A>
<A class=3Dmoz-txt-link-freetext =
href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" =
moz-do-not-send=3D"true">http://www.linuxtv.org/cgi-bin/mailman/listinfo/=
linux-dvb</A>=20
    </PRE></BLOCKQUOTE><PRE wrap=3D""><!---->

_______________________________________________
linux-dvb mailing list
<A class=3Dmoz-txt-link-abbreviated =
href=3D"mailto:linux-dvb@linuxtv.org" =
moz-do-not-send=3D"true">linux-dvb@linuxtv.org</A>
<A class=3Dmoz-txt-link-freetext =
href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" =
moz-do-not-send=3D"true">http://www.linuxtv.org/cgi-bin/mailman/listinfo/=
linux-dvb</A>
  =
</PRE></BLOCKQUOTE><BR></BLOCKQUOTE></BLOCKQUOTE><BR></BLOCKQUOTE></BODY>=
</HTML>

------=_NextPart_000_0030_01C8906F.E06D53D0--



--===============0483406653==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0483406653==--
