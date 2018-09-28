Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:41981 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbeI1XXh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Sep 2018 19:23:37 -0400
Date: Fri, 28 Sep 2018 18:58:52 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 15/30] media: entity: Look for indirect routes
Message-ID: <20180928165852.GD20786@w540>
References: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
 <20180823132544.521-16-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="WChQLJJJfbwij+9x"
Content-Disposition: inline
In-Reply-To: <20180823132544.521-16-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--WChQLJJJfbwij+9x
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sakari,

On Thu, Aug 23, 2018 at 03:25:29PM +0200, Niklas S=C3=B6derlund wrote:
> From: Sakari Ailus <sakari.ailus@linux.intel.com>
>
> Two pads are considered having an active route for the purpose of
> has_route() if an indirect active route can be found between the two pads.
> An simple example of this is that a source pad has an active route to
> another source pad if both of the pads have an active route to the same
> sink pad.
>
> Make media_entity_has_route() return true in that case, and do not rely on
> drivers performing this by themselves.
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/media-entity.c | 32 +++++++++++++++++++++++++++++++-
>  1 file changed, 31 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 3912bc75651fe0b7..29e732a130667ae9 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -240,6 +240,9 @@ EXPORT_SYMBOL_GPL(media_entity_pads_init);
>  bool media_entity_has_route(struct media_entity *entity, unsigned int pa=
d0,
>  			    unsigned int pad1)
>  {
> +	unsigned int i;
> +	bool has_route;
> +
>  	if (pad0 >=3D entity->num_pads || pad1 >=3D entity->num_pads)
>  		return false;
>
> @@ -253,7 +256,34 @@ bool media_entity_has_route(struct media_entity *ent=
ity, unsigned int pad0,
>  	    && entity->pads[pad1].flags & MEDIA_PAD_FL_SINK)
>  		swap(pad0, pad1);
>
> -	return entity->ops->has_route(entity, pad0, pad1);
> +	has_route =3D entity->ops->has_route(entity, pad0, pad1);
> +	/* A direct route is returned immediately */
> +	if (has_route ||
> +	    (entity->pads[pad0].flags & MEDIA_PAD_FL_SINK &&
> +	     entity->pads[pad1].flags & MEDIA_PAD_FL_SOURCE))

I'm not sure I get why you're using the || condition here.

I suspect it is in order to make sure the driver implementation of
ops->has_route() only checks for direct links, but wouldn't it be
better to clarify the function semantics instead of catching
'non-direct' routes returned here?

More generally, why not call ops->has_route() only in case pad0 and
pad1 have different type, and check for indirect links otherwise?

> +		return true;
> +
> +	/* Look for indirect routes */
> +	for (i =3D 0; i < entity->num_pads; i++) {
> +		if (i =3D=3D pad0 || i =3D=3D pad1)
> +			continue;

This is correct, but the following check catches this condition as
well I think.

I assume if we fall down here pad0 and pad1 are of the same type and
if 'i' is one of the two pads it will have the same type as pad0, and
you're checking for this here below.

> +
> +		/*
> +		 * There are no direct routes between same types of
> +		 * pads, so skip checking this route
> +		 */
> +		if (!((entity->pads[pad0].flags ^ entity->pads[i].flags) &
> +		      (MEDIA_PAD_FL_SOURCE | MEDIA_PAD_FL_SINK)))
> +			continue;
> +
> +		/* Is there an indirect route? */
> +		if (entity->ops->has_route(entity, i, pad0) &&
> +		    entity->ops->has_route(entity, i, pad1))

What guarantees here that i is a sink and pad0/pad1 are sources? It seems
the 'has_route' operation wants this, otherwise I don't see a reason
for "[PATCH 09/30] media: entity: Swap pads if route is checked from
source to sink". Did I miss something from that patch?

Sorry, lot of questions. I might be confused :/
Thanks
   j

> +			return true;
> +	}
> +
> +	return false;
> +
>  }
>  EXPORT_SYMBOL_GPL(media_entity_has_route);
>
> --
> 2.18.0
>

--WChQLJJJfbwij+9x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbrl3MAAoJEHI0Bo8WoVY8Q9oP/3qs2IMsPtykULrV1RUnfW/j
ukeSGZVahuT+GCji/eq6CgfOFMppkXhGj/RmhyIHEXR34E/WIvziWzSDpwgNaJbg
mNRC7J/H94fDrPiLMG3UhgrVnb8VKeleUf9leRtl0zp0lr2v4wPx5g3iKIf/nxIv
NJcUgp1Ls/ZNRVE/dcMxBi89dbG0BL9+tZf1SVzsEXLbzurcIxpq7BUMJPe5ZreO
/XeyklZJhuu07SNDsn+R4ZVeqfsBGzYkdNQvF2l2vxuoXEvgYNrrpci4VxL0tkVC
6ZNxdar5wAItVYM5B5vbFRlXWsbpu08VRVNioqgWcQJxGXIrBNOvThRg4AAoA5nP
/WzVhRHhTKL0sa2tq/L/3Lo99YFSY3DWnc4jpA85+bfyWflRNmm49kqjh/zKVgwE
a773PwV6M9zrwy/qotP9Ymu/Kbk2uh3RFHn/vmTaJtstttjYiICDUSVycPgOjs89
/rYyU9Irvi4u9KSIdhpvBpghKqZZwN8Fd5oYkDiLcj8nxR0784L4e9WmJndx2eDW
FyNrtxXTy5r53/ViKcv5VYRfyBIkXkmxrCkUWeB31dc7/dP6i5rPqF8hSU+aOHw6
Rxfsv8OMwN/LiUw2vMvIHYxV4L3AjgyEecpCL3iWrIYZyinLvVwqmIv2J0fjtyXO
jeSjVt/lCj6CB/tCVH+m
=fMMl
-----END PGP SIGNATURE-----

--WChQLJJJfbwij+9x--
