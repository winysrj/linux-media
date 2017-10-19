Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:43892 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752687AbdJSNaL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 09:30:11 -0400
Date: Thu, 19 Oct 2017 15:30:07 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv4 4/4] drm/tegra: add cec-notifier support
Message-ID: <20171019133007.GU9005@ulmo>
References: <20170911122952.33980-1-hverkuil@xs4all.nl>
 <20170911122952.33980-5-hverkuil@xs4all.nl>
 <20171019131716.GT9005@ulmo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1PHmS26pdpOR3Xc0"
Content-Disposition: inline
In-Reply-To: <20171019131716.GT9005@ulmo>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--1PHmS26pdpOR3Xc0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 19, 2017 at 03:17:16PM +0200, Thierry Reding wrote:
> On Mon, Sep 11, 2017 at 02:29:52PM +0200, Hans Verkuil wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> >=20
> > In order to support CEC the HDMI driver has to inform the CEC driver
> > whenever the physical address changes. So when the EDID is read the
> > CEC driver has to be informed and whenever the hotplug detect goes
> > away.
> >=20
> > This is done through the cec-notifier framework.
> >=20
> > The link between the HDMI driver and the CEC driver is done through
> > the hdmi_phandle in the tegra-cec node in the device tree.
> >=20
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/gpu/drm/tegra/Kconfig  | 1 +
> >  drivers/gpu/drm/tegra/drm.h    | 3 +++
> >  drivers/gpu/drm/tegra/hdmi.c   | 9 +++++++++
> >  drivers/gpu/drm/tegra/output.c | 6 ++++++
> >  4 files changed, 19 insertions(+)
> >=20
> > diff --git a/drivers/gpu/drm/tegra/Kconfig b/drivers/gpu/drm/tegra/Kcon=
fig
> > index 2db29d67193d..c882918c2024 100644
> > --- a/drivers/gpu/drm/tegra/Kconfig
> > +++ b/drivers/gpu/drm/tegra/Kconfig
> > @@ -8,6 +8,7 @@ config DRM_TEGRA
> >  	select DRM_PANEL
> >  	select TEGRA_HOST1X
> >  	select IOMMU_IOVA if IOMMU_SUPPORT
> > +	select CEC_CORE if CEC_NOTIFIER
> >  	help
> >  	  Choose this option if you have an NVIDIA Tegra SoC.
> > =20
> > diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
> > index 6d6da01282f3..c0a18b60caf1 100644
> > --- a/drivers/gpu/drm/tegra/drm.h
> > +++ b/drivers/gpu/drm/tegra/drm.h
> > @@ -212,6 +212,8 @@ int tegra_dc_state_setup_clock(struct tegra_dc *dc,
> >  			       struct clk *clk, unsigned long pclk,
> >  			       unsigned int div);
> > =20
> > +struct cec_notifier;
> > +
> >  struct tegra_output {
> >  	struct device_node *of_node;
> >  	struct device *dev;
> > @@ -219,6 +221,7 @@ struct tegra_output {
> >  	struct drm_panel *panel;
> >  	struct i2c_adapter *ddc;
> >  	const struct edid *edid;
> > +	struct cec_notifier *notifier;
> >  	unsigned int hpd_irq;
> >  	int hpd_gpio;
> >  	enum of_gpio_flags hpd_gpio_flags;
> > diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
> > index cda0491ed6bf..fbf14e1efd0e 100644
> > --- a/drivers/gpu/drm/tegra/hdmi.c
> > +++ b/drivers/gpu/drm/tegra/hdmi.c
> > @@ -21,6 +21,8 @@
> > =20
> >  #include <sound/hda_verbs.h>
> > =20
> > +#include <media/cec-notifier.h>
> > +
> >  #include "hdmi.h"
> >  #include "drm.h"
> >  #include "dc.h"
> > @@ -1720,6 +1722,10 @@ static int tegra_hdmi_probe(struct platform_devi=
ce *pdev)
> >  		return PTR_ERR(hdmi->vdd);
> >  	}
> > =20
> > +	hdmi->output.notifier =3D cec_notifier_get(&pdev->dev);
> > +	if (hdmi->output.notifier =3D=3D NULL)
> > +		return -ENOMEM;
> > +
> >  	hdmi->output.dev =3D &pdev->dev;
> > =20
> >  	err =3D tegra_output_probe(&hdmi->output);
> > @@ -1778,6 +1784,9 @@ static int tegra_hdmi_remove(struct platform_devi=
ce *pdev)
> > =20
> >  	tegra_output_remove(&hdmi->output);
> > =20
> > +	if (hdmi->output.notifier)
> > +		cec_notifier_put(hdmi->output.notifier);
> > +
> >  	return 0;
> >  }
> > =20
> > diff --git a/drivers/gpu/drm/tegra/output.c b/drivers/gpu/drm/tegra/out=
put.c
> > index 595d1ec3e02e..57c052521a44 100644
> > --- a/drivers/gpu/drm/tegra/output.c
> > +++ b/drivers/gpu/drm/tegra/output.c
> > @@ -11,6 +11,8 @@
> >  #include <drm/drm_panel.h>
> >  #include "drm.h"
> > =20
> > +#include <media/cec-notifier.h>
> > +
> >  int tegra_output_connector_get_modes(struct drm_connector *connector)
> >  {
> >  	struct tegra_output *output =3D connector_to_output(connector);
> > @@ -33,6 +35,7 @@ int tegra_output_connector_get_modes(struct drm_conne=
ctor *connector)
> >  		edid =3D drm_get_edid(connector, output->ddc);
> > =20
> >  	drm_mode_connector_update_edid_property(connector, edid);
> > +	cec_notifier_set_phys_addr_from_edid(output->notifier, edid);
>=20
> I had to guard this with:
>=20
> 	#if IS_REACHABLE(CONFIG_CEC_CORE) && IS_ENABLED(CONFIG_CEC_NOTIFIER)
> 	...
> 	#endif
>=20
> to enable this driver to be built without CEC_NOTIFIER enabled. I see
> that there are stubs defined if the above is false, but for some reason
> they don't seem to be there for me either.

Nevermind that. This was not actually failing. However, ...

> > =20
> >  	if (edid) {
> >  		err =3D drm_add_edid_modes(connector, edid);
> > @@ -68,6 +71,9 @@ tegra_output_connector_detect(struct drm_connector *c=
onnector, bool force)
> >  			status =3D connector_status_connected;
> >  	}
> > =20
> > +	if (status !=3D connector_status_connected)
> > +		cec_notifier_phys_addr_invalidate(output->notifier);

This doesn't seem to exist in v4.14-rc1 which is the base for the
drm/tegra tree for v4.15. I see this function will be introduced in
v4.15 via the media tree.

How about if I replace this by:

	cec_notifier_set_phys(output->notifier, CEC_PHYS_ADDR_INVALID);

for now and switch it over to the new function after v4.15-rc1? That way
we can avoid the extra dependency between the media and drm trees.

Thierry

--1PHmS26pdpOR3Xc0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlnoqNwACgkQ3SOs138+
s6HWXhAAto+5cflBsi4YZshztRUJuIxH1gsHr2Q+Z7IYa3P9da+E8TFhrB7CNcKi
G90gYawQNFV/8Ss2U1RffXnF6ByC8Pw6ywDm3vfstqkW4iFSUyu/XniEtQ5GtUgP
BGyUD0tuMkjxrczYqppWLML6qXUySBcoI7SgISD8NaK+YZgKmL9tzqJQYAO5WSwd
uZbcXz+DmR8qeIBRa6Vsc6K+4tiQscLsfj05VqXynRt1sddepYaTJUB45Fp/USlw
OWA8UYseKLrCabmwK5tr5X+LSuu54uRgYTQiBHkt+k2Tr+t2j7r3bLGzBROdAMWE
qgKBY/zq8ay/TD+pYZ8nBpy2Q6elO5NdIn0dAilLlPleVVgcycNkTOv2e3ejO0hQ
ti3cFjt6IJ9IseBPpQJ/KhPkWisXIEYXnw4COk10ypPmGyUnHK/5RCnGEVxt0hbq
vGPqtmHnf+qMWrGlzPOgKlJwXFkffqp2fH8IJRowbAzCzDCu9FKmoABV6OPgmTd6
p2d9oKlmBu2MaKWKNQiVP8pxulKfJB0fbYUY+ozyoc7zKSrq+VCElUHip3fOm4Rh
R4Lfq8MQgKO4uXkhWnF8Y008nygL+l35+zHH/yW7A9iL91q92GPya3qGOKWkDltB
Dvj1FUvm+GGktIESFgarUemfCPn4FY6UxFsq2HN5OBoNQG2edv0=
=7Q9W
-----END PGP SIGNATURE-----

--1PHmS26pdpOR3Xc0--
