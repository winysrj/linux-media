Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:44063 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751582AbeDDSmq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Apr 2018 14:42:46 -0400
Date: Wed, 4 Apr 2018 19:42:43 +0100
From: Sean Young <sean@mess.org>
To: Matthias Reichl <hias@horus.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Carlo Caione <carlo@caione.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Alex Deryskyba <alex@codesnake.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH 0/3] Improve latency of IR decoding
Message-ID: <20180404184243.rreugkxz5vxjkoay@gofer.mess.org>
References: <cover.1521901953.git.sean@mess.org>
 <20180328183028.bqqp55ser24lucf2@camel2.lan>
 <20180404114401.llnimwz2wqwxpkhw@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180404114401.llnimwz2wqwxpkhw@camel2.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matthias,

On Wed, Apr 04, 2018 at 01:44:01PM +0200, Matthias Reichl wrote:
> On Wed, Mar 28, 2018 at 08:30:29PM +0200, Matthias Reichl wrote:
> > Hi Sean,
> > 
> > On Sat, Mar 24, 2018 at 02:50:42PM +0000, Sean Young wrote:
> > > The current IR decoding is much too slow. Many IR protocols rely on
> > > a trailing space for decoding (e.g. rc-6 needs to know when the bits
> > > end). The trailing space is generated by the IR timeout, and if this
> > > is longer than required, keys can be perceived as sticky and slugish.
> > > 
> > > The other issue the keyup timer. IR has no concept of a keyup message,
> > > this is implied by the absence of IR. So, minimising the timeout for
> > > this further improves the handling.
> > > 
> > > With these patches in place, using IR with the builtin decoders is much
> > > improved and feels very snappy.
> > 
> > thanks a lot for the patches!
> > 
> > I didn't have much time to test yet, but quick checks on
> > Amlogic/meson-ir (kernel 4.16-rc7 + media tree + your patches)
> > and Raspberry Pi (RPi foundation kernel 4.14 + my backport of
> > your patches) look really promising.
> > 
> > I found one issue, though, in ir-sharp-decoder.c max_space must
> > be set to SHARP_ECHO_SPACE - otherwise we get a timeout between
> > the normal and inverted message part and decoding fails.

Thanks for spotting that -- you're right!

> > One thing I'm wondering is if the keyup timer marging might
> > be too tight now. Basically we have just the fixed 10ms marging
> > from idle timeout. The repeat periods of the protocols are rather
> > accurate/strict, so (programmable) remotes not sticking to the
> > official timing might cause repeated keyup/down events if they
> > are repeating a tad to slow.

This does need some further thought. There might be delays in the
scheduling of the rc decoding thread or the IR hardware might be slow
delivering new IR pulse data (e.g. fifo like hardware, e.g. winbond-cir).

> > I'm not sure if this could be an issue, but maybe we should
> > add a safety margin to the repeat periods as well? For example
> > 10 or 20 percent of the specced repeat periods. What do you think?
> > 
> > To get some more test coverage I've asked my colleague to
> > include my backport patch in the LibreELEC testbuilds for
> > x86 and RPi. We've got some 500 regular users of these so if
> > something's not working we should find out soon.
> 
> Quick update: testing so far went really smooth, no issues reported
> since we included the backport patch in LibreELEC testbuilds.
> 
> Quote from https://github.com/LibreELEC/LibreELEC.tv/pull/2623#issuecomment-377897518

Thank you so much for including the patches in the LibreELEC test builds,
that really is a great test! 

> > This is in my nightly test builds since 28 March, and no problems reported so far.
> >
> > On my NUC with Harmony One/RC6 remote these commits are working just fine.
> 
> I've been using LibreELEC on RPi with the patch (using a gpio ir
> receiver and a Hauppauge RC-5 remote) since then and everything
> was fine as well.

That's great. I'd like to do some more testing with various bits of hardware
and test all the protocols.

Thanks,

Sean
