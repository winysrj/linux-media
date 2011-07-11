Return-path: <mchehab@localhost>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:31544 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758057Ab1GKQSv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 12:18:51 -0400
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19995.8804.939482.9336@morden.metzler>
Date: Mon, 11 Jul 2011 18:18:44 +0200
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Oliver Endriss <o.endriss@gmx.de>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [PATCH 00/16] New drivers: DRX-K, TDA18271c2, Updates: CXD2099
 and ngene
In-Reply-To: <CAGoCfiwaYhXFi1_QXX55nfSOivgnk1YyDNP5_sXL61k3hdabQA@mail.gmail.com>
References: <201107031831.20378@orion.escape-edv.de>
	<CAGoCfiwaYhXFi1_QXX55nfSOivgnk1YyDNP5_sXL61k3hdabQA@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi Devin,

Devin Heitmueller writes:
 > On Sun, Jul 3, 2011 at 12:31 PM, Oliver Endriss <o.endriss@gmx.de> wrote:
 > > [PATCH 01/16] tda18271c2dd: Initial check-in
 > > [PATCH 02/16] tda18271c2dd: Lots of coding-style fixes
 > 
 > Oliver,
 > 
 > Why the new driver for the 18271c2?  There is already such a driver,
 > and in the past we've rejected multiple drivers for the same chip
 > unless there is a *very* compelling reason to do such.
 > 
 > The existing 18271 driver supports the C2 and is actively maintained.
 > 

AFAIR, there were at least 2 reasons.
One was that the existing driver does not accept 2 (or even 4) tuners with the
same address (but behind different demods) on the same I2C bus which
is the case on duoflex C/T addon cards.
The other was that it does not give back the intermediate frequency
which the demod needs. (This is currently done by misusing
get_frequency() but I added a get_if() call in newer internal versions
which should be added to dvb-core/dvb_frontend.h)
Feel free to change ngene/ddbridge to use the existing driver but it
will need some major changes in tda18271_attach() and a few other places.


Regards,
Ralph




