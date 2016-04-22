Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:54828 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbcDVLPU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 07:15:20 -0400
Date: Fri, 22 Apr 2016 13:14:59 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Peter Rosin <peda@axentia.se>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
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
	"linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Peter Rosin <peda@lysator.liu.se>
Subject: Re: [PATCH v7 00/24] i2c mux cleanup and locking update
Message-ID: <20160422111459.GA1538@katana>
References: <AM4PR02MB1299DD7DBCE30E8EFE9E1259BC6F0@AM4PR02MB1299.eurprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <AM4PR02MB1299DD7DBCE30E8EFE9E1259BC6F0@AM4PR02MB1299.eurprd02.prod.outlook.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> The problem with waiting until 4.8 with the rest of the series is that it
> will likely go stale, e.g. patch 22 ([media] rtl2832: change the i2c gate
> to be mux-locked) touches a ton of register accesses in that driver since
> it removes a regmap wrapper that is rendered obsolete. Expecting that
> patch to work for 4.8 is overly optimistic, and while patching things up

Okay, that can be argued, I understand that. So, what about this
suggestion: I pull in patches 1-15 today, and we schedule the rest of
the patches for like next week or so. That still gives the first set of
patches some time in linux-next for further exposure and testing whilst
the whole series should arrive in 4.7.

However, I need help with that. There are serious locking changes
involved and ideally these patches are reviewed by multiple people,
especially patches 16-19. I first want to say that the collaboration
experience with this series was great so far, lots of testing and
reporting back. Thanks for that already. Yet, if we want to have this in
4.7, this needs to be a group effort. So, if people interested could
review even a little and report back this would be extremly helpful.

> Third, should we deprecate the old i2c_add_mux_adapter, so that new
> users do not crop up behind our backs in the transition? Or not bother?

Usually it is fine to change in-kernel-APIs when you take care that all
current users are converted. But I am also fine with being nice and
keeping the old call around for a few cycles. It is your call.

> Fourth, I forgot to change patch 8 (iio: imu: inv_mpu6050: convert to
> use an explicit i2c mux core) to not change i2c_get_clientdata() ->
> dev_get_drvdata() as requested by Jonathan Cameron. How should I handle
> that?

I'll pull in the first patches this eveneing. You can choose to send me
an incremental patch or resend patch 8. I am fine with both, but it
should appear on the mailing list somehow.

> There are also some new Tested-by tags that I have added to my
> local branch but have not pushed anywhere. I'm ready to push all that
> to a new branch once you are ready to take it.

For the patches 1-15, I am ready when you are :)

Thanks,

   Wolfram


--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXGgezAAoJEBQN5MwUoCm2HvQQAKUUSxnW4Ou397cODJ7ZWtcE
3rI1hYz5r58o2Kmc00QiNdlJQyuzpWrqLc2WmN5omxlzSEprNup5jzePbk5aEo9l
fov+IMbgGAMsRsUyJ98G7Mpoij0mTNrFKR33QqqgGhUANR4QE/xDJPNnfMBnebJj
OG0ZHmGNnPqu1IIusIbUp762VqxKl1ZR8XjeywJO1z01KC1B6gK7q49/5B5bsjnz
DxriRYHGlcQdlis6Jp/wyHrYKVPkWLOCD4dEB7Cv9gH4uODbtjcMgHgKjATEPyXc
eimE7Xx9dbXjn8oxmm827eFBq6Km/DDi4N6osaKXlhT/vyPe8L/QEqLlRY+Sx1ni
RheGIbkzu5ORGgrc5onQG8A7PBsCdagdo7cbGKl0JV5531yYj2Z4sFJjzgoPGJye
3jim9C3aJxEzd6zRnV1kbl1NHeqJgr5SrDNA/sH/9VGAG6lLbb6V1Ij/fTgZAt0N
XM0C+Ke0JG3NvG3qpC/Mb6X9+64uTXv7V4+AxT+G7em167VQW4hG5CVEu+rCkW1N
qR66vsvkv8Ueoso29OprwGcYyDCXz62CCJcJRDSdAFqb50+K0FRmFMvmbZg4iU4g
sbHLXRTRGkSaXzFFxUbzVAYl6H2aIGZdlf1xfrlg6wQQfU7v9LMOuQoNXI9bYsuy
hKQNEWOQekSIwjypYw2t
=ijYn
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
