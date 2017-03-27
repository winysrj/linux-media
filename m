Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:36263 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751830AbdC0CTH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Mar 2017 22:19:07 -0400
Received: by mail-it0-f49.google.com with SMTP id e75so6466049itd.1
        for <linux-media@vger.kernel.org>; Sun, 26 Mar 2017 19:18:54 -0700 (PDT)
Message-ID: <1490581130.25828.1.camel@ndufresne.ca>
Subject: Re: [PATCH v7 5/9] media: venus: vdec: add video decoder files
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Sun, 26 Mar 2017 22:18:50 -0400
In-Reply-To: <be41ccbd-3ff1-bcae-c423-1acc68f35694@mm-sol.com>
References: <1489423058-12492-1-git-send-email-stanimir.varbanov@linaro.org>
         <1489423058-12492-6-git-send-email-stanimir.varbanov@linaro.org>
         <52b39f43-6f70-0cf6-abaf-4bb5bd2b3d86@xs4all.nl>
         <be41ccbd-3ff1-bcae-c423-1acc68f35694@mm-sol.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-jyE4rSxhV39lSKPWDmMZ"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-jyE4rSxhV39lSKPWDmMZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le dimanche 26 mars 2017 =C3=A0 00:30 +0200, Stanimir Varbanov a =C3=A9crit=
=C2=A0:
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0vb->planes[0].data_offset =3D data_offset;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0vb->timestamp =3D timestamp_us * NSEC_PER_USEC;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0vbuf->sequence =3D inst->sequence++;
> >=20
> > timestamp and sequence are only set for CAPTURE, not OUTPUT. Is
> > that correct?
>=20
> Correct. I can add sequence for the OUTPUT queue too, but I have no idea=
=C2=A0
> how that sequence is used by userspace.

Neither GStreamer or Chromium seems to use it. What does that number
means for a m2m driver ? Does it really means something ?

Nicolas
--=-jyE4rSxhV39lSKPWDmMZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAljYdooACgkQcVMCLawGqBze2QCgskb1DFeAkW98ATblzUT5uzkq
lwsAoNYuE5zzWKAnMHs4KqE+clJjHKhf
=ugCC
-----END PGP SIGNATURE-----

--=-jyE4rSxhV39lSKPWDmMZ--
