Return-path: <linux-media-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:42682 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752046AbdIRSSz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 14:18:55 -0400
From: Eric Anholt <eric@anholt.net>
To: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>
Subject: Re: [PATCH v2 3/4] [media] bcm2835-unicam: Driver for CCP2/CSI2 camera interface
In-Reply-To: <0d4dc119a2ba4917e0fecfe5084425830ec53ccb.1505314390.git.dave.stevenson@raspberrypi.org>
References: <cover.1505140980.git.dave.stevenson@raspberrypi.org> <0d4dc119a2ba4917e0fecfe5084425830ec53ccb.1505314390.git.dave.stevenson@raspberrypi.org>
Date: Mon, 18 Sep 2017 11:18:52 -0700
Message-ID: <87k20vswdv.fsf@anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Dave Stevenson <dave.stevenson@raspberrypi.org> writes:
> diff --git a/drivers/media/platform/bcm2835/bcm2835-unicam.c b/drivers/me=
dia/platform/bcm2835/bcm2835-unicam.c
> new file mode 100644
> index 0000000..5b1adc3
> --- /dev/null
> +++ b/drivers/media/platform/bcm2835/bcm2835-unicam.c
> @@ -0,0 +1,2192 @@
> +/*
> + * BCM2835 Unicam capture Driver
> + *
> + * Copyright (C) 2017 - Raspberry Pi (Trading) Ltd.
> + *
> + * Dave Stevenson <dave.stevenson@raspberrypi.org>
> + *
> + * Based on TI am437x driver by Benoit Parrot and Lad, Prabhakar and
> + * TI CAL camera interface driver by Benoit Parrot.
> + *

Possible future improvement: this description of the driver is really
nice and could be turned into kernel-doc.

> + * There are two camera drivers in the kernel for BCM283x - this one
> + * and bcm2835-camera (currently in staging).
> + *
> + * This driver is purely the kernel control the Unicam peripheral - there

Maybe "This driver directly controls..."?

> + * is no involvement with the VideoCore firmware. Unicam receives CSI-2
> + * or CCP2 data and writes it into SDRAM. The only processing options are
> + * to repack Bayer data into an alternate format, and applying windowing
> + * (currently not implemented).
> + * It should be possible to connect it to any sensor with a
> + * suitable output interface and V4L2 subdevice driver.
> + *
> + * bcm2835-camera uses with the VideoCore firmware to control the sensor,

"uses the"

> + * Unicam, ISP, and all tuner control loops. Fully processed frames are
> + * delivered to the driver by the firmware. It only has sensor drivers
> + * for Omnivision OV5647, and Sony IMX219 sensors.
> + *
> + * The two drivers are mutually exclusive for the same Unicam instance.
> + * The VideoCore firmware checks the device tree configuration during bo=
ot.
> + * If it finds device tree nodes called csi0 or csi1 it will block the
> + * firmware from accessing the peripheral, and bcm2835-camera will
> + * not be able to stream data.

Thanks for describing this here!

> +/*
> + * The peripheral can unpack and repack between several of
> + * the Bayer raw formats, so any Bayer format can be advertised
> + * as the same Bayer order in each of the supported bit depths.
> + * Use lower case to avoid clashing with V4L2_PIX_FMT_SGBRG8
> + * formats.
> + */
> +#define PIX_FMT_ALL_BGGR  v4l2_fourcc('b', 'g', 'g', 'r')
> +#define PIX_FMT_ALL_RGGB  v4l2_fourcc('r', 'g', 'g', 'b')
> +#define PIX_FMT_ALL_GBRG  v4l2_fourcc('g', 'b', 'r', 'g')
> +#define PIX_FMT_ALL_GRBG  v4l2_fourcc('g', 'r', 'b', 'g')

Should thes fourccs be defined in a common v4l2 header, to reserve it
from clashing with others later?

This is really the only question I have about this driver before seeing
it merged.  As far as me wearing my platform maintainer hat, I'm happy
with the driver, and my other little notes are optional.

> +static int unicam_probe(struct platform_device *pdev)
> +{
> +	struct unicam_cfg *unicam_cfg;
> +	struct unicam_device *unicam;
> +	struct v4l2_ctrl_handler *hdl;
> +	struct resource	*res;
> +	int ret;
> +
> +	unicam =3D devm_kzalloc(&pdev->dev, sizeof(*unicam), GFP_KERNEL);
> +	if (!unicam)
> +		return -ENOMEM;
> +
> +	unicam->pdev =3D pdev;
> +	unicam_cfg =3D &unicam->cfg;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	unicam_cfg->base =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(unicam_cfg->base)) {
> +		unicam_err(unicam, "Failed to get main io block\n");
> +		return PTR_ERR(unicam_cfg->base);
> +	}
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	unicam_cfg->clk_gate_base =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(unicam_cfg->clk_gate_base)) {
> +		unicam_err(unicam, "Failed to get 2nd io block\n");
> +		return PTR_ERR(unicam_cfg->clk_gate_base);
> +	}
> +
> +	unicam->clock =3D devm_clk_get(&pdev->dev, "lp_clock");
> +	if (IS_ERR(unicam->clock)) {
> +		unicam_err(unicam, "Failed to get clock\n");
> +		return PTR_ERR(unicam->clock);
> +	}
> +
> +	ret =3D platform_get_irq(pdev, 0);
> +	if (ret <=3D 0) {
> +		dev_err(&pdev->dev, "No IRQ resource\n");
> +		return -ENODEV;
> +	}
> +	unicam_cfg->irq =3D ret;
> +
> +	ret =3D devm_request_irq(&pdev->dev, unicam_cfg->irq, unicam_isr, 0,
> +			       "unicam_capture0", unicam);

Looks like there's no need to keep "irq" in the device private struct.

> +	if (ret) {
> +		dev_err(&pdev->dev, "Unable to request interrupt\n");
> +		return -EINVAL;
> +	}
> +
> +	ret =3D v4l2_device_register(&pdev->dev, &unicam->v4l2_dev);
> +	if (ret) {
> +		unicam_err(unicam,
> +			   "Unable to register v4l2 device.\n");
> +		return ret;
> +	}
> +
> +	/* Reserve space for the controls */
> +	hdl =3D &unicam->ctrl_handler;
> +	ret =3D v4l2_ctrl_handler_init(hdl, 16);
> +	if (ret < 0)
> +		goto probe_out_v4l2_unregister;
> +	unicam->v4l2_dev.ctrl_handler =3D hdl;
> +
> +	/* set the driver data in platform device */
> +	platform_set_drvdata(pdev, unicam);
> +
> +	ret =3D of_unicam_connect_subdevs(unicam);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to connect subdevs\n");
> +		goto free_hdl;
> +	}
> +
> +	/* Enabling module functional clock */
> +	pm_runtime_enable(&pdev->dev);

I think pm_runtime is only controlling the power domain for the PHY, not
the clock (which you're handling manually).

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAlnADgwACgkQtdYpNtH8
nugY2hAAnB2B60CdeULaewvf8c3ybeWyHWeCc4g4AUj5b160qkPgBtqFI8gXcljS
bPMJTu5j3A3pdYZEbOs+Nt6020do1jxSnYZMPsynLWPTvDGjKFbGbxnDp+GZhPFR
EATtg+QY+ciF/+eoEtuUZ/dF/RjkHAzqeqvpsqKaD/R6PQPJX/KjlrKxRx1OQsQq
pdHQlHGqRZ1Yo3xqELBGL/cZJvB9YLd1/8f1rR4vqagn/JcctUl/vFal26VWxPyW
9phf8q92wYtS92/sejvda12PASbAVU2Cwru6aqfuWcsgWCw44/nKC6DDgwxvjhzk
heSBkbsYP8xI9bWHIa2xGZP45GPzXYRrGQpJdACJ5ku70sPoQSv3uv7pZaGTl+Ih
ISam7ZkuEC5uMrVfj6KOPFVD4jVb+jcZ6dEP53GWlQ2bE5OEPiBKjWVXC6rryzpI
mPa0eca9eyz4fipv02TADj0hY3XlZQymGqoc3KR2o85FeG698mHBy5RGRfhjcHCG
PqhSl1JE9v+UxSQ1GvFtChlEYcuU3j5/zHJC+XjOThfDYX9woXPhgGGc95kicHWp
Ge87+g5DQLUVz5wbmIjT2sTFNi/1Z7NabFAAs/HdhoMM70Iytk4s5WIVzrukhlha
Pfm+Eejd1u09ONrrLwMrNrVtYXcJp6nIBK+xTeIXydvTWbFEXfY=
=bhxb
-----END PGP SIGNATURE-----
--=-=-=--
