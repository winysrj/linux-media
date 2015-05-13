Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:35700 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934118AbbEMVpj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 17:45:39 -0400
Received: by igbyr2 with SMTP id yr2so151423331igb.0
        for <linux-media@vger.kernel.org>; Wed, 13 May 2015 14:45:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150513181026.5b52b458@recife.lan>
References: <1431536238-12738-1-git-send-email-ksenija.stanojevic@gmail.com>
	<CALAqxLWjo3+h5QqVnJGe2vda9SbUGg1L8wZjuQWSVaX5di1MzA@mail.gmail.com>
	<5274992.1I7KfpY9Ml@wuerfel>
	<20150513181026.5b52b458@recife.lan>
Date: Wed, 13 May 2015 14:45:38 -0700
Message-ID: <CALAqxLUVFHNcss5+Cfao8ci_=cFJN77ZMAkz6hxK1OQzPFmddw@mail.gmail.com>
Subject: Re: [Y2038] [PATCH v3] Staging: media: Replace timeval with ktime_t
From: John Stultz <john.stultz@linaro.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	y2038 Mailman List <y2038@lists.linaro.org>,
	Ksenija Stanojevic <ksenija.stanojevic@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 13, 2015 at 2:10 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Em Wed, 13 May 2015 21:53:07 +0200
> Arnd Bergmann <arnd@arndb.de> escreveu:
>
>> On Wednesday 13 May 2015 10:04:48 John Stultz wrote:
>> > On Wed, May 13, 2015 at 9:57 AM, Ksenija Stanojevic
>> > <ksenija.stanojevic@gmail.com> wrote:
>> > > 'struct timeval last_tv' is used to get the time of last signal change
>> > > and 'struct timeval last_intr_tv' is used to get the time of last UART
>> > > interrupt.
>> > > 32-bit systems using 'struct timeval' will break in the year 2038, so we
>> > > have to replace that code with more appropriate types.
>> > > Here struct timeval is replaced with ktime_t.
>> > >
>> > > Signed-off-by: Ksenija Stanojevic <ksenija.stanojevic@gmail.com>
>>
>> An additional comment: as drivers/staging/media refers to a whole subsystem
>> with mutually independent drivers, the subject line should mention 'lirc',
>> either in addition to, or instead of 'media'.
>>
>> > > -static long delta(struct timeval *tv1, struct timeval *tv2)
>> > > +static inline long delta(ktime_t t1, ktime_t t2)
>> > >  {
>> > > -       unsigned long deltv;
>> > > -
>> > > -       deltv = tv2->tv_sec - tv1->tv_sec;
>> > > -       if (deltv > 15)
>> > > -               deltv = 0xFFFFFF;
>> > > -       else
>> > > -               deltv = deltv*1000000 +
>> > > -                       tv2->tv_usec -
>> > > -                       tv1->tv_usec;
>> > > -       return deltv;
>> > > +       /* return the delta in 32bit usecs, but cap to UINTMAX in case the
>> > > +        * delta is greater then 32bits */
>> > > +       return (long) min((unsigned int) ktime_us_delta(t1, t2), UINT_MAX);
>> > >  }
>> >
>> > This probably needs some close review from the media folks. Thinking
>> > about it more, I'm really not certain the 15sec cap was to avoid a
>> > 32bit overflow or if there's some other subtle undocumented reason.
>>
>> The new code is clearly wrong, as the cast to 'unsigned int' already truncates
>> the value to at most UINT_MAX, and the min() does not have any effect.
>>
>> The correct way to write what was intended here is
>>
>>       return min_t(long long, ktime_us_delta(t1, t2), UINT_MAX);
>>
>> which will truncate delta to an unsigned integer. The return type of the
>> delta() function would need to be changed to 'unsigned long' as well to
>> make this work.
>>
>> However, I think you are right that we should probably not change the
>> behavior, unless someone who understands the purpose better can say
>> what it really should be.
>
> Inside the remote controller code, we have measurements for pulse/space
> encodings on a IR transmission. The duration of a pulse or space is
> generally in the other of microseconds. On the standard protocols, the
> maximum duration is on NEC protocol, where a pulse of 9 ms is sent at
> the beginning:
>         http://www.sbprojects.com/knowledge/ir/nec.php
>
> It should be noticed that bigger time intervals can be used to indicate
> key repeat. Again, in the NEC protocol, the space between key repeats
> are 110 ms.
>
> So, everything above 110 ms is actually an infinite time.
>
> As the Kernel implementation was built to be generic enough, we consider
> (u32)-1 (e. g. about 4 seconds) as the maximum possible time.

So that's ~4 seconds of nanoseconds, but since we're talking usecs,
UINT_MAX is something like 70-some minutes.


> This is due to the fact that some IR protocols use u32 for the pulse/space
> time shifts. So, any duration bigger than that could actually be
> rounded to (u32)-1.

Sure. The part that confused me is that the delta function is checking
if the second delta is larger then 15 seconds, and I couldn't quite
understand the significance of that check. If it really is just to
make sure the timeval -> usec conversion doesn't overflow, then that's
easy enough to solve. But if the 15 second check has some other
meaning, we'd want to understand before changing this.

> That's said, I really don't see the need of "fixing" it on the y2038
> patchset. All that it is needed is to warrant that the time difference
> will be positive.
>
> I would, instead, remove the delta function, and replace:
>
>         do_gettimeofday(&curr_tv);
>         deltv = delta(&last_tv, &curr_tv);
>
> (and other equivalent parts)
>
> By an equivalent logic that would be reading the timestamp from a
> high precision clock.
>
> That's said, I suspect that this driver is broken, as I doubt that
> do_gettimeofday() gets enough precision needed for IR decoding. Also,
> as this returns a non-monotonic timestamp, it will break if one adjusts
> the clock while IR keys are being pressed.

Yep. Moving to ktime_get should help since it uses the monotonic clock.

thanks
-john
