Return-path: <linux-media-owner@vger.kernel.org>
Received: from ip78-183-211-87.adsl2.static.versatel.nl ([87.211.183.78]:58568
	"EHLO god.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZINPKb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 11:10:31 -0400
Date: Mon, 14 Sep 2009 17:10:12 +0200
From: spam@systol-ng.god.lan
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: Henk.Vergonet@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] tda18271 add FM filter selction + minor fixes
Message-ID: <20090914151011.GA2295@systol-ng.god.lan>
Reply-To: Henk.Vergonet@gmail.com
References: <20090907124934.GA8339@systol-ng.god.lan> <37219a840909070718q47890f5bgbf76a00ea8826880@mail.gmail.com> <20090907151809.GA12556@systol-ng.god.lan> <37219a840909070912h3678fb2cm94102d7437bec5df@mail.gmail.com> <20090908212733.GA19438@systol-ng.god.lan> <37219a840909081457u610b9c65le6141e79567ab629@mail.gmail.com> <20090909140147.GA24722@systol-ng.god.lan> <303a8ee30909090808u46acfb49l760d660f8a28f503@mail.gmail.com> <20090914001447.GA15770@systol-ng.god.lan> <303a8ee30909140533k728791b5p503701d4e6b14122@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <303a8ee30909140533k728791b5p503701d4e6b14122@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 14, 2009 at 08:33:46AM -0400, Michael Krufky wrote:
> On Sun, Sep 13, 2009 at 8:14 PM,  <spam@systol-ng.god.lan> wrote:
> >
> > This patch adds support for FM filter selection. The tda18271 has two rf
> > inputs RF_IN (45-864 MHz) and FM_IN (65-108 MHz). The code automatically
> > enables the antialiasing filter for radio reception and depending on the
> > FM input selected configures EB23 register.
> >
> > Additional fixes:
> > - Fixed the temerature comensation, see revision history of TDA18271HD_4
> > ?spec.
> > - Minor cosmetic change in the tda18271_rf_band[]
> > - Fixed one value and removed a duplicate in tda18271_cid_target[]
> >
> > Signed-off-by: Henk.Vergonet@gmail.com
> >
> >
> 
> Henk,
> 
> Thank you for your patch.
> 
> I have some other tda18271 patches pending merge currently, so it will
> be a few days before I'll be able to test and merge your patch.
> 
> In the meanwhile, I'd request that this single patch be broken down
> into three separate patches, each with a description of the change and
> sign-off.  I know that the patch you sent in is small, I just prefer
> to apply changes separately.
> 
Thats fine, I will wait for the pull in v4l-dvb and then redo the patches:
- FM filter selection
- Errata temerature compensation
- Table fixes

if thast ok.

> Do you have FM radio working on the Zolid board after applying this?

Unfortunately not yet, I get static noise with small 'ticks' at regular
intervals. It maybe the way I am testing. Currently I am using:

	mplayer radio://91.3/capture -nocache -rawaudio rate=32000 -radio \
		adevice=hw=1.0:arate=32000

to test.

I will try to see if a can solder some pin headers on the card so I can
use audio bypass to the sound card.

Thanks,

Henk
