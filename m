Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:57840 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732450AbeKWCfq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 21:35:46 -0500
Date: Thu, 22 Nov 2018 13:55:39 -0200
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: stakanov <stakanov@eclipso.eu>, Takashi Iwai <tiwai@suse.de>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: DVB-S PCI card regression on 4.19 / 4.20
Message-ID: <20181122135539.158b3985@coco.lan>
In-Reply-To: <96849b97-3abb-b879-ed05-35bcd58b5e43@gmail.com>
References: <4e0356d6303c128a3e6d0bcc453ba1be@mail.eclipso.de>
        <20181120104217.5b487bcd@coco.lan>
        <1593929.t9Y74Rdlh1@roadrunner.suse>
        <20181120140855.29f5dc3f@coco.lan>
        <96849b97-3abb-b879-ed05-35bcd58b5e43@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 21 Nov 2018 21:20:35 +0000
Malcolm Priestley <tvboxspy@gmail.com> escreveu:

> On 20/11/2018 16:08, Mauro Carvalho Chehab wrote:
> > Em Tue, 20 Nov 2018 14:20:01 +0100  
> <snip>
> 
> > Ok. Now, min/max frequencies are at the same scale. For DVB-S, 
> > dvb_frontend_get_frequency_limits() returns both in kHz, so the frequency
> > range is now OK.
> > 
> > The tuning frequency is wrong through. 10,719,000 kHz - e. g. 10,719 MHz
> > seems to be the transponder frequency you're trying to tune, and not the
> > intermediate frequency used at the DVB-S board.
> > 
> > That sounds to me either a wrong LNBf setting or a bug at libdvbv5 or
> > at Kaffeine's side. What happens is that the typical European LNBFs are:
> > 
> > 1) the "old" universal one:
> > 
> > UNIVERSAL
> > 	Universal, Europe
> > 	Freqs     : 10800 to 11800 MHz, LO: 9750 MHz
> > 	Freqs     : 11600 to 12700 MHz, LO: 10600 MHz  
> I am pretty certain this type is obsolete it doesn't look right for 9750Mhz oscillator.
> 
> I am sure it was 10000Mhz or 96?? or something like that for old analogue transmissions of 
> 20 years ago

This is the first LNBf entry at dvb-tools. I'm pretty sure people
used it for years, but yeah, I won't doubt that this is an obsolete
entry.

Yet, people may still be using old antennas somewhere, so we can't
simply remove it or replace.

Maybe we could change its description to say that this is the
old universal standard.

> > 
> > 2) the "new" universal one, with seems to be used by most modern
> > satellite dishes in Europe nowadays:
> > 
> > EXTENDED
> > 	Astra 1E, European Universal Ku (extended)  
> This needs renaming as 1E has long gone.

Agreed.

> 
> Certainly this type is used for Astra 19.2 and 28.2.
> 
> Ideally we should use a default LNB type for each Satellite either in libdvbv5, Kaffeine or respective tables.

Neither libdvbv5 nor Kaffeine has a concept of "default". The default
varies from the region of the globe where you're sitting, and the
actual satellite to where an antenna system is pointed. Also, it
changes over time.

Thanks,
Mauro
