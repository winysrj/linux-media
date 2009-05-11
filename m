Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f224.google.com ([209.85.219.224]:34921 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbZELAVI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2009 20:21:08 -0400
Received: by ewy24 with SMTP id 24so3864511ewy.37
        for <linux-media@vger.kernel.org>; Mon, 11 May 2009 17:21:07 -0700 (PDT)
Date: Mon, 11 May 2009 20:21:23 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: Re: [PATCH 3/3 ] big rework of TS for saa7134
Message-ID: <20090511202123.383c8300@glory.loctelecom.ru>
In-Reply-To: <1242082536.11527.4.camel@pc07.localdom.local>
References: <20090428195200.69d103e7@glory.loctelecom.ru>
	<20090511193705.0e06fac8@pedra.chehab.org>
	<1242082536.11527.4.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

> Hi,
> 
> Am Montag, den 11.05.2009, 19:37 -0300 schrieb Mauro Carvalho Chehab:
> > Em Tue, 28 Apr 2009 19:52:00 +1000
> > Dmitri Belimov <d.belimov@gmail.com> escreveu:
> > 
> > > Hi all.
> > > 
> > > 1. Add start/stop TS function.
> > > 2. Move setup DMA of TS to DMA function.
> > > 3. Write support cupture via MMAP
> > > 4. Rework startup and finish process, remove simple FSM.
> > > 
> > > This is patch from our customer. I checked this.
> > 
> > Dmitri,
> > 
> > Could you please re-send this patch, this time with your SOB?

Ok

> > Cheers,
> > Mauro
> 
> Did you check it is still OK for DVB-T and DVB-S also?

No. We tested only with analog TV, capturing from analog TV and composite input.
It support serial and parallel TS from MPEG encoder to saa7134.

> I did not yet and it is just a note and I hope to retire once.

Ok. It will be good.

With my best regards, Dmitry.

> Cheers,
> Hermann
> 
> 
> 
