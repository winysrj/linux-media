Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:49962 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932517AbdJQOTR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 10:19:17 -0400
Received: by mail-qk0-f175.google.com with SMTP id q83so2199514qke.6
        for <linux-media@vger.kernel.org>; Tue, 17 Oct 2017 07:19:17 -0700 (PDT)
Message-ID: <1508249953.19297.4.camel@ndufresne.ca>
Subject: Re: [PATCH] media: vb2: unify calling of set_page_dirty_lock
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 17 Oct 2017 10:19:13 -0400
In-Reply-To: <20171017101420.5a5cvyhkadmcqgfy@valkosipuli.retiisi.org.uk>
References: <20170829112603.32732-1-stanimir.varbanov@linaro.org>
         <1507650010.2784.11.camel@ndufresne.ca>
         <20171015204014.2awhhygw6hi3lxas@valkosipuli.retiisi.org.uk>
         <1508108964.4502.6.camel@ndufresne.ca>
         <20171017101420.5a5cvyhkadmcqgfy@valkosipuli.retiisi.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-JsLkc7swhun6acwfzwAf"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-JsLkc7swhun6acwfzwAf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mardi 17 octobre 2017 =C3=A0 13:14 +0300, Sakari Ailus a =C3=A9crit :
> On Sun, Oct 15, 2017 at 07:09:24PM -0400, Nicolas Dufresne wrote:
> > Le dimanche 15 octobre 2017 =C3=A0 23:40 +0300, Sakari Ailus a =C3=A9cr=
it :
> > > Hi Nicolas,
> > >=20
> > > On Tue, Oct 10, 2017 at 11:40:10AM -0400, Nicolas Dufresne wrote:
> > > > Le mardi 29 ao=C3=BBt 2017 =C3=A0 14:26 +0300, Stanimir Varbanov a =
=C3=A9crit :
> > > > > Currently videobuf2-dma-sg checks for dma direction for
> > > > > every single page and videobuf2-dc lacks any dma direction
> > > > > checks and calls set_page_dirty_lock unconditionally.
> > > > >=20
> > > > > Thus unify and align the invocations of set_page_dirty_lock
> > > > > for videobuf2-dc, videobuf2-sg  memory allocators with
> > > > > videobuf2-vmalloc, i.e. the pattern used in vmalloc has been
> > > > > copied to dc and dma-sg.
> > > >=20
> > > > Just before we go too far in "doing like vmalloc", I would like to
> > > > share this small video that display coherency issues when rendering
> > > > vmalloc backed DMABuf over various KMS/DRM driver. I can reproduce
> > > > this
> > > > easily with Intel and MSM display drivers using UVC or Vivid as
> > > > source.
> > > >=20
> > > > The following is an HDMI capture of the following GStreamer
> > > > pipeline
> > > > running on Dragonboard 410c.
> > > >=20
> > > >     gst-launch-1.0 -v v4l2src device=3D/dev/video2 ! video/x-
> > > > raw,format=3DNV16,width=3D1280,height=3D720 ! kmssink
> > > >     https://people.collabora.com/~nicolas/vmalloc-issue.mov
> > > >=20
> > > > Feedback on this issue would be more then welcome. It's not clear
> > > > to me
> > > > who's bug is this (v4l2, drm or iommu). The software is unlikely to
> > > > be
> > > > blamed as this same pipeline works fine with non-vmalloc based
> > > > sources.
> > >=20
> > > Could you elaborate this a little bit more? Which Intel CPU do you
> > > have
> > > there?
> >=20
> > I have tested with Skylake and Ivy Bridge and on Dragonboard 410c
> > (Qualcomm APQ8016 SoC) (same visual artefact)
>=20
> I presume kmssink draws on the display. Which GPU did you use?

In order, GPU will be Iris Pro 580, Intel=C2=AE Ivybridge Mobile and an
Adreno (3x ?). Why does it matter ? I'm pretty sure the GPU is not used
on the DB410c for this use case.

regards,
Nicolas
--=-JsLkc7swhun6acwfzwAf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCWeYRYQAKCRBxUwItrAao
HCu8AJ0SPGvrlZIu+P36chXlt/NH1Z12/gCfVl0RptQ1atVEfCJK3jeoxVGO23g=
=sb/s
-----END PGP SIGNATURE-----

--=-JsLkc7swhun6acwfzwAf--
