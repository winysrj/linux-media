Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751152AbdJ2W2U (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 18:28:20 -0400
Date: Sun, 29 Oct 2017 23:28:16 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v16 22/32] v4l: fwnode: Move KernelDoc documentation to
 the header
Message-ID: <20171029222816.3el3hzcsx7e5zklx@earth>
References: <20171026075342.5760-1-sakari.ailus@linux.intel.com>
 <20171026075342.5760-23-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="xgtefgl3fj6vnjo7"
Content-Disposition: inline
In-Reply-To: <20171026075342.5760-23-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--xgtefgl3fj6vnjo7
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Oct 26, 2017 at 10:53:32AM +0300, Sakari Ailus wrote:
> In V4L2 the practice is to have the KernelDoc documentation in the header
> and not in .c source code files. This consequently makes the V4L2 fwnode
> function documentation part of the Media documentation build.
>=20
> Also correct the link related function and argument naming in
> documentation and add an asterisk to v4l2_fwnode_endpoint_free()
> documentation to make it proper KernelDoc documentation.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reviewed-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> ---

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>

-- Sebastian

>  drivers/media/v4l2-core/v4l2-fwnode.c | 75 -----------------------------=
---
>  include/media/v4l2-fwnode.h           | 81 +++++++++++++++++++++++++++++=
+++++-
>  2 files changed, 80 insertions(+), 76 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-c=
ore/v4l2-fwnode.c
> index df0695b7bbcc..65bdcd59744a 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -183,25 +183,6 @@ v4l2_fwnode_endpoint_parse_csi1_bus(struct fwnode_ha=
ndle *fwnode,
>  		vep->bus_type =3D V4L2_MBUS_CSI1;
>  }
> =20
> -/**
> - * v4l2_fwnode_endpoint_parse() - parse all fwnode node properties
> - * @fwnode: pointer to the endpoint's fwnode handle
> - * @vep: pointer to the V4L2 fwnode data structure
> - *
> - * All properties are optional. If none are found, we don't set any flag=
s. This
> - * means the port has a static configuration and no properties have to be
> - * specified explicitly. If any properties that identify the bus as para=
llel
> - * are found and slave-mode isn't set, we set V4L2_MBUS_MASTER. Similarl=
y, if
> - * we recognise the bus as serial CSI-2 and clock-noncontinuous isn't se=
t, we
> - * set the V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag. The caller should hold a
> - * reference to @fwnode.
> - *
> - * NOTE: This function does not parse properties the size of which is va=
riable
> - * without a low fixed limit. Please use v4l2_fwnode_endpoint_alloc_pars=
e() in
> - * new drivers instead.
> - *
> - * Return: 0 on success or a negative error code on failure.
> - */
>  int v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
>  			       struct v4l2_fwnode_endpoint *vep)
>  {
> @@ -241,14 +222,6 @@ int v4l2_fwnode_endpoint_parse(struct fwnode_handle =
*fwnode,
>  }
>  EXPORT_SYMBOL_GPL(v4l2_fwnode_endpoint_parse);
> =20
> -/*
> - * v4l2_fwnode_endpoint_free() - free the V4L2 fwnode acquired by
> - * v4l2_fwnode_endpoint_alloc_parse()
> - * @vep - the V4L2 fwnode the resources of which are to be released
> - *
> - * It is safe to call this function with NULL argument or on a V4L2 fwno=
de the
> - * parsing of which failed.
> - */
>  void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vep)
>  {
>  	if (IS_ERR_OR_NULL(vep))
> @@ -259,29 +232,6 @@ void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_en=
dpoint *vep)
>  }
>  EXPORT_SYMBOL_GPL(v4l2_fwnode_endpoint_free);
> =20
> -/**
> - * v4l2_fwnode_endpoint_alloc_parse() - parse all fwnode node properties
> - * @fwnode: pointer to the endpoint's fwnode handle
> - *
> - * All properties are optional. If none are found, we don't set any flag=
s. This
> - * means the port has a static configuration and no properties have to be
> - * specified explicitly. If any properties that identify the bus as para=
llel
> - * are found and slave-mode isn't set, we set V4L2_MBUS_MASTER. Similarl=
y, if
> - * we recognise the bus as serial CSI-2 and clock-noncontinuous isn't se=
t, we
> - * set the V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag. The caller should hold a
> - * reference to @fwnode.
> - *
> - * v4l2_fwnode_endpoint_alloc_parse() has two important differences to
> - * v4l2_fwnode_endpoint_parse():
> - *
> - * 1. It also parses variable size data.
> - *
> - * 2. The memory it has allocated to store the variable size data must b=
e freed
> - *    using v4l2_fwnode_endpoint_free() when no longer needed.
> - *
> - * Return: Pointer to v4l2_fwnode_endpoint if successful, on an error po=
inter
> - * on error.
> - */
>  struct v4l2_fwnode_endpoint *v4l2_fwnode_endpoint_alloc_parse(
>  	struct fwnode_handle *fwnode)
>  {
> @@ -324,24 +274,6 @@ struct v4l2_fwnode_endpoint *v4l2_fwnode_endpoint_al=
loc_parse(
>  }
>  EXPORT_SYMBOL_GPL(v4l2_fwnode_endpoint_alloc_parse);
> =20
> -/**
> - * v4l2_fwnode_endpoint_parse_link() - parse a link between two endpoints
> - * @__fwnode: pointer to the endpoint's fwnode at the local end of the l=
ink
> - * @link: pointer to the V4L2 fwnode link data structure
> - *
> - * Fill the link structure with the local and remote nodes and port numb=
ers.
> - * The local_node and remote_node fields are set to point to the local a=
nd
> - * remote port's parent nodes respectively (the port parent node being t=
he
> - * parent node of the port node if that node isn't a 'ports' node, or the
> - * grand-parent node of the port node otherwise).
> - *
> - * A reference is taken to both the local and remote nodes, the caller m=
ust use
> - * v4l2_fwnode_endpoint_put_link() to drop the references when done with=
 the
> - * link.
> - *
> - * Return: 0 on success, or -ENOLINK if the remote endpoint fwnode can't=
 be
> - * found.
> - */
>  int v4l2_fwnode_parse_link(struct fwnode_handle *__fwnode,
>  			   struct v4l2_fwnode_link *link)
>  {
> @@ -376,13 +308,6 @@ int v4l2_fwnode_parse_link(struct fwnode_handle *__f=
wnode,
>  }
>  EXPORT_SYMBOL_GPL(v4l2_fwnode_parse_link);
> =20
> -/**
> - * v4l2_fwnode_put_link() - drop references to nodes in a link
> - * @link: pointer to the V4L2 fwnode link data structure
> - *
> - * Drop references to the local and remote nodes in the link. This funct=
ion
> - * must be called on every link parsed with v4l2_fwnode_parse_link().
> - */
>  void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link)
>  {
>  	fwnode_handle_put(link->local_node);
> diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> index ac605af9b877..105cfeee44ef 100644
> --- a/include/media/v4l2-fwnode.h
> +++ b/include/media/v4l2-fwnode.h
> @@ -115,13 +115,92 @@ struct v4l2_fwnode_link {
>  	unsigned int remote_port;
>  };
> =20
> +/**
> + * v4l2_fwnode_endpoint_parse() - parse all fwnode node properties
> + * @fwnode: pointer to the endpoint's fwnode handle
> + * @vep: pointer to the V4L2 fwnode data structure
> + *
> + * All properties are optional. If none are found, we don't set any flag=
s. This
> + * means the port has a static configuration and no properties have to be
> + * specified explicitly. If any properties that identify the bus as para=
llel
> + * are found and slave-mode isn't set, we set V4L2_MBUS_MASTER. Similarl=
y, if
> + * we recognise the bus as serial CSI-2 and clock-noncontinuous isn't se=
t, we
> + * set the V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag. The caller should hold a
> + * reference to @fwnode.
> + *
> + * NOTE: This function does not parse properties the size of which is va=
riable
> + * without a low fixed limit. Please use v4l2_fwnode_endpoint_alloc_pars=
e() in
> + * new drivers instead.
> + *
> + * Return: 0 on success or a negative error code on failure.
> + */
>  int v4l2_fwnode_endpoint_parse(struct fwnode_handle *fwnode,
>  			       struct v4l2_fwnode_endpoint *vep);
> +
> +/**
> + * v4l2_fwnode_endpoint_free() - free the V4L2 fwnode acquired by
> + * v4l2_fwnode_endpoint_alloc_parse()
> + * @vep: the V4L2 fwnode the resources of which are to be released
> + *
> + * It is safe to call this function with NULL argument or on a V4L2 fwno=
de the
> + * parsing of which failed.
> + */
> +void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vep);
> +
> +/**
> + * v4l2_fwnode_endpoint_alloc_parse() - parse all fwnode node properties
> + * @fwnode: pointer to the endpoint's fwnode handle
> + *
> + * All properties are optional. If none are found, we don't set any flag=
s. This
> + * means the port has a static configuration and no properties have to be
> + * specified explicitly. If any properties that identify the bus as para=
llel
> + * are found and slave-mode isn't set, we set V4L2_MBUS_MASTER. Similarl=
y, if
> + * we recognise the bus as serial CSI-2 and clock-noncontinuous isn't se=
t, we
> + * set the V4L2_MBUS_CSI2_CONTINUOUS_CLOCK flag. The caller should hold a
> + * reference to @fwnode.
> + *
> + * v4l2_fwnode_endpoint_alloc_parse() has two important differences to
> + * v4l2_fwnode_endpoint_parse():
> + *
> + * 1. It also parses variable size data.
> + *
> + * 2. The memory it has allocated to store the variable size data must b=
e freed
> + *    using v4l2_fwnode_endpoint_free() when no longer needed.
> + *
> + * Return: Pointer to v4l2_fwnode_endpoint if successful, on an error po=
inter
> + * on error.
> + */
>  struct v4l2_fwnode_endpoint *v4l2_fwnode_endpoint_alloc_parse(
>  	struct fwnode_handle *fwnode);
> -void v4l2_fwnode_endpoint_free(struct v4l2_fwnode_endpoint *vep);
> +
> +/**
> + * v4l2_fwnode_parse_link() - parse a link between two endpoints
> + * @fwnode: pointer to the endpoint's fwnode at the local end of the link
> + * @link: pointer to the V4L2 fwnode link data structure
> + *
> + * Fill the link structure with the local and remote nodes and port numb=
ers.
> + * The local_node and remote_node fields are set to point to the local a=
nd
> + * remote port's parent nodes respectively (the port parent node being t=
he
> + * parent node of the port node if that node isn't a 'ports' node, or the
> + * grand-parent node of the port node otherwise).
> + *
> + * A reference is taken to both the local and remote nodes, the caller m=
ust use
> + * v4l2_fwnode_put_link() to drop the references when done with the
> + * link.
> + *
> + * Return: 0 on success, or -ENOLINK if the remote endpoint fwnode can't=
 be
> + * found.
> + */
>  int v4l2_fwnode_parse_link(struct fwnode_handle *fwnode,
>  			   struct v4l2_fwnode_link *link);
> +
> +/**
> + * v4l2_fwnode_put_link() - drop references to nodes in a link
> + * @link: pointer to the V4L2 fwnode link data structure
> + *
> + * Drop references to the local and remote nodes in the link. This funct=
ion
> + * must be called on every link parsed with v4l2_fwnode_parse_link().
> + */
>  void v4l2_fwnode_put_link(struct v4l2_fwnode_link *link);
> =20
>  /**
> --=20
> 2.11.0
>=20

--xgtefgl3fj6vnjo7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAln2VgAACgkQ2O7X88g7
+ppB2BAAnPQGdoKVKIBv5HmX7ntijAlfMDNf99Ny0ue+TlbIx2R8332tUrMuPyHV
r/FmTIankEqD5nbjtPNKcwykFybu1v5ShS+15WSdHeel36MX5PnCBMX7a1B8raip
+zVpSn+kPkE6DGi7MqcLHLTh6JeEnU3lVcfMLlonMpSn58wsiLDBfe9zbIX8oo9n
CpU5k57R4isXR4GKHZddj34U/vUgXbLprAGAIpJvrG80scP4EwWvOS/egS/ljWFK
YpRHdBcaA/bS3ECm9yh/9ibB63YEaZdSDPIi9TtiwCr2Ii+BKipXsjcxIW5FGzQ6
9MKB4hcZSMPQgCgp/EqWSkDlLlxpeqdKdNOa2Eya3YHtGq+fljkp6mX2Npo50COw
vrv/umw07uzdigQbiNl1UT3v1cYjneQbaCt+a3/nzNa72Af2BGmJKa2U/Bl2D/7D
92fGKyazcm6Gl9KPXxvI29O/orS1yXRI6dZBNvRVjvvSKff+d6zQ7esIwJIbEbm/
zG8a9VcbmCUZFyyzjXkGFwKXvp8sv8t8b7CApYMkKuex3HH53Jr0RKWunPrcHASD
/iKUCTJ6e++GmQHvooKsSoDsK6rUgwyPOtdOv3nd2PkM3usxIywLfcLR3Nt/StSQ
tr3Mi4KAgcFKs8VYHYevXy7fdv+0Gm+Qkh+WSl5tMWTyDi3jWLI=
=2E5I
-----END PGP SIGNATURE-----

--xgtefgl3fj6vnjo7--
