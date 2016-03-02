Return-path: <linux-media-owner@vger.kernel.org>
Received: from axentia.se ([87.96.186.132]:16790 "EHLO EMAIL.axentia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbcCBXCj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2016 18:02:39 -0500
From: Peter Rosin <peda@axentia.se>
To: Wolfram Sang <wsa@the-dreams.de>, Peter Rosin <peda@lysator.liu.se>
CC: Peter Korsgaard <peter.korsgaard@barco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Frank Rowand <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	"Srinivas Pandruvada" <srinivas.pandruvada@linux.intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Nicholas Mc Guire <hofrat@osadl.org>,
	Olli Salonen <olli.salonen@iki.fi>,
	"linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH v3 0/8] i2c mux cleanup and locking update
Date: Wed, 2 Mar 2016 22:55:10 +0000
Message-ID: <d0164db34a634171afa631a3167269b8@EMAIL.axentia.se>
References: <1452265496-22475-1-git-send-email-peda@lysator.liu.se>
 <20160302172904.GC5439@katana>
In-Reply-To: <20160302172904.GC5439@katana>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Wolfram Sang wrote:
> On Fri, Jan 08, 2016 at 04:04:48PM +0100, Peter Rosin wrote:
> > 
> > Hi!
> > 
> > [doing a v3 even if there is no "big picture" feedback yet, but
> >  previous versions has bugs that make them harder to test than
> >  needed, and testing is very much desired]
> > 
> > I have a pair of boards with this i2c topology:
> > 
> >                        GPIO ---|  ------ BAT1
> >                         |      v /
> >    I2C  -----+------B---+---- MUX
> >              |                   \
> >            EEPROM                 ------ BAT2
> > 
> > 	(B denotes the boundary between the boards)
> > 
> > The problem with this is that the GPIO controller sits on the same i2c bus
> > that it MUXes. For pca954x devices this is worked around by using unlocked
> > transfers when updating the MUX. I have no such luck as the GPIO is a general
> > purpose IO expander and the MUX is just a random bidirectional MUX, unaware
> > of the fact that it is muxing an i2c bus, and extending unlocked transfers
> > into the GPIO subsystem is too ugly to even think about. But the general hw
> > approach is sane in my opinion, with the number of connections between the
> > two boards minimized. To put is plainly, I need support for it.
> > 
> > So, I observe that while it is needed to have the i2c bus locked during the
> > actual MUX update in order to avoid random garbage on the slave side, it
> > is not strictly a must to have it locked over the whole sequence of a full
> > select-transfer-deselect operation. The MUX itself needs to be locked, so
> > transfers to clients behind the mux are serialized, and the MUX needs to be
> > stable during all i2c traffic (otherwise individual mux slave segments
> > might see garbage).
> > 
> > This series accomplishes this by adding code to i2c-mux-gpio and
> > i2c-mux-pinctrl that determines if all involved devices used to update the
> > mux are controlled by the same root i2c adapter that is muxed. When this
> > is the case, the select-transfer-deselect operations should be locked
> > individually to avoid the deadlock. The i2c bus *is* still locked
> > during muxing, since the muxing happens as part of i2c transfers. This
> > is true even if the MUX is updated with several transfers to the GPIO (at
> > least as long as *all* MUX changes are using the i2s master bus). A lock
> > is added to the mux so that transfers through the mux are serialized.
> > 
> > Concerns:
> > - The locking is perhaps too complex?
> > - I worry about the priority inheritance aspect of the adapter lock. When
> >   the transfers behind the mux are divided into select-transfer-deselect all
> >   locked individually, low priority transfers get more chances to interfere
> >   with high priority transfers.
> > - When doing an i2c_transfer() in_atomic() context or with irqs_disabled(),
> >   there is a higher possibility that the mux is not returned to its idle
> >   state after a failed (-EAGAIN) transfer due to trylock.
> > - Is the detection of i2c-controlled gpios and pinctrls sane (i.e. the
> >   usage of the new i2c_root_adapter() function in 8/8)?
> > 
> > To summarize the series, there's some i2c-mux infrastructure cleanup work
> > first (I think that part stands by itself as desireable regardless), the
> > locking changes are in the last three patches of the series, with the real
> > meat in 8/8.
> > 
> > PS. needs a bunch of testing, I do not have access to all the involved hw
> 
> I want to let you know that I am currently thinking about this series.

Glad to hear it!

> There seems to be a second occasion where it could have helped AFAICT.
> http://patchwork.ozlabs.org/patch/584776/ (check my comments there from
> yesterday and today)

The mpu6050 driver has to set muxc->i2c_controlled before adding
any child adapters for anything to behave differently, and it also
has to make sure that all accesses in select/deselect are normal
i2c accesses (i.e. not unlocked accesses). When doing so,
unreleated i2c traffic might interleave with the muxing. So, if
the chip is auto-deselecting on the first i2c transfer after select
it will never work properly.

> First of all, really thank you that you tried to find the proper
> solution and went all the way for it. It is easy to do a fire&forget
> hack here, but you didn't.

Fire&forget often turns out to be just the fire. If you do it properly
there is a better chance that you really can forget it...

> I hope you understand, though, that I need to make a balance between
> features and complexity in my subsystem to have maintainable and stable
> code.
> 
> As I wrote in the mentioned thread already: "However, I am still
> undecided if that series should go upstream because it makes the mux
> code another magnitude more complex. And while this seems to be the
> second issue which could be fixed by that series, both issues seem to
> be corner cases, so I am not sure it is worth the complexity."
> 
> And for the cleanup series using struct mux_core. It is quite an
> intrusive change and, frankly, the savings look surprisingly low. I
> would have expected more, but you never find out until you do it. So, I
> am unsure here as well.

Yes, that part of the series went ballistic when the half-dozen mux
users outside of drivers/i2c was added to the mix (I was originally
not aware of them). The savings looked better when only the i2c-internal
muxes was considered, mainly because the external muxes are often not
real muxes and only have one child adapter. Creating the mux-core for
that one adapter then swallows the savings.

Funnily enough, I was just the other day looking at the series again and
decided to redo those 5 patches so that I first add the new mux core
and implement the old interface in terms of the new interface, then
convert all the mux users one patch at a time, then remove the glue.
That means 15 patches instead of 5, but each patch only touches one
subsystem, which should ease the transition. The end result is
equivalent, I only had to change a few names to make it possible to
have both the old and the new interfaces active at the same time.

In doing so, I realized that what might be good for the non-generic
one-child-only "muxes" is perhaps an interface that creates a mux core
and registers one child adapter with one call?

One other thing that could help the +- statistics is to maybe add more
parameters to i2c_mux_alloc, such as parent adapter and select/deselect
ops. But that is fairly cosmetic...

> I am not decided and open for discussion. This is just where we are
> currently. All interested parties, I am looking forward to more
> thoughts.

Cheers,
Peter
