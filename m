Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:50743 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932088AbdJSOBj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 10:01:39 -0400
Date: Thu, 19 Oct 2017 16:01:35 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv4 4/4] drm/tegra: add cec-notifier support
Message-ID: <20171019140135.GV9005@ulmo>
References: <20170911122952.33980-1-hverkuil@xs4all.nl>
 <20170911122952.33980-5-hverkuil@xs4all.nl>
 <20171019131716.GT9005@ulmo>
 <20171019133007.GU9005@ulmo>
 <7e1fcffd-76dc-c4f2-942c-b9872f73fff0@cisco.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CSNFvL6ilyiKL/Hs"
Content-Disposition: inline
In-Reply-To: <7e1fcffd-76dc-c4f2-942c-b9872f73fff0@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--CSNFvL6ilyiKL/Hs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 19, 2017 at 03:37:43PM +0200, Hans Verkuil wrote:
> On 10/19/17 15:30, Thierry Reding wrote:
> > On Thu, Oct 19, 2017 at 03:17:16PM +0200, Thierry Reding wrote:
> >> On Mon, Sep 11, 2017 at 02:29:52PM +0200, Hans Verkuil wrote:
> >>> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>>
> >>> In order to support CEC the HDMI driver has to inform the CEC driver
> >>> whenever the physical address changes. So when the EDID is read the
> >>> CEC driver has to be informed and whenever the hotplug detect goes
> >>> away.
> >>>
> >>> This is done through the cec-notifier framework.
> >>>
> >>> The link between the HDMI driver and the CEC driver is done through
> >>> the hdmi_phandle in the tegra-cec node in the device tree.
> >>>
> >>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>> ---
> >>>  drivers/gpu/drm/tegra/Kconfig  | 1 +
> >>>  drivers/gpu/drm/tegra/drm.h    | 3 +++
> >>>  drivers/gpu/drm/tegra/hdmi.c   | 9 +++++++++
> >>>  drivers/gpu/drm/tegra/output.c | 6 ++++++
> >>>  4 files changed, 19 insertions(+)
> >>>
> >>> diff --git a/drivers/gpu/drm/tegra/Kconfig b/drivers/gpu/drm/tegra/Kc=
onfig
> >>> index 2db29d67193d..c882918c2024 100644
> >>> --- a/drivers/gpu/drm/tegra/Kconfig
> >>> +++ b/drivers/gpu/drm/tegra/Kconfig
> >>> @@ -8,6 +8,7 @@ config DRM_TEGRA
> >>>  	select DRM_PANEL
> >>>  	select TEGRA_HOST1X
> >>>  	select IOMMU_IOVA if IOMMU_SUPPORT
> >>> +	select CEC_CORE if CEC_NOTIFIER
> >>>  	help
> >>>  	  Choose this option if you have an NVIDIA Tegra SoC.
> >>> =20
> >>> diff --git a/drivers/gpu/drm/tegra/drm.h b/drivers/gpu/drm/tegra/drm.h
> >>> index 6d6da01282f3..c0a18b60caf1 100644
> >>> --- a/drivers/gpu/drm/tegra/drm.h
> >>> +++ b/drivers/gpu/drm/tegra/drm.h
> >>> @@ -212,6 +212,8 @@ int tegra_dc_state_setup_clock(struct tegra_dc *d=
c,
> >>>  			       struct clk *clk, unsigned long pclk,
> >>>  			       unsigned int div);
> >>> =20
> >>> +struct cec_notifier;
> >>> +
> >>>  struct tegra_output {
> >>>  	struct device_node *of_node;
> >>>  	struct device *dev;
> >>> @@ -219,6 +221,7 @@ struct tegra_output {
> >>>  	struct drm_panel *panel;
> >>>  	struct i2c_adapter *ddc;
> >>>  	const struct edid *edid;
> >>> +	struct cec_notifier *notifier;
> >>>  	unsigned int hpd_irq;
> >>>  	int hpd_gpio;
> >>>  	enum of_gpio_flags hpd_gpio_flags;
> >>> diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdm=
i.c
> >>> index cda0491ed6bf..fbf14e1efd0e 100644
> >>> --- a/drivers/gpu/drm/tegra/hdmi.c
> >>> +++ b/drivers/gpu/drm/tegra/hdmi.c
> >>> @@ -21,6 +21,8 @@
> >>> =20
> >>>  #include <sound/hda_verbs.h>
> >>> =20
> >>> +#include <media/cec-notifier.h>
> >>> +
> >>>  #include "hdmi.h"
> >>>  #include "drm.h"
> >>>  #include "dc.h"
> >>> @@ -1720,6 +1722,10 @@ static int tegra_hdmi_probe(struct platform_de=
vice *pdev)
> >>>  		return PTR_ERR(hdmi->vdd);
> >>>  	}
> >>> =20
> >>> +	hdmi->output.notifier =3D cec_notifier_get(&pdev->dev);
> >>> +	if (hdmi->output.notifier =3D=3D NULL)
> >>> +		return -ENOMEM;
> >>> +
> >>>  	hdmi->output.dev =3D &pdev->dev;
> >>> =20
> >>>  	err =3D tegra_output_probe(&hdmi->output);
> >>> @@ -1778,6 +1784,9 @@ static int tegra_hdmi_remove(struct platform_de=
vice *pdev)
> >>> =20
> >>>  	tegra_output_remove(&hdmi->output);
> >>> =20
> >>> +	if (hdmi->output.notifier)
> >>> +		cec_notifier_put(hdmi->output.notifier);
> >>> +
> >>>  	return 0;
> >>>  }
> >>> =20
> >>> diff --git a/drivers/gpu/drm/tegra/output.c b/drivers/gpu/drm/tegra/o=
utput.c
> >>> index 595d1ec3e02e..57c052521a44 100644
> >>> --- a/drivers/gpu/drm/tegra/output.c
> >>> +++ b/drivers/gpu/drm/tegra/output.c
> >>> @@ -11,6 +11,8 @@
> >>>  #include <drm/drm_panel.h>
> >>>  #include "drm.h"
> >>> =20
> >>> +#include <media/cec-notifier.h>
> >>> +
> >>>  int tegra_output_connector_get_modes(struct drm_connector *connector)
> >>>  {
> >>>  	struct tegra_output *output =3D connector_to_output(connector);
> >>> @@ -33,6 +35,7 @@ int tegra_output_connector_get_modes(struct drm_con=
nector *connector)
> >>>  		edid =3D drm_get_edid(connector, output->ddc);
> >>> =20
> >>>  	drm_mode_connector_update_edid_property(connector, edid);
> >>> +	cec_notifier_set_phys_addr_from_edid(output->notifier, edid);
> >>
> >> I had to guard this with:
> >>
> >> 	#if IS_REACHABLE(CONFIG_CEC_CORE) && IS_ENABLED(CONFIG_CEC_NOTIFIER)
> >> 	...
> >> 	#endif
> >>
> >> to enable this driver to be built without CEC_NOTIFIER enabled. I see
> >> that there are stubs defined if the above is false, but for some reason
> >> they don't seem to be there for me either.
> >=20
> > Nevermind that. This was not actually failing. However, ...
> >=20
> >>> =20
> >>>  	if (edid) {
> >>>  		err =3D drm_add_edid_modes(connector, edid);
> >>> @@ -68,6 +71,9 @@ tegra_output_connector_detect(struct drm_connector =
*connector, bool force)
> >>>  			status =3D connector_status_connected;
> >>>  	}
> >>> =20
> >>> +	if (status !=3D connector_status_connected)
> >>> +		cec_notifier_phys_addr_invalidate(output->notifier);
> >=20
> > This doesn't seem to exist in v4.14-rc1 which is the base for the
> > drm/tegra tree for v4.15. I see this function will be introduced in
> > v4.15 via the media tree.
>=20
> Strange. This was released in the 4.13 kernel, so you should really have =
it.
> It compiles fine for me, both with the drm tegra driver built-in and as a
> module.
>=20
> This makes no sense to me.

Sigh... you're right. I had inadvertently rebased onto a v4.13-rc1 when
build testing. Sorry for the noise, it's working perfectly fine on top
of v4.14-rc1.

Thierry

--CSNFvL6ilyiKL/Hs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlnosDwACgkQ3SOs138+
s6Fc4xAAvL4Akm4S/zBPy5X4JIB40y73yX2WW0uuBw14PQ2GgZ4o9Nt6lHvZbsrf
ZwTCqFniJ7IUGzwk1NAgpu0YeOenAp71B6OU3eshXukgqt1I1DmqgwMcjXAK0JdW
fWfgYNlfllYg6y8eFbyhQDi5vBrntRALjXDlOTVngg2WY1odpq3AclqGQenN4iL0
On+st2dv7oOove/b1IWWyctA7V2EcM8sSXCjYYK03KdwoaVvFwrgR2GPc33MJkwn
gTSsgFf26twPowmEsYLMAhzzUJZ8WyYHDoyzUiQY4yJ665amH818lCENFZVCi+g0
Fp46E5Ouc6ApcHA0BYDIlFtE87m6DZxTDFGk64zO9AQcdiULuZ/V+23v9zsFPZ/W
AGiWkV09TUfDH2vcs4c9xfD8koTwmwbxwrAoIeRvd274R6p971mPwnl8IoYQCk0b
LWSkpdpaG9UQgK29dwaJB6y7R5Y7BGeZR/s5VLE1T1CJ3Ss7MAxmI2z/HTgWYpsR
x/pia9JmNmWf5x7ThTS5l/NJA2N9+TmsWiPGMPnSNYwgyMY0w5G5RULzVVhjv52i
nRcsirJovgMh9soT1Ew3/Y9Ybgoje3obUHvQjyHWAz4C2n5MEl0detlDTFIreZZ8
xOyBov0gZS7xmvejP6v3UUnLNnqmnRQjJ5XY6JK6bJtrRC98o6c=
=4Zru
-----END PGP SIGNATURE-----

--CSNFvL6ilyiKL/Hs--
