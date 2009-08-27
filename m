Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33162 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbZH0V64 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 17:58:56 -0400
Date: Thu, 27 Aug 2009 18:58:53 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Ville =?ISO-8859-1?B?U3lyauRs5A==?= <syrjala@sci.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Input <linux-input@vger.kernel.org>
Subject: Re: [RFC] Infrared Keycode standardization
Message-ID: <20090827185853.0aa2de76@pedra.chehab.org>
In-Reply-To: <20090827183636.GG26702@sci.fi>
References: <20090827045710.2d8a7010@pedra.chehab.org>
	<20090827183636.GG26702@sci.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 27 Aug 2009 21:36:36 +0300
Ville Syrjälä <syrjala@sci.fi> escreveu:


> I welcome this effort. It would be nice to have some kind of consistent
> behaviour between devices. But just limiting the effort to IR devices
> doesn't make sense. It shouldn't matter how the device is connected.

Agreed.

> 
> FASTWORWARD,REWIND,FORWARD and BACK aren't very clear. To me it would
> make most sense if FASTFORWARD and REWIND were paired and FORWARD and
> BACK were paired. I actually have those two a bit confused in
> ati_remote2 too where I used FASTFORWARD and BACK. I suppose it should
> be REWIND instead.

Makes sense. I updated it at the wiki. I also tried to group the keycodes by
function there.

> Also I should probably use ZOOM for the maximize/restore button (it's
> FRONT now), and maybe SETUP instead of ENTER for another. It has a
> picture of a checkbox, Windows software apparently shows a setup menu
> when it's pressed.
> 
> There are also a couple of buttons where no keycode really seems to
> match. One is the mouse button drag. I suppose I could implement the
> drag lock feature in the driver but I'm not sure if that's a good idea.
> It would make that button special and unmappable. Currently I have that
> mapped to EDIT IIRC.

I'm not sure what we should do with those buttons. 

Probably, the most complete IR spec is the RC5 codes:
	http://c6000.spectrumdigital.com/davincievm/revf/files/msp430/rc5_codes.pdf
(not sure if this table is complete or accurate, but on a search I did
today, this is the one that gave me a better documentation)

I suspect that, after solving the most used cases, we'll need to take a better look on it,
identifying the missing cases of the real implementations and add them to input.h.

> The other oddball button has a picture of a stopwatch (I think, it's
> not very clear). Currently it uses COFFEE, but maybe TIMER or something
> like that should be added. The Windows software's manual just say it
> toggles TV-on-demand, but I have no idea what that actually is.

Hmm... Maybe TV-on-demand is another name for pay-per-view?



Cheers,
Mauro
