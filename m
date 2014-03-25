Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:38454 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbaCYJqY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 05:46:24 -0400
Received: by mail-wg0-f42.google.com with SMTP id y10so137640wgg.25
        for <linux-media@vger.kernel.org>; Tue, 25 Mar 2014 02:46:23 -0700 (PDT)
From: James Hogan <james.hogan@imgtec.com>
To: David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Antti =?ISO-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>
Subject: Re: [PATCH 1/5] rc-main: add generic scancode filtering
Date: Tue, 25 Mar 2014 09:12:11 +0000
Message-ID: <10422443.FIKnYVGtAm@radagast>
In-Reply-To: <20140324235146.GA25627@hardeman.nu>
References: <1393629426-31341-1-git-send-email-james.hogan@imgtec.com> <1393629426-31341-2-git-send-email-james.hogan@imgtec.com> <20140324235146.GA25627@hardeman.nu>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1714853.PnQ5JmDmLT"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nextPart1714853.PnQ5JmDmLT
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Tuesday 25 March 2014 00:51:46 David H=E4rdeman wrote:
> On Fri, Feb 28, 2014 at 11:17:02PM +0000, James Hogan wrote:
> >Add generic scancode filtering of RC input events, and fall back to
> >permitting any RC_FILTER_NORMAL scancode filter to be set if no s_fi=
lter
> >callback exists. This allows raw IR decoder events to be filtered, a=
nd
> >potentially allows hardware decoders to set looser filters and rely =
on
> >generic code to filter out the corner cases.
>=20
> Hi James,
>=20
> What's the purpose of providing the sw scancode filtering in the case=
 where
> there's no hardware filtering support at all?

Consistency is probably the main reason, but I'll admit it's not perfec=
tly=20
consistent between generic/hardware filtering (mostly thanks to NEC sca=
ncode=20
complexities), and I have no particular objection to dropping it if tha=
t isn't=20
considered a good enough reason.

Here's the original discussion:
On Monday 10 February 2014 21:45:30 Antti Sepp=E4l=E4 wrote:
> On 10 February 2014 11:58, James Hogan <james.hogan@imgtec.com> wrote=
:
> > On Saturday 08 February 2014 13:30:01 Antti Sepp=E4l=E4 wrote:
> > > Also adding the scancode filter to it would
> > > demonstrate its usage.
> >=20
> > To actually add filtering support to loopback would require either:=

> > * raw-decoder/rc-core level scancode filtering for raw ir drivers
> > * OR loopback driver to encode like nuvoton and fuzzy match the IR
> > signals.
>=20
> Rc-core level scancode filtering shouldn't be too hard to do right? I=
f
> such would exist then it would provide a software fallback to other r=
c
> devices where hardware filtering isn't available. I'd love to see the=

> sysfs filter and filter_mask files to have an effect on my nuvoton to=
o


> (sorry that I'm replying so late...busy schedule :))

No problem :)

Cheers
James

> >Signed-off-by: James Hogan <james.hogan@imgtec.com>
> >Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> >Cc: Antti Sepp=E4l=E4 <a.seppala@gmail.com>
> >Cc: linux-media@vger.kernel.org
> >---
> >
> > drivers/media/rc/rc-main.c | 20 +++++++++++++-------
> > 1 file changed, 13 insertions(+), 7 deletions(-)
> >
> >diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c=

> >index 6448128..0a4f680 100644
> >--- a/drivers/media/rc/rc-main.c
> >+++ b/drivers/media/rc/rc-main.c
> >@@ -633,6 +633,7 @@ EXPORT_SYMBOL_GPL(rc_repeat);
> >
> > static void ir_do_keydown(struct rc_dev *dev, int scancode,
> >=20
> > =09=09=09  u32 keycode, u8 toggle)
> >=20
> > {
> >
> >+=09struct rc_scancode_filter *filter;
> >
> > =09bool new_event =3D !dev->keypressed ||
> > =09
> > =09=09=09 dev->last_scancode !=3D scancode ||
> > =09=09=09 dev->last_toggle !=3D toggle;
> >
> >@@ -640,6 +641,11 @@ static void ir_do_keydown(struct rc_dev *dev, i=
nt
> >scancode,>
> > =09if (new_event && dev->keypressed)
> > =09
> > =09=09ir_do_keyup(dev, false);
> >
> >+=09/* Generic scancode filtering */
> >+=09filter =3D &dev->scancode_filters[RC_FILTER_NORMAL];
> >+=09if (filter->mask && ((scancode ^ filter->data) & filter->mask))
> >+=09=09return;
> >+
> >
> > =09input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
> > =09
> > =09if (new_event && keycode !=3D KEY_RESERVED) {
> >
> >@@ -1019,9 +1025,7 @@ static ssize_t show_filter(struct device *devi=
ce,
> >
> > =09=09return -EINVAL;
> > =09
> > =09mutex_lock(&dev->lock);
> >
> >-=09if (!dev->s_filter)
> >-=09=09val =3D 0;
> >-=09else if (fattr->mask)
> >+=09if (fattr->mask)
> >
> > =09=09val =3D dev->scancode_filters[fattr->type].mask;
> > =09
> > =09else
> > =09
> > =09=09val =3D dev->scancode_filters[fattr->type].data;
> >
> >@@ -1069,7 +1073,7 @@ static ssize_t store_filter(struct device *dev=
ice,
> >
> > =09=09return ret;
> > =09
> > =09/* Scancode filter not supported (but still accept 0) */
> >
> >-=09if (!dev->s_filter)
> >+=09if (!dev->s_filter && fattr->type !=3D RC_FILTER_NORMAL)
> >
> > =09=09return val ? -EINVAL : count;
> > =09
> > =09mutex_lock(&dev->lock);
> >
> >@@ -1081,9 +1085,11 @@ static ssize_t store_filter(struct device *de=
vice,
> >
> > =09=09local_filter.mask =3D val;
> > =09
> > =09else
> > =09
> > =09=09local_filter.data =3D val;
> >
> >-=09ret =3D dev->s_filter(dev, fattr->type, &local_filter);
> >-=09if (ret < 0)
> >-=09=09goto unlock;
> >+=09if (dev->s_filter) {
> >+=09=09ret =3D dev->s_filter(dev, fattr->type, &local_filter);
> >+=09=09if (ret < 0)
> >+=09=09=09goto unlock;
> >+=09}
> >
> > =09/* Success, commit the new filter */
> > =09*filter =3D local_filter;

--nextPart1714853.PnQ5JmDmLT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABAgAGBQJTMUhzAAoJEKHZs+irPybfkWAP/jqMAYwM8gwbaWbhmMrt8wI8
P5VQu66yRk22EPjb4twFi98/5XAM90XKwRW7WOeB31zFB5NiTGru/ojMaXjhf1GA
9hQKbFFngfIYdbQQxTYCVj1trLInxZE2CmFkX3PsVUxaQAs+WWzOl2+eQXJ3stFL
d0Zw7WD2iAOQNnV0wXQGw38wPLcZk11R81txj2XlxsTpy7ctQsYdrYYJT5wIvTQG
pkjTAOX1qqQkj5+zaac131CfSYF2cpF1ySIGEzsMqCb7S23ifcnx46aGTv0vuMbR
j+CtXau3G9BwPHQxwqTZ/0Sd9hvm9S+SxPpprVzyr9J56Tqn/nDv3KCOiUWTYc8W
4JCJetgFNBG7cQEti2e+Y2QmoPuQ/HnawzRX1Q6RL66McjQe0Tj2aet4A95FHGvz
wpvRqb2JGRRxCD0lB0xwHi2rWWWXuKt1YbXn/p4MU47/dL41OJroHkJk07iEdf2f
Dag6pnywBdZqGAHfw/QkpfxlX/is+KR6L1TtBA3QwCrB6DJFOarAmbkdFkdVSzq6
6jsgGise0k7VUar8KYnGwmf5apClIdU9KJLdQLIOjkeBPBZZI0LBs1UALMfFVnQr
U3k3nOCJEQTS9U7cg7Iio68ajlEtTN3oXLT/sQPj0p9PzBvJH+xmq1Wp23GhHtXZ
2q816EnZrZB65CSh7vCy
=JOaK
-----END PGP SIGNATURE-----

--nextPart1714853.PnQ5JmDmLT--

