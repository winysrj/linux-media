Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251Ab1LQNY6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Dec 2011 08:24:58 -0500
Message-ID: <4EEC9822.3080308@redhat.com>
Date: Sat, 17 Dec 2011 11:24:50 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Manu Abraham <abraham.manu@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4 [PATCH 06/10] DVB: Use a unique delivery system identifier
 for DVBC_ANNEX_C
References: <CAHFNz9+MM16waF0eLUKwFpX7fBistkb=9OgtXvo+ZOYkk67UQQ@mail.gmail.com> <4EE350BF.1090402@redhat.com> <CAHFNz9JUEBy5WPuGqKGWuTKYZ6D18GZh+4DEhhDu4+GBTV5R=w@mail.gmail.com> <4EE5FF58.8060409@redhat.com> <CAHFNz9K-5LCrqFvxFfJUaQX0sYRNgH26Q9eWgiMiWg4F3hGnmw@mail.gmail.com> <4EE60814.80706@redhat.com> <4EE67126.8080000@linuxtv.org>
In-Reply-To: <4EE67126.8080000@linuxtv.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 12-12-2011 19:24, Andreas Oberritter escreveu:
> On 12.12.2011 14:56, Mauro Carvalho Chehab wrote:
>> On 12-12-2011 11:40, Manu Abraham wrote:
>>> On Mon, Dec 12, 2011 at 6:49 PM, Mauro Carvalho Chehab
>>
>>>> This also means that just doing an alias from FE_QAM and
>>>> SYS_DVBC_ANNEX_AC
>>>> to
>>>> SYS_DVBC_ANNEX_A may break something, as, for most devices,
>>>> SYS_DVBC_ANNEX_AC
>>>> really means both Annex A and C.
>>>
>>>
>>>
>>> With the current approach, the application can determine whether
>>> the hardware supports through the DELSYS enumeration.
>>>
>>> So, if you have a device that needs to support both ANNEX_A and
>>> ANNEX_C, it should be rather doing
>>>
>>> case DTV_ENUM_DELSYS:
>>>           buffer.data[0] = SYS_DVBC_ANNEX_A;
>>>           buffer.data[1] = SYS_DVBC_ANNEX_C;
>>>           break;
>>
>> Sure, but we'll need a logic to handle queries for SYS_DVBC_ANNEX_AC
>> anyway, if any of the existing DVB-C drivers is currently prepared to
>> support both.
>>
>> I'm not concerned with drx-k. The support for both standards are for
>> kernel 3.3. So, no backward compatibility is needed here.
>>
>> While there is no explicit option, the code for stv0297, stv0367,
>> tda10021 and tda10023 drivers are not clear if they support both
>> (maybe roll-off might be auto-detected?) or just SYS_DVBC_ANNEX_A.
> 
> tda10021: Driver sets roll-off to 0.15. No auto-detection.
> tda10023: Driver sets roll-off to 0.18. No auto-detection.
> 
> In general, auto-detection seems unlikely. Do you know any chip that
> does it? Unless you do, we shouldn't expect it to exist. stv0297 doesn't
> even detect IQ inversion.
> 
>> That's said, the difference between a 0.15 and a 0.13 rolloff is not big.
>> I won't doubt that a demod set to 0.15 rolloff would be capable of working
>> (non-optimized) with a 0.13 rolloff.
>>
>> What I'm saing is that, if any of the existing drivers currently works
>> with both Annex A and Annex C, we'll need something equivalent to:
>>
>> if (delsys == SYS_DVBC_ANNEX_AC) {
>>     int ret = try_annex_a();
>>     if (ret < 0)
>>         ret = try_annex_c();
>> }
> 
> I'd prefer treating ANNEX_AC just like ANNEX_A. It won't break anything,
> because register writes for ANNEX_A will be the same. i.e. applications
> using SYS_DVBC_ANNEX_AC will still get the same result as before.
> 
> What may change for a user: An updated application may allow him to
> select between A and C, if the frontend advertises both. In this case,
> both A and C are supposed to work, depending on the location of the
> user. Someone who successfully used his tuner in Japan before, and who's
> frontend doesn't advertise C, will still be able to choose A and thus
> use the same register settings as before.


As all existing DVB-C drivers currently upstream seem to be assuming a
Annex A, I don't have any troubles on doing that.


> 
>>>> I didn't look inside the drivers for stv0297, stv0367, tda10021 and
>>>> tda10023.
>>>> I suspect that some will need an additional code to change the roll-off,
>>>> based on
>>>> the delivery system.
>>>
>>>
>>>
>>> Of course, yes this would need to make the change across multiple
>>> drivers.
>>>
>>> We can fix the drivers, that's no issue at all, as it is a small change.
>>
>> Indeed, it is a small change. Tuners are trivial to change, but, at the
>> demod, we need to discover if roll-off is auto-detected somehow, or if
>> they require manual settings, in order to fix the demod drivers.
> 
> tda10021: Register 0x3d & 0x01: 0 -> 0.15; 1 -> 0.13
> tda10023: Register 0x3d & 0x03: 2 -> 0.15; 3 -> 0.13

Thanks for the info!

I'll prepare a patchset with Manu's patch 06 on it, plus the required
changes at the DocBook specs and the fixes for the drx-k based drivers
and for tda10021/tda10023. I should be sending the patches to the ML
later today.

> 
> Regards,
> Andreas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

