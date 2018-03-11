Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:41385 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932130AbeCKMzW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Mar 2018 08:55:22 -0400
Date: Sun, 11 Mar 2018 12:55:19 +0000
From: Sean Young <sean@mess.org>
To: Matthias Reichl <hias@horus.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Carlo Caione <carlo@caione.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Alex Deryskyba <alex@codesnake.com>,
        Jonas Karlman <jonas@kwiboo.se>, linux-media@vger.kernel.org,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH] media: rc: meson-ir: add timeout on idle
Message-ID: <20180311125518.pcob4wii43odmana@gofer.mess.org>
References: <20180306174122.6017-1-hias@horus.com>
 <20180308164327.ihhmvm6ntzvnsjy7@gofer.mess.org>
 <20180309155451.gbocsaj4s3puc4cq@camel2.lan>
 <20180310112744.plfxkmqbgvii7n7r@gofer.mess.org>
 <20180310173828.7lwyicxzar22dyb7@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180310173828.7lwyicxzar22dyb7@camel2.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matthias,

On Sat, Mar 10, 2018 at 06:38:28PM +0100, Matthias Reichl wrote:
> On Sat, Mar 10, 2018 at 11:27:45AM +0000, Sean Young wrote:
> > So if the timeout is below N then you will never get a space of N or larger;
> > the largest space I know of in an IR message is 40ms in the sanyo protocol:
> > 
> > https://www.sbprojects.net/knowledge/ir/sharp.php
> > 
> > So if timeout is set to less than 40ms, we would have trouble decoding the
> > sharp protocol.
> > 
> > The space between nec repeats is a little less than 100ms. I'm trying to
> > remember what would could go wrong if the space between them would be
> > timeouts instead. Mauro do you remember? I can imagine some IR hardware
> > (e.g. winbond) queuing up IR after generating a timeout, thus delaying
> > delivering IR to the kernel and we ending up generating a key up.
> > 
> > The problem with a higher timeout is that the trailing space (=timeout)
> > is sometimes needed for decoding, and decoding of the last message is
> > delayed until the timeout is received. That means the keyup message is
> > delayed until that time, making keys a bit "sticky" and more likely to
> > generate repeats. I'm pretty sure that is needed for rc-5 and nec.
> 
> Another issue with high timeouts is the response to very short button
> presses where the remote only transmits a single scancode. It then
> takes signal transmission time plus timeout, so roughly a quarter
> of a second on meson-ir and ite-cir with 200ms timeout, until the
> scancode is decoded and the keydown event is generated.
> 
> On longer button presses this is less of an issue as we get the
> space signal when the first pulse of the repeated scancode is
> received. So the delay between button press and keydown is determined
> by the remote scancode repeat interval and with typically ~110ms
> on nec/rc-5 a lot lower.
> 
> This affects both "quick fingers" using a standard remote and
> users of programmable remotes like the Logitech Harmony where
> the number of scancodes transmitted on a short press can be
> configured. With a single scancode transmission we run into
> the long keydown delay, 2 scancodes is fine, and at 3 or 4 we
> start running into the key repeat issue.
> 
> We received several reports from users that their remote felt
> "sluggish" when we switched from the downstream "amremote" driver
> (which IIRC decoded the nec protocol in hardware) to meson-ir.
> 
> Lowering the timeout to 125ms or even significantly lower
> (depending on what the protocol and IR receiver permits)
> removes this "sluggishness", users report that their remote
> is more "responsive".

That makes complete sense. I'm actually keen to get this lowered, since
this makes it possible to lower the repeat period per-protocol, see
commit d57ea877af38 which had to be reverted (the ite driver will
need fixing up as well before this can happen).

Lowering to below 125ms does increase the risk of regressions, so I
am weary of that. Do you think there is benefit in doing this?

Thanks

Sean
