Return-path: <mchehab@pedra>
Received: from keetweej.vanheusden.com ([83.163.219.98]:57957 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458Ab0HJLXB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Aug 2010 07:23:01 -0400
Date: Tue, 10 Aug 2010 13:22:59 +0200
From: folkert <folkert@vanheusden.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Pinnacle Systems, Inc. PCTV 330e & 2.6.34 &
	/dev/dvb
Message-ID: <20100810112258.GK6126@belle.intranet.vanheusden.com>
References: <20100809133252.GW6126@belle.intranet.vanheusden.com> <AANLkTimtHwW_PQ1vNQVaMKXXYdyVroZzwAfomu+Yw02C@mail.gmail.com> <20100809143550.GZ6126@belle.intranet.vanheusden.com> <AANLkTinJbdrHQPk9mudEAPtB7L_S11hS_ArX+DDsnBD6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinJbdrHQPk9mudEAPtB7L_S11hS_ArX+DDsnBD6@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

> >> > I have a:
> >> > Bus 001 Device 006: ID 2304:0226 Pinnacle Systems, Inc. PCTV 330e
> >> > inserted in a system with kernel 2.6.34.
> >>
> >> The PCTV 330e support for digital hasn't been merged upstream yet.
> >> See here:
> >> http://www.kernellabs.com/blog/?cat=35
> >
> > Does that mean teletext won't work either?
> 
> Teletext support is completely different that digital (DVB) support.
> VBI support (including teletext) was added to the in-kernel em28xx
> driver back in January.

That'll be the analogue interface probably? e.g. /dev/vbi0
Because a.f.a.i.k. the dvb interface is /dev/dvb/adapter0/demux0 ?


Folkert van Heusden

-- 
Ever wonder what is out there? Any alien races? Then please support
the seti@home project: setiathome.ssl.berkeley.edu
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
