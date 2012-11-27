Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:40592 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088Ab2K0NII (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 08:08:08 -0500
Message-ID: <50B4BB0F.8070306@ti.com>
Date: Tue, 27 Nov 2012 15:07:27 +0200
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
Subject: Re: [RFC v2 1/5] video: Add generic display entity core
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com> <1353620736-6517-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1353620736-6517-2-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigE45A9C0E179F35D5945D0348"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enigE45A9C0E179F35D5945D0348
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 2012-11-22 23:45, Laurent Pinchart wrote:
> +/**
> + * display_entity_get_modes - Get video modes supported by the display=
 entity
> + * @entity The display entity
> + * @modes: Pointer to an array of modes
> + *
> + * Fill the modes argument with a pointer to an array of video modes. =
The array
> + * is owned by the display entity.
> + *
> + * Return the number of supported modes on success (including 0 if no =
mode is
> + * supported) or a negative error code otherwise.
> + */
> +int display_entity_get_modes(struct display_entity *entity,
> +			     const struct videomode **modes)
> +{
> +	if (!entity->ops.ctrl || !entity->ops.ctrl->get_modes)
> +		return 0;
> +
> +	return entity->ops.ctrl->get_modes(entity, modes);
> +}
> +EXPORT_SYMBOL_GPL(display_entity_get_modes);
> +
> +/**
> + * display_entity_get_size - Get display entity physical size
> + * @entity: The display entity
> + * @width: Physical width in millimeters
> + * @height: Physical height in millimeters
> + *
> + * When applicable, for instance for display panels, retrieve the disp=
lay
> + * physical size in millimeters.
> + *
> + * Return 0 on success or a negative error code otherwise.
> + */
> +int display_entity_get_size(struct display_entity *entity,
> +			    unsigned int *width, unsigned int *height)
> +{
> +	if (!entity->ops.ctrl || !entity->ops.ctrl->get_size)
> +		return -EOPNOTSUPP;
> +
> +	return entity->ops.ctrl->get_size(entity, width, height);
> +}
> +EXPORT_SYMBOL_GPL(display_entity_get_size);

How do you envision these to be used with, say, DVI monitors with EDID
data? Should each panel driver, that manages a device with EDID, read
and parse the EDID itself? I guess that shouldn't be too difficult with
a common EDID lib, but that will only expose some of the information
found from EDID. Should the upper levels also have a way to get the raw
EDID data, in addition to funcs like above?

 Tomi



--------------enigE45A9C0E179F35D5945D0348
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQtLsPAAoJEPo9qoy8lh71N8cP/23ASSeUAx1kPHy6k/dyTWo6
Y1u0jj7AbdsXFVv+9Y7bT0RmDm3bcStLbqjR7p6ZmKv21D0XoqN56IyxMVchmDe2
bDm4org1UvSh+in8azpBnurhNJIWPAXuDdR8mxSmUzeWGoM9NDsKDd6aAddhgn2L
bGvHAp36oUFCPcmJYVDHCxvsD8ygLogzlTTZLWuS5Jadcszn4oy9I3PCLyMHMpmN
kgSUI8oVZHYoZjFqSA6Pu0JpbzyutFgi0fQ4arQRp2HPjU0TE1I1xh0F0L8Bp36u
1Ww4pROW6q6u1QBlqSuEFgq+NRHZDn5FsJBK7f+jcGSW0KO2E9W1BD8DDRGQ45eC
JDsPHJnZ8coaF+nj6rgfdoEc/bQrj2z/dVaebiLuHvTd9nQ/Y1F9KUs8cT5REYKC
WAtE07az5BBbO8CWbQcxKvggHYNI6mvnVwgkGpuwA10kkH4xSyqpUIn9q9uPNRBi
NAMlkyyYgQC3FNws2FSztsTYPvYxtNoofDPYW/RgQai9AgyGxfVhqr1UVl7URMab
WL6QuzKxOhJM7QHjyr368FMYoMVaF2Q1vOdrf9JK6ZMWdnhE0TbE/sGprxUXapf2
N/iLzekNdNVb9e4gHT4mCP+6K8EKwv9YLcUHv25G2pBlWObMyEWVZlO9lp2apy3a
n2weir1DuygMEyA4qVv6
=talx
-----END PGP SIGNATURE-----

--------------enigE45A9C0E179F35D5945D0348--
