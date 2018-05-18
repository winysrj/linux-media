Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:43022 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751588AbeEROWv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 10:22:51 -0400
Received: by mail-qt0-f173.google.com with SMTP id f13-v6so10444298qtp.10
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 07:22:50 -0700 (PDT)
Message-ID: <f2d8be6e6a1754afc253be816a0307f46c957b59.camel@ndufresne.ca>
Subject: Re: [ANN] Meeting to discuss improvements to support MC-based
 cameras on generic apps
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        LMML <linux-media@vger.kernel.org>,
        Wim Taymans <wtaymans@redhat.com>, schaller@redhat.com
Date: Fri, 18 May 2018 10:22:47 -0400
In-Reply-To: <3216261.G88TfqiCiH@avalon>
References: <20180517160708.74811cfb@vento.lan>
         <644920d91d1f69d659f233c6a52382d3f919babc.camel@ndufresne.ca>
         <3216261.G88TfqiCiH@avalon>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-CqkNEleeL8uqGtEGyA8P"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-CqkNEleeL8uqGtEGyA8P
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le vendredi 18 mai 2018 =C3=A0 11:15 +0300, Laurent Pinchart a =C3=A9crit :
> > I need to clarify a little bit on why we disabled libv4l2 in
> > GStreamer,
> > as it's not only for performance reason, there is couple of major
> > issues in the libv4l2 implementation that get's in way. Just a
> > short
> > list:
> >=20
> >=20
>=20
> Do you see any point in that list that couldn't be fixed in libv4l ?

Sure, most of it is features being added into the kernel uAPI but not
added to the emulation layer. But appart from that, libv4l will only
offer legacy use case, we need to think how generic userspace will be
able to access these camera, and leverage the per request controls,
multi-stream, etc. features. This is mostly what Android Camera HAL2
does (and it does it well), but it won't try and ensure this stays Open
Source in any ways. I would not mind if Android Camera HAL2 leads the
way, and a facilitator (something that does 90% of the work if you have
a proper Open Source driver) would lead the way in getting more OSS
drivers submitted.

> >    - Crash when CREATE_BUFS is being used

This is a side effect of CREATE_BUFS being passed-through, implementing
emulation for this should be straightforward.

> >    - Crash in the jpeg decoder (when frames are corrupted)

A minimalist framing parser would detect just enough of this, and would
fix it.

> >    - App exporting DMABuf need to be aware of emulation, otherwise the
> >      DMABuf exported are in the orignal format

libv4l2 can return ENOTTY to expbufs calls in=20

> >    - RW emulation only initialize the queue on first read (causing
> >      userspace poll() to fail)

This is not fixable, only place it would be fixed is by moving this
emulation into VideoBuf2. That would assume someone do care about RW
(even though it could be nicer uAPI when dealing with muxed or byte-
stream type of data).

> >    - Signature of v4l2_mmap does not match mmap() (minor)
> >    - The colorimetry does not seem emulated when conversion

This one is probably tricky, special is the converter plugin API is
considered stable. Maybe just resetting everything to DEFAULT would
work ?

> >    - Sub-optimal locking (at least deadlocks were fixed)

Need more investigation really, and proper measurement.
--=-CqkNEleeL8uqGtEGyA8P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWv7htwAKCRBxUwItrAao
HFoUAJoDLo+ZXPf3IoYNETy9QpU5Q6DuPACeM6xq6qZpKesZMPxgz9baFREaFPE=
=FviU
-----END PGP SIGNATURE-----

--=-CqkNEleeL8uqGtEGyA8P--
