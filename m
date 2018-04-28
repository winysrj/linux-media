Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:54232 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751079AbeD1TQy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 15:16:54 -0400
Subject: Re: [PATCH v2 8/8] drm: rcar-du: Add support for CRC computation
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180422223430.16407-9-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <2d89cb02-6df2-0240-82ab-c6b51ef129ac@ideasonboard.com>
Date: Sat, 28 Apr 2018 20:16:48 +0100
MIME-Version: 1.0
In-Reply-To: <20180422223430.16407-9-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="N937ohEyTo9X7kwdtBNEekiH59gT14x15"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--N937ohEyTo9X7kwdtBNEekiH59gT14x15
Content-Type: multipart/mixed; boundary="O36D1Ta7QMLVKir3jPZn6YngzDzRhvszS";
 protected-headers="v1"
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
Message-ID: <2d89cb02-6df2-0240-82ab-c6b51ef129ac@ideasonboard.com>
Subject: Re: [PATCH v2 8/8] drm: rcar-du: Add support for CRC computation
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180422223430.16407-9-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180422223430.16407-9-laurent.pinchart+renesas@ideasonboard.com>

--O36D1Ta7QMLVKir3jPZn6YngzDzRhvszS
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

On 22/04/18 23:34, Laurent Pinchart wrote:
> Implement CRC computation configuration and reporting through the DRM
> debugfs-based CRC API. The CRC source can be configured to any input
> plane or the pipeline output.
>=20
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.=
com>

I don't think I have any actual blocking questions here, so feel free to =
add a

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

I'll not be in distress if the CRC structures remain duplicated (although=
 I see
from your other mail you've considered defining the structure non-anonymo=
usly

--
Kieran



> ---
> Changes since v1:
>=20
> - Format the source names using plane IDs instead of plane indices
> ---
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.c | 156 +++++++++++++++++++++++++=
++++++--
>  drivers/gpu/drm/rcar-du/rcar_du_crtc.h |  19 ++++
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.c  |   7 ++
>  3 files changed, 176 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c b/drivers/gpu/drm/r=
car-du/rcar_du_crtc.c
> index c4420538ec85..d71d709fe3d9 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.c
> @@ -691,6 +691,52 @@ static const struct drm_crtc_helper_funcs crtc_hel=
per_funcs =3D {
>  	.atomic_disable =3D rcar_du_crtc_atomic_disable,
>  };
> =20
> +static struct drm_crtc_state *
> +rcar_du_crtc_atomic_duplicate_state(struct drm_crtc *crtc)
> +{
> +	struct rcar_du_crtc_state *state;
> +	struct rcar_du_crtc_state *copy;
> +
> +	if (WARN_ON(!crtc->state))
> +		return NULL;
> +
> +	state =3D to_rcar_crtc_state(crtc->state);
> +	copy =3D kmemdup(state, sizeof(*state), GFP_KERNEL);
> +	if (copy =3D=3D NULL)
> +		return NULL;
> +
> +	__drm_atomic_helper_crtc_duplicate_state(crtc, &copy->state);
> +
> +	return &copy->state;
> +}
> +
> +static void rcar_du_crtc_atomic_destroy_state(struct drm_crtc *crtc,
> +					      struct drm_crtc_state *state)
> +{
> +	__drm_atomic_helper_crtc_destroy_state(state);
> +	kfree(to_rcar_crtc_state(state));
> +}
> +
> +static void rcar_du_crtc_reset(struct drm_crtc *crtc)
> +{
> +	struct rcar_du_crtc_state *state;
> +
> +	if (crtc->state) {
> +		rcar_du_crtc_atomic_destroy_state(crtc, crtc->state);
> +		crtc->state =3D NULL;
> +	}
> +
> +	state =3D kzalloc(sizeof(*state), GFP_KERNEL);
> +	if (state =3D=3D NULL)
> +		return;
> +
> +	state->crc.source =3D VSP1_DU_CRC_NONE;
> +	state->crc.index =3D 0;
> +
> +	crtc->state =3D &state->state;
> +	crtc->state->crtc =3D crtc;
> +}
> +
>  static int rcar_du_crtc_enable_vblank(struct drm_crtc *crtc)
>  {
>  	struct rcar_du_crtc *rcrtc =3D to_rcar_crtc(crtc);
> @@ -710,15 +756,111 @@ static void rcar_du_crtc_disable_vblank(struct d=
rm_crtc *crtc)
>  	rcrtc->vblank_enable =3D false;
>  }
> =20
> -static const struct drm_crtc_funcs crtc_funcs =3D {
> -	.reset =3D drm_atomic_helper_crtc_reset,
> +static int rcar_du_crtc_set_crc_source(struct drm_crtc *crtc,
> +				       const char *source_name,
> +				       size_t *values_cnt)
> +{
> +	struct rcar_du_crtc *rcrtc =3D to_rcar_crtc(crtc);
> +	struct drm_modeset_acquire_ctx ctx;
> +	struct drm_crtc_state *crtc_state;
> +	struct drm_atomic_state *state;
> +	enum vsp1_du_crc_source source;
> +	unsigned int index =3D 0;
> +	unsigned int i;
> +	int ret;
> +
> +	/*
> +	 * Parse the source name. Supported values are "plane%u" to compute t=
he
> +	 * CRC on an input plane (%u is the plane ID), and "auto" to compute =
the
> +	 * CRC on the composer (VSP) output.
> +	 */
> +	if (!source_name) {
> +		source =3D VSP1_DU_CRC_NONE;
> +	} else if (!strcmp(source_name, "auto")) {
> +		source =3D VSP1_DU_CRC_OUTPUT;
> +	} else if (strstarts(source_name, "plane")) {
> +		source =3D VSP1_DU_CRC_PLANE;
> +
> +		ret =3D kstrtouint(source_name + strlen("plane"), 10, &index);
> +		if (ret < 0)
> +			return ret;
> +
> +		for (i =3D 0; i < rcrtc->vsp->num_planes; ++i) {
> +			if (index =3D=3D rcrtc->vsp->planes[i].plane.base.id) {
> +				index =3D i;
> +				break;
> +			}
> +		}
> +
> +		if (i >=3D rcrtc->vsp->num_planes)
> +			return -EINVAL;
> +	} else {
> +		return -EINVAL;
> +	}
> +
> +	*values_cnt =3D 1;
> +
> +	/* Perform an atomic commit to set the CRC source. */
> +	drm_modeset_acquire_init(&ctx, 0);
> +
> +	state =3D drm_atomic_state_alloc(crtc->dev);
> +	if (!state) {
> +		ret =3D -ENOMEM;
> +		goto unlock;
> +	}
> +
> +	state->acquire_ctx =3D &ctx;
> +
> +retry:
> +	crtc_state =3D drm_atomic_get_crtc_state(state, crtc);
> +	if (!IS_ERR(crtc_state)) {
> +		struct rcar_du_crtc_state *rcrtc_state;
> +
> +		rcrtc_state =3D to_rcar_crtc_state(crtc_state);
> +		rcrtc_state->crc.source =3D source;
> +		rcrtc_state->crc.index =3D index;
> +
> +		ret =3D drm_atomic_commit(state);

Does this 'cost' a vblank ? (as in - does this action being performed fro=
m
userspace have the capability to cause flicker, or loss of frame?)

> +	} else {
> +		ret =3D PTR_ERR(crtc_state);
> +	}
> +
> +	if (ret =3D=3D -EDEADLK) {
> +		drm_atomic_state_clear(state);
> +		drm_modeset_backoff(&ctx);
> +		goto retry;

Not knowing what the -EDEADLK represents yet, this isn't an infinite loop=

opportunity is it ? (I assume the state_clear(),backoff() clean up and pr=
event
that.)

> +	}
> +
> +	drm_atomic_state_put(state);
> +
> +unlock:
> +	drm_modeset_drop_locks(&ctx);
> +	drm_modeset_acquire_fini(&ctx);
> +
> +	return 0;
> +}
> +
> +static const struct drm_crtc_funcs crtc_funcs_gen2 =3D {
> +	.reset =3D rcar_du_crtc_reset,
> +	.destroy =3D drm_crtc_cleanup,
> +	.set_config =3D drm_atomic_helper_set_config,
> +	.page_flip =3D drm_atomic_helper_page_flip,
> +	.atomic_duplicate_state =3D rcar_du_crtc_atomic_duplicate_state,
> +	.atomic_destroy_state =3D rcar_du_crtc_atomic_destroy_state,
> +	.enable_vblank =3D rcar_du_crtc_enable_vblank,
> +	.disable_vblank =3D rcar_du_crtc_disable_vblank,
> +};
> +
> +static const struct drm_crtc_funcs crtc_funcs_gen3 =3D {
> +	.reset =3D rcar_du_crtc_reset,
>  	.destroy =3D drm_crtc_cleanup,
>  	.set_config =3D drm_atomic_helper_set_config,
>  	.page_flip =3D drm_atomic_helper_page_flip,
> -	.atomic_duplicate_state =3D drm_atomic_helper_crtc_duplicate_state,
> -	.atomic_destroy_state =3D drm_atomic_helper_crtc_destroy_state,
> +	.atomic_duplicate_state =3D rcar_du_crtc_atomic_duplicate_state,
> +	.atomic_destroy_state =3D rcar_du_crtc_atomic_destroy_state,
>  	.enable_vblank =3D rcar_du_crtc_enable_vblank,
>  	.disable_vblank =3D rcar_du_crtc_disable_vblank,
> +	.set_crc_source =3D rcar_du_crtc_set_crc_source,
>  };
> =20
>  /* -------------------------------------------------------------------=
----------
> @@ -821,8 +963,10 @@ int rcar_du_crtc_create(struct rcar_du_group *rgrp=
, unsigned int index)
>  	else
>  		primary =3D &rgrp->planes[index % 2].plane;
> =20
> -	ret =3D drm_crtc_init_with_planes(rcdu->ddev, crtc, primary,
> -					NULL, &crtc_funcs, NULL);
> +	ret =3D drm_crtc_init_with_planes(rcdu->ddev, crtc, primary, NULL,
> +					rcdu->info->gen <=3D 2 ?
> +					&crtc_funcs_gen2 : &crtc_funcs_gen3,
> +					NULL);
>  	if (ret < 0)
>  		return ret;
> =20
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h b/drivers/gpu/drm/r=
car-du/rcar_du_crtc.h
> index fdc2bf99bda1..518ee2c60eb8 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
> @@ -21,6 +21,8 @@
>  #include <drm/drmP.h>
>  #include <drm/drm_crtc.h>
> =20
> +#include <media/vsp1.h>
> +
>  struct rcar_du_group;
>  struct rcar_du_vsp;
> =20
> @@ -69,6 +71,23 @@ struct rcar_du_crtc {
> =20
>  #define to_rcar_crtc(c)	container_of(c, struct rcar_du_crtc, crtc)
> =20
> +/**
> + * struct rcar_du_crtc_state - Driver-specific CRTC state
> + * @state: base DRM CRTC state
> + * @crc.source: source for CRC calculation
> + * @crc.index: index of the CRC source plane (when crc.source is set t=
o plane)
> + */
> +struct rcar_du_crtc_state {
> +	struct drm_crtc_state state;
> +
> +	struct {
> +		enum vsp1_du_crc_source source;
> +		unsigned int index;
> +	} crc;

Another definition of this structure ... (is this the third?) do we need =
to
replicate it each time ? (I know it's small ... but I love to keep things=
 DRY)

> +};
> +
> +#define to_rcar_crtc_state(s) container_of(s, struct rcar_du_crtc_stat=
e, state)
> +
>  enum rcar_du_output {
>  	RCAR_DU_OUTPUT_DPAD0,
>  	RCAR_DU_OUTPUT_DPAD1,
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rc=
ar-du/rcar_du_vsp.c
> index bdcec201591f..ce19b883ad16 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> @@ -40,6 +40,8 @@ static void rcar_du_vsp_complete(void *private, bool =
completed, u32 crc)
> =20
>  	if (completed)
>  		rcar_du_crtc_finish_page_flip(crtc);
> +
> +	drm_crtc_add_crc_entry(&crtc->crtc, false, 0, &crc);
>  }
> =20
>  void rcar_du_vsp_enable(struct rcar_du_crtc *crtc)
> @@ -103,6 +105,11 @@ void rcar_du_vsp_atomic_begin(struct rcar_du_crtc =
*crtc)
>  void rcar_du_vsp_atomic_flush(struct rcar_du_crtc *crtc)
>  {
>  	struct vsp1_du_atomic_pipe_config cfg =3D { { 0, } };
> +	struct rcar_du_crtc_state *state;
> +
> +	state =3D to_rcar_crtc_state(crtc->crtc.state);
> +	cfg.crc.source =3D state->crc.source;
> +	cfg.crc.index =3D state->crc.index;
> =20
>  	vsp1_du_atomic_flush(crtc->vsp->vsp, crtc->vsp_pipe, &cfg);
>  }
>=20


--O36D1Ta7QMLVKir3jPZn6YngzDzRhvszS--

--N937ohEyTo9X7kwdtBNEekiH59gT14x15
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkC3XmD+9KP3jctR6oR5GchCkYf0FAlrkyKAACgkQoR5GchCk
Yf0sRg//ahiD773Z8Vx70xd6oAkZUe2kgdcGsCQymZeo4fxVahnI6CywFf05G6ww
yIL31td6HjPAmqSAjkZdhVQRRmIKP8ILGae+3TxffVVEiMVC1RlkSwp0EPsxKzHR
ND8OlTh2kXMXjOvx8IJaI+Aq7bMLy3s0OlRuOhOZ4lH+dM37r/t/HFaa4hkDRni7
DOqy/Uikmgk2sUcT6UVO4opIAkJLZCpUTwwBEE1ahqzPa+mn6420fOwZwf2FgUGm
q68/7NxJpGtKCuLXajPc8t95Y0BKoXRviCEo2EPOVzM2hLr5ixHMKLNDUrNRZiz7
pwSph4IiQj1rPRTlCwTLSnwlf9vvUKFsNU9LUjG7BdbYHviy5OjOY2R91aVlvn7d
Xw4ulMAmawo8zyuHdb4qNJvd4cT5Fw8TlGAXBJLv47hRNbSp9ZxylTJsg2jkdGLe
d8bUqjAC88egi5vhrjZwDX3ojiuGU5WMq1LUY4bkcWGQF9Qh0LhJxXKo49VlXtH+
f6668GeLp/Zy/ysMH2fD5BZ2rPgbIfKWf1NQeh7FY/oQ9mQfQuPlEUavS5IpndNf
O0kJNUzjfAvM6TGjpUKxGM5hBOdjDktfBO624iqYx/v+05wdgHfiZOKrbDnLqUL7
ibYeffYcZLiPtZtkdJgBRkvBgR3kHf0wjude+9TXL/AUAC9lUmM=
=0nY4
-----END PGP SIGNATURE-----

--N937ohEyTo9X7kwdtBNEekiH59gT14x15--
