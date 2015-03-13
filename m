Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39739 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbbCMJlM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2015 05:41:12 -0400
Date: Fri, 13 Mar 2015 10:40:50 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	pali.rohar@gmail.com, Tony Lindgren <tony@atomide.com>
Subject: Re: [RFC 18/18] omap3isp: Deprecate platform data support
Message-ID: <20150313094050.GB4980@earth>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
 <1425764475-27691-19-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DKU6Jbt7q3WqK7+M"
Content-Disposition: inline
In-Reply-To: <1425764475-27691-19-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

[+CC Tony]

On Sat, Mar 07, 2015 at 11:41:15PM +0200, Sakari Ailus wrote:
> Print a warning when the driver is used with platform data. Existing
> platform data user should move to DT now.

I guess this should become a more visible warning on OMAP SoC level,
since platform data based boot will be deprecated completly.

-- Sebastian

--DKU6Jbt7q3WqK7+M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVArCiAAoJENju1/PIO/qajWcQAIUyn6rZcJXxf06NC5Vp2mLt
wa5wUTAd4OSWwkW7TeLKda1wSifSPrnADz0W33RbRsE0hsOBU7fWuaLIEjPEAg75
xZii4eXGaXqlpbsE3gGlpZ3Fgob4BZbCYQpVKlvmIVoDf9Hk0uxU3TzHRtvVwR1B
9d1E6MdadohcTLAF2m3tLjPT+FzT9B8DA4HifmhfgsCXK41HL3DYD9YXTazc75RO
updeqnWHr1wETwx4eE2vEsBEuu9CU2Xt36NT2MVun7nl3yFlkJHoTxZGZsRLVVyG
adONppE7PCYzbzpDzUel8O4wJPpJ+Yp/pcj8ZEbgbf8SSDQHvDY3UMjJ/V6vJnVZ
joy4gJCHRtdkhXQn/ELXGXThFsJzfWOiuiH2ha+SQY0e2fy07XtyxiUnw+v2yMWQ
PxRimxG6UllBZDVYkcR8CV/HummdPFoG9REaGkNF45Pxs9G6FH60YLsh0UqjBXqa
mWQssuXzbsy3sxNP9SForeSouFW822adIrlm6pq6yrvl4sjcR7Uy12exMqO1zidM
jIQlxIAMnxa6CQMtpJPbk4MnaBvNve3HQCQp+2WGf7JQwcDr/5VtQTswnfX+fO+Q
cn14gC84mOogQYMYvYSiIM+SB3P+XL0w8VCAou1lgkAQB9SXLz0Pnf09gys361Ts
qZLhl4/IlNTns6lyl3ha
=s1SH
-----END PGP SIGNATURE-----

--DKU6Jbt7q3WqK7+M--
