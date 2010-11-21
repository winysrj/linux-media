Return-path: <mchehab@gaivota>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62051 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab0KUNGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Nov 2010 08:06:13 -0500
Received: by wyb28 with SMTP id 28so6065437wyb.19
        for <linux-media@vger.kernel.org>; Sun, 21 Nov 2010 05:06:12 -0800 (PST)
References: <4CE7EEC2.3040900@googlemail.com> <201011202022.43042@orion.escape-edv.de> <4AE4560D-F0F3-4D59-A4A1-D8D9A40904A8@dinkum.org.uk>
In-Reply-To: <4AE4560D-F0F3-4D59-A4A1-D8D9A40904A8@dinkum.org.uk>
Mime-Version: 1.0 (iPod Mail 8B117)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <BF93E88D-7A30-411D-9756-96E2FB95C8A1@googlemail.com>
Cc: Oliver Endriss <o.endriss@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Robert Longbottom <rongblor@googlemail.com>
Subject: Re: ngene & Satix-S2 dual problems
Date: Sun, 21 Nov 2010 13:07:17 +0000
To: Andre <linux-media@dinkum.org.uk>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>



On 21 Nov 2010, at 11:40 AM, Andre <linux-media@dinkum.org.uk> wrote:

> 
> On 20 Nov 2010, at 19:22, Oliver Endriss wrote:
> 
>> Hi,
>> 
>> On Saturday 20 November 2010 16:52:34 Robert Longbottom wrote:
>>> Hi all,
>>> 
>>> I have a Satix-S2 Dual that I'm trying to get to work properly so that I 
>>> can use it under MythTv however I'm running into a few issues.  I 
>>> previously posted about the problems I'm having here to the mythtv 
>>> list[1], but didn't really get anywhere.  I've had chance to have a bit 
>>> more of a play and I now seem to have a definite repeatable problem.
>>> 
>>> The problem is when a recording stops on one of the inputs, after about 
>>> 40s it causes the other input to loose it's signal lock and stop the 
>>> recording as well.
>>> 
>>> 
>>> Steps to demonstrate the problem (My Satix card is adapters 5 and 6)
>>> 
>>> In 3 seperate terminals set up femon/szap/cat to make a recording from 
>>> one of the inputs:
>>> 
>>> 1 - femon -a 6 -f 0 -H
>>> 2 - szap -a 6 -f 0 -d 0 -r -H -p -c scanResult07Oct2010_Satix -l 
>>> UNIVERSAL "BBC 1 London"
>>> 3 - cat /dev/dvb/adapter6/dvr0 > ad6.mpg
>>> 
>>> In 2 seperate terminals tune in the other input:
>>> 
>>> 4 - femon -a 5 -f 0 -H
>>> 5 - szap -a 5 -f 0 -d 0 -r -H -p -c scanResult07Oct2010_Satix -l 
>>> UNIVERSAL "ITV1 London"
>>> 
>>> Both inputs are fine, signal is good, recording from adapter 6 works.
>>> 
>>> 6 - Ctrl-C the szap process created in (5).
>>> 
>>> femon in (4) still reports status=SCVYL and decent signal strengh as if 
>>> the adapter is still tuned and FE_HAS_LOCK.  After approximately 40 
>>> seconds, either:
>>> 
>>> a) the signal drops significantly but the status remains at SCVYL and 
>>> FE_HAS_LOCK
>>> 
>>> or
>>> 
>>> b) the signal drops and the status goes blank with no lock.
>>> 
>>> It doesn't seem to matter which of these two happen, but at the same 
>>> time the recording on the other tuner looses it signal and stops 
>>> recording, despite the fact that szap is still running in (2).  femon in 
>>> (1) no longer reports FE_HAS_LOCK.
>>> 
>>> Strangely if I then try to restart the szap process created in terminal 
>>> 2 (to try and retune it) it just waits after printing out "using 
>>> '/dev/dvb/....".  However if I then restart the szap process in terminal 
>>> 5, the one in terminal 2 suddenly kicks in and gets a lock.
>>> 
>>> Interestingly I found a link describing a 60s period the card is kept 
>>> open for [2], which seems to be similar to my ~40s delay.  So it looks 
>>> like when the second input on the card is closed the first input looses 
>>> it's lock.
>>> 
>>> This obviously makes it pretty useless for MythTv and as a result it's 
>>> not currently being used, which is a shame!
>>> 
>>> I'm using the ngene driver from the stock 2.6.35.4 kernel on Gentoo.
>>> 
>>> Does anyone else see this problem?  Is there anything I can do to try 
>>> and fix / debug it?  Are there any bug fixes in the latest kernel that 
>>> might help, or in the linux-dvb drivers that would help?
>>> 
>>> Any help or advice much appreciated.
>> 
>> Please try this driver:
>> http://linuxtv.org/hg/~endriss/ngene-test2
> 
> Well that's progress, trying Robert's procedure fails with my stock driver (Ubuntu 10.10's 2.6.35-22-generic) but recording continues with your ngene-test2 driver :-)
> 
> NB I needed to go grab ngene_18.fw before it would work and I have three unexpected extra frontends, adapter 0,1&2 as well as the configured 5&6, not sure what's going on there yet!
> 
> There's a ber bump on the other tuner when you retune but it carries on which is the main thing at this stage. Can see glitches at the corresponding spot in the recording but worth a try with Myth perhaps?
> 
> I've been running with only one of the tuners for months, perhaps best to switch off active eit collection though looking at that ber bump.
> 
> Great stuff Oliver.
> 
> Andre
> 
> 

That does sound like good news, I'll try and give it a go later today now that I have a process to test with. If it does appear to have fixed it then I'll switch myth over to using it later next week and see how it gets on. 

Will report back with the results later. 

Robert. 

> 
>> 
>> CU
>> Oliver
>> 
>> -- 
>> ----------------------------------------------------------------
>> VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
>> 4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
>> Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
>> ----------------------------------------------------------------
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
> 
