Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:60506 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbbF2Tqf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 15:46:35 -0400
Date: Mon, 29 Jun 2015 14:46:32 -0500
From: Felipe Balbi <balbi@ti.com>
To: Benoit Parrot <bparrot@ti.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	<linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] media: am437x-vpfe: Requested frame size and fmt
 overwritten by current sensor setting
Message-ID: <20150629194632.GG1019@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <1435606940-2321-1-git-send-email-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KIzF6Cje4W/osXrF"
Content-Disposition: inline
In-Reply-To: <1435606940-2321-1-git-send-email-bparrot@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--KIzF6Cje4W/osXrF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 29, 2015 at 02:42:20PM -0500, Benoit Parrot wrote:
> Upon a S_FMT the input/requeated frame size and pixel format is
> overwritten by the current subdevice settings.
> Fix this so application can actually set the frame size and format.
>=20
> Signed-off-by: Benoit Parrot <bparrot@ti.com>

likewise, stable ?

--=20
balbi

--KIzF6Cje4W/osXrF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVkaCYAAoJEIaOsuA1yqREB8UP/3a+eZDUdGMhhb2M79hTc4Hg
DElRe/eEq/KD8vrM1AgMmWkTEKktWio15P3+9WOo450at44chlhEFvvLLoOo+Mgw
SucE5ULOxIea0pXAtVkqCzC3g2Msoat1VdBuJjXJqq77p4SK8MbPybFrgMtqgJO9
Baron93RXRa7w4YEDL0M+43DfEqdjGY0PO/YFurjVxC/QlPTDs3lfrAl8vZx+iuF
7kIw72V065dcrdqfZEUNfuNySPohvXLYCzKdUYXrVj+d+YVBWryS7BYXJjxP2+/P
E35HDkPOS3gQFN/bbBkeWMgbTZIxJCNvQxjfL4Fxomu94m4yYYyll5WuSo1NYed/
fr2If+rJ6Ral6/JFU88nHqdd+xFZeWU615eTfhD0rn/twA3gJtsmeNBVW4zIJnU+
AdF754aR5qqNjj6yFrCMBNOZYOkCR1VZubsJCI2NJ8ZlsQv1t5SyUxRNXrpsMSVU
vPp3snGzsgn5BHaGUtJFRbdl6PTkH+LVRJ4TTsuy8isiU6wAYVfpg8TaeqOPrPtK
PP22m54cBTlhqE1/wrCpcu/A+dbpf6qMCiIs4XreyVAZJsyyDW246cDwHyE60tvJ
P0A0B1vLV0rf/tUvbD1IovkbpkC5E4ITWWgeDFdBl+zEu6CWFb1oKPEDYOoy+nDG
4I59DHH2uAhfOHFOamzU
=U31p
-----END PGP SIGNATURE-----

--KIzF6Cje4W/osXrF--
