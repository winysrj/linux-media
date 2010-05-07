Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.coote.org ([93.97.186.182]:56664 "EHLO mercury.coote.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756163Ab0EGVSr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 May 2010 17:18:47 -0400
Cc: linux-media@vger.kernel.org
Message-Id: <AB617A31-155C-406F-959B-4C155BCAEE40@coote.org>
From: Tim Coote <tim+vger.kernel.org@coote.org>
To: william <william@cobradevil.org>
In-Reply-To: <4BE442D4.4070201@cobradevil.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: setting up a tevii s660
Date: Fri, 7 May 2010 22:18:38 +0100
References: <E23F27D7-CF5B-4F6B-9656-EB63E7005BD0@coote.org>	<4BE313DB.3020405@cobradevil.org>	<AC7E72DC-BC2D-47FF-AC6C-1CCFA7BD9446@coote.org>	<4BE4081E.9010203@cobradevil.org>
	<FB1E5F8F-1339-46D4-9755-8B78DD020651@coote.org>
	<4BE442D4.4070201@cobradevil.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fixed the initial problem: my hardware platform was broken. I  
eventually created a windows VM and ran the tevii code on that - did  
not work. So I pulled together a physical box, which worked.

Lesson: Fusion VM does not reliably work with the tevii. I don't know  
what's broken, but I cannot see any obvious paramaters to twitch. This  
is a shame as it is a powerful test technique to run up different  
configs on VMs.

I'm sure I'll be back on the list before this device works as well as  
it does on Windows.

I note that the box that the s660 came in had a linux logo, so  
presumably there's some sort of agreed service level that would be  
agreed to to allow such branding.... Otherwise linux will never be  
well supported.

Tim
On 7 May 2010, at 17:41, william wrote:

> On 05/07/2010 04:33 PM, Tim Coote wrote:
>> Thanks, William. Really helpful.
>>
>> I think that the issue is down to the mt312 or the ds3000_readreg.  
>> Here's my /var/log/kern.log (I had some confusion over which log  
>> file to look at due to
>> distro variations), from the tevii  
>> 100315_Beta_linux_tevii_ds3000.rar code:
>>
>> May  7 07:04:25 ubuntu kernel: [ 1888.738744] usb 1-1: USB  
>> disconnect, address 5
>> May  7 07:04:25 ubuntu kernel: [ 1888.756834] dvb-usb: TeVii S660  
>> USB successfully deinitialized and disconnected.
>> May  7 07:04:30 ubuntu kernel: [ 1893.648175] usb 1-1: new high  
>> speed USB device using ehci_hcd and address 6
>> May  7 07:04:30 ubuntu kernel: [ 1893.835482] usb 1-1: config 1  
>> interface 0 altsetting 0 bulk endpoint 0x81 has invalid maxpacket 2
>> May  7 07:04:31 ubuntu kernel: [ 1893.844725] usb 1-1:  
>> configuration #1 chosen from 1 choice
>> May  7 07:04:31 ubuntu kernel: [ 1893.989017] dvb-usb: found a  
>> 'TeVii S660 USB' in cold state, will try to load a firmware
>> May  7 07:04:31 ubuntu kernel: [ 1893.989030] usb 1-1: firmware:  
>> requesting dvb-usb-teviis660.fw
>> May  7 07:04:31 ubuntu kernel: [ 1893.995703] dvb-usb: downloading  
>> firmware from file 'dvb-usb-teviis660.fw'
>> May  7 07:04:31 ubuntu kernel: [ 1893.995706] dw2102: start  
>> downloading DW210X firmware
>> May  7 07:04:31 ubuntu kernel: [ 1894.360084] dvb-usb: found a  
>> 'TeVii S660 USB' in warm state.
>> May  7 07:04:31 ubuntu kernel: [ 1894.361316] dvb-usb: will pass  
>> the complete MPEG2 transport stream to the software demuxer.
>> May  7 07:04:31 ubuntu kernel: [ 1894.362140] DVB: registering new  
>> adapter (TeVii S660 USB)
>> May  7 07:04:36 ubuntu kernel: [ 1899.484223] dvb-usb: MAC address:  
>> 70:70:70:70:70:70
>> May  7 07:04:36 ubuntu kernel: [ 1899.612725] mt312: R(126): 00
>> May  7 07:04:36 ubuntu kernel: [ 1899.612729] Only Zarlink VP310/ 
>> MT312/ZL10313 are supported chips.
>> May  7 07:04:37 ubuntu kernel: [ 1899.844336] ds3000_attach
>> May  7 07:04:37 ubuntu kernel: [ 1899.864116] ds3000_readreg: read  
>> reg 0x00, value 0x70
>> May  7 07:04:37 ubuntu kernel: [ 1899.864119] Invalid probe,  
>> probably not a DS3000
>> May  7 07:04:37 ubuntu kernel: [ 1899.864208] dvb-usb: no frontend  
>> was attached by 'TeVii S660 USB'
>> May  7 07:04:37 ubuntu kernel: [ 1899.866721] dvb-usb: TeVii S660  
>> USB successfully initialized and connected.
>>
>> Clearly, either I've still got the wrong code, my hardware's  
>> different, or I've got some other config difference. your logfile  
>> clearly shows that ds3000_readreg is getting the correct 0xe0  
>> response, whereas mine's come back with 0x70 and therefore doesn't  
>> try to attach the frontend...
>> here's the hashes taht I've got for the modules (from modinfo, I  
>> think that this should show whether we're using hte same sources):
>> ds3000: srcversion:     8BBEA04D5B5CDF6343234E5
>> dw2102: srcversion:     ADE91410D87CAB74AE3862C
>> mt312:  srcversion:     E4DBE51A55D359EB4157AA2
>
> mine are:
> ds3000: srcversion:     C7DB14F51712A761A96E6C0
> dvb-usb-dw2102: srcversion:     FCBA4EFAEF1F6A88DC9F2DB
> mt312: srcversion:     01AA722165F2811847AD121
>
> md5sums from tevii source:
> ds3000.c fd28e654d57f0336640b6f13bed5102c
> dw2102.c 019a275475fe2fbf9a255c65d80ee7be
> mt312.c 222360df7838633b8b05e471b18678bd
>
>
> With kind regards
>
> William
>>
>> what did you do to get your mt312 correctly identified?
>>
>> On my wintel box, channel switching takes a couple of seconds, does  
>> yours take much longer?
>>
>> what's the real problem with leaving the rc polling on ? I know  
>> that you get log messages, but they're only messages. they can be  
>> turned off by commenting out the info lines (info ("query RC... )  
>> and then make/sudo make install (just put // at the beginning of  
>> the lines in dw2102.c)
>>
>> On 7 May 2010, at 13:31, william wrote:
>>
>>> Hello Tim,
>>>
>>> On 05/07/2010 01:41 PM, Tim Coote wrote:
>>>> William
>>>> did you load your modules with debug=1, or something else,  
>>>> somehow? I thought that the code printing out ds3000_readreg  
>>>> required debug. or have you got different source code from the  
>>>> tevii driver on www.tevii.com/Support.asp?  (unless I know what  
>>>> you're using, I cannot tell what's relevant.)
>>> i tried this so probably yes
>>> /etc/modprobe.d/test.conf
>>> ##
>>> options mt312 debug=1
>>> options ds3000 debug=1
>>> options dvb-usb-dw2102 debug=1
>>> options dvb-usb disable_rc_polling=1
>>> options dvb-usb-dw2102 keymap=2 demod=2
>>> ##
>>>
>>> The tevii device should be supported by the linuxtv drivers:
>>>
>>> ############
>>> hg clone http://linuxtv.org/hg/v4l-dvb
>>> cd v4l-dvb
>>> make menuconfig disable/enable what you need
>>> make&&  make install
>>> poweroff
>>> remove power/usb cables
>>> replug the power to tevii device
>>> then connect the usb
>>> then poweron pc
>>>
>>> Then i get this in my log:
>>> modprobe dvb-usb-dw2102
>>> [  217.546580] dvb-usb: found a 'TeVii S660 USB' in cold state,  
>>> will try to load a firmware
>>> [  217.546595] usb 1-3: firmware: requesting dvb-usb-s630.fw
>>> [  217.630018] dvb-usb: downloading firmware from file 'dvb-usb- 
>>> s630.fw'
>>> [  217.630030] dw2102: start downloading DW210X firmware
>>> [  217.748783] usb 1-3: USB disconnect, address 3
>>> [  217.850050] dvb-usb: found a 'TeVii S660 USB' in warm state.
>>> [  217.850161] dvb-usb: will pass the complete MPEG2 transport  
>>> stream to the software demuxer.
>>> [  217.850236] DVB: registering new adapter (TeVii S660 USB)
>>> [  228.090038] dvb-usb: MAC address: 00:00:00:00:00:00
>>> [  228.162540] mt312: R(126): 00
>>> [  228.162550] Only Zarlink VP310/MT312/ZL10313 are supported chips.
>>> [  228.507136] ds3000_attach
>>> [  228.542534] ds3000_readreg: read reg 0x00, value 0x00
>>> [  228.542541] Invalid probe, probably not a DS3000
>>> [  228.542808] dvb-usb: no frontend was attached by 'TeVii S660 USB'
>>> [  228.542861] dvb-usb: TeVii S660 USB successfully initialized  
>>> and connected.
>>> [  228.543000] usbcore: registered new interface driver dw2102
>>> [  228.543454] dvb-usb: TeVii S660 USB successfully deinitialized  
>>> and disconnected.
>>> [  228.820045] usb 1-3: new high speed USB device using ehci_hcd  
>>> and address 5
>>>
>>> ########
>>>
>>> using the tevii drivers i get this:
>>> doing the same make ; make install ; poweroff ....
>>> modprobe dvb-usb-dw2102
>>>
>>> [   80.354236] dvb-usb: found a 'TeVii S660 USB' in cold state,  
>>> will try to load a firmware
>>> [   80.354252] usb 1-3: firmware: requesting dvb-usb-teviis660.fw
>>> [   80.418598] dvb-usb: downloading firmware from file 'dvb-usb- 
>>> teviis660.fw'
>>> [   80.418609] dw2102: start downloading DW210X firmware
>>> [   80.436136] usb 1-3: USB disconnect, address 3
>>> [   80.545656] dvb-usb: found a 'TeVii S660 USB' in warm state.
>>> [   80.545780] dvb-usb: will pass the complete MPEG2 transport  
>>> stream to the software demuxer.
>>> [   80.545840] DVB: registering new adapter (TeVii S660 USB)
>>> [   90.810041] dvb-usb: MAC address: 00:00:00:00:00:00
>>> [   90.921279] mt312: R(126): 00
>>> [   90.921289] Only Zarlink VP310/MT312/ZL10313 are supported chips.
>>> [   91.243014] ds3000_attach
>>> [   91.283778] ds3000_readreg: read reg 0x00, value 0x00
>>> [   91.283785] Invalid probe, probably not a DS3000
>>> [   91.284052] dvb-usb: no frontend was attached by 'TeVii S660 USB'
>>> [   91.284105] dvb-usb: TeVii S660 USB successfully initialized  
>>> and connected.
>>> [   91.284209] usbcore: registered new interface driver dw2102
>>> [   91.284744] dvb-usb: TeVii S660 USB successfully deinitialized  
>>> and disconnected.
>>> [   91.560036] usb 1-3: new high speed USB device using ehci_hcd  
>>> and address 5
>>> [   91.710433] usb 1-3: config 1 interface 0 altsetting 0 bulk  
>>> endpoint 0x81 has invalid maxpacket 2
>>> [   91.712260] dvb-usb: found a 'TeVii S660 USB' in cold state,  
>>> will try to load a firmware
>>> [   91.712275] usb 1-3: firmware: requesting dvb-usb-teviis660.fw
>>> [   91.722989] dvb-usb: downloading firmware from file 'dvb-usb- 
>>> teviis660.fw'
>>> [   91.723001] dw2102: start downloading DW210X firmware
>>> [   91.840045] dvb-usb: found a 'TeVii S660 USB' in warm state.
>>> [   91.840180] dvb-usb: will pass the complete MPEG2 transport  
>>> stream to the software demuxer.
>>> [   91.840339] DVB: registering new adapter (TeVii S660 USB)
>>> [  102.080030] dvb-usb: MAC address: 00:18:bd:5c:54:7f
>>> [  102.120028] mt312: R(126): ff
>>> [  102.120038] Only Zarlink VP310/MT312/ZL10313 are supported chips.
>>> [  102.390448] ds3000_attach
>>> [  102.430027] ds3000_readreg: read reg 0x00, value 0xe0
>>> [  102.470026] ds3000_readreg: read reg 0x01, value 0xc0
>>> [  102.510026] ds3000_readreg: read reg 0x02, value 0x00
>>> [  102.510033] DS3000 chip version: 0.192 attached.
>>> [  102.510039] dw2102: Attached ds3000+ds2020!
>>> [  102.510041]
>>> [  102.510274] DVB: registering adapter 1 frontend 0 (Montage  
>>> Technology DS3000/TS2020)...
>>> [  102.510645] dvb-usb: TeVii S660 USB successfully initialized  
>>> and connected.
>>>
>>> #########
>>>
>>> now i have:
>>>
>>> root@backend:~# ls -al /dev/dvb/adapter1/
>>> total 0
>>> drwxr-xr-x 2 root root     120 2010-05-07 14:23 .
>>> drwxr-xr-x 4 root root      80 2010-05-07 14:23 ..
>>> crw-rw---- 1 root video 212, 4 2010-05-07 14:23 demux0
>>> crw-rw---- 1 root video 212, 5 2010-05-07 14:23 dvr0
>>> crw-rw---- 1 root video 212, 7 2010-05-07 14:23 frontend0
>>> crw-rw---- 1 root video 212, 6 2010-05-07 14:23 net0
>>>
>>>
>>> ###
>>>
>>> Now i can also make use off the device except that my system gets  
>>> slow and channel zapping takes ages.
>>> i disabled the debug message for the remote with the option  
>>> disable_rc_polling for dvb-usb.
>>>
>>> only then you cannot use the remote :)
>>>
>>> With kind regards
>>>
>>> William van de Velde
>>>
>>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux- 
>> media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

