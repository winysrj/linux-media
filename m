Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46007 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbZH1Mas (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2009 08:30:48 -0400
Date: Fri, 28 Aug 2009 09:30:42 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Ville =?ISO-8859-1?B?U3lyauRs?= =?ISO-8859-1?B?5A==?=
	<syrjala@sci.fi>, Linux Input <linux-input@vger.kernel.org>
Subject: Re: [RFC] Infrared Keycode standardization
Message-ID: <20090828093042.3cf3c770@pedra.chehab.org>
In-Reply-To: <alpine.LRH.1.10.0908281150120.10085@pub6.ifh.de>
References: <20090827045710.2d8a7010@pedra.chehab.org>
	<20090827183636.GG26702@sci.fi>
	<20090827185853.0aa2de76@pedra.chehab.org>
	<829197380908271506i251b47caoe8c08d483e78e938@mail.gmail.com>
	<20090828004628.06f34d12@pedra.chehab.org>
	<20090828041459.67c1499a@pedra.chehab.org>
	<alpine.LRH.1.10.0908281150120.10085@pub6.ifh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 28 Aug 2009 12:50:27 +0200 (CEST)
Patrick Boettcher <pboettcher@kernellabs.com> escreveu:

> Hi Mauro,
> 
> On Fri, 28 Aug 2009, Mauro Carvalho Chehab wrote:
> 
> > Em Fri, 28 Aug 2009 00:46:28 -0300
> > Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:
> >
> >> So, we need a sort of TODO list for IR changes. A start point (on a random
> >> order) would be something like:
> >>
> >> 2) Implement a v4l handler for EVIOCGKEYCODE/EVIOCSKEYCODE;
> >> 3) use a different arrangement for IR tables to not spend 16 K for IR table,
> >> yet allowing RC5 full table;
> >> 4) Use the common IR framework at the dvb drivers with their own iplementation;
> >> 5) Allow getkeycode/setkeycode to work with the dvb framework using the new
> >> methods;
> >
> > Ok, I have a code that handles the above for dvb-usb. Se enclosed. It turned to be
> > simpler than what I've expected originally ;)
> 
> Yeah, this is due to the nature of modularity of dvb-usb. 

Yes, but I was afraid that we would need to use a different struct for IR's.
This feature is already available for years at V4L, but the tables needed to
use scancode as their indexes to use the default handlers (I'm not sure, but
afaik, in the past there weren't ways to override them).

> Saying that, all 
> drivers which have (re)implemented IR-handling needs to ported as well. Or 
> included in dvb-usb :P .

My suggestion is to port the current implementation to ir-common.ko. This
module is not dependent of any other V4L or DVB specifics and has already
some code to handle GPIO polling based and GPIO IRQ based IR's. It contains
some IR tables for IR's that are used also on dvb-usb, like Hauppauge IR
keycodes.

Yet, we will need first to change ir-common.ko, since it is currently using the
tables indexed by a 7bit scancode (due to size constraints, V4L code discards
one RC5 byte), but this is already on our todo list (due to keycode
standardization).

> > Tested with kernel 2.6.30.3 and a dibcom device.
> >
> > While this patch works fine, for now, it is just a proof of concept, since there are a few
> > details to be decided/solved for a version 2, as described bellow.
> 
> This is the answer to the question I had several times in the past years.
> 
> Very good job. It will solve the memory waste in the driver for 
> key-tables filled up with keys for different remotes where the user of 
> one board only has one. The code will also be smaller and easier to read.
> 
> This also allows the user to use any remote with any (sensitive) 
> ir-sensor in a USB device.

True.

> Is there a feature in 'input' which allows to request a file (like 
> request_firmware)? This would be ideal for a transition from 
> in-kernel-keymaps to user-space-keymap-loading: By default it would 
> request the file corresponding to the remote delivered with the device.
> 
> Is that possible somehow?

There's nothing that I'm aware of, but I suspect that it shouldn't be hard to do it
via udev. 

We'll need to do some work there, in order to be sure that each V4L and DVB
device will have their own unique IR board ID's. We may then do an application
based on  v4l2-apps/util/keytable that will use the IR board ID to 
dynamically load the keytable, with a default config of loading the board's own
IR, but allowing the user to replace it by a custom one.

Currently, the Makefile at v4l2-apps/util creates a directory (keycodes) that
contains lots of IR tables. It does it by parsing the existing IR tables at V4L
side. After having all tables looking the same, it won't be hard to change it
to parse all MCE tables, creating an updated repository of the existing
scancode/keycode association.



Cheers,
Mauro
