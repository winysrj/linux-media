Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:60024 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760501AbZEKW4Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2009 18:56:16 -0400
Subject: Re: [PATCH 3/3 ] big rework of TS for saa7134
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Dmitri Belimov <d.belimov@gmail.com>, linux-media@vger.kernel.org,
	video4linux-list@redhat.com
In-Reply-To: <20090511193705.0e06fac8@pedra.chehab.org>
References: <20090428195200.69d103e7@glory.loctelecom.ru>
	 <20090511193705.0e06fac8@pedra.chehab.org>
Content-Type: text/plain
Date: Tue, 12 May 2009 00:55:36 +0200
Message-Id: <1242082536.11527.4.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Montag, den 11.05.2009, 19:37 -0300 schrieb Mauro Carvalho Chehab:
> Em Tue, 28 Apr 2009 19:52:00 +1000
> Dmitri Belimov <d.belimov@gmail.com> escreveu:
> 
> > Hi all.
> > 
> > 1. Add start/stop TS function.
> > 2. Move setup DMA of TS to DMA function.
> > 3. Write support cupture via MMAP
> > 4. Rework startup and finish process, remove simple FSM.
> > 
> > This is patch from our customer. I checked this.
> 
> Dmitri,
> 
> Could you please re-send this patch, this time with your SOB?
> 
> 
> 
> Cheers,
> Mauro

Did you check it is still OK for DVB-T and DVB-S also?

I did not yet and it is just a note and I hope to retire once.

Cheers,
Hermann



