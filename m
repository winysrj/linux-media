Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38431 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbaK2UuS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Nov 2014 15:50:18 -0500
Date: Sat, 29 Nov 2014 18:50:12 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: David Liontooth <lionteeth@cogweb.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: ISDB caption support
Message-ID: <20141129185012.714473bc@recife.lan>
In-Reply-To: <5479F19A.9000408@cogweb.net>
References: <5478D31E.5000402@cogweb.net>
	<CAGoCfizK4kN5QnmFs_trAk2w3xuSVtXYVF2wSmdXDazxbhk=yQ@mail.gmail.com>
	<547934E1.3050609@cogweb.net>
	<CAGoCfix11OiF5_kojJ4jKZadz3XYdYJccPGtivtzDepFfn4Rnw@mail.gmail.com>
	<20141129090408.1b52c9ea@recife.lan>
	<5479F19A.9000408@cogweb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI David,

Em Sat, 29 Nov 2014 08:17:30 -0800
David Liontooth <lionteeth@cogweb.net> escreveu:

> 
> Hi Mauro,
> 
> Thank you; that's extremely helpful. We are looking into how much work it will be to write an ISDB-Tb captioning decoder for CCExtractor.
> 
> Can we find a list of television capture hardware devices known to work in Brazil? Our friends in Rio are new to all this, and
> 
>        linux/Documentation/dvb# grep -i ISDB *
> 
> finds nothing. I'm aware of Linux TV's list of ISDB resources, but they don't specify ISDB subtype (ISDB-Tb) -- are they interchangeable?

Yes, the demod here is the same as the ones used in Japan. The only
difference is that the devices sold in Japan has the additional crypto
modules.

There are drivers that supports ISDB-T:

$ git grep -l SYS_ISDBT|grep -v tuners
Documentation/DocBook/media/dvb/dvbproperty.xml
drivers/media/common/siano/smsdvb-main.c
drivers/media/dvb-core/dvb_frontend.c
drivers/media/dvb-frontends/dib0070.c
drivers/media/dvb-frontends/dib0090.c
drivers/media/dvb-frontends/dib8000.c
drivers/media/dvb-frontends/mb86a20s.c
drivers/media/dvb-frontends/s921.c
drivers/media/dvb-frontends/tc90522.c
drivers/media/pci/pt1/va1j5jf8007t.c
drivers/media/pci/pt3/pt3.c
drivers/media/usb/dvb-usb/friio-fe.c
include/uapi/linux/dvb/frontend.h

I never found any PT1 or PT3 devices here. The friio is also sold
only in Japan, afaikt. The devices based on s921 are really crap
(and only 1seg).

So, basically the devices supported are based on either one of
those demods:
	Dibcom 80xx
	Toshiba mb86a20s
	Siano Rio

I suspect that the easier ones to find nowadays are the PixelView ones
that are based on cx231xx/mb86a20s:
	PixelView PlayTV USB 2.0 SBTVD Full-Seg - PV-D231U(RN)-F

Not the best ISDB-T chip, but it works if they have a good antenna.
There are other devices too, but the brand names change a lot, and,
as I didn't buy or received any new isdb-t devices those days, I'm
unsure what other devices have inside.

If your friends want, they could ping me back and I can try to help
them to find some devices.

With regards to CC decoding, IMHO, the best would be to add a parser
for ISDB CC at libdvbv5.

Regards,
