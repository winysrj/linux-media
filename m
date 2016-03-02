Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:54131 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853AbcCBRaj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Mar 2016 12:30:39 -0500
Date: Wed, 2 Mar 2016 18:29:05 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Peter Rosin <peda@lysator.liu.se>
Cc: Peter Rosin <peda@axentia.se>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
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
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Nicholas Mc Guire <hofrat@osadl.org>,
	Olli Salonen <olli.salonen@iki.fi>, linux-i2c@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 0/8] i2c mux cleanup and locking update
Message-ID: <20160302172904.GC5439@katana>
References: <1452265496-22475-1-git-send-email-peda@lysator.liu.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UPT3ojh+0CqEDtpF"
Content-Disposition: inline
In-Reply-To: <1452265496-22475-1-git-send-email-peda@lysator.liu.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--UPT3ojh+0CqEDtpF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 08, 2016 at 04:04:48PM +0100, Peter Rosin wrote:
> From: Peter Rosin <peda@axentia.se>
>=20
> Hi!
>=20
> [doing a v3 even if there is no "big picture" feedback yet, but
>  previous versions has bugs that make them harder to test than
>  needed, and testing is very much desired]
>=20
> I have a pair of boards with this i2c topology:
>=20
>                        GPIO ---|  ------ BAT1
>                         |      v /
>    I2C  -----+------B---+---- MUX
>              |                   \
>            EEPROM                 ------ BAT2
>=20
> 	(B denotes the boundary between the boards)
>=20
> The problem with this is that the GPIO controller sits on the same i2c bus
> that it MUXes. For pca954x devices this is worked around by using unlocked
> transfers when updating the MUX. I have no such luck as the GPIO is a gen=
eral
> purpose IO expander and the MUX is just a random bidirectional MUX, unawa=
re
> of the fact that it is muxing an i2c bus, and extending unlocked transfers
> into the GPIO subsystem is too ugly to even think about. But the general =
hw
> approach is sane in my opinion, with the number of connections between the
> two boards minimized. To put is plainly, I need support for it.
>=20
> So, I observe that while it is needed to have the i2c bus locked during t=
he
> actual MUX update in order to avoid random garbage on the slave side, it
> is not strictly a must to have it locked over the whole sequence of a full
> select-transfer-deselect operation. The MUX itself needs to be locked, so
> transfers to clients behind the mux are serialized, and the MUX needs to =
be
> stable during all i2c traffic (otherwise individual mux slave segments
> might see garbage).
>=20
> This series accomplishes this by adding code to i2c-mux-gpio and
> i2c-mux-pinctrl that determines if all involved devices used to update the
> mux are controlled by the same root i2c adapter that is muxed. When this
> is the case, the select-transfer-deselect operations should be locked
> individually to avoid the deadlock. The i2c bus *is* still locked
> during muxing, since the muxing happens as part of i2c transfers. This
> is true even if the MUX is updated with several transfers to the GPIO (at
> least as long as *all* MUX changes are using the i2s master bus). A lock
> is added to the mux so that transfers through the mux are serialized.
>=20
> Concerns:
> - The locking is perhaps too complex?
> - I worry about the priority inheritance aspect of the adapter lock. When
>   the transfers behind the mux are divided into select-transfer-deselect =
all
>   locked individually, low priority transfers get more chances to interfe=
re
>   with high priority transfers.
> - When doing an i2c_transfer() in_atomic() context or with irqs_disabled(=
),
>   there is a higher possibility that the mux is not returned to its idle
>   state after a failed (-EAGAIN) transfer due to trylock.
> - Is the detection of i2c-controlled gpios and pinctrls sane (i.e. the
>   usage of the new i2c_root_adapter() function in 8/8)?
>=20
> To summarize the series, there's some i2c-mux infrastructure cleanup work
> first (I think that part stands by itself as desireable regardless), the
> locking changes are in the last three patches of the series, with the real
> meat in 8/8.
>=20
> PS. needs a bunch of testing, I do not have access to all the involved hw

I want to let you know that I am currently thinking about this series.

There seems to be a second occasion where it could have helped AFAICT.
http://patchwork.ozlabs.org/patch/584776/ (check my comments there from
yesterday and today)

First of all, really thank you that you tried to find the proper
solution and went all the way for it. It is easy to do a fire&forget
hack here, but you didn't.

I hope you understand, though, that I need to make a balance between
features and complexity in my subsystem to have maintainable and stable
code.

As I wrote in the mentioned thread already: "However, I am still
undecided if that series should go upstream because it makes the mux
code another magnitude more complex. And while this seems to be the
second issue which could be fixed by that series, both issues seem to
be corner cases, so I am not sure it is worth the complexity."

And for the cleanup series using struct mux_core. It is quite an
intrusive change and, frankly, the savings look surprisingly low. I
would have expected more, but you never find out until you do it. So, I
am unsure here as well.

I am not decided and open for discussion. This is just where we are
currently. All interested parties, I am looking forward to more
thoughts.

Thanks,

   Wolfram


--UPT3ojh+0CqEDtpF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJW1yLgAAoJEBQN5MwUoCm2aP0QAJ6V0JdHSwqtGZ4WUc2ayisD
4BK4XC2Xz1f/71kvblwyyqBKV6MeSiW52gIXGLveXL4aV2iEu+6BEa2yEi0IB878
7ttujceclxbN/tOb4N7iS7BYeizbYZARYC/hUW5w29ren7UZI1UnGXTtaPvSImlX
GllkB0wk+ZsQg3j/RevkT8OqqGjskNeQWftR11ldL9WB7UOG+mB4asBhNY4aRe0u
3dyLfoH17qaMqckrym7M0y/yGMWb2huhjrShra1zsH6KtSjJfQ0Kn6oGxWxw71QB
B29ISZE8fKEdAmuuQTrNUQnyY1JvIb/JvIHBQW8F/TiEK4k4fyTp/tPxV7nGznNa
bOZnMfje5slFCaVOiPy4CFVQbnI9nM2CXYEwHncWxOzJxRrVIDyvn30SopFBWekG
xgeyuBoXLhE31fyLEcNAk1uwEqBro7we930yoP2wmM3CUQ1ENTMAXIiDS5NbZGQg
m1amNfNcG5Efmvk4giMcRxpQ5+TXrRVZQxnpBZIJRJX3nM0DqLrn3u6S7kBRWsuW
Ru2kF1B6tLcQyLFOtHYxVsqjHRg3aoUaAx1vQhWnhj9yWvyqooBLo1zwMYS5MuBy
CjC0T/JHR3clGCVG4IyLIxvTC5jQtGCKqT0GQqLtpD1FxyAv0GwyI88EMJaLE6u9
fqGQMgOUqoSj/JJv3ZTH
=jLKE
-----END PGP SIGNATURE-----

--UPT3ojh+0CqEDtpF--
