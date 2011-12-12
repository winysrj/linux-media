Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62477 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab1LLSIz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 13:08:55 -0500
Received: by eaaj10 with SMTP id j10so783248eaa.19
        for <linux-media@vger.kernel.org>; Mon, 12 Dec 2011 10:08:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EE62A60.2060505@redhat.com>
References: <CAHFNz9+MM16waF0eLUKwFpX7fBistkb=9OgtXvo+ZOYkk67UQQ@mail.gmail.com>
	<4EE350BF.1090402@redhat.com>
	<CAHFNz9JUEBy5WPuGqKGWuTKYZ6D18GZh+4DEhhDu4+GBTV5R=w@mail.gmail.com>
	<4EE5FF58.8060409@redhat.com>
	<CAHFNz9K-5LCrqFvxFfJUaQX0sYRNgH26Q9eWgiMiWg4F3hGnmw@mail.gmail.com>
	<4EE60814.80706@redhat.com>
	<CAHFNz9JpbmejMabgnGWPa95jXA=uQZ7JbWVRsYBwUUhr1-6S0Q@mail.gmail.com>
	<4EE62A60.2060505@redhat.com>
Date: Mon, 12 Dec 2011 23:38:53 +0530
Message-ID: <CAHFNz9J6p3dEBJPzA+qSD42cZgg+yskE7JYCuD8Y2mgP7gOJiw@mail.gmail.com>
Subject: Re: v4 [PATCH 06/10] DVB: Use a unique delivery system identifier for DVBC_ANNEX_C
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 12, 2011 at 9:52 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> On 12-12-2011 13:00, Manu Abraham wrote:
>>
>> On Mon, Dec 12, 2011 at 7:26 PM, Mauro Carvalho Chehab
>> <mchehab@redhat.com>  wrote:
>>>
>>> On 12-12-2011 11:40, Manu Abraham wrote:
>>>>
>>>>
>>>> On Mon, Dec 12, 2011 at 6:49 PM, Mauro Carvalho Chehab
>>>
>>>
>>>
>>>>> This also means that just doing an alias from FE_QAM and
>>>>> SYS_DVBC_ANNEX_AC
>>>>> to
>>>>> SYS_DVBC_ANNEX_A may break something, as, for most devices,
>>>>> SYS_DVBC_ANNEX_AC
>>>>> really means both Annex A and C.
>>>>
>>>>
>>>>
>>>>
>>>>
>>>> With the current approach, the application can determine whether
>>>> the hardware supports through the DELSYS enumeration.
>>>>
>>>> So, if you have a device that needs to support both ANNEX_A and
>>>> ANNEX_C, it should be rather doing
>>>>
>>>> case DTV_ENUM_DELSYS:
>>>>          buffer.data[0] = SYS_DVBC_ANNEX_A;
>>>>          buffer.data[1] = SYS_DVBC_ANNEX_C;
>>>>          break;
>>>
>>>
>>>
>>> Sure, but we'll need a logic to handle queries for SYS_DVBC_ANNEX_AC
>>> anyway, if any of the existing DVB-C drivers is currently prepared to
>>> support both.
>>>
>>> I'm not concerned with drx-k. The support for both standards are for
>>> kernel 3.3. So, no backward compatibility is needed here.
>>>
>>> While there is no explicit option, the code for stv0297, stv0367,
>>> tda10021 and tda10023 drivers are not clear if they support both
>>> (maybe roll-off might be auto-detected?) or just SYS_DVBC_ANNEX_A.
>>>
>>> That's said, the difference between a 0.15 and a 0.13 rolloff is not big.
>>> I won't doubt that a demod set to 0.15 rolloff would be capable of
>>> working
>>> (non-optimized) with a 0.13 rolloff.
>>>
>>> What I'm saing is that, if any of the existing drivers currently works
>>> with both Annex A and Annex C, we'll need something equivalent to:
>>>
>>> if (delsys == SYS_DVBC_ANNEX_AC) {
>>>        int ret = try_annex_a();
>>>        if (ret<  0)
>>>                ret = try_annex_c();
>>> }
>>>
>>> For FE_SET_FRONTEND (and the corresponding v5 logic), in order to avoid
>>> regressions.
>>
>>
>>
>> What I was implying:
>>
>> set_frontend/search()
>> {
>>      case SYS_DVBC_ANNEX_A:
>>               // do whatever you need to do for annex A tuning and return
>>               break;
>>      case SYS_DVBC_ANNEX_C:
>>               // do whatever you need to do for annex C tuning and return
>>               break;
>> }
>>
>>
>> ANNEX_AC is a link to ANNEX_A;
>
>
> Yes, I saw your approach.
>
>
>> We never had any ? users to ANNEX_C, so
>> that issue might be simple to ignore.
>
>
> This is hard to say. What I'm saying is that, if any of the current
> drivers works as-is with Annex C, we should assume that someone is using,
> as we don't have any evidence otherwise.
>
> I'm sure there are lots of people running Linux in Japan.
>
> How many of them are using the DVB subsystem is hard to say. The low message
> traffic at the ML for people *.jp is not a good measure, as due to language
> barriers, people may not be posting things there.
>
> A quick grep here on my local copy of the ML traffic (it currently has
> stored
> about 380 days of email, as I moved the older ones to a separate storage
> space)
> still shows 90 messages that has ".jp" inside:
>
> $ grep -l "\.jp" * |wc -l
>     90
>
> 41 of them has the word DVB inside. Ok, there are some false positives there
> too (due to *.jpg), but there are some valid hits also,
>
> Including a commit on this changeset:
> e38030f3ff02684eb9e25e983a03ad318a10a2ea.
> As the cx23885 driver does support DVB-C with stv0367, maybe the committer
> might be using it for DVB-C.
>
> Even if not, I suspect that it is likely to have some DVB-C Annex C users
> out there.


As far as I am aware, most of the services use BCAS2 encryption. There
is no BCAS2 support available as Open Source, other than with sundtek.


Regards,
Manu
