Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:53844 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759064AbeD1RsX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 13:48:23 -0400
Subject: Re: [PATCH v2 5/8] v4l: vsp1: Extend the DU API to support CRC
 computation
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180422223430.16407-6-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <d1a22090-36e5-6e6e-a93d-c896422eef54@ideasonboard.com>
Date: Sat, 28 Apr 2018 18:48:19 +0100
MIME-Version: 1.0
In-Reply-To: <20180422223430.16407-6-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="P9nshyzlBkX8rW41ayXCYUPHjoL6v6BFD"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--P9nshyzlBkX8rW41ayXCYUPHjoL6v6BFD
Content-Type: multipart/mixed; boundary="0WfLbRnLP1jzrLRcg83XWXaP5n8a5vr0p";
 protected-headers="v1"
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: linux-renesas-soc@vger.kernel.org
Message-ID: <d1a22090-36e5-6e6e-a93d-c896422eef54@ideasonboard.com>
Subject: Re: [PATCH v2 5/8] v4l: vsp1: Extend the DU API to support CRC
 computation
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180422223430.16407-6-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20180422223430.16407-6-laurent.pinchart+renesas@ideasonboard.com>

--0WfLbRnLP1jzrLRcg83XWXaP5n8a5vr0p
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable

Hi Laurent,

On 22/04/18 23:34, Laurent Pinchart wrote:
> Add a parameter (in the form of a structure to ease future API
> extensions) to the VSP atomic flush handler to pass CRC source
> configuration, and pass the CRC value to the completion callback.
>=20
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.=
com>

Only a minor 'thought' below.
(And Jacopo already caught the enum typos, so with those are fixed...)

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.c  |  6 ++++--
>  drivers/media/platform/vsp1/vsp1_drm.c |  6 ++++--
>  drivers/media/platform/vsp1/vsp1_drm.h |  2 +-
>  include/media/vsp1.h                   | 29 ++++++++++++++++++++++++++=
+--
>  4 files changed, 36 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rc=
ar-du/rcar_du_vsp.c
> index 2c260c33840b..bdcec201591f 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> @@ -31,7 +31,7 @@
>  #include "rcar_du_kms.h"
>  #include "rcar_du_vsp.h"
> =20
> -static void rcar_du_vsp_complete(void *private, bool completed)
> +static void rcar_du_vsp_complete(void *private, bool completed, u32 cr=
c)
>  {
>  	struct rcar_du_crtc *crtc =3D private;
> =20
> @@ -102,7 +102,9 @@ void rcar_du_vsp_atomic_begin(struct rcar_du_crtc *=
crtc)
> =20
>  void rcar_du_vsp_atomic_flush(struct rcar_du_crtc *crtc)
>  {
> -	vsp1_du_atomic_flush(crtc->vsp->vsp, crtc->vsp_pipe);
> +	struct vsp1_du_atomic_pipe_config cfg =3D { { 0, } }> +
> +	vsp1_du_atomic_flush(crtc->vsp->vsp, crtc->vsp_pipe, &cfg);
>  }
> =20
>  /* Keep the two tables in sync. */
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/pla=
tform/vsp1/vsp1_drm.c
> index 2b29a83dceb9..5fc31578f9b0 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -36,7 +36,7 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_pi=
peline *pipe,
>  	bool complete =3D completion =3D=3D VSP1_DL_FRAME_END_COMPLETED;
> =20
>  	if (drm_pipe->du_complete)
> -		drm_pipe->du_complete(drm_pipe->du_private, complete);
> +		drm_pipe->du_complete(drm_pipe->du_private, complete, 0);
> =20
>  	if (completion & VSP1_DL_FRAME_END_INTERNAL) {
>  		drm_pipe->force_brx_release =3D false;
> @@ -739,8 +739,10 @@ EXPORT_SYMBOL_GPL(vsp1_du_atomic_update);
>   * vsp1_du_atomic_flush - Commit an atomic update
>   * @dev: the VSP device
>   * @pipe_index: the DRM pipeline index
> + * @cfg: atomic pipe configuration
>   */
> -void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)=

> +void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index,=

> +			  const struct vsp1_du_atomic_pipe_config *cfg)
>  {
>  	struct vsp1_device *vsp1 =3D dev_get_drvdata(dev);
>  	struct vsp1_drm_pipeline *drm_pipe =3D &vsp1->drm->pipe[pipe_index];
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/pla=
tform/vsp1/vsp1_drm.h
> index f4af1b2b12d6..e5b88b28806c 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.h
> +++ b/drivers/media/platform/vsp1/vsp1_drm.h
> @@ -35,7 +35,7 @@ struct vsp1_drm_pipeline {
>  	wait_queue_head_t wait_queue;
> =20
>  	/* Frame synchronisation */
> -	void (*du_complete)(void *, bool);
> +	void (*du_complete)(void *data, bool completed, u32 crc);
>  	void *du_private;
>  };
> =20
> diff --git a/include/media/vsp1.h b/include/media/vsp1.h
> index ff7ef894465d..ac63a9928a79 100644
> --- a/include/media/vsp1.h
> +++ b/include/media/vsp1.h
> @@ -34,7 +34,7 @@ struct vsp1_du_lif_config {
>  	unsigned int width;
>  	unsigned int height;
> =20
> -	void (*callback)(void *, bool);
> +	void (*callback)(void *data, bool completed, u32 crc);

Did we have to add parameters to this callback for the dynamic BRx work ?=


</me struggles to remember correctly>. If so we might have to consider tu=
rning
it into a struct perhaps! - but for now or otherwise I think this will be=
 OK.

Ok - so I stopped being lazy and went to take a look. We turned completed=
 into a
bitfield - so I think actually that's enough to store any more flags we m=
ight
come up with, and the CRC doesn't fit in there :D

So lets leave this as adding an extra parameter for now.

>  	void *callback_data;
>  };
> =20
> @@ -61,11 +61,36 @@ struct vsp1_du_atomic_config {
>  	unsigned int zpos;
>  };
> =20
> +/**
> + * enum vsp1_du_crc_source - Source used for CRC calculation
> + * @VSP1_DU_CRC_NONE: CRC calculation disabled
> + * @VSP_DU_CRC_PLANE: Perform CRC calculation on an input plane
> + * @VSP_DU_CRC_OUTPUT: Perform CRC calculation on the composed output

I see Jacopo has already caught these ...

> + */
> +enum vsp1_du_crc_source {
> +	VSP1_DU_CRC_NONE,
> +	VSP1_DU_CRC_PLANE,
> +	VSP1_DU_CRC_OUTPUT,
> +};
> +
> +/**
> + * struct vsp1_du_atomic_pipe_config - VSP atomic pipe configuration p=
arameters
> + * @crc.source: source for CRC calculation
> + * @crc.index: index of the CRC source plane (when crc.source is set t=
o plane)
> + */
> +struct vsp1_du_atomic_pipe_config {
> +	struct  {
> +		enum vsp1_du_crc_source source;
> +		unsigned int index;
> +	} crc;
> +};
> +
>  void vsp1_du_atomic_begin(struct device *dev, unsigned int pipe_index)=
;
>  int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,=

>  			  unsigned int rpf,
>  			  const struct vsp1_du_atomic_config *cfg);
> -void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)=
;
> +void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index,=

> +			  const struct vsp1_du_atomic_pipe_config *cfg);
>  int vsp1_du_map_sg(struct device *dev, struct sg_table *sgt);
>  void vsp1_du_unmap_sg(struct device *dev, struct sg_table *sgt);
> =20
>=20


--0WfLbRnLP1jzrLRcg83XWXaP5n8a5vr0p--

--P9nshyzlBkX8rW41ayXCYUPHjoL6v6BFD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEkC3XmD+9KP3jctR6oR5GchCkYf0FAlrks+MACgkQoR5GchCk
Yf1A3A//YTeIcY5J7K8mW+JAb+hdsvOVVZNcYE0P/fNAXTXKg/6lVqkh9t0ewfXl
4CzqDKFjd6q5d1EA6WwQsP6JcdfQ7Z2eYm7pvG+ylEpuyTnhKqrG6rbyzLLHaSJq
vulWY6KHTXPa+H9gqlfnHZPtIQRJkngvmUaf/SzNi4YeJPUfeJd3UZd42o1BqnSN
CPcoz2xXK25UHr5xeOHmWBvNNWXzmXtWzPsfFb/Yu2oiHb7C6iKplkoUa9dzqJdX
b3RbOZV7S019PORJD1dYGDL5fcIfyZq2jD5WQgx+1PUvcxiBh8TjSCcsnmb0mDLC
1mX3TzcrxqiK6T3wTLdv+EjShPvrxDJUNxCBVDHUCqRq9Pps3WcGZQEfGW6vqH3R
sDxhRx+eEw4/80wkoA0wUdCBAMEehvF2azoVWYTPsxjrQJiP1WL/QQKTJxdBiwZx
Li3uoS9l2UplqVnD4ZbcAxOLqnWmQxiBGmH/y3IETFSk1rGBkO0tVuyTfOLzhxm0
VHjCj0dPJ3WPqgbh9gkgNJP6kNq3Dx0qIHczRU0gmWINR5LdOojb4B6845ePGSJX
qQc0HrfNd9iRkAjBg/+gwsJK+5BmxCZHdodW6foZ7Uk5pfynlZBq99M5XYf+DaS0
Tues8ZdDhVOLbwY2nFcaBRXD/YqovKmyvWjnJID2YEMM49bU9fk=
=spJi
-----END PGP SIGNATURE-----

--P9nshyzlBkX8rW41ayXCYUPHjoL6v6BFD--
