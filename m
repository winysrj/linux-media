Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:35167 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933378AbbGUTC1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2015 15:02:27 -0400
Received: by qgii95 with SMTP id i95so61406485qgi.2
        for <linux-media@vger.kernel.org>; Tue, 21 Jul 2015 12:02:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55AE9699.2070506@gmail.com>
References: <CALzAhNXQe7AtkwymcUeakVouMBmw7pG79-TeEjBMiK5ysXze_g@mail.gmail.com>
	<55AB5320.8030100@gmail.com>
	<CALzAhNX1Hs7vx9mF_nW08LcbW3Aa2UY0sNEDOi117NfhpCLK-A@mail.gmail.com>
	<55AD1C77.6030208@gmail.com>
	<CALzAhNVmmAy=4r0Vd=T82HPUrOzxK9Rg2-M=DQ8gUa-DXKsS6w@mail.gmail.com>
	<55AE6F31.3050308@gmail.com>
	<CALzAhNVuez1_byQe+FiOjZPdUpdgMg0q8CT2KPJ-rO8o8dohzw@mail.gmail.com>
	<55AE8A73.9070802@gmail.com>
	<55AE9699.2070506@gmail.com>
Date: Tue, 21 Jul 2015 15:02:26 -0400
Message-ID: <CALzAhNUn7v-RzJ2HWiGesgKoYQVR7DJM-PdhomcjfVaN_wdNQw@mail.gmail.com>
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

On Tue, Jul 21, 2015 at 2:59 PM, Tycho Lürsen <tycholursen@gmail.com> wrote:
>
>
> Op 21-07-15 om 20:07 schreef Tycho Lürsen:
>>
>>
>>
>> Op 21-07-15 om 18:19 schreef Steven Toth:
>>>
>>> On Tue, Jul 21, 2015 at 12:11 PM, Tycho Lürsen <tycholursen@gmail.com>
>>> wrote:
>>>>
>>>> Hi Steven,
>>>> I was too curious to wait for you and Antti to settle your differences,
>>>> so I
>>>> tested again against a 4.2-RC2
>>>> I did not disable DVB-T/T2, instead I reordered the lot. MythTV just
>>>> sees
>>>> the first system in the .delsys line in si2168.c,
>>>> so when it looks like this:
>>>> SYS_DVBC_ANNEX_A, SYS_DVBT, SYS_DVBT2
>>>> I'm good.
>>>
>>> We have no differences, its Antti's si2168 driver. If Antti doesn't
>>> like the approach for tri-stating, he's free to suggest and
>>> alternative. I suggested two alternatives yesterday.
>>>
>>>> Result:
>>>> With your patch both MythTV and Tvheadend still can't tune. Without it,
>>>> everything is ok.
>>>>
>>>> I'm not very interested in czap results, only in real use cases. For me
>>>> that's MythTV, but just to be sure I also tested with TVheadend.
>>>
>>> That's pretty bizarre results, although thank you for testing. :)
>>>
>>> When you say it can't tune, do you mean the signal does not lock, or
>>> that no video appears?
>>>
>> No lock, or partial lock.
>
> I've compiled a 4.2-RC3, this time without support for my TBS 6285 cards (so
> no saa716x) and without dvbloopback kernel module (so no MythTV)
>
>
> Result with your patch and only DVBSky T982 cards: TVheadend is fine with
> it. Lock and tune are OK.
> Going to test some more scenario's, I'll keep you informed.
> Regards,
> Tycho

Thank you sir.

In which case, please disregard my last email relating to changing:
 /* Tri-state the TS bus */
 si2168_set_ts_mode(fe, 1);

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
