Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:54341 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752142Ab2ISLpf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 07:45:35 -0400
Received: by lbbgj3 with SMTP id gj3so753708lbb.19
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2012 04:45:32 -0700 (PDT)
Message-ID: <1348055129.2565.54.camel@deskari>
Subject: Re: [RFC 0/5] Generic panel framework
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	Bryan Wu <bryan.wu@canonical.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	Sumit Semwal <sumit.semwal@ti.com>,
	Archit Taneja <archit@ti.com>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Inki Dae <inki.dae@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Alexandre Courbot <acourbot@nvidia.com>
Date: Wed, 19 Sep 2012 14:45:29 +0300
In-Reply-To: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-R8a6q3oReQ1az69Eh5Nv"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-R8a6q3oReQ1az69Eh5Nv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 2012-08-17 at 02:49 +0200, Laurent Pinchart wrote:
> Hi everybody,
>=20
> While working on DT bindings for the Renesas Mobile SoC display controlle=
r
> (a.k.a. LCDC) I quickly realized that display panel implementation based =
on
> board code callbacks would need to be replaced by a driver-based panel
> framework.

I thought I'd try to approach the common panel framework by creating
device tree examples that OMAP would need. I only thought about the
connections and organization, not individual properties, so I have not
filled any "compatible" or such properties.

What I have below is first DT data for OMAP SoC (more or less what omap4
has), then display examples of different board setups. The hardware
examples I have here are all real, so no imaginary use cases =3D).

We don't need to implement support for all these at once, but I think
the DT data structure should be right from the start, so I'm posting
this to get discussion about the format.


OMAP SoC
=3D=3D=3D=3D=3D=3D=3D=3D

So here's first the SoC specific display nodes. OMAP has a DSS (display
subsystem) block, which contains the following elements:

- DISPC (display controller) reads the pixels from memory and outputs
them using specified video timings. DISPC has three outputs, LCD0, LCD1
and TV. These are SoC internal outputs, they do not go outside the SoC.

- DPI gets its data from DISPC's LCD0, and outputs MIPI DPI (parallel
RBG)

- Two independent DSI modules, which get their data from LCD0 or LCD1,
and output MIPI DSI (a serial two-way video bus)

- HDMI, gets data from DISPC's TV output and outputs HDMI

/ {
	ocp {
		dss {
			dispc {
				dss-lcd0: output@0 {
				};

				dss-lcd1: output@1 {
				};

				dss-tv: output@2 {
				};
			};

			dpi: dpi {
				video-source =3D <&dss-lcd0>;
			};

			dsi0: dsi@0 {
				video-source =3D <&dss-lcd0>;
			};

			dsi1: dsi@1 {
				video-source =3D <&dss-lcd1>;
			};

			hdmi: hdmi {
				video-source =3D <&dss-tv>;
			};
		};
	};
};

I have defined all the relevant nodes, and video-source property is used
to point to the source for video data. I also define aliases for the SoC
outputs so that panels can use them.

One thing to note is that the video sources for some of the blocks, like
DSI, are not hardcoded in the HW, so dsi0 could get its data from LCD0
or LCD1. However, I don't think they are usually changed during runtime,
and the dss driver cannot change them independently for sure (meaning
that some upper layer should tell it how to change the config). Thus I
specify sane defaults here, but the board dts files can of course
override the video sources.

Another thing to note is that we have more outputs from OMAP than we
have outputs from DISPC. This means that the same video source is used
by multiple sinks (LCD0 used by DPI and DSI0). DPI and DSI0 cannot be
used at the same time, obviously.

And third thing to note, DISPC node defines outputs explicitly, as it
has multiple outputs, whereas the external outputs do not as they have
only one output. Thus the node's output is implicitly the node itself.
So, instead of having:

ds0: dsi@0 {
	video-source =3D <&dss-lcd0>;
	dsi0-out0: output@0 {
	};
};

I have:

dsi0: dsi@0 {
	video-source =3D <&dss-lcd0>;
};

Of this I'm a bit unsure. I believe in most cases there's only one
output, so it'd be nice to have a shorter representation, but I'm not
sure if it's good to handle the cases for single and multiple outputs
differently. Or if it's good to mix control and data busses, as, for
example, dsi0 can be used as both control and data bus. Having the
output defined explicitly would separate the control and data bus nodes.


Simple DPI panel
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Here a board has a DPI panel, which is controlled via i2c. Panel nodes
are children of the control bus, so in this case we define the panel
under i2c2.

&i2c2 {
	dpi-lcd-panel {
		video-source =3D <&dpi>;

	};
};


HDMI
=3D=3D=3D=3D

OMAP has a HDMI output, but it cannot be connected directly to an HDMI
cable. TI uses tpd12s015 chip in its board, which provides ESD,
level-shifting and whatnot (I'm an SW guy, google for the chip to read
the details =3D). tpd12s015 has a few GPIOs and powers that need to be
controlled, so we need a driver for it.

There's no control bus for the tpd12s015, so it's platform device. Then
there's the device for the HDMI monitor, and the DDC lines are connected
to OMAP's i2c4, thus the hdmi monitor device is a child of i2c.

/ {
	hdmi-connector: tpd12s015 {
		video-source =3D <&hdmi>;
	};
};

&i2c4 {
	hdmi-monitor {
		video-source =3D <&hdmi-connector>;
	};
};


DSI bridge chip
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

In this board we have a DSI bridge chip that is controlled via DSI, and
gets the pixel data via DSI video mode stream. The chip converts this to
LVDS. We then have an LVDS panel connected to this bridge chip, which is
controlled via SPI.

&dsi0 {
	dsi2lvds: dsi2lvds {
		video-source =3D <&dsi0>;

	};
};

&spi2 {
	lvds-lcd-panel {
		video-source =3D <&dsi2lvds>;
	};
};


High res dual-DSI panel
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Here we have a DSI video mode panel that gets its data from two DSI
buses. This allows it to get the combined bandwidth of the DSI buses,
achieving higher resolution than with single DSI bus. The panel is
controlled via the first DSI bus.

&dsi0 {
	dual-dsi-panel {
		video-source-1 =3D <&dsi0>;
		video-source-2 =3D <&dsi1>;

	};
};


DSI buffer chip with two outputs
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D

This board has a DSI command mode buffer chip, that contains its own
framebuffer. The buffer chip has two DPI outputs, which get the pixels
from the framebuffer. Similar to OMAP's DISPC this chip has multiple
outputs so they need to be defined explicitly. And we also have two
dummy DPI panels connected to this buffer chip.

&dsi0 {
	dsibuf {
		video-source =3D <&dsi0>;

		dsibuf-dpi0: output@0 {
		};

		dsibuf-dpi1: output@1 {
		};
	};
};

/ {
	dpi-lcd-panel@0 {
		video-source =3D <&dsibuf-dpi0>;

	};

	dpi-lcd-panel@1 {
		video-source =3D <&dsibuf-dpi1>;

	};
};

 Tomi


--=-R8a6q3oReQ1az69Eh5Nv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQWbBZAAoJEPo9qoy8lh71x88P/A4GZt/4vVGpUf51NjpRzOZr
NbNPrqjtTYrjD+cgPEBjF/m5jdPkkhtiqQFwaxanahby+YoC2rilHhbP7TWesGOi
nqeiG15mA5DTGkI8q91zlLZGlJneHZFtrihyz0FXOOuEHn0KqMGfvSRyYQohDplE
vxluOXrHoA4HvTDF1QCgEUzWS+euzdhdAcG4sZjrlcFKX2/0XhBJDaUNZIlswG5N
6ekWBadSfesXDI2FP1bcZ3b2PEInEJ49PXks8UjKbz1409qRUI6JJF+nJgxr47XS
cezuyDe/7UqXrhtwnw9Bhkq2TfnvG3C+SskX4dcU/NRGgbHLPcPOxkcevyAuXwxu
qMikoAgCY/3C5hv54Pi4tGIQISR2/Aa+idOeGJ1sv/K4V8ftbvkaH6Lm9MPps0iC
gsoEY/cmUKB6kYlKmrOjJ2VZirRVEB3uL8jh4mqjcJBF1Q0txupJHF1AHR0Tbu3d
XZPpIfK80gCVvV71qBZzCaugYfLbxkbRisENEbZRJHDvT1Q5FdTs7k/km5kK+5+L
yQm2bd294eBy5IRAhBw3wGUewjxKTtnczCOEm0mc1+xCS1IIW9zrLLIkyuteOmvg
0v1l329LqV+Sx7ptTn/inuS7ILvT990u96m60+icXjhSgLxSeXXq3HjmfI/r/wlC
4a9M9DMgsB7Pihuz35fg
=pQuG
-----END PGP SIGNATURE-----

--=-R8a6q3oReQ1az69Eh5Nv--

