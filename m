Return-path: <linux-media-owner@vger.kernel.org>
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:55936 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730426AbeGRPZp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Jul 2018 11:25:45 -0400
Date: Wed, 18 Jul 2018 15:47:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Rosin <peda@axentia.se>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH -next v4 1/3] regmap: add SCCB support
Message-ID: <20180718144723.GM5700@sirena.org.uk>
References: <1531756070-8560-1-git-send-email-akinobu.mita@gmail.com>
 <1531756070-8560-2-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nrXiCraHbXeog9mY"
Content-Disposition: inline
In-Reply-To: <1531756070-8560-2-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nrXiCraHbXeog9mY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 17, 2018 at 12:47:48AM +0900, Akinobu Mita wrote:
> This adds Serial Camera Control Bus (SCCB) support for regmap API that
> is intended to be used by some of Omnivision sensor drivers.

The following changes since commit ce397d215ccd07b8ae3f71db689aedb85d56ab40:

  Linux 4.18-rc1 (2018-06-17 08:04:49 +0900)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-sccb

for you to fetch changes up to bcf7eac3d97f49d8400ba52c71bee5934bf20093:

  regmap: add SCCB support (2018-07-18 15:45:23 +0100)

----------------------------------------------------------------
regmap: Add support for SCCB

This is an I2C subset.

----------------------------------------------------------------
Akinobu Mita (1):
      regmap: add SCCB support

 drivers/base/regmap/Kconfig       |   4 ++
 drivers/base/regmap/Makefile      |   1 +
 drivers/base/regmap/regmap-sccb.c | 128 ++++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h            |  35 +++++++++++
 4 files changed, 168 insertions(+)
 create mode 100644 drivers/base/regmap/regmap-sccb.c

--nrXiCraHbXeog9mY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAltPUvsACgkQJNaLcl1U
h9CHfwf/WlS+6f05pFZez91zy/MYpUBD++y4VxOnJn3t7kUo4VaFyYGLVXG9cx+e
b2LEyr52WkvjL/K61SeY1GDvo+ANBGcA26VTD6S22DIVBSekDEe4hh9tbkRcBMHE
kfLrSC+hdLX+bAv8Ws0kcKyNm5pOLTZPdNr0CoIo7yGK2nmH/54mOAfMroIS4RNb
xFjAGGoWbH7xXRrXuhe5PNdbzXecrE/pmKl/3IG6IN5gu2GYLd+niTgiM+X2Rv69
P29kD9izCb2rd8O1xl1UfudAGeJsZeerjtVqV7fc0YSIYNW3vQNbcC8pWvMmZ7Gb
W0iwocfPy2uzSnv8Jgz54PnROPubJg==
=CKOC
-----END PGP SIGNATURE-----

--nrXiCraHbXeog9mY--
