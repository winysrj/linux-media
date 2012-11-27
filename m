Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:55113 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752164Ab2K0NC5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 08:02:57 -0500
Message-ID: <50B4B9EB.2040102@ti.com>
Date: Tue, 27 Nov 2012 15:02:35 +0200
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
Subject: Re: [RFC v2 2/5] video: panel: Add DPI panel support
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <1353620736-6517-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1353620736-6517-3-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigFD00F10070BF62D3A736FC06"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enigFD00F10070BF62D3A736FC06
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 2012-11-22 23:45, Laurent Pinchart wrote:

> +static void panel_dpi_release(struct display_entity *entity)
> +{
> +	struct panel_dpi *panel =3D to_panel_dpi(entity);
> +
> +	kfree(panel);
> +}
> +
> +static int panel_dpi_remove(struct platform_device *pdev)
> +{
> +	struct panel_dpi *panel =3D platform_get_drvdata(pdev);
> +
> +	platform_set_drvdata(pdev, NULL);
> +	display_entity_unregister(&panel->entity);
> +
> +	return 0;
> +}
> +
> +static int __devinit panel_dpi_probe(struct platform_device *pdev)
> +{
> +	const struct panel_dpi_platform_data *pdata =3D pdev->dev.platform_da=
ta;
> +	struct panel_dpi *panel;
> +	int ret;
> +
> +	if (pdata =3D=3D NULL)
> +		return -ENODEV;
> +
> +	panel =3D kzalloc(sizeof(*panel), GFP_KERNEL);
> +	if (panel =3D=3D NULL)
> +		return -ENOMEM;
> +
> +	panel->pdata =3D pdata;
> +	panel->entity.dev =3D &pdev->dev;
> +	panel->entity.release =3D panel_dpi_release;
> +	panel->entity.ops.ctrl =3D &panel_dpi_control_ops;
> +
> +	ret =3D display_entity_register(&panel->entity);
> +	if (ret < 0) {
> +		kfree(panel);
> +		return ret;
> +	}
> +
> +	platform_set_drvdata(pdev, panel);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops panel_dpi_dev_pm_ops =3D {
> +};
> +
> +static struct platform_driver panel_dpi_driver =3D {
> +	.probe =3D panel_dpi_probe,
> +	.remove =3D panel_dpi_remove,
> +	.driver =3D {
> +		.name =3D "panel_dpi",
> +		.owner =3D THIS_MODULE,
> +		.pm =3D &panel_dpi_dev_pm_ops,
> +	},
> +};

I'm not sure of how the free/release works. The release func is called
when the ref count drops to zero. But... The object in question, the
panel_dpi struct which contains the display entity, is not only about
data, it's also about code located in this module.

So I don't see anything preventing from unloading this module, while
some other component is holding a ref for the display entity. While its
holding the ref, it's valid to call ops in the display entity, but the
code for the ops in this module is already unloaded.

I don't really know how the kref can be used properly in this use case...=


 Tomi



--------------enigFD00F10070BF62D3A736FC06
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQtLnrAAoJEPo9qoy8lh71fL0QAJqQ6sNq9zRT9yfgG6WzV4xO
vzH/3hLJl+vRJ66zvf82njHjQlRjspURMQXOCOXkJmHm7hPDl5GxzrKhQLVGej/u
TQ4mYfPL/lOItaUTnLB2alrv7IyfS+y2A5GUZqdX8femnSyqmkAw89IxzEY1MJll
qNtcpMoEhvzRGywZQbfEUGAS+ukF1vawvUyQlXRHR1buZ4EwZZC5t4znMGT6lrev
aeECiNnMP/rUPyk3d7XFFzHlNlopTwpPU4V3N7S9N8trETHQak3YhDROcuve4F6K
NuYRD1j1CsFDrp+ssmsWHNrFel/NnhmAHa83YxzTPorQPynE+JQyt5K+ErQkYiKb
Ln0gZEbVWLglA+MyIWBb6goyAlfhRhIywRi5qqX4TM29I4KtfkSk6Y+M84Ti8sdB
BvmL3VdyACA9XCk18GZX3icrHtKQbHJ6qmCG5yef68yBL6GbGt7OFgkpfcMI9xq5
DPlPkzyzNO/6wQp2m5lRpDB9GVPaoUKbpuGNkjnTu6aG7JC5ho9xDaLQU8c4Vhme
FBKSlVtjzXUAABnm6yNv+Us/2oKI4NCxRrZ4wmizgystv4PyrxIJ4bcW4M7E/LYo
Qmc73Zlx04fr9bKjhttQyAR5HQh8lgWC9xNLoMbW0ifdxeCuov+o4zP/KWc5y4lc
vJu0PD5qeeZ0zR+JC+pB
=lc2E
-----END PGP SIGNATURE-----

--------------enigFD00F10070BF62D3A736FC06--
