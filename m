Return-path: <mchehab@localhost>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43259 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757981Ab1GKQ1o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 12:27:44 -0400
Received: by eyx24 with SMTP id 24so1410619eyx.19
        for <linux-media@vger.kernel.org>; Mon, 11 Jul 2011 09:27:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <19995.8804.939482.9336@morden.metzler>
References: <201107031831.20378@orion.escape-edv.de>
	<CAGoCfiwaYhXFi1_QXX55nfSOivgnk1YyDNP5_sXL61k3hdabQA@mail.gmail.com>
	<19995.8804.939482.9336@morden.metzler>
Date: Mon, 11 Jul 2011 12:27:42 -0400
Message-ID: <CAGoCfizQhU10ECyHwcdY+T6=66-KcPxRL-j_w3ELHpK=6+wwdg@mail.gmail.com>
Subject: Re: [PATCH 00/16] New drivers: DRX-K, TDA18271c2, Updates: CXD2099
 and ngene
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Oliver Endriss <o.endriss@gmx.de>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Krufky <mkrufky@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi Ralph,

Good to hear from you.

> AFAIR, there were at least 2 reasons.
> One was that the existing driver does not accept 2 (or even 4) tuners with the
> same address (but behind different demods) on the same I2C bus which
> is the case on duoflex C/T addon cards.

Do you mean that you are relying solely on the i2c gates on the
"other" demods being closed so that the tuners associated with the
other inputs do not receive the commands?  If so, that would
definitely create the need for some weird locking structure (since
today demods typically do not manage their i2c gates in tandem).

> The other was that it does not give back the intermediate frequency
> which the demod needs. (This is currently done by misusing
> get_frequency() but I added a get_if() call in newer internal versions
> which should be added to dvb-core/dvb_frontend.h)

Generally speaking with other devices the IF is configured for the
tuner depending on the target modulation (there is a tda18271_config
struct passed at attach time containing the IF for various modes).
Then the demod driver is also configured for a particular IF.

Are you changing the IF based on something other than the target
modulation type?  Or do you need to vary the IF based on different
frequencies within the same modulation?

> Feel free to change ngene/ddbridge to use the existing driver but it
> will need some major changes in tda18271_attach() and a few other places.

If there are indeed good reasons, then so be it.  But it feels like we
are working around deficiencies in the core DVB framework that would
apply to all drivers, and it would be good if we could avoid the
maintenance headaches associated with two different drivers for the
same chip.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
