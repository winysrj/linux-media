Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:36426 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934140Ab3GWWhh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 18:37:37 -0400
Received: by mail-lb0-f177.google.com with SMTP id 10so6622218lbf.22
        for <linux-media@vger.kernel.org>; Tue, 23 Jul 2013 15:37:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA9z4LbeV223oPfyjzUpGLrg55Z8Eag8Hpu3x++N_LsiRr8y+Q@mail.gmail.com>
References: <CAA9z4LY6cWEm+4ed7HM3ga0dohsg6LJ6Z4XSge9i4FguJR=FJw@mail.gmail.com>
	<CAHFNz9JCf6SUWhjErWYBRnwbaFL3WvZuag0_1pZ0Nqt3pG24Hg@mail.gmail.com>
	<CAA9z4LYFW4iZsQgbPHHhy1ESiEDtVyNV4QaSeULq7p+kWs+e=A@mail.gmail.com>
	<CAHFNz9KNMVXa1kpMjoiiB4T9P-=AQqm7cfPDau_mtAQTxbUCEw@mail.gmail.com>
	<CAA9z4LbeV223oPfyjzUpGLrg55Z8Eag8Hpu3x++N_LsiRr8y+Q@mail.gmail.com>
Date: Wed, 24 Jul 2013 04:07:35 +0530
Message-ID: <CAHFNz9+KX2G8bz_9gpwBJpUr14VBUo=qAYLHm9-_0b8z_XUdzQ@mail.gmail.com>
Subject: Re: Proposed modifications to dvb_frontend_ops
From: Manu Abraham <abraham.manu@gmail.com>
To: Chris Lee <updatelee@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 24, 2013 at 2:57 AM, Chris Lee <updatelee@gmail.com> wrote:
>> Nitpick: tuner doesn't have anything to do with FEC, it just provides IQ
>> outputs to the demodulator. ;-)
>
> ya ya :) you knew what I meant, not what I said hehe
>
>> Demods support all FEC's relevant to their delivery systems. It's just that
>> some devices likely do support some additional states.
>
> This part I dont understand, what do you mean additional states ? and
> how would a userland application determine if a demod supports these
> additional states?


Actually, the userland application shouldn't know about these.


>> If I am not mistaken, the genpix hardware is a hardware wrapper around the
>> BCM demodulator. So, it is quite likely that even if you don't set any FEC
>> parameter, the device could still acquire lock as expected. I am not holding
>> my breath on this. Maybe someone with a genpix device can prove me right
>> or wrong.
>
> FEC_AUTO works for all but turbo-qpsk on genpix devices.
>


That was why the SYS_TURBO flag was introduced. IIRC, you needed one
flag alone for the turbo mode.


> I still think its important to have all the fec supported in the
> driver though even if FEC_AUTO did work 100% else why even have it as
> an option at all.

Maybe, FEC_AUTO is broken for some very old hardware.

If FEC_AUTO works just as expected, why would you have to take the
gigantic effort of specifying parameters by hand which is error prone which
you have mentioned later on ? I fail to understand your point.


>> With the STB0899 driver, all you need to tune with it is Frequency,
>> Symbol Rate and Delivery system
>>
>>
>> With the STV090x driver all you need is Frequency and Symbol Rate.
>> (It will auto detect delivery system)
>
> Same thing, I still think if we allow the user to send a fec value we
> should make sure its right, else why not just hard code all the
> drivers to fec-auto that support it and remove the option all
> together. I dont like that option.



This is why it was decided eventually that the FEC bits are redundant
and we decided not to create large lists and enumerations causing
insanity and not to mention ugliness. AFAIR, almost all drivers do
FEC_AUTO, except for the ones which have some known issues.



>> When a driver is not accepting those parameters as inputs, why
>> should the application/user burden himself with knowing parameters
>> of no relevance to him ?
>
> But it will accept them as inputs. without complaint too. I can send
> DTV_INNER_FEC w/ FEC_5_11 to stv090x and it doesnt complain at all,
> even though it doesnt support it. It'll even acquire a lock just
> because the demod uses blind search. So the driver most definitely
> does accept fec that it cant use.



The driver will acquire a lock to the frequency/srate and "return" the
relevant FEC value for the user/application. This avoids pitfalls and
human errors in manually specifying FEC bits to tune configurations,
as I described above. Because some legacy application does set
a FEC value which might be wrong and the rest are correct, I wouldn't
fail that request.



>> Actually with all those redundant FEC bits gone away from relevance, things are
>> a bit more saner.
>
> I dont understand this either. "gone away from relevance" are you
> meaning just how they really arent used much anymore or something?
> still though if the demod supports them I think we should too.


Yeah, they aren't really used at all. They exist for compatibility reasons.


                Manu
