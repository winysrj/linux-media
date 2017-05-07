Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35973 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbdEGXLR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 7 May 2017 19:11:17 -0400
Received: by mail-wm0-f68.google.com with SMTP id u65so11858303wmu.3
        for <linux-media@vger.kernel.org>; Sun, 07 May 2017 16:11:17 -0700 (PDT)
Date: Sun, 7 May 2017 17:42:12 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org
Cc: liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi
Subject: Re: [PATCH v3 00/13] stv0367/ddbridge: support CTv6/FlexCT hardware
Message-ID: <20170507174212.2e45ab71@audiostation.wuest.de>
In-Reply-To: <20170412212327.5b75be19@macbox>
References: <20170329164313.14636-1-d.scheller.oss@gmail.com>
        <20170412212327.5b75be19@macbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Wed, 12 Apr 2017 21:23:27 +0200
schrieb Daniel Scheller <d.scheller.oss@gmail.com>:

> Am Wed, 29 Mar 2017 18:43:00 +0200
> schrieb Daniel Scheller <d.scheller.oss@gmail.com>:
>=20
> > From: Daniel Scheller <d.scheller@gmx.net>
> >=20
> > Third iteration of the DD CineCTv6/FlexCT support patches with
> > mostly all things cleaned up that popped up so far. Obsoletes V1
> > and V2 series.
> >=20
> > These patches enhance the functionality of dvb-frontends/stv0367 to
> > work with Digital Devices hardware driven by the ST STV0367
> > demodulator chip and adds probe & attach bits to ddbridge to make
> > use of them, effectively enabling full support for CineCTv6 PCIe
> > bridges and (older) DuoFlex CT addon modules. =20
>=20
> Since V1 was sent over five weeks ago: Ping? Anyone? I'd really like
> to get this upstreamed.

Don't want to sound impatient, but V1 nears nine weeks, so: Second Ping.

=46rom what I can see, the two affected drivers aren't (at least)
actively maintained anymore, or maintainers may be MIA. So: Mauro, mind
having a look if you've got some spare time?

Thanks & best regards,
Daniel
