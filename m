Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59963 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab1LLPAH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 10:00:07 -0500
Received: by faar15 with SMTP id r15so1294696faa.19
        for <linux-media@vger.kernel.org>; Mon, 12 Dec 2011 07:00:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EE60814.80706@redhat.com>
References: <CAHFNz9+MM16waF0eLUKwFpX7fBistkb=9OgtXvo+ZOYkk67UQQ@mail.gmail.com>
	<4EE350BF.1090402@redhat.com>
	<CAHFNz9JUEBy5WPuGqKGWuTKYZ6D18GZh+4DEhhDu4+GBTV5R=w@mail.gmail.com>
	<4EE5FF58.8060409@redhat.com>
	<CAHFNz9K-5LCrqFvxFfJUaQX0sYRNgH26Q9eWgiMiWg4F3hGnmw@mail.gmail.com>
	<4EE60814.80706@redhat.com>
Date: Mon, 12 Dec 2011 20:30:06 +0530
Message-ID: <CAHFNz9JpbmejMabgnGWPa95jXA=uQZ7JbWVRsYBwUUhr1-6S0Q@mail.gmail.com>
Subject: Re: v4 [PATCH 06/10] DVB: Use a unique delivery system identifier for DVBC_ANNEX_C
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 12, 2011 at 7:26 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> On 12-12-2011 11:40, Manu Abraham wrote:
>>
>> On Mon, Dec 12, 2011 at 6:49 PM, Mauro Carvalho Chehab
>
>
>>> This also means that just doing an alias from FE_QAM and
>>> SYS_DVBC_ANNEX_AC
>>> to
>>> SYS_DVBC_ANNEX_A may break something, as, for most devices,
>>> SYS_DVBC_ANNEX_AC
>>> really means both Annex A and C.
>>
>>
>>
>>
>> With the current approach, the application can determine whether
>> the hardware supports through the DELSYS enumeration.
>>
>> So, if you have a device that needs to support both ANNEX_A and
>> ANNEX_C, it should be rather doing
>>
>> case DTV_ENUM_DELSYS:
>>          buffer.data[0] = SYS_DVBC_ANNEX_A;
>>          buffer.data[1] = SYS_DVBC_ANNEX_C;
>>          break;
>
>
> Sure, but we'll need a logic to handle queries for SYS_DVBC_ANNEX_AC
> anyway, if any of the existing DVB-C drivers is currently prepared to
> support both.
>
> I'm not concerned with drx-k. The support for both standards are for
> kernel 3.3. So, no backward compatibility is needed here.
>
> While there is no explicit option, the code for stv0297, stv0367,
> tda10021 and tda10023 drivers are not clear if they support both
> (maybe roll-off might be auto-detected?) or just SYS_DVBC_ANNEX_A.
>
> That's said, the difference between a 0.15 and a 0.13 rolloff is not big.
> I won't doubt that a demod set to 0.15 rolloff would be capable of working
> (non-optimized) with a 0.13 rolloff.
>
> What I'm saing is that, if any of the existing drivers currently works
> with both Annex A and Annex C, we'll need something equivalent to:
>
> if (delsys == SYS_DVBC_ANNEX_AC) {
>        int ret = try_annex_a();
>        if (ret < 0)
>                ret = try_annex_c();
> }
>
> For FE_SET_FRONTEND (and the corresponding v5 logic), in order to avoid
> regressions.


What I was implying:

set_frontend/search()
{
     case SYS_DVBC_ANNEX_A:
              // do whatever you need to do for annex A tuning and return
              break;
     case SYS_DVBC_ANNEX_C:
              // do whatever you need to do for annex C tuning and return
              break;
}


ANNEX_AC is a link to ANNEX_A; We never had any ? users to ANNEX_C, so
that issue might be simple to ignore.
