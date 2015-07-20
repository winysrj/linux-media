Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36085 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbbGTQGU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 12:06:20 -0400
Received: by wicgb10 with SMTP id gb10so30972747wic.1
        for <linux-media@vger.kernel.org>; Mon, 20 Jul 2015 09:06:18 -0700 (PDT)
Message-ID: <55AD1C77.6030208@gmail.com>
Date: Mon, 20 Jul 2015 18:06:15 +0200
From: =?UTF-8?B?VHljaG8gTMO8cnNlbg==?= <tycholursen@gmail.com>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: tonyc@wincomm.com.tw, Antti Palosaari <crope@iki.fi>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: Adding support for three new Hauppauge HVR-1275 variants - testers
 reqd.
References: <CALzAhNXQe7AtkwymcUeakVouMBmw7pG79-TeEjBMiK5ysXze_g@mail.gmail.com>	<55AB5320.8030100@gmail.com> <CALzAhNX1Hs7vx9mF_nW08LcbW3Aa2UY0sNEDOi117NfhpCLK-A@mail.gmail.com>
In-Reply-To: <CALzAhNX1Hs7vx9mF_nW08LcbW3Aa2UY0sNEDOi117NfhpCLK-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steven,
I was not aware of the fact that your patch depends on dvb-core as in 
4.2-RC2 (and up, I guess)
I tested against 3.18.18 and 4.1.2. That might explain the failures.
Anyhow, as soon as Antti and you are on the same page regarding this 
patch, I'll test again against a 4.2-RC>1
Regards,
Tycho.

Op 20-07-15 om 15:13 schreef Steven Toth:
> On Sun, Jul 19, 2015 at 3:34 AM, Tycho Lürsen <tycholursen@gmail.com> wrote:
>> Hi Steven,
>>
>> Tested your si2186 patch with my DVBSky T982 and TBS 6285 cards using
>> European DVB-C
>> Since MythTV can't handle multistandard frontends (yet), I've disabled
>> DVB-T/T2 like this (I always do that):
>>
>> sed -i 's/SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A/SYS_DVBC_ANNEX_A/'
>> drivers/media/dvb-frontends/si2168.c
>>
>> Result: both DVBSky T982 and TBS 6285 drivers are broken, meaning no lock,
>> no tune.
>>
>> Regards,
>> Tycho.
>>
>> Op 19-07-15 om 00:21 schreef Steven Toth:
>>> http://git.linuxtv.org/cgit.cgi/stoth/hvr1275.git/log/?h=hvr-1275
>>>
>>> Patches above are available for test.
>>>
>>> Antti, note the change to SI2168 to add support for enabling and
>>> disabling the SI2168 transport bus dynamically.
>>>
>>> I've tested with a combo card, switching back and forward between QAM
>>> and DVB-T, this works fine, just remember to select a different
>>> frontend as we have two frontends on the same adapter,
>>> adapter0/frontend0 is QAM/8SVB, adapter0/frontend1 is DVB-T/T2.
>>>
>>> If any testers have the ATSC or DVB-T, I'd expect these to work
>>> equally well, replease report feedback here.
>>>
>>> Thanks,
>>>
>>> - Steve
> Interesting, although I'm slightly confused.
>
> My patch mere added the ability for dvb-core to tri-state the tsport
> out bus, similar to other digital demodulator drivers in the tree....
> and testing with both azap and tzap (and dvbtraffic) showed no tuning,
> lock or other issues.
>
> What happens if you tzap/czap a known good frequency, before and after
> my patch, without your sed replacement, leaving T/T2 and A fully
> enabled?
>
> - Steve
>

