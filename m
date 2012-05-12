Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35510 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab2ELDJV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 23:09:21 -0400
Received: by pbbrp8 with SMTP id rp8so3997099pbb.19
        for <linux-media@vger.kernel.org>; Fri, 11 May 2012 20:09:20 -0700 (PDT)
Date: Sat, 12 May 2012 00:08:58 -0300
From: Ismael Luceno <ismael.luceno@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] au0828: Move under dvb
Message-ID: <20120512000858.3d9e41a8@pirotess>
In-Reply-To: <CAGoCfiydH48uY86w3oHbRDoJddX5qS1Va7vo4-vXwAn9JeSaaQ@mail.gmail.com>
References: <1336716892-5446-1-git-send-email-ismael.luceno@gmail.com>
	<1336716892-5446-2-git-send-email-ismael.luceno@gmail.com>
	<CAGoCfiydH48uY86w3oHbRDoJddX5qS1Va7vo4-vXwAn9JeSaaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/byIbRX50odxejSG2SKJj=tD"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/byIbRX50odxejSG2SKJj=tD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 11 May 2012 08:04:59 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> wrote:
...=20
> What is the motivation for moving these files?

Well, the device was on the wrong Kconfig section, and while thinking
about changing that, I just thought to move it under DVB.

> The au0828 is a hybrid bridge, and every other hybrid bridge is
> under video?

Sorry, the devices I got don't support analog, so I didn't thought
about it that much...

I guess it's arbitrary... isn't it? wouldn't it be better to have an
hybrid section? (just thinking out loud)

--Sig_/byIbRX50odxejSG2SKJj=tD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJPrdRKAAoJEBH/VE8bKTLbRb0IAOESSk07CFiqb5KORSuwe68B
MBW/8FE261K5KvPExN5/9r1gE35NPk8JVEPtFp3r3trwj+sOZcttBUgrTXfUp59x
vgiwwhL+u32V4U/H/dnGJPOwO8VFtcOZYvFOVzfqOeiyMdeFkiiLXgAdZ+tIxcPG
bgebzPXbUXTJM5cvjbReTz4Bc0SVaTxM/uyZIhSNd8CIpsTidpBDkaT69EUkjJKo
2X98TErJrk9cRdhZXbj55KC/rLfzsfAGGGz0bKAwIOf0UKCY1wlXJa1AElbu4eBY
kh+gfRDwZODodSU79p2cWi86kUjSPI6qY5aBN6KLxJaQIR3uuousDkuSJFVyPEE=
=YBav
-----END PGP SIGNATURE-----

--Sig_/byIbRX50odxejSG2SKJj=tD--
