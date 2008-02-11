Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mailhost.okg-computer.de ([85.131.254.125])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@okg-computer.de>) id 1JOgT7-0001UM-4O
	for linux-dvb@linuxtv.org; Mon, 11 Feb 2008 22:45:41 +0100
Received: from [10.10.43.109] (e180064215.adsl.alicedsl.de [85.180.64.215])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mailhost.okg-computer.de (Postfix) with ESMTP id 49C65441C4
	for <linux-dvb@linuxtv.org>; Mon, 11 Feb 2008 22:45:38 +0100 (CET)
Message-ID: <47B0C1FF.7060202@okg-computer.de>
Date: Mon, 11 Feb 2008 22:45:35 +0100
From: =?ISO-8859-1?Q?Jens_Krehbiel-Gr=E4ther?=
 <linux-dvb@okg-computer.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <200801252245.58642.dkuhlen@gmx.net>	<47A086D6.4080200@okg-computer.de>	<200801301908.36169.dkuhlen@gmx.net>	<47A0CD3C.40508@okg-computer.de>
	<47A0E8CC.3080207@okg-computer.de>
In-Reply-To: <47A0E8CC.3080207@okg-computer.de>
Subject: Re: [linux-dvb] Pinnacle PCTV Sat HDTV Pro USB (PCTV452e) and DVB-S2
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Jens Krehbiel-Gr=E4ther schrieb:
> Jens Krehbiel-Gr=E4ther schrieb:
>   =

>> Dominik Kuhlen schrieb:
>>   =

>>     =

>>> Hi
>>> <snip>
>>>   =

>>>     =

>>>       =

>>>> dev:/usr/src/multiproto# patch -p1 < pctv452e.patch
>>>> patching file linux/drivers/media/Kconfig
>>>> patching file linux/drivers/media/dvb/dvb-usb/Kconfig
>>>> Hunk #1 succeeded at 239 (offset 2 lines).
>>>> patching file linux/drivers/media/dvb/dvb-usb/Makefile
>>>> Hunk #1 succeeded at 61 with fuzz 2.
>>>> patching file linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
>>>> Hunk #1 FAILED at 139.
>>>> 1 out of 1 hunk FAILED -- saving rejects to file =

>>>> linux/drivers/media/dvb/dvb-usb =

>>>>                                                          /dvb-usb-ids.=
h.rej
>>>> patching file linux/drivers/media/dvb/dvb-usb/pctv452e.c
>>>> patching file linux/drivers/media/dvb/frontends/Kconfig
>>>> Hunk #1 succeeded at 405 (offset 47 lines).
>>>> patching file linux/drivers/media/dvb/frontends/Makefile
>>>> Hunk #1 succeeded at 42 (offset 3 lines).
>>>> patching file linux/drivers/media/dvb/frontends/lnbp21.c
>>>> Hunk #1 succeeded at 117 (offset -1 lines).
>>>> patching file linux/drivers/media/dvb/frontends/lnbp22.c
>>>> patching file linux/drivers/media/dvb/frontends/lnbp22.h
>>>> patching file linux/drivers/media/dvb/frontends/stb0899_algo.c
>>>> Hunk #1 succeeded at 495 (offset -27 lines).
>>>> patching file linux/drivers/media/dvb/frontends/stb0899_drv.c
>>>> patching file linux/drivers/media/dvb/frontends/stb0899_drv.h
>>>> patching file linux/drivers/media/dvb/frontends/stb6100.c
>>>> patching file linux/include/linux/dvb/frontend.h
>>>> patching file linux/include/linux/dvb/video.h
>>>> Hunk #1 succeeded at 32 with fuzz 1 (offset 1 line).
>>>> dev:/usr/src/multiproto#
>>>> </snip>
>>>>
>>>> So I inserted the line into =

>>>> linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h by hand
>>>> #define USB_PID_PCTV_452E                              0x021f
>>>>     =

>>>>       =

>>>>         =

>>> ok. this might happen if the file has been changed in repository since =
i have diff'ed.
>>>   =

>>>     =

>>>       =

>>>> I type make and all compiles with only a few warnings but now without =

>>>> any error.
>>>>
>>>> When I install the modules and load them I get the following output fr=
om =

>>>> dmesg:
>>>>
>>>> </snip>
>>>> usb 3-2: new high speed USB device using ehci_hcd and address 4
>>>> usb 3-2: configuration #1 chosen from 1 choice
>>>> dvb-usb: found a 'PCTV HDTV USB' in warm state.
>>>> pctv452e_power_ctrl: 1
>>>> dvb-usb: will pass the complete MPEG2 transport stream to the software =

>>>> demuxer.
>>>> DVB: registering new adapter (PCTV HDTV USB)
>>>> pctv452e_frontend_attach Enter
>>>> stb0899_attach: Exiting .. !
>>>>     =

>>>>       =

>>>>         =

>>> Hmm. i wonder why this happens: the stb0899 did not attach properly:
>>> could you please load the stb0899 without verbose=3D parameter.
>>>  it will  print more info what's going on.
>>>   =

>>>     =

>>>       =

>> Hi!
>>
>> Well perhaps it is a hardware error in my device??
>> Loading the module without "verbose" parameter prints the following in =

>> the syslog:
>>
>> Jan 30 19:37:21 dev kernel: usb 3-6: new high speed USB device using =

>> ehci_hcd and address 2
>> Jan 30 19:37:21 dev kernel: usb 3-6: device descriptor read/64, error -71
>> Jan 30 19:37:22 dev kernel: usb 3-6: device descriptor read/64, error -71
>> Jan 30 19:37:22 dev kernel: usb 3-6: new high speed USB device using =

>> ehci_hcd and address 3
>> Jan 30 19:37:22 dev kernel: usb 3-6: configuration #1 chosen from 1 choi=
ce
>> Jan 30 19:37:22 dev kernel: dvb-usb: found a 'PCTV HDTV USB' in warm sta=
te.
>> Jan 30 19:37:22 dev kernel: pctv452e_power_ctrl: 1
>> Jan 30 19:37:22 dev kernel: dvb-usb: will pass the complete MPEG2 =

>> transport stream to the software demuxer.
>> Jan 30 19:37:22 dev kernel: DVB: registering new adapter (PCTV HDTV USB)
>> Jan 30 19:37:22 dev kernel: pctv452e_frontend_attach Enter
>> Jan 30 19:37:22 dev kernel: stb0899_write_regs [0xf1b6]: 02
>> Jan 30 19:37:22 dev kernel: stb0899_write_regs [0xf1c2]: 00
>> Jan 30 19:37:22 dev kernel: stb0899_write_regs [0xf1c3]: 00
>> Jan 30 19:37:22 dev kernel: stb0899_write_regs [0xf141]: 02
>> Jan 30 19:37:22 dev kernel: _stb0899_read_reg: Reg=3D[0xf000], data=3D05
>> Jan 30 19:37:22 dev kernel: stb0899_get_dev_id: ID reg=3D[0x05]
>> Jan 30 19:37:22 dev kernel: stb0899_get_dev_id: Device ID=3D[0], Release=
=3D[5]
>> Jan 30 19:37:22 dev kernel: _stb0899_read_s2reg Device=3D[0xf3fc], Base =

>> address=3D[0x00000400], Offset=3D[0xf334], Data=3D[0xb7fffe05]
>> Jan 30 19:37:22 dev kernel: _stb0899_read_s2reg Device=3D[0xf3fc], Base =

>> address=3D[0x00000400], Offset=3D[0xf33c], Data=3D[0xb7fffe05]
>> Jan 30 19:37:22 dev kernel: stb0899_get_dev_id: Demodulator Core =

>> ID=3D[<B7><FF><FE>^E], Version=3D[-1207960059]
>> Jan 30 19:37:22 dev kernel: _stb0899_read_s2reg Device=3D[0xfafc], Base =

>> address=3D[0x00000800], Offset=3D[0xfa2c], Data=3D[0xb7fffe05]
>> Jan 30 19:37:22 dev kernel: _stb0899_read_s2reg Device=3D[0xfafc], Base =

>> address=3D[0x00000800], Offset=3D[0xfa34], Data=3D[0xb7fffe05]
>> Jan 30 19:37:22 dev kernel: stb0899_get_dev_id: couldn't find a STB 0899
>> Jan 30 19:37:22 dev kernel: stb0899_attach: Exiting .. !
>> Jan 30 19:37:22 dev kernel: dvb-usb: no frontend was attached by 'PCTV =

>> HDTV USB'
>> Jan 30 19:37:22 dev kernel: input: IR-receiver inside an USB DVB =

>> receiver as /class/input/input4
>> Jan 30 19:37:22 dev kernel: dvb-usb: schedule remote query interval to =

>> 100 msecs.
>> Jan 30 19:37:22 dev kernel: pctv452e_power_ctrl: 0
>> Jan 30 19:37:22 dev kernel: dvb-usb: PCTV HDTV USB successfully =

>> initialized and connected.
>> Jan 30 19:37:22 dev kernel: usbcore: registered new interface driver =

>> pctv452e
>>
>>
>>
>> Because of this line I think there is an error in the hardware:
>> Jan 30 19:37:22 dev kernel: stb0899_get_dev_id: Demodulator Core =

>> ID=3D[<B7><FF><FE>^E], Version=3D[-1207960059]
>>
>> Also the light is always showing green (even if it is not connected with =

>> a pc).
>> I will test the device under windows this evening to see wheter it is =

>> working or not.
>>   =

>>     =

>
> OK, I really think its a hardware problem. In Windows I get a bluescreen =

> when I start the TV-Application (on 3 different PCs, so I think it must =

> be something wrong with the hardware).
> I will try again when I get a new device from pinnacle support.
>   =



Hi!

Finally I got a new device from pinnacle support today. I plugged it =

into the computer and the modules loaded fine (without an error).
But now I have another problem. I scaned for channels and this works =

fine. After that I tried to tune. First try was "ProSieben HD" (Astra =

19,2=B0 E). I got a lock on this channel.
After this tuning (it works one time) I could never scan any more or =

tune to a channel.

This is the syslog from scanning for channels:

Feb 11 22:12:13 dev kernel: stb0899_write_regs [0xf41b]: ee
Feb 11 22:12:13 dev kernel: _stb0899_read_reg: Reg=3D[0xf43a], data=3D08
Feb 11 22:12:13 dev kernel: stb0899_check_carrier: --------------------> =

STB0899_DSTATUS=3D[0x08]
Feb 11 22:12:13 dev kernel: stb0899_check_carrier: -------------> =

NOCARRIER !
Feb 11 22:12:13 dev kernel: _stb0899_read_reg: Reg=3D[0xf41b], data=3Dee
Feb 11 22:12:13 dev kernel: stb0899_write_regs [0xf41b]: ee
Feb 11 22:12:13 dev kernel: stb0899_write_regs [0xf43e]: 14 7c
Feb 11 22:12:13 dev kernel: stb0899_search_carrier: Derot Freq=3D5244, =

mclk=3D1510
Feb 11 22:12:13 dev kernel: _stb0899_read_reg: Reg=3D[0xf41b], data=3Dee
Feb 11 22:12:13 dev kernel: stb0899_write_regs [0xf41b]: ee
Feb 11 22:12:13 dev kernel: _stb0899_read_reg: Reg=3D[0xf43a], data=3D08
Feb 11 22:12:13 dev kernel: stb0899_check_carrier: --------------------> =

STB0899_DSTATUS=3D[0x08]
Feb 11 22:12:13 dev kernel: stb0899_check_carrier: -------------> =

NOCARRIER !
Feb 11 22:12:13 dev kernel: _stb0899_read_reg: Reg=3D[0xf41b], data=3Dee
Feb 11 22:12:13 dev kernel: stb0899_write_regs [0xf41b]: ee
Feb 11 22:12:13 dev kernel: stb0899_write_regs [0xf43e]: eb 84
Feb 11 22:12:13 dev kernel: stb0899_search_carrier: Derot Freq=3D-5244, =

mclk=3D1510
Feb 11 22:12:13 dev kernel: _stb0899_read_reg: Reg=3D[0xf41b], data=3Dee
Feb 11 22:12:13 dev kernel: stb0899_write_regs [0xf41b]: ee
Feb 11 22:12:13 dev kernel: _stb0899_read_reg: Reg=3D[0xf43a], data=3D08
Feb 11 22:12:13 dev kernel: stb0899_check_carrier: --------------------> =

STB0899_DSTATUS=3D[0x08]
Feb 11 22:12:13 dev kernel: stb0899_check_carrier: -------------> =

NOCARRIER !
Feb 11 22:12:13 dev kernel: _stb0899_read_reg: Reg=3D[0xf41b], data=3Dee
Feb 11 22:12:13 dev kernel: stb0899_write_regs [0xf41b]: ee
Feb 11 22:12:13 dev kernel: stb0899_write_regs [0xf43e]: 16 31
Feb 11 22:12:13 dev kernel: stb0899_search_carrier: Derot Freq=3D5681, =

mclk=3D1510
Feb 11 22:12:13 dev kernel: _stb0899_read_reg: Reg=3D[0xf41b], data=3Dee
Feb 11 22:12:13 dev kernel: stb0899_write_regs [0xf41b]: ee
Feb 11 22:12:13 dev kernel: _stb0899_read_reg: Reg=3D[0xf43a], data=3D08
Feb 11 22:12:13 dev kernel: stb0899_check_carrier: --------------------> =

STB0899_DSTATUS=3D[0x08]
Feb 11 22:12:13 dev kernel: stb0899_check_carrier: -------------> =

NOCARRIER !
Feb 11 22:12:13 dev kernel: _stb0899_read_reg: Reg=3D[0xf41b], data=3Dee
Feb 11 22:12:13 dev kernel: stb0899_write_regs [0xf41b]: ee
Feb 11 22:12:13 dev kernel: stb0899_write_regs [0xf43e]: e9 cf
Feb 11 22:12:13 dev kernel: stb0899_search_carrier: Derot Freq=3D-5681, =

mclk=3D1510
Feb 11 22:12:13 dev kernel: _stb0899_read_reg: Reg=3D[0xf41b], data=3Dee
Feb 11 22:12:13 dev kernel: stb0899_write_regs [0xf41b]: ee
Feb 11 22:12:13 dev kernel: _stb0899_read_reg: Reg=3D[0xf43a], data=3D08
Feb 11 22:12:13 dev kernel: stb0899_check_carrier: --------------------> =

STB0899_DSTATUS=3D[0x08]
Feb 11 22:12:13 dev kernel: stb0899_check_carrier: -------------> =

NOCARRIER !
Feb 11 22:12:13 dev kernel: stb0899_write_regs [0xf417]: 33
Feb 11 22:12:13 dev kernel: stb0899_write_regs [0xf41b]: f7
Feb 11 22:12:13 dev kernel: stb0899_read_status: Delivery system DVB-S/DSS
Feb 11 22:12:13 dev kernel: stb0899_read_status: Delivery system DVB-S/DSS
Feb 11 22:12:14 dev kernel: lnbp22_set_voltage: 2 (18V=3D1 13V=3D0)
Feb 11 22:12:14 dev kernel: lnbp22_set_voltage: 0x60)
Feb 11 22:12:14 dev kernel: _stb0899_read_reg: Reg=3D[0xf12a], data=3D5c
Feb 11 22:12:14 dev kernel: stb0899_i2c_gate_ctrl: Disabling I2C =

Repeater ...
Feb 11 22:12:14 dev kernel: stb0899_write_regs [0xf12a]: 5c
Feb 11 22:12:14 dev kernel: stb0899_sleep: Going to Sleep .. (Really =

tired .. :-))
Feb 11 22:12:14 dev kernel: stb0899_write_regs [0xf141]: 82
Feb 11 22:12:14 dev kernel: pctv452e_power_ctrl: 0


(these are the last lines, if you need others, please mail me).

Is there something that I can do?? It works one time scanning and one =

time tuning, after that never more (even after some reboots and plugging =

power off the device).
I don't know if I am doing anything wrong, because one time it works...

thx,

Jens

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
