Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:58681 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934146Ab2JXNnC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Oct 2012 09:43:02 -0400
Date: Wed, 24 Oct 2012 16:37:20 +0300
From: Felipe Balbi <balbi@ti.com>
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Shubhrajyoti D <shubhrajyoti@ti.com>, <linux-usb@vger.kernel.org>,
	<linux-omap@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
	<linux-media@vger.kernel.org>
Subject: Re: [balbi-usb:i2c-transferred-bytes-on-NACK 7/9]
 drivers/media/i2c/adv7604.c:406:9: warning: initialization makes integer
 from pointer without a cast
Message-ID: <20121024133720.GF21735@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <5087e56f.wwcO2kZCKDOco89b%fengguang.wu@intel.com>
 <20121024132323.GA16927@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zi0sgQQBxRFxMTsj"
Content-Disposition: inline
In-Reply-To: <20121024132323.GA16927@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Zi0sgQQBxRFxMTsj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 24, 2012 at 09:23:23PM +0800, Fengguang Wu wrote:
> Sorry, this should really be CCed to the media list.
> I'll use the list recommended by get_maintainer.pl in future.

Actually, I would suggest only testing the following branches from my
tree:

dwc3, musb, xceiv, gadget and fixes

Those are my final branches, everything else is a temporary branch that
I'm using just so I don't loose some patches, or to make it easy for
other guys to test patches.

cheers

--=20
balbi

--Zi0sgQQBxRFxMTsj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQh+8PAAoJEIaOsuA1yqREvnAQAIA987jPiTqrYPuSIsKXpfrp
f7Np2irzEtqZ5h2IW74B7CGcyYYcPxjPl4cF47Yo6XwMf8MoSeEbE9O8Y3fQod4w
X1Vcnie9iauIfoKxuGmGubUIOwFGdWyRZVcVjdm+n3IEGBL4d8QgY4Oc3oFB7EW7
Fw/r2liaoygMO24IdKIOMkAUtXb6pPUAqwyi+YQGw8miZ/yCnOsVbgj1X2AuPxBH
N5sTJTy4Yx0+Vm1ROvB2CRq86Iq2cn5ReHmc8mkmHA1SRMWwoUbfWbhh6VBWZtnT
sbJBrs/31D9DtaQFEG4TTiiJaIIRDpktf02BifI8FPAC1EQwEQGZ3yYWp24oPaiq
acBbR3pbcOaEigsgRQeKWMePmdBRXTldTDKmVShbLEkp82mMz/rax4sKu8iBp/y0
6ZnrA3QRuXtZqLs7/DWb5qI35OjQjGRkdnwnbyREbdgssURIB7E2Ym6QQGEhFcVN
bjUYy4GJXksu9uNWzdsNFM9sm4vXPzWzHVX8PiRzAIjtr1bD9bWRcS5ZixVBPHTR
DOnPTFzDkHUz+KPBrOXMnNGE81sj+AIrY9Fpig5OGqUV9WSrkQmjlTNS3XP16H1/
J86FlwjonfnUKzHbWZOyqGGyEgDF4hhvWdTNnI5uGMAqCvaengtWr5LxXLfZ3kEL
CQjTZe/NpyFYFzunjxnD
=WeXj
-----END PGP SIGNATURE-----

--Zi0sgQQBxRFxMTsj--
