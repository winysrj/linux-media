Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:35949 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965603AbbBCNBp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 08:01:45 -0500
Received: by mail-wg0-f50.google.com with SMTP id b13so44307246wgh.9
        for <linux-media@vger.kernel.org>; Tue, 03 Feb 2015 05:01:43 -0800 (PST)
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 2/5] radio-bcm2048: use unlocked_ioctl instead of ioctl
Date: Tue, 3 Feb 2015 14:01:41 +0100
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	isely@isely.net, Hans Verkuil <hans.verkuil@cisco.com>
References: <1422967646-12223-1-git-send-email-hverkuil@xs4all.nl> <1422967646-12223-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1422967646-12223-3-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1905387.RyhPWnG3sC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201502031401.41945@pali>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart1905387.RyhPWnG3sC
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 03 February 2015 13:47:23 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> This driver does its own locking, so there is no need to use
> ioctl instead of unlocked_ioctl.
>=20
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Looks good,
Acked-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1905387.RyhPWnG3sC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlTQxrUACgkQi/DJPQPkQ1LLQwCfVO33gByl5Hy0FFY39suEYENa
4wYAnjeXeKFEjV5o5Rwcmo0yB8sfk5NO
=EpxA
-----END PGP SIGNATURE-----

--nextPart1905387.RyhPWnG3sC--
