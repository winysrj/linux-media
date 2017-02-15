Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58846 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751412AbdBOL2A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 06:28:00 -0500
Date: Wed, 15 Feb 2017 12:27:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: [RFC 08/13] smiapp-pll: Take existing divisor into account in
 minimum divisor check
Message-ID: <20170215112757.GA8974@amd>
References: <20170214134004.GA8570@amd>
 <20170214220503.GO16975@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <20170214220503.GO16975@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2017-02-15 00:05:03, Sakari Ailus wrote:
> Hi Pavel,
>=20
> On Tue, Feb 14, 2017 at 02:40:04PM +0100, Pavel Machek wrote:
> > From: Sakari Ailus <sakari.ailus@iki.fi>
> >=20
> > Required added multiplier (and divisor) calculation did not take into
> > account the existing divisor when checking the values against the
> > minimum divisor. Do just that.
> >=20
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
>=20
> I need to understand again why did I write this patch. :-)

Can you just trust your former self?

> Could you send me the smiapp driver output with debug level messages
> enabled, please?

> I think the problem was with the secondary sensor.

I believe it was with the main sensor, actually. Anyway, here are the
messages.

[    0.791290] smiapp 2-0010: could not get clock (-517)
[    2.705352] smiapp 2-0010: GPIO lookup for consumer xshutdown
[    2.705352] smiapp 2-0010: using device tree for GPIO lookup
[    2.705413] smiapp 2-0010: using lookup tables for GPIO lookup
[    2.705413] smiapp 2-0010: lookup for GPIO xshutdown failed
[    2.875244] smiapp 2-0010: lane_op_clock_ratio: 1
[    2.875274] smiapp 2-0010: binning: 1x1
[    2.875274] smiapp 2-0010: min / max pre_pll_clk_div: 1 / 4
[    2.875305] smiapp 2-0010: pre-pll check: min / max
pre_pll_clk_div: 1 / 1
[    2.875305] smiapp 2-0010: mul 25 / div 2
[    2.875305] smiapp 2-0010: pll_op check: min / max pre_pll_clk_div:
1 / 1
[    2.875335] smiapp 2-0010: pre_pll_clk_div 1
[    2.875335] smiapp 2-0010: more_mul_max: max_pll_multiplier check:
1
[    2.875335] smiapp 2-0010: more_mul_max: max_pll_op_freq_hz check:
1
[    2.875335] smiapp 2-0010: more_mul_max: max_op_sys_clk_div check:
1
[    2.875366] smiapp 2-0010: more_mul_max: min_pll_multiplier check:
1
[    2.875366] smiapp 2-0010: more_mul_min: min_pll_op_freq_hz check:
1
[    2.875366] smiapp 2-0010: more_mul_min: min_pll_multiplier check:
1
[    2.875396] smiapp 2-0010: more_mul_factor: 1
[    2.875396] smiapp 2-0010: more_mul_factor: min_op_sys_clk_div: 1
[    2.875396] smiapp 2-0010: final more_mul: 1
[    2.875427] smiapp 2-0010: op_sys_clk_div: 2
[    2.875427] smiapp 2-0010: op_pix_clk_div: 10
[    2.875427] smiapp 2-0010: pre_pll_clk_div 1
[    2.875457] smiapp 2-0010: pll_multiplier  25
[    2.875457] smiapp 2-0010: vt_sys_clk_div  2
[    2.875457] smiapp 2-0010: vt_pix_clk_div  10
[    2.875457] smiapp 2-0010: ext_clk_freq_hz	9600000
[    2.875488] smiapp 2-0010: pll_ip_clk_freq_hz	9600000
[    2.875488] smiapp 2-0010: pll_op_clk_freq_hz 	240000000
[    2.875488] smiapp 2-0010: vt_sys_clk_freq_hz 	120000000
[    2.875518] smiapp 2-0010: vt_pix_clk_freq_hz 	12000000
[    2.876068] smiapp 2-0010: lane_op_clock_ratio: 1
[    2.876068] smiapp 2-0010: binning: 1x1
[    2.876098] smiapp 2-0010: min / max pre_pll_clk_div: 1 / 4
[    2.876098] smiapp 2-0010: pre-pll check: min / max
pre_pll_clk_div: 1 / 1
[    2.876098] smiapp 2-0010: mul 25 / div 2
[    2.876129] smiapp 2-0010: pll_op check: min / max pre_pll_clk_div:
1 / 1
[    2.876129] smiapp 2-0010: pre_pll_clk_div 1
[    2.876129] smiapp 2-0010: more_mul_max: max_pll_multiplier check:
1
[    2.876159] smiapp 2-0010: more_mul_max: max_pll_op_freq_hz check:
1
[    2.876159] smiapp 2-0010: more_mul_max: max_op_sys_clk_div check:
1
[    2.876159] smiapp 2-0010: more_mul_max: min_pll_multiplier check:
1
[    2.876190] smiapp 2-0010: more_mul_min: min_pll_op_freq_hz check:
1
[    2.876190] smiapp 2-0010: more_mul_min: min_pll_multiplier check:
1
[    2.876190] smiapp 2-0010: more_mul_factor: 1
[    2.876190] smiapp 2-0010: more_mul_factor: min_op_sys_clk_div: 1
[    2.876220] smiapp 2-0010: final more_mul: 1
[    2.876220] smiapp 2-0010: op_sys_clk_div: 2
[    2.876220] smiapp 2-0010: op_pix_clk_div: 10
[    2.876251] smiapp 2-0010: pre_pll_clk_div 1
[    2.876251] smiapp 2-0010: pll_multiplier  25
[    2.876251] smiapp 2-0010: vt_sys_clk_div  2
[    2.876251] smiapp 2-0010: vt_pix_clk_div  10
[    2.876281] smiapp 2-0010: ext_clk_freq_hz	9600000
[    2.876281] smiapp 2-0010: pll_ip_clk_freq_hz	9600000
[    2.876281] smiapp 2-0010: pll_op_clk_freq_hz 	240000000
[    2.876312] smiapp 2-0010: vt_sys_clk_freq_hz 	120000000
[    2.876312] smiapp 2-0010: vt_pix_clk_freq_hz 	12000000
=2E..
[    4.728973] udevd[216]: starting version 175
[    8.031494] smiapp 2-0010: lane_op_clock_ratio: 1
[    8.031524] smiapp 2-0010: binning: 1x1
[    8.031524] smiapp 2-0010: min / max pre_pll_clk_div: 1 / 4
[    8.031524] smiapp 2-0010: pre-pll check: min / max
pre_pll_clk_div: 1 / 1
[    8.031555] smiapp 2-0010: mul 25 / div 2
[    8.031555] smiapp 2-0010: pll_op check: min / max pre_pll_clk_div:
1 / 1
[    8.031555] smiapp 2-0010: pre_pll_clk_div 1
[    8.031585] smiapp 2-0010: more_mul_max: max_pll_multiplier check:
1
[    8.031585] smiapp 2-0010: more_mul_max: max_pll_op_freq_hz check:
1
[    8.031585] smiapp 2-0010: more_mul_max: max_op_sys_clk_div check:
1
[    8.031616] smiapp 2-0010: more_mul_max: min_pll_multiplier check:
1
[    8.031616] smiapp 2-0010: more_mul_min: min_pll_op_freq_hz check:
1
[    8.031616] smiapp 2-0010: more_mul_min: min_pll_multiplier check:
1
[    8.031616] smiapp 2-0010: more_mul_factor: 1
[    8.031646] smiapp 2-0010: more_mul_factor: min_op_sys_clk_div: 1
[    8.031646] smiapp 2-0010: final more_mul: 1
[    8.031646] smiapp 2-0010: op_sys_clk_div: 2
[    8.031677] smiapp 2-0010: op_pix_clk_div: 10
[    8.031677] smiapp 2-0010: pre_pll_clk_div 1
[    8.031677] smiapp 2-0010: pll_multiplier  25
[    8.031707] smiapp 2-0010: vt_sys_clk_div  2
[    8.031707] smiapp 2-0010: vt_pix_clk_div  10
[    8.031707] smiapp 2-0010: ext_clk_freq_hz	9600000
[    8.031738] smiapp 2-0010: pll_ip_clk_freq_hz	9600000
[    8.031738] smiapp 2-0010: pll_op_clk_freq_hz 	240000000
[    8.031738] smiapp 2-0010: vt_sys_clk_freq_hz 	120000000
[    8.031768] smiapp 2-0010: vt_pix_clk_freq_hz 	12000000
[    8.064117] smiapp 2-0010: lane_op_clock_ratio: 1
[    8.064147] smiapp 2-0010: binning: 1x1
[    8.064147] smiapp 2-0010: min / max pre_pll_clk_div: 1 / 4
[    8.064178] smiapp 2-0010: pre-pll check: min / max
pre_pll_clk_div: 1 / 1
[    8.064178] smiapp 2-0010: mul 25 / div 2
[    8.064178] smiapp 2-0010: pll_op check: min / max pre_pll_clk_div:
1 / 1
[    8.064208] smiapp 2-0010: pre_pll_clk_div 1
[    8.064208] smiapp 2-0010: more_mul_max: max_pll_multiplier check:
1
[    8.064208] smiapp 2-0010: more_mul_max: max_pll_op_freq_hz check:
1
[    8.064239] smiapp 2-0010: more_mul_max: max_op_sys_clk_div check:
1
[    8.064239] smiapp 2-0010: more_mul_max: min_pll_multiplier check:
1
[    8.064239] smiapp 2-0010: more_mul_min: min_pll_op_freq_hz check:
1
[    8.064239] smiapp 2-0010: more_mul_min: min_pll_multiplier check:
1
[    8.064270] smiapp 2-0010: more_mul_factor: 1
[    8.064270] smiapp 2-0010: more_mul_factor: min_op_sys_clk_div: 1
[    8.064270] smiapp 2-0010: final more_mul: 1
[    8.064300] smiapp 2-0010: op_sys_clk_div: 2
[    8.064300] smiapp 2-0010: op_pix_clk_div: 10
[    8.064300] smiapp 2-0010: pre_pll_clk_div 1
[    8.064331] smiapp 2-0010: pll_multiplier  25
[    8.064331] smiapp 2-0010: vt_sys_clk_div  2
[    8.064331] smiapp 2-0010: vt_pix_clk_div  10
[    8.064361] smiapp 2-0010: ext_clk_freq_hz	9600000
[    8.064361] smiapp 2-0010: pll_ip_clk_freq_hz	9600000
[    8.064361] smiapp 2-0010: pll_op_clk_freq_hz 	240000000
[    8.064392] smiapp 2-0010: vt_sys_clk_freq_hz 	120000000
[    8.064392] smiapp 2-0010: vt_pix_clk_freq_hz 	12000000

Best regards,
								Pavel


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlikOz0ACgkQMOfwapXb+vJcNwCeOUjSjJLjYfMu8pJOlh95aChE
slYAoJjqxOcvmi7YvQX76EKwaU9i2cTN
=NHZ/
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
