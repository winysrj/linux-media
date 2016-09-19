Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751032AbcISWyz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 18:54:55 -0400
Date: Tue, 20 Sep 2016 00:54:40 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/5] smiapp: Set use suspend and resume ops for other
 functions
Message-ID: <20160919225435.2wqhkplmjac54xxr@earth>
References: <1473938961-16067-1-git-send-email-sakari.ailus@linux.intel.com>
 <1473938961-16067-4-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ugp7qitj3sdodmsx"
Content-Disposition: inline
In-Reply-To: <1473938961-16067-4-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ugp7qitj3sdodmsx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Sep 15, 2016 at 02:29:19PM +0300, Sakari Ailus wrote:
> Use the suspend and resume ops for freeze, thaw, poweroff and restore
> callbacks as well.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--ugp7qitj3sdodmsx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJX4GyrAAoJENju1/PIO/qagyAP/01hexx+21WViET93DjUnLRi
xsePfgNbHG18mxHCLGX/jU/f6ZO88OyN/btoXZXPFIE7qeeKLtIp2xO8pfKsmRe4
0HikyUWkGYUgo+fmdILKCHHXfBA3Kj/eH2EWINscQ+j3K6ONkdD2rODiSibTAXur
L+3ReU9dQELd1Ky/ZzSxSUWQQRwxNpTHzJuxpXyJS+o19ZRiuZlJF+kgGhCDvcr5
sHHFBXsnNbTFRK8Mc/Ria/DHNtrVQivBv2lNv0KKIAsUcZMgrkauNne6PH1L3E5b
P0GzlGKuaF8Ejh0zvFWw/ye9lSwR247vHHRVD917etFjuigLkr5Yi4lfh6Pf4O5t
LXVeT1jGAoZr2GRLC9TOBcw3D7dKxuo+ZBHxFw1iN2rnCmfqr5G/V9X2DVVQm+BM
OCePDSwRYk84a/O+I3CS07LRlPme8sDmB8EULk9icUTrt1V9NvTr0zWr6o72Kdi0
F1yYAtdAOb/GJEbiXvXo6ma1HcdzrYGOC+zm4fjAHh0H34RfQIE5ibQC7Fdc0EJi
vxc1wCXo8XKkeVAOKjDF6a4a2xK3ZysDvwj3KQxj2gLJYdDTb0fqIhnPUMe/QECF
u+g4zFikigsx2H3a0Y19a2tTJotv5VYah2NXe1C3u4ZcGtYN2baMUjujQPez56Sd
QoCfjxSPxfGPw2CO8G5s
=qfb8
-----END PGP SIGNATURE-----

--ugp7qitj3sdodmsx--
