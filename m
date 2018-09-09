Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f43.google.com ([209.85.166.43]:45944 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbeIIFhG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Sep 2018 01:37:06 -0400
Received: by mail-io1-f43.google.com with SMTP id e12-v6so4306010iok.12
        for <linux-media@vger.kernel.org>; Sat, 08 Sep 2018 17:49:27 -0700 (PDT)
Received: from eggsbenedict.adamsnet (24-220-35-37-dynamic.midco.net. [24.220.35.37])
        by smtp.gmail.com with ESMTPSA id u6-v6sm5040062itg.27.2018.09.08.17.49.24
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Sep 2018 17:49:24 -0700 (PDT)
Date: Sat, 8 Sep 2018 20:49:22 -0400
From: Adam Stylinski <kungfujesus06@gmail.com>
To: linux-media@vger.kernel.org
Subject: 4.18 regression
Message-ID: <20180909004922.GA9322@eggsbenedict.adamsnet>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

I haven't done a thorough bisection of kernel revisions, but moving from kernel 4.17.19 to 4.18.6 results in mythtv being unable to tune in any channel with a pic hdtv 5500 tuner (cx88 based device with an LG frontend). I get an error back from the channel scanner about not being able to measure signal strength and getting back an error unknown (errno 254).

I was able to use dvbtools with get-atsc to get a channel, but I don't think any of the forward error correction was applied to it.

Let me know if you need more details.

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEDgVoSkwBBLuwA/n/PqxEcTpO+acFAluUbhAACgkQPqxEcTpO
+aeC4BAA4j5jJcpiEFT4msIj6/BllRDqEXslpCX7XuombPQ0n0LBRPXUidAfg64J
KpA1lw/Mfj6V0IPdyB2GDFeRJWuBWEQLg/O79G2oH5G2gdc7FEn8/NK7uonEQN5R
fbNBqdm1LrhYd8wL+SvsiL+STDLgEYJzlDDvFyWwAuIpPQdyn6qkPVH2A1x4qtXa
5WFHb6NrTUCsh+DiBTzjkpT/Rd6GN193HUy2D1kvKMVHryOIDc+FT6bWvIrNc5Rb
S+8QqNAVToUwtZY/SX1qMbqvaN8Wfc/v21nBFJX9o7FPNESn43e8Fai/Nov+XzEE
buM0wOwBOrQIWC8Hu5j01FneTTcs/kQmHXpc7Rp8MKXBu1dJMwytrLyIfhNRPJgR
k/l44/w1eE6XTMlqkUlaaO54Mue0bx+sCx0D3et/5ZHTrwn6TiGRX4vmkCznHk7c
F1ivaaSIBSJSQwQPc3OmiPocJ7M0o0GJIpXV2DcUhiUoN9lZX8A/y4AoLfEESAgX
Xww7nDJTmaYkRIOhBTdmt4ObGtcjORhdC/r80qhZ/zDlEpygXyA8MQZ5TYa6nosF
diZP9r7mYEJMX3IIeDQhk9E6IJE1u7u8ALiLGFwUzQSZJvseN7EZ25KO0cbFcZqo
1HIkwE3JR347Yw8bC/PjJ5KZFj4yMyEyiiFRGSCXAB1FT5eJiug=
=w121
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
