Return-path: <linux-media-owner@vger.kernel.org>
Received: from psmtp31.wxs.nl ([195.121.247.33]:61197 "EHLO psmtp31.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbZFERUm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Jun 2009 13:20:42 -0400
Received: from localhost.sitecomwl312
 (ip545779c6.direct-adsl.nl [84.87.121.198])
 by psmtp31.wxs.nl (iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14
 2006)) with ESMTP id <0KKS007TU06ENO@psmtp31.wxs.nl> for
 linux-media@vger.kernel.org; Fri, 05 Jun 2009 19:20:43 +0200 (CEST)
Date: Fri, 05 Jun 2009 19:20:37 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
Subject: Re: [not working] Conceptronic USB 2.0 Digital TV Receiver - CTVDIGRCU
 - Device Information
In-reply-to: <4A2941E9.5090003@powercraft.nl>
To: Jelle de Jong <jelledejong@powercraft.nl>
Cc: Antti Palosaari <crope@iki.fi>, jhoogenraad@linuxtv.org,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
Message-id: <4A2953E5.7030307@hoogenraad.net>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 8BIT
References: <49F189BC.5090606@powercraft.nl> <49F1ADF3.2030901@iki.fi>
 <49F1AFC9.2040405@powercraft.nl> <49F1BA30.6060702@iki.fi>
 <4A293802.8070404@iki.fi> <4A2941E9.5090003@powercraft.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jelle de Jong wrote:
> Antti Palosaari wrote:
>> Terve Jelle,
>>
>> On 04/24/2009 04:10 PM, Antti Palosaari wrote:
>>> On 04/24/2009 03:25 PM, Jelle de Jong wrote:
>>>> I got an USB ID 14aa:0160 Conceptronic USB2.0 DVB-T CTVDIGRCU V2.0 but I
>>>> have no idea what chipsets it contains. Could somebody extract the
>>>> drivers to be sure? (see my first mail for driver web pages)
>>>> http://www.conceptronic.net/site/desktopdefault.aspx?tabindex=0&tabid=420&pc=CTVDIGRCU
>>>>
>>> There is no drivers for device USB-ID 14aa:0160.
>>>
>>> ; Copyright (C) Wideviewer Corporation, 2005 All Rights Reserved.
>>> ;
>>> ; USB DVB-T Adapter
>>> ; WideViewer DVB-T WT-225U
>>>
>>> ; The Vendor ID =14AA, and the Product ID =0226
>>> %DevModel.DeviceDesc%=DevModel.Dev,USB\VID_14AA&PID_0226&MI_00
>>>
>>> According to google search it could be Realtek.
>>> http://ubuntuforums.org/showthread.php?t=822291&page=2
>> I just got that device from post. I installed driver from:
>> http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2
>> and it is working :(
>>
>> Driver identifies this device as "Freecom USB 2.0 DVB-T Device".
>>
>> I have don't know exactly what's driver status currently - is is only in 
>> development tree currently. Could Jan Hoogenraad comment what should do 
>> before driver is ready to the master release?
>>
>> regards
>> Antti
> 
> That is great news, now lets see what is needed to get the code stable
> in the mainstream kernel code. So it will work out of the box with the
> upcoming kernel releases.
> 
> Did you need any proprietary firmware?
> 
> Does the device work with mplayer does the dvb-t radio work?
> 
> Cheers,
> 
> Jelle
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
In kernel integration: I'll re-post my entry of september 16, 2008.
This entry is still valid.
I have updated working repository rtl2831-r2 on a regular basis, both 
for syning with the kernel, and updating e.g. USB-IDs.

I've posted the same message on a list where there was some other 
activity, but got no response yet.
http://ubuntuforums.org/showthread.php?t=960113&page=2


------------------

The repository at http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2.
Thus:
  > hg clone http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2
  > make
  > make install
should be working at all times. I synchronise it once in a while to keep
it running.

Splitting the code up into front-end and back-end is more of a hassle
than I assumed. I'm struggling with the old include files, the data
structures (where used) and the linux interface protocols in general.

A version that does not even compile (NO USE FOR END USERS !)
http://linuxtv.org/hg/~jhoogenraad/rtl2831-sepfront
I have synched the version with the version on my harddisk.

Part of the code is already recycled into the kernel.
As Alistair noticed, this is now blocking for getting the support for
the stick into the main line. A pity for the users,


Peter Mayer wrote:
 > > --- Steven Toth <stoth@linuxtv.org> schrieb am So, 14.9.2008:
 > >
 >>> >>> So, I wonder now what the next steps are to make
 >> >> this driver available in the linux kernel, and when it will
 >> >> probably happen.
 >> >> I gather the tree has some significant merge issues,
 >> >> that's probably why it hasn't been merged. Generally if the 
drivers are
 >> >> legally clean, code clean they get merged in a couple of weeks.
 > >
 > > Sorry if I need to ask again, but what does this actually mean with 
respect to that specific driver rtl2821u? I just wonder.
 > >
 > > My problem is that in Ubuntu Hardy I managed to make this stick 
work, but in Debian SID I have no idea how to get it work. When I do
 > >
 > > hg clone http://linuxtv.org/hg/v4l-dvb
 > > make
 > > make install
 > >
 > > the stick is not recognized. The entries in /var/log/syslog are:
 > >
 > > Sep 15 23:35:55  kernel: usb 3-3: New USB device found, 
idVendor=14aa, idProduct=0160
 > > Sep 15 23:35:55  kernel: usb 3-3: New USB device strings: Mfr=1, 
Product=2, SerialNumber=3
 > > Sep 15 23:35:55  kernel: usb 3-3: Product: DTV Receiver
 > > Sep 15 23:35:55  kernel: usb 3-3: Manufacturer: DTV Receiver
 > > Sep 15 23:35:55  kernel: usb 3-3: SerialNumber: 0000000000010205
 > >
 > > When I unpack and make & make install rtl2831u_dvb-usb_v0.0.2mod, 
syslog says:
 > >
 > > Sep 15 23:40:17  kernel: usb 3-3: new high speed USB device using 
ehci_hcd and address 3
 > > Sep 15 23:40:17  kernel: usb 3-3: configuration #1 chosen from 1 choice
 > > Sep 15 23:40:17  kernel: usb 3-3: New USB device found, 
idVendor=14aa, idProduct=0160
 > > Sep 15 23:40:17  kernel: usb 3-3: New USB device strings: Mfr=1, 
Product=2, SerialNumber=3
 > > Sep 15 23:40:17  kernel: usb 3-3: Product: DTV Receiver
 > > Sep 15 23:40:17  kernel: usb 3-3: Manufacturer: DTV Receiver
 > > Sep 15 23:40:17  kernel: usb 3-3: SerialNumber: 0000000000010205
 > > Sep 15 23:40:17  NetworkManager: <debug> [1221514817.598859] 
nm_hal_device_added(): New device added (hal udi is 
'/org/freedesktop/Hal/devices/usb_device_14aa_160_0000000000010205').
 > > Sep 15 23:40:17  NetworkManager: <debug> [1221514817.602281] 
nm_hal_device_added(): New device added (hal udi is 
'/org/freedesktop/Hal/devices/usb_device_14aa_160_0000000000010205_usbraw').
 > > Sep 15 23:40:17  kernel: dvb-usb: found a 'Freecom USB 2.0 DVB-T 
Device' in warm state.
 > > Sep 15 23:40:17  kernel: dvb-usb: will pass the complete MPEG2 
transport stream to the software demuxer.
 > > Sep 15 23:40:17  udevd-event[3309]: run_program: '/sbin/modprobe' 
abnormal exit
 > > Sep 15 23:40:17  NetworkManager: <debug> [1221514817.795519] 
nm_hal_device_added(): New device added (hal udi is 
'/org/freedesktop/Hal/devices/usb_device_14aa_160_0000000000010205_if0').
 > >
 > > So, what can I try to make this stick work in Debian SID?
 > >
 > > Greetings,
 > > Peter
 > >
 > >
 > > __________________________________________________
 > > Do You Yahoo!?
 > > Sie sind Spam leid? Yahoo! Mail verfügt über einen herausragenden 
Schutz gegen Massenmails.
 > > http://mail.yahoo.com
 > >
 > >
 > > _______________________________________________
 > > linux-dvb mailing list
 > > linux-dvb@linuxtv.org
 > > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
 > >
 > >


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
