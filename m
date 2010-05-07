Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.coote.org ([93.97.186.182]:63920 "EHLO mercury.coote.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753915Ab0EGLl5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 May 2010 07:41:57 -0400
Cc: linux-media@vger.kernel.org
Message-Id: <AC7E72DC-BC2D-47FF-AC6C-1CCFA7BD9446@coote.org>
From: Tim Coote <tim+vger.kernel.org@coote.org>
To: william <william@cobradevil.org>
In-Reply-To: <4BE313DB.3020405@cobradevil.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: setting up a tevii s660
Date: Fri, 7 May 2010 12:41:54 +0100
References: <E23F27D7-CF5B-4F6B-9656-EB63E7005BD0@coote.org>
	<4BE313DB.3020405@cobradevil.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

William
did you load your modules with debug=1, or something else, somehow? I  
thought that the code printing out ds3000_readreg required debug. or  
have you got different source code from the tevii driver on www.tevii.com/Support.asp? 
   (unless I know what you're using, I cannot tell what's relevant.)

my log looks like this (VMWare fusion virtual hardware, MacBookPro  
host, xubuntu 10.04, installed and updated, make and sudo make install  
based on a .config that I understand works).

May  7 02:20:37 ubuntu kernel: [42761.520219] usb 1-1: new high speed  
USB device using ehci_hcd and address 2
May  7 02:20:37 ubuntu kernel: [42761.708776] usb 1-1: configuration  
#1 chosen from 1 choice
May  7 02:20:37 ubuntu kernel: [42762.229009] dvb-usb: found a 'TeVii  
S660 USB' in cold state, will try to load a firmware
May  7 02:20:37 ubuntu kernel: [42762.229027] usb 1-1: firmware:  
requesting dvb-usb-teviis660.fw
May  7 02:20:38 ubuntu kernel: [42762.307947] dvb-usb: downloading  
firmware from file 'dvb-usb-teviis660.fw'
May  7 02:20:38 ubuntu kernel: [42762.307950] dw2102: start  
downloading DW210X firmware
May  7 02:20:38 ubuntu kernel: [42762.508553] usb 1-1: USB disconnect,  
address 2
May  7 02:20:38 ubuntu kernel: [42762.592094] dvb-usb: found a 'TeVii  
S660 USB' in warm state.
May  7 02:20:38 ubuntu kernel: [42762.592253] dvb-usb: will pass the  
complete MPEG2 transport stream to the software demuxer.
May  7 02:20:38 ubuntu kernel: [42762.592324] DVB: registering new  
adapter (TeVii S660 USB)
May  7 02:20:42 ubuntu kernel: [42766.700222] dvb-usb: MAC address:  
00:00:00:00:00:00
May  7 02:20:42 ubuntu kernel: [42766.778218] Only Zarlink VP310/MT312/ 
ZL10313 are supported chips.
May  7 02:20:42 ubuntu kernel: [42767.053874] input: IR-receiver  
inside an USB DVB receiver as /devices/ 
pci0000:00/0000:00:11.0/0000:02:03.0/usb1/1-1/input/input5
May  7 02:20:42 ubuntu kernel: [42767.054053] dvb-usb: schedule remote  
query interval to 150 msecs.
May  7 02:20:42 ubuntu kernel: [42767.054058] dvb-usb: TeVii S660 USB  
successfully initialized and connected.
May  7 02:20:42 ubuntu kernel: [42767.054088] usbcore: registered new  
interface driver dw2102
May  7 02:20:42 ubuntu kernel: [42767.054463] dvb-usb: TeVii S660 USB  
successfully deinitialized and disconnected.
May  7 02:20:43 ubuntu kernel: [42767.340236] usb 1-1: new high speed  
USB device using ehci_hcd and address 3
May  7 02:20:43 ubuntu kernel: [42767.824316] usb 1-1: config 1  
interface 0 altsetting 0 bulk endpoint 0x81 has invalid maxpacket 2
May  7 02:20:43 ubuntu kernel: [42767.828380] usb 1-1: configuration  
#1 chosen from 1 choice
May  7 02:20:43 ubuntu kernel: [42768.068383] dvb-usb: found a 'TeVii  
S660 USB' in cold state, will try to load a firmware
May  7 02:20:43 ubuntu kernel: [42768.068388] usb 1-1: firmware:  
requesting dvb-usb-teviis660.fw
May  7 02:20:43 ubuntu kernel: [42768.087257] dvb-usb: downloading  
firmware from file 'dvb-usb-teviis660.fw'
May  7 02:20:43 ubuntu kernel: [42768.087260] dw2102: start  
downloading DW210X firmware
May  7 02:20:44 ubuntu kernel: [42768.360185] dvb-usb: found a 'TeVii  
S660 USB' in warm state.
May  7 02:20:44 ubuntu kernel: [42768.361175] dvb-usb: will pass the  
complete MPEG2 transport stream to the software demuxer.
May  7 02:20:44 ubuntu kernel: [42768.362197] DVB: registering new  
adapter (TeVii S660 USB)
May  7 02:20:49 ubuntu kernel: [42773.580095] dvb-usb: MAC address:  
70:70:70:70:70:70
May  7 02:20:49 ubuntu kernel: [42773.612787] Only Zarlink VP310/MT312/ 
ZL10313 are supported chips.
May  7 02:20:49 ubuntu kernel: [42773.875597] input: IR-receiver  
inside an USB DVB receiver as /devices/ 
pci0000:00/0000:00:11.0/0000:02:03.0/usb1/1-1/input/input6
May  7 02:20:49 ubuntu kernel: [42773.875684] dvb-usb: schedule remote  
query interval to 150 msecs.
May  7 02:20:49 ubuntu kernel: [42773.875687] dvb-usb: TeVii S660 USB  
successfully initialized and connected.
May  7 02:20:49 ubuntu kernel: [42774.024247] dw2102: query RC enter

I'm not getting the 'probably not a ds3000' line, although that could  
be a debugging level issue.

I see that you're using a different kernel and source file: here's my  
modinfo for the module that I'm using:

filename:       /lib/modules/2.6.32-22-generic/kernel/drivers/media/ 
dvb/dvb-usb/dvb-usb-dw2102.ko
license:        GPL
version:        0.1
description:    Driver for DVBWorld DVB-S 2101, 2102, DVB-S2 2104, DVB- 
C 3101 USB2.0, TeVii S600, S630, S650, S660 USB2.0, Prof 1100, 7500  
USB2.0 devices
author:         Igor M. Liplianin (c) liplianin@me.by
srcversion:     5B4AEEBD8B92549304CF812
alias:          usb:v3034p7500d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v9022pD660d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v3011pB012d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v9022pD630d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v04B4p3101d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0CCDp0064d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v9022pD650d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v04B4p2104d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v04B4p2101d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v04B4p2102d*dc*dsc*dp*ic*isc*ip*
depends:        dvb-usb
vermagic:       2.6.32-22-generic SMP mod_unload modversions 586
parm:           debug:set debugging level (1=info 2=xfer 4=rc(or- 
able)). (int)
parm:           keymap:set keymap 0=default 1=dvbworld 2=tevii  
3=tbs  ... (int)
parm:           demod:demod to probe (1=cx24116 2=stv0903+stv6110  
4=stv0903+stb6100(or-able)). (int)
parm:           adapter_nr:DVB adapter numbers (array of short)


I'm not convinced that either of us is actually communicating with our  
s660s. do you get a /dev/dvb/adapter0/frontend0? can you get any  
output at all from the device? if so, with what?

There are too many variables here. I'd like to collect all of the  
configurations of a known working system and work methodically from  
there.
On 6 May 2010, at 20:09, william wrote:

> Hello Tim,
>
> i also have a tevii s660 which i cannot get to work properly.
>
> i'm no programmer and nobody has given a reaction on my previous  
> posts (debugging my tevii...).
>
> I get this in my log after getting the source from the linuxtv site  
> with the driver igor wrote:
>
>
> [   45.654362] dvb-usb: found a 'TeVii S660 USB' in cold state, will  
> try to load a firmware
> [   45.654379] usb 1-3: firmware: requesting dvb-usb-s630.fw
> [   45.717438] dvb-usb: downloading firmware from file 'dvb-usb- 
> s630.fw'
> [   45.717450] dw2102: start downloading DW210X firmware
> [   45.824245] usb 1-3: USB disconnect, address 3
> [   45.930055] dvb-usb: found a 'TeVii S660 USB' in warm state.
> [   45.930167] dvb-usb: will pass the complete MPEG2 transport  
> stream to the software demuxer.
> [   45.930233] DVB: registering new adapter (TeVii S660 USB)
> [   56.182533] dvb-usb: MAC address: 00:00:00:00:00:00
> [   56.262532] mt312: R(126): 00
> [   56.262543] Only Zarlink VP310/MT312/ZL10313 are supported chips.
> [   56.607024] ds3000_attach
> [   56.642535] ds3000_readreg: read reg 0x00, value 0x00
> [   56.642542] Invalid probe, probably not a DS3000
> [   56.642816] dvb-usb: no frontend was attached by 'TeVii S660 USB'
> [   56.643037] input: IR-receiver inside an USB DVB receiver as / 
> devices/pci0000:00/0000:00:1d.7/usb1/1-3/input/input5
> [   56.643189] dvb-usb: schedule remote query interval to 150 msecs.
> [   56.643203] dvb-usb: TeVii S660 USB successfully initialized and  
> connected.
> [   56.643290] usbcore: registered new interface driver dw2102
> [   56.773230] dvb-usb: TeVii S660 USB successfully deinitialized  
> and disconnected.
> [   57.050043] usb 1-3: new high speed USB device using ehci_hcd and  
> address 5
>
> in my previous post i got a message that an mt312 chip was found and  
> now it does not find anything.
> so now i don't have a dvb device at all.
>
> the firmware is from the drivers from tevii. I tried and the s630  
> firmware and later the s660 firmware renamed to s630 but none worked.
>
> After installing the driver/changing the firmware, I shutdown the  
> computer removed the power from the tevii device and then replugged  
> and started my computer again.
>
> ======
>
> modinfo dvb-usb-dw2102
> filename:       /lib/modules/2.6.34-020634rc2-generic/kernel/drivers/ 
> media/dvb/dvb-usb/dvb-usb-dw2102.ko
> license:        GPL
> version:        0.1
> description:    Driver for DVBWorld DVB-S 2101, 2102, DVB-S2 2104,  
> DVB-C 3101 USB2.0, TeVii S600, S630, S650, S660 USB2.0, Prof 1100,  
> 7500 USB2.0 devices
> author:         Igor M. Liplianin (c) liplianin@me.by
> srcversion:     FCBA4EFAEF1F6A88DC9F2DB
> alias:          usb:v3034p7500d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v9022pD660d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v3011pB012d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v9022pD630d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v04B4p3101d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v0CCDp0064d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v9022pD650d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v04B4p2104d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v04B4p2101d*dc*dsc*dp*ic*isc*ip*
> alias:          usb:v04B4p2102d*dc*dsc*dp*ic*isc*ip*
> depends:        dvb-usb
> vermagic:       2.6.34-020634rc2-generic SMP mod_unload modversions
> parm:           debug:set debugging level (1=info 2=xfer 4=rc(or- 
> able)). (int)
> parm:           keymap:set keymap 0=default 1=dvbworld 2=tevii  
> 3=tbs  ... (int)
> parm:           demod:demod to probe (1=cx24116 2=stv0903+stv6110  
> 4=stv0903+stb6100(or-able)). (int)
> parm:           adapter_nr:DVB adapter numbers (array of short)
> ========
>
> if you need help testing i would be glad to help.
>
> The tevii drivers are working and also detect the mt312 chip.
> This driver does not, but i'm not very pleased about the driver from  
> tevii because channel switch takes long and image quality is bad and  
> my system get's slow/freezes.
>
> With kind regards
>
> William van de Velde
>
> On 05/06/2010 01:07 AM, Tim Coote wrote:
>> Hullo
>> I've been struggling with this for a couple of days. I have checked  
>> archives, but missed anything useful.
>>
>> I've got a tevii s660 (dvbs2 via usb). It works with some  
>> limitations on windows xp (I cannot get HD signals decoded, but  
>> think that's a limitation of the software that comes on the CD).
>>
>> I'm trying to get this working on Linux. I've tried VMs based on  
>> fedora 12 and mythbuntu (VMWare Fusion on a MacBookPro, both based  
>> on kernel 2.6.32), using the drivers from tevii's site (www.tevii.com/support.asp) 
>> . these drivers are slightly modified versions of the v4l tip - but  
>> don't appear to be modified where I've not yet managed to get the  
>> drivers working :-(.  Mythbuntu seems to be closest to working.  
>> Goodness knows how tevii tested the code, but it doesn't seem to  
>> work as far as I can see.  My issues could just be down to using a  
>> VM.
>>
>> I believe that I need to load up the modules ds3000 and dvb-usb- 
>> dw2102, + add a rule to /etc/udev/rules.d and a script to /etc/udev/ 
>> scripts.
>>
>> I think that I must be missing quite a lot of context, tho'. When I  
>> look at the code in dw2102.c, which seems to support the s660, the  
>> bit that downloads the firmware looks broken and if I add a default  
>> clause to the switch that does the download, the s660's missed the  
>> download process.  This could be why when I do get anything out of  
>> the device it looks like I'm just getting repeated bytes (the same  
>> value repeated, different values at different times, sometimes  
>> nothing).  I'm finding it non-trivial working out the call  
>> sequences of the code or devising repeatable tests.
>>
>> Can anyone kick me off on getting this working? I'd like to at  
>> least get to the point where scandvb can tune the device. It does  
>> look like some folk have had success in the past, but probably with  
>> totally different codebase (there are posts that refer to the  
>> teviis660 module, which I cannot find).
>>
>> Any pointer gratefully accepted. I'll feed back any success if I  
>> can be pointed at where to drop document it.
>>
>> tia
>>
>> Tim
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux- 
>> media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

