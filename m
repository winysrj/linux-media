Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:33653 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751824AbdHaQNC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 12:13:02 -0400
Received: by mail-qt0-f178.google.com with SMTP id e2so516488qta.0
        for <linux-media@vger.kernel.org>; Thu, 31 Aug 2017 09:13:02 -0700 (PDT)
Message-ID: <1504195978.18413.14.camel@ndufresne.ca>
Subject: Re: DRM Format Modifiers in v4l2
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Brian Starkey <brian.starkey@arm.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Daniel Vetter <daniel@ffwll.ch>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        jonathan.chai@arm.com, dri-devel <dri-devel@lists.freedesktop.org>
Date: Thu, 31 Aug 2017 12:12:58 -0400
In-Reply-To: <4559442.sz5HF0f0o4@avalon>
References: <20170821155203.GB38943@e107564-lin.cambridge.arm.com>
         <47128f36-2990-bd45-ead9-06a31ed8cde0@xs4all.nl>
         <20170824111430.GB25711@e107564-lin.cambridge.arm.com>
         <4559442.sz5HF0f0o4@avalon>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-e06+oLvaIJbxwjp5iysk"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-e06+oLvaIJbxwjp5iysk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le jeudi 31 ao=C3=BBt 2017 =C3=A0 17:28 +0300, Laurent Pinchart a =C3=A9cri=
t :
> > e.g. if I have two devices which support MODIFIER_FOO, I could attempt
> > to share a buffer between them which uses MODIFIER_FOO without
> > necessarily knowing exactly what it is/does.
>=20
> Userspace could certainly set modifiers blindly, but the point of modifie=
rs is=20
> to generate side effects benefitial to the use case at hand (for instance=
 by=20
> optimizing the memory access pattern). To use them meaningfully userspace=
=20
> would need to have at least an idea of the side effects they generate.

Generic userspace will basically pick some random combination. To allow
generically picking the optimal configuration we could indeed rely on
the application knowledge, but we could also enhance the spec so that
the order in the enumeration becomes meaningful.

regards,
Nicolas
--=-e06+oLvaIJbxwjp5iysk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWag1igAKCRBxUwItrAao
HDlyAKCOvBbltiRlQ1eyqv1p8Y0W9U25ZACgqH0BXuuHY5IdrY+WID43m+7Ij0w=
=I09b
-----END PGP SIGNATURE-----

--=-e06+oLvaIJbxwjp5iysk--
