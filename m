Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <FlyMyPG@gmail.com>) id 1L4Hwl-0005Vb-Df
	for linux-dvb@linuxtv.org; Sun, 23 Nov 2008 17:36:36 +0100
Received: from cpe-24-165-6-130.san.res.rr.com ([24.165.6.130])
	by cdptpa-omta05.mail.rr.com with ESMTP id
	<20081123163556.DZYP7376.cdptpa-omta05.mail.rr.com@cpe-24-165-6-130.san.res.rr.com>
	for <linux-dvb@linuxtv.org>; Sun, 23 Nov 2008 16:35:56 +0000
Message-ID: <4929866C.5010109@gmail.com>
Date: Sun, 23 Nov 2008 08:35:56 -0800
From: Bob Cunningham <FlyMyPG@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <49287DCC.9040004@gmail.com>
In-Reply-To: <49287DCC.9040004@gmail.com>
Subject: Re: [linux-dvb] AnyTV AUTV002 USB ATSC/QAM Tuner Stick
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I previously wrote:
> Hi,
> 
> I just bought an AnyTV AUTV002 USB Tuner Stick from DealExtreme.  When plugged in, lsusb provides the following:
> 
>    Bus 001 Device 011: ID 05e1:0400 Syntek Semiconductor Co., Ltd 
> 
> A quick search revealed that the au0828 driver had recently been updated (10 Nov) to support this USB ID.
> 
> Following instructions on the wiki, I obtained the latest v4l-dvb source via Mercurial, and built/installed it without error.  Next I did "modprobe au0828", and dmesg provided the following:
> 
>     au0828 driver loaded
>     usbcore: registered new interface driver au0828
> 
> Next I did "lsmod | grep au0828", which provides the following:
> 
>    au0828                 20384  0 
>    dvb_core               68673  1 au0828
>    tveeprom               14917  1 au0828
>    i2c_core               20949  4 au0828,tveeprom,nvidia,i2c_i801
> 
> dmesg provides the following when the device is plugged in:
> 
>    usb 1-2: new high speed USB device using ehci_hcd and address 10
>    usb 1-2: configuration #1 chosen from 1 choice
>    usb 1-2: New USB device found, idVendor=05e1, idProduct=0400
>    usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>    usb 1-2: Product: USB 2.0 Video Capture Controller
>    usb 1-2: Manufacturer: Syntek Semiconductor
> 
> However, I have no /dev/dvb.  I unplugged/replugged several times, with no change.
> 
> I rebooted and repeated the modprobe and the unplug/replug, with no different results.
> 
> My guess is that udev isn't making the connection from the USB ID, but I'm not sure what to do about it.  
> 
> I'm running a fully updated FC8 on a Dell dual Xeon-HT server with kernel 2.6.26.6-49.fc8 #1 SMP.
> 
> Did I miss something basic?
> 
> 
> Thanks,
> 
> -BobC


Hi again,

To see what's happening in the udev domain, I added the following rule to hopefully let the system know that I'm trying to plug in a v4l device:

/etc/udev/rules.d/25-name-video-devices.rules:
    SUBSYSTEM=="video4linux", BUS=="usb", SYSFS{idVendor}=="05e1", SYSFS{idProduct}=="0400", NAME="video0"

At the end of this note is the output of "udevmonitor --environment" that is generated when the tuner stick is plugged in.  Sorry for the length, but I'm not sure what's important.  Though I don't know what should be happening for this device, it seems I'm adding lots of endpoints, but the only devices identified are for sound.  No video.

How do I get the au0828 driver to accept this device?


Thanks,

-BobC


Output of "udevmonitor --environment":

udevmonitor will print the received events for:
UDEV the event which udev sends out after rule processing
UEVENT the kernel uevent

UEVENT[1227456137.360734] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-2 (usb)
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2
SUBSYSTEM=usb
MAJOR=189
MINOR=11
DEVTYPE=usb_device
PHYSDEVBUS=usb
DEVICE=/proc/bus/usb/001/012
PRODUCT=5e1/400/5
TYPE=0/0/0
BUSNUM=001
DEVNUM=012
SEQNUM=1605

UEVENT[1227456137.361600] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.0 (usb)
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.0
SUBSYSTEM=usb
DEVTYPE=usb_interface
PHYSDEVBUS=usb
DEVICE=/proc/bus/usb/001/012
PRODUCT=5e1/400/5
TYPE=0/0/0
INTERFACE=255/255/255
MODALIAS=usb:v05E1p0400d0005dc00dsc00dp00icFFiscFFipFF
SEQNUM=1606

UEVENT[1227456137.361624] add      /class/usb_endpoint/usbdev1.12_ep81 (usb_endpoint)
ACTION=add
DEVPATH=/class/usb_endpoint/usbdev1.12_ep81
SUBSYSTEM=usb_endpoint
MAJOR=250
MINOR=8
PHYSDEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.0
PHYSDEVBUS=usb
SEQNUM=1607

UEVENT[1227456137.362218] add      /class/usb_endpoint/usbdev1.12_ep82 (usb_endpoint)
ACTION=add
DEVPATH=/class/usb_endpoint/usbdev1.12_ep82
SUBSYSTEM=usb_endpoint
MAJOR=250
MINOR=9
PHYSDEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.0
PHYSDEVBUS=usb
SEQNUM=1608

UEVENT[1227456137.362238] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.1 (usb)
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.1
SUBSYSTEM=usb
DEVTYPE=usb_interface
PHYSDEVBUS=usb
DEVICE=/proc/bus/usb/001/012
PRODUCT=5e1/400/5
TYPE=0/0/0
INTERFACE=1/1/0
MODALIAS=usb:v05E1p0400d0005dc00dsc00dp00ic01isc01ip00
SEQNUM=1609

UEVENT[1227456137.363306] add      /class/sound/pcmC1D0c (sound)
ACTION=add
DEVPATH=/class/sound/pcmC1D0c
SUBSYSTEM=sound
MAJOR=116
MINOR=10
PHYSDEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.1
PHYSDEVBUS=usb
PHYSDEVDRIVER=snd-usb-audio
SEQNUM=1610

UEVENT[1227456137.363324] add      /class/sound/dsp1 (sound)
ACTION=add
DEVPATH=/class/sound/dsp1
SUBSYSTEM=sound
MAJOR=14
MINOR=19
PHYSDEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.1
PHYSDEVBUS=usb
PHYSDEVDRIVER=snd-usb-audio
SEQNUM=1611

UEVENT[1227456137.363878] add      /class/sound/audio1 (sound)
ACTION=add
DEVPATH=/class/sound/audio1
SUBSYSTEM=sound
MAJOR=14
MINOR=20
PHYSDEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.1
PHYSDEVBUS=usb
PHYSDEVDRIVER=snd-usb-audio
SEQNUM=1612

UEVENT[1227456137.363898] add      /class/sound/controlC1 (sound)
ACTION=add
DEVPATH=/class/sound/controlC1
SUBSYSTEM=sound
MAJOR=116
MINOR=11
PHYSDEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.1
PHYSDEVBUS=usb
PHYSDEVDRIVER=snd-usb-audio
SEQNUM=1613

UEVENT[1227456137.364445] add      /class/sound/mixer1 (sound)
ACTION=add
DEVPATH=/class/sound/mixer1
SUBSYSTEM=sound
MAJOR=14
MINOR=16
PHYSDEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.1
PHYSDEVBUS=usb
PHYSDEVDRIVER=snd-usb-audio
SEQNUM=1614

UEVENT[1227456137.364864] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.2 (usb)
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.2
SUBSYSTEM=usb
DEVTYPE=usb_interface
DRIVER=snd-usb-audio
PHYSDEVBUS=usb
PHYSDEVDRIVER=snd-usb-audio
DEVICE=/proc/bus/usb/001/012
PRODUCT=5e1/400/5
TYPE=0/0/0
INTERFACE=1/2/0
MODALIAS=usb:v05E1p0400d0005dc00dsc00dp00ic01isc02ip00
SEQNUM=1615

UEVENT[1227456137.365333] add      /class/usb_endpoint/usbdev1.12_ep84 (usb_endpoint)
ACTION=add
DEVPATH=/class/usb_endpoint/usbdev1.12_ep84
SUBSYSTEM=usb_endpoint
MAJOR=250
MINOR=10
PHYSDEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.2
PHYSDEVBUS=usb
PHYSDEVDRIVER=snd-usb-audio
SEQNUM=1616

UEVENT[1227456137.365632] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.3 (usb)
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.3
SUBSYSTEM=usb
DEVTYPE=usb_interface
PHYSDEVBUS=usb
DEVICE=/proc/bus/usb/001/012
PRODUCT=5e1/400/5
TYPE=0/0/0
INTERFACE=255/255/255
MODALIAS=usb:v05E1p0400d0005dc00dsc00dp00icFFiscFFipFF
SEQNUM=1617

UEVENT[1227456137.365916] add      /class/usb_endpoint/usbdev1.12_ep83 (usb_endpoint)
ACTION=add
DEVPATH=/class/usb_endpoint/usbdev1.12_ep83
SUBSYSTEM=usb_endpoint
MAJOR=250
MINOR=11
PHYSDEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.3
PHYSDEVBUS=usb
SEQNUM=1618

UEVENT[1227456137.366631] add      /class/usb_endpoint/usbdev1.12_ep00 (usb_endpoint)
ACTION=add
DEVPATH=/class/usb_endpoint/usbdev1.12_ep00
SUBSYSTEM=usb_endpoint
MAJOR=250
MINOR=12
PHYSDEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2
PHYSDEVBUS=usb
PHYSDEVDRIVER=usb
SEQNUM=1619

UDEV  [1227456137.378540] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-2 (usb)
UDEV_LOG=3
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2
SUBSYSTEM=usb
MAJOR=189
MINOR=11
DEVTYPE=usb_device
PHYSDEVBUS=usb
DEVICE=/proc/bus/usb/001/012
PRODUCT=5e1/400/5
TYPE=0/0/0
BUSNUM=001
DEVNUM=012
SEQNUM=1605
UDEVD_EVENT=1
DEVNAME=/dev/bus/usb/001/012

UDEV  [1227456137.423287] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.2 (usb)
UDEV_LOG=3
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.2
SUBSYSTEM=usb
DEVTYPE=usb_interface
DRIVER=snd-usb-audio
PHYSDEVBUS=usb
PHYSDEVDRIVER=snd-usb-audio
DEVICE=/proc/bus/usb/001/012
PRODUCT=5e1/400/5
TYPE=0/0/0
INTERFACE=1/2/0
MODALIAS=usb:v05E1p0400d0005dc00dsc00dp00ic01isc02ip00
SEQNUM=1615
UDEVD_EVENT=1

UDEV  [1227456137.442648] add      /class/usb_endpoint/usbdev1.12_ep84 (usb_endpoint)
UDEV_LOG=3
ACTION=add
DEVPATH=/class/usb_endpoint/usbdev1.12_ep84
SUBSYSTEM=usb_endpoint
MAJOR=250
MINOR=10
PHYSDEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.2
PHYSDEVBUS=usb
PHYSDEVDRIVER=snd-usb-audio
SEQNUM=1616
UDEVD_EVENT=1
DEVNAME=/dev/usbdev1.12_ep84

UDEV  [1227456137.450632] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.1 (usb)
UDEV_LOG=3
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.1
SUBSYSTEM=usb
DEVTYPE=usb_interface
PHYSDEVBUS=usb
DEVICE=/proc/bus/usb/001/012
PRODUCT=5e1/400/5
TYPE=0/0/0
INTERFACE=1/1/0
MODALIAS=usb:v05E1p0400d0005dc00dsc00dp00ic01isc01ip00
SEQNUM=1609
UDEVD_EVENT=1

UDEV  [1227456137.462968] add      /class/sound/mixer1 (sound)
UDEV_LOG=3
ACTION=add
DEVPATH=/class/sound/mixer1
SUBSYSTEM=sound
MAJOR=14
MINOR=16
PHYSDEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.1
PHYSDEVBUS=usb
PHYSDEVDRIVER=snd-usb-audio
SEQNUM=1614
UDEVD_EVENT=1
DEVNAME=/dev/mixer1

UDEV  [1227456137.464124] add      /class/sound/audio1 (sound)
UDEV_LOG=3
ACTION=add
DEVPATH=/class/sound/audio1
SUBSYSTEM=sound
MAJOR=14
MINOR=20
PHYSDEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.1
PHYSDEVBUS=usb
PHYSDEVDRIVER=snd-usb-audio
SEQNUM=1612
UDEVD_EVENT=1
DEVNAME=/dev/audio1

UDEV  [1227456137.480950] add      /class/sound/pcmC1D0c (sound)
UDEV_LOG=3
ACTION=add
DEVPATH=/class/sound/pcmC1D0c
SUBSYSTEM=sound
MAJOR=116
MINOR=10
PHYSDEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.1
PHYSDEVBUS=usb
PHYSDEVDRIVER=snd-usb-audio
SEQNUM=1610
UDEVD_EVENT=1
DEVNAME=/dev/snd/pcmC1D0c

UDEV  [1227456137.484585] add      /class/sound/controlC1 (sound)
UDEV_LOG=3
ACTION=add
DEVPATH=/class/sound/controlC1
SUBSYSTEM=sound
MAJOR=116
MINOR=11
PHYSDEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.1
PHYSDEVBUS=usb
PHYSDEVDRIVER=snd-usb-audio
SEQNUM=1613
UDEVD_EVENT=1
DEVNAME=/dev/snd/controlC1

UDEV  [1227456137.489291] add      /class/sound/dsp1 (sound)
UDEV_LOG=3
ACTION=add
DEVPATH=/class/sound/dsp1
SUBSYSTEM=sound
MAJOR=14
MINOR=19
PHYSDEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.1
PHYSDEVBUS=usb
PHYSDEVDRIVER=snd-usb-audio
SEQNUM=1611
UDEVD_EVENT=1
DEVNAME=/dev/dsp1

UDEV  [1227456137.491488] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.0 (usb)
UDEV_LOG=3
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.0
SUBSYSTEM=usb
DEVTYPE=usb_interface
PHYSDEVBUS=usb
DEVICE=/proc/bus/usb/001/012
PRODUCT=5e1/400/5
TYPE=0/0/0
INTERFACE=255/255/255
MODALIAS=usb:v05E1p0400d0005dc00dsc00dp00icFFiscFFipFF
SEQNUM=1606
UDEVD_EVENT=1

UDEV  [1227456137.510251] add      /class/usb_endpoint/usbdev1.12_ep82 (usb_endpoint)
UDEV_LOG=3
ACTION=add
DEVPATH=/class/usb_endpoint/usbdev1.12_ep82
SUBSYSTEM=usb_endpoint
MAJOR=250
MINOR=9
PHYSDEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.0
PHYSDEVBUS=usb
SEQNUM=1608
UDEVD_EVENT=1
DEVNAME=/dev/usbdev1.12_ep82

UDEV  [1227456137.534106] add      /devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.3 (usb)
UDEV_LOG=3
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.3
SUBSYSTEM=usb
DEVTYPE=usb_interface
PHYSDEVBUS=usb
DEVICE=/proc/bus/usb/001/012
PRODUCT=5e1/400/5
TYPE=0/0/0
INTERFACE=255/255/255
MODALIAS=usb:v05E1p0400d0005dc00dsc00dp00icFFiscFFipFF
SEQNUM=1617
UDEVD_EVENT=1

UDEV  [1227456137.535262] add      /class/usb_endpoint/usbdev1.12_ep81 (usb_endpoint)
UDEV_LOG=3
ACTION=add
DEVPATH=/class/usb_endpoint/usbdev1.12_ep81
SUBSYSTEM=usb_endpoint
MAJOR=250
MINOR=8
PHYSDEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.0
PHYSDEVBUS=usb
SEQNUM=1607
UDEVD_EVENT=1
DEVNAME=/dev/usbdev1.12_ep81

UDEV  [1227456137.542033] add      /class/usb_endpoint/usbdev1.12_ep83 (usb_endpoint)
UDEV_LOG=3
ACTION=add
DEVPATH=/class/usb_endpoint/usbdev1.12_ep83
SUBSYSTEM=usb_endpoint
MAJOR=250
MINOR=11
PHYSDEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.3
PHYSDEVBUS=usb
SEQNUM=1618
UDEVD_EVENT=1
DEVNAME=/dev/usbdev1.12_ep83

UDEV  [1227456137.545002] add      /class/usb_endpoint/usbdev1.12_ep00 (usb_endpoint)
UDEV_LOG=3
ACTION=add
DEVPATH=/class/usb_endpoint/usbdev1.12_ep00
SUBSYSTEM=usb_endpoint
MAJOR=250
MINOR=12
PHYSDEVPATH=/devices/pci0000:00/0000:00:1d.7/usb1/1-2
PHYSDEVBUS=usb
PHYSDEVDRIVER=usb
SEQNUM=1619
UDEVD_EVENT=1
DEVNAME=/dev/usbdev1.12_ep00


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
