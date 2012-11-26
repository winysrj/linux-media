Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:54654 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab2KZMhy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Nov 2012 07:37:54 -0500
Message-ID: <50B36286.7010704@ti.com>
Date: Mon, 26 Nov 2012 14:37:26 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: <devicetree-discuss@lists.ozlabs.org>,
	Rob Herring <robherring2@gmail.com>,
	<linux-fbdev@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	<linux-media@vger.kernel.org>,
	Stephen Warren <swarren@wwwdotorg.org>,
	<kernel@pengutronix.de>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	David Airlie <airlied@linux.ie>
Subject: Re: [PATCHv15 2/7] video: add display_timing and videomode
References: <1353920848-1705-1-git-send-email-s.trumtrar@pengutronix.de> <1353920848-1705-3-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1353920848-1705-3-git-send-email-s.trumtrar@pengutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigE10E60E74F53751CDC28A32F"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enigE10E60E74F53751CDC28A32F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-11-26 11:07, Steffen Trumtrar wrote:

> +/*
> + * Subsystem independent description of a videomode.
> + * Can be generated from struct display_timing.
> + */
> +struct videomode {
> +	u32 pixelclock;		/* pixelclock in Hz */

I don't know if this is of any importance, but the linux clock framework
manages clock rates with unsigned long. Would it be better to use the
same type here?

> +	u32 hactive;
> +	u32 hfront_porch;
> +	u32 hback_porch;
> +	u32 hsync_len;
> +
> +	u32 vactive;
> +	u32 vfront_porch;
> +	u32 vback_porch;
> +	u32 vsync_len;
> +
> +	u32 hah;		/* hsync active high */
> +	u32 vah;		/* vsync active high */
> +	u32 de;			/* data enable */
> +	u32 pixelclk_pol;

What values will these 4 have? Aren't these booleans?

The data enable comment should be "data enable active high".

The next patch says in the devtree binding documentation that the values
may be on/off/ignored. Is that represented here somehow, i.e. values are
0/1/2 or so? If not, what does it mean if the value is left out from
devtree data, meaning "not used on hardware"?

There's also a "doubleclk" value mentioned in the devtree bindings doc,
but not shown here.

I think this videomode struct is the one that display drivers are going
to use (?), in addition to the display_timing, so it would be good to
document it well.

 Tomi



--------------enigE10E60E74F53751CDC28A32F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQs2KKAAoJEPo9qoy8lh71Kb4QAI/EpmPrknERI/HM5+43WedB
vhuC6WTKEnoURcQpotJL+wl0WNuLENGR/pkGiRBT2wJVuhERHv7/XeYV4umMvGcR
yCF4gBYlZrbYYG1tZinJgDJlSgdir7a6j39sXz4ufnxgm11ONVlfqg7iGKCjJ3jS
7e4qVjmRT5CJ7T+odtuVcJvIlyQw69lSDImJ7EFkqiIopAmpvKQzdb5uCvS6FYAg
ukJGmH6tPGgMtk25YKIT+CJACs1lZfDysHcX4RpAb4AN29SV0gBsFN/wnVATOCP1
hUAStv/72Z/jxWvG0Cq1jxwyVB4M6k3WcxoZwGj6yOcquUYH/JUVUtUwwx94qV7l
l95c4qxgTN+R5H5EKhzBtrZLWGEBWFi/BKM5Fot+4qW5rcF7G4R7hbsVqq3vKr9v
pwDlTSpi5RG7yZ1bfe6MBGLUFXaivqeWq0UgUPmiK361z5eRU4xtQHs498/VGajz
UiQQqzlILQlk8EkImHN5SpMbO6JQKUOF8BFYct9fqxMU6PrPUsXJZ8QXp84arEes
OOrk56fozhgSpQy+H42tEiOfnhPLrUn0ckq1e7L9uPz10xmyMLZdgmeOcEtPntvw
2JKKL8qBpuuFZiJly9xxKupa6XmQvdghEXJoQCrE9nZA4rgh68ls9oq+WSFAo8iO
NN0oVfiviH2sJb4GrI46
=0bJ/
-----END PGP SIGNATURE-----

--------------enigE10E60E74F53751CDC28A32F--
