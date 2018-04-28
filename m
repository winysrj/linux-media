Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay11.mail.gandi.net ([217.70.178.231]:57287 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759736AbeD1J4J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 05:56:09 -0400
Date: Sat, 28 Apr 2018 11:56:04 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v2 3/8] v4l: vsp1: Reset the crop and compose rectangles
 in the set_fmt helper
Message-ID: <20180428095604.GB18201@w540>
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180422223430.16407-4-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="QKdGvSO+nmPlgiQ/"
Content-Disposition: inline
In-Reply-To: <20180422223430.16407-4-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--QKdGvSO+nmPlgiQ/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Laurent,

On Mon, Apr 23, 2018 at 01:34:25AM +0300, Laurent Pinchart wrote:
> To make vsp1_subdev_set_pad_format() usable by entities that support
> selection rectangles, we need to reset the crop and compose rectangles
> when setting the format on the sink pad. Do so and replace the custom
> set_fmt implementation of the histogram code by a call to
> vsp1_subdev_set_pad_format().
>
> Resetting the crop and compose rectangles for entities that don't
> support crop and compose has no adverse effect as the rectangles are
> ignored anyway.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>


> ---
>  drivers/media/platform/vsp1/vsp1_entity.c | 16 +++++++++
>  drivers/media/platform/vsp1/vsp1_histo.c  | 59 +++----------------------------
>  2 files changed, 20 insertions(+), 55 deletions(-)
>
> diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
> index 239df047efd0..181a583aecad 100644
> --- a/drivers/media/platform/vsp1/vsp1_entity.c
> +++ b/drivers/media/platform/vsp1/vsp1_entity.c
> @@ -335,6 +335,7 @@ int vsp1_subdev_set_pad_format(struct v4l2_subdev *subdev,
>  	struct vsp1_entity *entity = to_vsp1_entity(subdev);
>  	struct v4l2_subdev_pad_config *config;
>  	struct v4l2_mbus_framefmt *format;
> +	struct v4l2_rect *selection;
>  	unsigned int i;
>  	int ret = 0;
>
> @@ -377,6 +378,21 @@ int vsp1_subdev_set_pad_format(struct v4l2_subdev *subdev,
>  	format = vsp1_entity_get_pad_format(entity, config, 1);
>  	*format = fmt->format;
>
> +	/* Reset the crop and compose rectangles */
> +	selection = vsp1_entity_get_pad_selection(entity, config, fmt->pad,
> +						  V4L2_SEL_TGT_CROP);
> +	selection->left = 0;
> +	selection->top = 0;
> +	selection->width = format->width;
> +	selection->height = format->height;
> +
> +	selection = vsp1_entity_get_pad_selection(entity, config, fmt->pad,
> +						  V4L2_SEL_TGT_COMPOSE);
> +	selection->left = 0;
> +	selection->top = 0;
> +	selection->width = format->width;
> +	selection->height = format->height;
> +
>  done:
>  	mutex_unlock(&entity->lock);
>  	return ret;
> diff --git a/drivers/media/platform/vsp1/vsp1_histo.c b/drivers/media/platform/vsp1/vsp1_histo.c
> index 029181c1fb61..5e15c8ff88d9 100644
> --- a/drivers/media/platform/vsp1/vsp1_histo.c
> +++ b/drivers/media/platform/vsp1/vsp1_histo.c
> @@ -389,65 +389,14 @@ static int histo_set_format(struct v4l2_subdev *subdev,
>  			    struct v4l2_subdev_format *fmt)
>  {
>  	struct vsp1_histogram *histo = subdev_to_histo(subdev);
> -	struct v4l2_subdev_pad_config *config;
> -	struct v4l2_mbus_framefmt *format;
> -	struct v4l2_rect *selection;
> -	unsigned int i;
> -	int ret = 0;
>
>  	if (fmt->pad != HISTO_PAD_SINK)
>  		return histo_get_format(subdev, cfg, fmt);
>
> -	mutex_lock(&histo->entity.lock);
> -
> -	config = vsp1_entity_get_pad_config(&histo->entity, cfg, fmt->which);
> -	if (!config) {
> -		ret = -EINVAL;
> -		goto done;
> -	}
> -
> -	/*
> -	 * Default to the first format if the requested format is not
> -	 * supported.
> -	 */
> -	for (i = 0; i < histo->num_formats; ++i) {
> -		if (fmt->format.code == histo->formats[i])
> -			break;
> -	}
> -	if (i == histo->num_formats)
> -		fmt->format.code = histo->formats[0];
> -
> -	format = vsp1_entity_get_pad_format(&histo->entity, config, fmt->pad);
> -
> -	format->code = fmt->format.code;
> -	format->width = clamp_t(unsigned int, fmt->format.width,
> -				HISTO_MIN_SIZE, HISTO_MAX_SIZE);
> -	format->height = clamp_t(unsigned int, fmt->format.height,
> -				 HISTO_MIN_SIZE, HISTO_MAX_SIZE);
> -	format->field = V4L2_FIELD_NONE;
> -	format->colorspace = V4L2_COLORSPACE_SRGB;
> -
> -	fmt->format = *format;
> -
> -	/* Reset the crop and compose rectangles */
> -	selection = vsp1_entity_get_pad_selection(&histo->entity, config,
> -						  fmt->pad, V4L2_SEL_TGT_CROP);
> -	selection->left = 0;
> -	selection->top = 0;
> -	selection->width = format->width;
> -	selection->height = format->height;
> -
> -	selection = vsp1_entity_get_pad_selection(&histo->entity, config,
> -						  fmt->pad,
> -						  V4L2_SEL_TGT_COMPOSE);
> -	selection->left = 0;
> -	selection->top = 0;
> -	selection->width = format->width;
> -	selection->height = format->height;
> -
> -done:
> -	mutex_unlock(&histo->entity.lock);
> -	return ret;
> +	return vsp1_subdev_set_pad_format(subdev, cfg, fmt,
> +					  histo->formats, histo->num_formats,
> +					  HISTO_MIN_SIZE, HISTO_MIN_SIZE,
> +					  HISTO_MAX_SIZE, HISTO_MAX_SIZE);
>  }
>
>  static const struct v4l2_subdev_pad_ops histo_pad_ops = {
> --
> Regards,
>
> Laurent Pinchart
>

--QKdGvSO+nmPlgiQ/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJa5EU0AAoJEHI0Bo8WoVY8CbQP/irsNP3yMfUr1XtbQB1uYIHr
pccEOvbxVbnT/yu7Wwu29J67NuZ7zZ4L1IjLN0Odl7tVu78Ptp7kqTOrfMXNnYd7
f7l6z8t99NTRaazYQwh4lIHA9Z94fc7xtpshMJib6caBXqMil0CiC9rxZ6L1Yapk
NKiO+KxvXxGJrzwYHPihd2k3GdTUSKm06SJo8c1LhaWVUOrI+pRyErotUKrZE8PZ
bzDULnmMe3AMtzyGpdKv7E9kv88ElV+5sftzSPy7QhQjrrWWqhUis+mg5c4IaEsX
QklRTxGrBFf0wxgZkxN9fBDVRJtH+gtdN8T3fnHTwxhJHqFPnnUcEUNCCkFuCkC0
axJ8vVZVLfh/wXVpstugcxmNV0hkwMxkVI7qwrJ7ZMzg209+7Tw8fZ4ZUQfCjo/y
e7inc751A+GDlKOOyicp2POv84T3RlDUVBkU5trbCpq/mD610ROy3ewBzWc5J9cJ
pGOTwn1P7LjS6d++GjTQ2unTzy8ztJioy+ksEQbJWmzKPj6G5smDrghDGUufPV2r
gfv1OD1MBwmtL4l1kGZPd5w3Sf75HKVXx1B3j3NjR9wEd++N3bLWq32p8iCmPhjK
GAjiJxRMsM4VcXAYYJ/Nzr4DoVAucWYM7O0uKpPxuKIcX2DFbXO+biKA7N6k9dgo
Wk8GHxLjlIu4mxbEDxnO
=iaer
-----END PGP SIGNATURE-----

--QKdGvSO+nmPlgiQ/--
