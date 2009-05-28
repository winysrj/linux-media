Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:56370 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbZE1ExX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 May 2009 00:53:23 -0400
Received: by fxm12 with SMTP id 12so3417679fxm.37
        for <linux-media@vger.kernel.org>; Wed, 27 May 2009 21:53:23 -0700 (PDT)
Date: Thu, 28 May 2009 14:54:16 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Hartmut Hackmann <hartmut.hackmann@t-online.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: Re: [PATCH 3/3 ] big rework of TS for saa7134
Message-ID: <20090528145416.50eda8da@glory.loctelecom.ru>
In-Reply-To: <1242162153.3749.20.camel@pc07.localdom.local>
References: <20090428195200.69d103e7@glory.loctelecom.ru>
	<20090511193705.0e06fac8@pedra.chehab.org>
	<1242082536.11527.4.camel@pc07.localdom.local>
	<20090511202123.383c8300@glory.loctelecom.ru>
	<20090511215456.2fe38980@pedra.chehab.org>
	<20090511210107.1eafb364@glory.loctelecom.ru>
	<1242162153.3749.20.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi 

> Hi,
> 
> Am Montag, den 11.05.2009, 21:01 +1000 schrieb Dmitri Belimov:
> > Hi 
> > 
> > > Em Mon, 11 May 2009 20:21:23 +1000
> > > Dmitri Belimov <d.belimov@gmail.com> escreveu:
> > > 
> > > > > > Cheers,
> > > > > > Mauro
> > > > > 
> > > > > Did you check it is still OK for DVB-T and DVB-S also?
> > > > 
> > > > No. We tested only with analog TV, capturing from analog TV and
> > > > composite input. It support serial and parallel TS from MPEG
> > > > encoder to saa7134.
> > > 
> > > Since the patch touched on saa7134-ts, it is important to check
> > > if it will not cause regressions with DVB. Could you please test
> > > it?
> > 
> > Ok. I'll do it with our customers. In my place hasn't any DVB
> > channels.
> 
> Dmitry, the patches from your RESEND don't apply anymore, since
> already two of your previous patches, still present in this set, are
> now in v4l-dvb.
> 
> I did apply manually. Also you did not run "make checkpatch" and I
> tried to fix a bunch of coding style errors and warnings from it.

Sorry. This is my error.
 
> Please review the attached version and consider to use it for a RESEND
> v2. More testers welcome, also for DVB serial TS and ATSC.
> 
> For DVB parallel TS.
> Tested-by: Hermann Pitton <hermann-pitton@arcor.de>

Our customer test this patch with our TV card and DVB-T, no any regression.
Today I'll resend this patch.

With my best regards, Dmitry.
