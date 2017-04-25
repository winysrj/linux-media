Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:36169 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1432000AbdDYQzb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 12:55:31 -0400
Received: by mail-it0-f51.google.com with SMTP id g66so22902861ite.1
        for <linux-media@vger.kernel.org>; Tue, 25 Apr 2017 09:55:30 -0700 (PDT)
Message-ID: <1493139327.19105.18.camel@ndufresne.ca>
Subject: Re: support autofocus / autogain in libv4l2
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Date: Tue, 25 Apr 2017 12:55:27 -0400
In-Reply-To: <20170425113009.GH30553@pali>
References: <20170414232332.63850d7b@vento.lan>
         <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
         <20170419105118.72b8e284@vento.lan> <20170424093059.GA20427@amd>
         <20170424103802.00d3b554@vento.lan> <20170424212914.GA20780@amd>
         <20170424224724.5bb52382@vento.lan> <20170425080538.GA30380@amd>
         <20170425080815.GD30553@pali> <20170425112330.GB7926@amd>
         <20170425113009.GH30553@pali>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-qEu/nOczlZh9av2AKbph"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-qEu/nOczlZh9av2AKbph
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 25 avril 2017 =C3=A0 13:30 +0200, Pali Roh=C3=A1r a =C3=A9crit=C2=
=A0:
> Pinos (renamed from PulseVideo)
>=20
> https://blogs.gnome.org/uraeus/2015/06/30/introducing-pulse-video/
> https://cgit.freedesktop.org/~wtay/pinos/
>=20
> But from git history it looks like it is probably dead now...

This is also incorrect. See "work" branch. It is still a one man show,
code being aggressively re-factored. I suspect this will be the case
until the "form" is considered acceptable.

Nicolas
--=-qEu/nOczlZh9av2AKbph
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlj/f38ACgkQcVMCLawGqBwVAQCfS6qEWMNHWTaU8NMZbz8uXZgY
pHAAoK/yCBvUtG3newOaIry9Z3YP8RF/
=TFSG
-----END PGP SIGNATURE-----

--=-qEu/nOczlZh9av2AKbph--
