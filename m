Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:36276 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbdBAB2z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 20:28:55 -0500
Received: by mail-io0-f193.google.com with SMTP id q20so19584807ioi.3
        for <linux-media@vger.kernel.org>; Tue, 31 Jan 2017 17:28:55 -0800 (PST)
Message-ID: <1485912532.27233.4.camel@ndufresne.ca>
Subject: Re: rtl2832_sdr and /dev/swradio0
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Russel Winder <russel@winder.org.uk>,
        DVB_Linux_Media <linux-media@vger.kernel.org>
Date: Tue, 31 Jan 2017 20:28:52 -0500
In-Reply-To: <1485885027.10632.13.camel@winder.org.uk>
References: <1485885027.10632.13.camel@winder.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-oOs8WcsmaZneLerDjLSv"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-oOs8WcsmaZneLerDjLSv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 31 janvier 2017 =C3=A0 17:50 +0000, Russel Winder a =C3=A9crit=C2=
=A0:
> Hi,
>=20
> Is anyone actively working on the rtl2832_sdr driver?
>=20
> I am particularly interested in anyone who has code for turning the
> byte stream from /dev/swradio0 into an ETI stream. Or failing that
> getting enough data about the API for using /dev/swradio0 so as to
> write a byte sequence to ETI driver based on the dab2eti program in
> DABtool (which uses the librtlsdr mechanism instead of the
> /dev/swradio0 one).

This device works like any V4L2 driver, with the differences explained
here:

https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/dev-sdr.html

For the rest I'm no expert. You can probably port dab2eti to use this
interface instead of librtlsdr and keep the rest. You may be able to
skip an fft if your driver supports it, otherwise you'll get RU12, that
you'll probably have to convert to floats before passing to the rest of
the processing code.

regards,
Nicolas
--=-oOs8WcsmaZneLerDjLSv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAliROdQACgkQcVMCLawGqBxTUwCfRi/PAFqykdd0HmXGqJ+8Sghd
vo8An1fnZnZHH28wN5kfFoMsHFiw6XdY
=KgoO
-----END PGP SIGNATURE-----

--=-oOs8WcsmaZneLerDjLSv--

