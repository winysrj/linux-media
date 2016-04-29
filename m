Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:40019 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbcD2HQQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 03:16:16 -0400
Date: Fri, 29 Apr 2016 09:16:04 +0200
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
	Adriana Reus <adriana.reus@intel.com>,
	Matt Ranostay <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Terry Heo <terryheo@google.com>, Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	Crestez Dan Leonard <leonard.crestez@intel.com>,
	linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, Peter Rosin <peda@lysator.liu.se>
Subject: Re: [PATCH v7 16/24] i2c: allow adapter drivers to override the
 adapter locking
Message-ID: <20160429071604.GB1870@katana>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
 <1461165484-2314-17-git-send-email-peda@axentia.se>
 <20160428205018.GA3553@katana>
 <470abe38-ab5f-2d0a-305b-e1a3253ce5a9@axentia.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UHN/qo2QbUvPLonB"
Content-Disposition: inline
In-Reply-To: <470abe38-ab5f-2d0a-305b-e1a3253ce5a9@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--UHN/qo2QbUvPLonB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> Yes, obviously... I'll make that change locally and wait for the rest.

Another nit: You could use '--strict' with checkpatch and see if you
want to fix the issues reported. I am not keen on those (except for
'space around operators'), it's a matter of taste I guess, but maybe you
like some of the suggestions.

Thanks,

   Wolfram


--UHN/qo2QbUvPLonB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXIwo0AAoJEBQN5MwUoCm2xygP/R5oDbvLxlS7QtNDFqs9YQsb
ue1CKWIAtDwxVfWhTN4Ux5CvI5qPlwR8XKphfQA2zuZxx0jdndtyLs1rsPMyHXXq
DHOZES/Sh3KQw2BS6VCIiO845STigGd59qEuRkWIsNPk5ZCoE4ysPsVHVzNb91Uy
JERiKobdGC4oPL/8OHkq9AKsRlDgq4ljCdHafc4TZktM8fl6R6x0yBJlh1OxcX4z
93pYx6Z/wRd0c4sMDUYOlEZgwmqVK15BhxkWRiYggdvI7vde3bX5SB25sjpYbNV0
NBA2pDEj7CqMth6Y+QkxxHaSqsWFe9Zf6mK69RJ11S/61FfBDAh6NKZOEWakZm0R
hk89WmtwSgyGtQdjadOCZxZykDidlT3wyRjk1bZ7LuK6aon8IIOkWMux3Pa96Dxp
PwVGpMaSXz24aWKu0FWENYoISP8dKY+pcGoMV2Hah9/21ciengW/Gd1PG/h4aDjO
87Lqo9JusJ+UI5/mmViL7ev2M6u26jG1UgfPVWyKwWtxFqV4IIU7iVuwxmn17CYn
OJ6fRQi5R0ImNL/0BF6DY9mqovephJTtMiO7Oc7OXHtM6VtIUGIdSddYBkRgQlFj
p8g6WMpcH/aO+Ta35w1k1UiTNvA3HS6N1NjcHS/1TBop/ck3SeZWK8pQ26LBJev8
j9ihkxWB4rcskib6i911
=Nlmg
-----END PGP SIGNATURE-----

--UHN/qo2QbUvPLonB--
