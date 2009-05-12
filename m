Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39962 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868AbZELAzD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2009 20:55:03 -0400
Date: Mon, 11 May 2009 21:54:56 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Dmitri Belimov <d.belimov@gmail.com>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: Re: [PATCH 3/3 ] big rework of TS for saa7134
Message-ID: <20090511215456.2fe38980@pedra.chehab.org>
In-Reply-To: <20090511202123.383c8300@glory.loctelecom.ru>
References: <20090428195200.69d103e7@glory.loctelecom.ru>
	<20090511193705.0e06fac8@pedra.chehab.org>
	<1242082536.11527.4.camel@pc07.localdom.local>
	<20090511202123.383c8300@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 11 May 2009 20:21:23 +1000
Dmitri Belimov <d.belimov@gmail.com> escreveu:

> > > Cheers,
> > > Mauro
> > 
> > Did you check it is still OK for DVB-T and DVB-S also?
> 
> No. We tested only with analog TV, capturing from analog TV and composite input.
> It support serial and parallel TS from MPEG encoder to saa7134.

Since the patch touched on saa7134-ts, it is important to check if it will not
cause regressions with DVB. Could you please test it?
> 




Cheers,
Mauro
