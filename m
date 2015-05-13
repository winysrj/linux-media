Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:58233 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965006AbbEMTxL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 15:53:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: y2038@lists.linaro.org
Cc: John Stultz <john.stultz@linaro.org>,
	Ksenija Stanojevic <ksenija.stanojevic@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [Y2038] [PATCH v3] Staging: media: Replace timeval with ktime_t
Date: Wed, 13 May 2015 21:53:07 +0200
Message-ID: <5274992.1I7KfpY9Ml@wuerfel>
In-Reply-To: <CALAqxLWjo3+h5QqVnJGe2vda9SbUGg1L8wZjuQWSVaX5di1MzA@mail.gmail.com>
References: <1431536238-12738-1-git-send-email-ksenija.stanojevic@gmail.com> <CALAqxLWjo3+h5QqVnJGe2vda9SbUGg1L8wZjuQWSVaX5di1MzA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 13 May 2015 10:04:48 John Stultz wrote:
> On Wed, May 13, 2015 at 9:57 AM, Ksenija Stanojevic
> <ksenija.stanojevic@gmail.com> wrote:
> > 'struct timeval last_tv' is used to get the time of last signal change
> > and 'struct timeval last_intr_tv' is used to get the time of last UART
> > interrupt.
> > 32-bit systems using 'struct timeval' will break in the year 2038, so we
> > have to replace that code with more appropriate types.
> > Here struct timeval is replaced with ktime_t.
> >
> > Signed-off-by: Ksenija Stanojevic <ksenija.stanojevic@gmail.com>

An additional comment: as drivers/staging/media refers to a whole subsystem
with mutually independent drivers, the subject line should mention 'lirc',
either in addition to, or instead of 'media'.

> > -static long delta(struct timeval *tv1, struct timeval *tv2)
> > +static inline long delta(ktime_t t1, ktime_t t2)
> >  {
> > -       unsigned long deltv;
> > -
> > -       deltv = tv2->tv_sec - tv1->tv_sec;
> > -       if (deltv > 15)
> > -               deltv = 0xFFFFFF;
> > -       else
> > -               deltv = deltv*1000000 +
> > -                       tv2->tv_usec -
> > -                       tv1->tv_usec;
> > -       return deltv;
> > +       /* return the delta in 32bit usecs, but cap to UINTMAX in case the
> > +        * delta is greater then 32bits */
> > +       return (long) min((unsigned int) ktime_us_delta(t1, t2), UINT_MAX);
> >  }
> 
> This probably needs some close review from the media folks. Thinking
> about it more, I'm really not certain the 15sec cap was to avoid a
> 32bit overflow or if there's some other subtle undocumented reason.

The new code is clearly wrong, as the cast to 'unsigned int' already truncates
the value to at most UINT_MAX, and the min() does not have any effect.

The correct way to write what was intended here is

	return min_t(long long, ktime_us_delta(t1, t2), UINT_MAX);

which will truncate delta to an unsigned integer. The return type of the
delta() function would need to be changed to 'unsigned long' as well to
make this work.

However, I think you are right that we should probably not change the
behavior, unless someone who understands the purpose better can say
what it really should be. I'd probably change teh above to

	long delta_us = ktime_us_delta(t1, t2);
	return min(delta_us, PULSE_MASK);

	Arnd
