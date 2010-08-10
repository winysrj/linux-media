Return-path: <mchehab@pedra>
Received: from keetweej.vanheusden.com ([83.163.219.98]:51049 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab0HJMWQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Aug 2010 08:22:16 -0400
Date: Tue, 10 Aug 2010 14:22:14 +0200
From: folkert <folkert@vanheusden.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Pinnacle Systems, Inc. PCTV 330e & 2.6.34 &
	/dev/dvb
Message-ID: <20100810122214.GN6126@belle.intranet.vanheusden.com>
References: <20100809133252.GW6126@belle.intranet.vanheusden.com> <AANLkTimtHwW_PQ1vNQVaMKXXYdyVroZzwAfomu+Yw02C@mail.gmail.com> <20100809143550.GZ6126@belle.intranet.vanheusden.com> <AANLkTinJbdrHQPk9mudEAPtB7L_S11hS_ArX+DDsnBD6@mail.gmail.com> <20100810112258.GK6126@belle.intranet.vanheusden.com> <AANLkTin-eXj-78iDkU=FYTiuzRH1_qwRwYQskO2=g19B@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin-eXj-78iDkU=FYTiuzRH1_qwRwYQskO2=g19B@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

> >> Teletext support is completely different that digital (DVB) support.
> >> VBI support (including teletext) was added to the in-kernel em28xx
> >> driver back in January.
> >
> > That'll be the analogue interface probably? e.g. /dev/vbi0
> > Because a.f.a.i.k. the dvb interface is /dev/dvb/adapter0/demux0 ?
> 
> Yes, VBI is an analog interface, and the teletext is provided via /dev/vbi0.

Ok. Right as we speak I'm compiling the driver from the url you
mentioned. I'll keep the list posted about the results.


Folkert van Heusden

-- 
www.vanheusden.com/multitail - multitail is tail on steroids. multiple
               windows, filtering, coloring, anything you can think of
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
