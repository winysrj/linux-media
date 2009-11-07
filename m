Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f180.google.com ([209.85.216.180]:48344 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZKGL2q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Nov 2009 06:28:46 -0500
Received: by pxi10 with SMTP id 10so1324572pxi.33
        for <linux-media@vger.kernel.org>; Sat, 07 Nov 2009 03:28:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197380911061743o64c4661gfdee5c65f680904e@mail.gmail.com>
References: <20764.64.213.30.2.1257390002.squirrel@webmail.exetel.com.au>
	 <702870ef0911051257k52c142e8ne1b32506f1efb45c@mail.gmail.com>
	 <829197380911051304g1544e277s870f869be14e1a18@mail.gmail.com>
	 <25126.64.213.30.2.1257464759.squirrel@webmail.exetel.com.au>
	 <829197380911051551q3b844c5ek490a5eb7c96783e9@mail.gmail.com>
	 <39786.64.213.30.2.1257466403.squirrel@webmail.exetel.com.au>
	 <40380.64.213.30.2.1257474692.squirrel@webmail.exetel.com.au>
	 <829197380911051843r4a55bddcje8c014f5548ca247@mail.gmail.com>
	 <702870ef0911061659q208b73c3te7d62f5a220e9499@mail.gmail.com>
	 <829197380911061743o64c4661gfdee5c65f680904e@mail.gmail.com>
Date: Sat, 7 Nov 2009 22:28:51 +1100
Message-ID: <702870ef0911070328v4d39afd9kc2469fb3e78ba203@mail.gmail.com>
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Robert Lowery <rglowery@exemail.com.au>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin

> please confirm exactly which of your boards is not working.

Sorry for being unclear.

I have three test setups I am working with, all on the same computer.
1. Ubuntu Hardy, kernel 2.6.24-23-rt and drivers from v4l-dvb tip.
2. Ubuntu Karmic, kernel 2.6.31-14-generic, stock Ubuntu drivers.
3. Ubuntu Karmic, kernel 2.6.31-14-generic, v4l-dvb tip.

Setups 2 & 3 are the same install, on a separate hard disk from setup 1.
I change between 2 & 3 by installing the v4l modules or restoring the
ubuntu stuff from backup. (rsync -av --delete).

The computer has two DVB-T cards.

First device is the same as Robert's, I believe. It has two tuners. lsusb gives:
Bus 003 Device 003: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4
(ZL10353+xc2028/xc3028) (initialized)
Bus 003 Device 002: ID 0fe9:db78 DVICO FusionHDTV DVB-T Dual Digital 4
(ZL10353+xc2028/xc3028) (initialized)
I have a 'rev1' version of this board.


Second device is DViCO FusionHDTV Dual Digital Express, a PCIe card
based on cx23885[1] It also has two tuners. lspci gives:
04:00.0 Multimedia video controller [0400]: Conexant Systems, Inc.
CX23885 PCI Video and Audio Decoder [14f1:8852] (rev 02)
	Subsystem: DViCO Corporation Device [18ac:db78]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at 90000000 (64-bit, non-prefetchable) [size=2M]
	Capabilities: <access denied>
	Kernel driver in use: cx23885
	Kernel modules: cx23885

With Robert's patch compiled in:
 * On setup 1
  I am able to tune both cards and there are no errors from the cxusb module
   or dvb-usb anymore.
   I tested each of the four tuners, by running dvbscan with
appropriate arguments to
   select the right /dev/dvb/adapterN.

   I just realised I should probably revert the patch and check which
tuners show the
   original problem. Before I was taking the default choice (adapter0,
I think) which is
    one of lhe Dual Digital 4 tuners.

 * I have yet to test setup 2,
   I have built the patched kernel module but the box is back 'in
production' right now.
   I plan to test tomorrow.

 * On setup 3. I attempted to tune using dvbscan, w_scan and vlc.
   Again, I was not specific about which tuner the applications should use.
   So to answer your question, I think it is the lsusb id 0fe9:db78
that is unable to tune.
   I will check the tuners individually, tomorrow.

   My impression was that the failures were because of API differences
between the
   applications (all provided as part of the ubuntu install) and the
V4L modules. I have
   not tried to build v4l-apps from the mercurial tree.

So, I hope this makes things clearer. Happy to run tests if you have
any time to look at this.

Kind regards
Vince


[1] http://linuxtv.org/wiki/index.php/DViCO_FusionHDTV_DVB-T_Dual_Express

On 11/7/09, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
> Please excuse the top post. This is coming from my phone.
>
> Vincent, please confirm exactly which of your boards is not working.
> Roberts patch is not a general fix and only applies to his EXACT
> product .
>
> please provide the pci/usb I'd in question.
>
> thanks,
>
> devin
>
> On 11/6/09, Vincent McIntyre <vincent.mcintyre@gmail.com> wrote:
>> I tried this patch, on 2.6.24-23-rt and 2.6.31-14-generic
>> .
>> On the first, it appears to work fine. Thanks again Rob!
>>
>> On the second, while the kernel seems happy I am unable to get any
>> applications to tune the card, when I use the latest v4l tree + Rob's
>> patch (40705fec2fb2 tip).
>>
>>  * dvbscan fails with 'unable to query frontend status'
>>
>>  * vlc is unable to tune as well
>> [0x9c2cf50] dvb access error: DVB-T: setting frontend failed (-1):
>> Invalid argument
>> [0x9c2cf50] dvb access error: DVB-T: tuning failed
>> [0xb7400c18] main input error: open of `dvb://frequency=177500' failed:
>> (null)
>>
>>
>>  * w_scan fails a bit more informatively
>> w_scan version 20090808 (compiled for DVB API 5.0)
>> using settings for AUSTRALIA
>> DVB aerial
>> DVB-T AU
>> frontend_type DVB-T, channellist 3
>> output format vdr-1.6
>> Info: using DVB adapter auto detection.
>>         /dev/dvb/adapter0/frontend0 -> DVB-T "Zarlink ZL10353 DVB-T": good
>> :-)
>>         /dev/dvb/adapter1/frontend0 -> DVB-T "Zarlink ZL10353 DVB-T": good
>> :-)
>>         /dev/dvb/adapter2/frontend0 -> DVB-T "Zarlink ZL10353 DVB-T": good
>> :-)
>>         /dev/dvb/adapter3/frontend0 -> DVB-T "Zarlink ZL10353 DVB-T": good
>> :-)
>> Using DVB-T frontend (adapter /dev/dvb/adapter0/frontend0)
>> -_-_-_-_ Getting frontend capabilities-_-_-_-_
>> Using DVB API 5.1
>> frontend Zarlink ZL10353 DVB-T supports
>> INVERSION_AUTO
>> QAM_AUTO
>> TRANSMISSION_MODE_AUTO
>> GUARD_INTERVAL_AUTO
>> HIERARCHY_AUTO
>> FEC_AUTO
>> -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
>> Scanning 7MHz frequencies...
>> 177500: (time: 00:00) set_frontend:1690: FATAL: unsupported DVB API
>> Version
>> 5.1
>>
>> Presumably this is all understood and expected (i.e. application
>> authors are updating their code?)
>>
>> Is there a way to build with the API set to version 5.0?
>>
>> I was able to use vlc and w_scan ok with Rob's module option
>> workaround and the stock modules from ubuntu. I will have a go at
>> building their source + Rob's patch.
>>
>>
>> On 11/6/09, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
>>> On Thu, Nov 5, 2009 at 9:31 PM, Robert Lowery <rglowery@exemail.com.au>
>>> wrote:
>>>> Devin,
>>>>
>>>> I have confirmed the patch below fixes my issue.  Could you please merge
>>>> it for me?
>>>>
>>>> Thanks
>>>>
>>>> -Rob
>>>
>>> Sure.  I'm putting together a patch series for this weekend with a few
>>> different misc fixes.
>>>
>>> Devin
>>>
>>> --
>>> Devin J. Heitmueller - Kernel Labs
>>> http://www.kernellabs.com
>>>
>>
>
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>
