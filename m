Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:36169 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab2KWOwL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 09:52:11 -0500
Message-ID: <50AF8D79.1070309@ti.com>
Date: Fri, 23 Nov 2012 16:51:37 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: <linux-fbdev@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	<linux-media@vger.kernel.org>, Archit Taneja <archit@ti.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Bryan Wu <bryan.wu@canonical.com>,
	Inki Dae <inki.dae@samsung.com>,
	Jesse Barker <jesse.barker@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	Rob Clark <rob.clark@linaro.org>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Tom Gall <tom.gall@linaro.org>,
	Vikas Sajjan <vikas.sajjan@linaro.org>
Subject: Re: [RFC v2 0/5] Common Display Framework
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigE52132CFB354F015B945ED6E"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enigE52132CFB354F015B945ED6E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 2012-11-22 23:45, Laurent Pinchart wrote:
> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>=20
> Hi everybody,
>=20
> Here's the second RFC of what was previously known as the Generic Panel=

> Framework.

Nice work! Thanks for working on this.

I was doing some testing with the code, seeing how to use it in omapdss.
Here are some thoughts:

In your model the DSS gets the panel devices connected to it from
platform data. After the DSS and the panel drivers are loaded, DSS gets
a notification and connects DSS and the panel.

I think it's a bit limited way. First of all, it'll make the DT data a
bit more complex (although this is not a major problem). With your
model, you'll need something like:

soc-base.dtsi:

dss {
	dpi0: dpi {
	};
};

board.dts:

&dpi0 {
	panel =3D &dpi-panel;
};

/ {
	dpi-panel: dpi-panel {
		...panel data...;
	};
};

Second, it'll prevent hotplug, and even if real hotplug would not be
supported, it'll prevent cases where the connected panel must be found
dynamically (like reading ID from eeprom).

Third, it kinda creates a cyclical dependency: the DSS needs to know
about the panel and calls ops in the panel, and the panel calls ops in
the DSS. I'm not sure if this is an actual problem, but I usually find
it simpler if calls are done only in one direction.


What I suggest is take a simpler approach, something alike to how
regulators or gpios are used, even if slightly more complex than those:
the entity that has a video output (SoC's DSS, external chips) offers
that video output as resource. It doesn't know or care who uses it. The
user of the video output (panel, external chips) will find the video
output (to which it is connected in the HW) by some means, and will use
different operations on that output to operate the device.

This would give us something like the following DT data:

soc-base.dtsi:

dss {
	dpi0: dpi {
	};
};

board.dts:

/ {
	dpi-panel: dpi-panel {
		source =3D <&dpi0>;
		...panel data...;
	};
};

The panel driver would do something like this in its probe:

int dpi_panel_probe()
{
	// Find the video source, increase ref
	src =3D get_video_source_from_of("source");

	// Reserve the video source for us. others can still get and
	// observe it, but cannot use it as video data source.
	// I think this should cascade upstream, so that after this call
	// each video entity from the panel to the SoC's CRTC is
	// reserved and locked for this video pipeline.
	reserve_video_source(src);

	// set DPI HW configuration, like DPI data lines. The
	// configuration would come from panel's platform data
	set_dpi_config(src, config);

	// register this panel as a display.
	register_display(this);
}


The DSS's dpi driver would do something like:

int dss_dpi_probe()
{
	// register as a DPI video source
	register_video_source(this);
}

A DSI-2-DPI chip would do something like:

int dsi2dpi_probe()
{
	// get, reserve and config the DSI bus from SoC
	src =3D get_video_source_from_of("source");
	reserve_video_source(src);
	set_dsi_config(src, config);

	// register as a DPI video source
	register_video_source(this);
}


Here we wouldn't have similar display_entity as you have, but video
sources and displays. Video sources are elements in the video pipeline,
and a video source is used only by the next downstream element. The last
element in the pipeline would not be a video source, but a display,
which would be used by the upper layer.

Video source's ops would deal with things related to the video bus in
question, like configuring data lanes, sending DSI packets, etc. The
display ops would be more high level things, like enable, update, etc.
Actually, I guess you could consider the display to represent and deal
with the whole pipeline, while video source deals with the bus between
two display entities.

 Tomi



--------------enigE52132CFB354F015B945ED6E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQr415AAoJEPo9qoy8lh71Tz4P/RcVvM8ey8XnHzm6/WmehYUd
Zjf9MgyIIrSaG/N1uwKLqlbWmnapjvnHXtDglRbYS22F1yhsHFOKGO16lhxOyCBZ
XfKJxX097gbNjpVy1JxUT6haPDVglqV/cMx2hRr5XE906NEaDqh/p3jD8ifkxi8N
KlKzh5dJAyKxd6NFSBdmsR3WvVJh5h/UHypP/FA47LC8pQtl7KdA6wL2IGabpfBt
W0m7o5eIeM0r/5Zazz/1cDsYbxUASDfCGiPDE/SqvC2HyyA05nS2ZSB1r/wA3ewO
moHSZmVMMU8W5ULdErUeZsmVtO7w3y6VkwCO7CGNVsjW7qt6AQWF/ez9Ki1bl2DE
kiZHG7t5J8SAIISTJSRhk+ChbOeSzNDlAS3om6rwSbDa0ce5PUS0u9MfvpIr84Bj
bz4DZaG/N/1Ex4H+kwf0KgVeh+rfyupRUy0Q5H1iAC5hYbxuRlokLxbhvhkktpVM
7MhWWIqND9hNXQiZlp+W0ty8qBRZlK4SrTmVTLVEt5YefDgGMuifyIwqYf6EtL30
XSjll9h9xcHL3R0TaPNU8j6L92ITwAq/Senq4q8myYZCEi2bsTNlIJyR3125c2yD
V0sLLrlmWaj0XpVfRInc1rbrMQUpIXdR2KitBN50ENt3K6hiC6FCGgCT5RsHte97
EyuVObK09GYQTpmX3HJd
=//6f
-----END PGP SIGNATURE-----

--------------enigE52132CFB354F015B945ED6E--
