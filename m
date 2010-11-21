Return-path: <mchehab@gaivota>
Received: from bordeaux.papayaltd.net ([82.129.38.124]:51299 "EHLO
	bordeaux.papayaltd.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab0KUTXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Nov 2010 14:23:07 -0500
Subject: Re: ngene & Satix-S2 dual problems
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Andre <linux-media@dinkum.org.uk>
In-Reply-To: <4CE95582.6070303@googlemail.com>
Date: Sun, 21 Nov 2010 19:23:04 +0000
Cc: Oliver Endriss <o.endriss@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <EB9B0D4A-4C99-4DEB-BEB9-3E3D70C99595@dinkum.org.uk>
References: <4CE7EEC2.3040900@googlemail.com> <201011202022.43042@orion.escape-edv.de> <4AE4560D-F0F3-4D59-A4A1-D8D9A40904A8@dinkum.org.uk> <BF93E88D-7A30-411D-9756-96E2FB95C8A1@googlemail.com> <20B5CF8F-F0FD-40CF-A46B-7356646F7B07@dinkum.org.uk> <4CE95582.6070303@googlemail.com>
To: Robert Longbottom <rongblor@googlemail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


On 21 Nov 2010, at 17:23, Robert Longbottom wrote:

> On 21/11/2010 13:15, Andre wrote:
>> 
>> On 21 Nov 2010, at 13:07, Robert Longbottom wrote:
>> 
>>> 
>>> 
>>> On 21 Nov 2010, at 11:40 AM, Andre<linux-media@dinkum.org.uk>  wrote:
>>> 
>>>> 
>>>> On 20 Nov 2010, at 19:22, Oliver Endriss wrote:
>>>> 
>>>>> Hi,
>>>>> 
>>>>> On Saturday 20 November 2010 16:52:34 Robert Longbottom wrote:
>>>>>> Hi all,
>>>>>> 
>>>>>> I have a Satix-S2 Dual that I'm trying to get to work properly so that I
>>>>>> can use it under MythTv however I'm running into a few issues.  I
>>>>>> previously posted about the problems I'm having here to the mythtv
>>>>>> list[1], but didn't really get anywhere.  I've had chance to have a bit
>>>>>> more of a play and I now seem to have a definite repeatable problem.
>>>>>> 
>>>>>> The problem is when a recording stops on one of the inputs, after about
>>>>>> 40s it causes the other input to loose it's signal lock and stop the
>>>>>> recording as well.
>>>>>> 
>>>>>> 
>>>>>> Steps to demonstrate the problem (My Satix card is adapters 5 and 6)
>>>>>> 
>>>>>> In 3 seperate terminals set up femon/szap/cat to make a recording from
>>>>>> one of the inputs:
>>>>>> 
>>>>>> 1 - femon -a 6 -f 0 -H
>>>>>> 2 - szap -a 6 -f 0 -d 0 -r -H -p -c scanResult07Oct2010_Satix -l
>>>>>> UNIVERSAL "BBC 1 London"
>>>>>> 3 - cat /dev/dvb/adapter6/dvr0>  ad6.mpg
>>>>>> 
>>>>>> In 2 seperate terminals tune in the other input:
>>>>>> 
>>>>>> 4 - femon -a 5 -f 0 -H
>>>>>> 5 - szap -a 5 -f 0 -d 0 -r -H -p -c scanResult07Oct2010_Satix -l
>>>>>> UNIVERSAL "ITV1 London"
>>>>>> 
>>>>>> Both inputs are fine, signal is good, recording from adapter 6 works.
>>>>>> 
>>>>>> 6 - Ctrl-C the szap process created in (5).
>>>>>> 
>>>>>> femon in (4) still reports status=SCVYL and decent signal strengh as if
>>>>>> the adapter is still tuned and FE_HAS_LOCK.  After approximately 40
>>>>>> seconds, either:
>>>>>> 
>>>>>> a) the signal drops significantly but the status remains at SCVYL and
>>>>>> FE_HAS_LOCK
>>>>>> 
>>>>>> or
>>>>>> 
>>>>>> b) the signal drops and the status goes blank with no lock.
>>>>>> 
>>>>>> It doesn't seem to matter which of these two happen, but at the same
>>>>>> time the recording on the other tuner looses it signal and stops
>>>>>> recording, despite the fact that szap is still running in (2).  femon in
>>>>>> (1) no longer reports FE_HAS_LOCK.
>>>>>> 
>>>>>> Strangely if I then try to restart the szap process created in terminal
>>>>>> 2 (to try and retune it) it just waits after printing out "using
>>>>>> '/dev/dvb/....".  However if I then restart the szap process in terminal
>>>>>> 5, the one in terminal 2 suddenly kicks in and gets a lock.
>>>>>> 
>>>>>> Interestingly I found a link describing a 60s period the card is kept
>>>>>> open for [2], which seems to be similar to my ~40s delay.  So it looks
>>>>>> like when the second input on the card is closed the first input looses
>>>>>> it's lock.
>>>>>> 
>>>>>> This obviously makes it pretty useless for MythTv and as a result it's
>>>>>> not currently being used, which is a shame!
>>>>>> 
>>>>>> I'm using the ngene driver from the stock 2.6.35.4 kernel on Gentoo.
>>>>>> 
>>>>>> Does anyone else see this problem?  Is there anything I can do to try
>>>>>> and fix / debug it?  Are there any bug fixes in the latest kernel that
>>>>>> might help, or in the linux-dvb drivers that would help?
>>>>>> 
>>>>>> Any help or advice much appreciated.
>>>>> 
>>>>> Please try this driver:
>>>>> http://linuxtv.org/hg/~endriss/ngene-test2
>>>> 
>>>> Well that's progress, trying Robert's procedure fails with my stock driver (Ubuntu 10.10's 2.6.35-22-generic) but recording continues with your ngene-test2 driver :-)
>>>> 
>>>> NB I needed to go grab ngene_18.fw before it would work and I have three unexpected extra frontends, adapter 0,1&2 as well as the configured 5&6, not sure what's going on there yet!
>>>> 
>>>> There's a ber bump on the other tuner when you retune but it carries on which is the main thing at this stage. Can see glitches at the corresponding spot in the recording but worth a try with Myth perhaps?
>>>> 
>>>> I've been running with only one of the tuners for months, perhaps best to switch off active eit collection though looking at that ber bump.
>>>> 
>>>> Great stuff Oliver.
>>>> 
>>>> Andre
>>>> 
>>>> 
>>> 
>>> That does sound like good news, I'll try and give it a go later today now that I have a process to test with. If it does appear to have fixed it then I'll switch myth over to using it later next week and see how it gets on.
>> 
>> I tried it with Myth 0.24 and just got six simultaneous HD recordings out of it :-)) total seven if you count the one I started to keep the HD-S2 card busy, can't try any more with that sat and my sub.
>> 
>> No glitches I can see, tried it a couple of times with different muxes, so far so good.
>>> 
>>> Will report back with the results later.
>> 
>> You can have your thread back now ;-)
> 
> Thanks ;-)  The more people that test this and iron out the bugs the better :-)

I've got an email monitor looking for any mention of the ngene in here, mythtv, hts & vdr lists so I can see if there is any activity, looking for just this kind of email :-)


> 
> I've run through my procedure again using the ngene-test2 drivers from Oliver and I can report success as well.  I too see a glitch on the 2nd tuner when you retune the 1st, or after about 30s from killing an szap against the 1st, but the stream on the second tuner continues, so thats a massive improvement.  Good work.
> 
> I'll give it a quick go with MythTV as well tonight, and later next week.  Previously when I tried this tuner with MythTV it would record upto 6 streams with no problem, but of couse when one tuner dropped out of use the streams using the other tuner would stop recording (but I didn't know why at the time).  I just need to set up a cunning array of recordings to test that through MythTV, but it looks pretty promising so far.
> 
> Oh, I also get the three extra dvb adapters, in my case 1,2 & 3.  (I already have two other dvb cards in this box that take 0 and 4)  Thats using these module parameters:

That's definitely odd, it's the ngene that's generating them not any of the other cards I have. I just managed to get everything to fit in the default 8 adaptors, I can't use one_adaptor=1 as dvbloopback doesn't work with that.

The extra nodes seem to be a harmless oddity and this driver is a massive improvement, big thank you to Oliver.

Report back in a few days, my system records ~ 10 hours of HD a day, small percentage of which I actually watch so it should get a workout.

Andre

> 
> robert@quad /sys/module/ngene/parameters $ grep -iH . *
> adapter_nr:5,6,-1,-1,-1,-1,-1,-1
> debug:0
> one_adapter:0
> shutdown_workaround:0
> 
> 
> 
> If I use the default parameters:
> robert@quad /sys/module/ngene/parameters $ grep -iH . *
> adapter_nr:-1,-1,-1,-1,-1,-1,-1,-1
> debug:0
> one_adapter:1
> shutdown_workaround:0
> 
> I only get one dvb adapter (/dev/dvb/adapter1), but it contains too much stuff (extra demuxes, dvrs & nets):
> 
> robert@quad /dev/dvb $ ls -l adapter1
> total 0
> crw-rw---- 1 root video 212,  0 Nov 21 17:09 demux0
> crw-rw---- 1 root video 212,  7 Nov 21 17:09 demux1
> crw-rw---- 1 root video 212, 11 Nov 21 17:09 demux2
> crw-rw---- 1 root video 212, 14 Nov 21 17:09 demux3
> crw-rw---- 1 root video 212, 17 Nov 21 17:09 demux4
> crw-rw---- 1 root video 212,  1 Nov 21 17:09 dvr0
> crw-rw---- 1 root video 212,  8 Nov 21 17:09 dvr1
> crw-rw---- 1 root video 212, 12 Nov 21 17:09 dvr2
> crw-rw---- 1 root video 212, 15 Nov 21 17:09 dvr3
> crw-rw---- 1 root video 212, 18 Nov 21 17:09 dvr4
> crw-rw---- 1 root video 212,  6 Nov 21 17:09 frontend0
> crw-rw---- 1 root video 212, 10 Nov 21 17:09 frontend1
> crw-rw---- 1 root video 212,  2 Nov 21 17:09 net0
> crw-rw---- 1 root video 212,  9 Nov 21 17:09 net1
> crw-rw---- 1 root video 212, 13 Nov 21 17:09 net2
> crw-rw---- 1 root video 212, 16 Nov 21 17:09 net3
> crw-rw---- 1 root video 212, 19 Nov 21 17:09 net4
> 
> dmesg reports the following when you do 'modprobe ngene' if that helps at all:
> 
> [ 4504.852993] nGene PCIE bridge driver, Copyright (C) 2005-2007 Micronas
> [ 4504.853039] ngene 0000:02:00.0: PCI INT A -> Link[APC5] -> GSI 16 (level, low) -> IRQ 16
> [ 4504.853048] ngene: Found Mystique SaTiX-S2 Dual (v2)
> [ 4504.855133] ngene 0000:02:00.0: setting latency timer to 64
> [ 4504.855667] ngene: Device version 1
> [ 4504.857551] ngene: Loading firmware file ngene_18.fw.
> [ 4504.876640] ngene 0000:02:00.0: irq 41 for MSI/MSI-X
> [ 4504.878124] error in i2c_read_reg
> [ 4504.878127] No CXD2099 detected at 40
> [ 4504.878285] DVB: registering new adapter (nGene)
> [ 4505.159774] LNBx2x attached on addr=a
> [ 4505.159859] stv6110x_attach: Attaching STV6110x
> [ 4505.159864] DVB: registering adapter 1 frontend 0 (STV090x Multistandard)...
> [ 4505.165626] LNBx2x attached on addr=8
> [ 4505.165894] stv6110x_attach: Attaching STV6110x
> [ 4505.165901] DVB: registering adapter 1 frontend 0 (STV090x Multistandard)...
> 
> Thanks,
> Robert.
> 

