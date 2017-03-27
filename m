Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:35126 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752979AbdC0O7T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 10:59:19 -0400
Received: by mail-it0-f49.google.com with SMTP id y18so76824014itc.0
        for <linux-media@vger.kernel.org>; Mon, 27 Mar 2017 07:59:04 -0700 (PDT)
Message-ID: <1490626683.5935.18.camel@ndufresne.ca>
Subject: Re: [PATCH v7 5/9] media: venus: vdec: add video decoder files
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Mon, 27 Mar 2017 10:58:03 -0400
In-Reply-To: <6ea4524d-9794-a9b5-8327-367152c92493@xs4all.nl>
References: <1489423058-12492-1-git-send-email-stanimir.varbanov@linaro.org>
         <1489423058-12492-6-git-send-email-stanimir.varbanov@linaro.org>
         <52b39f43-6f70-0cf6-abaf-4bb5bd2b3d86@xs4all.nl>
         <be41ccbd-3ff1-bcae-c423-1acc68f35694@mm-sol.com>
         <6ea4524d-9794-a9b5-8327-367152c92493@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-hJgOGKCnhgucUo3AG8si"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-hJgOGKCnhgucUo3AG8si
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lundi 27 mars 2017 =C3=A0 10:45 +0200, Hans Verkuil a =C3=A9crit=C2=A0:
> > > timestamp and sequence are only set for CAPTURE, not OUTPUT. Is
> > > that correct?
> >=20
> > Correct. I can add sequence for the OUTPUT queue too, but I have no
> > idea how that sequence is used by userspace.
>=20
> You set V4L2_BUF_FLAG_TIMESTAMP_COPY, so you have to copy the
> timestamp from the output buffer
> to the capture buffer, if that makes sense for this codec. If not,
> then you shouldn't use that
> V4L2_BUF_FLAG and just generate new timestamps whenever a capture
> buffer is ready.
>=20
> For sequence numbering just give the output queue its own sequence
> counter.

Btw, GStreamer and Chromium only supports TIMESTAMP_COPY, and will most
likely leak frames if you craft timestamp.

Nicolas
--=-hJgOGKCnhgucUo3AG8si
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAljZKHsACgkQcVMCLawGqByoUgCbBp7XbvkFYcKl9sYQ2TdzP1LE
mRwAnjUd2J0Bf3baPl+9SXDQa8YZAXkL
=k7fQ
-----END PGP SIGNATURE-----

--=-hJgOGKCnhgucUo3AG8si--
