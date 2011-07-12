Return-path: <mchehab@localhost>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59640 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab1GLSVt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2011 14:21:49 -0400
Received: by iyb12 with SMTP id 12so4889648iyb.19
        for <linux-media@vger.kernel.org>; Tue, 12 Jul 2011 11:21:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19995.8804.939482.9336@morden.metzler>
References: <201107031831.20378@orion.escape-edv.de>
	<CAGoCfiwaYhXFi1_QXX55nfSOivgnk1YyDNP5_sXL61k3hdabQA@mail.gmail.com>
	<19995.8804.939482.9336@morden.metzler>
Date: Tue, 12 Jul 2011 14:21:47 -0400
Message-ID: <CAOcJUbyNvds6es80SSo9nzUrHakOkPO3GfWg6tKpTN=z=0UfXQ@mail.gmail.com>
Subject: Re: [PATCH 00/16] New drivers: DRX-K, TDA18271c2, Updates: CXD2099
 and ngene
From: Michael Krufky <mkrufky@kernellabs.com>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Oliver Endriss <o.endriss@gmx.de>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Mon, Jul 11, 2011 at 12:18 PM, Ralph Metzler <rjkm@metzlerbros.de> wrote:
> Hi Devin,
>
> Devin Heitmueller writes:
>  > On Sun, Jul 3, 2011 at 12:31 PM, Oliver Endriss <o.endriss@gmx.de> wrote:
>  > > [PATCH 01/16] tda18271c2dd: Initial check-in
>  > > [PATCH 02/16] tda18271c2dd: Lots of coding-style fixes
>  >
>  > Oliver,
>  >
>  > Why the new driver for the 18271c2?  There is already such a driver,
>  > and in the past we've rejected multiple drivers for the same chip
>  > unless there is a *very* compelling reason to do such.
>  >
>  > The existing 18271 driver supports the C2 and is actively maintained.
>  >

...not to mention that many bridge drivers are now depending on the
tda18271 tuner module - It's well-tested and proven to work properly
with a variety of different kinda of hardware.

> AFAIR, there were at least 2 reasons.
> One was that the existing driver does not accept 2 (or even 4) tuners with the
> same address (but behind different demods) on the same I2C bus which
> is the case on duoflex C/T addon cards.

This is a limitation with the hybrid_tuner_request_state - When
creating this mechanism, I foresaw this scenario, but didnt have a way
to test any solution.  One way we can account for this would be to rev
hybrid_tuner_request_state to optionally take a unique identifier
rather than an i2c bus ID to identify the uniqueness of the tuner
instance...

> The other was that it does not give back the intermediate frequency
> which the demod needs. (This is currently done by misusing
> get_frequency() but I added a get_if() call in newer internal versions
> which should be added to dvb-core/dvb_frontend.h)

Why not add the get_if() call to the existing driver?  Improvements
are always welcome :-)

> Feel free to change ngene/ddbridge to use the existing driver but it
> will need some major changes in tda18271_attach() and a few other places.

...the attach is the most insignificant part of the driver.  If there
are limitations causing trouble for you, then we should look at those
limitations rather than duplicating a development effort.

Regards,

Mike Krufky
