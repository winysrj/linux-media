Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:52335 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbbJDXPP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Oct 2015 19:15:15 -0400
Message-ID: <1444000510.26489.4.camel@collabora.com>
Subject: Re: v4l2 api: supported resolution negotiation
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reply-To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
	"Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Cc: linux-media@vger.kernel.org
Date: Mon, 05 Oct 2015 00:15:10 +0100
In-Reply-To: <20151004184923.GH26916@valkosipuli.retiisi.org.uk>
References: <muqr5s$f1j$2@ger.gmane.org>
	 <20151004184923.GH26916@valkosipuli.retiisi.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-hzoCk09FxsH2V1UbXGyY"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-hzoCk09FxsH2V1UbXGyY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le dimanche 04 octobre 2015 =C3=A0 21:49 +0300, Sakari Ailus a =C3=A9crit :
> I think the GStreamer
> v4lsrc tries very small and very large values. The driver will clamp
> them to
> a supported values which are passed to the application from the
> IOCTL.

In GStreamer we try ENUM_FRAMESIZE, and when no supported, we fallback
to try_fmt() with 1x1 (driver will raise it to the minimum) and then
MAX,MAX (driver will lower it to the maximum). We assume that the
driver supports a range, as iterating over all possibilities takes too
much time.

Nicolas
--=-hzoCk09FxsH2V1UbXGyY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEABECAAYFAlYRsv4ACgkQcVMCLawGqByZZgCfe7p+fVc8U1roa3/Q4Gh75jpq
8asAn2bvg+Tew3kEEkvXWgmqPJSEv96b
=bcQU
-----END PGP SIGNATURE-----

--=-hzoCk09FxsH2V1UbXGyY--

