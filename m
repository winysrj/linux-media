Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52470 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751344AbeEDPvM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 11:51:12 -0400
Date: Fri, 4 May 2018 12:51:02 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        rascobie@slingshot.co.nz
Subject: Re: [PATCH v3 1/3] [media] dvb_frontend: add S2X and misc. other
 enums
Message-ID: <20180504125050.49e1ca54@vento.lan>
In-Reply-To: <20180313221805.26818-2-d.scheller.oss@gmail.com>
References: <20180313221805.26818-1-d.scheller.oss@gmail.com>
        <20180313221805.26818-2-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 13 Mar 2018 23:18:03 +0100
Daniel Scheller <d.scheller.oss@gmail.com> escreveu:

> From: Daniel Scheller <d.scheller@gmx.net>
>=20
> Additional enums:
>  * FEC ratios 1/4 and 1/3
>  * 64/128/256-APSK modulations (DVB-S2X)
>  * 15%, 10% and 5% rolloff factors (DVB-S2X)
>  * 64K transmission mode (DVB-T2)
>=20
> Add these enums to the frontend.h docs exceptions aswell (uapi docs are
> updated separately).
>=20
> Also, bump the DVB API version to 5.12 to make userspace aware of these
> new enums.

Series look good, except for one detail: how userspace would know if
a device supports S2(X) or not?

>=20
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
> v2 to v3:
> - All new enum patches squashed into one commit
> - DVB API bump to 5.12
>=20
> Please take note of some additional things in the cover letter.
>=20
>  Documentation/media/frontend.h.rst.exceptions |  9 +++++++++
>  drivers/media/dvb-core/dvb_frontend.c         |  9 +++++++++
>  include/uapi/linux/dvb/frontend.h             | 29 +++++++++++++++++++++=
+-----
>  include/uapi/linux/dvb/version.h              |  2 +-
>  4 files changed, 43 insertions(+), 6 deletions(-)
>=20
> diff --git a/Documentation/media/frontend.h.rst.exceptions b/Documentatio=
n/media/frontend.h.rst.exceptions
> index f7c4df620a52..c1643ce93426 100644
> --- a/Documentation/media/frontend.h.rst.exceptions
> +++ b/Documentation/media/frontend.h.rst.exceptions
> @@ -84,6 +84,9 @@ ignore symbol APSK_16
>  ignore symbol APSK_32
>  ignore symbol DQPSK
>  ignore symbol QAM_4_NR
> +ignore symbol APSK_64
> +ignore symbol APSK_128
> +ignore symbol APSK_256
> =20
>  ignore symbol SEC_VOLTAGE_13
>  ignore symbol SEC_VOLTAGE_18
> @@ -117,6 +120,8 @@ ignore symbol FEC_AUTO
>  ignore symbol FEC_3_5
>  ignore symbol FEC_9_10
>  ignore symbol FEC_2_5
> +ignore symbol FEC_1_4
> +ignore symbol FEC_1_3
> =20
>  ignore symbol TRANSMISSION_MODE_AUTO
>  ignore symbol TRANSMISSION_MODE_1K
> @@ -129,6 +134,7 @@ ignore symbol TRANSMISSION_MODE_C1
>  ignore symbol TRANSMISSION_MODE_C3780
>  ignore symbol TRANSMISSION_MODE_2K
>  ignore symbol TRANSMISSION_MODE_8K
> +ignore symbol TRANSMISSION_MODE_64K
> =20
>  ignore symbol GUARD_INTERVAL_AUTO
>  ignore symbol GUARD_INTERVAL_1_128
> @@ -161,6 +167,9 @@ ignore symbol ROLLOFF_35
>  ignore symbol ROLLOFF_20
>  ignore symbol ROLLOFF_25
>  ignore symbol ROLLOFF_AUTO
> +ignore symbol ROLLOFF_15
> +ignore symbol ROLLOFF_10
> +ignore symbol ROLLOFF_5
> =20
>  ignore symbol INVERSION_ON
>  ignore symbol INVERSION_OFF
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-co=
re/dvb_frontend.c
> index a7ed16e0841d..52c76e32f864 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -2183,6 +2183,15 @@ static int dtv_set_frontend(struct dvb_frontend *f=
e)
>  		break;
>  	case SYS_DVBS2:
>  		switch (c->rolloff) {
> +		case ROLLOFF_5:
> +			rolloff =3D 105;
> +			break;
> +		case ROLLOFF_10:
> +			rolloff =3D 110;
> +			break;
> +		case ROLLOFF_15:
> +			rolloff =3D 115;
> +			break;
>  		case ROLLOFF_20:
>  			rolloff =3D 120;
>  			break;
> diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/f=
rontend.h
> index 4f9b4551c534..8bf1c63627a2 100644
> --- a/include/uapi/linux/dvb/frontend.h
> +++ b/include/uapi/linux/dvb/frontend.h
> @@ -296,6 +296,8 @@ enum fe_spectral_inversion {
>   * @FEC_3_5:  Forward Error Correction Code 3/5
>   * @FEC_9_10: Forward Error Correction Code 9/10
>   * @FEC_2_5:  Forward Error Correction Code 2/5
> + * @FEC_1_4:  Forward Error Correction Code 1/4
> + * @FEC_1_3:  Forward Error Correction Code 1/3
>   *
>   * Please note that not all FEC types are supported by a given standard.
>   */
> @@ -313,6 +315,8 @@ enum fe_code_rate {
>  	FEC_3_5,
>  	FEC_9_10,
>  	FEC_2_5,
> +	FEC_1_4,
> +	FEC_1_3,
>  };
> =20
>  /**
> @@ -331,6 +335,9 @@ enum fe_code_rate {
>   * @APSK_32:	32-APSK modulation
>   * @DQPSK:	DQPSK modulation
>   * @QAM_4_NR:	4-QAM-NR modulation
> + * @APSK_64:	64-APSK modulation
> + * @APSK_128:	128-APSK modulation
> + * @APSK_256:	256-APSK modulation
>   *
>   * Please note that not all modulations are supported by a given standar=
d.
>   *
> @@ -350,6 +357,9 @@ enum fe_modulation {
>  	APSK_32,
>  	DQPSK,
>  	QAM_4_NR,
> +	APSK_64,
> +	APSK_128,
> +	APSK_256,
>  };
> =20
>  /**
> @@ -374,6 +384,8 @@ enum fe_modulation {
>   *	Single Carrier (C=3D1) transmission mode (DTMB only)
>   * @TRANSMISSION_MODE_C3780:
>   *	Multi Carrier (C=3D3780) transmission mode (DTMB only)
> + * @TRANSMISSION_MODE_64K:
> + *	Transmission mode 64K
>   *
>   * Please note that not all transmission modes are supported by a given
>   * standard.
> @@ -388,6 +400,7 @@ enum fe_transmit_mode {
>  	TRANSMISSION_MODE_32K,
>  	TRANSMISSION_MODE_C1,
>  	TRANSMISSION_MODE_C3780,
> +	TRANSMISSION_MODE_64K,
>  };
> =20
>  /**
> @@ -567,20 +580,26 @@ enum fe_pilot {
> =20
>  /**
>   * enum fe_rolloff - Rolloff factor
> - * @ROLLOFF_35:		Roloff factor: =CE=B1=3D35%
> - * @ROLLOFF_20:		Roloff factor: =CE=B1=3D20%
> - * @ROLLOFF_25:		Roloff factor: =CE=B1=3D25%
> - * @ROLLOFF_AUTO:	Auto-detect the roloff factor.
> + * @ROLLOFF_35:		Rolloff factor: =CE=B1=3D35%
> + * @ROLLOFF_20:		Rolloff factor: =CE=B1=3D20%
> + * @ROLLOFF_25:		Rolloff factor: =CE=B1=3D25%
> + * @ROLLOFF_AUTO:	Auto-detect the rolloff factor.
> + * @ROLLOFF_15:		Rolloff factor: =CE=B1=3D15%
> + * @ROLLOFF_10:		Rolloff factor: =CE=B1=3D10%
> + * @ROLLOFF_5:		Rolloff factor: =CE=B1=3D5%
>   *
>   * .. note:
>   *
> - *    Roloff factor of 35% is implied on DVB-S. On DVB-S2, it is default.
> + *    Rolloff factor of 35% is implied on DVB-S. On DVB-S2, it is defaul=
t.
>   */
>  enum fe_rolloff {
>  	ROLLOFF_35,
>  	ROLLOFF_20,
>  	ROLLOFF_25,
>  	ROLLOFF_AUTO,
> +	ROLLOFF_15,
> +	ROLLOFF_10,
> +	ROLLOFF_5,
>  };
> =20
>  /**
> diff --git a/include/uapi/linux/dvb/version.h b/include/uapi/linux/dvb/ve=
rsion.h
> index 2c5cffe6d2a0..204d39b82039 100644
> --- a/include/uapi/linux/dvb/version.h
> +++ b/include/uapi/linux/dvb/version.h
> @@ -25,6 +25,6 @@
>  #define _DVBVERSION_H_
> =20
>  #define DVB_API_VERSION 5
> -#define DVB_API_VERSION_MINOR 11
> +#define DVB_API_VERSION_MINOR 12
> =20
>  #endif /*_DVBVERSION_H_*/



Thanks,
Mauro
