Return-path: <mchehab@pedra>
Received: from smtp208.alice.it ([82.57.200.104]:60935 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab0KIPdw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 10:33:52 -0500
Date: Tue, 9 Nov 2010 16:33:25 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] v4l: Remove module_name argument to the
 v4l2_i2c_new_subdev* functions
Message-Id: <20101109163325.3b706714.ospite@studenti.unina.it>
In-Reply-To: <1289316628-9394-3-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1289316628-9394-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<1289316628-9394-3-git-send-email-laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Nov_2010_16_33_25_+0100_84U2bUdJm8X8SD1D"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--Signature=_Tue__9_Nov_2010_16_33_25_+0100_84U2bUdJm8X8SD1D
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue,  9 Nov 2010 16:30:28 +0100
Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:

> The argument isn't used anymore by the functions, remote it.

s/remote/remove/

Regards,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?

--Signature=_Tue__9_Nov_2010_16_33_25_+0100_84U2bUdJm8X8SD1D
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkzZacUACgkQ5xr2akVTsAFdIQCfVIqMMD8J7/zVUkepNBAZLTG1
x44AnRzFhS011NNlMAIPJX0F2rEYXrC8
=wWmc
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Nov_2010_16_33_25_+0100_84U2bUdJm8X8SD1D--
