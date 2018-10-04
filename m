Return-path: <linux-media-owner@vger.kernel.org>
Received: from leonov.paulk.fr ([185.233.101.22]:32874 "EHLO leonov.paulk.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727203AbeJDSmS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 4 Oct 2018 14:42:18 -0400
Message-ID: <5846814403f61b09c1597bd89e6ffc37ccfb9d53.camel@paulk.fr>
Subject: Re: [RFC PATCH] media: docs-rst: Document m2m stateless video
 decoder interface
From: Paul Kocialkowski <contact@paulk.fr>
To: Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 04 Oct 2018 13:49:42 +0200
In-Reply-To: <CAAFQd5D7OGfMJks=mP-f3jEXCzwN6MVYNN5a8JFVJZvkF_wH+Q@mail.gmail.com>
References: <20180831074743.235010-1-acourbot@chromium.org>
         <b8a80df8-fd07-6820-3021-670c360ff306@xs4all.nl>
         <38b32d24-6957-4bee-9168-b3afbfcae083@xs4all.nl>
         <a5c47693-4d66-1afc-9053-45bbbbef9d7c@xs4all.nl>
         <CAPBb6MXrEPz7Z60zUp-m4pWUB7t9p1iFSqqp9s4Gjqj9i3v4sA@mail.gmail.com>
         <01f1723c-8fd0-8f34-0862-624d2bbf51e3@xs4all.nl>
         <CAPBb6MV_m9X6d2Jefk+CU+bxOq8Jnz6XcE++_qDfgQ8Jdd1FYQ@mail.gmail.com>
         <CAAFQd5D7OGfMJks=mP-f3jEXCzwN6MVYNN5a8JFVJZvkF_wH+Q@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-51qpwwEIPQrAzYDtynz4"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-51qpwwEIPQrAzYDtynz4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Le mercredi 03 octobre 2018 =C3=A0 19:13 +0900, Tomasz Figa a =C3=A9crit :
> On Tue, Sep 18, 2018 at 5:02 PM Alexandre Courbot <acourbot@chromium.org>=
 wrote:
> > Hi Hans, sorry for the late reply.
> >=20
> > On Tue, Sep 11, 2018 at 6:09 PM Hans Verkuil <hverkuil@xs4all.nl> wrote=
:
> > > On 09/11/18 10:40, Alexandre Courbot wrote:
> > > > On Mon, Sep 10, 2018 at 9:49 PM Hans Verkuil <hverkuil@xs4all.nl> w=
rote:
> > > > > On 09/10/2018 01:57 PM, Hans Verkuil wrote:
> > > > > > On 09/10/2018 01:25 PM, Hans Verkuil wrote:
> > > > > > > > +
> > > > > > > > +Decoding
> > > > > > > > +=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > > > > +
> > > > > > > > +For each frame, the client is responsible for submitting a=
 request to which the
> > > > > > > > +following is attached:
> > > > > > > > +
> > > > > > > > +* Exactly one frame worth of encoded data in a buffer subm=
itted to the
> > > > > > > > +  ``OUTPUT`` queue,
> > > > > > > > +* All the controls relevant to the format being decoded (s=
ee below for details).
> > > > > > > > +
> > > > > > > > +``CAPTURE`` buffers must not be part of the request, but m=
ust be queued
> > > > > > > > +independently. The driver will pick one of the queued ``CA=
PTURE`` buffers and
> > > > > > > > +decode the frame into it. Although the client has no contr=
ol over which
> > > > > > > > +``CAPTURE`` buffer will be used with a given ``OUTPUT`` bu=
ffer, it is guaranteed
> > > > > > > > +that ``CAPTURE`` buffers will be returned in decode order =
(i.e. the same order
> > > > > > > > +as ``OUTPUT`` buffers were submitted), so it is trivial to=
 associate a dequeued
> > > > > > > > +``CAPTURE`` buffer to its originating request and ``OUTPUT=
`` buffer.
> > > > > > > > +
> > > > > > > > +If the request is submitted without an ``OUTPUT`` buffer o=
r if one of the
> > > > > > > > +required controls are missing, then :c:func:`MEDIA_REQUEST=
_IOC_QUEUE` will return
> > > > > > > > +``-EINVAL``.
> > > > > > >=20
> > > > > > > Not entirely true: if buffers are missing, then ENOENT is ret=
urned. Missing required
> > > > > > > controls or more than one OUTPUT buffer will result in EINVAL=
. This per the latest
> > > > > > > Request API changes.
> > > > > > >=20
> > > > > > >  Decoding errors are signaled by the ``CAPTURE`` buffers bein=
g
> > > > > > > > +dequeued carrying the ``V4L2_BUF_FLAG_ERROR`` flag.
> > > > > > >=20
> > > > > > > Add here that if the reference frame had an error, then all o=
ther frames that refer
> > > > > > > to it should also set the ERROR flag. It is up to userspace t=
o decide whether or
> > > > > > > not to drop them (part of the frame might still be valid).
> > > > > > >=20
> > > > > > > I am not sure whether this should be documented, but there ar=
e some additional
> > > > > > > restrictions w.r.t. reference frames:
> > > > > > >=20
> > > > > > > Since decoders need access to the decoded reference frames th=
ere are some corner
> > > > > > > cases that need to be checked:
> > > > > > >=20
> > > > > > > 1) V4L2_MEMORY_USERPTR cannot be used for the capture queue: =
the driver does not
> > > > > > >    know when a malloced but dequeued buffer is freed, so the =
reference frame
> > > > > > >    could suddenly be gone.
> > > > > > >=20
> > > > > > > 2) V4L2_MEMORY_DMABUF can be used, but drivers should check t=
hat the dma buffer is
> > > > > > >    still available AND increase the dmabuf refcount while it =
is used by the HW.
> > > > > > >=20
> > > > > > > 3) What to do if userspace has requeued a buffer containing a=
 reference frame,
> > > > > > >    and you want to decode a B/P-frame that refers to that buf=
fer? We need to
> > > > > > >    check against that: I think that when you queue a capture =
buffer whose index
> > > > > > >    is used in a pending request as a reference frame, than th=
at should fail with
> > > > > > >    an error. And trying to queue a request referring to a buf=
fer that has been
> > > > > > >    requeued should also fail.
> > > > > > >=20
> > > > > > > We might need to add some support for this in v4l2-mem2mem.c =
or vb2.
> > > > > > >=20
> > > > > > > We will have similar (but not quite identical) issues with st=
ateless encoders.
> > > > > >=20
> > > > > > Related to this is the question whether buffer indices that are=
 used to refer
> > > > > > to reference frames should refer to the capture or output queue=
.
> > > > > >=20
> > > > > > Using capture indices works if you never queue more than one re=
quest at a time:
> > > > > > you know exactly what the capture buffer index is of the decode=
d I-frame, and
> > > > > > you can use that in the following requests.
> > > > > >=20
> > > > > > But if multiple requests are queued, then you don't necessarily=
 know to which
> > > > > > capture buffer an I-frame will be decoded, so then you can't pr=
ovide this index
> > > > > > to following B/P-frames. This puts restrictions on userspace: y=
ou can only
> > > > > > queue B/P-frames once you have decoded the I-frame. This might =
be perfectly
> > > > > > acceptable, though.
> > > >=20
> > > > IIUC at the moment we are indeed using CAPTURE buffer indexes, e.g:
> > > >=20
> > > > .. flat-table:: struct v4l2_ctrl_mpeg2_slice_params
> > > >   ..
> > > >       - ``backward_ref_index``
> > > >       - Index for the V4L2 buffer to use as backward reference, use=
d
> > > > with
> > > >        B-coded and P-coded frames.
> > > >=20
> > > > So I wonder how is the user-space currently exercising Cedrus doing
> > > > here? Waiting for each frame used as a reference to be dequeued?
> > >=20
> > > No, the assumption is (if I understand correctly) that userspace won'=
t
> > > touch the memory of the dequeued reference buffer so HW can just poin=
t
> > > to it.
> > >=20
> > > Paul, please correct me if I am wrong.
> > >=20
> > > What does chromeOS do?
> >=20
> > At the moment Chrome OS (using the config store) queues the OUTPUT and
> > CAPTURE buffers together, i.e. in the same request. The CAPTURE buffer
> > is not tied to the request in any way, but what seems to matter here
> > is the queue order. If drivers process CAPTURE drivers sequentially,
> > then you can know which CAPTURE buffer will be used for the request.
> >=20
> > The corollary of that is that CAPTURE buffers cannot be re-queued
> > until they are not referenced anymore, something the Chrome OS
> > userspace also takes care of. Would it be a problem to make this the
> > default expectation instead of having the kernel check and reorder
> > CAPTURE buffers? The worst that can happen AFAICT is is frame
> > corruption, and processing queued CAPTURE buffers sequentially would
> > allow us to use the V4L2 buffer ID to reference frames. That's still
> > the most intuitive way to do, using relative frame indexes (i.e. X
> > frames ago) adds complexity and the potential for misuse and bugs.
>=20
> +1
>=20
> The stateless API delegates the reference frame management to the
> client and I don't see why we should be protecting the client from
> itself. In particular, as I suggested in another email, there can be
> valid cases where requeuing CAPTURE buffers while still on the
> reference list is okay.

I agree that it's best to delegate this to the client, to alleviate the
complexity of dealing with relative indexes in the driver. From what
I've seen, players take care of allocating enough buffers so that re-
queuing CAPTURE buffers is not a problem in practice (they are no
longer used as reference when re-queued). What I've seen is that
buffers are simply rotated at each frame and that just works with
enough buffers allocated.

=46rom that perspective, it would probably also make sense to ask that
userspace provides CAPTURE buffers indexes for references (and thus
stays in charge of the CAPTURE-OUTPUT association).

We could also have the driver keep that association and ask userspace
to provide OUTPUT buffers indexes for references. This seems more
consistent from an API perspective (requests associate OUTPUT buffers
with metadata, so that's the unit that naturally identifies a frame).

However, I'm pretty sure that userspace would also have to keep the
association one way or another to decide which buffer can be reused
safely, so it seems to me like keeping CAPTURE indexes would reduce the
driver overhead without really complexifying userspace much.

What do you think?

Cheers,

Paul

--=20
Developer of free digital technology and hardware support.

Website: https://www.paulk.fr/
Coding blog: https://code.paulk.fr/
Git repositories: https://git.paulk.fr/ https://git.code.paulk.fr/

--=-51qpwwEIPQrAzYDtynz4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEAbcMXZQMtj1fphLChP3B6o/ulQwFAlu1/lYACgkQhP3B6o/u
lQzr+g//e4O/rYOIZpsYqyqEWs9RDvXSCj2xW/h3nls2OLJ2ywvOmk6tdt9ByIKo
AMQhq9NAUtflzujMf/C8nCCQa3fyC9kNETMN+RIigXo8l6SWmEaTN/X13IfciUKP
qD6lssomrAFWhhbzfEidkXIU+tsJM9nfhPoLAnOgeCugezzvmwZaT7TALQZIF9sh
CqP8qiiIVT+zblIq/tiLpXx97WpGVnkz/xButj+03Zhy1clp07TemmyIythHaAIp
fGgKVUxJesiqOa6Fe/Q3Mw/6ebvHjusj0wHUZma3jiqXfCcPsrQhYKaHJIVwDJmd
KfCIl0HfLvD77SYOWBwGCQ9+2+4DayqW6y9Y7GaNYFsantUYxmUPBvdPxf9vKmC0
fiQFvWj9AUhfQ2k9E36DXnHt4KvTDaS0bm6DmbQ/cYb+MTZ3zrc1el5aeK64DX+n
NihGGB9uRGrcUPyRnafyPc/3kc/6lsjoKej/hTTul0iXw/MPTledtubquycfSStS
6XwErIQFjNrez78UD0lSFrQ/3NUf5lwk5vaA9YZUD+GSsoqPrjXJJlpSalmon7+R
2mwCLs2nc+oI5P1QDm2NOTCiujQUsrPUVbBCAsOZaY+TUDyTLUWoXPNWdqirZxRn
YxO4hlvnlm5lIdXvs3EhYHLHgEPSw3Xa+6PoC1tKj8QXoJRWcP4=
=meRo
-----END PGP SIGNATURE-----

--=-51qpwwEIPQrAzYDtynz4--
