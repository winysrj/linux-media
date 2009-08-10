Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7AFSUkH028839
	for <video4linux-list@redhat.com>; Mon, 10 Aug 2009 11:28:30 -0400
Received: from mail-bw0-f209.google.com (mail-bw0-f209.google.com
	[209.85.218.209])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n7AFSBRv003397
	for <video4linux-list@redhat.com>; Mon, 10 Aug 2009 11:28:11 -0400
Received: by bwz5 with SMTP id 5so1362914bwz.3
	for <video4linux-list@redhat.com>; Mon, 10 Aug 2009 08:28:10 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 10 Aug 2009 17:28:10 +0200
Message-ID: <6f278f100908100828u4bd05f87red8128223dc4ffbb@mail.gmail.com>
From: Theou Jean-Baptiste <jbtheou@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: Information about sq930
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

I manage the EasyCam project and one of my user try to use sq930 driver.
With Sam Revitch, i have make some change in this driver, one year ago
(source is availble in my mecurial depot : http://hg.jbtheou.fr). But my
user have lot of problems. Some infomation at the end of e-mail.
I would know if some body can fix this driver, because nobody fix this
driver since long time. Thanks and sorry for my poor english.

lsusb -v:
Bus 005 Device 011: ID 2770:930c NHJ, Ltd
Device Descriptor:
bLength 18
bDescriptorType 1
bcdUSB 2.00
bDeviceClass 0 (Defined at Interface level)
bDeviceSubClass 0
bDeviceProtocol 0
bMaxPacketSize0 64
idVendor 0x2770 NHJ, Ltd
idProduct 0x930c
bcdDevice 1.00
iManufacturer 1 SQ Tech CO., LTD.
iProduct 2 USB 2.0 PC camera
iSerial 0
bNumConfigurations 1
Configuration Descriptor:
bLength 9
bDescriptorType 2
wTotalLength 32
bNumInterfaces 1
bConfigurationValue 1
iConfiguration 0
bmAttributes 0x80
(Bus Powered)
MaxPower 500mA
Interface Descriptor:
bLength 9
bDescriptorType 4
bInterfaceNumber 0
bAlternateSetting 0
bNumEndpoints 2
bInterfaceClass 255 Vendor Specific Class
bInterfaceSubClass 255 Vendor Specific Subclass
bInterfaceProtocol 255 Vendor Specific Protocol
iInterface 0
Endpoint Descriptor:
bLength 7
bDescriptorType 5
bEndpointAddress 0x81 EP 1 IN
bmAttributes 2
Transfer Type Bulk
Synch Type None
Usage Type Data
wMaxPacketSize 0x0200 1x 512 bytes
bInterval 0
Endpoint Descriptor:
bLength 7
bDescriptorType 5
bEndpointAddress 0x02 EP 2 OUT
bmAttributes 2
Transfer Type Bulk
Synch Type None
Usage Type Data
wMaxPacketSize 0x0200 1x 512 bytes
bInterval 0
Device Qualifier (for other device speed):
bLength 10
bDescriptorType 6
bcdUSB 2.00
bDeviceClass 0 (Defined at Interface level)
bDeviceSubClass 0
bDeviceProtocol 0
bMaxPacketSize0 64
bNumConfigurations 1
Device Status: 0x0002
(Bus Powered)
Remote Wakeup Enabled

dmesg:
[260643.954670] usb 5-2: new high speed USB device using ehci_hcd and
address 11
[260644.094585] usb 5-2: configuration #1 chosen from 1 choice
[260644.095096] sq930-0: sq930_control_dma: read 001f/0000 8
[260644.095774] sq930-0: Product: USB 2.0 PC camera
[260644.095781] sq930-0: Device model: Generic SQ930B/C Webcam
[260644.095785] sq930-0: Chip: 930b FW: 12
[260644.095789] sq930-0: sq930_control_dma: write 3101/00f0 0
[260644.109337] sq930-0: Could not determine image sensor

compilation:
compilation :

ln:
E_SUDO_PASSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS=
SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS=
SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS=
SSSSSSSSSSSSSSSSSSSSSSSSSScreating
symbolic link `/lib/modules/2.6.24-24-generic/build/include/linux/config.h'=
:
File exists
Reading package lists... Done
Building dependency tree
Reading state information... Done
linux-headers-2.6.24-24-generic is already the newest version.
The following packages were automatically installed and are no longer
required:
myspell-fr-gut linux-headers-2.6.24-23-generic openoffice.org-help-fr
linux-headers-2.6.24-23 openoffice.org-l10n-fr
Use 'apt-get autoremove' to remove them.
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
make -C /lib/modules/2.6.24-24-generic/build
M=3D/usr/local/EasyCam/drivers/sq930 clean
make1 <http://projet.jbtheou.fr/issues/show/2#fn1>: Entering directory
`/usr/src/linux-headers-2.6.24-24-generic'
CLEAN /usr/local/EasyCam/drivers/sq930/.tmp_versions
CLEAN /usr/local/EasyCam/drivers/sq930/Module.symvers
make1 <http://projet.jbtheou.fr/issues/show/2#fn1>: Leaving directory
`/usr/src/linux-headers-2.6.24-24-generic'
rm -f Module.symvers Modules.symvers
make -C /lib/modules/2.6.24-24-generic/build
M=3D/usr/local/EasyCam/drivers/sq930 V=3D0 modules
make1 <http://projet.jbtheou.fr/issues/show/2#fn1>: Entering directory
`/usr/src/linux-headers-2.6.24-24-generic'
CC [M] /usr/local/EasyCam/drivers/sq930/sq930_core.o
CC [M] /usr/local/EasyCam/drivers/sq930/sq930_lz24bp.o
CC [M] /usr/local/EasyCam/drivers/sq930/usbcam_dev.o
CC [M] /usr/local/EasyCam/drivers/sq930/usbcam_fops.o
/usr/local/EasyCam/drivers/sq930/usbcam_fops.c: In function
?usbcam_v4l_ioctl?:
/usr/local/EasyCam/drivers/sq930/usbcam_fops.c:1159: warning: unused
variable ?udp?
/usr/local/EasyCam/drivers/sq930/usbcam_fops.c: At top level:
/usr/local/EasyCam/drivers/sq930/usbcam_fops.c:52: warning:
?v4l_ioctl_names? defined but not used
CC [M] /usr/local/EasyCam/drivers/sq930/usbcam_buf.o
CC [M] /usr/local/EasyCam/drivers/sq930/usbcam_util.o
LD [M] /usr/local/EasyCam/drivers/sq930/sq930.o
Building modules, stage 2.
MODPOST 1 modules
CC /usr/local/EasyCam/drivers/sq930/sq930.mod.o
LD [M] /usr/local/EasyCam/drivers/sq930/sq930.ko
make1 <http://projet.jbtheou.fr/issues/show/2#fn1>: Leaving directory
`/usr/src/linux-headers-2.6.24-24-generic'
make -C /lib/modules/2.6.24-24-generic/build
M=3D/usr/local/EasyCam/drivers/sq930 V=3D0 modules
make1 <http://projet.jbtheou.fr/issues/show/2#fn1>: Entering directory
`/usr/src/linux-headers-2.6.24-24-generic'
Building modules, stage 2.
MODPOST 1 modules
make1 <http://projet.jbtheou.fr/issues/show/2#fn1>: Leaving directory
`/usr/src/linux-headers-2.6.24-24-generic'
mkdir -p /lib/modules/2.6.24-24-generic/extra
rm -f /kernel/driver/media/video/
find /lib/modules/2.6.24-24-generic -name sq930.ko | xargs rm -f
install -c -m 0644 sq930.ko /lib/modules/2.6.24-24-generic/extra
/sbin/depmod -a


--=20
Jean-Baptiste Th=E9ou
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
