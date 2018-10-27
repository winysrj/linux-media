Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34417 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726610AbeJ0SSf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 Oct 2018 14:18:35 -0400
Received: by mail-wm1-f67.google.com with SMTP id f1-v6so5806987wmg.1
        for <linux-media@vger.kernel.org>; Sat, 27 Oct 2018 02:38:14 -0700 (PDT)
Message-ID: <9ac3abb4a8dee94bd2adca6c781bf8c58f68b945.camel@ndufresne.ca>
Subject: Re: [RFP] Which V4L2 ioctls could be replaced by better versions?
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Tomasz Figa <tfiga@chromium.org>, pza@pengutronix.de
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Sat, 27 Oct 2018 10:38:05 +0100
In-Reply-To: <CAAFQd5A3a1o55pcV6Kn5ZWXQFYJvuv4y1+oD4=PEZXoYMhrX0Q@mail.gmail.com>
References: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl>
         <6efdab2da3e4263a49a6a2630df7f79511302088.camel@ndufresne.ca>
         <CAAFQd5BsvtqM3QriFd5vo55ZDKxFcnGAR21Y7ch247jXX6-iQg@mail.gmail.com>
         <20181021162843.ys6eqbbyg5w5ufrv@pengutronix.de>
         <CAAFQd5A3a1o55pcV6Kn5ZWXQFYJvuv4y1+oD4=PEZXoYMhrX0Q@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
        boundary="=-pLLpDdRIcgH3RDT5zn1B"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-pLLpDdRIcgH3RDT5zn1B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lundi 22 octobre 2018 =C3=A0 12:37 +0900, Tomasz Figa a =C3=A9crit :
> Hi Philipp,
>=20
> On Mon, Oct 22, 2018 at 1:28 AM Philipp Zabel <pza@pengutronix.de> wrote:
> >=20
> > On Wed, Oct 03, 2018 at 05:24:39PM +0900, Tomasz Figa wrote:
> > [...]
> > > > Yes, but that would fall in a complete redesign I guess. The buffer
> > > > allocation scheme is very inflexible. You can't have buffers of two
> > > > dimensions allocated at the same time for the same queue. Worst, yo=
u
> > > > cannot leave even 1 buffer as your scannout buffer while reallocati=
ng
> > > > new buffers, this is not permitted by the framework (in software). =
As a
> > > > side effect, there is no way to optimize the resolution changes, yo=
u
> > > > even have to copy your scannout buffer on the CPU, to free it in or=
der
> > > > to proceed. Resolution changes are thus painfully slow, by design.
> >=20
> > [...]
> > > Also, I fail to understand the scanout issue. If one exports a vb2
> > > buffer to a DMA-buf and import it to the scanout engine, it can keep
> > > scanning out from it as long as it want, because the DMA-buf will hol=
d
> > > a reference on the buffer, even if it's removed from the vb2 queue.
> >=20
> > REQBUFS 0 fails if the vb2 buffer is still in use, including from dmabu=
f
> > attachments: vb2_buffer_in_use checks the num_users memop. The refcount
> > returned by num_users shared between the vmarea handler and dmabuf ops,
> > so any dmabuf attachment counts towards in_use.
>=20
> Ah, right. I've managed to completely forget about it, since we have a
> downstream patch that we attempted to upstream earlier [1], but didn't
> have a chance to follow up on the comments and there wasn't much
> interest in it in general.
>=20
> [1] https://lore.kernel.org/patchwork/patch/607853/
>=20
> Perhaps it would be worth reviving?

In this patch we should consider a way to tell userspace that this has
been opt in, otherwise existing userspace will have to remain using
sub-optimal copy based reclaiming in order to ensure that renegotiation
can work on older kernel tool. At worst someone could probably do trial
and error (reqbufs(1)/mmap/reqbufs(0)) but on CMA with large buffers
this introduces extra startup time.

>=20
> Best regards,
> Tomasz

--=-pLLpDdRIcgH3RDT5zn1B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSScpfJiL+hb5vvd45xUwItrAaoHAUCW9Qx/QAKCRBxUwItrAao
HFW6AJoDYIbC4a6FKuneqPaj51KBhM6iXQCePyb/Ld2ypILrhAbiB+peTXVg/TU=
=bXi5
-----END PGP SIGNATURE-----

--=-pLLpDdRIcgH3RDT5zn1B--
