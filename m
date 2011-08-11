Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54300 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab1HKOrF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2011 10:47:05 -0400
Received: by gxk21 with SMTP id 21so1351733gxk.19
        for <linux-media@vger.kernel.org>; Thu, 11 Aug 2011 07:47:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL9G6WXnXJwfCZY5gZ8Qph_RuP29PVDCeYT037-e=T9fCo3PVg@mail.gmail.com>
References: <CAL9G6WXnXJwfCZY5gZ8Qph_RuP29PVDCeYT037-e=T9fCo3PVg@mail.gmail.com>
Date: Thu, 11 Aug 2011 16:47:03 +0200
Message-ID: <CAL9G6WX=e5c_gXw8yC76-1XDTT7_wxyDnak6TjyZHz9cUWuM5g@mail.gmail.com>
Subject: Re: Problems with Tevii S660
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/8/11 Josu Lazkano <josu.lazkano@gmail.com>:
> Hello list, I just bought a Tevii S660 DVB-S2 USb tunner and I have
> some problems with it. I already has the Tevii S470 card and it works
> great with this configuration:
>
> mkdir /usr/local/src/dvb
> cd /usr/local/src/dvb
> wget http://tevii.com/100315_Beta_linux_tevii_ds3000.rar
> unrar x 100315_Beta_linux_tevii_ds3000.rar
> cp *.fw /lib/firmware
> tar xjvf linux-tevii-ds3000.tar.bz2
> cd linux-tevii-ds3000
> make && make install
>
> I am using Debian Squeeze with stable kernel: 2.6.32-5-686
>
> I configured the modprobe this way:
>
> # cat /etc/modprobe.d/options.conf
> #Tevii S470
> options cx23885 adapter_nr=7
> #Tevii S660
> options dvb-usb-dw2102 adapter_nr=6
> #Disable the IR
> options dvb-usb disable_rc_polling=1
>
> At first time it works well, I just pluged it and it creates a dvb
> device on /dev/dvb/adapter6 and the dmesg is correct (I have not a
> copy of the message). I didn't try yet to watch any channel (I am
> uusing MythTV).
>
> I reboot the machine and there are some USB error on the boot
> secuence, something like this:
>
> ... device descriptor read/64, error -110
>
> (Here is a photo of the screen: http://i53.tinypic.com/2u3z5s0.jpg)
>
> After a long boot, I execute the dmesg and this is what I get:
>
> [  145.909045] usb 4-2: device descriptor read/64, error -110
> [  146.189073] usb 4-2: new full speed USB device using ohci_hcd and address 5
> [  151.208761] usb 4-2: device descriptor read/8, error -110
> [  156.329684] usb 4-2: device descriptor read/8, error -110
> [  156.612043] usb 4-2: new full speed USB device using ohci_hcd and address 6
> [  161.636610] usb 4-2: device descriptor read/8, error -110
> [  166.756544] usb 4-2: device descriptor read/8, error -110
> [  166.864081] hub 4-0:1.0: unable to enumerate USB device on port 2
>
> And there is no device on lsusb.
>
> Then I try to boot without the device, it start well the machine, then
> plug the device and this is the dmesg:
>
> [  162.372030] usb 1-2: new high speed USB device using ehci_hcd and address 2
> [  177.484038] usb 1-2: device descriptor read/64, error -110
> [  192.700039] usb 1-2: device descriptor read/64, error -110
> [  192.920036] usb 1-2: new high speed USB device using ehci_hcd and address 3
> [  208.028034] usb 1-2: device descriptor read/64, error -110
> [  223.252028] usb 1-2: device descriptor read/64, error -110
> [  223.465028] usb 1-2: new high speed USB device using ehci_hcd and address 4
> [  228.484176] usb 1-2: device descriptor read/8, error -110
> [  233.604097] usb 1-2: device descriptor read/8, error -110
> [  233.820029] usb 1-2: new high speed USB device using ehci_hcd and address 5
> [  238.840170] usb 1-2: device descriptor read/8, error -110
> [  243.961092] usb 1-2: device descriptor read/8, error -110
> [  244.064050] hub 1-0:1.0: unable to enumerate USB device on port 2
> [  244.392034] usb 3-2: new full speed USB device using ohci_hcd and address 2
> [  259.568033] usb 3-2: device descriptor read/64, error -110
> [  274.848036] usb 3-2: device descriptor read/64, error -110
> [  275.128035] usb 3-2: new full speed USB device using ohci_hcd and address 3
>
> I contact with Tevii, but there is no support for this device on
> Linux, they point me to go to
> http://mercurial.intuxication.org/hg/s2-liplianin/
>
> I read some users having same problem with this device, here is one
> that resolve it uploading I new firmware on each boot:
> http://www.gilzad.de/blog/pivot/entry.php?id=7
>
> Can you help with this?
>
> I am not an expert on kernel/driver/firmware, I will apreciate any help.
>
> Thanks for your help and best regards.
>
>
> --
> Josu Lazkano
>

Hello again, I try it on the work again, I just install the driver and
set the modprobe. I attached and all looks well:

$ dmesg
[ 5424.064262] usb 1-3: new high speed USB device using ehci_hcd and address 4
[ 5424.196383] usb 1-3: New USB device found, idVendor=9022, idProduct=d660
[ 5424.196387] usb 1-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[ 5424.196481] usb 1-3: configuration #1 chosen from 1 choice
[ 5424.433400] dvb-usb: found a 'TeVii S660 USB' in cold state, will
try to load a firmware
[ 5424.433403] usb 1-3: firmware: requesting dvb-usb-teviis660.fw
[ 5424.548027] dvb-usb: downloading firmware from file 'dvb-usb-teviis660.fw'
[ 5424.548030] dw2102: start downloading DW210X firmware
[ 5424.564904] usb 1-3: USB disconnect, address 4
[ 5424.668011] dvb-usb: found a 'TeVii S660 USB' in warm state.
[ 5424.668045] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[ 5424.668062] DVB: registering new adapter (TeVii S660 USB)
[ 5428.764009] dvb-usb: MAC address: d3:d3:d3:d3:d3:d3
[ 5428.828255] Only Zarlink VP310/MT312/ZL10313 are supported chips.
[ 5429.084260] Invalid probe, probably not a DS3000
[ 5429.084322] dvb-usb: no frontend was attached by 'TeVii S660 USB'
[ 5429.084325] dvb-usb: TeVii S660 USB successfully initialized and connected.
[ 5429.084353] usbcore: registered new interface driver dw2102
[ 5429.084591] dvb-usb: TeVii S660 USB successfully deinitialized and
disconnected.
[ 5429.324012] usb 1-3: new high speed USB device using ehci_hcd and address 5
[ 5429.456657] usb 1-3: config 1 interface 0 altsetting 0 bulk
endpoint 0x81 has invalid maxpacket 2
[ 5429.457030] usb 1-3: New USB device found, idVendor=9022, idProduct=d660
[ 5429.457033] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 5429.457036] usb 1-3: Product: DVBS2BOX
[ 5429.457038] usb 1-3: Manufacturer: TBS-Tech
[ 5429.457122] usb 1-3: configuration #1 chosen from 1 choice
[ 5429.457318] dvb-usb: found a 'TeVii S660 USB' in cold state, will
try to load a firmware
[ 5429.457322] usb 1-3: firmware: requesting dvb-usb-teviis660.fw
[ 5429.459604] dvb-usb: downloading firmware from file 'dvb-usb-teviis660.fw'
[ 5429.459606] dw2102: start downloading DW210X firmware
[ 5429.580262] dvb-usb: found a 'TeVii S660 USB' in warm state.
[ 5429.580293] dvb-usb: will pass the complete MPEG2 transport stream
to the software demuxer.
[ 5429.580419] DVB: registering new adapter (TeVii S660 USB)
[ 5433.676256] dvb-usb: MAC address: 00:18:bd:xx:xx:xx
[ 5433.696007] Only Zarlink VP310/MT312/ZL10313 are supported chips.
[ 5433.972008] DS3000 chip version: 0.192 attached.
[ 5433.972010] dw2102: Attached ds3000+ds2020!
[ 5433.972011]
[ 5433.972158] DVB: registering adapter 6 frontend 0 (Montage
Technology DS3000/TS2020)...
[ 5433.972409] dvb-usb: TeVii S660 USB successfully initialized and connected.

$ lsusb
...
Bus 001 Device 005: ID 9022:d660 TeVii Technology Ltd. DVB-S2 S660
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

$ ls -l /dev/dvb/
total 0
drwxr-xr-x 2 root root 120 Aug 11 16:18 adapter6

I have not a dish here to test the signal, but it looks well. I reboot
with device connected and it has no errors, maybe it is my hardware
issue. I will try again when arrive to home, the hardware is a Nvidia
ION board.

Regards.

-- 
Josu Lazkano
