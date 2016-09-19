Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751443AbcISX2C (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 19:28:02 -0400
Date: Tue, 20 Sep 2016 01:27:57 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v3 00/18] More smiapp cleanups, fixes
Message-ID: <20160919232756.rolq7itax7er6a4g@earth>
References: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="u22q5is4heh4ixiu"
Content-Disposition: inline
In-Reply-To: <1474322571-20290-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--u22q5is4heh4ixiu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Sep 20, 2016 at 01:02:33AM +0300, Sakari Ailus wrote:
> This set further cleans up the smiapp driver and prepares for
> later changes.
>=20
> since v2:
>=20
> - Fix badly formatted debug message on wrong frame format model type
>=20
> - Add a debug message on faulty frame descriptor (image data lines are
>   among embedded data lines)
>=20
> - Fix error handling in registered() callback, add  unregistered()
>   callback
>=20
> - smiapp_create_subdev() will return immediately if its ssd argument is
>   NULL. No need for caller to check this.

Reviewed-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--u22q5is4heh4ixiu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJX4HR5AAoJENju1/PIO/qa+q4P/RBY1CCvWQ0mfD5FhEw1h97R
bs72NBMIdNo8HW0Xm+1pXH7pBgo3QcmAn77YHwCjwLt+6IKApZt5LlkF+S6C2x3G
TMoDNIE4K9ftG79XoNeMn8iCG7Gbfcw/hNMDekOTKVCBxDiM2dQh40147YXI1ojM
YhW1SwiN5COBT6JH/A4FRDQmuIwKAw98oGBGYRngxsRrpNjRT3zh/0Gl/Nf1iAIz
v68Y2h3Mh1g+7WBO7BQlOcjIktpJqGJeHG4LS7u1yXefX299mgVQcxIxABTr+QEF
4BXMzRfrTQoEtZZ46rZTEKosuIAXy4f9FDmWzfh6NVjim1Jq+Ij66IY5pwsPoomG
PLJQTy0Xx+7HNHJJt81A1x1sK2y92THf4nD2JxYoxPGog7jV2bysMriBQpMs+qy/
QLDbQ5d9ZbwnaW43RoX6F6gu1O1cTS1njWQPApltulLTzLmSNG9DEceqlLG9WpFn
6DYoAD3Fs8IMWVZvSj2aURDd1RA/WJQViaVrFQbMKPIAuuwwXcRTxw2HF9SujMjR
nC05//7X1xNEVTFpwCqgc/xexdy6lPZLTfov8UapI4UO5RA/cn+2IBnnfVsX3bgA
3fMcnHZSNWmLUENGMJeGJrj17iGCicc/0ZNDUi97S7oKPr/SejrA7jZivF+vWPV6
SeU5N3b9yQS3od0nXG/U
=heJj
-----END PGP SIGNATURE-----

--u22q5is4heh4ixiu--
