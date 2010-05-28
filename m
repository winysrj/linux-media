Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:42913 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab0E1Hfg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 May 2010 03:35:36 -0400
Received: by fg-out-1718.google.com with SMTP id d23so331259fga.1
        for <linux-media@vger.kernel.org>; Fri, 28 May 2010 00:35:34 -0700 (PDT)
Date: Fri, 28 May 2010 09:35:31 +0200
From: Davor Emard <davoremard@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Compro videomate T750F DVB-T mode works now
Message-ID: <20100528073531.GC7710@lipa.lan>
References: <20100507235024.GA7470@z60m>
 <20100527141704.46d95f54@pedra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100527141704.46d95f54@pedra>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 27, 2010 at 02:17:04PM -0300, Mauro Carvalho Chehab wrote:
> Em Sat, 8 May 2010 01:50:24 +0200
> Emard <davoremard@gmail.com> escreveu:
> 
> > HI
> > 
> > ... tried to post this few times to thhis list I don't know if
> > it has made it maybe this time it will appear on the mailing list....
> > 
> > I have european version of Compro Videomate T750F Vista
> > hybrid dvb-t + tv (PAL) + FM card. In kernels up to date (2.6.33.3)
> > it didn't want to initialize in analog mode (tuner xc2028 always failed).
> > 
> > Here's sligthly adapted patch from
> > http://www.linuxtv.org/pipermail/linux-dvb/2008-May/025945.html
> > that works for me. It disables analog tuner xc2028 which doesn't
> > work (maybe because current driver is only for ntsc version of the
> > card) and enables digital tuner that consists of zarlink 10353 and
> > qt1010. Tested and works on kernel 2.6.33.3
> 
> xc2028 tuner driver supports PAL standards as well. If it is not working fine,
> it is probably because the GPIO's are wrong. You need to run REGSPY.EXE program,
> from DScaler project, to get the proper gpio values for your board.
> 
> Btw, please send your Signed-off-by: on your patches.
> > 
> > Best regards, Emard
> > 
> > --- linux-2.6.33.3/drivers/media/video/saa7134/saa7134-cards.c.orig	2010-05-02 00:06:45.000000000 +0200
> > +++ linux-2.6.33.3/drivers/media/video/saa7134/saa7134-cards.c	2010-05-02 01:20:50.000000000 +0200
> > @@ -4883,10 +4883,11 @@ struct saa7134_board saa7134_boards[] =
> >  		/* John Newbigin <jn@it.swin.edu.au> */
> >  		.name           = "Compro VideoMate T750",
> >  		.audio_clock    = 0x00187de7,
> > -		.tuner_type     = TUNER_XC2028,
> > +		.tuner_type     = TUNER_ABSENT,

HI!

Ignore this patch, this is early version that breaks analog part just
to get dvb-t working. 

I had posted improved patch (I called it v17, should be on this list as well) 
with early supports for both analog dvb-t and radio on 2.6.33.4 (also the remote, but the 
IR system had changed so we may fix remote later... but that's easy :). We
have another issues

Patch v17 which works on my case from cold reboot and at least first
time VDR is started. Subsequent restarts of VDR may prevent DVB-T tuner
from changing frequency - it stays and receives the previos frequency
at which VDR stopped. But sometimes after frew minutes VDR starts working
again tuning to different freq - strange behaviour really maybe it's not
only because of compro patch, could be firmware issue too)

While Samuel is testing this he had some positive results but so far but he needs 
to preinitialize the card with window$ before the firmware gets loaded :(.
I don't need this (anyway my motherboard removes PCI power for 2 seconds during 
restart so I even cannot try such intialization method)

Emard
