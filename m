Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51101 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbZH2Spg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2009 14:45:36 -0400
Date: Sat, 29 Aug 2009 15:45:28 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Patrick Boettcher <pboettcher@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Ville =?ISO-8859-1?B?U3lyauRs5A==?= <syrjala@sci.fi>,
	Linux Input <linux-input@vger.kernel.org>
Subject: Re: [RFC] Infrared Keycode standardization
Message-ID: <20090829154528.74cd98da@pedra.chehab.org>
In-Reply-To: <20090828093042.3cf3c770@pedra.chehab.org>
References: <20090827045710.2d8a7010@pedra.chehab.org>
	<20090827183636.GG26702@sci.fi>
	<20090827185853.0aa2de76@pedra.chehab.org>
	<829197380908271506i251b47caoe8c08d483e78e938@mail.gmail.com>
	<20090828004628.06f34d12@pedra.chehab.org>
	<20090828041459.67c1499a@pedra.chehab.org>
	<alpine.LRH.1.10.0908281150120.10085@pub6.ifh.de>
	<20090828093042.3cf3c770@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 28 Aug 2009 09:30:42 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:

> Em Fri, 28 Aug 2009 12:50:27 +0200 (CEST)
> Patrick Boettcher <pboettcher@kernellabs.com> escreveu:
> 
> > Hi Mauro,
> > 
> > On Fri, 28 Aug 2009, Mauro Carvalho Chehab wrote:
> > 
> > > Em Fri, 28 Aug 2009 00:46:28 -0300
> > > Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:
> > >
> > >> So, we need a sort of TODO list for IR changes. A start point (on a random
> > >> order) would be something like:
> > >>
> > >> 2) Implement a v4l handler for EVIOCGKEYCODE/EVIOCSKEYCODE;
> > >> 3) use a different arrangement for IR tables to not spend 16 K for IR table,
> > >> yet allowing RC5 full table;
> > >> 4) Use the common IR framework at the dvb drivers with their own iplementation;
> > >> 5) Allow getkeycode/setkeycode to work with the dvb framework using the new
> > >> methods;
> > >
> > > Ok, I have a code that handles the above for dvb-usb. Se enclosed. It turned to be
> > > simpler than what I've expected originally ;)
> > 
> > Yeah, this is due to the nature of modularity of dvb-usb. 
> 
> Yes, but I was afraid that we would need to use a different struct for IR's.
> This feature is already available for years at V4L, but the tables needed to
> use scancode as their indexes to use the default handlers (I'm not sure, but
> afaik, in the past there weren't ways to override them).
> 
> > Saying that, all 
> > drivers which have (re)implemented IR-handling needs to ported as well. Or 
> > included in dvb-usb :P .
> 
> My suggestion is to port the current implementation to ir-common.ko. This
> module is not dependent of any other V4L or DVB specifics and has already
> some code to handle GPIO polling based and GPIO IRQ based IR's. It contains
> some IR tables for IR's that are used also on dvb-usb, like Hauppauge IR
> keycodes.
> 
> Yet, we will need first to change ir-common.ko, since it is currently using the
> tables indexed by a 7bit scancode (due to size constraints, V4L code discards
> one RC5 byte), but this is already on our todo list (due to keycode
> standardization).

Ok, I've did several changes on both V4L and dvb-usb IR implementations. They
scancode tables are now implemented at the same way, at:
	http://linuxtv.org/hg/~mchehab/IR

I've also added there the current version of the getkeycode/setkeycode patch.

Ah, the v4l2-apps/util/Makefile will now generate the scancode userspace tables
for DVB IR's as well (currently, we have 85 IR layouts generated from source files).

What's still missing:

- For now, V4L is still using internally the old decoding process, based on the
7bit array of keycode.

- I haven't yet added some extra empty data at dvb scancode tables;

- although they're using the same structs, the code is still different.

Please review.



Cheers,
Mauro
