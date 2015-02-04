Return-path: <linux-media-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50251 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965274AbbBDKrl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2015 05:47:41 -0500
Date: Wed, 4 Feb 2015 10:47:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Wolfram Sang <wsa@the-dreams.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	linux-i2c@vger.kernel.org, linux-media@vger.kernel.org,
	Jean Delvare <jdelvare@suse.de>
Message-ID: <20150204104720.GU21293@sirena.org.uk>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
 <1419367799-14263-21-git-send-email-crope@iki.fi>
 <20150202180726.454dc878@recife.lan>
 <54CFDCCC.3030006@iki.fi>
 <20150202203324.GA11486@katana>
 <20150203155301.7ba63776@recife.lan>
 <54D11499.6080800@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="m4Bb2ZHVQIF8uI6I"
Content-Disposition: inline
In-Reply-To: <54D11499.6080800@iki.fi>
Subject: Re: [PATCH 21/66] rtl2830: implement own I2C locking
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--m4Bb2ZHVQIF8uI6I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 03, 2015 at 08:34:01PM +0200, Antti Palosaari wrote:
> On 02/03/2015 07:53 PM, Mauro Carvalho Chehab wrote:

> >If latter a better way to lock the I2C mux appears, we can reverse
> >this change.

> More I am worried about next patch in a serie, which converts all that to
> regmap API... Same recursive mux register access comes to problem there,
> which I work-arounded by defining own I2C IO... And in that case I used
> i2c_lock_adapter/i2c_unlock_adapter so adapter is locked properly.

Opne coding the register I/O is a terrible solution, we should allow
people to keep this code factored out.

--m4Bb2ZHVQIF8uI6I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJU0fi4AAoJECTWi3JdVIfQAj4H/jPrWZCtmodKYxGoNzixT1Ha
o2vcHt7CLOBNhBF+LusOXdCcuz83maG1azHpuMLiM4xQiYb/q26WcD1571jOSiMy
7IpR9SBdeTXjhX927o620ZfJ8PsKSuH3Bn3+3WcaicyUxGzSq1tmsyVJjLt1BsgS
7+20zY8d/XVADx8JJMjac05urMbD95fhSM1M4a0TcUI/ACFr3H3mzNu43vr9h9xZ
lEMy1fxYI4MjpCCU7SytiwH6qRdHWwgZePIr1S1VzMrvU+xjqpYRZiP8KxZYGHVS
mGW+TPQGRPjRSXc5oBJJAQGcvi6fQ+hHazJQ4lCAY6x3olIPvlo9PcKSpMB3C9s=
=zjl4
-----END PGP SIGNATURE-----

--m4Bb2ZHVQIF8uI6I--
