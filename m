Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f20.google.com ([209.85.220.20]:58764 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbZBPHnz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 02:43:55 -0500
Received: by fxm13 with SMTP id 13so5397450fxm.13
        for <linux-media@vger.kernel.org>; Sun, 15 Feb 2009 23:43:52 -0800 (PST)
Date: Mon, 16 Feb 2009 08:43:32 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Andrea Venturi <a.venturi@avalpa.com>
cc: linux-media@vger.kernel.org
Subject: Re: TS sample from freeview, anyone?
In-Reply-To: <499165F4.6080405@avalpa.com>
Message-ID: <alpine.DEB.2.01.0902101822100.30427@ybpnyubfg.ybpnyqbznva>
References: <498C02BE.9010004@avalpa.com> <alpine.DEB.2.01.0902100948270.1147@ybpnyubfg.ybpnyqbznva> <499165F4.6080405@avalpa.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ciao Andrea,

On Tue, 10 Feb 2009, Andrea Venturi wrote:

> > > i'm looking for a full TS sample of a freeview mheg RedButton
> > > transmission.

> > How much are you looking for -- in other words, do you need
> > the full service including video that a RedButton service

> i'd like to have a couple of minute of a full TS from Freeview, to give a
> quick glance to Red button service.

I will guess that as you are replying to this message, you
did not receive any reply from someone in the UK with
access to Freeview  :-)


I am myself not in the UK, and so I cannot help you with a
stream of one or more Freeview Muxen; also, I do not know
the details about Red Button via Freeview there, or such
details as `channels 301 and 302' which I must translate
in my head into the satellite equivalents which I receive.

However, if my experience is enough, Freesat has given
me the `quick glance' I needed to see that Red Button
exists, and that I can receive it, and, other than that,
I'm not impressed -- but it works, and that's the
important thing!


I should first point you to (if you do not already know)
the programs:
redbutton-download  and
redbutton-browser
(which I think are on sourceforge).  These were written
for Freeview (DVB-T) and did not work via sat until the
launch of Freesat; then they worked automagically for me  :-)


> > dish in Zuerich long before I was aware of the spotbeam.
> >   
> i know that i could try freesat albeit has a tight footprint, but i just have
> a fixed dish toward 13 east

Actually, Freesat itself consists of both services on the
tight Astra2D footprint, consisting of the BBC television
services, plus the other commercial/PSB broadcasters, as
well as services which can be received easily throughout
Europe on Eurobird or a different Astra satellite.  But
the Red Button services are limited, as far as I know, to
the BBC UK television and radio services, and perhaps some
of the other PSB broadcasters -- most of which are on the
UK spotbeam.

Of course, this does not help if you only have one dish,
but it does give you an alternative if nobody can send you
the full transport stream you wish  ;-)


> > However, the BBC radio services are on a pan-european beam

> is there really MHEG over the BBC radio service?

Yes, but...  I have probably confused you by the difference
between the domestic BBC UK services, and those of BBC
Worldwide or the World Service...

A selection of the BBC UK radio services, just as the
television programmes, are broadcast at 28E2.  While the
latter TV programmes are sent via Astra 2D on a spotbeam
tightly focussed on the UK, the radio services (Radio 1,
2, 3, 4 and family, plus 6music and Radio 7) are at 28E
at -- if I remember -- 11953MHz, which can be received
throughout most of Europe -- that is, if you have a dish
you can aim towards 28E...

These services, plus Radio London, and several others in
different languages, do carry a minimal MHEG service, and
I've been able to see that with `redbutton-browser', but
it's pretty much the station logo, some information about
the present programme, and similar fluff.  Which is why
I've said, woo, I can see it, now back to work...


> do you mean on these BBC "World service" at 13 degree?

No, none of the BBC programming directed at the Real
World (ooops, guess I can't immigrate into the UK now)
carry MHEG info, as far as I know.  That means, neither
the televisio World Service or BBC Prime (to move to 9E),
nor any of the many radio services on Hotbirds, which do
not include the domestic services (Radios 1 through 7).

So no, you will not see MHEG from the BBC on Hotbirds.

Unless I am wrong, but then, I think it would have long
since been public...  (this is a disclaimer, in case I
am wrong  :-)



First, an apology, in case I am writing at a level which is
too simple for you, and also in case I am writing about
things which you do not yet understand...


Anyway, what I see with `redbutton-download' are directories
with the MHEG data, which is transmitted in a cycle, so that
you will be receiving identical data after a short time...

beer@ralph:/usr/local/src/mini_dab$ ls -alrt /home/beer/carousels/
total 36
drwxr-xr-x  3 beer dialout   4096 Oct 14 04:08 3846
drwxr-xr-x  3 beer dialout   4096 Oct 14 04:08 3847
drwxr-xr-x  3 beer dialout   4096 Oct 14 04:45 3852
drwxr-xr-x  3 beer dialout   4096 Oct 14 05:36 3845

The directory structures under this are too much to show in
this mail, but I suspect these refer to four of the BBC
radio services on that day when I could not sleep and
decided to check out the radio MHEG services.


So, what I am trying to say, is that a snapshot of a
minute or two will give you the PIDs of the carousels
for the MHEG data on one particular multiplex, but it
will not give you the complete extent of possibilities
for additional services beyond digital teletext, which
includes the occasional trigger for ITV-HD or the varied
multiscreen offerings on Freesat, which require changing
to a different transponder for those services via sat.

Also, that you can receive -- with an extra dish --
at least some MHEG data for radio services, which will
deliver a constant stream for you to play with, rather
than just a minute or three.


barry bouwsma
