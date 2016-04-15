Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-he1eur01on0096.outbound.protection.outlook.com ([104.47.0.96]:23037
	"EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751751AbcDOXJ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 19:09:59 -0400
From: Peter Rosin <peda@axentia.se>
To: Wolfram Sang <wsa@the-dreams.de>, Peter Rosin <peda@lysator.liu.se>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Jonathan Corbet" <corbet@lwn.net>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	"Peter Meerwald" <pmeerw@pmeerw.net>,
	Antti Palosaari <crope@iki.fi>,
	"Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	"Frank Rowand" <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	"Kalle Valo" <kvalo@codeaurora.org>, Joe Perches <joe@perches.com>,
	Jiri Slaby <jslaby@suse.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	"Matt Ranostay" <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Terry Heo <terryheo@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	"linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v6 01/24] i2c-mux: add common data for every i2c-mux
 instance
Date: Fri, 15 Apr 2016 15:52:55 +0000
Message-ID: <AM4PR02MB1299030956B02941183DF239BC680@AM4PR02MB1299.eurprd02.prod.outlook.com>
Content-Language: sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Wolfram Sang wrote:
> > > wonder even more if we couldn't supply num_adapters to i2c_mux_alloc()
> > > and reserve the memory statically. i2c busses are not
> > > dynamic/hot-pluggable so that should be good enough?
> > 
> > Yes, that would work, but it would take some restructuring in some of
> > the drivers that currently don't know how many child adapters they
> > are going to need when they call i2c_mux_alloc.
> 
> Which ones?

If you look at i2c-mux-reg.c, it currently allocates its private
struct regmux, then fills it with various platform things and then
when it knows how many children it needs it allocates them. After
v6 it first allocates a mux core and private struct regmux in one go
using i2c_mux_alloc, then continues in much the same way as before.

If the number of children is needed for the i2c_mux_alloc call, then
this is certainly doable, and it would probably not be all that bad,
but the simplest approach would probably be to allocate the private
struct regmux first, then dig through the platform data, then allocate
the mux core when the number of children is known. Which would still
be two allocations separated by the platform data dig.

So, your suggestion would basically move the mux core allocation
from generally being done early together with other private data to
later when the driver has figured out how many children it's going
to create.

The restructuring I thought about is needed if the intention of this
was to reduce number of allocations, but maybe you just wanted
what I described above? Because what I did in v6 and what you are
suggesting is quite similar in complexity, but your version has the
advantage of not having the need for realloc.

So, I have made this change locally (and the adapters->num_adapters
change) and I like it. I haven't even compile-tested it yet though,
but I'll get back when I have done some testing.

> > Because you thought about removing i2c_mux_reserve_adapters completely,
> > and not provide any means of adding more adapters than specified in
> > the i2c_mux_alloc call, right?
> 
> Yes. I assumed I2C to be static enough that such information is known in
> advance.
> 
> > > Ignoring the 80 char limit here makes the code more readable.
> > 
> > That is only true if you actually have more than 80 characters, so I don't
> > agree. Are you adamant about it? (I'm not)
> 
> No. Keep it if you prefer it.
> 
> > >> +EXPORT_SYMBOL_GPL(i2c_mux_one_adapter);
> > > 
> > > Are you sure the above function pays off? Its argument list is very
> > > complex and it doesn't save a lot of code. Having seperate calls is
> > > probably more understandable in drivers? Then again, I assume it makes
> > > the conversion of existing drivers easier.
> > 
> > I added it in v4, you can check earlier versions if you like. Without
> > it most gate-muxes (i.e. typically the muxes in drivers/media) grew
> > since the i2c_add_mux_adapter call got replaced by two calls, i.e.
> > i2c_mux_alloc followed by i2c_max_add_adapter, and coupled with
> > error checks made it look more complex than before. So, this wasn't
> > much of a cleanup from the point of those drivers.
> 
> Hmm, v3 didn't have the driver patches posted with it. Can you push it
> to your branch? I am also not too strong with this one, but having a
> look how it looks without would be nice.

Although I'm not sure what you meant by "driver patches", I have pushed
mux-core-and-locking-2 and mux-core-and-locking-3 to
https://github.com/peda-r/i2c-mux/ (note that these are the branches as
they where when I posted v2 and v3 to the list, i.e. w/o fixups)

Those early versions updated all drivers with each change, making each
patch big, so if that was what you meant by missing "driver patches" then
there simply were no driver patches.

If you meant the follow-up patches to relax locking in the media drivers
etc, I only compile-tested them using throwaway branches back then (if I
even had branches). So, I don't have anything ready to push, sorry.

Cheers,
Peter
