Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:45888 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751012AbdJSNRU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 09:17:20 -0400
Date: Thu, 19 Oct 2017 15:17:16 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv4 4/4] drm/tegra: add cec-notifier support
Message-ID: <20171019131716.GT9005@ulmo>
References: <20170911122952.33980-1-hverkuil@xs4all.nl>
 <20170911122952.33980-5-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mgIE+9cwyCTt+85Z"
Content-Disposition: inline
In-Reply-To: <20170911122952.33980-5-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mgIE+9cwyCTt+85Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 11, 2017 at 02:29:52PM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> In order to support CEC the HDMI driver has to inform the CEC driver
> whenever the physical address changes. So when the EDID is read the
> CEC driver has to be informed and whenever the hotplug detect goes
> away.
>=20
> This is done through the cec-notifier framework.
>=20
> The link between the HDMI driver and the CEC driver is done through
> the hdmi_phandle in the tegra-cec node in the device tree.
>=20
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/gpu/drm/tegra/Kconfig  | 1 +
>  drivers/gpu/drm/tegra/drm.h    | 3 +++
>  drivers/gpu/drm/tegra/hdmi.c   | 9 +++++++++
>  drivers/gpu/drm/tegra/output.c | 6 ++++++
>  4 files changed, 19 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/tegra/Kconfig b/drivers/gpu/drm/tegra/Kconfig
> index 2db29d67193d..c882918c2024 100644
> --- a/drivers/gpu/drm/tegra/Kconfig
> +++ b/drivers/gpu/drm/tegra/Kconfig
> @@ -8,6 +8,7 @@ config DRM_TEGRA
>  	select DRM_PANEL
>  	select TEGRA_HOST1X
>  	select IOMMU_IOVA if IOMMU_SUPPORT
> +	select CEC_CORE if CEC_NOTIFIER
>  	help
>  	  Choose this option if you have an NVIDIA Tegra SoC.
> =20
> diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
> index 6d6da01282f3..c0a18b60caf1 100644
> --- a/drivers/gpu/drm/tegra/drm.h
> +++ b/drivers/gpu/drm/tegra/drm.h
> @@ -212,6 +212,8 @@ int tegra_dc_state_setup_clock(struct tegra_dc *dc,
>  			       struct clk *clk, unsigned long pclk,
>  			       unsigned int div);
> =20
> +struct cec_notifier;
> +
>  struct tegra_output {
>  	struct device_node *of_node;
>  	struct device *dev;
> @@ -219,6 +221,7 @@ struct tegra_output {
>  	struct drm_panel *panel;
>  	struct i2c_adapter *ddc;
>  	const struct edid *edid;
> +	struct cec_notifier *notifier;
>  	unsigned int hpd_irq;
>  	int hpd_gpio;
>  	enum of_gpio_flags hpd_gpio_flags;
> diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
> index cda0491ed6bf..fbf14e1efd0e 100644
> --- a/drivers/gpu/drm/tegra/hdmi.c
> +++ b/drivers/gpu/drm/tegra/hdmi.c
> @@ -21,6 +21,8 @@
> =20
>  #include <sound/hda_verbs.h>
> =20
> +#include <media/cec-notifier.h>
> +
>  #include "hdmi.h"
>  #include "drm.h"
>  #include "dc.h"
> @@ -1720,6 +1722,10 @@ static int tegra_hdmi_probe(struct platform_device=
 *pdev)
>  		return PTR_ERR(hdmi->vdd);
>  	}
> =20
> +	hdmi->output.notifier =3D cec_notifier_get(&pdev->dev);
> +	if (hdmi->output.notifier =3D=3D NULL)
> +		return -ENOMEM;
> +
>  	hdmi->output.dev =3D &pdev->dev;
> =20
>  	err =3D tegra_output_probe(&hdmi->output);
> @@ -1778,6 +1784,9 @@ static int tegra_hdmi_remove(struct platform_device=
 *pdev)
> =20
>  	tegra_output_remove(&hdmi->output);
> =20
> +	if (hdmi->output.notifier)
> +		cec_notifier_put(hdmi->output.notifier);
> +
>  	return 0;
>  }
> =20
> diff --git a/drivers/gpu/drm/tegra/output.c b/drivers/gpu/drm/tegra/outpu=
t.c
> index 595d1ec3e02e..57c052521a44 100644
> --- a/drivers/gpu/drm/tegra/output.c
> +++ b/drivers/gpu/drm/tegra/output.c
> @@ -11,6 +11,8 @@
>  #include <drm/drm_panel.h>
>  #include "drm.h"
> =20
> +#include <media/cec-notifier.h>
> +
>  int tegra_output_connector_get_modes(struct drm_connector *connector)
>  {
>  	struct tegra_output *output =3D connector_to_output(connector);
> @@ -33,6 +35,7 @@ int tegra_output_connector_get_modes(struct drm_connect=
or *connector)
>  		edid =3D drm_get_edid(connector, output->ddc);
> =20
>  	drm_mode_connector_update_edid_property(connector, edid);
> +	cec_notifier_set_phys_addr_from_edid(output->notifier, edid);

I had to guard this with:

	#if IS_REACHABLE(CONFIG_CEC_CORE) && IS_ENABLED(CONFIG_CEC_NOTIFIER)
	...
	#endif

to enable this driver to be built without CEC_NOTIFIER enabled. I see
that there are stubs defined if the above is false, but for some reason
they don't seem to be there for me either.

> =20
>  	if (edid) {
>  		err =3D drm_add_edid_modes(connector, edid);
> @@ -68,6 +71,9 @@ tegra_output_connector_detect(struct drm_connector *con=
nector, bool force)
>  			status =3D connector_status_connected;
>  	}
> =20
> +	if (status !=3D connector_status_connected)
> +		cec_notifier_phys_addr_invalidate(output->notifier);

Same here.

Thierry

--mgIE+9cwyCTt+85Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlnopdkACgkQ3SOs138+
s6FTPQ//QJ9lWPpkdyOL5WWo4tjDq8bDYeyBavkO9m9X+sAY6Ug0hJXoWWLOKRRC
r6Vxasa8noLMDIRJlGLLCo2JUFbzoc/EE0PJc3MehJk4e2NCfB0RfAFRaCthmLo9
OEacddUNHPsHm7pn/dbPpCd1CKkBUoe19i0PrnOYrnwU1+LkJ8rIBN4Q8mrEKjGM
d3L44fx23J337K0xdEhM54w/rC3dIyIqHxX1utJhycS6sO6LE3o3ESH3/1fUWopi
Eq1mxKYgYm9X/bhaDV3KDhYSSWtXkhhf2H8Fve4q0iHE8IBV2U7sVi4vYKoM3iIR
cvgafvoDI3ppI5fvzyeTAtQSrEaOecYxGMQHAW2zwDS+CtwpKN9IoYYMUY2BQXya
HQHcgnKo7oX5PDDbh8ROudjUC/kkWgTSldwbEJVu81MBQUsqHdvwskI3oEdIDqdZ
IIwV8UQkYPeGGhBLEB5Nw6mTxAvagPWGqEOYgViwiPslaMKikBArVIDVEGb3GKMQ
Z177fwDVyQ2QoPaWioCw8FSpeCll31zTY5s6tIJWbKWh/GnYOd3wFa/0b5rOeecp
2ikwoEKNID63L/qFQ8gOi2eWIxVvD1OrW3+d5pPeqMbvQultIbtqCMWm2HN+hFRJ
rWJ5a+exPdpuoXrTiObNTI/YwMJNz5UHNbAiETMr7k/Y/hZngbc=
=OmU6
-----END PGP SIGNATURE-----

--mgIE+9cwyCTt+85Z--
