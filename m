Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.andi.de1.cc ([85.214.239.24]:54303 "EHLO
        h2641619.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751791AbdEDUSi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 May 2017 16:18:38 -0400
Date: Thu, 4 May 2017 22:18:19 +0200
From: Andreas Kemnade <andreas@kemnade.info>
To: crope@iki.fi, mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [media] af9035: init i2c already in
 it930x_frontend_attach
Message-ID: <20170504221819.0aac4a73@aktux>
In-Reply-To: <1489616530-4025-3-git-send-email-andreas@kemnade.info>
References: <1489616530-4025-1-git-send-email-andreas@kemnade.info>
        <1489616530-4025-3-git-send-email-andreas@kemnade.info>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/V_WIvYnabTwkrsfbGqzy8+r"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/V_WIvYnabTwkrsfbGqzy8+r
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Mar 2017 23:22:09 +0100
Andreas Kemnade <andreas@kemnade.info> wrote:

> i2c bus is already needed when the frontend is probed,
> so init it already in it930x_frontend_attach
> That prevents errors like
>      si2168: probe of 6-0067 failed with error -5
>=20
> Signed-off-by: Andreas Kemnade <andreas@kemnade.info>

seems to be also needed for the
CINERGY TC2 Stick
Quoting from=20
https://www.linuxmintusers.de/index.php?topic=3D41074.30

Mar 26 12:44:14 minimoose kernel: [=C2=A0 732.884876] usb 1-3: dvb_usb_v2: =
found a 'TerraTec Cinergy TC2 Stick' in warm state
Mar 26 12:44:14 minimoose kernel: [=C2=A0 732.885012] usb 1-3: dvb_usb_v2: =
will pass the complete MPEG2 transport stream to the software demuxer
Mar 26 12:44:14 minimoose kernel: [=C2=A0 732.885245] dvbdev: DVB: register=
ing new adapter (TerraTec Cinergy TC2 Stick)
Mar 26 12:44:14 minimoose kernel: [=C2=A0 732.885254] usb 1-3: media contro=
ller created
Mar 26 12:44:14 minimoose kernel: [=C2=A0 732.886117] dvbdev: dvb_create_me=
dia_entity: media entity 'dvb-demux' registered.
Mar 26 12:44:14 minimoose kernel: [=C2=A0 732.890589] si2168: probe of 8-00=
67 failed with error -5


Regards,
Andreas Kemnade

--Sig_/V_WIvYnabTwkrsfbGqzy8+r
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJZC4yWAAoJEInxNTv1CwY0wCEP/1Sj2LV6vAf4bZqn2w8w3QiY
IUsAS6F3dDlClwnEgBQyz9v1nJXfIZK4fXK4d0AG1u1y2pOAAXWt3XIGBFKq1PUU
7hqT/zzaxgc0/3eE31jkW47s+nhUvLoFHaxT+yqN03rs7l4cGtYZbsW1nQle2ZuH
PomUl+HAuk/kmEFnBq7Djh7s6TO4l18pQsXx+9EXQRKznzKonUZpNKSc7avg6Vng
5Z1znKHu3sFuYujNhQQbgCNXJYNrMejQNrgXXhlQbGGL01ntjHfaTjFQSYlFvO34
zs5S0oEAifXGQ80gF3MWjLxgvmOdBivRQnQ2Aiuj7TB45xaxUcCJBR2GjIrvSku5
k7fwXsSVI5yP8s7dtawRzzPrzk0jfXU0KH2pNNjODSsNzRJafSyFx20nZj47DGMd
lwr6kVW4TMGnxlmq4fOmNOeBeujpEttf3RPa0cMUtohhhwD1BSmJsy/Jk0zG62+E
89TbY9PgHrjcBrzs/OyfJ4uzIGyKEDrNTqgLcI4XWaMl2rQ/MIYkt3rEaA8aXEZR
AMX6eiovoZsGtm3623s3I9Lf/9GI/puXwwloj7wRhAknrXRXlkIcm2Nk3wi8t3om
kyZjNTdlIVRHgfIF88WMd2blMZ7vOGj8ufMfaLTWu7wWyuTVFNM01thCskY6hAYV
7xGoLlr62ifEjqozKUAk
=xU8p
-----END PGP SIGNATURE-----

--Sig_/V_WIvYnabTwkrsfbGqzy8+r--
