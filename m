Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36560 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932764Ab3GWQrM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 12:47:12 -0400
Received: by mail-ob0-f172.google.com with SMTP id wo10so10538924obc.17
        for <linux-media@vger.kernel.org>; Tue, 23 Jul 2013 09:47:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHFNz9JCf6SUWhjErWYBRnwbaFL3WvZuag0_1pZ0Nqt3pG24Hg@mail.gmail.com>
References: <CAA9z4LY6cWEm+4ed7HM3ga0dohsg6LJ6Z4XSge9i4FguJR=FJw@mail.gmail.com>
	<CAHFNz9JCf6SUWhjErWYBRnwbaFL3WvZuag0_1pZ0Nqt3pG24Hg@mail.gmail.com>
Date: Tue, 23 Jul 2013 10:47:11 -0600
Message-ID: <CAA9z4LYFW4iZsQgbPHHhy1ESiEDtVyNV4QaSeULq7p+kWs+e=A@mail.gmail.com>
Subject: Re: Proposed modifications to dvb_frontend_ops
From: Chris Lee <updatelee@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Not all tuners support all fec's

- genpix devices support an odd 5/11 fec for digicipher, pretty sure
no one else does.
- stv0899 supports 1/2, 2/3, 3/4, 5/6, 6/7, 7/8
- stv0900 supports 1/2, 3/5, 2/3, 3/4, 4/5, 5/6, 8/9, 9/10

Not all tuners support the entire range of fec's. I think this is more
the norm then the exception.

If the userland application can poll the driver for a list of
supported fec it allows them to have a list of valid tuning options
for the user to choose from, vs listing everything and hoping it
doesnt fail.

As stated Id much rather have a list made up from system -> modulation -> fec.

ie genpix

SYS_TURBO -> QPSK/8PSK
SYS_TURBO.QPSK -> 1/2, 2/3, 3/4, 5/6, 7/8
SYS_TURBO.8PSK -> 2/3, 3/4, 5/6, 8/9

but that could get more complicated to implement pretty quickly

Chris Lee


On Tue, Jul 23, 2013 at 7:35 AM, Manu Abraham <abraham.manu@gmail.com> wrote:
> On Sat, Jul 20, 2013 at 1:57 AM, Chris Lee <updatelee@gmail.com> wrote:
>> In frontend.h we have a struct called dvb_frontend_ops, in there we
>> have an element called delsys to show the delivery systems supported
>> by the tuner, Id like to propose we add onto that with delmod and
>> delfec.
>>
>> Its not a perfect solution as sometimes a specific modulation or fec
>> is only availible on specific systems. But its better then what we
>> have now. The struct fe_caps isnt really suited for this, its missing
>> many systems, modulations, and fec's. Its just not expandable enough
>> to get all the supported sys/mod/fec a tuner supports in there.
>
> Question > Why should an application know all the modulations and
> FEC's supported by a demodulator ?
>
> Aren't demodulators compliant to their respective delivery systems ?
>
> Or do you mean to state that, you are trying to work around some
> demodulator quirks ?
>
>
> Regards,
>
> Manu
