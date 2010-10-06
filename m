Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47598 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab0JFLuc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Oct 2010 07:50:32 -0400
Received: by wwj40 with SMTP id 40so6995129wwj.1
        for <linux-media@vger.kernel.org>; Wed, 06 Oct 2010 04:50:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1286234505.3167.29.camel@pc07.localdom.local>
References: <25861669.1285195582100.JavaMail.ngmail@webmail18.arcor-online.net>
	<AANLkTimdpehorJb+YrDuRgL7vSbF9Bn5iQS_g5TqF35F@mail.gmail.com>
	<4CA9FCB0.40502@gmail.com>
	<1286234505.3167.29.camel@pc07.localdom.local>
Date: Wed, 6 Oct 2010 13:50:29 +0200
Message-ID: <AANLkTimujmbJEYua6Ezb6zZzvF-WGnorTBGMc2CtrEz7@mail.gmail.com>
Subject: Re: [linux-dvb] Asus MyCinema P7131 Dual support
From: Giorgio <mywing81@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Dejan Rodiger <dejan.rodiger@gmail.com>,
	linux-media@vger.kernel.org, Dmitri Belimov <d.belimov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Hermann,

2010/10/5 hermann pitton <hermann-pitton@arcor.de>:
> Hi Giorgio,
>
> Am Montag, den 04.10.2010, 18:11 +0200 schrieb Giorgio:
>> On 04/10/2010 01:48, Dejan Rodiger wrote:
>> > Hi Hermann,
>> >
>> > I finally found the time to wire analog antena and I checked it with
>> > my TV if it is working correctly.
>> > Since I am using local cable provider which didn't upgrade their
>> > system in 10 years and they are still broadcast in analog, I had a
>> > problem off finding channel list, so in the end I tried tvtime-scanner
>> > and it found about 58 channels. But, out of this 58 most of them were
>> > not good (no signal). I was able to finetune few programs. My main
>> > programs (local Croatian TV stations) were not found. Maybe I need to
>> > finetune every found station.
>> >
>> > I also tried zapping which crashed my X.
>> >
>> > I am also lost in setting mythtv. I set analog tunner on /dev/video0.
>> > But I think I have a problem of setting the channel list for my local
>> > cable provider. Is it possible to scan whole list or something. If you
>> > have any reading recommendation to set this, I would be helpfull
>>
>> Dejan,
>>
>> I have the exact same card:
>>
>> # sudo lpci -vnn
>> 02:07.0 Multimedia controller [0480]: Philips Semiconductors SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
>>       Subsystem: ASUSTeK Computer Inc. Device [1043:4876]
>>       Flags: bus master, medium devsel, latency 64, IRQ 20
>>       Memory at fbfff800 (32-bit, non-prefetchable) [size=2K]
>>       Capabilities: [40] Power Management version 2
>>       Kernel driver in use: saa7134
>>       Kernel modules: saa7134
>>
>> and I can confirm you that it's autodetected and works very well (both the
>> analog and the digital part) on 2.6.35.
>> 2.6.32 has a problem with dvb-t reception, but I have reported it and hopefully
>> it will be fixed soon upstream: http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/23604
>
> thanks for the report and pointing to the details again.

No problem :)

> We can see, that my testings on four different machines and Dmitri's
> tests have not been enough. Mauro had the Dual card=78 version from me
> too at least for analog TV testing.
>
> And, that was on hg with most backward compat as possible.
>
> How good are our chances, to run in such and similar troubles in the
> future, in fact staying only on latest -rc, rc-git and in best case on
> -next stuff previously?

Yes, I was quite disappointed to notice there was a regression in
2.6.30, .31 and .32 and that nobody had noticed it before (in my
experience saa7134 has always been one of the best driver on linux) so
I think it will be very important to test new code properly in the
future, at least before the code is widely used by distros. I am
willing to help with testing.

> It will all come down to the distros and such a bug fix might take just
> a year in the future regularly ...

I reported the bug on Ubuntu's Launchpad, but after the patch was
ready and users confirmed it solved the problem, the Ubuntu team
didn't backport the fix, so dvb-t reception is still broken, for
example, on Ubuntu Lucid 10.04 (which is a long term release, and will
be supported for 3 years)

> So, if the quality control was not even sufficient on hg, what will
> happen on latest -rc git stuff for that?
>
> Obviously zillions of people do much more prefer to crash around there
> than on hg ... ;)
>
> Likely, I only have to read the LKML daily ...
>
> Despite of that, we need a good analysis of course, and a way how to
> avoid such.

Maybe we can have some kind of test team? It would help to find
regressions before it's too late.

> Cheers,
> Hermann

Giorgio Vazzana
