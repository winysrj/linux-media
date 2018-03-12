Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:42325 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932252AbeCLN6N (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Mar 2018 09:58:13 -0400
Date: Mon, 12 Mar 2018 13:58:11 +0000
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
Message-ID: <20180312135811.g25jjzhmh3jnvgjr@gofer.mess.org>
References: <20180306174122.6017-1-hias@horus.com>
 <20180308164327.ihhmvm6ntzvnsjy7@gofer.mess.org>
 <20180309155451.gbocsaj4s3puc4cq@camel2.lan>
 <20180310112744.plfxkmqbgvii7n7r@gofer.mess.org>
 <20180310173828.7lwyicxzar22dyb7@camel2.lan>
 <20180311125518.pcob4wii43odmana@gofer.mess.org>
 <20180312132000.oqrj4xjdi7lvupnu@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180312132000.oqrj4xjdi7lvupnu@camel2.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 12, 2018 at 02:20:00PM +0100, Matthias Reichl wrote:
> On Sun, Mar 11, 2018 at 12:55:19PM +0000, Sean Young wrote:
> > That makes complete sense. I'm actually keen to get this lowered, since
> > this makes it possible to lower the repeat period per-protocol, see
> > commit d57ea877af38 which had to be reverted (the ite driver will
> > need fixing up as well before this can happen).
> 
> I remember the commit, this issue hit us in LibreELEC testbuilds
> as well :-)
> 
> > Lowering to below 125ms does increase the risk of regressions, so I
> > am weary of that. Do you think there is benefit in doing this?
> 
> I'd also say stick to the 125ms default. The default settings
> should always be safe ones IMO.

Well, yes. I just wanted to explore the ideal situation before making
up our minds.

> People who want to optimize for the last bit of performance can
> easily do that on their own, at their own risk.
> 
> 
> Personally I've been using gpio-ir-recv on RPi with the default 125ms
> timeout and a Hauppauge rc-5 remote for about 2 years now and I've
> always been happy with that.

Ok. We should try to get this change for meson-ir ready for v4.17. I can
write a patch later.

> I have to acknowledge though that the responsiveness of a remote
> with short messages, like rc-5, in combination with a low timeout
> (I tested down to 10ms) is pretty impressive.

I've been thinking about this problem. What we could do is have a 
per-protocol maximum space length, and repeat period. The timeout
can then be set to a maximum space length (+safety margin), and the
keyup timer can be set to timeout + repeat period (+safety margin).

If memory serves, the lirc daemon always sets the timeout with
LIRC_SET_REC_TIMEOUT, so it would not affect lirc daemon decoding.

Anyway, just an idea. Not something for v4.17.

Thanks,

Sean
