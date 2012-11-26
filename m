Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:58097 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795Ab2KZOoF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Nov 2012 09:44:05 -0500
Message-ID: <50B37EEC.6090808@ti.com>
Date: Mon, 26 Nov 2012 16:38:36 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: <devicetree-discuss@lists.ozlabs.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
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
Subject: Re: [PATCHv15 3/7] video: add of helper for display timings/videomode
References: <1353920848-1705-1-git-send-email-s.trumtrar@pengutronix.de> <1353920848-1705-4-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1353920848-1705-4-git-send-email-s.trumtrar@pengutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig30E97DFC1D800BE9C603588C"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enig30E97DFC1D800BE9C603588C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On 2012-11-26 11:07, Steffen Trumtrar wrote:
> This adds support for reading display timings from DT into a struct
> display_timings. The of_display_timing implementation supports multiple=

> subnodes. All children are read into an array, that can be queried.
>=20
> If no native mode is specified, the first subnode will be used.
>=20
> For cases where the graphics driver knows there can be only one
> mode description or where the driver only supports one mode, a helper
> function of_get_videomode is added, that gets a struct videomode from D=
T.
>=20
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Acked-by: Stephen Warren <swarren@nvidia.com>
> Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
> Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
> Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
> Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  .../devicetree/bindings/video/display-timing.txt   |  107 ++++++++++
>  drivers/video/Kconfig                              |   15 ++
>  drivers/video/Makefile                             |    2 +
>  drivers/video/of_display_timing.c                  |  219 ++++++++++++=
++++++++
>  drivers/video/of_videomode.c                       |   54 +++++
>  include/linux/of_display_timing.h                  |   20 ++
>  include/linux/of_videomode.h                       |   18 ++
>  7 files changed, 435 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/video/display-tim=
ing.txt
>  create mode 100644 drivers/video/of_display_timing.c
>  create mode 100644 drivers/video/of_videomode.c
>  create mode 100644 include/linux/of_display_timing.h
>  create mode 100644 include/linux/of_videomode.h
>=20
> diff --git a/Documentation/devicetree/bindings/video/display-timing.txt=
 b/Documentation/devicetree/bindings/video/display-timing.txt
> new file mode 100644
> index 0000000..e238f27
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/video/display-timing.txt
> @@ -0,0 +1,107 @@
> +display-timing bindings
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +display-timings node
> +--------------------
> +
> +required properties:
> + - none
> +
> +optional properties:
> + - native-mode: The native mode for the display, in case multiple mode=
s are
> +		provided. When omitted, assume the first node is the native.
> +
> +timing subnode
> +--------------
> +
> +required properties:
> + - hactive, vactive: display resolution
> + - hfront-porch, hback-porch, hsync-len: horizontal display timing par=
ameters
> +   in pixels
> +   vfront-porch, vback-porch, vsync-len: vertical display timing param=
eters in
> +   lines
> + - clock-frequency: display clock in Hz
> +
> +optional properties:
> + - hsync-active: hsync pulse is active low/high/ignored
> + - vsync-active: vsync pulse is active low/high/ignored
> + - de-active: data-enable pulse is active low/high/ignored
> + - pixelclk-inverted: pixelclock is inverted (active on falling edge)/=

> +				non-inverted (active on rising edge)/
> +				     ignored (ignore property)

I think hsync-active and vsync-active are clear, and commonly used, and
they are used for both drm and fb mode conversions in later patches.

de-active is not used in drm and fb mode conversions, but I think it's
also clear.

pixelclk-inverted is not used in the mode conversions. It's also a bit
unclear to me. What does it mean that pix clock is "active on rising
edge"? The pixel data is driven on rising edge? How about the sync
signals and DE, when are they driven? Does your HW have any settings
related to those?

OMAP has the invert pclk setting, but it also has a setting to define
when the sync signals are driven. The options are:
- syncs are driven on rising edge of pclk
- syncs are driven on falling edge of pclk
- syncs are driven on the opposite edge of pclk compared to the pixel dat=
a

For DE there's no setting, except the active high/low.

And if I'm not mistaken, if the optional properties are not defined,
they are not ignored, but left to the default 0. Which means active low,
or active on rising edge(?). I think it would be good to have a
"undefined" value for the properties.

> + - interlaced (bool): boolean to enable interlaced mode
> + - doublescan (bool): boolean to enable doublescan mode
> + - doubleclk (bool)

As I mentioned in the other mail, doubleclk is not used nor documented he=
re.

> +All the optional properties that are not bool follow the following log=
ic:
> +    <1>: high active
> +    <0>: low active
> +    omitted: not used on hardware
> +
> +There are different ways of describing the capabilities of a display. =
The devicetree
> +representation corresponds to the one commonly found in datasheets for=
 displays.
> +If a display supports multiple signal timings, the native-mode can be =
specified.

I have some of the same concerns for this series than with the
interpreted power sequences (on fbdev): when you publish the DT
bindings, it's somewhat final version then, and fixing it later will be
difficult. Of course, video modes are much clearer than the power
sequences, so it's possible there won't be any problems with the DT
bindings.

However, I'd still feel safer if the series would be split to non-DT and
DT parts. The non-DT parts could be merged quite easily, and people
could start using them in their kernels. This should expose
bugs/problems related to the code.

The DT part could be merged later, when there's confidence that the
timings are good for all platforms.

Or, alternatively, all the non-common bindings (de-active, pck
invert,...) that are not used for fbdev or drm currently could be left
out for now. But I'd stil prefer merging it in two parts.

 Tomi



--------------enig30E97DFC1D800BE9C603588C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQs37sAAoJEPo9qoy8lh71zJwP/i4Km77Fy9pbVD2ZyioXmyCs
PNgBGD98c9rDyVLf/v8tRlfdLNLuXhkthJCJz3ZXShIlpppp9UcvU/y8RlPBAywx
lXaD7lPaeILZjaDHRZnuIpodNndc3Sl8rfNo5TBgOPy6itY8jDSGpWFCvkFVakTa
RFazhrMcOtECbhHb8IH+a0RVlrjCmaoC8L/Gj7AMFog3NsvGbYpVlDuizaOSDg3/
oUPCwt/Ru0QsugE1cYbORdgmGsiGT0WRsF5+ZGpCNHW3dxIvQUiTr4H1PdEKHZ4q
vDTYniwLEeXbqxEp/Ohdy1WZkHgd5DOr+RoTejv/HdcSYZQ1mVaORscPrSO252j1
UmqaXCc6i821LNg+zS51eMulkAfu04EsnAAnZgCBlhM5hoG3gC58nvhIsugLe2H8
C5xcxvOMitVwbsmfl8GxZHaWxsmPY0nxwNMTd2if0XgZqUfJ9W2KOnwjxUgL1oNE
4Emq1QOg5/PXtWJYMqsIP493+10XNa+xmtBTy1NZfNk6DwHm3cYBpdkubl2sVM2s
GN1NwtyZ2zHuQDPyBZk8VtlfPZrny8xBinKiITOuvR/oMSs9cqbBbECLQz5Uq9kA
Ikgx+EeoVFbTOuKB4yUctq/TraOu29aDTyc+dwuY6AIV0PlEZzLz98dWp3r34Jz7
R8Z/Lim2bD1RShc3VxJi
=JV+3
-----END PGP SIGNATURE-----

--------------enig30E97DFC1D800BE9C603588C--
