Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:46144 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbeHWVIN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Aug 2018 17:08:13 -0400
Received: by mail-qk0-f180.google.com with SMTP id j7-v6so4132721qkd.13
        for <linux-media@vger.kernel.org>; Thu, 23 Aug 2018 10:37:27 -0700 (PDT)
Message-ID: <f4d1e18a6552446b092cffaa3028e0dfe5432b9a.camel@ndufresne.ca>
Subject: Re: [RFC] Request API and V4L2 capabilities
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Date: Thu, 23 Aug 2018 13:37:24 -0400
In-Reply-To: <b46ee744-4c00-7e73-1925-65f2122e30f0@xs4all.nl>
References: <621896b1-f26e-3239-e7e7-e8c9bc4f3fe8@xs4all.nl>
         <b46ee744-4c00-7e73-1925-65f2122e30f0@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-563f/p2b4oZSJVthBc45"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-563f/p2b4oZSJVthBc45
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 23 ao=C3=BBt 2018 =C3=A0 16:31 +0200, Hans Verkuil a =C3=A9crit :
> > I propose adding these capabilities:
> >=20
> > #define V4L2_BUF_CAP_HAS_REQUESTS     0x00000001
> > #define V4L2_BUF_CAP_REQUIRES_REQUESTS        0x00000002
> > #define V4L2_BUF_CAP_HAS_MMAP         0x00000100
> > #define V4L2_BUF_CAP_HAS_USERPTR      0x00000200
> > #define V4L2_BUF_CAP_HAS_DMABUF               0x00000400
>=20
> I substituted SUPPORTS for HAS and dropped the REQUIRES_REQUESTS capabili=
ty.
> As Tomasz mentioned, technically (at least for stateless codecs) you coul=
d
> handle just one frame at a time without using requests. It's very ineffic=
ient,
> but it would work.

I thought the request was providing a data structure to refer back to
the frames, so each codec don't have to implement one. Do you mean that
the framework will implicitly request requests in that mode ? or simply
that there is no such helper ?

--=-563f/p2b4oZSJVthBc45
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCW37w1AAKCRBxUwItrAao
HMsmAJ98lwNYgd4fk0Mk13FqBr0Vo0lY7QCeI6X5vdzloQSEa1tDdDHZgO6wq7Q=
=jvyy
-----END PGP SIGNATURE-----

--=-563f/p2b4oZSJVthBc45--
