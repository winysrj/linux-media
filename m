Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:36284 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751543AbdFIPiY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Jun 2017 11:38:24 -0400
Received: by mail-it0-f43.google.com with SMTP id m47so138705607iti.1
        for <linux-media@vger.kernel.org>; Fri, 09 Jun 2017 08:38:24 -0700 (PDT)
Message-ID: <1497022700.2672.8.camel@ndufresne.ca>
Subject: Re: [RFC 00/10] V4L2 explicit synchronization support
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Date: Fri, 09 Jun 2017 11:38:20 -0400
In-Reply-To: <bafe3f9d-cdf4-bb22-b9c8-fe3f677d289c@osg.samsung.com>
References: <20170313192035.29859-1-gustavo@padovan.org>
         <20170403081610.16a2a3fc@vento.lan>
         <bafe3f9d-cdf4-bb22-b9c8-fe3f677d289c@osg.samsung.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-uZiEEP4heuVQbJso6uy0"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-uZiEEP4heuVQbJso6uy0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lundi 03 avril 2017 =C3=A0 15:46 -0400, Javier Martinez Canillas a
=C3=A9crit=C2=A0:
> > The problem is that adding implicit fences changed the behavior of
> > the ioctls, causing gstreamer to wait forever for buffers to be ready.
> >=20
>=20
> The problem was related to trying to make user-space unaware of the impli=
cit
> fences support, and so it tried to QBUF a buffer that had already a pendi=
ng
> fence. A workaround was to block the second QBUF ioctl if the buffer had =
a
> pending fence, but this caused the mentioned deadlock since GStreamer was=
n't
> expecting the QBUF ioctl to block.

That QBUF may block isn't a problem, but modern userspace application,
not just GStreamer, need "cancellable" operations. This is achieved by
avoiding blocking call that cannot be interrupted. What is usually
done, is that we poll the device FD to determine when it is safe to
call QBUF in a way that it will return in a finit amount of time. For
the implicit fence, it could not work, since the driver is not yet
aware of the fence, hence cannot use it to delay the poll operation.
Though, it's not clear why it couldn't wait asynchronously like this
RFC is doing with the explicit fences.

In the current RFC, the fences are signalled through a callback, and
QBUF is split in half. So waiting on the fence is done elsewhere, and
the qbuf operation completes on the fence callback thread.

Nicolas=20
--=-uZiEEP4heuVQbJso6uy0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlk6wOwACgkQcVMCLawGqByE0ACfYkrL4zo6DYn1y4sPYs5suvyh
0E0AoMZ+yVHfhXPn3D1p/EF5fXg8JTRj
=Pvl7
-----END PGP SIGNATURE-----

--=-uZiEEP4heuVQbJso6uy0--
