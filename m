Return-path: <linux-media-owner@vger.kernel.org>
Received: from leonov.paulk.fr ([185.233.101.22]:60158 "EHLO leonov.paulk.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729517AbeIGUGz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Sep 2018 16:06:55 -0400
Message-ID: <84cd11cd7efd2301ee70e92a71bd915d2f38c41e.camel@paulk.fr>
Subject: Re: [PATCH v9 5/9] media: platform: Add Cedrus VPU decoder driver
From: Paul Kocialkowski <contact@paulk.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Date: Fri, 07 Sep 2018 17:24:40 +0200
In-Reply-To: <4b30c0bf-e525-1868-f625-569d4a104aa0@xs4all.nl>
References: <20180906222442.14825-1-contact@paulk.fr>
         <20180906222442.14825-6-contact@paulk.fr>
         <4b30c0bf-e525-1868-f625-569d4a104aa0@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-pfNOvWR/bi0bWWWe83Jr"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-pfNOvWR/bi0bWWWe83Jr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Le vendredi 07 septembre 2018 =C3=A0 15:13 +0200, Hans Verkuil a =C3=A9crit=
 :
> On 09/07/2018 12:24 AM, Paul Kocialkowski wrote:
> > From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> >=20
> > This introduces the Cedrus VPU driver that supports the VPU found in
> > Allwinner SoCs, also known as Video Engine. It is implemented through
> > a V4L2 M2M decoder device and a media device (used for media requests).
> > So far, it only supports MPEG-2 decoding.
> >=20
> > Since this VPU is stateless, synchronization with media requests is
> > required in order to ensure consistency between frame headers that
> > contain metadata about the frame to process and the raw slice data that
> > is used to generate the frame.
> >=20
> > This driver was made possible thanks to the long-standing effort
> > carried out by the linux-sunxi community in the interest of reverse
> > engineering, documenting and implementing support for the Allwinner VPU=
.
> >=20
> > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> > Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
>=20
> One high-level comment:
>=20
> Can you add a TODO file for this staging driver? This can be done in
> a follow-up patch.

Definitely, I'll do that soon!

> It should contain what needs to be done to get this out of staging:
>=20
> - Request API needs to stabilize
> - Userspace support for stateless codecs must be created
> - Ideally one other stateless decoder driver and at least one
>   stateless encoder driver should be implemented to ensure that nothing
>   was forgotten in the Request API.
> - Anything else?

I still fell rather unsure about the codec metadata controls, so it
would be good to wait for more feedback on that specific point too.
They definitely fit our driver's needs and I also checked them against
the spec to spot missing elements, but I'm still worried I might have
missed something relevant there. Are there use cases currently not
covered by their current verison?

> And a few last code comments:
>=20
> > ---
> >  MAINTAINERS                                   |   7 +
> >  drivers/staging/media/Kconfig                 |   2 +
> >  drivers/staging/media/Makefile                |   1 +
> >  drivers/staging/media/sunxi/Kconfig           |  15 +
> >  drivers/staging/media/sunxi/Makefile          |   1 +
> >  drivers/staging/media/sunxi/cedrus/Kconfig    |  14 +
> >  drivers/staging/media/sunxi/cedrus/Makefile   |   3 +
> >  drivers/staging/media/sunxi/cedrus/cedrus.c   | 422 ++++++++++++++
> >  drivers/staging/media/sunxi/cedrus/cedrus.h   | 165 ++++++
> >  .../staging/media/sunxi/cedrus/cedrus_dec.c   |  70 +++
> >  .../staging/media/sunxi/cedrus/cedrus_dec.h   |  27 +
> >  .../staging/media/sunxi/cedrus/cedrus_hw.c    | 322 +++++++++++
> >  .../staging/media/sunxi/cedrus/cedrus_hw.h    |  30 +
> >  .../staging/media/sunxi/cedrus/cedrus_mpeg2.c | 237 ++++++++
> >  .../staging/media/sunxi/cedrus/cedrus_regs.h  | 233 ++++++++
> >  .../staging/media/sunxi/cedrus/cedrus_video.c | 544 ++++++++++++++++++
> >  .../staging/media/sunxi/cedrus/cedrus_video.h |  30 +
> >  17 files changed, 2123 insertions(+)
> >  create mode 100644 drivers/staging/media/sunxi/Kconfig
> >  create mode 100644 drivers/staging/media/sunxi/Makefile
> >  create mode 100644 drivers/staging/media/sunxi/cedrus/Kconfig
> >  create mode 100644 drivers/staging/media/sunxi/cedrus/Makefile
> >  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus.c
> >  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus.h
> >  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_dec.c
> >  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_dec.h
> >  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_hw.c
> >  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_hw.h
> >  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
> >  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_regs.h
> >  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_video.c
> >  create mode 100644 drivers/staging/media/sunxi/cedrus/cedrus_video.h
> >=20
>=20
> <snip>
>=20
> > +static int cedrus_request_validate(struct media_request *req)
> > +{
> > +	struct media_request_object *obj;
> > +	struct v4l2_ctrl_handler *parent_hdl, *hdl;
> > +	struct cedrus_ctx *ctx =3D NULL;
> > +	struct v4l2_ctrl *ctrl_test;
> > +	unsigned int i;
> > +
> > +	if (vb2_request_buffer_cnt(req) !=3D 1)
> > +		return -ENOENT;
>=20
> I would return ENOENT if there are no buffers, and EINVAL if there are to=
o
> many. Returning ENOENT in the latter case would be very confusing.
>=20
> I also highly recommend that you add v4l2_info lines for these errors.

Yes that seems much clearer. I'll send that as a follow-up patch.

> > +
> > +	list_for_each_entry(obj, &req->objects, list) {
> > +		struct vb2_buffer *vb;
> > +
> > +		if (vb2_request_object_is_buffer(obj)) {
> > +			vb =3D container_of(obj, struct vb2_buffer, req_obj);
> > +			ctx =3D vb2_get_drv_priv(vb->vb2_queue);
> > +
> > +			break;
> > +		}
> > +	}
> > +
> > +	if (!ctx)
> > +		return -ENOENT;
> > +
> > +	parent_hdl =3D &ctx->hdl;
> > +
> > +	hdl =3D v4l2_ctrl_request_hdl_find(req, parent_hdl);
> > +	if (!hdl) {
> > +		v4l2_err(&ctx->dev->v4l2_dev, "Missing codec control(s)\n");
>=20
> Should be v4l2_info: it is not a driver error, it is just an info message=
.

Oh, my mistake.

> > +		return -ENOENT;
> > +	}
> > +
> > +	for (i =3D 0; i < CEDRUS_CONTROLS_COUNT; i++) {
> > +		if (cedrus_controls[i].codec !=3D ctx->current_codec ||
> > +		    !cedrus_controls[i].required)
> > +			continue;
> > +
> > +		ctrl_test =3D v4l2_ctrl_request_hdl_ctrl_find(hdl,
> > +			cedrus_controls[i].id);
> > +		if (!ctrl_test) {
> > +			v4l2_err(&ctx->dev->v4l2_dev,
> > +				 "Missing required codec control\n");
>=20
> Ditto.
>
> > +			return -ENOENT;
> > +		}
> > +	}
> > +
> > +	v4l2_ctrl_request_hdl_put(hdl);
> > +
> > +	return vb2_request_validate(req);
> > +}
>=20
> Not worth making a v10, but you can do this in a follow-up patch.
>=20
> Once I have the two follow-up patches I'll make a pull request.

Excellent! I'm really glad we're approaching the end of it.

Cheers,

Paul

--=20
Developer of free digital technology and hardware support.

Website: https://www.paulk.fr/
Coding blog: https://code.paulk.fr/
Git repositories: https://git.paulk.fr/ https://git.code.paulk.fr/

--=-pfNOvWR/bi0bWWWe83Jr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEAbcMXZQMtj1fphLChP3B6o/ulQwFAluSmDgACgkQhP3B6o/u
lQxJmxAAjRHm8+yIxMz5a6A5PQOC+rhKe0d3MbpBroMOj1NoOlG2T9EMlFozb1z2
sxRfXyL09WE3DxDFGWew4AL0aKTLGw9mTlzfBJojIMB2gOf7vc6teZ6NL6fOfA+w
suyBFdtM6MLglOlOwJUCI+MoqZg7+l3R6KFb4aX4dJ4mlC0UrH3k82DCJLUpZdXN
YhtUz2JqV4+s7FQ42KM7p+6cZd40E5QyLBBLNWFjP3X72r/kfGybXKTxLY4iqJYE
yiU2uIXv6N8ll5+l1LhlDY/KAtLBo4Zkw9XFvBLae7l6+E0BCxcflBFfsdqdV/s3
T/s9KUcGA3A/6tNveeTBhUkn6veMTt4RhgHQw6eyUao/1INumc9Q/yTKUroQo7AP
WhYeC6SAdltZ3bclv/Pk94QWo7tgm0EL8Ad3M0HT9zjjb7dk5oCP2BJqv4zBXJNs
VCmgM0D9CB7gYvjomNNy+nfj3V4R7OYxn9783Foya0n8j4G7LRdmWyqzJ3y8bn5r
/Un92sN7ANcDgandFhnLCmMvgbyw9Jo/aC1nVUJk8w7idXdu7kgi9mdp8gWc10MV
aE8YnqiJhEZqvhaWD8ZoEo+7JM247Am77kg1vE51GJTSa7Wt5sV11X7QSqQLe4ch
V1GN0saRIG2cJyZdAUsujghbsnJwoTFaCPVwdieEml+QY+L6Shs=
=kob7
-----END PGP SIGNATURE-----

--=-pfNOvWR/bi0bWWWe83Jr--
