Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:40184 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751832AbdHVRnv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 13:43:51 -0400
Date: Tue, 22 Aug 2017 19:43:39 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Yong <yong.deng@magewell.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hverkuil@xs4all.nl>,
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
Message-ID: <20170822174339.6woauylgzkgqxygk@flea.lan>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
 <1501131697-1359-2-git-send-email-yong.deng@magewell.com>
 <20170728160233.xooevio4hoqkgfaq@flea.lan>
 <20170731111640.d5a8e580a48183cfce85943d@magewell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="zatyhyqmpkkyikjj"
Content-Disposition: inline
In-Reply-To: <20170731111640.d5a8e580a48183cfce85943d@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zatyhyqmpkkyikjj
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Yong,

On Mon, Jul 31, 2017 at 11:16:40AM +0800, Yong wrote:
> > > @@ -143,6 +143,7 @@ source "drivers/media/platform/am437x/Kconfig"
> > >  source "drivers/media/platform/xilinx/Kconfig"
> > >  source "drivers/media/platform/rcar-vin/Kconfig"
> > >  source "drivers/media/platform/atmel/Kconfig"
> > > +source "drivers/media/platform/sun6i-csi/Kconfig"
> >=20
> > We're going to have several different drivers in v4l eventually, so I
> > guess it would make sense to move to a directory of our own.
>=20
> Like this?
> drivers/media/platform/sunxi/sun6i-csi

Yep.

> > > +static int sun6i_graph_notify_complete(struct v4l2_async_notifier *n=
otifier)
> > > +{
> > > +	struct sun6i_csi *csi =3D
> > > +			container_of(notifier, struct sun6i_csi, notifier);
> > > +	struct sun6i_graph_entity *entity;
> > > +	int ret;
> > > +
> > > +	dev_dbg(csi->dev, "notify complete, all subdevs registered\n");
> > > +
> > > +	/* Create links for every entity. */
> > > +	list_for_each_entry(entity, &csi->entities, list) {
> > > +		ret =3D sun6i_graph_build_one(csi, entity);
> > > +		if (ret < 0)
> > > +			return ret;
> > > +	}
> > > +
> > > +	/* Create links for video node. */
> > > +	ret =3D sun6i_graph_build_video(csi);
> > > +	if (ret < 0)
> > > +		return ret;
> >=20
> > Can you elaborate a bit on the difference between a node parsed with
> > _graph_build_one and _graph_build_video? Can't you just store the
> > remote sensor when you build the notifier, and reuse it here?
>=20
> There maybe many usercases:
> 1. CSI->Sensor.
> 2. CSI->MIPI->Sensor.
> 3. CSI->FPGA->Sensor1
>             ->Sensor2.
> FPGA maybe some other video processor. FPGA, MIPI, Sensor can be
> registered as v4l2 subdevs. We do not care about the driver code
> of them. But they should be linked together here.
>=20
> So, the _graph_build_one is used to link CSI port and subdevs.=20
> _graph_build_video is used to link CSI port and video node.

So the graph_build_one is for the two first cases, and the
_build_video for the latter case?

If so, you should take a look at the last iteration of the
subnotifiers rework by Nikas S=F6derlund (v4l2-async: add subnotifier
registration for subdevices).

It allows subdevs to register notifiers, and you don't have to build
the graph from the video device, each device and subdev can only care
about what's next in the pipeline, but not really what's behind it.

That would mean in your case that you can only deal with your single
CSI pad, and whatever subdev driver will use it care about its own.

> This part is also difficult to understand for me. The one CSI module
> have only one DMA channel(single port). But thay can be linked to=20
> different physical port (Parallel or MIPI)(multiple ep) by IF select
> register.
>=20
> For now, the binding can have several ep, the driver will just pick
> the first valid one.

Yeah, I'm not really sure how we could deal with that, but I guess we
can do it later on.

> >=20
> > > +struct sun6i_csi_ops {
> > > +	int (*get_supported_pixformats)(struct sun6i_csi *csi,
> > > +					const u32 **pixformats);
> > > +	bool (*is_format_support)(struct sun6i_csi *csi, u32 pixformat,
> > > +				  u32 mbus_code);
> > > +	int (*s_power)(struct sun6i_csi *csi, bool enable);
> > > +	int (*update_config)(struct sun6i_csi *csi,
> > > +			     struct sun6i_csi_config *config);
> > > +	int (*update_buf_addr)(struct sun6i_csi *csi, dma_addr_t addr);
> > > +	int (*s_stream)(struct sun6i_csi *csi, bool enable);
> > > +};
> >=20
> > Didn't we agreed on removing those in the first iteration? It's not
> > really clear at this point whether they will be needed at all. Make
> > something simple first, without those ops. When we'll support other
> > SoCs we'll have a better chance at seeing what and how we should deal
> > with potential quirks.
>=20
> OK. But without ops, it is inappropriate to sun6i_csi and sun6i_csi.
> Maybe I should merge the two files.

I'm not sure what you meant here, but if you think that's appropriate,
please go ahead.

> > > +		return IRQ_HANDLED;
> > > +	}
> > > +
> > > +	if (status & CSI_CH_INT_STA_FD_PD) {
> > > +		sun6i_video_frame_done(&sdev->csi.video);
> > > +	}
> > > +
> > > +	regmap_write(regmap, CSI_CH_INT_STA_REG, status);
> >=20
> > Isn't it redundant with the one you did in the condition a bit above?
> >=20
> > You should also check that your device indeed generated an
> > interrupt. In the occurence of a spourious interrupt, your code will
> > return IRQ_HANDLED, which is the wrong thing to do.
> >=20
> > I think you should reverse your logic a bit here to make this
> > easier. You should just check that your status flags are indeed set,
> > and if not just bail out and return IRQ_NONE.
> >=20
> > And if they are, go on with treating your interrupt.
>=20
> OK. I will add check for status flags.
> BTW, how can a spurious interrupt occurred?

Usually it's either through some interference, or some poorly designed
controller. This is unlikely, but it's something you should take into
account.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--zatyhyqmpkkyikjj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZnG1LAAoJEBx+YmzsjxAg0HcP/RrpgFmQ+kSctr5oXL7ZBYp5
68BTDv4enVtnV2rA/VrFBbxf6bnFpfx2W1/XK9oo3+h+NQE8tBmMQglkNpxKr5h8
OyVr5Q88Hm9cW1b+5hgp+/z6i1946evhFAI2LspPG7GlNGybXUILu7x15hAzMIyq
N9gNn6qn4Tu7L/o3OWNaY4CsiUnhargxQRa7sxTiGaPFf39TjNw+Z8CgpwT6twQA
cE8gro97zP9+mMrdW5W7gQ7bkTgfibP1ax6Zti68rqAqfG3nwWyW//sb62fQMuUR
4axgFvYGIG1ky5UeyrwmrT14XvdPrFsoodKvyoremeZ3crFH86ZLwfTNoWlTJ05c
OfOpuUFZtuvx5lCyN+s8cDjh9I+WjNopGJFugQSvik9xIxStt4vhYi50dmz1bZ6i
9BChqVmmNh4IkS1NVqokt+PyX+2XJBZHLc/duGzUwy6aj4jFINQqvX5/I4L7Gv01
WANwN84X6KCXdEr94hXCqxdejbB5LlAFmVJZbPc0psEGFX9fNxP6PGtIv2E2EWqa
9z7q0U8k+m4Yyy2p1YwEcTD3AygxM9TSZTnn+VXAZWf5DhBisJJfHa0pXqRREa/l
U0X3ZmedO8yuvE1pCYppsZB8IBupX05Aw6N5MqZpA8Azkz0lkcuzYW037t1EZYAP
ysJ5K0MtOsZFvMV88Xud
=QjH0
-----END PGP SIGNATURE-----

--zatyhyqmpkkyikjj--
