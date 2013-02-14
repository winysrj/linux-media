Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:51847 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab3BNLPZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Feb 2013 06:15:25 -0500
Message-ID: <511CC747.4060508@ti.com>
Date: Thu, 14 Feb 2013 13:15:19 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Florian Neuhaus <florian.neuhaus@reberinformatik.ch>,
	"Taneja, Archit" <archit@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: AW: omapdss/omap3isp/omapfb: Picture from omap3isp can't recover
 after a blank/unblank (or overlay disables after resuming)
References: <6EE9CD707FBED24483D4CB0162E85467245822C8@AMSPRD0711MB532.eurprd07.prod.outlook.com> <6EE9CD707FBED24483D4CB0162E8546724593AEC@AMSPRD0711MB532.eurprd07.prod.outlook.com> <511CB792.1020608@ti.com> <4202523.mOtkCksGpI@avalon>
In-Reply-To: <4202523.mOtkCksGpI@avalon>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigA89C52CB5271E760BFED89A6"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enigA89C52CB5271E760BFED89A6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-02-14 13:07, Laurent Pinchart wrote:

>> In many cases underflows are rather hard to debug and solve. There are=

>> things in the DSS hardware like FIFO thresholds and prefetch, and VRFB=

>> tile sizes, which can be changed (although unfortunately only by
>> modifying the drivers). How they should be changed if a difficult
>> question, though, and whether it'll help is also a question mark.
>=20
> Naive question here, instead of killing the overlay completely when an =

> underflow happens, couldn't the DSS driver somehow recover from that co=
ndition=20
> by restarting whatever needs to be restarted ?

Yes. Killing the overlay is just the safest choice. Presumably if an
underflow happens, the problem is still there, and it'll just happen
again if you re-enable the overlay. Obviously this is not always the
case, as this problem at hand shows.

There's much to improve with the DSS driver's error handling, though. I
think first step would be to remove it totally from DSS, and move it to
omapfb/omapdrm. It's a bit difficult to handle the errors at the lowest
level.

 Tomi



--------------enigA89C52CB5271E760BFED89A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRHMdHAAoJEPo9qoy8lh71Fd0P/3lyuO3DenZMXFHhvbFKYJc6
e5TFaXAcS7fhG5h13jAKwI6m3gP+3BZKvTJ/WU4+vQI1tA/NFmCizfIU/x3ytnFp
CeKY2O5/HcVr6MdMo7VnJtcuRvwIPZxdBr6TjcIx7jZgZwISqOD5sy/lnw0mRLno
BAYGEP7oyrnoLAziYGG5hYb5tIuHGOvmU69X2IMY3t0l812XHMmxU7e0hlUoZFmR
QcJv3xmvC8w/ltTcHCf4zzeQKrP4Nz89cqe8elxV5ajkYNGsz7Ka8daaqM1VgrOe
5qXA3TM883Rbd0cBpX6U+KhU/grQNqpQTh1gE34lX82jUlxVxmzUN1hKMN4OWCYy
QtGUC8w+OM4TXVT9SFkMtVTiW3LO/tXi23+/X8cXgFlmwH4W7N7QkXwNJJq5QOL/
oatBRlx4AmAqVOW1Z7zxx3GINzTqdufdOf8WWhTVvLwO2e1N15N+lrQOSMcF9kmU
9S+nQDTkCaJDjUaiNgJXfr5A1CTRfOl34ueRCPDZFkQ3MN2KE4NsUrdCxi67prl/
ZAMDnKa5thvaPquWjq52XzxnFup/+BDwrsSAV/vc/rwNwI+Z3x7WBlcn3TaT+3ea
OiwOcWgcjJUmNo34UMgJhojO6G9HAlmtfdzaeiboJ3goofvNbt52gLGvivIowuq9
7iaRPznGlM2Sf7v6VJf5
=OQCt
-----END PGP SIGNATURE-----

--------------enigA89C52CB5271E760BFED89A6--
