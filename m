Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:35927 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933691Ab3GWV1l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 17:27:41 -0400
Received: by mail-oa0-f43.google.com with SMTP id i7so12577640oag.16
        for <linux-media@vger.kernel.org>; Tue, 23 Jul 2013 14:27:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHFNz9KNMVXa1kpMjoiiB4T9P-=AQqm7cfPDau_mtAQTxbUCEw@mail.gmail.com>
References: <CAA9z4LY6cWEm+4ed7HM3ga0dohsg6LJ6Z4XSge9i4FguJR=FJw@mail.gmail.com>
	<CAHFNz9JCf6SUWhjErWYBRnwbaFL3WvZuag0_1pZ0Nqt3pG24Hg@mail.gmail.com>
	<CAA9z4LYFW4iZsQgbPHHhy1ESiEDtVyNV4QaSeULq7p+kWs+e=A@mail.gmail.com>
	<CAHFNz9KNMVXa1kpMjoiiB4T9P-=AQqm7cfPDau_mtAQTxbUCEw@mail.gmail.com>
Date: Tue, 23 Jul 2013 15:27:41 -0600
Message-ID: <CAA9z4LbeV223oPfyjzUpGLrg55Z8Eag8Hpu3x++N_LsiRr8y+Q@mail.gmail.com>
Subject: Re: Proposed modifications to dvb_frontend_ops
From: Chris Lee <updatelee@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Nitpick: tuner doesn't have anything to do with FEC, it just provides IQ
> outputs to the demodulator. ;-)

ya ya :) you knew what I meant, not what I said hehe

> Demods support all FEC's relevant to their delivery systems. It's just that
> some devices likely do support some additional states.

This part I dont understand, what do you mean additional states ? and
how would a userland application determine if a demod supports these
additional states?

> I think DCII FEC5/11 is standard, reading this URL
> http://rickcaylor.websitetoolbox.com/post/DCII-Valid-SRFECModulation-Combinations-5827500
> I would say, it is pretty much standard for DCII.

yes 5/11 is standard for DCII, but nothing else.

> Given that it is pretty much standard, I would say that for DCII; for
> the genpix
> all you need is a SYS_DCII and or a SYS_DSS addition to the genpix driver,
> rather than having a ton of delivery systems mixed with modulations as in
> your patch with DCII_QPSK, ... _OQPSK etc. Actually, those are a bit too
> superfluous. You shouldn't mix delivery systems and modulations. That was
> the whole reason why the delivery system flag was introduced to make
> things saner and proper for the frontend API.

Yup fair enough, easy to change, I'll get on that and resubmit the patch.

> If I am not mistaken, the genpix hardware is a hardware wrapper around the
> BCM demodulator. So, it is quite likely that even if you don't set any FEC
> parameter, the device could still acquire lock as expected. I am not holding
> my breath on this. Maybe someone with a genpix device can prove me right
> or wrong.

FEC_AUTO works for all but turbo-qpsk on genpix devices.

I still think its important to have all the fec supported in the
driver though even if FEC_AUTO did work 100% else why even have it as
an option at all.

> With the STB0899 driver, all you need to tune with it is Frequency,
> Symbol Rate and Delivery system
>
>
> With the STV090x driver all you need is Frequency and Symbol Rate.
> (It will auto detect delivery system)

Same thing, I still think if we allow the user to send a fec value we
should make sure its right, else why not just hard code all the
drivers to fec-auto that support it and remove the option all
together. I dont like that option.

> When a driver is not accepting those parameters as inputs, why
> should the application/user burden himself with knowing parameters
> of no relevance to him ?

But it will accept them as inputs. without complaint too. I can send
DTV_INNER_FEC w/ FEC_5_11 to stv090x and it doesnt complain at all,
even though it doesnt support it. It'll even acquire a lock just
because the demod uses blind search. So the driver most definitely
does accept fec that it cant use.

> Actually with all those redundant FEC bits gone away from relevance, things are
> a bit more saner.

I dont understand this either. "gone away from relevance" are you
meaning just how they really arent used much anymore or something?
still though if the demod supports them I think we should too.

Honestly I still think the .delsys .delmod .delfec is a cleaner
approach then we have now which is ugly and mismatched (modulations
mixed in with fec, and only some are defined) its not a perfect
solution though so I really dont think its worth fighting for if
others dont agree with me. Im just kinda surprised that everyone is
perfectly happy with the .delsys / .caps method we use

Chris
