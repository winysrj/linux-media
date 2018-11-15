Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41911 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbeKPC6c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 21:58:32 -0500
Received: by mail-qk1-f196.google.com with SMTP id 189so32805367qkj.8
        for <linux-media@vger.kernel.org>; Thu, 15 Nov 2018 08:49:56 -0800 (PST)
Message-ID: <463ac42b795933a54daa8d2bbba3ff1ac2b733db.camel@ndufresne.ca>
Subject: Re: [PATCH] media: venus: fix reported size of 0-length buffers
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 15 Nov 2018 11:49:53 -0500
In-Reply-To: <CAPBb6MWJ1Qu9YoRRusOGiC7dioMkgvU=1dCF6XZ4xDUxp7ri9A@mail.gmail.com>
References: <20181113093048.236201-1-acourbot@chromium.org>
         <CAKQmDh-91tHP1VxLisW1A3GR9G7du3F-Y2XrrgoFU=gvhGoP6w@mail.gmail.com>
         <CAPBb6MWJ1Qu9YoRRusOGiC7dioMkgvU=1dCF6XZ4xDUxp7ri9A@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-6S0umYBXH8V0Ck7nbbNE"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-6S0umYBXH8V0Ck7nbbNE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mercredi 14 novembre 2018 =C3=A0 13:12 +0900, Alexandre Courbot a =C3=A9=
crit :
> On Wed, Nov 14, 2018 at 3:54 AM Nicolas Dufresne <nicolas@ndufresne.ca> w=
rote:
> >=20
> >=20
> > Le mar. 13 nov. 2018 04 h 30, Alexandre Courbot <acourbot@chromium.org>=
 a =C3=A9crit :
> > > The last buffer is often signaled by an empty buffer with the
> > > V4L2_BUF_FLAG_LAST flag set. Such buffers were returned with the
> > > bytesused field set to the full size of the OPB, which leads
> > > user-space to believe that the buffer actually contains useful data. =
Fix
> > > this by passing the number of bytes reported used by the firmware.
> >=20
> > That means the driver does not know on time which one is last. Why not =
just returned EPIPE to userspace on DQBUF and ovoid this useless roundtrip =
?
>=20
> Sorry, I don't understand what you mean. EPIPE is supposed to be
> returned after a buffer with V4L2_BUF_FLAG_LAST is made available for
> dequeue. This patch amends the code that prepares this LAST-flagged
> buffer. How could we avoid a roundtrip in this case?

Maybe it has changed, but when this was introduced, we found that some
firmware (Exynos MFC) could not know which one is last. Instead, it
gets an event saying there will be no more buffers.

Sending buffers with payload size to 0 just for the sake of setting the
V4L2_BUF_FLAG_LAST was considered a waste. Specially that after that,
every polls should return EPIPE. So in the end, we decided the it
should just unblock the userspace and return EPIPE.

If you look at the related GStreamer code, it completely ignores the
LAST flag. With fake buffer of size 0, userspace will endup dequeuing
and throwing away. This is not useful to the process of terminating the
decoding. To me, this LAST flag is not useful in this context.

Nicolas

--=-6S0umYBXH8V0Ck7nbbNE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCW+2jsgAKCRBxUwItrAao
HCgqAKCnBb2eMP0cPmS+6Ou7ivPc9pPkyQCgxqkUwibgiWW3BLK4Dr3dRV6WVN4=
=DhZl
-----END PGP SIGNATURE-----

--=-6S0umYBXH8V0Ck7nbbNE--
