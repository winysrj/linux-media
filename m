Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab1LLN4j (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 08:56:39 -0500
Message-ID: <4EE60814.80706@redhat.com>
Date: Mon, 12 Dec 2011 11:56:36 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4 [PATCH 06/10] DVB: Use a unique delivery system identifier
 for DVBC_ANNEX_C
References: <CAHFNz9+MM16waF0eLUKwFpX7fBistkb=9OgtXvo+ZOYkk67UQQ@mail.gmail.com> <4EE350BF.1090402@redhat.com> <CAHFNz9JUEBy5WPuGqKGWuTKYZ6D18GZh+4DEhhDu4+GBTV5R=w@mail.gmail.com> <4EE5FF58.8060409@redhat.com> <CAHFNz9K-5LCrqFvxFfJUaQX0sYRNgH26Q9eWgiMiWg4F3hGnmw@mail.gmail.com>
In-Reply-To: <CAHFNz9K-5LCrqFvxFfJUaQX0sYRNgH26Q9eWgiMiWg4F3hGnmw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12-12-2011 11:40, Manu Abraham wrote:
> On Mon, Dec 12, 2011 at 6:49 PM, Mauro Carvalho Chehab

>> This also means that just doing an alias from FE_QAM and SYS_DVBC_ANNEX_AC
>> to
>> SYS_DVBC_ANNEX_A may break something, as, for most devices,
>> SYS_DVBC_ANNEX_AC
>> really means both Annex A and C.
>
>
>
> With the current approach, the application can determine whether
> the hardware supports through the DELSYS enumeration.
>
> So, if you have a device that needs to support both ANNEX_A and
> ANNEX_C, it should be rather doing
>
> case DTV_ENUM_DELSYS:
>           buffer.data[0] = SYS_DVBC_ANNEX_A;
>           buffer.data[1] = SYS_DVBC_ANNEX_C;
>           break;

Sure, but we'll need a logic to handle queries for SYS_DVBC_ANNEX_AC
anyway, if any of the existing DVB-C drivers is currently prepared to
support both.

I'm not concerned with drx-k. The support for both standards are for
kernel 3.3. So, no backward compatibility is needed here.

While there is no explicit option, the code for stv0297, stv0367,
tda10021 and tda10023 drivers are not clear if they support both
(maybe roll-off might be auto-detected?) or just SYS_DVBC_ANNEX_A.

That's said, the difference between a 0.15 and a 0.13 rolloff is not big.
I won't doubt that a demod set to 0.15 rolloff would be capable of working
(non-optimized) with a 0.13 rolloff.

What I'm saing is that, if any of the existing drivers currently works
with both Annex A and Annex C, we'll need something equivalent to:

if (delsys == SYS_DVBC_ANNEX_AC) {
	int ret = try_annex_a();
	if (ret < 0)
		ret = try_annex_c();
}

For FE_SET_FRONTEND (and the corresponding v5 logic), in order to avoid
regressions.

>
>
>> I didn't look inside the drivers for stv0297, stv0367, tda10021 and
>> tda10023.
>> I suspect that some will need an additional code to change the roll-off,
>> based on
>> the delivery system.
>
>
>
> Of course, yes this would need to make the change across multiple
> drivers.
>
> We can fix the drivers, that's no issue at all, as it is a small change.

Indeed, it is a small change. Tuners are trivial to change, but, at the
demod, we need to discover if roll-off is auto-detected somehow, or if
they require manual settings, in order to fix the demod drivers.

>
> Regards,
> Manu

