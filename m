Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48976 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751024AbdBRWxQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 18 Feb 2017 17:53:16 -0500
Date: Sat, 18 Feb 2017 23:53:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: [RFC 04/13] omap3isp: add support for CSI1 bus
Message-ID: <20170218225312.GA14012@amd>
References: <20170214133947.GA8490@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <20170214133947.GA8490@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I guess I'll need some help here.

> @@ -160,6 +163,33 @@ static int ccp2_if_enable(struct isp_ccp2_device *cc=
p2, u8 enable)
>  			return ret;
>  	}
> =20
> +	if (isp->revision =3D=3D ISP_REVISION_2_0) {
> +		struct media_pad *pad;
> +		struct v4l2_subdev *sensor;
> +		const struct isp_ccp2_cfg *buscfg;
> +		u32 csirxfe;
> +
> +		pad =3D media_entity_remote_pad(&ccp2->pads[CCP2_PAD_SINK]);
> +		sensor =3D media_entity_to_v4l2_subdev(pad->entity);
> +		/* Struct isp_bus_cfg has union inside */
> +		buscfg =3D &((struct isp_bus_cfg *)sensor->host_priv)->bus.ccp2;
> +
> +
> +		if (enable) {
> +			csirxfe =3D OMAP343X_CONTROL_CSIRXFE_PWRDNZ |
> +				  OMAP343X_CONTROL_CSIRXFE_RESET;
> +
> +			if (buscfg->phy_layer)
> +				csirxfe |=3D OMAP343X_CONTROL_CSIRXFE_SELFORM;
> +
> +			if (buscfg->strobe_clk_pol)
> +				csirxfe |=3D OMAP343X_CONTROL_CSIRXFE_CSIB_INV;
> +		} else
> +			csirxfe =3D 0;
> +
> +		regmap_write(isp->syscon, isp->syscon_offset, csirxfe);
> +	}
> +

This is ugly. This does not belong here, it is basically duplicate of

=2E But that function is not called, because ccp2->phy is not
initialized for ISP_REVISION_2_0 in ..._ccp2_init():

int omap3isp_ccp2_init(struct isp_device *isp)
{
        if (isp->revision =3D=3D ISP_REVISION_2_0) {
                ccp2->vdds_csib =3D devm_regulator_get(isp->dev, "vdds_csib=
");
                if (IS_ERR(ccp2->vdds_csib)) {
                        if (PTR_ERR(ccp2->vdds_csib) =3D=3D -EPROBE_DEFER)
                                return -EPROBE_DEFER;
                        dev_dbg(isp->dev,
                                "Could not get regulator vdds_csib\n");
                        ccp2->vdds_csib =3D NULL;
                }
        } else if (isp->revision =3D=3D ISP_REVISION_15_0) {
                ccp2->phy =3D &isp->isp_csiphy1;
        }


=2E..phy is only initialized for REVISION_15 case. (and isp_csiphy1
seems to contain uninitialized data at this point. Below is a fix for
that).

If someone has an idea what to do there, please help. I tried
ccp2->phy =3D &isp->isp_csiphy2; but that does not have pipe
initialized, so it eventually leads to crash.

Thanks,
								Pavel


diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/pl=
atform/omap3isp/ispcsiphy.c
index 8f73f6d..a2474b6 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.c
+++ b/drivers/media/platform/omap3isp/ispcsiphy.c
@@ -362,14 +374,16 @@ int omap3isp_csiphy_init(struct isp_device *isp)
 	phy2->phy_regs =3D OMAP3_ISP_IOMEM_CSIPHY2;
 	mutex_init(&phy2->mutex);
=20
-	if (isp->revision =3D=3D ISP_REVISION_15_0) {
-		phy1->isp =3D isp;
-		phy1->csi2 =3D &isp->isp_csi2c;
-		phy1->num_data_lanes =3D ISP_CSIPHY1_NUM_DATA_LANES;
-		phy1->cfg_regs =3D OMAP3_ISP_IOMEM_CSI2C_REGS1;
-		phy1->phy_regs =3D OMAP3_ISP_IOMEM_CSIPHY1;
-		mutex_init(&phy1->mutex);
+	if (isp->revision !=3D ISP_REVISION_15_0) {
+		memset(phy1, sizeof(*phy1), 0);
+		return 0;
 	}
=20
+	phy1->isp =3D isp;
+	phy1->csi2 =3D &isp->isp_csi2c;
+	phy1->num_data_lanes =3D ISP_CSIPHY1_NUM_DATA_LANES;
+	phy1->cfg_regs =3D OMAP3_ISP_IOMEM_CSI2C_REGS1;
+	phy1->phy_regs =3D OMAP3_ISP_IOMEM_CSIPHY1;
+	mutex_init(&phy1->mutex);
 	return 0;
 }



--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlio0FgACgkQMOfwapXb+vIZOgCfQXzRkbMh8j48S8VIl8Lk7Ap6
w3QAoMIcuUoT1Ci3uDUHAVymk7ettS1P
=Et0V
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
