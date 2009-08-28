Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46430 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbZH1Dqf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 23:46:35 -0400
Date: Fri, 28 Aug 2009 00:46:28 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Ville =?ISO-8859-1?B?U3lyauRs5A==?= <syrjala@sci.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Input <linux-input@vger.kernel.org>
Subject: Re: [RFC] Infrared Keycode standardization
Message-ID: <20090828004628.06f34d12@pedra.chehab.org>
In-Reply-To: <829197380908271506i251b47caoe8c08d483e78e938@mail.gmail.com>
References: <20090827045710.2d8a7010@pedra.chehab.org>
	<20090827183636.GG26702@sci.fi>
	<20090827185853.0aa2de76@pedra.chehab.org>
	<829197380908271506i251b47caoe8c08d483e78e938@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 27 Aug 2009 18:06:51 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> Since we're on the topic of IR support, there are probably a couple of
> other things we may want to be thinking about if we plan on
> refactoring the API at all:
> 
> 1.  The fact that for RC5 remote controls, the tables in ir-keymaps.c
> only have the second byte.  In theory, they should have both bytes
> since the vendor byte helps prevents receiving spurious commands from
> unrelated remote controls.  We should include the ability to "ignore
> the vendor byte" so we can continue to support all the remotes
> currently in the ir-keymaps.c where we don't know what the vendor byte
> should contain.

This were done due to at least two reasons:

1) Several boards uses a few GPIO bits (in general 7 or less bits) for IR.
There's one logic at ir-common.ko to convert a 32 bits GPIO read into a 7 bits
scancode.

2) In order to properly support the default EVIOCGKEYCODE/EVIOCSKEYCODE
handlers, we need to have keycode table, where the scan code is the index. So,
if we use 14 bits for it, this means that this table would reserve 16384 bytes,
and will probably a very few of those bytes (on a IR with 64 keys, it would
need only 64 entries).

As it seems that there are some ways to replace the default
getkeycode/setkeycode handlers, I suspect that we can get rid of this limitation.

I'll do some tests here with a dib0700 and an em28xx devices.

> 2..  The fact that the current API provides no real way to change the
> mode of operation for the IR receiver, for those receivers that
> support multiple modes (NEC/RC5/RC6).  While you have the ability to
> change the mapping table from userland via the keytable program, there
> is currently no way to tell the IR receiver which mode to operate in.

In this case, we'll need to have a set of new ioctls at the event interface, to
allow enum/get/set the IR protocol type(s) per event device.

> One would argue that the above keymaps structure should include new
> fields to indicate what type of remote it is (NEC/RC5/RC6 etc), as
> well as field to indicate that the vendor codes are absent from the
> key mapping for that remote).  Given this, I can change the dib0700
> and em28xx IR receivers to automatically set the IR capture mode
> appropriate based on which remote is in the device profile.

Let's go step by step. Adding the ability of dynamically change the type of
remote will likely cause major changes at the GPIO polling code, since we'll
need to move some code from bttv and saa7134 into ir-functions.c and rework on
it. We'll probably end by converting the remaining polling code to use high
precision timers as we've done with cx88.

So, we need a sort of TODO list for IR changes. A start point (on a random
order) would be something like:

1) Standardize the keycodes;
2) Implement a v4l handler for EVIOCGKEYCODE/EVIOCSKEYCODE;
3) use a different arrangement for IR tables to not spend 16 K for IR table,
yet allowing RC5 full table;
4) Use the common IR framework at the dvb drivers with their own iplementation;
5) Allow getkeycode/setkeycode to work with the dvb framework using the new
methods;
6) implement new event ioctls (EVIOEPROTO/EVIOGPROTO/EVIOSPROTO ?), to allow
enumerating/getting/setting the IR protocol types;
7) Change the non-gpio drivers to support IR protocol type;
8) Create a gpio handler that supports changing the protocol type;
9) Migrate the remaining drivers to the new gpio handler methods;
10) Merge pertinent lirc drivers;
11) Add missing keys at input.h.



Cheers,
Mauro
