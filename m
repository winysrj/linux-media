Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <fabreg@gmail.com>) id 1KDNQB-0000f4-Kt
	for linux-dvb@linuxtv.org; Mon, 30 Jun 2008 19:44:14 +0200
Received: by wf-out-1314.google.com with SMTP id 27so1568622wfd.17
	for <linux-dvb@linuxtv.org>; Mon, 30 Jun 2008 10:44:07 -0700 (PDT)
Message-ID: <43d295de0806301044w65ed9d84q96785ca01090c8c@mail.gmail.com>
Date: Mon, 30 Jun 2008 19:44:07 +0200
From: "Fabrizio Regalli" <fabreg@gmail.com>
To: "Michael Krufky" <mkrufky@linuxtv.org>
In-Reply-To: <43d295de0806291500y532e2126qaeec577e406406bd@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <43d295de0806291420w4b15c20cj25c05e79617d3371@mail.gmail.com>
	<4867FE44.2000901@linuxtv.org>
	<43d295de0806291437i309164eodfc08c293a3237e1@mail.gmail.com>
	<48680114.4030007@linuxtv.org>
	<43d295de0806291500y532e2126qaeec577e406406bd@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Conexant Device 8852
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

Yo! Now it's ok.

Follow these steps.

Get a new kernel soruce from kernel.org, recompile it *WITHOUT* any
devices like V4L or DVD.
Reboot the machine, install dvb from mercurial.

modprobe cx23885

and dmesg says:

CORE cx23885[0]: subsystem: 0070:71d1, board: Hauppauge WinTV-HVR1200
[card=7,autodetected]
cx23885[0]: i2c bus 0 registered
cx23885[0]: i2c bus 1 registered
cx23885[0]: i2c bus 2 registered
tveeprom 1-0050: Hauppauge model 71999, rev J1E9, serial# 3545326
tveeprom 1-0050: MAC address is 00-0D-FE-36-18-EE
tveeprom 1-0050: tuner model is Philips 18271_8295 (idx 149, type 54)
tveeprom 1-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K)
ATSC/DVB Digital (eeprom 0xf4)
tveeprom 1-0050: audio processor is CX23885 (idx 39)
tveeprom 1-0050: decoder processor is CX23885B (idx 41)
tveeprom 1-0050: has no radio, has no IR receiver, has no IR transmitter
cx23885[0]: hauppauge eeprom: model=71999
cx23885[0]: cx23885 based dvb card
tda829x 2-0042: type set to tda8295
tda18271 2-0060: creating new instance
TDA18271HD/C1 detected @ 2-0060
DVB: registering new adapter (cx23885[0])
DVB: registering frontend 0 (NXP TDA10048HN DVB-T)...
cx23885_dev_checkrevision() Hardware revision = 0xb0
cx23885[0]/0: found at 0000:03:00.0, rev: 2, irq: 16, latency: 0,
mmio: 0xf9c00000
PCI: Setting latency timer of device 0000:03:00.0 to 64

The modules loads fine.

Now I can't try the card with some software because I'm remotely
connected, but later I'll trying.

Thanks to all, in particoular "sn9" from #linuxtv

Regards.
Fabrizio

2008/6/30 Fabrizio Regalli <fabreg@gmail.com>:
> Ok, I've installed the cvs version of driver.
>
> Now I've another problem loading of cx23885 module:
>
> WARNING: Error inserting videobuf_core
> (/lib/modules/2.6.25.9/kernel/drivers/media/video/videobuf-core.ko):
> Invalid argument
> WARNING: Error inserting dvb_core
> (/lib/modules/2.6.25.9/kernel/drivers/media/dvb/dvb-core/dvb-core.ko):
> Invalid argument
> WARNING: Error inserting videobuf_dvb
> (/lib/modules/2.6.25.9/kernel/drivers/media/video/videobuf-dvb.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
> WARNING: Error inserting videobuf_dma_sg
> (/lib/modules/2.6.25.9/kernel/drivers/media/video/videobuf-dma-sg.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
> WARNING: Error inserting compat_ioctl32
> (/lib/modules/2.6.25.9/kernel/drivers/media/video/compat_ioctl32.ko):
> Invalid module format
> WARNING: Error inserting v4l1_compat
> (/lib/modules/2.6.25.9/kernel/drivers/media/video/v4l1-compat.ko):
> Invalid argument
> WARNING: Error inserting videodev
> (/lib/modules/2.6.25.9/kernel/drivers/media/video/videodev.ko):
> Invalid module format
> FATAL: Error inserting cx23885
> (/lib/modules/2.6.25.9/kernel/drivers/media/video/cx23885/cx23885.ko):
> Unknown symbol in module, or unknown parameter (see dmesg)
>
> Maybe I must disable the kernel native module before compile this new one?
>
> Thanks.
> Fab
>
> 2008/6/29 Michael Krufky <mkrufky@linuxtv.org>:
>> 2008/6/29 Michael Krufky <mkrufky@linuxtv.org>:
>>>> Fabrizio Regalli wrote:
>>>>
>>>>> Hello.
>>>>>
>>>>> I've the follow tv card on my linux box:
>>>>>
>>>>> 03:00.0 Multimedia video controller: Conexant Device 8852 (rev 02)
>>>>>       Subsystem: Hauppauge computer works Inc. Device 71d1
>>>>>
>>>> [snip]
>>>>
>>>>> I try to use cx23885 driver (with card=<1,2,3,4,5,6> option) but doesn't works.
>>>>> Could someone please help me?
>>>>>
>>>> Use the cx23885 driver from linuxtv.org master branch -- Hauppauge WinTV-HVR1200 will be supported with the 2.6.26 kernel.
>>>>
>>>> Regards,
>>>>
>>>> Mike
>>>>
>>>>
>>
>> Fabrizio Regalli wrote:
>>> Hi Michael
>>>
>>> thanks for your reply.
>>> Which extacly are the files needed? Maybe
>>>
>>> http://linuxtv.org/downloads/linuxtv-dvb-1.1.1.tar.bz2
>>>
>>> and
>>>
>>> http://linuxtv.org/downloads/linuxtv-dvb-apps-1.1.1.tar.bz2
>>>
>>> Thanks again.
>>> Fab
>>>
>>
>> Follow these instructions:
>>
>> http://linuxtv.org/repo/#mercurial
>>
>> Good luck!
>>
>> -Mike
>>
>>
>>
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
