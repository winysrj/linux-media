Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:18930 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbZLBH2X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2009 02:28:23 -0500
Received: by ey-out-2122.google.com with SMTP id 4so1391270eyf.19
        for <linux-media@vger.kernel.org>; Tue, 01 Dec 2009 23:28:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B15E9F0.3050701@wilsononline.id.au>
References: <4B15C45F.7020909@wilsononline.id.au> <4B15E9F0.3050701@wilsononline.id.au>
From: ALi <osatien@gmail.com>
Date: Wed, 2 Dec 2009 08:28:07 +0100
Message-ID: <431ff28c0912012328j3956c544h132b7c3995fd01ee@mail.gmail.com>
Subject: Re: dvb_usb_dib0700 ( T14BR) not initializing on reboot
To: Paul <mylists@wilsononline.id.au>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Are you sure that your usb is dib0700?
if you look on the sources .... you wont see idVendor=413c,
idProduct=3010 however there is

oscar@X-Evian:/usr/src/linux-source-2.6.30/drivers/media/dvb/dvb-usb$
grep 05d8 * -iR
Coincidencia en el fichero binario dvb-usb-dib0700.ko
dvb-usb-dib0700.mod.c:MODULE_ALIAS("usb:v05D8p810Fd*dc*dsc*dp*ic*isc*ip*");


in the file .... so .... try to recompile it with your device id, and
pray for it :)

On Wed, Dec 2, 2009 at 5:15 AM, Paul <mylists@wilsononline.id.au> wrote:
> On 2/12/2009 12:35 PM, Paul wrote:
>>
>> I have a DVB-T USB device ( T14BR),
>> which seems to work fine when I plug in my Fedora 10 box but I if I
>> reboot with device connected it regularity fails to initialise correctly
>> and to correct I have to remove unplug-device remove the module and
>> reload module to fix up and only after system has been fully booted
>>
>> eg
>> modprobe -r dvb-usb-dib0700
>> then
>> modprobe dvb-usb-dib0700  adapter_nr=2
>> and then plug device in.
>> I get the following msgs when it seems to fail and the second set when
>> it works
>>
>> kernel log (failed)
>>
>> Nov 22 13:51:50 mythbox kernel: usb 2-7: new full speed USB device using
>> ohci_hcd and address 2
>> Nov 22 13:51:50 mythbox kernel: usb 2-7: new full speed USB device using
>> ohci_hcd and address 3
>> Nov 22 13:51:50 mythbox kernel: usb 2-7: new full speed USB device using
>> ohci_hcd and address 4
>> Nov 22 13:51:50 mythbox kernel: usb 2-7: new full speed USB device using
>> ohci_hcd and address 5
>> Nov 22 13:51:50 mythbox kernel: usb 2-8: new low speed USB device using
>> ohci_hcd and address 6
>> Nov 22 13:51:50 mythbox kernel: usb 2-8: configuration #1 chosen from 1
>> choice
>> Nov 22 13:51:50 mythbox kernel: usb 2-8: New USB device found,
>> idVendor=413c, idProduct=3010
>> Nov 22 13:51:50 mythbox kernel: usb 2-8: New USB device strings: Mfr=0,
>> Product=0, SerialNumber=0
>> Nov 22 13:51:50 mythbox kernel: usbcore: registered new interface driver
>> hiddev
>> Nov 22 13:51:50 mythbox kernel: input: HID 413c:3010 as
>> /devices/pci0000:00/0000:00:02.0/usb2/2-8/2-8:1.0/input/input4
>> Nov 22 13:51:50 mythbox kernel: input,hidraw0: USB HID v1.00 Mouse [HID
>> 413c:3010] on usb-0000:00:02.0-8
>> Nov 22 13:51:50 mythbox kernel: usbcore: registered new interface driver
>> usbhid
>> Nov 22 13:51:50 mythbox kernel: usbhid: v2.6:USB HID core driver
>>
>>
>> http://www.artectv.com/ehtm/products/t14.htm
>>
>> kernel log (working)
>>
>> Nov 29 09:58:20 mythbox kernel: usb 1-8: new high speed USB device using
>> ehci_hcd and address 3
>> Nov 29 09:58:20 mythbox kernel: usb 1-8: configuration #1 chosen from 1
>> choice
>> Nov 29 09:58:20 mythbox kernel: usb 1-8: New USB device found,
>> idVendor=05d8, idProduct=810f
>> Nov 29 09:58:20 mythbox kernel: usb 1-8: New USB device strings: Mfr=1,
>> Product=2, SerialNumber=3
>> Nov 29 09:58:20 mythbox kernel: usb 1-8: Product: ART7070
>> Nov 29 09:58:20 mythbox kernel: usb 1-8: Manufacturer: Ultima
>> Nov 29 09:58:20 mythbox kernel: usb 1-8: SerialNumber: 001
>> Nov 29 09:58:20 mythbox kernel: dib0700: loaded with support for 7
>> different device-types
>> Nov 29 09:58:20 mythbox kernel: dvb-usb: found a 'Artec T14BR DVB-T' in
>> cold state, will try to load a firmware
>> Nov 29 09:58:20 mythbox kernel: firmware: requesting
>> dvb-usb-dib0700-1.10.fw
>> Nov 29 09:58:20 mythbox kernel: dvb-usb: downloading firmware from file
>> 'dvb-usb-dib0700-1.10.fw'
>> Nov 29 09:58:22 mythbox kernel: dib0700: firmware started successfully.
>> Nov 29 09:58:23 mythbox kernel: dvb-usb: found a 'Artec T14BR DVB-T' in
>> warm state.
>> Nov 29 09:58:23 mythbox kernel: dvb-usb: will pass the complete MPEG2
>> transport stream to the software demuxer.
>> Nov 29 09:58:23 mythbox kernel: DVB: registering new adapter (Artec
>> T14BR DVB-T)
>> Nov 29 09:58:23 mythbox kernel: DiB0070: successfully identified
>> Nov 29 09:58:23 mythbox kernel: input: IR-receiver inside an USB DVB
>> receiver as /devices/pci0000:00/0000:00:02.1/usb1/1
>> -8/input/input7
>> Nov 29 09:58:23 mythbox kernel: dvb-usb: schedule remote query interval
>> to 150 msecs.
>> Nov 29 09:58:23 mythbox kernel: dvb-usb: Artec T14BR DVB-T successfully
>> initialized and connected.
>>
>>
>
>
> Note I googled a few other people with the same issue:
>
> http://www.linuxtv.org/pipermail/linux-dvb/2007-November/022145.html
> http://ubuntuforums.org/archive/index.php/t-1233131.html
>
> so I'm assuming its a known issue, right?
>
> Paul
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
