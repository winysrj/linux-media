Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:9775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758064Ab1GKRTM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 13:19:12 -0400
Message-ID: <4E1B3085.2040907@redhat.com>
Date: Mon, 11 Jul 2011 14:19:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Ralph Metzler <rjkm@metzlerbros.de>,
	Oliver Endriss <o.endriss@gmx.de>, linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [PATCH 00/16] New drivers: DRX-K, TDA18271c2, Updates: CXD2099
 and ngene
References: <201107031831.20378@orion.escape-edv.de> <CAGoCfiwaYhXFi1_QXX55nfSOivgnk1YyDNP5_sXL61k3hdabQA@mail.gmail.com> <19995.8804.939482.9336@morden.metzler> <CAGoCfizQhU10ECyHwcdY+T6=66-KcPxRL-j_w3ELHpK=6+wwdg@mail.gmail.com>
In-Reply-To: <CAGoCfizQhU10ECyHwcdY+T6=66-KcPxRL-j_w3ELHpK=6+wwdg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi Ralph and Devin,

Em 11-07-2011 13:27, Devin Heitmueller escreveu:
> Hi Ralph,
> 
> Good to hear from you.
> 
>> AFAIR, there were at least 2 reasons.
>> One was that the existing driver does not accept 2 (or even 4) tuners with the
>> same address (but behind different demods) on the same I2C bus which
>> is the case on duoflex C/T addon cards.

I2C core has now support for I2C switches, but I never used it.

I'm not against of merging the tda18271c2 at the short term, but the
both driver maintainers need to work on merging them into one driver
at the long term, to avoid duplicated maintenance efforts.

> Do you mean that you are relying solely on the i2c gates on the
> "other" demods being closed so that the tuners associated with the
> other inputs do not receive the commands?  If so, that would
> definitely create the need for some weird locking structure (since
> today demods typically do not manage their i2c gates in tandem).
> 
>> The other was that it does not give back the intermediate frequency
>> which the demod needs. (This is currently done by misusing
>> get_frequency() but I added a get_if() call in newer internal versions
>> which should be added to dvb-core/dvb_frontend.h)
>
> Generally speaking with other devices the IF is configured for the
> tuner depending on the target modulation (there is a tda18271_config
> struct passed at attach time containing the IF for various modes).
> Then the demod driver is also configured for a particular IF.

Yeah, with the current way, it is possible to make it work, by binding
tda18271 3 times (one for analog, one for DVB-T and another for DVB-C).
Some care should be taken at the frontend, to avoid it to create one
private instance of its management struct for each binding, but it
works fine. The hybrid_tuner_request_state() call does such trick.
It also works fine when analog is enabled.

> Are you changing the IF based on something other than the target
> modulation type?  Or do you need to vary the IF based on different
> frequencies within the same modulation?
> 
>> Feel free to change ngene/ddbridge to use the existing driver but it
>> will need some major changes in tda18271_attach() and a few other places.
> 
> If there are indeed good reasons, then so be it.  But it feels like we
> are working around deficiencies in the core DVB framework that would
> apply to all drivers, and it would be good if we could avoid the
> maintenance headaches associated with two different drivers for the
> same chip.

Agreed.

Ralph,

Could you please check if my patches didn't break for ngene/ddbridge?
I don't have any ngene/ddbrige here for testing. In special, I had to 
add a fix for drxk module rmmod due to the way dvb_attach() works.

Thanks!
Mauro
