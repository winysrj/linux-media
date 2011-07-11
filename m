Return-path: <mchehab@localhost>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:28434 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997Ab1GKRPn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 13:15:43 -0400
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19995.12215.798514.99100@morden.metzler>
Date: Mon, 11 Jul 2011 19:15:35 +0200
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Oliver Endriss <o.endriss@gmx.de>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [PATCH 00/16] New drivers: DRX-K, TDA18271c2, Updates: CXD2099
 and ngene
In-Reply-To: <CAGoCfizQhU10ECyHwcdY+T6=66-KcPxRL-j_w3ELHpK=6+wwdg@mail.gmail.com>
References: <201107031831.20378@orion.escape-edv.de>
	<CAGoCfiwaYhXFi1_QXX55nfSOivgnk1YyDNP5_sXL61k3hdabQA@mail.gmail.com>
	<19995.8804.939482.9336@morden.metzler>
	<CAGoCfizQhU10ECyHwcdY+T6=66-KcPxRL-j_w3ELHpK=6+wwdg@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Devin Heitmueller writes:
 > Hi Ralph,
 > 
 > Good to hear from you.
 > 
 > > AFAIR, there were at least 2 reasons.
 > > One was that the existing driver does not accept 2 (or even 4) tuners with the
 > > same address (but behind different demods) on the same I2C bus which
 > > is the case on duoflex C/T addon cards.
 > 
 > Do you mean that you are relying solely on the i2c gates on the
 > "other" demods being closed so that the tuners associated with the
 > other inputs do not receive the commands?  If so, that would
 > definitely create the need for some weird locking structure (since
 > today demods typically do not manage their i2c gates in tandem).

Yes, gate openings are locked against each other in the bridge drivers.


 > > The other was that it does not give back the intermediate frequency
 > > which the demod needs. (This is currently done by misusing
 > > get_frequency() but I added a get_if() call in newer internal versions
 > > which should be added to dvb-core/dvb_frontend.h)
 > 
 > Generally speaking with other devices the IF is configured for the
 > tuner depending on the target modulation (there is a tda18271_config
 > struct passed at attach time containing the IF for various modes).
 > Then the demod driver is also configured for a particular IF.

You mean the optional "struct tda18271_std_map *std_map;"?
That would be a possibility. But then you have to handle IF tables for
all kinds of tuners and demods in the bridge driver.
Letting the tuner choose the IF and have a way to tell the demod (a simple
get_if() call) is much easier.

 > Are you changing the IF based on something other than the target
 > modulation type?  Or do you need to vary the IF based on different
 > frequencies within the same modulation?

No.
 
 > > Feel free to change ngene/ddbridge to use the existing driver but it
 > > will need some major changes in tda18271_attach() and a few other places.
 > 
 > If there are indeed good reasons, then so be it.  But it feels like we
 > are working around deficiencies in the core DVB framework that would
 > apply to all drivers, and it would be good if we could avoid the
 > maintenance headaches associated with two different drivers for the
 > same chip.

I know. At the time I was also just porting the DRX-K and only wanted
to get it working based on the known to work Windows driver
combination and not wrestle with other problems.
I guess it whould not be too hard to adapt the old driver now.

Another problem that keeps showing up in the existing drivers is that
some tuner/demod combinations let the tuner call gate_ctrl, others
only call it in the demod.
This leads to problems when trying to use them in new combinations.
Either the gate is not opened/closed at all or twice. In the latter
case this can even lead to lockups if also using locking.

Regards,
Ralph


