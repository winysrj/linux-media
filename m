Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([89.238.76.85]:39913 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbcD2G6P (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 02:58:15 -0400
Date: Fri, 29 Apr 2016 08:57:52 +0200
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
Subject: Re: [PATCH v7 22/24] [media] rtl2832: change the i2c gate to be
 mux-locked
Message-ID: <20160429065752.GA1870@katana>
References: <1461165484-2314-1-git-send-email-peda@axentia.se>
 <1461165484-2314-23-git-send-email-peda@axentia.se>
 <20160428214758.GA4531@katana>
 <4ae65dd6-1197-11d6-ef0a-714c0525cf3a@axentia.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <4ae65dd6-1197-11d6-ef0a-714c0525cf3a@axentia.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> So, I think all is ok, or do you need more than Tested-by?

I think this will do. Thanks!


--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXIwXwAAoJEBQN5MwUoCm2UnUP/2B1IrbS77z10XlqIYnwthVF
tWSEFlv+9wwkLVfpRQ/3aK2gMCAkblwnph3uhOytPLRFDYSbSQQTEmEhZ46RvKhK
k3oDjzH1xqci5u8w84y+ykWokI/x/xBSsbw/R2ox2OY/LKts92DrYVT2RxFIq2Vt
+Jt8yfI8gxAOsiRi3qxYnH1FaqboxB/qbGdXKIduZe1yx6V+I2h0fHOLH/IiRF2M
yoGcDpKrn69VYprAn6HK4+5erdAvT7dNSNoeW/QulBzUrIXs59h3VF3gHGKpRwSZ
8zoxHAsHlBw6i0Qnd0PGW7BKBu9h7w4NrbShbmmqR+T4UF9f/bA1E9EaWDOM27QA
v+B40nNV3VRMCLjNW00KdlgUF8LCNbb38dZ2IdK9z+RnuSlVhRD/tguWD4DKJKjs
KdnDiZ4c1EVio+H/cylyyBV2RRxiWGDCSVwZlSWS66G3ca5wH7dZokFJqr+iTsNK
kLMeJqsXgOlmbG+D573BgskD+SBvw75ht32LcsKqNw+12InEKzcRNrXwaxLAGvYA
p4TxXM1hfG9/oiQr3mQ/fup2tUDpg7vqDZIqvJbXg/gCPkxxDE8PNiByQ3VLOKgd
xPCoVA22rLBMaGqCYmM33fioxA+Embp6AkEhx8vM18xqJfU1kR4ZFYZ/mOhIEMlp
oUmO+G1ZGXeVVlSFg2cc
=e09L
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
