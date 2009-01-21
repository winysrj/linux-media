Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:50967 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752273AbZAUCe7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2009 21:34:59 -0500
Subject: Re: [linux-dvb] Terratec XS HD support?
From: hermann pitton <hermann-pitton@arcor.de>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: linux-media@vger.kernel.org,
	DVB mailin' list thingy <linux-dvb@linuxtv.org>,
	em28xx@mcentral.de
In-Reply-To: <d9def9db0901201826j7bef2232s6ad12b7ff081ece3@mail.gmail.com>
References: <496C9FDE.2040408@hemmail.se>
	 <d9def9db0901131101y59cd5c1ct2344052f86b42feb@mail.gmail.com>
	 <d9def9db0901151028k6ab8bd79q6627c7516020aabe@mail.gmail.com>
	 <alpine.DEB.2.00.0901171037230.18169@ybpnyubfg.ybpnyqbznva>
	 <d9def9db0901170216g5be0ed16sa1eeb4c4f9acce76@mail.gmail.com>
	 <1232503628.2685.5.camel@pc10.localdom.local>
	 <d9def9db0901201826j7bef2232s6ad12b7ff081ece3@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 03:35:28 +0100
Message-Id: <1232505328.2685.9.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Mittwoch, den 21.01.2009, 03:26 +0100 schrieb Markus Rechberger:
> On Wed, Jan 21, 2009 at 3:07 AM, hermann pitton <hermann-pitton@arcor.de> wrote:
> >
> > Am Samstag, den 17.01.2009, 11:16 +0100 schrieb Markus Rechberger:
> >> On Sat, Jan 17, 2009 at 10:57 AM, BOUWSMA Barry
> >> <freebeer.bouwsma@gmail.com> wrote:
> >> > Hi Markus, I follow your list as a non-subscriber, but I thought
> >> > it would be worthwhile to post this to linux-dvb as well, and
> >> > eventually to linux-media...
> >> >
> >> > On Thu, 15 Jan 2009, Markus Rechberger wrote:
> >> >
> >> >> On Tue, Jan 13, 2009 at 8:01 PM, Markus Rechberger
> >> >> <mrechberger@gmail.com> wrote:
> >> >
> >> >> >> Is there any news about Terratec HTC USB XS HD support?
> >> >
> >> >> > it's upcoming soon.
> >> >
> >> > Thanks Markus, that's good news for me, and for several people
> >> > who have written me as well!
> >> >
> >> >
> >> >> http://mcentral.de/wiki/index.php5/Terratec_HTC_XS
> >> >> you might track that site for upcoming information.
> >> >
> >> > Interesting.  You say that your code will make use of a BSD
> >> > setup.  Can you or someone say something about this, or point
> >> > to past discussion which explains this?  Would this be the
> >> > userspace_tuner link on your wiki?
> >> >
> >> > In particular, I'm wondering whether this is completely
> >> > compatible with the standard DVB utilities -- dvbscan,
> >> > dvbstream, and the like, or whether a particular higher-
> >> > level end-user application is required.
> >> >
> >> >
> >>
> >> The design goes hand in hand with some discussions that have been made
> >> with some BSD developers.
> >> The setup makes use of usbdevfs and pci configspace access from
> >> userland, some work still has to be done there, it (will give/gives)
> >> manufacturers the freedom to release opensource and binary drivers for
> >> userland.
> >> I'm a friend of open development and not of some kind of monopoly
> >> where a few people rule everything (linux).
> >
> > I do remember when BSD shared some tuner code with GNU/LINUX ;)
> >
> 
> there is nothing wrong with that.
> 
> As a reference:
> * http://mcentral.de/wiki/index.php5/Terratec_HTC_XS
> * http://corona.homeunix.net/cx88wiki
> 
> regards,
> Markus

Without following your links for now,
for the code exchange during the last six years with what you claim,

there must be something very, very wrong.

cheers,
hermann


