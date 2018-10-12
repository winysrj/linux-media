Return-path: <linux-media-owner@vger.kernel.org>
Received: from leonov.paulk.fr ([185.233.101.22]:36804 "EHLO leonov.paulk.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728131AbeJLUAV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Oct 2018 16:00:21 -0400
Message-ID: <ff0c60810411c9f25b7412746a8e91d7e099774a.camel@paulk.fr>
Subject: Re: [RFC PATCH v2] media: docs-rst: Document m2m stateless video
 decoder interface
From: Paul Kocialkowski <contact@paulk.fr>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 12 Oct 2018 14:28:34 +0200
In-Reply-To: <CAAFQd5DvkvjMrdSVd-Ba5RiGUjM6Jp8hruk23A87sd4htoFovw@mail.gmail.com>
References: <20181004081119.102575-1-acourbot@chromium.org>
         <7bd6883f43f3ffa1803975236eb18b5e63d3455a.camel@paulk.fr>
         <CAAFQd5DvkvjMrdSVd-Ba5RiGUjM6Jp8hruk23A87sd4htoFovw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-4D5luGoNjzPR1BXOT9NZ"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-4D5luGoNjzPR1BXOT9NZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Le mardi 09 octobre 2018 =C3=A0 14:58 +0900, Tomasz Figa a =C3=A9crit :
> Hi Paul,
>=20
> On Thu, Oct 4, 2018 at 9:40 PM Paul Kocialkowski <contact@paulk.fr> wrote=
:
> > Hi Alexandre,
> >=20
> > Thanks for submitting this second version of the RFC, it is very
> > appreciated! I will try to provide useful feedback here and hopefully
> > be more reactive than during v1 review!
> >=20
> > Most of it looks good to me, but there is a specific point I'd like to
> > keep discussing.
> >=20
> > Le jeudi 04 octobre 2018 =C3=A0 17:11 +0900, Alexandre Courbot a =C3=A9=
crit :
> > > This patch documents the protocol that user-space should follow when
> > > communicating with stateless video decoders. It is based on the
> > > following references:
> > >=20
> > > * The current protocol used by Chromium (converted from config store =
to
> > >   request API)
> > >=20
> > > * The submitted Cedrus VPU driver
> > >=20
> > > As such, some things may not be entirely consistent with the current
> > > state of drivers, so it would be great if all stakeholders could poin=
t
> > > out these inconsistencies. :)
> > >=20
> > > This patch is supposed to be applied on top of the Request API V18 as
> > > well as the memory-to-memory video decoder interface series by Tomasz
> > > Figa.
> > >=20
> > > Changes since V1:
> > >=20
> > > * Applied fixes received as feedback,
> > > * Moved controls descriptions to the extended controls file,
> > > * Document reference frame management and referencing (need Hans' fee=
dback on
> > >   that).
> > >=20
> > > Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> > > ---
> > >  .../media/uapi/v4l/dev-stateless-decoder.rst  | 348 ++++++++++++++++=
++
> > >  Documentation/media/uapi/v4l/devices.rst      |   1 +
> > >  .../media/uapi/v4l/extended-controls.rst      |  25 ++
> > >  .../media/uapi/v4l/pixfmt-compressed.rst      |  54 ++-
> > >  4 files changed, 424 insertions(+), 4 deletions(-)
> > >  create mode 100644 Documentation/media/uapi/v4l/dev-stateless-decode=
r.rst
> > >=20
> > > diff --git a/Documentation/media/uapi/v4l/dev-stateless-decoder.rst b=
/Documentation/media/uapi/v4l/dev-stateless-decoder.rst
> > > new file mode 100644
> > > index 000000000000..e54246df18d0
> > > --- /dev/null
> > > +++ b/Documentation/media/uapi/v4l/dev-stateless-decoder.rst
> > > @@ -0,0 +1,348 @@
> > > +.. -*- coding: utf-8; mode: rst -*-
> > > +
> > > +.. _stateless_decoder:
> > > +
> > > +**************************************************
> > > +Memory-to-memory Stateless Video Decoder Interface
> > > +**************************************************
> > > +
> > > +A stateless decoder is a decoder that works without retaining any ki=
nd of state
> > > +between processing frames. This means that each frame is decoded ind=
ependently
> > > +of any previous and future frames, and that the client is responsibl=
e for
> > > +maintaining the decoding state and providing it to the driver. This =
is in
> > > +contrast to the stateful video decoder interface, where the hardware=
 maintains
> > > +the decoding state and all the client has to do is to provide the ra=
w encoded
> > > +stream.
> > > +
> > > +This section describes how user-space ("the client") is expected to =
communicate
> > > +with such decoders in order to successfully decode an encoded stream=
. Compared
> > > +to stateful codecs, the driver/client sequence is simpler, but the c=
ost of this
> > > +simplicity is extra complexity in the client which must maintain a c=
onsistent
> > > +decoding state.
> > > +
> > > +Querying capabilities
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > +
> > > +1. To enumerate the set of coded formats supported by the driver, th=
e client
> > > +   calls :c:func:`VIDIOC_ENUM_FMT` on the ``OUTPUT`` queue.
> > > +
> > > +   * The driver must always return the full set of supported ``OUTPU=
T`` formats,
> > > +     irrespective of the format currently set on the ``CAPTURE`` que=
ue.
> > > +
> > > +2. To enumerate the set of supported raw formats, the client calls
> > > +   :c:func:`VIDIOC_ENUM_FMT` on the ``CAPTURE`` queue.
> > > +
> > > +   * The driver must return only the formats supported for the forma=
t currently
> > > +     active on the ``OUTPUT`` queue.
> > > +
> > > +   * Depending on the currently set ``OUTPUT`` format, the set of su=
pported raw
> > > +     formats may depend on the value of some controls (e.g. H264 or =
VP9
> > > +     profile). The client is responsible for making sure that these =
controls
> > > +     are set to the desired value before querying the ``CAPTURE`` qu=
eue.
> >=20
> > I still think we have a problem when enumerating CAPTURE formats, that
> > providing the profile/level information does not help solving.
> >=20
> > From previous emails on v1 (to which I failed to react to), it seems
> > that the consensus was to set the profile/level indication beforehand
> > to reduce the subset of possible formats and return that as enumerated
> > possible formats.
>=20
> I think the consensus was to set all the the parsed header controls
> and actually Alex seems to have mentioned it slightly further in his
> patch:
>=20
> +   * In order to enumerate raw formats supported by a given coded format=
, the
> +     client must thus set that coded format on the ``OUTPUT`` queue firs=
t, then
> +     set any control listed on the format's description, and finally enu=
merate
> +     the ``CAPTURE`` queue.
>=20
> > However, it does not really solve the issue here, given the following
> > distinct cases:
> >=20
> > 1. The VPU can only output the format for the decoded frame and that
> > format is not known until the first buffer metadata is passed.
>=20
> That's why I later suggested metadata (parsed header controls) and not
> just some selective controls, such as profiles.

Oh sorry, it seems that I misunderstood this part. I totally agree with
the approach of setting the required codec controls then.

I will look into how that can be managed with VAAPI. I recall that the
format negotiation part happens very early (no metadata passed yet) and
I don't think there's a way to change the format afterwards. But if
there's a problem there, it's definitely on VAAPI's side and that
should not contaminate our API.

> > Everything that is reported as supported at this point should be
> > understood as supported formats for the decoded bitstreams, but
> > userspace would have to pick the one matching the decoded format of the
> > bitstream to decode. I don't really see the point of trying to reduce
> > that list by providing the profile/level.
> >=20
> > 2. The VPU has some format conversion block in its pipeline and can
> > actually provide a range of different formats for CAPTURE buffers,
> > independently from the format of the decoded bitstream.
> >=20
> > Either way, I think (correct me if I'm wrong) that players do know the
> > format from the decoded bitstream here, so enumeration only makes sense
> > for case 2.
>=20
> Players don't know the format for the decoded bitstream, as I already
> explained before. From stream metadata they would only know whether
> the stream is YUV 4:2:0 vs 4:2:2, but wouldn't know the exact hardware
> constraints, e.g. whether NV12 or YUV420 is supported for given YUV
> 4:2:0 stream.

That's a good point, thanks!

> > Something we could do is to not enumerate any format for case 1., which
> > we would specify as an indication that only the decoded bitstream
> > format must be set. Then in case 2., we would enumerate the possible
> > formats.
> >=20
> > For case 1., having the driver expose the supported profiles ensures
> > that any format in a supported profile is valid although not
> > enumerated.
>=20
> Profile doesn't fully determine a specific pixel format, only the
> abstract format (see above).

=46rom what I've understood, profile indicates which YUV sub-sampling
configuration is allowed, but there may be multiple ones. For instance,
the High 4:4:4 profile allows both 4:2:2 and 4:4:4 sub-sampling.

So I maintain that it doesn't make much sense to set the profile while
decoding. Instead, I think it should be a read-only control that
indicates what the hardware can do. Reading this control would allow
userspace to find out whether the current video can be decoded in
hardware or not (so this could be added to the Querying capabilities
part of the doc).

> > Alternatively, we could go with a control that indicates whether the
> > driver supports a format decorrelated from the decoded bitstream format
> > and still enumerate all formats in case 1., with the implication that
> > only the right one must be picked by userspace. Here again, I don't see
> > the point of reducing the list by setting the profile/level.
> >=20
> > So my goal here is to clearly enable userspace to distinguish between
> > the two situations.
> >=20
> > What do you think?
>=20
> Why would we need to create a control, if we already have the ENUM_FMT
> API existing exactly to achieve this? We already have this problem
> solved for stateful decoders and if we request the userspace to
> actually set all the necessary metadata beforehand, the resulting
> behavior (initialization sequence) would be much more consistent
> between these 2 APIs.

Let's drop this idea altogether, setting required controls feels like a
much more generic and cleaner approach.

Cheers,

Paul

--=20
Developer of free digital technology and hardware support.

Website: https://www.paulk.fr/
Coding blog: https://code.paulk.fr/
Git repositories: https://git.paulk.fr/ https://git.code.paulk.fr/

--=-4D5luGoNjzPR1BXOT9NZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEAbcMXZQMtj1fphLChP3B6o/ulQwFAlvAk3IACgkQhP3B6o/u
lQwhHA//QjpEnNZTqcwc7ApvVPj/L4CK8Y6d0ZChHL5CpNx9HfKoqdCp9KhsYV+o
jOZ16/y98fMJsyYmDNWVe0CIkSjHVGqNyHEa0MtyVNov4ikqDGbYrNC6rNIdM5rZ
Y7nNec+9sAQHfvL7v9GVkwGEhgJ3QrgYzCJaQj13CdPAQrgxqcIYiasSfhBySxLg
q8gcjzZVCj3G30oEkAvI0mpW7I3xQiSdT/IDIVZtorl/EfEwaKYEExXMNBsdIu1w
25qXA+CCBQ55wFJofGspjJzslooahJr+iSRMaaixgEhGB8h0gqhE0QC8gw9lJVNF
vLwfg//4z1UwgP5tNET+OoAcQ1PfLWnK2e8usl+SYQA+MLzwRnTbqYB3wEOeKjlT
Pbt7wgg6ZNQId+IZHUzwEP0TCrSONekjIZdy2rHkFdI5S/LYzdIrjyKhQOYppazN
Jqh/yarxegIeenUHF6msPKQckNKwdnmMRBI0KZ6tnwRuvcWQ6f43aIERaCsoE3A9
pKLazi3aLKqf0geG185FaYdB+pa3rydqNozyZvgowTqaj36zCbDM5+f4iyEZy+IN
cNKkq3RBMgB9Av6zeWC8LQ8wFZPNuItkyXOPu4La296Mz7eH1H6s+uQFjkTbz7I2
hOP7NcQR6Q56VRftbJPksdEO6qwwhRTSUrBZhfW1f+LZIUrWjw8=
=XgDL
-----END PGP SIGNATURE-----

--=-4D5luGoNjzPR1BXOT9NZ--
