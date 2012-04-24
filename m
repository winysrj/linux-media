Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:47979 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758114Ab2DXXgY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Apr 2012 19:36:24 -0400
Subject: Re: udev rules for persistent symlinks for adapter?/frontend0
 devices
From: Andy Walls <awalls@md.metrocast.net>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-media@vger.kernel.org
Date: Tue, 24 Apr 2012 19:26:18 -0400
In-Reply-To: <jn6n2e$gu1$1@dough.gmane.org>
References: <jn6n2e$gu1$1@dough.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1335309978.8218.22.camel@palomino.walls.org>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2012-04-24 at 13:14 -0400, Brian J. Murrell wrote:
> Hi,
> 
> I have two DVB devices in my machine that I want to be able to identify
> persistently[1].  They are typically on /dev/dvb/adapter{0,1}/frontend0
> but their order is arbitrary and can change from one boot to another.
> 
> So using udevadm info I tried to find attributes for them that I could
> rely on consistently.  Here is the output from:
> 
> # udevadm info --attribute-walk --name /dev/dvb/adapter?/frontend0
> 
> First device:
> 
>   looking at device '/devices/pci0000:00/0000:00:1e.0/0000:02:09.0/dvb/dvb0.frontend0':
>     KERNEL=="dvb0.frontend0"
>     SUBSYSTEM=="dvb"
>     DRIVER==""
> 
>   looking at parent device '/devices/pci0000:00/0000:00:1e.0/0000:02:09.0':
>     KERNELS=="0000:02:09.0"
>     SUBSYSTEMS=="pci"
>     DRIVERS=="cx18"
>     ATTRS{vendor}=="0x14f1"
>     ATTRS{device}=="0x5b7a"
>     ATTRS{subsystem_vendor}=="0x0070"
>     ATTRS{subsystem_device}=="0x7400"
>     ATTRS{class}=="0x040000"
>     ATTRS{irq}=="21"
>     ATTRS{local_cpus}=="ff"
>     ATTRS{local_cpulist}=="0-7"
>     ATTRS{dma_mask_bits}=="32"
>     ATTRS{consistent_dma_mask_bits}=="32"
>     ATTRS{enable}=="1"
>     ATTRS{broken_parity_status}=="0"
>     ATTRS{msi_bus}==""
> 
>   looking at parent device '/devices/pci0000:00/0000:00:1e.0':
>     KERNELS=="0000:00:1e.0"
>     SUBSYSTEMS=="pci"
>     DRIVERS==""
>     ATTRS{vendor}=="0x8086"
>     ATTRS{device}=="0x244e"
>     ATTRS{subsystem_vendor}=="0x0000"
>     ATTRS{subsystem_device}=="0x0000"
>     ATTRS{class}=="0x060400"
>     ATTRS{irq}=="0"
>     ATTRS{local_cpus}=="ff"
>     ATTRS{local_cpulist}=="0-7"
>     ATTRS{dma_mask_bits}=="32"
>     ATTRS{consistent_dma_mask_bits}=="32"
>     ATTRS{enable}=="1"
>     ATTRS{broken_parity_status}=="0"
>     ATTRS{msi_bus}=="1"
> 
>   looking at parent device '/devices/pci0000:00':
>     KERNELS=="pci0000:00"
>     SUBSYSTEMS==""
>     DRIVERS==""
> 
> And the second device:
> 
>   looking at device '/devices/pci0000:00/0000:00:1d.7/usb1/1-3/dvb/dvb1.frontend0':
>     KERNEL=="dvb1.frontend0"
>     SUBSYSTEM=="dvb"
>     DRIVER==""
> 
>   looking at parent device '/devices/pci0000:00/0000:00:1d.7/usb1/1-3':
>     KERNELS=="1-3"
>     SUBSYSTEMS=="usb"
>     DRIVERS=="usb"
>     ATTRS{configuration}==""
>     ATTRS{bNumInterfaces}==" 4"
>     ATTRS{bConfigurationValue}=="1"
>     ATTRS{bmAttributes}=="80"
>     ATTRS{bMaxPower}=="500mA"
>     ATTRS{urbnum}=="5941719"
>     ATTRS{idVendor}=="2040"
>     ATTRS{idProduct}=="7200"
>     ATTRS{bcdDevice}=="0005"
>     ATTRS{bDeviceClass}=="00"
>     ATTRS{bDeviceSubClass}=="00"
>     ATTRS{bDeviceProtocol}=="00"
>     ATTRS{bNumConfigurations}=="1"
>     ATTRS{bMaxPacketSize0}=="64"
>     ATTRS{speed}=="480"
>     ATTRS{busnum}=="1"
>     ATTRS{devnum}=="2"
>     ATTRS{devpath}=="3"
>     ATTRS{version}==" 2.00"
>     ATTRS{maxchild}=="0"
>     ATTRS{quirks}=="0x0"
>     ATTRS{avoid_reset_quirk}=="0"
>     ATTRS{authorized}=="1"
>     ATTRS{manufacturer}=="Hauppauge"
>     ATTRS{product}=="WinTV HVR-950"
>     ATTRS{serial}=="*********"
> 
>   looking at parent device '/devices/pci0000:00/0000:00:1d.7/usb1':
>     KERNELS=="usb1"
>     SUBSYSTEMS=="usb"
>     DRIVERS=="usb"
>     ATTRS{configuration}==""
>     ATTRS{bNumInterfaces}==" 1"
>     ATTRS{bConfigurationValue}=="1"
>     ATTRS{bmAttributes}=="e0"
>     ATTRS{bMaxPower}=="  0mA"
>     ATTRS{urbnum}=="52"
>     ATTRS{idVendor}=="1d6b"
>     ATTRS{idProduct}=="0002"
>     ATTRS{bcdDevice}=="0302"
>     ATTRS{bDeviceClass}=="09"
>     ATTRS{bDeviceSubClass}=="00"
>     ATTRS{bDeviceProtocol}=="00"
>     ATTRS{bNumConfigurations}=="1"
>     ATTRS{bMaxPacketSize0}=="64"
>     ATTRS{speed}=="480"
>     ATTRS{busnum}=="1"
>     ATTRS{devnum}=="1"
>     ATTRS{devpath}=="0"
>     ATTRS{version}==" 2.00"
>     ATTRS{maxchild}=="8"
>     ATTRS{quirks}=="0x0"
>     ATTRS{avoid_reset_quirk}=="0"
>     ATTRS{authorized}=="1"
>     ATTRS{manufacturer}=="Linux 3.2.0-18-generic ehci_hcd"
>     ATTRS{product}=="EHCI Host Controller"
>     ATTRS{serial}=="0000:00:1d.7"
>     ATTRS{authorized_default}=="1"
> 
>   looking at parent device '/devices/pci0000:00/0000:00:1d.7':
>     KERNELS=="0000:00:1d.7"
>     SUBSYSTEMS=="pci"
>     DRIVERS=="ehci_hcd"
>     ATTRS{vendor}=="0x8086"
>     ATTRS{device}=="0x24dd"
>     ATTRS{subsystem_vendor}=="0x1043"
>     ATTRS{subsystem_device}=="0x80a6"
>     ATTRS{class}=="0x0c0320"
>     ATTRS{irq}=="23"
>     ATTRS{local_cpus}=="ff"
>     ATTRS{local_cpulist}=="0-7"
>     ATTRS{dma_mask_bits}=="32"
>     ATTRS{consistent_dma_mask_bits}=="32"
>     ATTRS{enable}=="1"
>     ATTRS{broken_parity_status}=="0"
>     ATTRS{msi_bus}==""
>     ATTRS{companion}==""
>     ATTRS{uframe_periodic_max}=="100"
> 
>   looking at parent device '/devices/pci0000:00':
>     KERNELS=="pci0000:00"
>     SUBSYSTEMS==""
>     DRIVERS==""
> 
> So I tried rules like:
> 
> SUBSYSTEM=="dvb", ATTRS{product}=="WinTV HVR-950", SYMLINK="dvb_pvr950q"
> SUBSYSTEM=="dvb", DRIVERS=="cx18", SYMLINK="dvb_hvr1600"
> 
> but those ended up symlinking to the "net0" device:
> 
> lrwxrwxrwx 1 root root 17 Apr 24 12:56 /dev/dvb_hvr1600 -> dvb/adapter0/net0
> lrwxrwxrwx 1 root root 17 Apr 24 12:56 /dev/dvb_pvr950q -> dvb/adapter1/net0
> 
> How can I create symlinks to the "frontend0" device rather than the
> net0 device?

Maybe by using matches on DEVPATH and/or DEVNAME along with the other
attributes you already check?

# `pactl list | grep -B3 'card_name = "CX18' | awk /Owner Module/ '{print "pactl unload-module " $3}'`
# modprobe -r cx18-alsa
# modprobe -r cx18
# udevadm monitor --kernel --udev --property --subsystem-match=dvb > foo.log &
# modprobe cx18
# fg
^C
# less foo.log

monitor will print the received events for:
UDEV - the event which udev sends out after rule processing
KERNEL - the kernel uevent

KERNEL[1335308536.171634] add      /devices/pci0000:00/0000:00:14.4/0000:03:00.0/dvb/dvb0.demux0 (dvb)
UDEV_LOG=3
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:14.4/0000:03:00.0/dvb/dvb0.demux0
SUBSYSTEM=dvb
DEVNAME=dvb/adapter0/demux0
DVB_ADAPTER_NUM=0
DVB_DEVICE_TYPE=demux
DVB_DEVICE_NUM=0
SEQNUM=2218
MAJOR=212
MINOR=0

KERNEL[1335308536.177080] add      /devices/pci0000:00/0000:00:14.4/0000:03:00.0/dvb/dvb0.dvr0 (dvb)
UDEV_LOG=3
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:14.4/0000:03:00.0/dvb/dvb0.dvr0
SUBSYSTEM=dvb
DEVNAME=dvb/adapter0/dvr0
DVB_ADAPTER_NUM=0
DVB_DEVICE_TYPE=dvr
DVB_DEVICE_NUM=0
SEQNUM=2219
MAJOR=212
MINOR=1

UDEV  [1335308536.198925] add      /devices/pci0000:00/0000:00:14.4/0000:03:00.0/dvb/dvb0.dvr0 (dvb)
UDEV_LOG=3
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:14.4/0000:03:00.0/dvb/dvb0.dvr0
SUBSYSTEM=dvb
DEVNAME=/dev/dvb/adapter0/dvr0
DVB_ADAPTER_NUM=0
DVB_DEVICE_TYPE=dvr
DVB_DEVICE_NUM=0
SEQNUM=2219
nodmraid=1
MAJOR=212
MINOR=1
TAGS=:udev-acl:

UDEV  [1335308536.201584] add      /devices/pci0000:00/0000:00:14.4/0000:03:00.0/dvb/dvb0.demux0 (dvb)
UDEV_LOG=3
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:14.4/0000:03:00.0/dvb/dvb0.demux0
SUBSYSTEM=dvb
DEVNAME=/dev/dvb/adapter0/demux0
DVB_ADAPTER_NUM=0
DVB_DEVICE_TYPE=demux
DVB_DEVICE_NUM=0
SEQNUM=2218
nodmraid=1
MAJOR=212
MINOR=0
TAGS=:udev-acl:

KERNEL[1335308536.258048] add      /devices/pci0000:00/0000:00:14.4/0000:03:00.0/dvb/dvb0.frontend0 (dvb)
UDEV_LOG=3
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:14.4/0000:03:00.0/dvb/dvb0.frontend0
SUBSYSTEM=dvb
DEVNAME=dvb/adapter0/frontend0
DVB_ADAPTER_NUM=0
DVB_DEVICE_TYPE=frontend
DVB_DEVICE_NUM=0
SEQNUM=2222
MAJOR=212
MINOR=2

KERNEL[1335308536.260246] add      /devices/pci0000:00/0000:00:14.4/0000:03:00.0/dvb/dvb0.net0 (dvb)
UDEV_LOG=3
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:14.4/0000:03:00.0/dvb/dvb0.net0
SUBSYSTEM=dvb
DEVNAME=dvb/adapter0/net0
DVB_ADAPTER_NUM=0
DVB_DEVICE_TYPE=net
DVB_DEVICE_NUM=0
SEQNUM=2223
MAJOR=212
MINOR=3

UDEV  [1335308536.278415] add      /devices/pci0000:00/0000:00:14.4/0000:03:00.0/dvb/dvb0.net0 (dvb)
UDEV_LOG=3
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:14.4/0000:03:00.0/dvb/dvb0.net0
SUBSYSTEM=dvb
DEVNAME=/dev/dvb/adapter0/net0
DVB_ADAPTER_NUM=0
DVB_DEVICE_TYPE=net
DVB_DEVICE_NUM=0
SEQNUM=2223
nodmraid=1
MAJOR=212
MINOR=3

UDEV  [1335308536.292451] add      /devices/pci0000:00/0000:00:14.4/0000:03:00.0/dvb/dvb0.frontend0 (dvb)
UDEV_LOG=3
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:14.4/0000:03:00.0/dvb/dvb0.frontend0
SUBSYSTEM=dvb
DEVNAME=/dev/dvb/adapter0/frontend0
DVB_ADAPTER_NUM=0
DVB_DEVICE_TYPE=frontend
DVB_DEVICE_NUM=0
SEQNUM=2222
nodmraid=1
MAJOR=212
MINOR=2
TAGS=:udev-acl:

Regards,
Andy W.

> Cheers,
> b.
> 
> [1] You might wonder why I would care given that they both do
>     quite the same thing and who cares which one is "0" and which
>     one is "1".  But the reality is that while they might function
>     the same the HVR-1600 produces streams with "glitches" in them
>     (see my other message to this list "HVR-1600 QAM recordings with
>     slight glitches in them" -- but yes, otherwise I couldn't really
>     care less about which was which) and the PVR-950Q produces _perfect_
>     streams, so I really only want to use the HVR-1600 in "overflow"
>     situations.
> 


