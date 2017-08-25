Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:42104 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932291AbdHYNl0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 09:41:26 -0400
Date: Fri, 25 Aug 2017 15:41:14 +0200
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
Message-ID: <20170825134114.rwttrmzw5gbtwdx2@flea.lan>
References: <1501131697-1359-1-git-send-email-yong.deng@magewell.com>
 <1501131697-1359-2-git-send-email-yong.deng@magewell.com>
 <20170728160233.xooevio4hoqkgfaq@flea.lan>
 <20170731111640.d5a8e580a48183cfce85943d@magewell.com>
 <20170822174339.6woauylgzkgqxygk@flea.lan>
 <20170823103216.e43283308c195c4a80d929fa@magewell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="q5eugcagmdzotuv4"
Content-Disposition: inline
In-Reply-To: <20170823103216.e43283308c195c4a80d929fa@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--q5eugcagmdzotuv4
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Yong,

On Wed, Aug 23, 2017 at 10:32:16AM +0800, Yong wrote:
> > > > > +static int sun6i_graph_notify_complete(struct v4l2_async_notifie=
r *notifier)
> > > > > +{
> > > > > +	struct sun6i_csi *csi =3D
> > > > > +			container_of(notifier, struct sun6i_csi, notifier);
> > > > > +	struct sun6i_graph_entity *entity;
> > > > > +	int ret;
> > > > > +
> > > > > +	dev_dbg(csi->dev, "notify complete, all subdevs registered\n");
> > > > > +
> > > > > +	/* Create links for every entity. */
> > > > > +	list_for_each_entry(entity, &csi->entities, list) {
> > > > > +		ret =3D sun6i_graph_build_one(csi, entity);
> > > > > +		if (ret < 0)
> > > > > +			return ret;
> > > > > +	}
> > > > > +
> > > > > +	/* Create links for video node. */
> > > > > +	ret =3D sun6i_graph_build_video(csi);
> > > > > +	if (ret < 0)
> > > > > +		return ret;
> > > >=20
> > > > Can you elaborate a bit on the difference between a node parsed with
> > > > _graph_build_one and _graph_build_video? Can't you just store the
> > > > remote sensor when you build the notifier, and reuse it here?
> > >=20
> > > There maybe many usercases:
> > > 1. CSI->Sensor.
> > > 2. CSI->MIPI->Sensor.
> > > 3. CSI->FPGA->Sensor1
> > >             ->Sensor2.
> > > FPGA maybe some other video processor. FPGA, MIPI, Sensor can be
> > > registered as v4l2 subdevs. We do not care about the driver code
> > > of them. But they should be linked together here.
> > >=20
> > > So, the _graph_build_one is used to link CSI port and subdevs.=20
> > > _graph_build_video is used to link CSI port and video node.
> >=20
> > So the graph_build_one is for the two first cases, and the
> > _build_video for the latter case?
>=20
> No.=20
> The _graph_build_one is used to link the subdevs found in the device=20
> tree. _build_video is used to link the closest subdev to video node.
> Video node is created in the driver, so the method to get it's pad is
> diffrent to the subdevs.

Sorry for being slow here, I'm still not sure I get it.

In summary, both the sun6i_graph_build_one and sun6i_graph_build_video
will iterate over each endpoint, will retrieve the remote entity, and
will create the media link between the CSI pad and the remote pad.

As far as I can see, there's basically two things that
sun6i_graph_build_one does that sun6i_graph_build_video doesn't:
  - It skips all the links that would connect to one of the CSI sinks
  - It skips all the links that would connect to a remote node that is
    equal to the CSI node.

I assume the latter is because you want to avoid going in an infinite
loop when you would follow one of the CSI endpoint (going to the
sensor), and then follow back the same link in the opposite
direction. Right?

I'm confused about the first one though. All the pads you create in
your driver are sink pads, so wouldn't that skip all the pads of the
CSI nodes?

Also, why do you iterate on all the CSI endpoints, when there's only
of them? You want to anticipate the future binding for devices with
multiple channels?

> >=20
> > If so, you should take a look at the last iteration of the
> > subnotifiers rework by Nikas S=F6derlund (v4l2-async: add subnotifier
> > registration for subdevices).
> >=20
> > It allows subdevs to register notifiers, and you don't have to build
> > the graph from the video device, each device and subdev can only care
> > about what's next in the pipeline, but not really what's behind it.
> >=20
> > That would mean in your case that you can only deal with your single
> > CSI pad, and whatever subdev driver will use it care about its own.
>=20
> Do you mean the subdevs create pad link in the notifier registered by
> themself ?

Yes.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--q5eugcagmdzotuv4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZoCj6AAoJEBx+YmzsjxAgOgAQAKs3HSFXvN0bvXdsKh/ncGrN
sbsxwt5GcHU30Um2Qlopek7Fu1LEEjLdg+XJFu6ltoRz9VPT+PhJbyoIBLUza9jO
4QPiBhMHcs2x3HRlifLOS3DMQ/GCV8wgUMX0MFfDKQuk8c1nQYQLc9FSjrxnU94L
llJGrgRV9sbohz4Q2fTT1q6heU3BJsNsdKx/YE52U+B12WHJbmxJzLoJBbAXFhwX
ajosPtDGtWKVBL37C0kB5A5qc8WDVooqulXEVluIEYALCHI7sRsUfTOOhqa9Cv+C
5xRyEagOhUDWvMLoDiu2IOI1DA52rS8uWN4ZS2A64GEnm7a7AYU11sDiSi7VK+lL
xxI/QobuVnvEXMAEp8ajaKfXFSOEX/Fxke28qBsVhAN9XIOr4S/+eKITN+G8a+Jm
oJxuElIJuJeMN6lKdCvY1HGENqrRiYYqaGW1r2LSzYdktm/D+ynOSDhRn6nJyVVy
kahwMgXmuXLPdn5zAeq2hghVCp3jiUy3epqItPTPceAQCYwtYOlcnTxc2ynlnEsD
pD1i3BnX3Q2p3YqPaWQKFazOb79uDzqoa6MWcmQPsPQM0UQRvlVCe7itvszxiuop
SB52+mlkrLmAlwK3ytoJU3WeNbcBEpJ+QencWNFhjeN6NzPkPBcQJTbbnIGlFKgt
WY6NXvOruF1ZPyPjS7v8
=MzUW
-----END PGP SIGNATURE-----

--q5eugcagmdzotuv4--
