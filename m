Return-path: <linux-media-owner@vger.kernel.org>
Received: from www49.your-server.de ([213.133.104.49]:56382 "EHLO
	www49.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab0AKSow (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2010 13:44:52 -0500
Received: from [188.97.242.148] (helo=[192.168.1.22])
	by www49.your-server.de with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <besse@motama.com>)
	id 1NUOkS-00031s-Go
	for linux-media@vger.kernel.org; Mon, 11 Jan 2010 19:12:16 +0100
Message-ID: <4B4B69FA.40905@motama.com>
Date: Mon, 11 Jan 2010 19:12:10 +0100
From: Andreas Besse <besse@motama.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Writing udev reuls for dual tuner devices
Content-Type: multipart/mixed;
 boundary="------------000508080601030908070805"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000508080601030908070805
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

I use a Media-Pointer MP-S2 Dual DVB-S2 PCIe card with the latest drivers from the git-Repository
http://projects.vdr-developer.org/repositories/show/mediapointer-dvb-s2 .

I tried to write udev rules to define the adapter names of the tuner to avoid that the device names could change at boot. It seems not to be possible to write a udev rule for this dual DVB-S2 device, because there are no attributes to differentiate between tuner 0 and tuner 1. Attached is the output of udevinfo.

The following udev rule allows only to define the adapter name of a single tuner:
SUBSYSTEM=="dvb", ATTRS{vendor}=="0x18c3", ATTRS{device}=="0x0720",
KERNELS=="0000:02:00.0",
PROGRAM="/bin/sh -c 'K=%k; K=$${K#dvb}; printf dvb/adapter0/%%s $${K#*.}'", SYMLINK+="%c"

How can this issue be solved in general? I think the driver should provide an attribute for each tuner, so that it is possible to write udev rules. How this has been solved for other Dual Tuner devices like Pinnacle PCTV Dual DVB-T Diversity, DViCO FusionHDTV DVB-T Dual Express?




--------------000508080601030908070805
Content-Type: text/plain;
 name="udevinfo.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="udevinfo.txt"


Udevinfo starts with the device specified by the devpath and then
walks up the chain of parent devices. It prints for every device
found, all possible attributes in the udev rules key format.
A rule to match, can be composed by the attributes of the device
and the attributes from one single parent device.

  looking at device '/devices/pci0000:00/0000:00:01.0/0000:01:00.0/dvb/dvb0.frontend0':
    KERNEL=="dvb0.frontend0"
    SUBSYSTEM=="dvb"
    DRIVER==""
    ATTR{dev}=="212:2"

  looking at parent device '/devices/pci0000:00/0000:00:01.0/0000:01:00.0/dvb':
    KERNELS=="dvb"
    SUBSYSTEMS==""
    DRIVERS==""

  looking at parent device '/devices/pci0000:00/0000:00:01.0/0000:01:00.0':
    KERNELS=="0000:01:00.0"
    SUBSYSTEMS=="pci"
    DRIVERS=="ngene"
    ATTRS{vendor}=="0x18c3"
    ATTRS{device}=="0x0720"
    ATTRS{subsystem_vendor}=="0x18c3"
    ATTRS{subsystem_device}=="0xabc4"
    ATTRS{class}=="0x040000"
    ATTRS{irq}=="16"
    ATTRS{local_cpus}=="ffffffff,ffffffff,ffffffff,ffffffff"
    ATTRS{modalias}=="pci:v000018C3d00000720sv000018C3sd0000ABC4bc04sc00i00"
    ATTRS{enable}=="1"
    ATTRS{broken_parity_status}=="0"
    ATTRS{msi_bus}==""

  looking at parent device '/devices/pci0000:00/0000:00:01.0':
    KERNELS=="0000:00:01.0"
    SUBSYSTEMS=="pci"
    DRIVERS=="pcieport-driver"
    ATTRS{vendor}=="0x8086"
    ATTRS{device}=="0x2771"
    ATTRS{subsystem_vendor}=="0x0000"
    ATTRS{subsystem_device}=="0x0000"
    ATTRS{class}=="0x060400"
    ATTRS{irq}=="223"
    ATTRS{local_cpus}=="ffffffff,ffffffff,ffffffff,ffffffff"
    ATTRS{modalias}=="pci:v00008086d00002771sv00000000sd00000000bc06sc04i00"
    ATTRS{enable}=="2"
    ATTRS{broken_parity_status}=="0"
    ATTRS{msi_bus}=="1"

  looking at parent device '/devices/pci0000:00':
    KERNELS=="pci0000:00"
    SUBSYSTEMS==""
    DRIVERS==""


Udevinfo starts with the device specified by the devpath and then
walks up the chain of parent devices. It prints for every device
found, all possible attributes in the udev rules key format.
A rule to match, can be composed by the attributes of the device
and the attributes from one single parent device.

  looking at device '/devices/pci0000:00/0000:00:01.0/0000:01:00.0/dvb/dvb1.frontend0':
    KERNEL=="dvb1.frontend0"
    SUBSYSTEM=="dvb"
    DRIVER==""
    ATTR{dev}=="212:5"

  looking at parent device '/devices/pci0000:00/0000:00:01.0/0000:01:00.0/dvb':
    KERNELS=="dvb"
    SUBSYSTEMS==""
    DRIVERS==""

  looking at parent device '/devices/pci0000:00/0000:00:01.0/0000:01:00.0':
    KERNELS=="0000:01:00.0"
    SUBSYSTEMS=="pci"
    DRIVERS=="ngene"
    ATTRS{vendor}=="0x18c3"
    ATTRS{device}=="0x0720"
    ATTRS{subsystem_vendor}=="0x18c3"
    ATTRS{subsystem_device}=="0xabc4"
    ATTRS{class}=="0x040000"
    ATTRS{irq}=="16"
    ATTRS{local_cpus}=="ffffffff,ffffffff,ffffffff,ffffffff"
    ATTRS{modalias}=="pci:v000018C3d00000720sv000018C3sd0000ABC4bc04sc00i00"
    ATTRS{enable}=="1"
    ATTRS{broken_parity_status}=="0"
    ATTRS{msi_bus}==""

  looking at parent device '/devices/pci0000:00/0000:00:01.0':
    KERNELS=="0000:00:01.0"
    SUBSYSTEMS=="pci"
    DRIVERS=="pcieport-driver"
    ATTRS{vendor}=="0x8086"
    ATTRS{device}=="0x2771"
    ATTRS{subsystem_vendor}=="0x0000"
    ATTRS{subsystem_device}=="0x0000"
    ATTRS{class}=="0x060400"
    ATTRS{irq}=="223"
    ATTRS{local_cpus}=="ffffffff,ffffffff,ffffffff,ffffffff"
    ATTRS{modalias}=="pci:v00008086d00002771sv00000000sd00000000bc06sc04i00"
    ATTRS{enable}=="2"
    ATTRS{broken_parity_status}=="0"
    ATTRS{msi_bus}=="1"

  looking at parent device '/devices/pci0000:00':
    KERNELS=="pci0000:00"
    SUBSYSTEMS==""
    DRIVERS==""


--------------000508080601030908070805--
