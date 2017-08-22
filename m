Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:43146 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752557AbdHVURn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 16:17:43 -0400
Date: Tue, 22 Aug 2017 22:17:31 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Yong <yong.deng@magewell.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Benoit Parrot <bparrot@ti.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/3] media: V3s: Add support for Allwinner CSI.
Message-ID: <20170822201731.hyjqrbkhggaoomfl@flea.home>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
 <1501131697-1359-2-git-send-email-yong.deng@magewell.com>
 <5082b6d6-29a7-f101-8cba-13fce8983c89@xs4all.nl>
 <20170822110148.734c01b69dacc57fa08965d1@magewell.com>
 <8dd8c350-cd45-5cd9-65cc-67102944811f@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6fmkb2gzohr3aqga"
Content-Disposition: inline
In-Reply-To: <8dd8c350-cd45-5cd9-65cc-67102944811f@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--6fmkb2gzohr3aqga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 22, 2017 at 08:43:35AM +0200, Hans Verkuil wrote:
> >>> +static int sun6i_video_link_setup(struct media_entity *entity,
> >>> +				  const struct media_pad *local,
> >>> +				  const struct media_pad *remote, u32 flags)
> >>> +{
> >>> +	struct video_device *vdev =3D media_entity_to_video_device(entity);
> >>> +	struct sun6i_video *video =3D video_get_drvdata(vdev);
> >>> +
> >>> +	if (WARN_ON(video =3D=3D NULL))
> >>> +		return 0;
> >>> +
> >>> +	return sun6i_video_formats_init(video);
> >>
> >> Why is this called here? Why not in video_init()?
> >=20
> > sun6i_video_init is in the driver probe context. sun6i_video_formats_in=
it
> > use media_entity_remote_pad and media_entity_to_v4l2_subdev to find the
> > subdevs.
> > The media_entity_remote_pad can't work before all the media pad linked.
>=20
> A video_init is typically called from the notify_complete callback.
> Actually, that's where the video_register_device should be created as wel=
l.
> When you create it in probe() there is possibly no sensor yet, so it would
> be a dead video node (or worse, crash when used).
>=20
> There are still a lot of platform drivers that create the video node in t=
he
> probe, but it's not the right place if you rely on the async loading of
> subdevs.

That's not really related, but I'm not really sure it's a good way to
operate. This essentially means that you might wait forever for a
component in your pipeline to be probed, without any chance of it
happening (not compiled, compiled as a module and not loaded, hardware
defect preventing the driver from probing properly, etc), even though
that component might not be essential.

This is how DRM operates, and you sometimes end up in some very dumb
situations where you wait for say, the DSI controller to probe, while
you only care about HDMI in your system.

But this seems to be on of the hot topic these days, so we might
discuss it further in some other thread :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--6fmkb2gzohr3aqga
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZnJFbAAoJEBx+YmzsjxAgMtsQAKSTAOKjGu0DMGROoAdX3iZS
Zz8GXJsf3bRpZIVKdD98EINRs1uOKAlwK3S4pghb3Tak6Ixj9/zEJSMjF1XMsO55
dSGLeIdqZj3C7JF41Eyr+5TCVK1ps53TNyA8qrf0rO0I0KdRbjlulv56mn/WWoMO
W7RD7rP+xL/GaiT0az691zbUuBXBA3Sv7bfg0XhWshFBFpc9G9nbeHk/TaG17wd/
YchlkJG98gEfl/a8RF0yu7xMR629PzoqTxFEqmI966HFNp5jxBWW8SEF+SduawAt
Ly9zt5y0ISLyFWlfzGIEDsWvOqZKubihblPuas36qYdxJwNb+qySymq9EXReO6BD
sP6aafm7DS32Nkagz+QxBQmULYcSjBzj+/434ezLvB6MCq8ZmpDiKUoGppe+3NxI
WSrSqvpe7e0BWjSlMtevfwNvZUpXTnQ1lGDBb6uPuo2vXXIG9g4uMQTXc0tuiVit
84ek3cN28trSgOSiSOISp7pbPYEZwlNtMzyASB7o067OrR7EUg5bP+/MuPn/MSN1
8R4siDejt+A6fcHU+xQMxI2tcm1pu280wKML6Huypz7J7Ql2WNs54H3ldRAKH+/N
kCbZSXYA9b83UTX+jb0oegJ2I8O/b/yA2xZsLpVhPJ1dJLoF1GKnHAuAwozmfR/D
BoUZ19JquVDfaEYpO2wH
=4ADb
-----END PGP SIGNATURE-----

--6fmkb2gzohr3aqga--
