Return-path: <linux-media-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:24978 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbZBSTMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2009 14:12:40 -0500
Received: by mu-out-0910.google.com with SMTP id i10so398452mue.1
        for <linux-media@vger.kernel.org>; Thu, 19 Feb 2009 11:12:38 -0800 (PST)
Date: Thu, 19 Feb 2009 15:12:27 -0400
From: Manu <eallaud@gmail.com>
Subject: Re : Re : Re : Re : TT 3650
To: Faruk A <fa@elwak.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <20090218092217.232120@gmx.net>
	<20090218103353.64bf6400@free.fr> <1234961317.5755.0@manu-laptop>
	<20090218204455.19b867a0@free.fr> <1234999838.7508.0@manu-laptop>
	<20090219095109.7cbe2c49@free.fr> <1235040908.5940.0@manu-laptop>
	<854d46170902190640u3b39b5efw774be7b01e2044c6@mail.gmail.com>
In-Reply-To: <854d46170902190640u3b39b5efw774be7b01e2044c6@mail.gmail.com>
	(from fa@elwak.com on Thu Feb 19 10:40:42 2009)
Message-Id: <1235070747.12435.0@manu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 19.02.2009 10:40:42, Faruk A a écrit :
> On Thu, Feb 19, 2009 at 11:55 AM, Manu <eallaud@gmail.com> wrote:
> > Le 19.02.2009 04:51:09, Jean-Francois Moine a écrit :
> >> On Wed, 18 Feb 2009 19:30:37 -0400
> >> Manu <eallaud@gmail.com> wrote:
> >>
> >> > Le 18.02.2009 15:44:55, Jean-Francois Moine a écrit :
> >> > > Yes. I use it to look at FTA channels on AB3 5°W:
> >> > >
> >> > > - France 24 (12674.00 H - DVB-S2 - QPSK) is good.
> >> > >
> >> > > - I can also get the transponder 11636.00 V (DVB Newtec -
> QPSK),
> >> but
> >> > > not
> >> > >   the transponder 11139.00 V (DVB Newtec - 8PSK turbo)
> >> > >
> >> > > - For some time, there were clear channels (M6 and W9) in the
> >> > >   transponder 11471.00 V (DVB-S2 - 8PSK). Both were fine.
> >> >
> >> > Just to make things clear, can you prodvide symbol rate and FEC
> for
> >> > all these transponders.
> >>
> >> I don't understand the question!
> >>
> >> I think the symbol rate is mandatory, but the FEC may found
> >> automatically. For example, I use vlc for the 2 different
> >> transponders:
> >>
> >> #EXTINF:0,orange
> >> #EXTVLCOPT:dvb-frequency=11512000
> >> #EXTVLCOPT:dvb-srate=29947000
> >> #EXTVLCOPT:dvb-voltage=13
> >> dvb://
> >> #EXTINF:0,france
> >> #EXTVLCOPT:dvb-frequency=11590000
> >> #EXTVLCOPT:dvb-srate=20000000
> >> #EXTVLCOPT:dvb-voltage=13
> >> dvb://
> >>
> >> The first transponder is FEC 7/8, and the second 2/3.
> >>
> >> For the other transponders (DVB-S2 / 8PSK), if use szap-s2 +
> >> dvbstream.
> >
> > OK great thx, that's what I was asking for! Indeed I have some
> troubles
> > locking on S2 transponders which all have 30 MS/s rate. I see that
> > yours are lower, well with one very close to that.
> > Bye
> > Emmanuel
> 
> Hi Manu!
> 
> I use to own this card until it broke and replaced with TeVii S650.
> It used to lock just fine on this Transponders. Although i can't
> receive from this satellite
> anymore my dish has been realigned to 16E instead.
> 
> Thor 1W
> 12015 H 30000-3/4
> 12130 H 30000-3/4
> 
> Faruk
> 

Thx, can you tell me with which driver (repo and date if possible).
Thx
Bye
Emmanuel

