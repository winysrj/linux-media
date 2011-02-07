Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64882 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375Ab1BGDE4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Feb 2011 22:04:56 -0500
Received: by wwa36 with SMTP id 36so4354014wwa.1
        for <linux-media@vger.kernel.org>; Sun, 06 Feb 2011 19:04:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110206232800.GA83692@io.frii.com>
References: <AANLkTin8Rjch6o7aU-9S9m8f5aBYVeSwxSaVhyEfM5q9@mail.gmail.com>
	<20110206232800.GA83692@io.frii.com>
Date: Sun, 6 Feb 2011 20:04:54 -0700
Message-ID: <AANLkTinMCTh-u-JgcNB3SsZ2yf+9DgNFGA6thF7S0K15@mail.gmail.com>
Subject: Re: Tuning channels with DViCO FusionHDTV7 Dual Express
From: Dave Johansen <davejohansen@gmail.com>
To: v4l-dvb Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Feb 6, 2011 at 4:14 PM, Daniel O'Connor <darius@dons.net.au> wrote:
>
> You could try the latest DVB drivers, although on my DViCo (which looks like the DVB-T version of yours) they aren't any better.
>
> However the drivers in Ubuntu at least work for 1 tuner, if I try and use both in mythtv one tends to lock up after a while :-/

I actually had the card working and tuning channels about 2 years ago
with Ubuntu 08.10 and 09.04. From what I recall 08.10 required updated
drivers but 09.04 didn't, so I'd imagine that it should at least be
possible for it to work and possibly just out of the box. But do you
think that has a high likelihood of success now?

On Sun, Feb 6, 2011 at 4:28 PM, Mark Zimmerman <markzimm@frii.com> wrote:
> On Sun, Feb 06, 2011 at 03:46:59PM -0700, Dave Johansen wrote:
>> I am trying to resurrect my MythBuntu system with a DViCO FusionHDTV7
>> Dual Express. I had previously had some issues with trying to get
>> channels working in MythTV (
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg03846.html
>> ), but now it locks up with MythBuntu 10.10 when I scan for channels
>> in MythTV and also with the scan command line utility.
>>
>> Here's the output from scan:
>>
>> scan /usr/share/dvb/atsc/us-ATSC-
>> center-frequencies-8VSB
>> scanning us-ATSC-center-frequencies-8VSB
>> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>> >>> tune to: 189028615:8VSB
>> WARNING: filter timeout pid 0x0000
>> WARNING: filter timeout pid 0x1ffb
>>
>> Any ideas/suggestions on how I can get this to work?
>
> Check your dmesg to see if yout firmware loads.
>
>
>

I checked dmesg and the firmware loads. It doesn't appear to report
any errors either.

Thanks,
Dave
