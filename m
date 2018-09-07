Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:45021 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727856AbeIGTfy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Sep 2018 15:35:54 -0400
Date: Fri, 7 Sep 2018 16:54:36 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Tomasz Figa <tfiga@chromium.org>
Subject: Re: [RFP] Stateless Codec Userspace Support
Message-ID: <20180907145436.fwzudpefpv3e7i37@flea>
References: <ae73ad59-af82-040c-ec89-b8defd8e312c@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vsqgy4jzq3mieubo"
Content-Disposition: inline
In-Reply-To: <ae73ad59-af82-040c-ec89-b8defd8e312c@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--vsqgy4jzq3mieubo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 07, 2018 at 04:34:45PM +0200, Hans Verkuil wrote:
> Support for stateless codecs and Request API will hopefully be merged for
> 4.20, and the next step is to discuss how to organize the userspace suppo=
rt.
>=20
> Hopefully by the time the media summit starts we'll have some better ideas
> of what we want in this area.
>=20
> Some userspace support is available from bootlin for the cedrus driver:
>=20
>   - v4l2-request-test, that has a bunch of sample frames for various
>     codecs and will rely solely on the kernel request api (and DRM for
>     the display part) to test and bringup a particular driver
>     https://github.com/bootlin/v4l2-request-test
>=20
>   - libva-v4l2-request, that is a libva implementation using the
>     request API
>     https://github.com/bootlin/libva-v4l2-request
>=20
> But this is more geared towards testing and less a 'proper' implementatio=
n.

While the first one is definitely a test tool, I wouldn't consider the
latter as such. We have Kodi and VLC running with it, and we started
to work on using gstreamer on top of it, so it's definitely something
I would consider for real world use cases.

Maxime

--=20
Maxime Ripard, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--vsqgy4jzq3mieubo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAluSkSsACgkQ0rTAlCFN
r3QDQw//cooMu208s1dqtoAM517Ds856l4BjnU8ck2gFdaRxUf+unwge3tfUsLfq
GOMop+j9p57g7CM+dNgdUNEUTz9YsmIqjVPUjWU8s0HfHkRdUhINdZsWLOOzFVTi
4J7wT3hlIxfAub0Lvw5gpcqtIO6/Yc0FmiqL/Z/Op1JT9Cjs+0MTDmuKJl6Gw+rP
HPu8v76BnNagBrhFCvmVig1/21th32laGARqy20hE8LV5oX3iG3VygqWtZ6i4AQl
cF0cuhdbga+m3fBXAAagSDlLIGNbli08epXn+GKN4QPUhjnjojRqplKGZz97DUzz
36lk7q8VjZ1wr1HRh/+B2Kd8jUHToXRVKPnEo6Hzy/UlYUhlc6g52LpnpG9MzTCk
9W2hPlWmcFMdQuAz+ahVS5Y3I7cpH1N+nnUTxNhK7ipAxFSgljczoGxSuVLrIWmT
ZyGzB4bM496dm/x9d7quzdpouRgRGrcHy1cohbIy3JWcR793TAgaP1LRkLWX0x9I
k+NwZK3bOELxzOpJz3xNIdMZunAXswGvWWfQ2Nd6Blmqj4StCtghL9BMgLlo4J0F
3e0xwMdOu71iW8Y6AJySCNdJa6oKvgFi1hVNPXXr3D9l1qKHPzma+8/32tt8sdEn
ql/M92lLA5kgErubREe0XgjIU40+Ayc96RxEZzvl72mAuuEFY4I=
=J57x
-----END PGP SIGNATURE-----

--vsqgy4jzq3mieubo--
