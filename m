Return-path: <linux-media-owner@vger.kernel.org>
Received: from rotring.dds.nl ([85.17.178.138]:45737 "EHLO rotring.dds.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbZCUVWn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Mar 2009 17:22:43 -0400
Subject: Re: [patch review] radio/Kconfig: introduce 3 groups: isa, pci,
 and others drivers
From: Alain Kalker <miki@dds.nl>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Alexey Klimov <klimov.linux@gmail.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	linux-media@vger.kernel.org
In-Reply-To: <1237670174.6280.55.camel@miki-desktop>
References: <1237467800.19717.37.camel@tux.localhost>
	 <20090319110303.7a53f9bb@pedra.chehab.org>
	 <208cbae30903190718l10911cc1j2a6f4f21b7f2b107@mail.gmail.com>
	 <20090319113903.7663ae71@pedra.chehab.org>
	 <Pine.LNX.4.58.0903191526120.28292@shell2.speakeasy.net>
	 <1237669890.6280.51.camel@miki-desktop>
	 <1237670174.6280.55.camel@miki-desktop>
Content-Type: text/plain
Date: Sat, 21 Mar 2009 22:22:36 +0100
Message-Id: <1237670556.6280.57.camel@miki-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op zaterdag 21-03-2009 om 22:16 uur [tijdzone +0100], schreef Alain
Kalker:

Starting out from 'allmodconfig',
> > Pruning (deselecting) all principal modules (i.e. those that actually
> > provide modaliases) for devices that we don't want, and then pruning all
> > of their dependencies that have now become redundant (i.e. modules that
> > have nothing or only unselected modules depending on them) seems decent
> > enough to me.

Sorry for the multiple refinement replies :-)

> > Kind regards,
> > 
> > Alain

