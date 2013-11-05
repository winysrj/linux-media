Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.mimuw.edu.pl ([193.0.96.6]:36754 "EHLO mail.mimuw.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab3KEGOZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Nov 2013 01:14:25 -0500
Message-ID: <20131105071422.16618olr3fxev83i@mail.mimuw.edu.pl>
Date: Tue, 05 Nov 2013 07:14:22 +0100
From: "Janusz S. Bien" <jsbien@mimuw.edu.pl>
To: Roland Scheidegger <rscheidegger_lists@hispeed.ch>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] az6007: support Technisat Cablestar Combo HDCI
 (minus remote)
References: <1383421772-28243-1-git-send-email-rscheidegger_lists@hispeed.ch>
In-Reply-To: <1383421772-28243-1-git-send-email-rscheidegger_lists@hispeed.ch>
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_1ecgaw560bdt"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This message is in MIME format.

--=_1ecgaw560bdt
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Thank you very much for the patch.

Quote/Cytat - Roland Scheidegger <rscheidegger_lists@hispeed.ch> (Sat =20
02 Nov 2013 08:49:32 PM CET):

[...]

> Originally based on idea found on
> http://www.linuxtv.org/wiki/index.php/TechniSat_CableStar_Combo_HD_CI =20
> claiming
> only id needs to be added (but failed to mention it only worked because t=
he
> driver couldn't find the h7 drx-k firmware...).

Together with Tobias Wessel, another user of the device, we have =20
updated and extended the wiki entry.

The problem is that although I use the same system as Tobias (Debian =20
wheezy) and it seems we installed media_build in the identical way, it =20
works OK for Tobias but not for me, as the required drivers are not =20
loaded. The device itself is not a problem because it works perfectly =20
on Windows.

Looks like udev may be the culprit, I enclose a log fragment from my =20
rather chaotic experiments - I'm just a Debian user and my knowledge =20
of the system internals is rudimentary.

So my questions are:

Do you have any comments or suggestions regarding the modified wiki entry?

Where to look for help with my problem?

How to uninstall media_build to start experimenting from the scratch?

Best regards

Janusz

--=20
Prof. dr hab. Janusz S. Bie=C5=84 -  Uniwersytet Warszawski (Katedra =20
Lingwistyki Formalnej)
Prof. Janusz S. Bie=C5=84 - University of Warsaw (Formal Linguistics Depart=
ment)
jsbien@uw.edu.pl, jsbien@mimuw.edu.pl, http://fleksem.klf.uw.edu.pl/~jsbien=
/
--=_1ecgaw560bdt
Content-Type: text/x-log;
 charset=UTF-8;
 name="udevCableStar.log"
Content-Disposition: attachment;
 filename="udevCableStar.log"
Content-Transfer-Encoding: 7bit

Nov  4 23:14:14 cauda kernel: [  343.333559] usb 7-4: New USB device found, idVendor=14f7, idProduct=0003
Nov  4 23:14:14 cauda kernel: [  343.333566] usb 7-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
Nov  4 23:14:14 cauda kernel: [  343.333571] usb 7-4: Product: CableStar Combo HD CI
Nov  4 23:14:14 cauda kernel: [  343.333574] usb 7-4: Manufacturer: TechniSat Digital S.A.
Nov  4 23:14:14 cauda kernel: [  343.333578] usb 7-4: SerialNumber: 0008C9D91826
Nov  4 23:14:14 cauda udevd[3696]: 'usb-db /devices/pci0000:00/0000:00:1d.7/usb7/7-4'(out) 'ID_VENDOR_FROM_DATABASE=TechniSat Digital GmbH'
Nov  4 23:14:14 cauda udevd[3696]: 'usb-db /devices/pci0000:00/0000:00:1d.7/usb7/7-4'(out) 'ID_MODEL_FROM_DATABASE=CableStar Combo HD CI'
Nov  4 23:14:14 cauda udevd[3696]: 'usb-db /devices/pci0000:00/0000:00:1d.7/usb7/7-4' [5215] exit with return code 0
Nov  4 23:14:14 cauda udevd[3696]: IMPORT builtin 'usb_id' /lib/udev/rules.d/60-libgphoto2-2.rules:11
Nov  4 23:14:14 cauda udevd[3696]: ID_VENDOR=TechniSat_Digital_S.A.
Nov  4 23:14:14 cauda udevd[3696]: ID_VENDOR_ENC=TechniSat\x20Digital\x20S.A.
Nov  4 23:14:14 cauda udevd[3696]: ID_VENDOR_ID=14f7
Nov  4 23:14:14 cauda udevd[3696]: ID_MODEL=CableStar_Combo_HD_CI
Nov  4 23:14:14 cauda udevd[3696]: ID_MODEL_ENC=CableStar\x20Combo\x20HD\x20CI
Nov  4 23:14:14 cauda udevd[3696]: ID_MODEL_ID=0003
Nov  4 23:14:14 cauda udevd[3696]: ID_REVISION=0003
Nov  4 23:14:14 cauda udevd[3696]: ID_SERIAL=TechniSat_Digital_S.A._CableStar_Combo_HD_CI_0008C9D91826
Nov  4 23:14:14 cauda udevd[3696]: ID_SERIAL_SHORT=0008C9D91826
Nov  4 23:14:14 cauda udevd[3696]: ID_BUS=usb
Nov  4 23:14:14 cauda udevd[3696]: ID_USB_INTERFACES=:ff0000:
Nov  4 23:14:14 cauda udevd[3696]: RUN '/usr/share/virtualbox/VBoxCreateUSBNode.sh $major $minor $attr{bDeviceClass}' /etc/udev/rules.d/60-vboxdrv.rules:5
Nov  4 23:14:14 cauda udevd[3696]: PROGRAM 'mtp-probe /sys/devices/pci0000:00/0000:00:1d.7/usb7/7-4 7 6' /lib/udev/rules.d/69-libmtp.rules:939
Nov  4 23:14:14 cauda udevd[5216]: starting 'mtp-probe /sys/devices/pci0000:00/0000:00:1d.7/usb7/7-4 7 6'
Nov  4 23:14:14 cauda mtp-probe: checking bus 7, device 6: "/sys/devices/pci0000:00/0000:00:1d.7/usb7/7-4"
Nov  4 23:14:14 cauda mtp-probe: bus: 7, device: 6 was not an MTP device
Nov  4 23:14:14 cauda udevd[3696]: 'mtp-probe /sys/devices/pci0000:00/0000:00:1d.7/usb7/7-4 7 6'(out) '0'
Nov  4 23:14:14 cauda udevd[3696]: 'mtp-probe /sys/devices/pci0000:00/0000:00:1d.7/usb7/7-4 7 6' [5216] exit with return code 0
Nov  4 23:14:14 cauda udevd[3696]: MODE 0664 /lib/udev/rules.d/91-permissions.rules:36
Nov  4 23:14:14 cauda udevd[3696]: no node name set, will use kernel supplied name 'bus/usb/007/006'
Nov  4 23:14:14 cauda udevd[3696]: creating device node '/dev/bus/usb/007/006', devnum=189:773, mode=01664, uid=0, gid=0
Nov  4 23:14:14 cauda udevd[3696]: preserve file '/dev/bus/usb/007/006', because it has correct dev_t
Nov  4 23:14:14 cauda udevd[3696]: set permissions /dev/bus/usb/007/006, 021664, uid=0, gid=0
Nov  4 23:14:14 cauda udevd[3696]: creating symlink '/dev/char/189:773' to '../bus/usb/007/006'
Nov  4 23:14:14 cauda udevd[3696]: created db file '/run/udev/data/c189:773' for '/devices/pci0000:00/0000:00:1d.7/usb7/7-4'
Nov  4 23:14:14 cauda udevd[5217]: starting '/usr/share/virtualbox/VBoxCreateUSBNode.sh 189 773 00'
Nov  4 23:14:14 cauda udevd[3696]: '/usr/share/virtualbox/VBoxCreateUSBNode.sh 189 773 00' [5217] exit with return code 0
Nov  4 23:14:14 cauda udevd[3696]: passed -1 bytes to netlink monitor 0x9bea488
Nov  4 23:14:14 cauda udevd[3696]: seq 1397 processed with 0
Nov  4 23:14:14 cauda udevd[371]: seq 1397 done with 0
Nov  4 23:14:14 cauda udevd[371]: passed 300 bytes to netlink monitor 0x9bc9318
Nov  4 23:14:14 cauda udevd[3696]: seq 1398 running
Nov  4 23:14:14 cauda udevd[3696]: device 0x9bca230 has devpath '/devices/pci0000:00/0000:00:1d.7/usb7/7-4/7-4:1.0'
Nov  4 23:14:14 cauda udevd[3696]: no db file to read /run/udev/data/+usb:7-4:1.0: No such file or directory
Nov  4 23:14:14 cauda udevd[3696]: device 0x9bcb130 has devpath '/devices/pci0000:00/0000:00:1d.7/usb7/7-4'
Nov  4 23:14:14 cauda udevd[3696]: RUN 'usb_modeswitch --driver-bind %p %s{idVendor} %s{idProduct} %E{PRODUCT}' /lib/udev/rules.d/40-usb_modeswitch.rules:16
Nov  4 23:14:14 cauda udevd[3696]: device 0x9bca8a8 has devpath '/devices/pci0000:00/0000:00:1d.7/usb7'
Nov  4 23:14:14 cauda udevd[3696]: device 0x9bc9420 has devpath '/devices/pci0000:00/0000:00:1d.7'
Nov  4 23:14:14 cauda udevd[3696]: device 0x9bc9818 has devpath '/devices/pci0000:00'
Nov  4 23:14:14 cauda udevd[3696]: IMPORT 'usb-db /devices/pci0000:00/0000:00:1d.7/usb7/7-4/7-4:1.0' /lib/udev/rules.d/55-Argyll.rules:62
Nov  4 23:14:14 cauda udevd[5228]: starting 'usb-db /devices/pci0000:00/0000:00:1d.7/usb7/7-4/7-4:1.0'
Nov  4 23:14:14 cauda udevd[3696]: 'usb-db /devices/pci0000:00/0000:00:1d.7/usb7/7-4/7-4:1.0'(err) 'libudev: udev_device_new_from_syspath: device 0x8fa4318 has devpath '/devices/pci0000:00/0000:00:1d.7/usb7/7-4/7-4:1.0''
Nov  4 23:14:14 cauda udevd[3696]: 'usb-db /devices/pci0000:00/0000:00:1d.7/usb7/7-4/7-4:1.0'(err) 'libudev: udev_device_new_from_syspath: device 0x8fa45b8 has devpath '/devices/pci0000:00/0000:00:1d.7/usb7/7-4''
Nov  4 23:14:14 cauda udevd[3696]: 'usb-db /devices/pci0000:00/0000:00:1d.7/usb7/7-4/7-4:1.0'(out) 'ID_VENDOR_FROM_DATABASE=TechniSat Digital GmbH'
Nov  4 23:14:14 cauda udevd[3696]: 'usb-db /devices/pci0000:00/0000:00:1d.7/usb7/7-4/7-4:1.0'(out) 'ID_MODEL_FROM_DATABASE=CableStar Combo HD CI'
Nov  4 23:14:14 cauda udevd[3696]: 'usb-db /devices/pci0000:00/0000:00:1d.7/usb7/7-4/7-4:1.0' [5228] exit with return code 0
Nov  4 23:14:14 cauda udevd[3696]: RUN '/sbin/modprobe -b $env{MODALIAS}' /lib/udev/rules.d/80-drivers.rules:7
Nov  4 23:14:14 cauda udevd[3696]: created db file '/run/udev/data/+usb:7-4:1.0' for '/devices/pci0000:00/0000:00:1d.7/usb7/7-4/7-4:1.0'
Nov  4 23:14:14 cauda udevd[5229]: starting 'usb_modeswitch --driver-bind /devices/pci0000:00/0000:00:1d.7/usb7/7-4/7-4:1.0   14f7/3/3'
Nov  4 23:14:15 cauda udevd[3696]: 'usb_modeswitch --driver-bind /devices/pci0000:00/0000:00:1d.7/usb7/7-4/7-4:1.0   14f7/3/3' [5229] exit with return code 0
Nov  4 23:14:15 cauda udevd[5236]: starting '/sbin/modprobe -b usb:v14F7p0003d0003dc00dsc00dp00icFFisc00ip00in00'
Nov  4 23:14:15 cauda udevd[3696]: '/sbin/modprobe -b usb:v14F7p0003d0003dc00dsc00dp00icFFisc00ip00in00'(err) 'FATAL: Module usb:v14F7p0003d0003dc00dsc00dp00icFFisc00ip00in00 not found.'
Nov  4 23:14:15 cauda udevd[3696]: '/sbin/modprobe -b usb:v14F7p0003d0003dc00dsc00dp00icFFisc00ip00in00' [5236] exit with return code 1
Nov  4 23:14:15 cauda udevd[3696]: passed -1 bytes to netlink monitor 0x9bea488
Nov  4 23:14:15 cauda udevd[3696]: seq 1398 processed with 0
Nov  4 23:14:15 cauda udevd[371]: seq 1398 done with 0

--=_1ecgaw560bdt--
