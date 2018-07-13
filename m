Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:52481 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbeGMIyk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jul 2018 04:54:40 -0400
Message-ID: <2a64aec733392cd15d87b53a268fb8328af0a82c.camel@bootlin.com>
Subject: Re: [PATCH v5 18/22] media: platform: Add Sunxi-Cedrus VPU decoder
 driver
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Marco Franchi <marco.franchi@nxp.com>,
        Icenowy Zheng <icenowy@aosc.io>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pawel Osciak <posciak@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-sunxi@googlegroups.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>
Date: Fri, 13 Jul 2018 10:40:58 +0200
In-Reply-To: <e31090c371ae7f7999b0aa983a20f33451cc89fb.camel@collabora.com>
References: <20180710080114.31469-1-paul.kocialkowski@bootlin.com>
         <20180710080114.31469-19-paul.kocialkowski@bootlin.com>
         <e31090c371ae7f7999b0aa983a20f33451cc89fb.camel@collabora.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Hb1cmEa3+oOsZx1t5cjo"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-Hb1cmEa3+oOsZx1t5cjo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 2018-07-10 at 16:57 -0300, Ezequiel Garcia wrote:
> Hey Paul,
>=20
> My comments on v4 of course apply here as well.

Yes, it seems that most of your comments were not already adressed by
this v5. I will answer your remarks and suggestions on the v4 thread.

> One other thing...
>=20
> On Tue, 2018-07-10 at 10:01 +0200, Paul Kocialkowski wrote:
> > This introduces the Sunxi-Cedrus VPU driver that supports the VPU
> > found
> > in Allwinner SoCs, also known as Video Engine. It is implemented
> > through
> > a v4l2 m2m decoder device and a media device (used for media
> > requests).
> > So far, it only supports MPEG2 decoding.
> >=20
> > Since this VPU is stateless, synchronization with media requests is
> > required in order to ensure consistency between frame headers that
> > contain metadata about the frame to process and the raw slice data
> > that
> > is used to generate the frame.
> >=20
> > This driver was made possible thanks to the long-standing effort
> > carried out by the linux-sunxi community in the interest of reverse
> > engineering, documenting and implementing support for Allwinner VPU.
> >=20
> > Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> >=20
>=20
> [..]
> > +
> > +static irqreturn_t cedrus_bh(int irq, void *data)
> > +{
> > +	struct cedrus_dev *dev =3D data;
> > +	struct cedrus_ctx *ctx;
> > +
> > +	ctx =3D v4l2_m2m_get_curr_priv(dev->m2m_dev);
> > +	if (!ctx) {
> > +		v4l2_err(&dev->v4l2_dev,
> > +			 "Instance released before the end of
> > transaction\n");
> > +		return IRQ_HANDLED;
> > +	}
> > +
> > +	v4l2_m2m_job_finish(ctx->dev->m2m_dev, ctx->fh.m2m_ctx);
> > +
>=20
> I don't like the fact that v4l2_m2m_job_finish calls .device_run
> reentrantly. Let me try to make v4l2_m2m_job_finish() safe to be called
> in atomic context, so hopefully drivers can just call it in the top-
> half.

Thanks for your patches in this direction, I will try them and hopefully
base our next Sunxi-Cedrus version on them, if it seems that this
framework change will be picked-up by maintainers.

> You are returning the buffers in the top-half, so this is just a matter
> or better design, not a performance improvement.

This is definitely a nice design improvement IMO (if not only for
avoiding reentrancy)!=20

And this reduces our code path between starting decoding and userspace
notification that decoding finished. Starting the worker thread is no
longer required before notifying userspace, so I think we are going to
see performance improvements from this. Hopefully, the worker thread
will run while userspace is busy preparing the next frame, so this
should work a lot better for us!

Cheers,

Paul

--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-Hb1cmEa3+oOsZx1t5cjo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAltIZZsACgkQ3cLmz3+f
v9GZSwgAll0CoEb3HEWeSrmcIyD2zGldqS9lJIg6saOKi3kCp/yUuGFJcYUocGcM
VOkqt0HbnMJUH8aCTATD6YqusYV+x6UTZtDK6VjCk6a1m4vXG7ZEtE5LhRvY1pT9
XEjj3BNxdJfPAagdLcz9NNxwOuvW32h52qxJPnb3TS7mhsTa6dK23JMbA0WtDTMl
k8jGSOWza0ZhRQf6repdmxFlhYJuKRXTGuuN1pOnqPznK/HDqutni8STajBb/wZH
Oi9gVJ9aL6PkRTRHuaP9pRSn8D4LgE2cixsZIIdrw2q/+t6BgcJKR2A365hyno91
13OtXD6jkny5A81ymYVzAO6SAcji8g==
=ZMyy
-----END PGP SIGNATURE-----

--=-Hb1cmEa3+oOsZx1t5cjo--
