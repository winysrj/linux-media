Return-path: <linux-media-owner@vger.kernel.org>
Received: from anholt.net ([50.246.234.109]:39364 "EHLO anholt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752434AbdGLTCo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 15:02:44 -0400
From: Eric Anholt <eric@anholt.net>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 4/4] drm/vc4: add HDMI CEC support
In-Reply-To: <20170711112021.38525-5-hverkuil@xs4all.nl>
References: <20170711112021.38525-1-hverkuil@xs4all.nl> <20170711112021.38525-5-hverkuil@xs4all.nl>
Date: Wed, 12 Jul 2017 12:02:40 -0700
Message-ID: <87d195h41b.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hans Verkuil <hverkuil@xs4all.nl> writes:

> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> This patch adds support to VC4 for CEC.
>
> To prevent the firmware from eating the CEC interrupts you need to add th=
is to
> your config.txt:
>
> mask_gpu_interrupt1=3D0x100
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

This looks pretty great.  Just a couple of little comments.

> ---
>  drivers/gpu/drm/vc4/Kconfig    |   8 ++
>  drivers/gpu/drm/vc4/vc4_hdmi.c | 203 +++++++++++++++++++++++++++++++++++=
+++++-
>  drivers/gpu/drm/vc4/vc4_regs.h |   5 +
>  3 files changed, 211 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/gpu/drm/vc4/Kconfig b/drivers/gpu/drm/vc4/Kconfig
> index 4361bdcfd28a..fdae18aeab4f 100644
> --- a/drivers/gpu/drm/vc4/Kconfig
> +++ b/drivers/gpu/drm/vc4/Kconfig
> @@ -19,3 +19,11 @@ config DRM_VC4
>  	  This driver requires that "avoid_warnings=3D2" be present in
>  	  the config.txt for the firmware, to keep it from smashing
>  	  our display setup.
> +
> +config DRM_VC4_HDMI_CEC
> +       bool "Broadcom VC4 HDMI CEC Support"
> +       depends on DRM_VC4
> +       select CEC_CORE
> +       help
> +	  Choose this option if you have a Broadcom VC4 GPU
> +	  and want to use CEC.

Do we need a Kconfig for this?  Couldn't we just #ifdef on CEC_CORE
instead?

> diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdm=
i.c
> index b0521e6cc281..14e2ece5db94 100644
> --- a/drivers/gpu/drm/vc4/vc4_hdmi.c
> +++ b/drivers/gpu/drm/vc4/vc4_hdmi.c

> +static int vc4_hdmi_cec_adap_enable(struct cec_adapter *adap, bool enabl=
e)
> +{
> +	struct vc4_dev *vc4 =3D cec_get_drvdata(adap);
> +	u32 hsm_clock =3D clk_get_rate(vc4->hdmi->hsm_clock);
> +	u32 cntrl1 =3D HDMI_READ(VC4_HDMI_CEC_CNTRL_1);
> +	u32 divclk =3D cntrl1 & VC4_HDMI_CEC_DIV_CLK_CNT_MASK;

We should probably be setting the divider to a value of our choice,
rather than relying on whatever default value is there.

(Bonus points if we were to do this using a common clk divider, so the
rate shows up in /debug/clk/clk_summary, but I won't require that)

> +	/* clock period in microseconds */
> +	u32 usecs =3D 1000000 / (hsm_clock / divclk);
> +	u32 val =3D HDMI_READ(VC4_HDMI_CEC_CNTRL_5);
> +
> +	val &=3D ~(VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET |
> +		 VC4_HDMI_CEC_CNT_TO_4700_US_MASK |
> +		 VC4_HDMI_CEC_CNT_TO_4500_US_MASK);
> +	val |=3D ((4700 / usecs) << VC4_HDMI_CEC_CNT_TO_4700_US_SHIFT) |
> +	       ((4500 / usecs) << VC4_HDMI_CEC_CNT_TO_4500_US_SHIFT);
> +
> +	if (enable) {
> +		cntrl1 &=3D VC4_HDMI_CEC_DIV_CLK_CNT_MASK |
> +			  VC4_HDMI_CEC_ADDR_MASK;
> +
> +		HDMI_WRITE(VC4_HDMI_CEC_CNTRL_5, val |
> +			   VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
> +		HDMI_WRITE(VC4_HDMI_CEC_CNTRL_5, val);
> +		HDMI_WRITE(VC4_HDMI_CEC_CNTRL_2,
> +			 ((1500 / usecs) << VC4_HDMI_CEC_CNT_TO_1500_US_SHIFT) |
> +			 ((1300 / usecs) << VC4_HDMI_CEC_CNT_TO_1300_US_SHIFT) |
> +			 ((800 / usecs) << VC4_HDMI_CEC_CNT_TO_800_US_SHIFT) |
> +			 ((600 / usecs) << VC4_HDMI_CEC_CNT_TO_600_US_SHIFT) |
> +			 ((400 / usecs) << VC4_HDMI_CEC_CNT_TO_400_US_SHIFT));
> +		HDMI_WRITE(VC4_HDMI_CEC_CNTRL_3,
> +			 ((2750 / usecs) << VC4_HDMI_CEC_CNT_TO_2750_US_SHIFT) |
> +			 ((2400 / usecs) << VC4_HDMI_CEC_CNT_TO_2400_US_SHIFT) |
> +			 ((2050 / usecs) << VC4_HDMI_CEC_CNT_TO_2050_US_SHIFT) |
> +			 ((1700 / usecs) << VC4_HDMI_CEC_CNT_TO_1700_US_SHIFT));
> +		HDMI_WRITE(VC4_HDMI_CEC_CNTRL_4,
> +			 ((4300 / usecs) << VC4_HDMI_CEC_CNT_TO_4300_US_SHIFT) |
> +			 ((3900 / usecs) << VC4_HDMI_CEC_CNT_TO_3900_US_SHIFT) |
> +			 ((3600 / usecs) << VC4_HDMI_CEC_CNT_TO_3600_US_SHIFT) |
> +			 ((3500 / usecs) << VC4_HDMI_CEC_CNT_TO_3500_US_SHIFT));
> +
> +		HDMI_WRITE(VC4_HDMI_CPU_MASK_CLEAR, VC4_HDMI_CPU_CEC);
> +	} else {
> +		HDMI_WRITE(VC4_HDMI_CPU_MASK_SET, VC4_HDMI_CPU_CEC);
> +		HDMI_WRITE(VC4_HDMI_CEC_CNTRL_5, val |
> +			   VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
> +	}
> +	return 0;
> +}

> +static int vc4_hdmi_cec_adap_transmit(struct cec_adapter *adap, u8 attem=
pts,
> +				      u32 signal_free_time, struct cec_msg *msg)
> +{
> +	struct vc4_dev *vc4 =3D cec_get_drvdata(adap);
> +	u32 val;
> +	unsigned int i;
> +
> +	for (i =3D 0; i < msg->len; i +=3D 4)
> +		HDMI_WRITE(VC4_HDMI_CEC_TX_DATA_1 + i,
> +			   (msg->msg[i]) |
> +			   (msg->msg[i + 1] << 8) |
> +			   (msg->msg[i + 2] << 16) |
> +			   (msg->msg[i + 3] << 24));
> +
> +	val =3D HDMI_READ(VC4_HDMI_CEC_CNTRL_1);
> +	val &=3D ~VC4_HDMI_CEC_START_XMIT_BEGIN;
> +	HDMI_WRITE(VC4_HDMI_CEC_CNTRL_1, val);
> +	val &=3D ~VC4_HDMI_CEC_MESSAGE_LENGTH_MASK;
> +	val |=3D (msg->len - 1) << VC4_HDMI_CEC_MESSAGE_LENGTH_SHIFT;
> +	val |=3D VC4_HDMI_CEC_START_XMIT_BEGIN;

It doesn't look to me like len should have 1 subtracted from it.  The
field has 4 bits for our up-to-16-byte length, and the firmware seems to
be setting it to the same value as a memcpy for the message data uses.

> +
> +	HDMI_WRITE(VC4_HDMI_CEC_CNTRL_1, val);
> +	return 0;
> +}
> +
> +static const struct cec_adap_ops vc4_hdmi_cec_adap_ops =3D {
> +	.adap_enable =3D vc4_hdmi_cec_adap_enable,
> +	.adap_log_addr =3D vc4_hdmi_cec_adap_log_addr,
> +	.adap_transmit =3D vc4_hdmi_cec_adap_transmit,
> +};
> +#endif

> diff --git a/drivers/gpu/drm/vc4/vc4_regs.h b/drivers/gpu/drm/vc4/vc4_reg=
s.h
> index b18cc20ee185..55677bd50f66 100644
> --- a/drivers/gpu/drm/vc4/vc4_regs.h
> +++ b/drivers/gpu/drm/vc4/vc4_regs.h
> @@ -595,6 +595,7 @@
>  # define VC4_HDMI_CEC_ADDR_MASK			VC4_MASK(15, 12)
>  # define VC4_HDMI_CEC_ADDR_SHIFT		12
>  /* Divides off of HSM clock to generate CEC bit clock. */
> +/* With the current defaults the CEC bit clock is 40 kHz =3D 25 usec */
>  # define VC4_HDMI_CEC_DIV_CLK_CNT_MASK		VC4_MASK(11, 0)
>  # define VC4_HDMI_CEC_DIV_CLK_CNT_SHIFT		0
>=20=20
> @@ -670,6 +671,10 @@
>  # define VC4_HDMI_CPU_CEC			BIT(6)
>  # define VC4_HDMI_CPU_HOTPLUG			BIT(0)
>=20=20
> +#define VC4_HDMI_CPU_MASK_STATUS		0x34c
> +#define VC4_HDMI_CPU_MASK_SET			0x350
> +#define VC4_HDMI_CPU_MASK_CLEAR			0x354
> +
>  #define VC4_HDMI_GCP(x)				(0x400 + ((x) * 0x4))
>  #define VC4_HDMI_RAM_PACKET(x)			(0x400 + ((x) * 0x24))
>  #define VC4_HDMI_PACKET_STRIDE			0x24
> --=20
> 2.11.0

Maybe squash these changes into the previous patch?  Or we could squash
the previous patch into this one and just tack my signed-off-by on
yours.  Either way's fine with me.


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE/JuuFDWp9/ZkuCBXtdYpNtH8nugFAllmclAACgkQtdYpNtH8
nuhq/xAAiz8cxob0KbglOdICoZpJUz99cq4z6o8GhKVQ+jWpX+9g0OXa7iRacfWg
6Ewm84uj7nXZxTJ1ILBRrrvViUBUDpM87MdBSOn8aHU6iv3r31mXu69uAqmUmjlo
hzV+GDPdsMkAwcf66aHOOYstGu+OYf84muwOP1r/GWtelbz2/Hz6Q8yS+khxVe0i
zgxCSMU6X1T96yakTLcsIPrKIN91MewtM3lIqo2WyJle79WztSwOxCvEKXp4DSlj
8sUJjaBmP4koMcCcLJ6uO1f8Tjjkxo1JhuAcJm8VTc4H6i49SftXs89vK7OWlos4
+yuVRlJ9112XCjErLZhSGc6Rz2pyE1OTSYNqME74W+yKTAbYpBAPPz/VUT1EVYqo
m21BPrqx1g9jEQ56ExFKz4TtiLIIXOl9rvx14GAx7euHFUokm0cqeHElojz7WjS4
IZ5+YZVhXsotBpFXd3qIKj7PDEgkWAQEwDSFx61D3zb7MWcBSatwiWsnr6WOjJtf
iZUbiJXZQfmB+SUmvloZB7noa5Re2VGeLyK0YOiXi6oUIblpWkzbJC1rChCA1s9h
F43sqGbBTDBfqyiduJgb9ZDJ8ktOfKkr1c0jkATN0WxqQHvVPFqGf1SJbjLyHcIN
RmcCPQmd3cIjx1ngZ3fxj0NWBFSlA43dLknJfptvdSl2+tCy19o=
=Ow0M
-----END PGP SIGNATURE-----
--=-=-=--
