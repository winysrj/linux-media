Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f180.google.com ([209.85.128.180]:52440 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757994Ab3GWUyX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 16:54:23 -0400
Received: by mail-ve0-f180.google.com with SMTP id pa12so6383424veb.25
        for <linux-media@vger.kernel.org>; Tue, 23 Jul 2013 13:54:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA9z4LYFW4iZsQgbPHHhy1ESiEDtVyNV4QaSeULq7p+kWs+e=A@mail.gmail.com>
References: <CAA9z4LY6cWEm+4ed7HM3ga0dohsg6LJ6Z4XSge9i4FguJR=FJw@mail.gmail.com>
	<CAHFNz9JCf6SUWhjErWYBRnwbaFL3WvZuag0_1pZ0Nqt3pG24Hg@mail.gmail.com>
	<CAA9z4LYFW4iZsQgbPHHhy1ESiEDtVyNV4QaSeULq7p+kWs+e=A@mail.gmail.com>
Date: Wed, 24 Jul 2013 02:24:21 +0530
Message-ID: <CAHFNz9KNMVXa1kpMjoiiB4T9P-=AQqm7cfPDau_mtAQTxbUCEw@mail.gmail.com>
Subject: Re: Proposed modifications to dvb_frontend_ops
From: Manu Abraham <abraham.manu@gmail.com>
To: Chris Lee <updatelee@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 23, 2013 at 10:17 PM, Chris Lee <updatelee@gmail.com> wrote:
> Not all tuners support all fec's

Nitpick: tuner doesn't have anything to do with FEC, it just provides IQ
outputs to the demodulator. ;-)

That said;

Demods support all FEC's relevant to their delivery systems. It's just that
some devices likely do support some additional states.


> - genpix devices support an odd 5/11 fec for digicipher, pretty sure
> no one else does.

I think DCII FEC5/11 is standard, reading this URL
http://rickcaylor.websitetoolbox.com/post/DCII-Valid-SRFECModulation-Combinations-5827500

Also, according to the BCM4201 datasheet:
* DVB/DIRECTV/Digicipher II compliant FEC decoder
64 state viterbi decoder supports rates= 5/11, 1/2, 3/5, 2/3, 3/4.
4/5, 5/6, 6/7, 7/8

I would say, it is pretty much standard for DCII.

Given that it is pretty much standard, I would say that for DCII; for
the genpix
all you need is a SYS_DCII and or a SYS_DSS addition to the genpix driver,
rather than having a ton of delivery systems mixed with modulations as in
your patch with DCII_QPSK, ... _OQPSK etc. Actually, those are a bit too
superfluous. You shouldn't mix delivery systems and modulations. That was
the whole reason why the delivery system flag was introduced to make
things saner and proper for the frontend API.

If I am not mistaken, the genpix hardware is a hardware wrapper around the
BCM demodulator. So, it is quite likely that even if you don't set any FEC
parameter, the device could still acquire lock as expected. I am not holding
my breath on this. Maybe someone with a genpix device can prove me right
or wrong.


> - stv0899 supports 1/2, 2/3, 3/4, 5/6, 6/7, 7/8
> - stv0900 supports 1/2, 3/5, 2/3, 3/4, 4/5, 5/6, 8/9, 9/10


Ah....

Though these devices support additional modes, the STB0899 (I don't know
whether you meant the STB0899 with stv0899, yet looking at the stb0899,
since there doesn't seem to be other references)

With the STB0899 driver, all you need to tune with it is Frequency,
Symbol Rate and Delivery system


With the STV090x driver all you need is Frequency and Symbol Rate.
(It will auto detect delivery system)


>
> Not all tuners support the entire range of fec's. I think this is more
> the norm then the exception.
>


I find it slightly hard to believe... ;-)


> If the userland application can poll the driver for a list of
> supported fec it allows them to have a list of valid tuning options
> for the user to choose from, vs listing everything and hoping it
> doesnt fail.


When a driver is not accepting those parameters as inputs, why
should the application/user burden himself with knowing parameters
of no relevance to him ?


>
> As stated Id much rather have a list made up from system -> modulation -> fec.
>
> ie genpix
>
> SYS_TURBO -> QPSK/8PSK
> SYS_TURBO.QPSK -> 1/2, 2/3, 3/4, 5/6, 7/8
> SYS_TURBO.8PSK -> 2/3, 3/4, 5/6, 8/9
>
> but that could get more complicated to implement pretty quickly


Actually with all those redundant FEC bits gone away from relevance, things are
a bit more saner.

Regards,

Manu
