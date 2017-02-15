Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:14503 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751837AbdBOHPT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 02:15:19 -0500
Subject: Re: [PATCH v3 1/2] v4l: Add camera voice coil lens control class,
 current control
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-media@vger.kernel.org
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
 <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170214224750.GE11317@amd>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <f3ba8ca3-0931-604e-d84c-43c0e43857db@linux.intel.com>
Date: Wed, 15 Feb 2017 09:15:03 +0200
MIME-Version: 1.0
In-Reply-To: <20170214224750.GE11317@amd>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="w6j5ULPA7r2gedNpgSo1NAM1NvHSdaHcM"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--w6j5ULPA7r2gedNpgSo1NAM1NvHSdaHcM
Content-Type: multipart/mixed; boundary="Xlt2covLlwa6sxNP5roCaK1EMTUfnQnI0";
 protected-headers="v1"
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-media@vger.kernel.org
Message-ID: <f3ba8ca3-0931-604e-d84c-43c0e43857db@linux.intel.com>
Subject: Re: [PATCH v3 1/2] v4l: Add camera voice coil lens control class,
 current control
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
 <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170214224750.GE11317@amd>
In-Reply-To: <20170214224750.GE11317@amd>

--Xlt2covLlwa6sxNP5roCaK1EMTUfnQnI0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Pavel,

On 02/15/17 00:47, Pavel Machek wrote:
> On Tue 2017-02-14 14:20:22, Sakari Ailus wrote:
>> Add a V4L2 control class for voice coil lens driver devices. These are=

>> simple devices that are used to move a camera lens from its resting
>> position.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>=20
> Looks good to me.
>=20
> I wonder... should we somehow expose the range of diopters to
> userspace? I believe userland camera application will need that
> information.

It'd certainly be useful to be able to provide more information.

The question is: where to store it, and how? It depends on the voice
coil, the spring constant, the lens and the distance of the lens from
the sensor --- at least. Probably the sensor size as well.

On voice coil lenses it is also somewhat inexact.

--=20
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com


--Xlt2covLlwa6sxNP5roCaK1EMTUfnQnI0--

--w6j5ULPA7r2gedNpgSo1NAM1NvHSdaHcM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlikAAQACgkQbUA2G24owZNorwD8DP4YWoonm3JE/Psg1oQk5kGF
uqVnq49oP07YZiDrmCEBAJj/IvS2+aziB9PJ3wdoU1mxtGdAObGxA6H1cfeWbOje
=yjRb
-----END PGP SIGNATURE-----

--w6j5ULPA7r2gedNpgSo1NAM1NvHSdaHcM--
