Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:54349 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757199AbZAPWyb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Jan 2009 17:54:31 -0500
Subject: Re: Fw: [PATCH] E506r-composite-input
From: hermann pitton <hermann-pitton@arcor.de>
To: Tim Farrington <timf@iinet.net.au>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Tim Farrington <timf@iinet.au>, linux-media@vger.kernel.org
In-Reply-To: <49706EFE.2050804@iinet.net.au>
References: <20090115233528.7f458d34@pedra.chehab.org>
	 <1232102064.2695.12.camel@pc10.localdom.local>
	 <49706EFE.2050804@iinet.net.au>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 23:54:32 +0100
Message-Id: <1232146472.7588.23.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Freitag, den 16.01.2009, 20:26 +0900 schrieb Tim Farrington:
> hermann pitton wrote:
> > Hi,
> >
> > Am Donnerstag, den 15.01.2009, 23:35 -0200 schrieb Mauro Carvalho
> > Chehab:
> >   
> >> Message sent to the wrong address... it is not *-owner ;)
> >>
> >> Forwarded message:
> >>
> >> Date: Thu, 15 Jan 2009 21:58:55 +0900
> >> From: Tim Farrington <timf@iinet.net.au>
> >> To: Mauro Carvalho Chehab <mchehab@infradead.org>,
> >> linux-media-owner@vger.kernel.org
> >> Subject: [PATCH] E506r-composite-input
> >>
> >>
> >> Make correction to composite input plus svideo input
> >> to Avermedia E506R
> >>
> >> Signed-off-by: Tim Farrington timf@iinet.net.au
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >> Cheers,
> >> Mauro
> >>
> >>
> >>
> >>
> >>
> >>
> >>
> >> Unterschied
> >> zwischen
> >> Dateien-Anlage
> >> (E506r_composite.patch)
> >>
> >> Only in .: E506r_composite.patch
> >> diff
> >> -upr ./linux/drivers/media/video/saa7134/saa7134-cards.c ../a/v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c
> >> --- ./linux/drivers/media/video/saa7134/saa7134-cards.c 2009-01-15
> >> 21:42:05.000000000 +0900
> >> +++ ../a/v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c      2009-01-15 21:45:29.000000000 +0900
> >> @@ -4362,13 +4362,13 @@ struct saa7134_board saa7134_boards[] = 
> >>                          .amux = TV,
> >>                          .tv   = 1,
> >>                  }, {
> >> -                        .name = name_comp,
> >> -                        .vmux = 0,
> >> +                        .name = name_comp1,
> >> +                        .vmux = 3,
> >>                          .amux = LINE1,
> >>                  }, {
> >>                          .name = name_svideo,
> >>                          .vmux = 8,
> >> -                        .amux = LINE1,
> >> +                        .amux = LINE2,
> >>                  } },
> >>                  .radio = {
> >>                          .name = name_radio,
> >>
> >>     
> >
> > Mauro, I was never sure about why that patch, which introduced name_comp
> > was accepted very, very late in the drivers history. It previously
> > always started the enumeration with name_comp1.
> >
> > If it should have any sense at all, I thought it was to avoid ambiguity
> > on such devices which have only one Composite input.
> >
> > Tim, are you sure that Composite amux is LINE1 and S-Video LINE2?
> >
> > It would be the first and only card ever seen with different amux for
> > those inputs and should be noted as unusual case. I doubt it has two
> > different audio-in connectors.
> >
> > Cheers,
> > Hermann
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >   
> Hermann,
> For the record, Avermedia are well known for not respecting the GPL, and 
> finding ways to
> have as many different chip combinations on as many different cards as 
> they can,
> and as many different input configurations as they can invent.
> (Try looking at all the different chip combinations they use on all 
> their "Volar" sticks.)

At least they use unique PCI subsystem IDs these days.

> Avermedia make the E506R, which is a PCMCIA card.

Can remember when it for the first time appeared on the list ;)

> It has a FM Radio input, a DVB-T/Analog Television input and a Remote 
> Control.
> 
> It also has a mini-SCSI input, to which is connected an Audio Left 
> cable, an Audio Right cable, and a Composite Video cable;
> also separately connected to the SCSI is a S-Video input cable.

If you have a single left/right pair as analog audio in, how can it be
for Composite one the LINE1 input pair and for S-Video on the LINE2
input pair of the chip.

There is no gpio switching on an external audio mux visible for these
inputs in the card's entry.

The error is probably taken from the E500 cardbus or I simply don't
understand what should happen on that card with the external audio in.

Unless you confirm you have tested audio on both inputs you modified,
it looks for me like a bug is left.

I thought I did help to fix this on Markus tree already and there was
sound reported for s-video working on LINE1!

I know it have been hard times with this one, but yourself introduced
vmux 0 for Composite over S-Video and now you take it away again ...

Cheers,
Hermann

> Regards,
> Timf

