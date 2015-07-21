Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:34480 "EHLO
	mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbbGUTAu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2015 15:00:50 -0400
Received: by qkfc129 with SMTP id c129so96473173qkf.1
        for <linux-media@vger.kernel.org>; Tue, 21 Jul 2015 12:00:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55AE8A73.9070802@gmail.com>
References: <CALzAhNXQe7AtkwymcUeakVouMBmw7pG79-TeEjBMiK5ysXze_g@mail.gmail.com>
	<55AB5320.8030100@gmail.com>
	<CALzAhNX1Hs7vx9mF_nW08LcbW3Aa2UY0sNEDOi117NfhpCLK-A@mail.gmail.com>
	<55AD1C77.6030208@gmail.com>
	<CALzAhNVmmAy=4r0Vd=T82HPUrOzxK9Rg2-M=DQ8gUa-DXKsS6w@mail.gmail.com>
	<55AE6F31.3050308@gmail.com>
	<CALzAhNVuez1_byQe+FiOjZPdUpdgMg0q8CT2KPJ-rO8o8dohzw@mail.gmail.com>
	<55AE8A73.9070802@gmail.com>
Date: Tue, 21 Jul 2015 15:00:49 -0400
Message-ID: <CALzAhNW9_S=gaT9ioytcpz1hBJ4qjdxaJN6E7ZPQ__8QPdQ=6w@mail.gmail.com>
Subject: Re: Adding support for three new Hauppauge HVR-1275 variants -
 testers reqd.
From: Steven Toth <stoth@kernellabs.com>
To: =?UTF-8?Q?Tycho_L=C3=BCrsen?= <tycholursen@gmail.com>
Cc: tonyc@wincomm.com.tw, Antti Palosaari <crope@iki.fi>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 21, 2015 at 2:07 PM, Tycho Lürsen <tycholursen@gmail.com> wrote:
>
>
> Op 21-07-15 om 18:19 schreef Steven Toth:
>>
>> On Tue, Jul 21, 2015 at 12:11 PM, Tycho Lürsen <tycholursen@gmail.com>
>> wrote:
>>>
>>> Hi Steven,
>>> I was too curious to wait for you and Antti to settle your differences,
>>> so I
>>> tested again against a 4.2-RC2
>>> I did not disable DVB-T/T2, instead I reordered the lot. MythTV just sees
>>> the first system in the .delsys line in si2168.c,
>>> so when it looks like this:
>>> SYS_DVBC_ANNEX_A, SYS_DVBT, SYS_DVBT2
>>> I'm good.
>>
>> We have no differences, its Antti's si2168 driver. If Antti doesn't
>> like the approach for tri-stating, he's free to suggest and
>> alternative. I suggested two alternatives yesterday.
>>
>>> Result:
>>> With your patch both MythTV and Tvheadend still can't tune. Without it,
>>> everything is ok.
>>>
>>> I'm not very interested in czap results, only in real use cases. For me
>>> that's MythTV, but just to be sure I also tested with TVheadend.
>>
>> That's pretty bizarre results, although thank you for testing. :)
>>
>> When you say it can't tune, do you mean the signal does not lock, or
>> that no video appears?
>>
> No lock, or partial lock.

Thanks.

That's even worse than expected, given that the patch adjusts the TS
interface, and has nothing to do with tuning, lock, rf or signal
status. It still feels like something else is going on, some other
unexpected race for example.

I can't reproduce that behavior, but given that you can.... Can you
please try this? in si2168.c, change:

 /* Tri-state the TS bus */
 si2168_set_ts_mode(fe, 1);

to

 /* Tri-state the TS bus */
 si2168_set_ts_mode(fe, 0);

... recompile and retest?

Thx.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
