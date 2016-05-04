Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:47049 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbcEDUnF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 May 2016 16:43:05 -0400
Date: Wed, 4 May 2016 22:42:48 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Peter Rosin <peda@axentia.se>
Cc: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
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
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Jiri Slaby <jslaby@suse.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matt Ranostay <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Terry Heo <terryheo@google.com>, Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Crestez Dan Leonard <leonard.crestez@intel.com>,
	linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v9 0/9] i2c mux cleanup and locking update
Message-ID: <20160504204248.GA4270@katana>
References: <1462392935-28011-1-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <1462392935-28011-1-git-send-email-peda@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 04, 2016 at 10:15:26PM +0200, Peter Rosin wrote:
> Hi!
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
> of the fact that it is muxing an i2c bus. Extending unlocked transfers
> into the GPIO subsystem is too ugly to even think about. But the general =
hw
> approach is sane in my opinion, with the number of connections between the
> two boards minimized. To put it plainly, I need support for it.
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
> least as long as *all* MUX changes are using the i2c master bus). A lock
> is added to i2c adapters that muxes on that adapter grab, so that transfe=
rs
> through the muxes are serialized.
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
>   usage of the new i2c_root_adapter() function in 18/24)?
>=20
> The first half (patches 01-15 in v7) of what was originally part of this
> series have already been scheduled for 4.6. So, this is the second half
> (patches 16-24 in v7, patches 1-9 in v9).
>=20
> To summarize the series, there is some preparatory locking changes in
> in 1/9 and the real meat is in 3/9. There is some documentation added in
> 4/9 while 5/9 and after are cleanups to existing drivers utilizing
> the new stuff.
>=20
> PS. needs a bunch of testing, I do not have access to all the involved hw.
>=20
> This second half of the series is planned to be merged with 4.7 and can
> also be pulled from github, if that is preferred:
>=20

Applied all to for-next, thanks for keeping at it!


--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXKl7IAAoJEBQN5MwUoCm2m88P/3xZwhW448LzmsJnYPKjkk60
QYI1Ndi/yx22b3KFjihd5dBq/nyq9BVNpqkDeEFOuknC1Sg8aYjfu5nFJWIPj+50
GLjbP1qfPhBxygzPJ5m5/pgBPQJGa6XI+UVFjKOoUYPzQXLLLI040hlYgkU9OPVa
/OqybfWaA6AATy+J1nU0SStLHnJbQO4l+0QXJQ3DyGjJbW1ZJzbAm1F3vCjlfSQF
T6HFsMSBUDzpKtDyLIznekRJqMp9wkn5nc2ZALKR9f51DSM52auEHrMGqPKHCdun
gaRFuGj6h9xzUkJkdB7PibS78jUDyZJT237bPnB3JWRnWyy/Y4dQjekr6FZdpc2n
ciUpYAiAfzaSk+mxr496glcaLDalU5pCzsWVLfFsxSz1hKF56vIT4SIElpfcZy9R
NjrXj9GpdDTHc8IfZYpHxoy2ILfHoEZwySvoOHQdfuWDk56JCvJK8e2NFm1RVGPw
xeGyFHPg+vnznMe45leVhsuX8YzTJhpTrrS+j5XnuQi+Af1ZPFrHety4Yw01pWqS
NA2BiYE8uBAIzLVKaChGGCHJyMgpkp97ESx7n1GuCq3VITIpwQJLIb5ynartEwEk
HBHlDc78s1Q6Vhm3sTUpXi6bsW/XD0aveg8CSqWHuMLCnxfKi4N2yz9Y1uOe++Um
c7j74vKBacnVMkhGKbPw
=+P4c
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
