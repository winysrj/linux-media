Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:33711 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965487AbeAJQoU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Jan 2018 11:44:20 -0500
Received: by mail-qk0-f172.google.com with SMTP id i141so2247697qke.0
        for <linux-media@vger.kernel.org>; Wed, 10 Jan 2018 08:44:20 -0800 (PST)
Message-ID: <1515602656.5266.15.camel@ndufresne.ca>
Subject: Re: [PATCH v7 0/6] V4L2 Explicit Synchronization
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Date: Wed, 10 Jan 2018 11:44:16 -0500
In-Reply-To: <20180110160732.7722-1-gustavo@padovan.org>
References: <20180110160732.7722-1-gustavo@padovan.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-pGVNhnL6838h6CCK7gTP"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-pGVNhnL6838h6CCK7gTP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 10 janvier 2018 =C3=A0 14:07 -0200, Gustavo Padovan a =C3=A9cri=
t :
> v7 bring a fix for a crash when not using fences and a uAPI fix.
> I've done a bit more of testing on it and also measured some
> performance. On a intel laptop a DRM<->V4L2 pipeline with fences is
> runnning twice as faster than the same pipeline with no fences.

What does it mean twice faster here ?

Nicolas
--=-pGVNhnL6838h6CCK7gTP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWlZC4AAKCRBxUwItrAao
HBkPAKDIl+ctr9WaE2IRpXm/nb7SroytGQCghjWle1edOls8KwjIQJaRaFGmeQw=
=cK8y
-----END PGP SIGNATURE-----

--=-pGVNhnL6838h6CCK7gTP--
