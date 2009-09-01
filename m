Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f175.google.com ([209.85.222.175]:59000 "EHLO
	mail-pz0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbZIABiJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 21:38:09 -0400
Date: Mon, 31 Aug 2009 18:38:08 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Patrick Boettcher <pboettcher@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <syrjala@sci.fi>,
	Linux Input <linux-input@vger.kernel.org>
Subject: Re: [RFC] Infrared Keycode standardization
References: <20090827045710.2d8a7010@pedra.chehab.org> <20090827183636.GG26702@sci.fi> <20090827185853.0aa2de76@pedra.chehab.org> <829197380908271506i251b47caoe8c08d483e78e938@mail.gmail.com> <20090828004628.06f34d12@pedra.chehab.org> <20090828041459.67c1499a@pedra.chehab.org> <alpine.LRH.1.10.0908281150120.10085@pub6.ifh.de> <20090828093042.3cf3c770@pedra.chehab.org> <20090829154528.74cd98da@pedra.chehab.org> <20090831024741.69fe587b@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831024741.69fe587b@pedra.chehab.org>
Message-Id: <20090901021047.3E0D2526EA5@mailhub.coreip.homeip.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

On Mon, Aug 31, 2009 at 02:47:41AM -0300, Mauro Carvalho Chehab wrote:
> Em Sat, 29 Aug 2009 15:45:28 -0300
> Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:
> 
> > Ok, I've did several changes on both V4L and dvb-usb IR implementations. They
> > scancode tables are now implemented at the same way, at:
> > 	http://linuxtv.org/hg/~mchehab/IR
> 
> Ok, I've also updated the V4L2 API spec with the default keyboard mapping on
> the above URL. If nobody complains, I'll update our development tree with the
> above changes likely today (Aug, 31) night, and prepare the changesets to be
> added at linux-next.
> 

I see that you changed from KEY_KP* to KEY_*, unfortunately this change
will break users who have digits in upper register. KEY_KP* were not
perfect either since they are affected by NumLock state. I would
recommend moving to KEY_NUMERIC_* which should be unaffected by either
register, shift state or NumLock state.

Of course there is an issue of them being absent from most keymaps; but
nothing is perfect in thsi world ;)

-- 
Dmitry
