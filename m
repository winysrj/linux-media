Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:40001 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbeI0TQR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Sep 2018 15:16:17 -0400
Date: Thu, 27 Sep 2018 14:58:04 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH 07/30] media: entity: Add has_route entity operation
Message-ID: <20180927125804.GC20786@w540>
References: <20180823132544.521-1-niklas.soderlund+renesas@ragnatech.se>
 <20180823132544.521-8-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2/5bycvrmDh4d1IB"
Content-Disposition: inline
In-Reply-To: <20180823132544.521-8-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--2/5bycvrmDh4d1IB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,
   thank you all for the patches!

On Thu, Aug 23, 2018 at 03:25:21PM +0200, Niklas S=C3=B6derlund wrote:
> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> The optional operation can be used by entities to report whether two
> pads are internally connected.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  include/media/media-entity.h | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 532c438b9eb862c5..07df1b8d85a3c1ba 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -193,6 +193,9 @@ struct media_pad {
>   * @link_validate:	Return whether a link is valid from the entity point =
of
>   *			view. The media_pipeline_start() function
>   *			validates all links by calling this operation. Optional.
> + * @has_route:		Return whether a route exists inside the entity between
> + *			two given pads. Optional. If the operation isn't
> + *			implemented all pads will be considered as connected.
>   *
>   * .. note::
>   *
> @@ -205,6 +208,8 @@ struct media_entity_operations {
>  			  const struct media_pad *local,
>  			  const struct media_pad *remote, u32 flags);
>  	int (*link_validate)(struct media_link *link);
> +	bool (*has_route)(struct media_entity *entity, unsigned int pad0,
> +			  unsigned int pad1);

In one next patch in the series:
[PATCH 09/30] media: entity: Swap pads if route is checked from source to s=
ink
the media_entity_has_route() operations ensures the sink pad is always
the first one. Could we make it explicit in the paramters name and
documentation to ease understanding when driver will have to implement this?

Thanks
   j



>  };
>
>  /**
> --
> 2.18.0
>

--2/5bycvrmDh4d1IB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbrNPZAAoJEHI0Bo8WoVY8ZKIQAKS+DJA/Kwr7iJ8njQrIrBjp
1LyQuGlAe286CPoH2Coe2/5F2BhFLCQIs2WVwT5txx4zTBOwebScUxsLkZ/rI13o
6a/vUac4zUPrvLURyCWv5KzeW7djHZ+ZJQTQ086tyIv+KWzVIzm5EjLroCHl3uu3
r85IRAkbqv9wIwd1zR8rHMWO1+bNBw91L+bPUGHdpWgqNE2Q+Z5JR+kRvZb3BfAj
LsN/3bEY3NVQAzVE3ZkCKB9/f+LgyyCFWd4d0j+iHdw7WMQmnA7EntpwuPNUoGD6
nYnAniOyhVjODIdPU75fYbVp0rli8PjySrmOlGNzfkOIAE9FufisAtnv5TQcSP9k
VgIaQOCwu3G5ABnc/c4adZMQ8kXT/Jbfn7Dy8t8Hx4pN2ReNejP7rga7eCtAbMAc
8/fGJE/InXOFxQoUryY1cYndR6Md0vgCbQUjLo/PkOSwlfYbd5ExpYNC14WJ7wUe
7POffMBXDbowd+FMP6G0q0LsfN5Np+NZVFLhi1QgUYDjEW1tan63VOpIXbYow1n7
0JQQbL8B48gq7zw0lAGLATpR0MY1MEqNTvfZR6lzReB78w8HonE/VUiykIwICG7o
mpsv2J/phXIpuOXQUnULzp1I/HlIUU32J96xaUIBuIbpr+jhHEhxevgc4fpyTAb4
gsvnZx6afaZkqkMYszwF
=yIN1
-----END PGP SIGNATURE-----

--2/5bycvrmDh4d1IB--
