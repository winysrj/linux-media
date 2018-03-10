Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:42492 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750703AbeCJRib (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Mar 2018 12:38:31 -0500
Date: Sat, 10 Mar 2018 18:38:28 +0100
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Carlo Caione <carlo@caione.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Alex Deryskyba <alex@codesnake.com>,
        Jonas Karlman <jonas@kwiboo.se>, linux-media@vger.kernel.org,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH] media: rc: meson-ir: add timeout on idle
Message-ID: <20180310173828.7lwyicxzar22dyb7@camel2.lan>
References: <20180306174122.6017-1-hias@horus.com>
 <20180308164327.ihhmvm6ntzvnsjy7@gofer.mess.org>
 <20180309155451.gbocsaj4s3puc4cq@camel2.lan>
 <20180310112744.plfxkmqbgvii7n7r@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180310112744.plfxkmqbgvii7n7r@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

On Sat, Mar 10, 2018 at 11:27:45AM +0000, Sean Young wrote:
> Hi Matthias,
> 
> On Fri, Mar 09, 2018 at 04:54:51PM +0100, Matthias Reichl wrote:
> > On Thu, Mar 08, 2018 at 04:43:27PM +0000, Sean Young wrote:
> > > On Tue, Mar 06, 2018 at 06:41:22PM +0100, Matthias Reichl wrote:
> > > > +
> > > >  static int meson_ir_probe(struct platform_device *pdev)
> > > >  {
> > > >  	struct device *dev = &pdev->dev;
> > > > @@ -145,7 +161,9 @@ static int meson_ir_probe(struct platform_device *pdev)
> > > >  	ir->rc->map_name = map_name ? map_name : RC_MAP_EMPTY;
> > > >  	ir->rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
> > > >  	ir->rc->rx_resolution = US_TO_NS(MESON_TRATE);
> > > > +	ir->rc->min_timeout = 1;
> > > >  	ir->rc->timeout = MS_TO_NS(200);
> > > > +	ir->rc->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
> > > 
> > > Any idea why the default timeout is to 200ms? It seems very high.
> > 
> > Indeed it is very high, but I have no idea where that might be
> > coming from - so I didn't touch it.
> > 
> > I've been testing rc-5 and NEC remotes with 20-50ms timeouts
> > on meson-ir/upstream kernel and a couple of LibreELEC users are
> > using 30-50ms timeouts without issues on Amlogic devices as well
> > (on 3.14 vendor kernel with meson-ir timeout patch):
> > 
> > https://forum.libreelec.tv/thread/11643-le9-0-remote-configs-ir-keytable-amlogic-devices/?postID=83124#post83124
> > 
> > Out of curiosity: where does the 125ms IR_DEFAULT_TIMEOUT value
> > come from? For raw IR signals processed by the decoders this seems
> > rather high to me as well. On my RPi3 with gpio-ir-recv I'm
> > using 30ms timeout (with an rc-5 remote) without issues.
> 
> So if the timeout is below N then you will never get a space of N or larger;
> the largest space I know of in an IR message is 40ms in the sanyo protocol:
> 
> https://www.sbprojects.net/knowledge/ir/sharp.php
> 
> So if timeout is set to less than 40ms, we would have trouble decoding the
> sharp protocol.
> 
> The space between nec repeats is a little less than 100ms. I'm trying to
> remember what would could go wrong if the space between them would be
> timeouts instead. Mauro do you remember? I can imagine some IR hardware
> (e.g. winbond) queuing up IR after generating a timeout, thus delaying
> delivering IR to the kernel and we ending up generating a key up.
> 
> The problem with a higher timeout is that the trailing space (=timeout)
> is sometimes needed for decoding, and decoding of the last message is
> delayed until the timeout is received. That means the keyup message is
> delayed until that time, making keys a bit "sticky" and more likely to
> generate repeats. I'm pretty sure that is needed for rc-5 and nec.

Another issue with high timeouts is the response to very short button
presses where the remote only transmits a single scancode. It then
takes signal transmission time plus timeout, so roughly a quarter
of a second on meson-ir and ite-cir with 200ms timeout, until the
scancode is decoded and the keydown event is generated.

On longer button presses this is less of an issue as we get the
space signal when the first pulse of the repeated scancode is
received. So the delay between button press and keydown is determined
by the remote scancode repeat interval and with typically ~110ms
on nec/rc-5 a lot lower.

This affects both "quick fingers" using a standard remote and
users of programmable remotes like the Logitech Harmony where
the number of scancodes transmitted on a short press can be
configured. With a single scancode transmission we run into
the long keydown delay, 2 scancodes is fine, and at 3 or 4 we
start running into the key repeat issue.

We received several reports from users that their remote felt
"sluggish" when we switched from the downstream "amremote" driver
(which IIRC decoded the nec protocol in hardware) to meson-ir.

Lowering the timeout to 125ms or even significantly lower
(depending on what the protocol and IR receiver permits)
removes this "sluggishness", users report that their remote
is more "responsive".

so long,

Hias
