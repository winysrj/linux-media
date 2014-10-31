Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp00.uk.clara.net ([195.8.89.33]:51687 "EHLO
	claranet-outbound-smtp00.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703AbaJaPtV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 11:49:21 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] DocBook media: Clarify V4L2_FIELD_ANY for drivers
Date: Fri, 31 Oct 2014 15:49:12 +0000
Message-ID: <5445654.FH7TshJYAP@f19simon>
In-Reply-To: <5453A289.5020007@xs4all.nl>
References: <1414766908-24894-1-git-send-email-simon.farnsworth@onelan.co.uk> <5453A289.5020007@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1431848.PEoNF8zFr5"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart1431848.PEoNF8zFr5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"

On Friday 31 October 2014 15:54:01 Hans Verkuil wrote:
> On 10/31/2014 03:48 PM, Simon Farnsworth wrote:
> > Documentation for enum v4l2_field did not make it clear that V4L2_F=
IELD_ANY
> > is only acceptable as input to the kernel, not as a response from t=
he
> > driver.
> >=20
> > Make it clear, to stop userspace developers like me assuming it can=
 be
> > returned by the driver.
> >=20
> > Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
> > ---
> >  Documentation/DocBook/media/v4l/io.xml | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation=
/DocBook/media/v4l/io.xml
> > index e5e8325..8918bb2 100644
> > --- a/Documentation/DocBook/media/v4l/io.xml
> > +++ b/Documentation/DocBook/media/v4l/io.xml
> > @@ -1422,7 +1422,10 @@ one of the <constant>V4L2_FIELD_NONE</consta=
nt>,
> >  <constant>V4L2_FIELD_BOTTOM</constant>, or
> >  <constant>V4L2_FIELD_INTERLACED</constant> formats is acceptable.
> >  Drivers choose depending on hardware capabilities or e.&nbsp;g. th=
e
> > -requested image size, and return the actual field order. &v4l2-buf=
fer;
> > +requested image size, and return the actual field order. If multip=
le
> > +field orders are possible the driver must choose one of the possib=
le
> > +field orders during &VIDIOC-S-FMT; or &VIDIOC-TRY-FMT; and must no=
t
> > +return V4L2_FIELD_ANY. &v4l2-buffer;
>=20
> I would phrase it slightly differently:
>=20
> "Drivers must never return <constant>V4L2_FIELD_ANY</constant>. If mu=
ltiple
> field orders are possible the driver must choose one of the possible
> field orders during &VIDIOC-S-FMT; or &VIDIOC-TRY-FMT;."
>=20

I like your wording better than mine. v2 patch sent.

=2D-=20
Simon Farnsworth
Software Engineer
ONELAN Ltd
http://www.onelan.com

--nextPart1431848.PEoNF8zFr5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABAgAGBQJUU698AAoJEOsKZy3xM+c71pUH/R2UPoxPuebc5Lvt8n9zA0Wl
izf/f5Cs6xoVUSIpxsjZjH6uNDVlbgX85G2r/+51l2SfyY8W8ej/e2K8evzax8nu
di/ThBu8plD5ecTlHlb0xzohozeeIeS09UIR4/WPPhLepRiJ9zRnfROrpnh0hhAM
e6wykZrvpwUeiE6Eh7zlygvzhp4+E6LfMVZ0hGDEy6K755aByXVCkOQg00ZYBcrq
f2QLKO7zzyJzb/OPIZ7jWlVU9cxMyLF5dRL9FA6NG2CyC+2kuJM87YAEqdAi+i2V
y1/dW7bt+rOQXRR6M4ViPVRlOGXERnv9ggbkNqTXqwaP9E5l6trQ4xjGnpdvXvI=
=R4w3
-----END PGP SIGNATURE-----

--nextPart1431848.PEoNF8zFr5--

